//! HTTP JSON/XML API (`serve`): request parsing, auth gate, connection
//! handling, and the ordered route dispatch (issue #11 phase 5 split):
//!   http/shared.zig        ConnCtx/Route + envelope/mapping helpers
//!   http/routes_meta.zig   /health /surface /classes /info /constants
//!   http/routes_ops.zig    /op/* (ERP facade)
//!   http/routes_raw.zig    /query /call (raw escape hatch)
//! The /v1 facade is its own module (v1.zig). Dispatch order is the
//! contract: company-ensure → meta → v1 → ops → raw → 404.
//!
//! Response format follows the Accept header (default JSON). Request bodies
//! are JSON by default; `Content-Type: application/xml` on POST /call makes
//! the body a raw BUSY XML document (method/type/modify in the query string).
//! GET /call?method=M&args=<urlencoded JSON array> is available for read
//! methods in either mode.
const std = @import("std");
const json = @import("../util/json.zig");
const busyc = @import("../core/com.zig");
const helpers = @import("../util/helpers.zig");
const sqlguard = @import("../util/sqlguard.zig");
const cli_mod = @import("cli.zig");
const ops = @import("../handlers.zig");
const envelope = @import("envelope.zig");
const format = @import("format.zig");
const auth = @import("auth.zig");
const sessions = @import("sessions.zig");
const user_sessions = @import("user_sessions.zig");
const win32 = @import("../core/com/win32.zig");
const v1 = @import("v1.zig");
const shared = @import("http/shared.zig");
const routes_auth = @import("http/routes_auth.zig");
const routes_meta = @import("http/routes_meta.zig");
const routes_ops = @import("http/routes_ops.zig");
const routes_raw = @import("http/routes_raw.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;
const Format = format.Format;
const ConnCtx = shared.ConnCtx;
const Route = shared.Route;

const eql = helpers.eql;
const startsWithCi = helpers.startsWithCi;
const printOut = helpers.printOut;
const optsFrom = cli_mod.optsFrom;
const errPayload = shared.errPayload;
const ctOf = shared.ctOf;
const qparam = shared.qparam;

var serve_body_buf: [8 * 1024 * 1024]u8 = undefined;

fn respond(w: *Io.Writer, status: []const u8, content_type: []const u8, body: []const u8) !void {
    try w.print("HTTP/1.1 {s}\r\nContent-Type: {s}\r\nX-Content-Type-Options: nosniff\r\nContent-Length: {d}\r\nConnection: close\r\n\r\n", .{ status, content_type, body.len });
    try w.writeAll(body);
    try w.flush();
}

fn handleConn(ctx: ConnCtx, alloc: Allocator, stream: *Io.net.Stream) !void {
    var rbuf: [16384]u8 = undefined;
    var rd = stream.reader(ctx.io, &rbuf);

    const first = (try rd.interface.takeDelimiter('\n')) orelse return;
    var toks = std.mem.tokenizeScalar(u8, std.mem.trim(u8, first, " \t\r"), ' ');
    const verb = toks.next() orelse return;
    const target = toks.next() orelse return;
    const qmark = std.mem.indexOfScalar(u8, target, '?');
    const path = if (qmark) |i| target[0..i] else target;
    const query = if (qmark) |i| target[i + 1 ..] else "";

    var content_length: usize = 0;
    var expect_continue = false;
    var accept_hdr: []const u8 = "";
    var ctype_hdr: []const u8 = "";
    var auth_hdr: []const u8 = "";
    var xtok_hdr: []const u8 = "";
    var xcompany_hdr: []const u8 = "";
    while (true) {
        const l = (try rd.interface.takeDelimiter('\n')) orelse break;
        const line = std.mem.trim(u8, l, " \t\r");
        if (line.len == 0) break;
        if (startsWithCi(line, "content-length:")) {
            content_length = std.fmt.parseInt(usize, std.mem.trim(u8, line["content-length:".len..], " "), 10) catch 0;
        } else if (startsWithCi(line, "accept:")) {
            accept_hdr = std.mem.trim(u8, line["accept:".len..], " ");
        } else if (startsWithCi(line, "content-type:")) {
            ctype_hdr = std.mem.trim(u8, line["content-type:".len..], " ");
        } else if (startsWithCi(line, "authorization:")) {
            auth_hdr = std.mem.trim(u8, line["authorization:".len..], " ");
        } else if (startsWithCi(line, "x-bridge-token:")) {
            xtok_hdr = std.mem.trim(u8, line["x-bridge-token:".len..], " ");
        } else if (startsWithCi(line, "x-company:")) {
            xcompany_hdr = std.mem.trim(u8, line["x-company:".len..], " ");
        } else if (startsWithCi(line, "expect:")) {
            if (std.ascii.eqlIgnoreCase(std.mem.trim(u8, line["expect:".len..], " "), "100-continue"))
                expect_continue = true;
        }
    }
    const fmt = format.acceptFormat(accept_hdr);

    // Issue #4: token gate before 100-continue, body, or routing. Armed
    // only when a token is configured; /info exempt (issue decision),
    // everything else - /health, 404s, all routes - requires it.
    if (!auth.authorized(ctx.token, path, auth_hdr, xtok_hdr)) {
        var wbuf: [1024]u8 = undefined;
        var cw = stream.writer(ctx.io, &wbuf);
        const p = errPayload(alloc, fmt, "401", "unauthorized", "missing or invalid token (send Authorization: Bearer <token> or X-Bridge-Token: <token>)") catch return;
        defer alloc.free(p);
        respond(&cw.interface, "401 Unauthorized", ctOf(fmt), p) catch {};
        return;
    }

    if (expect_continue) {
        var wbuf: [256]u8 = undefined;
        var cw = stream.writer(ctx.io, &wbuf);
        try cw.interface.writeAll("HTTP/1.1 100 Continue\r\n\r\n");
        try cw.interface.flush();
    }
    if (content_length > serve_body_buf.len) {
        var wbuf: [1024]u8 = undefined;
        var w2 = stream.writer(ctx.io, &wbuf);
        const p = errPayload(alloc, fmt, "413", "payload_too_large", "body too large") catch return;
        defer alloc.free(p);
        respond(&w2.interface, "413 Payload Too Large", ctOf(fmt), p) catch {};
        return;
    }
    const body = serve_body_buf[0..content_length];
    if (content_length > 0) try rd.interface.readSliceAll(body);

    // ---- route ----
    var req_arena = std.heap.ArenaAllocator.init(alloc);
    defer req_arena.deinit();
    const ralloc = req_arena.allocator();

    var rctx = ctx;
    rctx.company_hdr = xcompany_hdr;
    rctx.user_token = auth.bearerOf(auth_hdr) orelse "";
    const r = route(rctx, ralloc, fmt, verb, path, query, body, ctype_hdr) catch |err| blk: {
        var cb: [64]u8 = undefined;
        const msg = if (ctx.sess.lastError().len > 0) ctx.sess.lastError() else @errorName(err);
        break :blk Route{
            .status = "500 Internal Server Error",
            .content_type = ctOf(fmt),
            .payload = try errPayload(ralloc, fmt, "500", helpers.errCode(err, &cb), msg),
        };
    };
    var wbuf: [16384]u8 = undefined;
    var w = stream.writer(ctx.io, &wbuf);
    respond(&w.interface, r.status, r.content_type, r.payload) catch |err| {
        std.debug.print("respond failed: {t}\n", .{err});
    };
}

/// Ordered dispatch — the contract (issue #11 phase 5): company-ensure,
/// meta, /v1, /op, raw, 404. Each group returns null to fall through.
fn route(
    ctx_in: ConnCtx,
    ralloc: Allocator,
    fmt: Format,
    verb: []const u8,
    path: []const u8,
    query: []const u8,
    body: []const u8,
    ctype: []const u8,
) !Route {
    var ctx = ctx_in; // per-request copy (session_entry stash below)
    // Company selection (issue #5): company-scoped routes honor ?comp=
    // (query, wins) or X-Company (header); default = the serve --comp.
    // Swap happens here - one company open at a time (BUSY COM state is
    // process-global, first-open-wins; see sessions.zig header comment).
    if (eql(path, "/query") or eql(path, "/call") or startsWithCi(path, "/op") or startsWithCi(path, "/v1")) {
        const sel: ?[]const u8 = blk: {
            if (try qparam(ralloc, query, "comp")) |c| break :blk c;
            if (ctx.company_hdr.len > 0) break :blk ctx.company_hdr;
            break :blk null;
        };
        ctx.sw.ensure(sel) catch |err| {
            if (err == error.CompanyNotFound)
                return .{
                    .status = "404 Not Found",
                    .content_type = ctOf(fmt),
                    .payload = try errPayload(ralloc, fmt, "404", "company_not_found", "unknown company (no <data>/<comp> directory; see GET /info)"),
                };
            return err;
        };
    }

    // Session gate (contract §5, provisional enforcement): when armed,
    // the facade surfaces need a valid user session. Raw /call /query
    // stay device-tier until BUSY-013 decides the operator boundary.
    if (ctx.require_session and (startsWithCi(path, "/v1") or startsWithCi(path, "/op"))) {
        if (ctx.us.verify(ctx.user_token, win32.unixSeconds())) |se| {
            ctx.session_entry = se; // BUSY-012 report gating reads this
        } else {
            return .{
                .status = "401 Unauthorized",
                .content_type = ctOf(fmt),
                .payload = try errPayload(ralloc, fmt, "401", "unauthorized", "valid user session required (POST /auth/login; serve runs with --require-session)"),
            };
        }
    }

    // Auth endpoints (BUSY-010/011): before meta — identity precedes
    // capability discovery, and login must not depend on /info wiring.
    if (startsWithCi(path, "/auth")) {
        if (try routes_auth.routeAuth(ctx, ralloc, fmt, verb, path, body)) |r| return r;
    }

    if (try routes_meta.routeMeta(ctx, ralloc, fmt, verb, path, query)) |r| return r;

    // ---- versioned ERP resource facade (issue #7): /v1 ----
    if (startsWithCi(path, "/v1")) {
        if (try v1.route(ralloc, ctx.sess, fmt, verb, path, query, body, ctx.session_entry, ctx.require_session)) |r| {
            return .{ .status = r.status, .content_type = r.content_type, .payload = r.payload };
        }
    }

    if (try routes_ops.routeOps(ctx, ralloc, fmt, verb, path, query, body)) |r| return r;
    if (try routes_raw.routeRaw(ctx, ralloc, fmt, verb, path, query, body, ctype)) |r| return r;

    return .{
        .status = "404 Not Found",
        .content_type = ctOf(fmt),
        .payload = try errPayload(ralloc, fmt, "404", "not_found", "unknown route (see /health /info /constants /surface /classes /query /call /op /v1)"),
    };
}

/// The `serve` command: open the session once, then accept loop.
/// Response format is per-request (Accept header), not --out.
pub fn serve(io: Io, alloc: Allocator, cli: Cli) !u8 {
    // Query guard flags (issue #3) parse first — fail fast, no COM needed.
    const guard = cli_mod.guardFrom(cli, "read-only") catch |err| {
        const msg = switch (err) {
            error.BadQueryMode => "invalid --query-mode (use full, read-only, off)",
            error.BadMaxRows => "invalid --max-rows (non-negative integer; 0 = unlimited)",
        };
        const t = envelope.errJsonText(alloc, "bad_args", msg) catch return 1;
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    const o = optsFrom(cli) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NoBusyProgId) "busy_not_found" else helpers.errCode(err, &cb);
        const m = if (err == error.NoBusyProgId)
            "no registered Busy2L*.CFixedInterface found - is BUSY installed? (or pass --prog-id)"
        else
            @errorName(err);
        const t = envelope.errJsonText(alloc, mach, m) catch return 1;
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    const host = cli.getOr("--host", "127.0.0.1");
    const port = std.fmt.parseInt(u16, cli.getOr("--port", "9820"), 10) catch cli_mod.DEFAULT_PORT;
    // Token & exposure policy (issue #4): --token wins, BUSY_BRIDGE_TOKEN
    // fallback; refuse a non-loopback bind with no token before COM opens.
    var token_env: ?[]u8 = null;
    defer if (token_env) |tv| alloc.free(tv);
    const token: ?[]const u8 = if (cli.get("--token")) |tf|
        (if (tf.len == 0) null else tf)
    else blk: {
        const own_env: std.process.Environ = .{ .block = .global };
        const v = own_env.getAlloc(alloc, "BUSY_BRIDGE_TOKEN") catch |e| switch (e) {
            error.EnvironmentVariableMissing => break :blk null,
            else => return e,
        };
        if (v.len == 0) {
            alloc.free(v);
            break :blk null;
        }
        token_env = v;
        break :blk v;
    };
    if (!auth.bindAllowed(token, host)) {
        const msg = try std.fmt.allocPrint(alloc, "refusing to bind non-loopback host '{s}' without a token: pass --token <t> or set BUSY_BRIDGE_TOKEN (see README, Security)", .{host});
        defer alloc.free(msg);
        const etext = envelope.errJsonText(alloc, "token_required", msg) catch return 1;
        defer alloc.free(etext);
        try printOut(io, alloc, etext);
        try printOut(io, alloc, "\n");
        return 1;
    }

    var sw = try sessions.Switcher.init(alloc, io, o);
    defer sw.deinit();

    // User sessions (BUSY-010): --require-session arms the /v1+/op
    // session gate (contract §5; auth_mode in /info + boot line).
    // --super-user selects the provisional full-rights identity.
    var us = user_sessions.UserSessions.init(alloc);
    defer us.deinit();
    if (cli.get("--session-idle-ttl")) |t| {
        us.idle_ttl = std.fmt.parseInt(i64, t, 10) catch {
            const et = envelope.errJsonText(alloc, "bad_args", "invalid --session-idle-ttl (seconds)") catch return 1;
            defer alloc.free(et);
            try printOut(io, alloc, et);
            try printOut(io, alloc, "\n");
            return 1;
        };
    }
    if (cli.get("--session-abs-ttl")) |t| {
        us.abs_ttl = std.fmt.parseInt(i64, t, 10) catch {
            const et = envelope.errJsonText(alloc, "bad_args", "invalid --session-abs-ttl (seconds)") catch return 1;
            defer alloc.free(et);
            try printOut(io, alloc, et);
            try printOut(io, alloc, "\n");
            return 1;
        };
    }
    const require_session = cli.flag("--require-session");
    const super_user = cli.getOr("--super-user", "Admin");

    const addr = try Io.net.IpAddress.parse(host, port);
    var server = try addr.listen(io, .{});
    defer server.deinit(io);

    const mode_wire = if (guard.mode == .read_only) "read-only" else @tagName(guard.mode);
    const auth_mode = if (require_session) "session" else if (token != null) "token" else "off";
    const boot = try std.fmt.allocPrint(alloc,
        \\{{"ok":true,"listening":"{s}:{d}","prog_id":"{s}","company":"{s}","query_mode":"{s}","max_rows":{d},"auth":{s},"auth_mode":"{s}","multi_company":true}}
        \\
    , .{ host, port, o.prog_id, o.comp orelse "(none)", mode_wire, guard.max_rows, if (token != null) "true" else "false", auth_mode });
    defer alloc.free(boot);
    try printOut(io, alloc, boot);

    const ctx = ConnCtx{
        .io = io,
        .sess = &sw.sess,
        .prog_id = o.prog_id,
        .comp = o.comp,
        .sw = &sw,
        .query_mode = guard.mode,
        .max_rows = guard.max_rows,
        .token = token,
        .us = &us,
        .super_user = super_user,
        .require_session = require_session,
    };
    while (true) {
        var stream = server.accept(io) catch |err| {
            std.debug.print("accept failed: {t}\n", .{err});
            break;
        };
        defer stream.close(io);
        handleConn(ctx, alloc, &stream) catch |err| {
            std.debug.print("conn error: {t}\n", .{err});
        };
    }
    return 0;
}
