//! Shared HTTP types + helpers (issue #11 phase 5): the ConnCtx request
//! context, the Route response triple, and the envelope/mapping helpers
//! every route module uses. `serve`/`handleConn`/auth stay in the parent
//! `../http.zig` dispatcher; route groups live in `routes_*.zig`.
const std = @import("std");
const json = @import("../../util/json.zig");
const busyc = @import("../../core/com.zig");
const helpers = @import("../../util/helpers.zig");
const sqlguard = @import("../../util/sqlguard.zig");
const cli_mod = @import("../cli.zig");
const envelope = @import("../envelope.zig");
const format = @import("../format.zig");
const sessions = @import("../sessions.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Format = format.Format;

pub const ConnCtx = struct {
    io: Io,
    sess: *busyc.Session,
    prog_id: []const u8,
    comp: ?[]const u8,
    /// Issue #5: swap-based multi-company session behind `sess`.
    sw: *sessions.Switcher,
    /// Per-request company override from the X-Company header ("" = none).
    company_hdr: []const u8 = "",
    /// Query guard mode for POST /query (issue #3; serve default read-only).
    query_mode: sqlguard.Mode,
    /// Row cap for /query responses (0 = unlimited).
    max_rows: usize,
    /// Issue #4 token gate: configured token, or null (loopback mode,
    /// gate disarmed - byte-identical pre-#4 behavior).
    token: ?[]const u8,
};

pub const Route = struct {
    status: []const u8,
    content_type: []const u8,
    payload: []u8,
};

pub fn errPayload(alloc: Allocator, fmt: Format, code: []const u8, machine: []const u8, msg: []const u8) ![]u8 {
    return switch (fmt) {
        .json => envelope.errJsonText(alloc, machine, msg),
        .xml => format.errorXml(alloc, code, machine, msg),
    };
}

pub fn ctOf(fmt: Format) []const u8 {
    return switch (fmt) {
        .json => format.ct_json,
        .xml => format.ct_xml,
    };
}

/// Percent-decoded query parameter lookup (arena-owned result).
pub fn qparam(alloc: Allocator, query: []const u8, name: []const u8) !?[]u8 {
    var it = std.mem.splitScalar(u8, query, '&');
    while (it.next()) |pair| {
        const eq = std.mem.indexOfScalar(u8, pair, '=') orelse continue;
        if (std.ascii.eqlIgnoreCase(pair[0..eq], name))
            return try helpers.urlDecode(alloc, pair[eq + 1 ..]);
    }
    return null;
}

pub fn badReq(alloc: Allocator, fmt: Format, machine: []const u8, msg: []const u8) Route {
    return .{
        .status = "400 Bad Request",
        .content_type = ctOf(fmt),
        .payload = errPayload(alloc, fmt, "400", machine, msg) catch unreachable,
    };
}

/// Guard refusal for POST /query (issue #3): the standard error envelope
/// with the stable machine code `query_not_allowed`.
pub fn denyQuery(alloc: Allocator, fmt: Format, msg: []const u8) Route {
    return .{
        .status = "403 Forbidden",
        .content_type = ctOf(fmt),
        .payload = errPayload(alloc, fmt, "403", "query_not_allowed", msg) catch unreachable,
    };
}

/// Operations facade success (issue #7): `{"ok":true,"op":…,"result":…}`
/// or `<Op><name>…</name><result>…</result></Op>` — same envelope as the
/// CLI `op` command. Returns `!?Route` so route groups can `return`
/// directly through their `!?Route` signature (payload coercion would
/// otherwise need `try` at every call site).
pub fn opOk(alloc: Allocator, fmt: Format, op_name: []const u8, v: *const json.Value) !?Route {
    const payload = switch (fmt) {
        .json => try envelope.opJson(alloc, op_name, v),
        .xml => try envelope.opXml(alloc, op_name, v),
    };
    return Route{ .status = "200 OK", .content_type = ctOf(fmt), .payload = payload };
}

/// Map operation errors to routes: NotFound -> 404, BadArgs -> 400,
/// BusyRejected/BatchRolledBack -> 422 (BUSY's own verdict / rolled
/// back); anything else stays `null` so the caller propagates (-> 500).
pub fn opErr(alloc: Allocator, fmt: Format, sess: *busyc.Session, err: anyerror) !?Route {
    const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
    if (err == error.NotFound)
        return .{ .status = "404 Not Found", .content_type = ctOf(fmt), .payload = try errPayload(alloc, fmt, "404", "not_found", msg) };
    if (err == error.BadArgs)
        return .{ .status = "400 Bad Request", .content_type = ctOf(fmt), .payload = try errPayload(alloc, fmt, "400", "bad_args", msg) };
    if (err == error.BusyRejected or err == error.BatchRolledBack) {
        var cb: [64]u8 = undefined;
        const mach = helpers.errCode(err, &cb);
        return .{ .status = "422 Unprocessable Entity", .content_type = ctOf(fmt), .payload = try errPayload(alloc, fmt, "422", mach, msg) };
    }
    return null;
}
