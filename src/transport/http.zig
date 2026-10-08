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

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;
const Format = format.Format;

const eql = helpers.eql;
const startsWithCi = helpers.startsWithCi;
const printOut = helpers.printOut;
const okWrap = envelope.okWrap;
const optsFrom = cli_mod.optsFrom;
const openSession = ops.openSession;
const surfaceText = ops.surfaceText;
const listBusyClasses = registry.listBusyClasses;
const urlDecode = helpers.urlDecode;

var serve_body_buf: [8 * 1024 * 1024]u8 = undefined;

const ConnCtx = struct {
    io: Io,
    sess: *busyc.Session,
    prog_id: []const u8,
    comp: ?[]const u8,
    /// Query guard mode for POST /query (issue #3; serve default read-only).
    query_mode: sqlguard.Mode,
    /// Row cap for /query responses (0 = unlimited).
    max_rows: usize,
};

const Route = struct {
    status: []const u8,
    content_type: []const u8,
    payload: []u8,
};

fn respond(w: *Io.Writer, status: []const u8, content_type: []const u8, body: []const u8) !void {
    try w.print("HTTP/1.1 {s}\r\nContent-Type: {s}\r\nContent-Length: {d}\r\nConnection: close\r\n\r\n", .{ status, content_type, body.len });
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
        } else if (startsWithCi(line, "expect:")) {
            if (std.ascii.eqlIgnoreCase(std.mem.trim(u8, line["expect:".len..], " "), "100-continue"))
                expect_continue = true;
        }
    }
    const fmt = format.acceptFormat(accept_hdr);

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

    const r = route(ctx, ralloc, fmt, verb, path, query, body, ctype_hdr) catch |err| blk: {
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
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.infoXml(ralloc, cli_mod.VERSION, ctx.prog_id, ctx.comp) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try format.infoJson(ralloc, cli_mod.VERSION, ctx.prog_id, ctx.comp) };
    }

    if (eql(verb, "GET") and eql(path, "/constants")) {
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.constantsXml(ralloc) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try format.constantsJson(ralloc) };
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
        .payload = try errPayload(ralloc, fmt, "404", "not_found", "unknown route (see /health /info /constants /surface /classes /query /call)"),
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

    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    try openSession(&sess, o);

    const addr = try Io.net.IpAddress.parse(host, port);
    var server = try addr.listen(io, .{});
    defer server.deinit(io);

    const mode_wire = if (guard.mode == .read_only) "read-only" else @tagName(guard.mode);
    const boot = try std.fmt.allocPrint(alloc,
        \\{{"ok":true,"listening":"{s}:{d}","prog_id":"{s}","company":"{s}","query_mode":"{s}","max_rows":{d}}}
        \\
    , .{ host, port, o.prog_id, o.comp orelse "(none)", mode_wire, guard.max_rows });
    defer alloc.free(boot);
    try printOut(io, alloc, boot);

    const ctx = ConnCtx{
        .io = io,
        .sess = &sess,
        .prog_id = o.prog_id,
        .comp = o.comp,
        .query_mode = guard.mode,
        .max_rows = guard.max_rows,
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
