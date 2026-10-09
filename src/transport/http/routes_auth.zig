//! Auth route group (BUSY-010/011; contract: docs/auth-contract.md §2):
//! POST /auth/login, GET /auth/me, POST /auth/logout.
//!
//! Reachable at the device tier only (no session needed to log in).
//! Login validates through the probe-verified path (report §4–§6):
//! company ensure → CheckIfLoginDetRequired → ValidUserPassword →
//! GetCompConfigJSON payload. `CheckIfLoginDetRequiredFromDatabase`
//! (UI trap) is never used. Provisional rights: the configured super
//! user gets {"all":true}, everyone else deny-all {} (contract §3).
const std = @import("std");
const json = @import("../../util/json.zig");
const ops = @import("../../handlers.zig");
const format = @import("../format.zig");
const envelope = @import("../envelope.zig");
const sh = @import("shared.zig");

const Allocator = std.mem.Allocator;
const Format = format.Format;
const ConnCtx = sh.ConnCtx;
const Route = sh.Route;

const eql = @import("../../util/helpers.zig").eql;
const win32 = @import("../../core/com/win32.zig");
const nowSecs = win32.unixSeconds;

pub fn routeAuth(
    ctx: ConnCtx,
    ralloc: Allocator,
    fmt: Format,
    verb: []const u8,
    path: []const u8,
    body: []const u8,
) !?Route {
    if (eql(path, "/auth/login")) {
        if (!eql(verb, "POST")) return null;
        return login(ctx, ralloc, fmt, body);
    }
    if (eql(path, "/auth/me")) {
        if (!eql(verb, "GET")) return null;
        return me(ctx, ralloc, fmt) catch |err| {
            return deny(ralloc, fmt, "500 Internal Server Error", "internal", @errorName(err));
        };
    }
    if (eql(path, "/auth/logout")) {
        if (!eql(verb, "POST")) return null;
        // Idempotent per contract: unknown/expired -> still 200.
        _ = ctx.us.revoke(ctx.user_token);
        return .{ .status = "200 OK", .content_type = sh.ctOf(fmt), .payload = try envelope.okWrap(ralloc, "status", &.{ .str = "logged-out" }) };
    }
    return null;
}

fn deny(alloc: Allocator, fmt: Format, status: []const u8, machine: []const u8, msg: []const u8) Route {
    return .{
        .status = status,
        .content_type = sh.ctOf(fmt),
        .payload = sh.errPayload(alloc, fmt, status[0..3], machine, msg) catch unreachable,
    };
}

fn helpers_err(err: anyerror) []const u8 {
    return switch (err) {
        error.OpenDbFailed => "busy_rejected",
        error.NoSuchMember => "no_such_member",
        error.NoBusyProgId => "busy_not_found",
        else => "internal",
    };
}

fn rightsOf(alloc: Allocator, is_super: bool) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    if (is_super) try ops.common.put(alloc, &e, "all", .{ .bool = true });
    return ops.common.objFrom(alloc, &e); // {} = deny-all provisional
}

fn login(ctx: ConnCtx, ralloc: Allocator, fmt: Format, body: []const u8) Route {
    var parsed = json.parse(ralloc, body) catch {
        return deny(ralloc, fmt, "400 Bad Request", "invalid_json", "body must be a JSON object");
    };
    if (parsed != .obj) return deny(ralloc, fmt, "400 Bad Request", "invalid_json", "body must be a JSON object");
    const username = parsed.get("username") orelse return deny(ralloc, fmt, "400 Bad Request", "bad_args", "missing \"username\"");
    const password = parsed.get("password") orelse return deny(ralloc, fmt, "400 Bad Request", "bad_args", "missing \"password\"");
    const comp = parsed.get("comp") orelse return deny(ralloc, fmt, "400 Bad Request", "bad_args", "missing \"comp\" (credential validation needs an open company; contract §2)");
    if (username.* != .str or username.str.len == 0)
        return deny(ralloc, fmt, "400 Bad Request", "bad_args", "\"username\" must be a non-empty string");
    if (password.* != .str)
        return deny(ralloc, fmt, "400 Bad Request", "bad_args", "\"password\" must be a string");
    if (comp.* != .str or comp.str.len == 0)
        return deny(ralloc, fmt, "400 Bad Request", "bad_args", "\"comp\" must be a non-empty string");
    const fy: i64 = if (parsed.get("fy")) |f| (if (f.* == .int) f.int else 0) else 0;

    // Company open (login owns its ensure — /auth is not in the
    // company-ensure path list; contract §5 "none (this is the gate)").
    ctx.sw.ensure(comp.str) catch |err| {
        if (err == error.CompanyNotFound)
            return deny(ralloc, fmt, "404 Not Found", "company_not_found", "unknown company (no <data>/<comp> directory)");
        const msg = if (ctx.sess.lastError().len > 0) ctx.sess.lastError() else @errorName(err);
        return deny(ralloc, fmt, "500 Internal Server Error", helpers_err(err), msg);
    };

    // CheckIfLoginDetRequired (verified): true for configured AND
    // unknown users — the password check below is the actual gate and
    // does not enumerate (contract §4). Errors surface; the bool is
    // informational for M1.
    _ = ops.auth.loginRequired(ctx.sess, username.str) catch |err| {
        const msg = if (ctx.sess.lastError().len > 0) ctx.sess.lastError() else @errorName(err);
        return deny(ralloc, fmt, "500 Internal Server Error", helpers_err(err), msg);
    };

    const valid = ops.auth.validatePassword(ctx.sess, username.str, password.str) catch |err| {
        const msg = if (ctx.sess.lastError().len > 0) ctx.sess.lastError() else @errorName(err);
        return deny(ralloc, fmt, "500 Internal Server Error", helpers_err(err), msg);
    };
    if (!valid) {
        // Identical response for wrong password and unknown user
        // (contract §4: no user enumeration).
        return deny(ralloc, fmt, "401 Unauthorized", "invalid_credentials", "invalid username or password");
    }

    const config = ops.auth.configPayload(ctx.sess, ralloc, fy) catch |err| {
        const msg = if (ctx.sess.lastError().len > 0) ctx.sess.lastError() else @errorName(err);
        return deny(ralloc, fmt, "500 Internal Server Error", helpers_err(err), msg);
    };

    const token = ctx.us.issue(username.str, comp.str, fy, nowSecs()) catch |err| {
        return deny(ralloc, fmt, "500 Internal Server Error", "internal", @errorName(err));
    };
    const is_super = eql(username.str, ctx.super_user);
    return loginResult(ralloc, fmt, token, username.str, comp.str, fy, is_super, config) catch |err| {
        return deny(ralloc, fmt, "500 Internal Server Error", "internal", @errorName(err));
    };
}

fn me(ctx: ConnCtx, ralloc: Allocator, fmt: Format) !Route {
    const e = ctx.us.verify(ctx.user_token, nowSecs()) orelse
        return deny(ralloc, fmt, "401 Unauthorized", "unauthorized", "valid user session required (POST /auth/login)");
    const is_super = eql(e.user, ctx.super_user);
    var ee: std.ArrayList(json.Value.Entry) = .empty;
    try ops.common.put(ralloc, &ee, "user", .{ .str = try ralloc.dupe(u8, e.user) });
    try ops.common.put(ralloc, &ee, "is_mobile_user", .{ .bool = false });
    try ops.common.put(ralloc, &ee, "company", .{ .str = try ralloc.dupe(u8, e.company) });
    try ops.common.put(ralloc, &ee, "fy", .{ .int = e.fy });
    try ops.common.put(ralloc, &ee, "rights", try rightsOf(ralloc, is_super));
    const result = try ops.common.objFrom(ralloc, &ee);
    return .{ .status = "200 OK", .content_type = sh.ctOf(fmt), .payload = try envelope.okWrap(ralloc, "result", &result) };
}

fn loginResult(
    alloc: Allocator,
    fmt: Format,
    token: []const u8,
    user: []const u8,
    company: []const u8,
    fy: i64,
    is_super: bool,
    config: json.Value,
) !Route {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    try ops.common.put(alloc, &e, "token", .{ .str = try alloc.dupe(u8, token) });
    try ops.common.put(alloc, &e, "user", .{ .str = try alloc.dupe(u8, user) });
    try ops.common.put(alloc, &e, "is_mobile_user", .{ .bool = false });
    try ops.common.put(alloc, &e, "company", .{ .str = try alloc.dupe(u8, company) });
    try ops.common.put(alloc, &e, "fy", .{ .int = fy });
    try ops.common.put(alloc, &e, "config", config);
    try ops.common.put(alloc, &e, "rights", try rightsOf(alloc, is_super));
    const result = try ops.common.objFrom(alloc, &e);
    return .{ .status = "200 OK", .content_type = sh.ctOf(fmt), .payload = try envelope.okWrap(alloc, "result", &result) };
}
