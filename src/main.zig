//! busy-bridge: modern programmatic interface over the BUSY ERP COM surface.
//!
//! Commands:
//!   busy-bridge classes                      enumerate all registered BUSY ProgIDs
//!   busy-bridge surface [--prog-id P] [--member M]
//!                                            dump the full IDispatch surface as JSON
//!   busy-bridge query --comp C --sql SQL     run SQL against an open company -> JSON rows
//!   busy-bridge call --method M [--args J]   invoke any COM method with JSON args
//!   busy-bridge serve [--port N] [--comp C]  local HTTP JSON API over the same ops
//!   busy-bridge version | help
//!
//! Long options: --prog-id --busy --data --comp --sql --method --args --port --host
const std = @import("std");
const builtin = @import("builtin");
const json = @import("json.zig");
const busyc = @import("com.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const DEFAULT_PROG = "Busy2L21.CFixedInterface";
const DEFAULT_BUSY = "C:\\BusyWin\\";
const DEFAULT_DATA = "C:\\BusyWin\\DATA\\";
const DEFAULT_PORT: u16 = 9820;

const Usage =
    \\busy-bridge - programmatic interface over BUSY ERP's COM API surface
    \\
    \\usage:
    \\  busy-bridge classes                            list all registered BUSY COM classes
    \\  busy-bridge surface [--prog-id P] [--member M] dump IDispatch surface as JSON
    \\  busy-bridge query --comp C --sql "SELECT ..."  query open company (opens via OpenDB)
    \\  busy-bridge call --method M [--args '[..]']    invoke any COM method, JSON args,
    \\       [--prog-id P] [--comp C]                   {"$byref": v} marks out-params
    \\  busy-bridge serve [--port 9820] [--host H]     HTTP JSON API: GET /surface /classes
    \\       [--comp C] [--prog-id P]                   POST /query {"sql":..} /call {"method":..}
    \\  busy-bridge version
    \\
    \\common options: --prog-id (default Busy2L21.CFixedInterface)
    \\                --busy (default C:\BusyWin\) --data (default C:\BusyWin\DATA\)
    \\                --args-b64 / --sql-b64: base64-encoded value (use from PowerShell
    \\                5.1+ to avoid its double-quote mangling of native args)
    \\
;

// ---------------- win32 registry externs (for `classes`) ----------------

const HKEY_LOCAL_MACHINE: ?*anyopaque = @ptrFromInt(0x80000002);
const KEY_READ: u32 = 0x20019;
const ERROR_SUCCESS: i32 = 0;
const ERROR_MORE_DATA: i32 = 234;
const ERROR_NO_MORE_ITEMS: i32 = 259;

extern "advapi32" fn RegOpenKeyExA(
    hKey: ?*anyopaque,
    lpSubKey: [*:0]const u8,
    ulOptions: u32,
    samDesired: u32,
    phkResult: *?*anyopaque,
) callconv(.winapi) i32;
extern "advapi32" fn RegEnumKeyExA(
    hKey: ?*anyopaque,
    dwIndex: u32,
    lpName: [*]u8,
    lpcchName: *u32,
    lpReserved: ?*u32,
    lpClass: ?[*]u8,
    lpcchClass: ?*u32,
    lpftLastWriteTime: ?*anyopaque,
) callconv(.winapi) i32;
extern "advapi32" fn RegCloseKey(hKey: ?*anyopaque) callconv(.winapi) i32;

fn listBusyClasses(alloc: Allocator) ![][]const u8 {
    var h: ?*anyopaque = null;
    if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, "SOFTWARE\\Classes", 0, KEY_READ, &h) != ERROR_SUCCESS)
        return error.RegistryOpenFailed;
    defer _ = RegCloseKey(h);
    var out: std.ArrayList([]const u8) = .empty;
    errdefer {
        for (out.items) |s| alloc.free(s);
        out.deinit(alloc);
    }
    var i: u32 = 0;
    while (true) : (i += 1) {
        var name: [512]u8 = undefined;
        var n: u32 = name.len;
        const rc = RegEnumKeyExA(h, i, &name, &n, null, null, null, null);
        if (rc == ERROR_NO_MORE_ITEMS) break;
        if (rc == ERROR_MORE_DATA) continue; // oversized key: skip
        if (rc != ERROR_SUCCESS) return error.RegistryEnumFailed;
        const key = name[0..n];
        if (std.mem.startsWith(u8, key, "Busy"))
            try out.append(alloc, try alloc.dupe(u8, key));
    }
    return out.toOwnedSlice(alloc);
}

// ---------------- small helpers ----------------

const Cli = struct {
    items: []const [:0]const u8,

    fn get(self: Cli, key: []const u8) ?[]const u8 {
        var i: usize = 1;
        while (i + 1 < self.items.len) : (i += 1) {
            if (std.mem.eql(u8, self.items[i], key)) return self.items[i + 1];
        }
        return null;
    }

    fn getOr(self: Cli, key: []const u8, dflt: []const u8) []const u8 {
        return self.get(key) orelse dflt;
    }
};

fn eql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

fn startsWithCi(hay: []const u8, needle: []const u8) bool {
    if (hay.len < needle.len) return false;
    return std.ascii.eqlIgnoreCase(hay[0..needle.len], needle);
}

/// Decode a base64 CLI value. Used by --args-b64/--sql-b64 because
/// PowerShell 5.1 mangles embedded double quotes in native-command args.
fn b64Decode(alloc: Allocator, s: []const u8) ![]u8 {
    const dec = std.base64.standard.Decoder;
    const size = try dec.calcSizeForSlice(s);
    const buf = try alloc.alloc(u8, size);
    errdefer alloc.free(buf);
    try dec.decode(buf, s);
    return buf;
}

fn printOut(io: Io, alloc: Allocator, text: []const u8) !void {
    _ = alloc;
    var buf: [16384]u8 = undefined;
    var w = Io.File.stdout().writer(io, &buf);
    try w.interface.writeAll(text);
    try w.interface.flush();
}

fn emitJson(io: Io, alloc: Allocator, v: *const json.Value) !void {
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try json.stringify(v, &w);
    try out.append(alloc, '\n');
    try printOut(io, alloc, out.items);
}

fn errJsonText(alloc: Allocator, msg: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":false,");
    try w.field("error");
    try w.str(msg);
    try w.raw("}");
    return out.toOwnedSlice(alloc);
}

fn fieldText(alloc: Allocator, key: []const u8, v: *const json.Value) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.field(key);
    try json.stringify(v, &w);
    return out.toOwnedSlice(alloc);
}

/// Wrap a JSON value as {"ok":true, key: value} text.
fn okWrap(alloc: Allocator, key: []const u8, v: *const json.Value) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,");
    try w.field(key);
    try json.stringify(v, &w);
    try w.raw("}");
    return out.toOwnedSlice(alloc);
}

// ---------------- session helpers ----------------

const OpenOpts = struct {
    prog_id: []const u8,
    busy: []const u8,
    data: []const u8,
    comp: ?[]const u8,
};

fn optsFrom(cli: Cli) OpenOpts {
    return .{
        .prog_id = cli.getOr("--prog-id", DEFAULT_PROG),
        .busy = cli.getOr("--busy", DEFAULT_BUSY),
        .data = cli.getOr("--data", DEFAULT_DATA),
        .comp = cli.get("--comp"),
    };
}

fn openSession(sess: *busyc.Session, o: OpenOpts) !void {
    try sess.create(o.prog_id);
    if (o.comp) |c| {
        var open_args = [_]json.Value{ .{ .str = o.busy }, .{ .str = o.data }, .{ .str = c } };
        var r = try sess.invoke("OpenDB", &open_args);
        defer r.deinit(sess.alloc);
        switch (r.ret) {
            .bool => |b| if (!b) {
                sess.setErr("OpenDB rejected company '{s}' in {s}", .{ c, o.data });
                return error.OpenDbFailed;
            },
            else => {},
        }
    }
}

/// Serialize a session's IDispatch surface to JSON text.
fn surfaceText(sess: *busyc.Session, alloc: Allocator, prog_id: []const u8, member_filter: ?[]const u8) ![]u8 {
    const members = try sess.surface(alloc);
    defer {
        for (members) |*m| m.deinit(alloc);
        alloc.free(members);
    }
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"prog_id\":");
    try w.str(prog_id);
    try w.raw(",\"count\":");
    {
        var b: [16]u8 = undefined;
        try w.raw(std.fmt.bufPrint(&b, "{d}", .{members.len}) catch unreachable);
    }
    try w.raw(",\"members\":[");
    var written: usize = 0;
    for (members) |m| {
        if (member_filter) |f| {
            if (!std.ascii.eqlIgnoreCase(m.name, f)) continue;
        }
        if (written != 0) try w.raw(",");
        written += 1;
        try w.raw("{\"name\":");
        try w.str(m.name);
        try w.raw(",\"kind\":");
        try w.str(m.kind);
        try w.raw(",\"nparams\":");
        {
            var b: [16]u8 = undefined;
            try w.raw(std.fmt.bufPrint(&b, "{d}", .{m.nparams}) catch unreachable);
        }
        try w.raw(",\"nopt\":");
        {
            var b: [16]u8 = undefined;
            try w.raw(std.fmt.bufPrint(&b, "{d}", .{m.nopt}) catch unreachable);
        }
        try w.raw(",\"params\":[");
        for (m.params, 0..) |p, i| {
            if (i != 0) try w.raw(",");
            try w.str(p);
        }
        try w.raw("]}");
    }
    try w.raw("]}");
    return out.toOwnedSlice(alloc);
}

// ---------------- commands ----------------

fn cmdClasses(io: Io, alloc: Allocator) !u8 {
    const classes = try listBusyClasses(alloc);
    defer {
        for (classes) |c| alloc.free(c);
        alloc.free(classes);
    }
    var v = try alloc.alloc(json.Value, classes.len);
    defer alloc.free(v);
    for (classes, 0..) |c, i| v[i] = .{ .str = c };
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,\"count\":");
    {
        var b: [16]u8 = undefined;
        try w.raw(std.fmt.bufPrint(&b, "{d}", .{classes.len}) catch unreachable);
    }
    try w.raw(",\"classes\":[");
    for (v, 0..) |*cv, i| {
        if (i != 0) try w.raw(",");
        try json.stringify(cv, &w);
    }
    try w.raw("]}");
    try out.append(alloc, '\n');
    try printOut(io, alloc, out.items);
    return 0;
}

fn cmdSurface(io: Io, alloc: Allocator, cli: Cli) !u8 {
    const o = optsFrom(cli);
    var sess = busyc.Session.init(alloc) catch |err| {
        const t = try errJsonText(alloc, @errorName(err));
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    defer sess.deinit();
    sess.create(o.prog_id) catch |err| {
        const t = try errJsonText(alloc, if (sess.lastError().len > 0) sess.lastError() else @errorName(err));
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    const text = surfaceText(&sess, alloc, o.prog_id, cli.get("--member")) catch |err| {
        const t = try errJsonText(alloc, if (sess.lastError().len > 0) sess.lastError() else @errorName(err));
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    defer alloc.free(text);
    try printOut(io, alloc, text);
    try printOut(io, alloc, "\n");
    return 0;
}

fn cmdQuery(io: Io, alloc: Allocator, cli: Cli) !u8 {
    var owned_sql: ?[]u8 = null;
    defer if (owned_sql) |o| alloc.free(o);
    const sql: []const u8 = if (cli.get("--sql-b64")) |b| blk: {
        owned_sql = b64Decode(alloc, b) catch {
            const t = try errJsonText(alloc, "invalid --sql-b64 (not valid base64)");
            defer alloc.free(t);
            try printOut(io, alloc, t);
            try printOut(io, alloc, "\n");
            return 1;
        };
        break :blk owned_sql.?;
    } else cli.get("--sql") orelse {
        const t = try errJsonText(alloc, "missing required --sql (or --sql-b64)");
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    const o = optsFrom(cli);
    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    var ok = true;
    var out_text: []u8 = undefined;
    blk: {
        openSession(&sess, o) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try errJsonText(alloc, msg);
            ok = false;
            break :blk;
        };
        const rows = sess.queryToJson(sql) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try errJsonText(alloc, msg);
            ok = false;
            break :blk;
        };
        var rows_mut = rows;
        defer rows_mut.deinit(alloc);
        out_text = try okWrap(alloc, "rows", &rows_mut);
    }
    defer alloc.free(out_text);
    try printOut(io, alloc, out_text);
    try printOut(io, alloc, "\n");
    return if (ok) 0 else 1;
}

fn cmdCall(io: Io, alloc: Allocator, cli: Cli) !u8 {
    const method = cli.get("--method") orelse {
        const t = try errJsonText(alloc, "missing required --method");
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    var owned_args: ?[]u8 = null;
    defer if (owned_args) |o| alloc.free(o);
    const args_text: []const u8 = if (cli.get("--args-b64")) |b| blk: {
        owned_args = b64Decode(alloc, b) catch {
            const t = try errJsonText(alloc, "invalid --args-b64 (not valid base64)");
            defer alloc.free(t);
            try printOut(io, alloc, t);
            try printOut(io, alloc, "\n");
            return 1;
        };
        break :blk owned_args.?;
    } else cli.getOr("--args", "[]");
    const o = optsFrom(cli);

    var parsed = json.parse(alloc, args_text) catch |err| {
        const t = try errJsonText(alloc, @errorName(err));
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    };
    defer parsed.deinit(alloc);
    if (parsed != .arr) {
        const t = try errJsonText(alloc, "--args must be a JSON array");
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 1;
    }

    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    var ok = true;
    var out_text: []u8 = undefined;
    blk: {
        openSession(&sess, o) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try errJsonText(alloc, msg);
            ok = false;
            break :blk;
        };
        const res = sess.invoke(method, parsed.arr) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try errJsonText(alloc, msg);
            ok = false;
            break :blk;
        };
        var res_mut = res;
        defer res_mut.deinit(alloc);
        // {"ok":true,"result":R,"outs":[...]}
        var out: std.ArrayList(u8) = .empty;
        var w = json.Writer{ .buf = &out, .alloc = alloc };
        w.raw("{\"ok\":true,\"result\":") catch break :blk;
        json.stringify(&res_mut.ret, &w) catch break :blk;
        w.raw(",\"outs\":") catch break :blk;
        var outs_v = json.Value{ .arr = res_mut.outs };
        json.stringify(&outs_v, &w) catch break :blk;
        w.raw("}") catch break :blk;
        out_text = out.toOwnedSlice(alloc) catch break :blk;
        ok = true;
    }
    defer alloc.free(out_text);
    try printOut(io, alloc, out_text);
    try printOut(io, alloc, "\n");
    return if (ok) 0 else 1;
}

// ---------------- HTTP server ----------------

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

fn cmdServe(io: Io, alloc: Allocator, cli: Cli) !u8 {
    const o = optsFrom(cli);
    const host = cli.getOr("--host", "127.0.0.1");
    const port = std.fmt.parseInt(u16, cli.getOr("--port", "9820"), 10) catch DEFAULT_PORT;

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

// ---------------- entry ----------------

pub fn main(init: std.process.Init) !u8 {
    const io = init.io;
    const alloc = init.gpa;

    var list: std.ArrayList([:0]const u8) = .empty;
    defer list.deinit(alloc);
    // Windows arg iterator reuses one internal buffer -> duplicate each arg.
    var it = try init.minimal.args.iterateAllocator(alloc);
    defer it.deinit();
    _ = it.next(); // skip argv[0] (program path)
    while (it.next()) |a| {
        const dup = try alloc.allocSentinel(u8, a.len, 0);
        @memcpy(dup, a);
        list.append(alloc, dup) catch return 1;
    }
    const items = try list.toOwnedSlice(alloc);
    defer {
        for (items) |a| alloc.free(a);
        alloc.free(items);
    }

    if (items.len == 0) {
        try printOut(io, alloc, Usage);
        return 1;
    }
    const cmd = items[0];
    const cli = Cli{ .items = items };

    if (eql(cmd, "help") or eql(cmd, "--help") or eql(cmd, "-h")) {
        try printOut(io, alloc, Usage);
        return 0;
    }
    if (eql(cmd, "version")) {
        try printOut(io, alloc, "busy-bridge 0.1.0 (zig " ++ comptime versionString() ++ ", x86-windows)\n");
        return 0;
    }
    if (eql(cmd, "classes")) return cmdClasses(io, alloc);
    if (eql(cmd, "surface")) return cmdSurface(io, alloc, cli);
    if (eql(cmd, "query")) return cmdQuery(io, alloc, cli);
    if (eql(cmd, "call")) return cmdCall(io, alloc, cli);
    if (eql(cmd, "serve")) return cmdServe(io, alloc, cli);

    try printOut(io, alloc, "unknown command: ");
    try printOut(io, alloc, cmd);
    try printOut(io, alloc, "\n\n");
    try printOut(io, alloc, Usage);
    return 1;
}

fn versionString() []const u8 {
    comptime {
        return std.fmt.comptimePrint("{d}.{d}.{d}", .{
            builtin.zig_version.major,
            builtin.zig_version.minor,
            builtin.zig_version.patch,
        });
    }
}
