//! Operations route group (issue #11 phase 5): /op/* — the ERP facade
//! over HTTP (catalog, reads, writes, batch, named reports). Returns
//! null → caller falls through to the 404.
const std = @import("std");
const json = @import("../../util/json.zig");
const ops = @import("../../handlers.zig");
const sh = @import("shared.zig");

const Allocator = std.mem.Allocator;
const Format = @import("../format.zig").Format;
const ConnCtx = sh.ConnCtx;
const Route = sh.Route;

const eql = @import("../../util/helpers.zig").eql;

pub fn routeOps(
    ctx: ConnCtx,
    ralloc: Allocator,
    fmt: Format,
    verb: []const u8,
    path: []const u8,
    query: []const u8,
    body: []const u8,
) !?Route {
    // ---- operations facade (issue #7): normalized reads over raw COM ----
    if (eql(verb, "GET") and eql(path, "/op")) {
        var ops_arr: std.ArrayList(json.Value) = .empty;
        for (ops.catalog.all) |opn| {
            var e: std.ArrayList(json.Value.Entry) = .empty;
            try ops.common.put(ralloc, &e, "name", .{ .str = try ralloc.dupe(u8, opn.name) });
            try ops.common.put(ralloc, &e, "route", .{ .str = try ralloc.dupe(u8, opn.route) });
            try ops.common.put(ralloc, &e, "cli", .{ .str = try ralloc.dupe(u8, opn.cli) });
            try ops.common.put(ralloc, &e, "params", .{ .str = try ralloc.dupe(u8, opn.params) });
            try ops.common.put(ralloc, &e, "summary", .{ .str = try ralloc.dupe(u8, opn.summary) });
            try ops_arr.append(ralloc, try ops.common.objFrom(ralloc, &e));
        }
        var result: std.ArrayList(json.Value.Entry) = .empty;
        try ops.common.put(ralloc, &result, "operations", .{ .arr = try ops_arr.toOwnedSlice(ralloc) });
        const v = try ops.common.objFrom(ralloc, &result);
        return sh.opOk(ralloc, fmt, "catalog", &v);
    }
    // ---- master reads: GET /op/<kind>s (list) | GET /op/<kind>?name= ----
    // One arm for every routed kind (masters.kinds): plural = list, singular
    // = get. vouchers/reports/series and typos fall through to their arms.
    if (eql(verb, "GET") and std.mem.startsWith(u8, path, "/op/") and
        std.mem.indexOfScalar(u8, path["/op/".len..], '/') == null)
    {
        const seg = path["/op/".len..];
        if (ops.masters.kindPath(seg)) |kp| {
            if (kp.list) {
                const limit = blk: {
                    if (try sh.qparam(ralloc, query, "limit")) |raw|
                        break :blk std.fmt.parseInt(usize, raw, 10) catch
                            return sh.badReq(ralloc, fmt, "bad_args", "invalid limit (non-negative integer; 0 = unlimited)");
                    break :blk @as(usize, 100);
                };
                const q = try sh.qparam(ralloc, query, "q");
                const v = ops.masters.list(ctx.sess, ralloc, kp.kind, .{ .limit = limit, .q = q }) catch |err| {
                    if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
                    return err;
                };
                const name = try std.fmt.allocPrint(ralloc, "list-{s}", .{kp.plur});
                return sh.opOk(ralloc, fmt, name, &v);
            }
            const raw_name = (try sh.qparam(ralloc, query, "name")) orelse
                return sh.badReq(ralloc, fmt, "bad_args", "missing \"name\" (exact business name)");
            const v = ops.masters.get(ctx.sess, ralloc, kp.kind, raw_name) catch |err| {
                if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
                return err;
            };
            const name = try std.fmt.allocPrint(ralloc, "get-{s}", .{kp.sing});
            return sh.opOk(ralloc, fmt, name, &v);
        }
        if (eql(seg, "series")) {
            const limit = blk: {
                if (try sh.qparam(ralloc, query, "limit")) |raw|
                    break :blk std.fmt.parseInt(usize, raw, 10) catch
                        return sh.badReq(ralloc, fmt, "bad_args", "invalid limit (non-negative integer; 0 = unlimited)");
                break :blk @as(usize, 100);
            };
            const q = try sh.qparam(ralloc, query, "q");
            const type_name = try sh.qparam(ralloc, query, "type");
            const v = ops.masters.seriesList(ctx.sess, ralloc, .{ .limit = limit, .q = q, .type_name = type_name }) catch |err| {
                if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
                return err;
            };
            return sh.opOk(ralloc, fmt, "list-series", &v);
        }
    }
    if (eql(verb, "GET") and eql(path, "/op/vouchers")) {
        const limit = blk: {
            if (try sh.qparam(ralloc, query, "limit")) |raw|
                break :blk std.fmt.parseInt(usize, raw, 10) catch
                    return sh.badReq(ralloc, fmt, "bad_args", "invalid limit (non-negative integer; 0 = unlimited)");
            break :blk @as(usize, 100);
        };
        const type_name = try sh.qparam(ralloc, query, "type");
        const v = ops.vouchers.list(ctx.sess, ralloc, .{ .type_name = type_name, .limit = limit }) catch |err| {
            if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return sh.opOk(ralloc, fmt, "list-vouchers", &v);
    }
    if (eql(verb, "GET") and eql(path, "/op/voucher")) {
        const raw_code = (try sh.qparam(ralloc, query, "code")) orelse
            return sh.badReq(ralloc, fmt, "bad_args", "missing \"code\" (integer VchCode)");
        const code = std.fmt.parseInt(i64, raw_code, 10) catch
            return sh.badReq(ralloc, fmt, "bad_args", "invalid \"code\" (integer VchCode)");
        const v = ops.vouchers.get(ctx.sess, ralloc, code) catch |err| {
            if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return sh.opOk(ralloc, fmt, "get-voucher", &v);
    }

    // ---- M2 writes (issue #7 / WP2): one exec dispatcher for CLI + HTTP.
    // Every routed kind's SINGULAR path takes POST (create) / PUT (update,
    // ?name=) / DELETE (?name=) — the same shapes the CLI and /v1 build.
    // Plural write paths keep 404ing (catalog routes are singular);
    // vouchers/series/batch have no kindPath entry and fall to their arms.
    if (!eql(verb, "GET") and std.mem.startsWith(u8, path, "/op/") and
        std.mem.indexOfScalar(u8, path["/op/".len..], '/') == null)
    {
        const seg = path["/op/".len..];
        if (ops.masters.kindPath(seg)) |kp| {
            if (!kp.list) {
                if (eql(verb, "POST")) {
                    const parsed = json.parse(ralloc, body) catch {
                        return sh.badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
                    };
                    const op_name = try std.fmt.allocPrint(ralloc, "create-{s}", .{kp.sing});
                    const v = ops.exec.run(ctx.sess, ralloc, op_name, &parsed) catch |err| {
                        if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
                        return err;
                    };
                    return sh.opOk(ralloc, fmt, op_name, &v);
                }
                if (eql(verb, "PUT") or eql(verb, "DELETE")) {
                    const raw_name = (try sh.qparam(ralloc, query, "name")) orelse
                        return sh.badReq(ralloc, fmt, "bad_args", "missing \"name\" (the master to change)");
                    var ne: std.ArrayList(json.Value.Entry) = .empty;
                    try ops.common.put(ralloc, &ne, "name", .{ .str = try ralloc.dupe(u8, raw_name) });
                    const name_obj = try ops.common.objFrom(ralloc, &ne);
                    const args_v: json.Value = if (eql(verb, "PUT")) blk: {
                        const parsed = json.parse(ralloc, body) catch {
                            return sh.badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
                        };
                        // inject the positional key (it wins over "name" in the body)
                        break :blk ops.common.mergeRoot(ralloc, &parsed, &name_obj) catch {
                            return sh.badReq(ralloc, fmt, "bad_args", "body must be a JSON object of string values");
                        };
                    } else name_obj;
                    const op_name = try std.fmt.allocPrint(ralloc, "{s}-{s}", .{
                        if (eql(verb, "PUT")) "update" else "delete",
                        kp.sing,
                    });
                    const v = ops.exec.run(ctx.sess, ralloc, op_name, &args_v) catch |err| {
                        if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
                        return err;
                    };
                    return sh.opOk(ralloc, fmt, op_name, &v);
                }
            }
        }
    }
    if (eql(verb, "POST") and eql(path, "/op/voucher")) {
        const parsed = json.parse(ralloc, body) catch {
            return sh.badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        const v = ops.exec.run(ctx.sess, ralloc, "post-voucher", &parsed) catch |err| {
            if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return sh.opOk(ralloc, fmt, "post-voucher", &v);
    }
    if (eql(verb, "DELETE") and eql(path, "/op/voucher")) {
        const raw_code = (try sh.qparam(ralloc, query, "code")) orelse
            return sh.badReq(ralloc, fmt, "bad_args", "missing \"code\" (integer VchCode)");
        const code = std.fmt.parseInt(i64, raw_code, 10) catch
            return sh.badReq(ralloc, fmt, "bad_args", "invalid \"code\" (integer VchCode)");
        var ce: std.ArrayList(json.Value.Entry) = .empty;
        try ops.common.put(ralloc, &ce, "code", .{ .int = code });
        const args_v = try ops.common.objFrom(ralloc, &ce);
        const v = ops.exec.run(ctx.sess, ralloc, "delete-voucher", &args_v) catch |err| {
            if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return sh.opOk(ralloc, fmt, "delete-voucher", &v);
    }
    if (eql(verb, "POST") and eql(path, "/op/batch")) {
        const parsed = json.parse(ralloc, body) catch {
            return sh.badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        // accept a bare array or {"ops":[...]}
        var entries: json.Value = parsed;
        if (parsed == .obj) {
            if (parsed.get("ops")) |o| {
                if (o.* != .arr) return sh.badReq(ralloc, fmt, "bad_args", "\"ops\" must be an array");
                entries = o.*;
            } else return sh.badReq(ralloc, fmt, "bad_args", "body must be an array of entries or {\"ops\":[...]}");
        }
        if (entries != .arr) return sh.badReq(ralloc, fmt, "bad_args", "body must be a JSON array of entries");
        const v = ops.batch.run(ctx.sess, ralloc, &entries) catch |err| {
            if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return sh.opOk(ralloc, fmt, "batch", &v);
    }

    // ---- M3 named reports (issue #7): GET /op/report/<name>?params ----
    if (eql(verb, "GET") and std.mem.startsWith(u8, path, "/op/report/")) {
        const report = path["/op/report/".len..];
        if (report.len == 0)
            return sh.badReq(ralloc, fmt, "bad_args", "missing report name (see GET /op)");
        var entries: std.ArrayList(json.Value.Entry) = .empty;
        const str_params = [_][]const u8{ "name", "group", "item", "from", "to", "date", "q", "type", "party" };
        for (str_params) |p| {
            if (try sh.qparam(ralloc, query, p)) |v| try ops.common.put(ralloc, &entries, p, .{ .str = v });
        }
        if (try sh.qparam(ralloc, query, "limit")) |raw| {
            const n = std.fmt.parseInt(i64, raw, 10) catch {
                entries.deinit(ralloc);
                return sh.badReq(ralloc, fmt, "bad_args", "invalid limit (non-negative integer; 0 = unlimited)");
            };
            try ops.common.put(ralloc, &entries, "limit", .{ .int = n });
        }
        const args_v = try ops.common.objFrom(ralloc, &entries);
        // BUSY-012 report enforcement (contract §5): when the session
        // gate is armed, the named report must map to a granted repID
        // (unmapped reports fail closed for non-super users).
        if (ctx.require_session) {
            const se = ctx.session_entry orelse return .{
                .status = "401 Unauthorized",
                .content_type = sh.ctOf(fmt),
                .payload = try sh.errPayload(ralloc, fmt, "401", "unauthorized", "valid user session required (POST /auth/login)"),
            };
            const bits = ops.rights.RightsBits{ .all = se.rights_all, .mask = se.report_mask };
            if (!ops.rights.canViewReport(bits, report)) {
                return .{
                    .status = "403 Forbidden",
                    .content_type = sh.ctOf(fmt),
                    .payload = try sh.errPayload(ralloc, fmt, "403", "rights_denied", "report not permitted for this user (see GET /auth/me rights.reports)"),
                };
            }
        }
        const v = ops.reports.run(ctx.sess, ralloc, report, &args_v) catch |err| {
            if (try sh.opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return sh.opOk(ralloc, fmt, report, &v);
    }

    return null;
}
