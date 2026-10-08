//! HTTP JSON API (`serve` command): request parsing, routing, responses.
const std = @import("std");
const json = @import("../util/json.zig");
const busyc = @import("../core/com.zig");
const helpers = @import("../util/helpers.zig");
const cli_mod = @import("cli.zig");
const ops = @import("../core/ops.zig");
const registry = @import("../core/registry.zig");
const envelope = @import("envelope.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;

const eql = helpers.eql;
const startsWithCi = helpers.startsWithCi;
const printOut = helpers.printOut;
const errJsonText = envelope.errJsonText;
const okWrap = envelope.okWrap;
const optsFrom = cli_mod.optsFrom;
const openSession = ops.openSession;
const surfaceText = ops.surfaceText;
const listBusyClasses = registry.listBusyClasses;

var serve_body_buf: [8 * 1024 * 1024]u8 = undefined;

const ConnCtx = struct {
    io: Io,
    sess: *busyc.Session,
    prog_id: []const u8,
};

fn respond(w: *Io.Writer, status: []const u8, body: []const u8) !void {
    try w.print("HTTP/1.1 {s}\r\nContent-Type: application/json\r\nContent-Length: {d}\r\nConnection: close\r\n\r\n", .{ status, body.len });
    try w.writeAll(body);
    try w.flush();
}

fn handleConn(ctx: ConnCtx, alloc: Allocator, stream: *Io.net.Stream) !void {
    var rbuf: [16384]u8 = undefined;
    var rd = stream.reader(ctx.io, &rbuf);

    const first = (try rd.interface.takeDelimiter('\n')) orelse return;
    var toks = std.mem.tokenizeScalar(u8, std.mem.trim(u8, first, " \t\r"), ' ');
    const method = toks.next() orelse return;
    const path = toks.next() orelse return;

    var content_length: usize = 0;
    var expect_continue = false;
    while (true) {
        const l = (try rd.interface.takeDelimiter('\n')) orelse break;
        const line = std.mem.trim(u8, l, " \t\r");
        if (line.len == 0) break;
        if (startsWithCi(line, "content-length:")) {
            content_length = std.fmt.parseInt(usize, std.mem.trim(u8, line["content-length:".len..], " "), 10) catch 0;
        } else if (startsWithCi(line, "expect:")) {
            if (std.ascii.eqlIgnoreCase(std.mem.trim(u8, line["expect:".len..], " "), "100-continue"))
                expect_continue = true;
        }
    }
    if (expect_continue) {
        var wbuf: [256]u8 = undefined;
        var cw = stream.writer(ctx.io, &wbuf);
        try cw.interface.writeAll("HTTP/1.1 100 Continue\r\n\r\n");
        try cw.interface.flush();
    }
    if (content_length > serve_body_buf.len) {
        var wbuf2: [512]u8 = undefined;
        var w2 = stream.writer(ctx.io, &wbuf2);
        respond(&w2.interface, "413 Payload Too Large", "{\"ok\":false,\"error\":\"body too large\"}") catch {};
        return;
    }
    const body = serve_body_buf[0..content_length];
    if (content_length > 0) try rd.interface.readSliceAll(body);

    // ---- route ----
    var req_arena = std.heap.ArenaAllocator.init(alloc);
    defer req_arena.deinit();
    const ralloc = req_arena.allocator();

    const r = route(ctx, ralloc, method, path, body) catch |err| blk2: {
        const msg = if (ctx.sess.lastError().len > 0) ctx.sess.lastError() else @errorName(err);
        break :blk2 Route{ .status = "500 Internal Server Error", .payload = try errJsonText(ralloc, msg) };
    };
    var wbuf: [16384]u8 = undefined;
    var w = stream.writer(ctx.io, &wbuf);
    respond(&w.interface, r.status, r.payload) catch |err| {
        std.debug.print("respond failed: {t}\n", .{err});
    };
}

const Route = struct { status: []const u8, payload: []u8 };

fn route(ctx: ConnCtx, ralloc: Allocator, method: []const u8, path: []const u8, body: []const u8) !Route {
    if (eql(method, "GET") and eql(path, "/health")) {
        return .{ .status = "200 OK", .payload = try okWrap(ralloc, "status", &.{ .str = "up" }) };
    }
    if (eql(method, "GET") and eql(path, "/surface")) {
        return .{ .status = "200 OK", .payload = try surfaceText(ctx.sess, ralloc, ctx.prog_id, null) };
    }
    if (eql(method, "GET") and eql(path, "/classes")) {
        const classes = try listBusyClasses(ralloc);
        var out: std.ArrayList(u8) = .empty;
        var w = json.Writer{ .buf = &out, .alloc = ralloc };
        try w.raw("{\"ok\":true,\"classes\":[");
        for (classes, 0..) |c, i| {
            if (i != 0) try w.raw(",");
            try w.str(c);
        }
        try w.raw("]}");
        return .{ .status = "200 OK", .payload = try out.toOwnedSlice(ralloc) };
    }
    if (eql(method, "POST") and eql(path, "/query")) {
        const parsed = json.parse(ralloc, body) catch {
            return .{ .status = "400 Bad Request", .payload = try errJsonText(ralloc, "invalid JSON body") };
        };
        const sql_v = parsed.get("sql") orelse {
            return .{ .status = "400 Bad Request", .payload = try errJsonText(ralloc, "missing \"sql\"") };
        };
        if (sql_v.* != .str)
            return .{ .status = "400 Bad Request", .payload = try errJsonText(ralloc, "\"sql\" must be a string") };
        const rows = try ctx.sess.queryToJson(sql_v.str);
        var rows_mut = rows;
        defer rows_mut.deinit(ctx.sess.alloc);
        return .{ .status = "200 OK", .payload = try okWrap(ralloc, "rows", &rows_mut) };
    }
    if (eql(method, "POST") and eql(path, "/call")) {
        const parsed = json.parse(ralloc, body) catch {
            return .{ .status = "400 Bad Request", .payload = try errJsonText(ralloc, "invalid JSON body") };
        };
        const meth_v = parsed.get("method") orelse {
            return .{ .status = "400 Bad Request", .payload = try errJsonText(ralloc, "missing \"method\"") };
        };
        if (meth_v.* != .str)
            return .{ .status = "400 Bad Request", .payload = try errJsonText(ralloc, "\"method\" must be a string") };
        var args_v: json.Value = .{ .arr = &.{} };
        if (parsed.get("args")) |a| {
            if (a.* == .arr) args_v = a.*;
        }
        var res = try ctx.sess.invoke(meth_v.str, args_v.arr);
        defer res.deinit(ctx.sess.alloc);
        var out: std.ArrayList(u8) = .empty;
        var w = json.Writer{ .buf = &out, .alloc = ralloc };
        try w.raw("{\"ok\":true,\"result\":");
        try json.stringify(&res.ret, &w);
        try w.raw(",\"outs\":");
        var outs_v = json.Value{ .arr = res.outs };
        try json.stringify(&outs_v, &w);
        try w.raw("}");
        return .{ .status = "200 OK", .payload = try out.toOwnedSlice(ralloc) };
    }
    return .{ .status = "404 Not Found", .payload = try errJsonText(ralloc, "unknown route (see /health /surface /classes /query /call)") };
}

/// The `serve` command: open the session once, then accept loop.
pub fn serve(io: Io, alloc: Allocator, cli: Cli) !u8 {
    const o = optsFrom(cli);
    const host = cli.getOr("--host", "127.0.0.1");
    const port = std.fmt.parseInt(u16, cli.getOr("--port", "9820"), 10) catch cli_mod.DEFAULT_PORT;

    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    try openSession(&sess, o);

    const addr = try Io.net.IpAddress.parse(host, port);
    var server = try addr.listen(io, .{});
    defer server.deinit(io);

    const boot = try std.fmt.allocPrint(alloc,
        \\{{"ok":true,"listening":"{s}:{d}","prog_id":"{s}","company":"{s}"}}
        \\
    , .{ host, port, o.prog_id, o.comp orelse "(none)" });
    defer alloc.free(boot);
    try printOut(io, alloc, boot);

    const ctx = ConnCtx{ .io = io, .sess = &sess, .prog_id = o.prog_id };
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
