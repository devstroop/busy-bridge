//! CLI commands: dispatch + per-command implementations (classes/surface/
//! query/call); `serve` delegates to http.zig. Response format follows --out
//! (default json); errors render in the same active format.
const std = @import("std");
const builtin = @import("builtin");
const json = @import("../util/json.zig");
const busyc = @import("../core/com.zig");
const helpers = @import("../util/helpers.zig");
const cli_mod = @import("cli.zig");
const ops = @import("../core/ops.zig");
const registry = @import("../core/registry.zig");
const http = @import("http.zig");
const envelope = @import("envelope.zig");
const format = @import("format.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;
const Format = format.Format;

const eql = helpers.eql;
const b64Decode = helpers.b64Decode;
const printOut = helpers.printOut;
const okWrap = envelope.okWrap;
const Usage = cli_mod.Usage;
const optsFrom = cli_mod.optsFrom;
const openSession = ops.openSession;
const surfaceText = ops.surfaceText;
const listBusyClasses = registry.listBusyClasses;

/// Build an error payload in the active wire format (no printing).
fn failText(alloc: Allocator, fmt: Format, code: []const u8, msg: []const u8) ![]u8 {
    return switch (fmt) {
        .json => envelope.errJsonText(alloc, msg),
        .xml => format.errorXml(alloc, code, msg),
    };
}

/// Print an error in the active wire format and return the failure exit code.
fn fail(io: Io, alloc: Allocator, fmt: Format, code: []const u8, msg: []const u8) !u8 {
    const t = try failText(alloc, fmt, code, msg);
    defer alloc.free(t);
    try printOut(io, alloc, t);
    try printOut(io, alloc, "\n");
    return 1;
}

/// Route a parsed argv to its command. `cli.items[0]` is the command name.
pub fn run(io: Io, alloc: Allocator, cli: Cli) !u8 {
    if (cli.items.len == 0) {
        try printOut(io, alloc, Usage);
        return 1;
    }
    const cmd = cli.items[0];
    if (eql(cmd, "help") or eql(cmd, "--help") or eql(cmd, "-h")) {
        try printOut(io, alloc, Usage);
        return 0;
    }
    if (eql(cmd, "version")) {
        try printOut(io, alloc, "busy-bridge 0.1.0 (zig " ++ comptime versionString() ++ ", x86-windows)\n");
        return 0;
    }
    const fmt: Format = format.fromOutFlag(cli.getOr("--out", "json")) catch {
        return fail(io, alloc, .json, "1", "invalid --out value (use json or xml)");
    };
    if (eql(cmd, "classes")) return cmdClasses(io, alloc, fmt);
    if (eql(cmd, "surface")) return cmdSurface(io, alloc, cli, fmt);
    if (eql(cmd, "query")) return cmdQuery(io, alloc, cli, fmt);
    if (eql(cmd, "call")) return cmdCall(io, alloc, cli, fmt);
    if (eql(cmd, "serve")) return http.serve(io, alloc, cli); // Accept-negotiated

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

fn cmdClasses(io: Io, alloc: Allocator, fmt: Format) !u8 {
    const classes = try listBusyClasses(alloc);
    defer {
        for (classes) |c| alloc.free(c);
        alloc.free(classes);
    }
    if (fmt == .xml) {
        const t = try format.classesXml(alloc, classes);
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 0;
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

fn cmdSurface(io: Io, alloc: Allocator, cli: Cli, fmt: Format) !u8 {
    const o = optsFrom(cli);
    var sess = busyc.Session.init(alloc) catch |err| {
        return fail(io, alloc, fmt, "1", @errorName(err));
    };
    defer sess.deinit();
    sess.create(o.prog_id) catch |err| {
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, "1", msg);
    };
    const filter = cli.get("--member");
    if (fmt == .xml) {
        const members = sess.surface(alloc) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            return fail(io, alloc, fmt, "1", msg);
        };
        defer {
            for (members) |*m| m.deinit(alloc);
            alloc.free(members);
        }
        const t = format.surfaceXml(alloc, o.prog_id, members, filter) catch |err| {
            return fail(io, alloc, fmt, "1", @errorName(err));
        };
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 0;
    }
    const text = surfaceText(&sess, alloc, o.prog_id, filter) catch |err| {
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, "1", msg);
    };
    defer alloc.free(text);
    try printOut(io, alloc, text);
    try printOut(io, alloc, "\n");
    return 0;
}

fn cmdQuery(io: Io, alloc: Allocator, cli: Cli, fmt: Format) !u8 {
    var owned_sql: ?[]u8 = null;
    defer if (owned_sql) |o| alloc.free(o);
    const sql: []const u8 = if (cli.get("--sql-b64")) |b| blk: {
        owned_sql = b64Decode(alloc, b) catch {
            return fail(io, alloc, fmt, "1", "invalid --sql-b64 (not valid base64)");
        };
        break :blk owned_sql.?;
    } else cli.get("--sql") orelse {
        return fail(io, alloc, fmt, "1", "missing required --sql (or --sql-b64)");
    };
    const o = optsFrom(cli);
    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    var ok = true;
    var out_text: []u8 = undefined;
    blk: {
        openSession(&sess, o) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, "1", msg);
            ok = false;
            break :blk;
        };
        const rows = sess.queryToJson(sql) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, "1", msg);
            ok = false;
            break :blk;
        };
        var rows_mut = rows;
        defer rows_mut.deinit(alloc);
        out_text = switch (fmt) {
            .json => try okWrap(alloc, "rows", &rows_mut),
            .xml => try format.rowsXml(alloc, &rows_mut),
        };
    }
    defer alloc.free(out_text);
    try printOut(io, alloc, out_text);
    try printOut(io, alloc, "\n");
    return if (ok) 0 else 1;
}

fn cmdCall(io: Io, alloc: Allocator, cli: Cli, fmt: Format) !u8 {
    const method = cli.get("--method") orelse {
        return fail(io, alloc, fmt, "1", "missing required --method");
    };
    var owned_args: ?[]u8 = null;
    defer if (owned_args) |o| alloc.free(o);
    const args_text: []const u8 = if (cli.get("--args-b64")) |b| blk: {
        owned_args = b64Decode(alloc, b) catch {
            return fail(io, alloc, fmt, "1", "invalid --args-b64 (not valid base64)");
        };
        break :blk owned_args.?;
    } else cli.getOr("--args", "[]");
    const o = optsFrom(cli);

    var parsed = json.parse(alloc, args_text) catch |err| {
        return fail(io, alloc, fmt, "1", @errorName(err));
    };
    defer parsed.deinit(alloc);
    if (parsed != .arr) {
        return fail(io, alloc, fmt, "1", "--args must be a JSON array");
    }
    // JSON-object XML arguments become real XML before the COM call.
    format.xmlifyArgsInPlace(alloc, method, parsed.arr) catch |err| {
        const msg = if (err == error.BadDocument)
            "xml argument must be a single-key document object like {\"Root\":{...}}"
        else
            @errorName(err);
        return fail(io, alloc, fmt, "1", msg);
    };

    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    var ok = true;
    var out_text: []u8 = undefined;
    blk: {
        openSession(&sess, o) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, "1", msg);
            ok = false;
            break :blk;
        };
        const res = sess.invoke(method, parsed.arr) catch |err| {
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, "1", msg);
            ok = false;
            break :blk;
        };
        var res_mut = res;
        defer res_mut.deinit(alloc);
        if (fmt == .xml) {
            out_text = if (format.isPassthrough(method, &res_mut))
                try alloc.dupe(u8, res_mut.ret.str)
            else
                try format.callXml(alloc, method, &res_mut);
            break :blk;
        }
        // JSON mode: xml-out results become structured trees, never blobs.
        format.enrichCallResult(alloc, method, &res_mut) catch {};
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
