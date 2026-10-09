//! /v1 — versioned ERP resource facade (issue #7): resource-style paths
//! over the same `core/ops` as /op, plus opaque keyset cursors for lists.
//!
//! Additive to the raw tier and to /op (kept for unversioned compat);
//! one wire-envelope family across the bridge — v1 responses reuse the
//! `{"ok":true,"op":"v1/<resource>","result":{…}}` / `<Op>` shapes, with
//! list results carrying `page: {limit, has_more, next_cursor}`.
//!
//! Path grammar (after the /v1 prefix, split BEFORE percent-decoding, so
//! names may contain encoded '/' or spaces):
//!   GET    /v1                      surface index
//!   GET    /v1/accounts|items       list  (?limit= &cursor= &q=)
//!   GET    /v1/accounts|items/{name}       one by exact business name
//!   POST   /v1/accounts|items             create  (JSON body)
//!   PUT    /v1/accounts|items/{name}      update  (name from path wins)
//!   DELETE /v1/accounts|items/{name}      delete
//!   GET    /v1/vouchers             list  (?type= &limit= &cursor=)
//!   GET    /v1/vouchers/{code}      one by VchCode
//!   POST   /v1/vouchers             post  (JSON body)
//!   DELETE /v1/vouchers/{code}      delete
//!   GET    /v1/reports/{name}       named report (?from= &to= &…)
const std = @import("std");
const json = @import("../util/json.zig");
const busyc = @import("../core/com.zig");
const helpers = @import("../util/helpers.zig");
const ops = @import("../core/ops.zig");
const envelope = @import("envelope.zig");
const format = @import("format.zig");

const Allocator = std.mem.Allocator;
const eql = helpers.eql;
const urlDecode = helpers.urlDecode;

pub const Result = struct {
    status: []const u8,
    content_type: []const u8,
    payload: []u8,
};

const jct = format.ct_json;
const xct = format.ct_xml;

fn ctOf(fmt: format.Format) []const u8 {
    return switch (fmt) {
        .json => jct,
        .xml => xct,
    };
}

fn errResult(alloc: Allocator, fmt: format.Format, code: []const u8, machine: []const u8, msg: []const u8) !Result {
    const payload = switch (fmt) {
        .json => try envelope.errJsonText(alloc, machine, msg),
        .xml => try format.errorXml(alloc, code, machine, msg),
    };
    return .{ .status = statusOf(code), .content_type = ctOf(fmt), .payload = payload };
}

fn statusOf(code: []const u8) []const u8 {
    if (eql(code, "400")) return "400 Bad Request";
    if (eql(code, "404")) return "404 Not Found";
    if (eql(code, "422")) return "422 Unprocessable Entity";
    return "500 Internal Server Error";
}

/// Success envelope: same family as /op ("resource" key instead of "op").
fn okResult(alloc: Allocator, fmt: format.Format, resource: []const u8, v: *const json.Value) !Result {
    const payload = switch (fmt) {
        .json => try envelope.opJsonNamed(alloc, "resource", resource, v),
        .xml => try envelope.opXml(alloc, resource, v),
    };
    return .{ .status = "200 OK", .content_type = ctOf(fmt), .payload = payload };
}

/// op-error mapping (same contract as the /op routes): NotFound -> 404,
/// BadArgs -> 400, BusyRejected/BatchRolledBack -> 422; else 500.
fn errRoute(alloc: Allocator, fmt: format.Format, sess: *busyc.Session, err: anyerror) !Result {
    const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
    if (err == error.NotFound) return errResult(alloc, fmt, "404", "not_found", msg);
    if (err == error.BadArgs) return errResult(alloc, fmt, "400", "bad_args", msg);
    if (err == error.BusyRejected or err == error.BatchRolledBack) {
        var cb: [64]u8 = undefined;
        return errResult(alloc, fmt, "422", helpers.errCode(err, &cb), msg);
    }
    return errResult(alloc, fmt, "500", "invoke_failed", msg);
}

/// Percent-decoded query parameter lookup (arena-owned result).
fn qparam(alloc: Allocator, query: []const u8, name: []const u8) !?[]u8 {
    var it = std.mem.splitScalar(u8, query, '&');
    while (it.next()) |pair| {
        const eq = std.mem.indexOfScalar(u8, pair, '=') orelse continue;
        if (std.ascii.eqlIgnoreCase(pair[0..eq], name))
            return try urlDecode(alloc, pair[eq + 1 ..]);
    }
    return null;
}

/// Split `/accounts/Cash%20in%20hand` into `.{resource, key}` — split on
/// the FIRST '/' only (a key may itself contain encoded slashes).
/// Pure: unit-tested without BUSY.
pub fn splitPath(rest: []const u8) struct { resource: []const u8, key: ?[]const u8 } {
    var r = rest;
    if (r.len > 0 and r[0] == '/') r = r[1..];
    const slash = std.mem.indexOfScalar(u8, r, '/');
    if (slash) |i| return .{ .resource = r[0..i], .key = r[i + 1 ..] };
    return .{ .resource = r, .key = null };
}

test "splitPath splits resource and key once" {
    const t = std.testing;
    var p = splitPath("");
    try t.expectEqualStrings("", p.resource);
    try t.expect(p.key == null);
    p = splitPath("/accounts");
    try t.expectEqualStrings("accounts", p.resource);
    try t.expect(p.key == null);
    p = splitPath("/accounts/Cash%20in%20hand");
    try t.expectEqualStrings("accounts", p.resource);
    try t.expectEqualStrings("Cash%20in%20hand", p.key.?);
    // key containing an encoded slash stays one segment until decoding
    p = splitPath("/accounts/a%2Fb");
    try t.expectEqualStrings("accounts", p.resource);
    try t.expectEqualStrings("a%2Fb", p.key.?);
    p = splitPath("/reports/trial-balance");
    try t.expectEqualStrings("reports", p.resource);
    try t.expectEqualStrings("trial-balance", p.key.?);
}

/// `?limit=` for list routes: default 100, 0 = unlimited. Bad values set
/// the session error and return error.BadArgs (-> 400 bad_args).
fn listLimit(sess: *busyc.Session, alloc: Allocator, query: []const u8) !usize {
    const raw = (try qparam(alloc, query, "limit")) orelse return 100;
    return std.fmt.parseInt(usize, raw, 10) catch {
        sess.setErr("invalid limit (non-negative integer; 0 = unlimited)", .{});
        return error.BadArgs;
    };
}

/// Dispatch a /v1 request. Returns null when the path is not under /v1
/// (the caller 404s through the standard raw-tier envelope).
pub fn route(
    alloc: Allocator,
    sess: *busyc.Session,
    fmt: format.Format,
    verb: []const u8,
    path: []const u8,
    query: []const u8,
    body: []const u8,
) !?Result {
    if (!eql(path, "/v1") and !std.mem.startsWith(u8, path, "/v1/")) return null;
    return try routeInner(alloc, sess, fmt, verb, path, query, body);
}

fn routeInner(
    alloc: Allocator,
    sess: *busyc.Session,
    fmt: format.Format,
    verb: []const u8,
    path: []const u8,
    query: []const u8,
    body: []const u8,
) !Result {
    const rest = path["/v1".len..];

    // ---- surface index ----
    if ((rest.len == 0 or eql(rest, "/")) and eql(verb, "GET")) {
        var v: std.ArrayList(json.Value.Entry) = .empty;
        try ops.common.put(alloc, &v, "api", .{ .str = try alloc.dupe(u8, "busy-bridge/v1") });
        const resources = [_][]const u8{ "accounts", "items", "vouchers", "reports" };
        var arr: std.ArrayList(json.Value) = .empty;
        for (resources) |r| try arr.append(alloc, .{ .str = try alloc.dupe(u8, r) });
        try ops.common.put(alloc, &v, "resources", .{ .arr = try arr.toOwnedSlice(alloc) });
        const obj = try ops.common.objFrom(alloc, &v);
        return okResult(alloc, fmt, "v1/index", &obj);
    }

    const seg = splitPath(rest);
    const key: ?[]u8 = if (seg.key) |k| try urlDecode(alloc, k) else null;

    // ---- masters (accounts / items) ----
    if (eql(seg.resource, "accounts") or eql(seg.resource, "items")) {
        const kind: ops.masters.Kind = if (eql(seg.resource, "accounts")) .account else .item;
        if (key == null and eql(verb, "GET")) {
            const limit = listLimit(sess, alloc, query) catch |err|
                return errRoute(alloc, fmt, sess, err);
            const cursor = try qparam(alloc, query, "cursor");
            const q = try qparam(alloc, query, "q");
            const v = ops.masters.list(sess, alloc, kind, .{ .limit = limit, .q = q, .cursor = cursor }) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, if (kind == .account) "v1/accounts" else "v1/items", &v);
        }
        if (key != null and eql(verb, "GET")) {
            const v = ops.masters.get(sess, alloc, kind, key.?) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, if (kind == .account) "v1/account" else "v1/item", &v);
        }
        if (key == null and eql(verb, "POST")) {
            const parsed = json.parse(alloc, body) catch
                return errResult(alloc, fmt, "400", "invalid_json", "invalid JSON body");
            const op_name = if (kind == .account) "create-account" else "create-item";
            const v = ops.exec.run(sess, alloc, op_name, &parsed) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, if (kind == .account) "v1/account" else "v1/item", &v);
        }
        if (key != null and (eql(verb, "PUT") or eql(verb, "DELETE"))) {
            var ne: std.ArrayList(json.Value.Entry) = .empty;
            try ops.common.put(alloc, &ne, "name", .{ .str = try alloc.dupe(u8, key.?) });
            const name_obj = try ops.common.objFrom(alloc, &ne);
            const op_name_base: []const u8 = if (kind == .account) "account" else "item";
            if (eql(verb, "PUT")) {
                const parsed = json.parse(alloc, body) catch
                    return errResult(alloc, fmt, "400", "invalid_json", "invalid JSON body");
                const merged = ops.common.mergeRoot(alloc, &parsed, &name_obj) catch
                    return errResult(alloc, fmt, "400", "bad_args", "body must be a JSON object of string values");
                const op_name = try std.fmt.allocPrint(alloc, "update-{s}", .{op_name_base});
                defer alloc.free(op_name);
                const v = ops.exec.run(sess, alloc, op_name, &merged) catch |err|
                    return errRoute(alloc, fmt, sess, err);
                return okResult(alloc, fmt, if (kind == .account) "v1/account" else "v1/item", &v);
            }
            const op_name = try std.fmt.allocPrint(alloc, "delete-{s}", .{op_name_base});
            defer alloc.free(op_name);
            const v = ops.exec.run(sess, alloc, op_name, &name_obj) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, if (kind == .account) "v1/account" else "v1/item", &v);
        }
        return errResult(alloc, fmt, "404", "not_found", "unknown /v1 route (see GET /v1)");
    }

    // ---- vouchers ----
    if (eql(seg.resource, "vouchers")) {
        if (key == null and eql(verb, "GET")) {
            const limit = listLimit(sess, alloc, query) catch |err|
                return errRoute(alloc, fmt, sess, err);
            const cursor = try qparam(alloc, query, "cursor");
            const type_name = try qparam(alloc, query, "type");
            const v = ops.vouchers.list(sess, alloc, .{ .type_name = type_name, .limit = limit, .cursor = cursor }) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, "v1/vouchers", &v);
        }
        if (key != null and eql(verb, "GET")) {
            const code = std.fmt.parseInt(i64, key.?, 10) catch
                return errResult(alloc, fmt, "400", "bad_args", "invalid code (integer VchCode)");
            const v = ops.vouchers.get(sess, alloc, code) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, "v1/voucher", &v);
        }
        if (key == null and eql(verb, "POST")) {
            const parsed = json.parse(alloc, body) catch
                return errResult(alloc, fmt, "400", "invalid_json", "invalid JSON body");
            const v = ops.exec.run(sess, alloc, "post-voucher", &parsed) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, "v1/voucher", &v);
        }
        if (key != null and eql(verb, "DELETE")) {
            const code = std.fmt.parseInt(i64, key.?, 10) catch
                return errResult(alloc, fmt, "400", "bad_args", "invalid code (integer VchCode)");
            var ce: std.ArrayList(json.Value.Entry) = .empty;
            try ops.common.put(alloc, &ce, "code", .{ .int = code });
            const args_v = try ops.common.objFrom(alloc, &ce);
            const v = ops.exec.run(sess, alloc, "delete-voucher", &args_v) catch |err|
                return errRoute(alloc, fmt, sess, err);
            return okResult(alloc, fmt, "v1/voucher", &v);
        }
        return errResult(alloc, fmt, "404", "not_found", "unknown /v1 route (see GET /v1)");
    }

    // ---- named reports: args from query params ----
    if (eql(seg.resource, "reports")) {
        if (key == null or !eql(verb, "GET"))
            return errResult(alloc, fmt, "404", "not_found", "unknown /v1 route (see GET /v1)");
        var args: std.ArrayList(json.Value.Entry) = .empty;
        for ([_][]const u8{ "name", "group", "from", "to", "date", "item", "q" }) |p| {
            if (try qparam(alloc, query, p)) |val|
                try ops.common.put(alloc, &args, p, .{ .str = val });
        }
        if (try qparam(alloc, query, "limit")) |raw| {
            const n = std.fmt.parseInt(i64, raw, 10) catch {
                sess.setErr("invalid limit (non-negative integer; 0 = unlimited)", .{});
                return errRoute(alloc, fmt, sess, error.BadArgs);
            };
            try ops.common.put(alloc, &args, "limit", .{ .int = n });
        }
        const args_obj = try ops.common.objFrom(alloc, &args);
        const v = ops.reports.run(sess, alloc, key.?, &args_obj) catch |err|
            return errRoute(alloc, fmt, sess, err);
        const report_key = key.?;
        var res_name_buf: [64]u8 = undefined;
        const res_name = std.fmt.bufPrint(&res_name_buf, "v1/reports/{s}", .{report_key}) catch "v1/reports";
        return okResult(alloc, fmt, res_name, &v);
    }

    return errResult(alloc, fmt, "404", "not_found", "unknown /v1 route (see GET /v1)");
}
