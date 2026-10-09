//! Raw-tier CLI commands (issue #11 phase 4): classes, surface, query,
//! call — the COM escape hatch. `op` commands live in `ops.zig`; the
//! dispatcher and shared fail helpers in `../commands.zig`.
const std = @import("std");
const json = @import("../../util/json.zig");
const busyc = @import("../../core/com.zig");
const helpers = @import("../../util/helpers.zig");
const sqlguard = @import("../../util/sqlguard.zig");
const cli_mod = @import("../cli.zig");
const ops = @import("../../handlers.zig");
const record = @import("../../core/com/record.zig");
const golden = @import("../../handlers/golden.zig");
const registry = @import("../../core/registry.zig");
const envelope = @import("../envelope.zig");
const format = @import("../format.zig");
const cmd = @import("../commands.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;
const Format = format.Format;

const eql = helpers.eql;
const b64Decode = helpers.b64Decode;
const printOut = helpers.printOut;
const optsFrom = cli_mod.optsFrom;
const openSession = ops.openSession;
const surfaceText = ops.surfaceText;
const listBusyClasses = registry.listBusyClasses;
const fail = cmd.fail;
const failText = cmd.failText;

pub fn cmdClasses(io: Io, alloc: Allocator, fmt: Format) !u8 {
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

pub fn cmdSurface(io: Io, alloc: Allocator, cli: Cli, fmt: Format) !u8 {
    const o = optsFrom(cli) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NoBusyProgId) "busy_not_found" else helpers.errCode(err, &cb);
        const m = if (err == error.NoBusyProgId)
            "no registered Busy2L*.CFixedInterface found - is BUSY installed? (or pass --prog-id)"
        else
            @errorName(err);
        return fail(io, alloc, fmt, mach, m);
    };
    var sess = busyc.Session.init(alloc) catch |err| {
        var cb: [64]u8 = undefined;
        return fail(io, alloc, fmt, helpers.errCode(err, &cb), @errorName(err));
    };
    defer sess.deinit();
    sess.create(o.prog_id) catch |err| {
        var cb: [64]u8 = undefined;
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, helpers.errCode(err, &cb), msg);
    };
    const filter = cli.get("--member");
    if (fmt == .xml) {
        const members = sess.surface(alloc) catch |err| {
            var cb: [64]u8 = undefined;
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            return fail(io, alloc, fmt, helpers.errCode(err, &cb), msg);
        };
        defer {
            for (members) |*m| m.deinit(alloc);
            alloc.free(members);
        }
        const t = format.surfaceXml(alloc, o.prog_id, members, filter) catch |err| {
            var cb: [64]u8 = undefined;
            return fail(io, alloc, fmt, helpers.errCode(err, &cb), @errorName(err));
        };
        defer alloc.free(t);
        try printOut(io, alloc, t);
        try printOut(io, alloc, "\n");
        return 0;
    }
    const text = surfaceText(&sess, alloc, o.prog_id, filter) catch |err| {
        var cb: [64]u8 = undefined;
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, helpers.errCode(err, &cb), msg);
    };
    defer alloc.free(text);
    try printOut(io, alloc, text);
    try printOut(io, alloc, "\n");
    return 0;
}

pub fn cmdQuery(io: Io, alloc: Allocator, cli: Cli, fmt: Format) !u8 {
    var owned_sql: ?[]u8 = null;
    defer if (owned_sql) |o| alloc.free(o);
    const sql: []const u8 = if (cli.get("--sql-b64")) |b| blk: {
        owned_sql = b64Decode(alloc, b) catch {
            return fail(io, alloc, fmt, "invalid_base64", "invalid --sql-b64 (not valid base64)");
        };
        break :blk owned_sql.?;
    } else cli.get("--sql") orelse {
        return fail(io, alloc, fmt, "bad_args", "missing required --sql (or --sql-b64)");
    };
    // Query guard (issue #3): parse flags + refuse BEFORE touching COM, so
    // a refusal is instant and works even with BUSY not running.
    const guard = cli_mod.guardFrom(cli, "full") catch |err| {
        return fail(io, alloc, fmt, "bad_args", switch (err) {
            error.BadQueryMode => "invalid --query-mode (use full, read-only, off)",
            error.BadMaxRows => "invalid --max-rows (non-negative integer; 0 = unlimited)",
        });
    };
    sqlguard.check(guard.mode, sql) catch {
        return fail(io, alloc, fmt, "query_not_allowed", switch (guard.mode) {
            .off => "query disabled by --query-mode off",
            .read_only => "read-only mode accepts only a single SELECT/WITH statement (no multi-statement SQL)",
            else => unreachable,
        });
    };
    // Query target DB (iteration 6): the FY DB via GetRecordset
    // (default) or the company/common DB via GetRecordsetFromCompanyDB
    // (regular-user tables live on the common side). Same guard.
    const db = cli.getOr("--db", "fy");
    const rs_method: []const u8 = if (std.mem.eql(u8, db, "common"))
        "GetRecordsetFromCompanyDB"
    else if (std.mem.eql(u8, db, "fy"))
        "GetRecordset"
    else {
        return fail(io, alloc, fmt, "bad_args", "invalid --db (use fy, common)");
    };
    const o = optsFrom(cli) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NoBusyProgId) "busy_not_found" else helpers.errCode(err, &cb);
        const m = if (err == error.NoBusyProgId)
            "no registered Busy2L*.CFixedInterface found - is BUSY installed? (or pass --prog-id)"
        else
            @errorName(err);
        return fail(io, alloc, fmt, mach, m);
    };
    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    var ok = true;
    var out_text: []u8 = undefined;
    blk: {
        openSession(&sess, o) catch |err| {
            var cb: [64]u8 = undefined;
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, helpers.errCode(err, &cb), msg);
            ok = false;
            break :blk;
        };
        const rows = sess.queryToJsonFrom(sql, rs_method) catch |err| {
            var cb: [64]u8 = undefined;
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, helpers.errCode(err, &cb), msg);
            ok = false;
            break :blk;
        };
        var rows_mut = rows;
        defer rows_mut.deinit(alloc);
        out_text = switch (fmt) {
            .json => try envelope.rowsJson(alloc, &rows_mut, guard.max_rows),
            .xml => blk2: {
                // Legacy SC=1 rowset has no truncation marker — cap the
                // rows via a shallow view, document JSON as the aware mode.
                const view = envelope.rowView(&rows_mut, guard.max_rows);
                break :blk2 try format.rowsXml(alloc, &view);
            },
        };
    }
    defer alloc.free(out_text);
    try printOut(io, alloc, out_text);
    try printOut(io, alloc, "\n");
    return if (ok) 0 else 1;
}

pub fn cmdCall(io: Io, alloc: Allocator, cli: Cli, fmt: Format) !u8 {
    const method = cli.get("--method") orelse {
        return fail(io, alloc, fmt, "bad_args", "missing required --method");
    };
    var owned_args: ?[]u8 = null;
    defer if (owned_args) |o| alloc.free(o);
    const args_text: []const u8 = if (cli.get("--args-b64")) |b| blk: {
        owned_args = b64Decode(alloc, b) catch {
            return fail(io, alloc, fmt, "invalid_base64", "invalid --args-b64 (not valid base64)");
        };
        break :blk owned_args.?;
    } else cli.getOr("--args", "[]");
    const o = optsFrom(cli) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NoBusyProgId) "busy_not_found" else helpers.errCode(err, &cb);
        const m = if (err == error.NoBusyProgId)
            "no registered Busy2L*.CFixedInterface found - is BUSY installed? (or pass --prog-id)"
        else
            @errorName(err);
        return fail(io, alloc, fmt, mach, m);
    };

    var parsed = json.parse(alloc, args_text) catch |err| {
        var cb: [64]u8 = undefined;
        return fail(io, alloc, fmt, helpers.errCode(err, &cb), @errorName(err));
    };
    defer parsed.deinit(alloc);
    if (parsed != .arr) {
        return fail(io, alloc, fmt, "bad_args", "--args must be a JSON array");
    }
    // JSON-object XML arguments become real XML before the COM call.
    format.xmlifyArgsInPlace(alloc, method, parsed.arr) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.BadDocument) "xml_arg_invalid" else helpers.errCode(err, &cb);
        const msg = if (err == error.BadDocument)
            "xml argument must be a single-key document object like {\"Root\":{...}}"
        else
            @errorName(err);
        return fail(io, alloc, fmt, mach, msg);
    };

    var sess = try busyc.Session.init(alloc);
    defer sess.deinit();
    var ok = true;
    var out_text: []u8 = undefined;
    blk: {
        openSession(&sess, o) catch |err| {
            var cb: [64]u8 = undefined;
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, helpers.errCode(err, &cb), msg);
            ok = false;
            break :blk;
        };
        const enum_ret = cli.flag("--enumerate-ret");
        const res = sess.invokeEx(method, parsed.arr, .{ .enumerate_ret = enum_ret }) catch |err| {
            var cb: [64]u8 = undefined;
            const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
            out_text = try failText(alloc, fmt, helpers.errCode(err, &cb), msg);
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

/// Record read-only golden flows as a JSONL transcript for replay CI
/// (issue 009). Plain-text output like version/help. Fails when BUSY is
/// absent (busy_not_found) or the company will not open; a partial
/// transcript is still written on mid-run failure.
pub fn cmdRecord(io: Io, alloc: Allocator, cli: Cli) !u8 {
    const comp = cli.get("--comp") orelse
        return fail(io, alloc, .json, "bad_args", "record needs --comp CODE");
    const out_path = cli.getOr("--out", "transcript.jsonl");
    const o = optsFrom(cli) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NoBusyProgId) "busy_not_found" else helpers.errCode(err, &cb);
        const m = if (err == error.NoBusyProgId)
            "no registered Busy2L*.CFixedInterface found - is BUSY installed? (or pass --prog-id)"
        else
            @errorName(err);
        return fail(io, alloc, .json, mach, m);
    };
    var sess = busyc.Session.init(alloc) catch |err| {
        var cb: [64]u8 = undefined;
        return fail(io, alloc, .json, helpers.errCode(err, &cb), @errorName(err));
    };
    defer sess.deinit();
    sess.create(o.prog_id) catch |err| {
        var cb: [64]u8 = undefined;
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, .json, helpers.errCode(err, &cb), msg);
    };
    var rec = record.Recorder{ .sess = &sess, .alloc = alloc };
    defer rec.deinit();
    const now_ms = Io.Timestamp.now(io, .real).toMilliseconds();
    rec.header(o.prog_id, now_ms) catch |err| {
        var cb: [64]u8 = undefined;
        return fail(io, alloc, .json, helpers.errCode(err, &cb), @errorName(err));
    };
    golden.runGoldenReads(&sess, alloc, &rec, o.busy, o.data, comp) catch |err| {
        rec.writeFile(io, out_path) catch {};
        var cb: [64]u8 = undefined;
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, .json, helpers.errCode(err, &cb), msg);
    };
    rec.writeFile(io, out_path) catch |err| {
        var cb: [64]u8 = undefined;
        return fail(io, alloc, .json, helpers.errCode(err, &cb), @errorName(err));
    };
    var b: [128]u8 = undefined;
    try printOut(io, alloc, std.fmt.bufPrint(&b, "recorded {d} entries -> {s}\n", .{ rec.seq, out_path }) catch unreachable);
    return 0;
}
