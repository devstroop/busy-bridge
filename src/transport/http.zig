//! HTTP JSON/XML API (`serve`): request parsing, format negotiation, routing.
//!
//! Response format follows the Accept header (default JSON). Request bodies
//! are JSON by default; `Content-Type: application/xml` on POST /call makes
//! the body a raw BUSY XML document (method/type/modify in the query string).
//! GET /call?method=M&args=<urlencoded JSON array> is available for read
//! methods in either mode.
const std = @import("std");
const json = @import("../util/json.zig");
const xml = @import("../util/xml.zig");
const busyc = @import("../core/com.zig");
const helpers = @import("../util/helpers.zig");
const sqlguard = @import("../util/sqlguard.zig");
const cli_mod = @import("cli.zig");
const ops = @import("../core/ops.zig");
const registry = @import("../core/registry.zig");
const envelope = @import("envelope.zig");
const format = @import("format.zig");
const auth = @import("auth.zig");
const sessions = @import("sessions.zig");
const v1 = @import("v1.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;
const Format = format.Format;

const eql = helpers.eql;
const startsWithCi = helpers.startsWithCi;
const printOut = helpers.printOut;
const okWrap = envelope.okWrap;
const optsFrom = cli_mod.optsFrom;
const surfaceText = ops.surfaceText;
const listBusyClasses = registry.listBusyClasses;
const urlDecode = helpers.urlDecode;

var serve_body_buf: [8 * 1024 * 1024]u8 = undefined;

const ConnCtx = struct {
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

const Route = struct {
    status: []const u8,
    content_type: []const u8,
    payload: []u8,
};

fn respond(w: *Io.Writer, status: []const u8, content_type: []const u8, body: []const u8) !void {
    try w.print("HTTP/1.1 {s}\r\nContent-Type: {s}\r\nX-Content-Type-Options: nosniff\r\nContent-Length: {d}\r\nConnection: close\r\n\r\n", .{ status, content_type, body.len });
    try w.writeAll(body);
    try w.flush();
}

fn errPayload(alloc: Allocator, fmt: Format, code: []const u8, machine: []const u8, msg: []const u8) ![]u8 {
    return switch (fmt) {
        .json => envelope.errJsonText(alloc, machine, msg),
        .xml => format.errorXml(alloc, code, machine, msg),
    };
}

fn ctOf(fmt: Format) []const u8 {
    return switch (fmt) {
        .json => format.ct_json,
        .xml => format.ct_xml,
    };
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

fn badReq(alloc: Allocator, fmt: Format, machine: []const u8, msg: []const u8) Route {
    return .{
        .status = "400 Bad Request",
        .content_type = ctOf(fmt),
        .payload = errPayload(alloc, fmt, "400", machine, msg) catch unreachable,
    };
}

/// Guard refusal for POST /query (issue #3): the standard error envelope
/// with the stable machine code `query_not_allowed`.
fn denyQuery(alloc: Allocator, fmt: Format, msg: []const u8) Route {
    return .{
        .status = "403 Forbidden",
        .content_type = ctOf(fmt),
        .payload = errPayload(alloc, fmt, "403", "query_not_allowed", msg) catch unreachable,
    };
}

/// Operations facade success (issue #7): `{"ok":true,"op":…,"result":…}`
/// or `<Op><name>…</name><result>…</result></Op>` — same envelope as the
/// CLI `op` command.
fn opOk(alloc: Allocator, fmt: Format, op_name: []const u8, v: *const json.Value) !Route {
    const payload = switch (fmt) {
        .json => try envelope.opJson(alloc, op_name, v),
        .xml => try envelope.opXml(alloc, op_name, v),
    };
    return .{ .status = "200 OK", .content_type = ctOf(fmt), .payload = payload };
}

/// Map operation errors to routes: NotFound -> 404, BadArgs -> 400,
/// BusyRejected/BatchRolledBack -> 422 (BUSY's own verdict / rolled
/// back); anything else stays `null` so the caller propagates (-> 500).
fn opErr(alloc: Allocator, fmt: Format, sess: *busyc.Session, err: anyerror) !?Route {
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

fn route(
    ctx: ConnCtx,
    ralloc: Allocator,
    fmt: Format,
    verb: []const u8,
    path: []const u8,
    query: []const u8,
    body: []const u8,
    ctype: []const u8,
) !Route {
    const jct = format.ct_json;
    const xct = format.ct_xml;

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

    if (eql(verb, "GET") and eql(path, "/health")) {
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.healthXml(ralloc) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try okWrap(ralloc, "status", &.{ .str = "up" }) };
    }

    if (eql(verb, "GET") and eql(path, "/surface")) {
        const filter = try qparam(ralloc, query, "member");
        if (fmt == .xml) {
            const members = try ctx.sess.surface(ralloc);
            return .{
                .status = "200 OK",
                .content_type = xct,
                .payload = try format.surfaceXml(ralloc, ctx.prog_id, members, filter),
            };
        }
        return .{
            .status = "200 OK",
            .content_type = jct,
            .payload = try surfaceText(ctx.sess, ralloc, ctx.prog_id, filter),
        };
    }

    if (eql(verb, "GET") and eql(path, "/classes")) {
        const classes = try listBusyClasses(ralloc);
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.classesXml(ralloc, classes) };
        var out: std.ArrayList(u8) = .empty;
        var w = json.Writer{ .buf = &out, .alloc = ralloc };
        try w.raw("{\"ok\":true,\"classes\":[");
        for (classes, 0..) |c, i| {
            if (i != 0) try w.raw(",");
            try w.str(c);
        }
        try w.raw("]}");
        return .{ .status = "200 OK", .content_type = jct, .payload = try out.toOwnedSlice(ralloc) };
    }

    if (eql(verb, "GET") and eql(path, "/info")) {
        const active = ctx.sw.current orelse ctx.sw.opts.comp;
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.infoXml(ralloc, cli_mod.VERSION, ctx.prog_id, active, ctx.sw.switches) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try format.infoJson(ralloc, cli_mod.VERSION, ctx.prog_id, active, ctx.sw.switches) };
    }

    if (eql(verb, "GET") and eql(path, "/constants")) {
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.constantsXml(ralloc) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try format.constantsJson(ralloc) };
    }

    // ---- versioned ERP resource facade (issue #7): /v1 ----
    if (startsWithCi(path, "/v1")) {
        if (try v1.route(ralloc, ctx.sess, fmt, verb, path, query, body)) |r| {
            return .{ .status = r.status, .content_type = r.content_type, .payload = r.payload };
        }
    }

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
        return opOk(ralloc, fmt, "catalog", &v);
    }
    if (eql(verb, "GET") and eql(path, "/op/accounts") or (eql(verb, "GET") and eql(path, "/op/items"))) {
        const kind: ops.masters.Kind = if (eql(path, "/op/accounts")) .account else .item;
        const limit = blk: {
            if (try qparam(ralloc, query, "limit")) |raw|
                break :blk std.fmt.parseInt(usize, raw, 10) catch
                    return badReq(ralloc, fmt, "bad_args", "invalid limit (non-negative integer; 0 = unlimited)");
            break :blk @as(usize, 100);
        };
        const q = try qparam(ralloc, query, "q");
        const v = ops.masters.list(ctx.sess, ralloc, kind, .{ .limit = limit, .q = q }) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        const name = if (kind == .account) "list-accounts" else "list-items";
        return opOk(ralloc, fmt, name, &v);
    }
    if (eql(verb, "GET") and (eql(path, "/op/account") or eql(path, "/op/item"))) {
        const kind: ops.masters.Kind = if (eql(path, "/op/account")) .account else .item;
        const raw_name = (try qparam(ralloc, query, "name")) orelse
            return badReq(ralloc, fmt, "bad_args", "missing \"name\" (exact business name)");
        const v = ops.masters.get(ctx.sess, ralloc, kind, raw_name) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        const name = if (kind == .account) "get-account" else "get-item";
        return opOk(ralloc, fmt, name, &v);
    }
    if (eql(verb, "GET") and eql(path, "/op/vouchers")) {
        const limit = blk: {
            if (try qparam(ralloc, query, "limit")) |raw|
                break :blk std.fmt.parseInt(usize, raw, 10) catch
                    return badReq(ralloc, fmt, "bad_args", "invalid limit (non-negative integer; 0 = unlimited)");
            break :blk @as(usize, 100);
        };
        const type_name = try qparam(ralloc, query, "type");
        const v = ops.vouchers.list(ctx.sess, ralloc, .{ .type_name = type_name, .limit = limit }) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, "list-vouchers", &v);
    }
    if (eql(verb, "GET") and eql(path, "/op/voucher")) {
        const raw_code = (try qparam(ralloc, query, "code")) orelse
            return badReq(ralloc, fmt, "bad_args", "missing \"code\" (integer VchCode)");
        const code = std.fmt.parseInt(i64, raw_code, 10) catch
            return badReq(ralloc, fmt, "bad_args", "invalid \"code\" (integer VchCode)");
        const v = ops.vouchers.get(ctx.sess, ralloc, code) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, "get-voucher", &v);
    }

    // ---- M2 writes (issue #7): one exec dispatcher for CLI + HTTP ----
    if (eql(verb, "POST") and (eql(path, "/op/account") or eql(path, "/op/item"))) {
        const parsed = json.parse(ralloc, body) catch {
            return badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        const op_name = if (eql(path, "/op/account")) "create-account" else "create-item";
        const v = ops.exec.run(ctx.sess, ralloc, op_name, &parsed) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, op_name, &v);
    }
    if (eql(verb, "PUT") and (eql(path, "/op/account") or eql(path, "/op/item"))) {
        const raw_name = (try qparam(ralloc, query, "name")) orelse
            return badReq(ralloc, fmt, "bad_args", "missing \"name\" (the master to change)");
        const parsed = json.parse(ralloc, body) catch {
            return badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        // inject the positional key (it wins over "name" in the body)
        var ne: std.ArrayList(json.Value.Entry) = .empty;
        try ops.common.put(ralloc, &ne, "name", .{ .str = try ralloc.dupe(u8, raw_name) });
        const name_obj = try ops.common.objFrom(ralloc, &ne);
        const merged = ops.common.mergeRoot(ralloc, &parsed, &name_obj) catch {
            return badReq(ralloc, fmt, "bad_args", "body must be a JSON object of string values");
        };
        const op_name = if (eql(path, "/op/account")) "update-account" else "update-item";
        const v = ops.exec.run(ctx.sess, ralloc, op_name, &merged) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, op_name, &v);
    }
    if (eql(verb, "DELETE") and (eql(path, "/op/account") or eql(path, "/op/item"))) {
        const raw_name = (try qparam(ralloc, query, "name")) orelse
            return badReq(ralloc, fmt, "bad_args", "missing \"name\"");
        var ne: std.ArrayList(json.Value.Entry) = .empty;
        try ops.common.put(ralloc, &ne, "name", .{ .str = try ralloc.dupe(u8, raw_name) });
        const args_v = try ops.common.objFrom(ralloc, &ne);
        const op_name = if (eql(path, "/op/account")) "delete-account" else "delete-item";
        const v = ops.exec.run(ctx.sess, ralloc, op_name, &args_v) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, op_name, &v);
    }
    if (eql(verb, "POST") and eql(path, "/op/voucher")) {
        const parsed = json.parse(ralloc, body) catch {
            return badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        const v = ops.exec.run(ctx.sess, ralloc, "post-voucher", &parsed) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, "post-voucher", &v);
    }
    if (eql(verb, "DELETE") and eql(path, "/op/voucher")) {
        const raw_code = (try qparam(ralloc, query, "code")) orelse
            return badReq(ralloc, fmt, "bad_args", "missing \"code\" (integer VchCode)");
        const code = std.fmt.parseInt(i64, raw_code, 10) catch
            return badReq(ralloc, fmt, "bad_args", "invalid \"code\" (integer VchCode)");
        var ce: std.ArrayList(json.Value.Entry) = .empty;
        try ops.common.put(ralloc, &ce, "code", .{ .int = code });
        const args_v = try ops.common.objFrom(ralloc, &ce);
        const v = ops.exec.run(ctx.sess, ralloc, "delete-voucher", &args_v) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, "delete-voucher", &v);
    }
    if (eql(verb, "POST") and eql(path, "/op/batch")) {
        const parsed = json.parse(ralloc, body) catch {
            return badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        // accept a bare array or {"ops":[...]}
        var entries: json.Value = parsed;
        if (parsed == .obj) {
            if (parsed.get("ops")) |o| {
                if (o.* != .arr) return badReq(ralloc, fmt, "bad_args", "\"ops\" must be an array");
                entries = o.*;
            } else return badReq(ralloc, fmt, "bad_args", "body must be an array of entries or {\"ops\":[...]}");
        }
        if (entries != .arr) return badReq(ralloc, fmt, "bad_args", "body must be a JSON array of entries");
        const v = ops.batch.run(ctx.sess, ralloc, &entries) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, "batch", &v);
    }

    // ---- M3 named reports (issue #7): GET /op/report/<name>?params ----
    if (eql(verb, "GET") and std.mem.startsWith(u8, path, "/op/report/")) {
        const report = path["/op/report/".len..];
        if (report.len == 0)
            return badReq(ralloc, fmt, "bad_args", "missing report name (see GET /op)");
        var entries: std.ArrayList(json.Value.Entry) = .empty;
        const str_params = [_][]const u8{ "name", "group", "item", "from", "to", "date", "q" };
        for (str_params) |p| {
            if (try qparam(ralloc, query, p)) |v| try ops.common.put(ralloc, &entries, p, .{ .str = v });
        }
        if (try qparam(ralloc, query, "limit")) |raw| {
            const n = std.fmt.parseInt(i64, raw, 10) catch {
                entries.deinit(ralloc);
                return badReq(ralloc, fmt, "bad_args", "invalid limit (non-negative integer; 0 = unlimited)");
            };
            try ops.common.put(ralloc, &entries, "limit", .{ .int = n });
        }
        const args_v = try ops.common.objFrom(ralloc, &entries);
        const v = ops.reports.run(ctx.sess, ralloc, report, &args_v) catch |err| {
            if (try opErr(ralloc, fmt, ctx.sess, err)) |r| return r;
            return err;
        };
        return opOk(ralloc, fmt, report, &v);
    }

    if (eql(verb, "POST") and eql(path, "/query")) {
        // Guard first when the facility is off (issue #3): refuse before
        // parsing the body — the route is disabled, not malformed.
        if (ctx.query_mode == .off)
            return denyQuery(ralloc, fmt, "query disabled by --query-mode off");
        const parsed = json.parse(ralloc, body) catch {
            return badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
        };
        const sql_v = parsed.get("sql") orelse {
            return badReq(ralloc, fmt, "bad_args", "missing \"sql\"");
        };
        if (sql_v.* != .str) {
            return badReq(ralloc, fmt, "bad_args", "\"sql\" must be a string");
        }
        if (ctx.query_mode == .read_only) {
            sqlguard.check(.read_only, sql_v.str) catch {
                return denyQuery(ralloc, fmt, "read-only mode accepts only a single SELECT/WITH statement (no multi-statement SQL)");
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
        return .{ .status = "200 OK", .content_type = ctOf(fmt), .payload = payload };
    }

    if ((eql(verb, "GET") or eql(verb, "POST")) and eql(path, "/call")) {
        var method: []const u8 = "";
        var args: []json.Value = &.{};
        var raw_xml_body = false;

        if (eql(verb, "POST") and format.bodyIsXml(ctype)) {
            // raw BUSY document in the body; metadata in the query string
            const m = try qparam(ralloc, query, "method") orelse
                return badReq(ralloc, fmt, "bad_args", "missing method parameter");
            method = m;
            const ts = try qparam(ralloc, query, "type") orelse
                return badReq(ralloc, fmt, "bad_args", "missing type parameter (raw XML bodies need ?type=N)");
            const type_i = std.fmt.parseInt(i64, ts, 10) catch {
                return badReq(ralloc, fmt, "bad_args", "invalid type parameter");
            };
            _ = xml.parse(ralloc, body) catch {
                return badReq(ralloc, fmt, "invalid_xml_body", "invalid XML body");
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
            if (try qparam(ralloc, query, "modify")) |ms| {
                try list.append(ralloc, .{ .bool = std.mem.eql(u8, ms, "true") or std.mem.eql(u8, ms, "1") });
            }
            args = try list.toOwnedSlice(ralloc);
            raw_xml_body = true;
        } else if (eql(verb, "POST")) {
            const parsed = json.parse(ralloc, body) catch {
                return badReq(ralloc, fmt, "invalid_json", "invalid JSON body");
            };
            const mv = parsed.get("method") orelse {
                return badReq(ralloc, fmt, "bad_args", "missing \"method\"");
            };
            if (mv.* != .str) {
                return badReq(ralloc, fmt, "bad_args", "\"method\" must be a string");
            }
            method = mv.str;
            var args_v: json.Value = .{ .arr = &.{} };
            if (parsed.get("args")) |a| {
                if (a.* == .arr) args_v = a.*;
            }
            args = args_v.arr;
        } else {
            const m = try qparam(ralloc, query, "method") orelse
                return badReq(ralloc, fmt, "bad_args", "missing method parameter");
            method = m;
            if (try qparam(ralloc, query, "args")) |raw| {
                const parsed = json.parse(ralloc, raw) catch {
                    return badReq(ralloc, fmt, "bad_args", "invalid args (expected URL-encoded JSON array)");
                };
                if (parsed != .arr) {
                    return badReq(ralloc, fmt, "bad_args", "args must be a JSON array");
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
                return badReq(ralloc, fmt, mach, msg);
            };
        }

        var res = try ctx.sess.invoke(method, args);
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

    const addr = try Io.net.IpAddress.parse(host, port);
    var server = try addr.listen(io, .{});
    defer server.deinit(io);

    const mode_wire = if (guard.mode == .read_only) "read-only" else @tagName(guard.mode);
    const boot = try std.fmt.allocPrint(alloc,
        \\{{"ok":true,"listening":"{s}:{d}","prog_id":"{s}","company":"{s}","query_mode":"{s}","max_rows":{d},"auth":{s},"multi_company":true}}
        \\
    , .{ host, port, o.prog_id, o.comp orelse "(none)", mode_wire, guard.max_rows, if (token != null) "true" else "false" });
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
