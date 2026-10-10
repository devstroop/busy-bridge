//! Raw route group (issue #11 phase 5): POST /query (guarded SQL) and
//! GET|POST /call (any COM method) — the raw escape hatch over HTTP.
//! Returns null → caller tries the next group.
const std = @import("std");
const json = @import("../../util/json.zig");
const xml = @import("../../util/xml.zig");
const busyc = @import("../../core/com.zig");
const helpers = @import("../../util/helpers.zig");
const sqlguard = @import("../../util/sqlguard.zig");
const envelope = @import("../envelope.zig");
const format = @import("../format.zig");
const sh = @import("shared.zig");

const Allocator = std.mem.Allocator;
const Format = format.Format;
const ConnCtx = sh.ConnCtx;
const Route = sh.Route;

const eql = helpers.eql;

pub fn routeRaw(
    ctx: ConnCtx,
    ralloc: Allocator,
    fmt: Format,
    verb: []const u8,
    path: []const u8,
    query: []const u8,
    body: []const u8,
    ctype: []const u8,
) !?Route {
    const jct = format.ct_json;
    const xct = format.ct_xml;

    if (eql(verb, "POST") and eql(path, "/query")) {
        // Guard first when the facility is off (issue #3): refuse before
        // parsing the body — the route is disabled, not malformed.
        if (ctx.query_mode == .off)
            return sh.denyQuery(ralloc, fmt, "query disabled by --query-mode off");
        const parsed = json.parse(ralloc, body) catch {
            return sh.badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        const sql_v = parsed.get("sql") orelse {
            return sh.badReq(ralloc, fmt, "bad_args", "missing \"sql\"");
        };
        if (sql_v.* != .str) {
            return sh.badReq(ralloc, fmt, "bad_args", "\"sql\" must be a string");
        }
        if (ctx.query_mode == .read_only) {
            sqlguard.check(.read_only, sql_v.str) catch {
                return sh.denyQuery(ralloc, fmt, "read-only mode accepts only a single SELECT/WITH statement (no multi-statement SQL)");
            };
        }
        const rows = try ctx.sess.queryToJson(sql_v.str);
        var rows_mut = rows;
        defer rows_mut.deinit(ctx.sess.alloc);
        const payload = switch (fmt) {
            .json => try envelope.rowsJson(ralloc, &rows_mut, ctx.max_rows),
            .xml => blk: {
                // Legacy SC=1 rowset carries no truncation marker — the cap
                // still applies; JSON is the truncation-aware mode.
                const view = envelope.rowView(&rows_mut, ctx.max_rows);
                break :blk try format.rowsXml(ralloc, &view);
            },
        };
        return .{ .status = "200 OK", .content_type = sh.ctOf(fmt), .payload = payload };
    }

    if ((eql(verb, "GET") or eql(verb, "POST")) and eql(path, "/call")) {
        var method: []const u8 = "";
        var args: []json.Value = &.{};
        var raw_xml_body = false;

        if (eql(verb, "POST") and format.bodyIsXml(ctype)) {
            // raw BUSY document in the body; metadata in the query string
            const m = try sh.qparam(ralloc, query, "method") orelse
                return sh.badReq(ralloc, fmt, "bad_args", "missing method parameter");
            method = m;
            const ts = try sh.qparam(ralloc, query, "type") orelse
                return sh.badReq(ralloc, fmt, "bad_args", "missing type parameter (raw XML bodies need ?type=N)");
            const type_i = std.fmt.parseInt(i64, ts, 10) catch {
                return sh.badReq(ralloc, fmt, "bad_args", "invalid type parameter");
            };
            _ = xml.parse(ralloc, body) catch {
                return sh.badReq(ralloc, fmt, "invalid_xml_body", "invalid XML body");
            };
            var list: std.ArrayList(json.Value) = .empty;
            try list.append(ralloc, .{ .int = type_i });
            try list.append(ralloc, .{ .str = try ralloc.dupe(u8, body) });
            const byref_entries = try ralloc.alloc(json.Value.Entry, 1);
            byref_entries[0] = .{
                .key = try ralloc.dupe(u8, "$byref"),
                .val = .{ .str = try ralloc.dupe(u8, "") },
            };
            try list.append(ralloc, .{ .obj = byref_entries });
            if (try sh.qparam(ralloc, query, "modify")) |ms| {
                try list.append(ralloc, .{ .bool = std.mem.eql(u8, ms, "true") or std.mem.eql(u8, ms, "1") });
            }
            args = try list.toOwnedSlice(ralloc);
            raw_xml_body = true;
        } else if (eql(verb, "POST")) {
            const parsed = json.parse(ralloc, body) catch {
                return sh.badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
            };
            const mv = parsed.get("method") orelse {
                return sh.badReq(ralloc, fmt, "bad_args", "missing \"method\"");
            };
            if (mv.* != .str) {
                return sh.badReq(ralloc, fmt, "bad_args", "\"method\" must be a string");
            }
            method = mv.str;
            var args_v: json.Value = .{ .arr = &.{} };
            if (parsed.get("args")) |a| {
                if (a.* == .arr) args_v = a.*;
            }
            args = args_v.arr;
        } else {
            const m = try sh.qparam(ralloc, query, "method") orelse
                return sh.badReq(ralloc, fmt, "bad_args", "missing method parameter");
            method = m;
            if (try sh.qparam(ralloc, query, "args")) |raw| {
                const parsed = json.parse(ralloc, raw) catch {
                    return sh.badReq(ralloc, fmt, "bad_args", "invalid args (expected URL-encoded JSON array)");
                };
                if (parsed != .arr) {
                    return sh.badReq(ralloc, fmt, "bad_args", "args must be a JSON array");
                }
                args = parsed.arr;
            }
        }

        if (!raw_xml_body) {
            // JSON-object XML arguments become real XML before the COM call.
            format.xmlifyArgsInPlace(ralloc, method, args) catch |err| {
                var cb: [64]u8 = undefined;
                const mach = if (err == error.BadDocument) "xml_arg_invalid" else helpers.errCode(err, &cb);
                const msg = if (err == error.BadDocument)
                    "xml argument must be a single-key document object like {\"Root\":{...}}"
                else
                    @errorName(err);
                return sh.badReq(ralloc, fmt, mach, msg);
            };
        }

        // Collection read-back (BUSY-004/012): ?enumerate_ret=1 walks a
        // VT_DISPATCH return through the VB6 Collection contract.
        const enum_ret = (try sh.qparam(ralloc, query, "enumerate_ret")) != null;
        var res = try ctx.sess.invokeEx(method, args, .{ .enumerate_ret = enum_ret });
        defer res.deinit(ctx.sess.alloc);

        if (fmt == .xml) {
            if (format.isPassthrough(method, &res)) {
                return .{
                    .status = "200 OK",
                    .content_type = xct,
                    .payload = try ralloc.dupe(u8, res.ret.str),
                };
            }
            return .{
                .status = "200 OK",
                .content_type = xct,
                .payload = try format.callXml(ralloc, method, &res),
            };
        }
        // JSON mode: xml-out results become structured trees, never blobs.
        // Enrich with the session allocator — the deferred res.deinit below
        // frees through it (arena memory must not be freed by the gpa).
        format.enrichCallResult(ctx.sess.alloc, method, &res) catch {};
        var out: std.ArrayList(u8) = .empty;
        var w = json.Writer{ .buf = &out, .alloc = ralloc };
        try w.raw("{\"ok\":true,\"result\":");
        try json.stringify(&res.ret, &w);
        try w.raw(",\"outs\":");
        var outs_v = json.Value{ .arr = res.outs };
        try json.stringify(&outs_v, &w);
        try w.raw("}");
        return .{ .status = "200 OK", .content_type = jct, .payload = try out.toOwnedSlice(ralloc) };
    }

    return null;
}
