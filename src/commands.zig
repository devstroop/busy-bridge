//! CLI commands: dispatch + per-command implementations (classes/surface/
//! query/call); `serve` delegates to http.zig.
const std = @import("std");
const builtin = @import("builtin");
const json = @import("json.zig");
const busyc = @import("com.zig");
const helpers = @import("helpers.zig");
const cli_mod = @import("cli.zig");
const ops = @import("ops.zig");
const registry = @import("registry.zig");
const http = @import("http.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;

const eql = helpers.eql;
const b64Decode = helpers.b64Decode;
const printOut = helpers.printOut;
const errJsonText = helpers.errJsonText;
const okWrap = helpers.okWrap;
const Usage = cli_mod.Usage;
const optsFrom = cli_mod.optsFrom;
const openSession = ops.openSession;
const surfaceText = ops.surfaceText;
const listBusyClasses = registry.listBusyClasses;

/// Route a parsed argv to its command. `cli.items[0]` is the command name.
pub fn run(io: Io, alloc: Allocator, cli: Cli) !u8 {
    const cmd = cli.items[0];
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
    if (eql(cmd, "serve")) return http.serve(io, alloc, cli);

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
