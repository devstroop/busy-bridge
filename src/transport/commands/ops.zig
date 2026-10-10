//! ERP-facade CLI commands (issue #11 phase 4): `op` verb dispatch —
//! catalog/list/get reads, create/update/delete/post/batch writes, named
//! reports. Raw commands live in `raw.zig`; the dispatcher and shared
//! fail helpers in `../commands.zig`.
const std = @import("std");
const json = @import("../../util/json.zig");
const busyc = @import("../../core/com.zig");
const helpers = @import("../../util/helpers.zig");
const cli_mod = @import("../cli.zig");
const ops = @import("../../handlers.zig");
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
const fail = cmd.fail;

/// `busy-bridge op ...` — ERP operations facade (issue #7): normalized
/// reads with mechanical internals; raw `call`/`query` remain the escape
/// hatch. Positionals: `catalog`, `list <accounts|items|vouchers>`,
/// `get <account|item|voucher> <key>`; flags: --limit --q --type.
pub fn cmdOp(io: Io, alloc: Allocator, cli: Cli, fmt: Format) !u8 {
    // positional words (skip flags + their values)
    var pos: std.ArrayList([]const u8) = .empty;
    defer pos.deinit(alloc);
    {
        var i: usize = 1;
        while (i < cli.items.len) : (i += 1) {
            const it = cli.items[i];
            if (it.len >= 2 and it[0] == '-' and it[1] == '-') {
                i += 1; // flag + value
                continue;
            }
            try pos.append(alloc, it);
        }
    }
    if (pos.items.len == 0)
        return fail(io, alloc, fmt, "bad_args", "usage: busy-bridge op <catalog | list <accounts|items|vouchers> [--limit N] [--q X] [--type NAME] | get <account|item|voucher> <key> | create|update <account|item> <name> [--json {..}] | delete <account|item> <name> | post --json {..} | batch --json [..]>");

    const verb = pos.items[0];
    if (eql(verb, "catalog")) {
        // plain text like version/help — docs generation reads it raw
        const md = try ops.catalog.markdown(alloc);
        defer alloc.free(md);
        try printOut(io, alloc, md);
        return 0;
    }

    // M2 writes (issue #7): create/update/delete/post/batch share the
    // exec dispatcher (one JSON-args path for CLI, HTTP and batch).
    if (eql(verb, "create") or eql(verb, "update") or eql(verb, "delete") or eql(verb, "post") or eql(verb, "batch"))
        return cmdOpWrite(io, alloc, cli, fmt, pos.items, verb);

    // M3 named reports (issue #7): balances + stock status.
    if (eql(verb, "report")) return cmdOpReport(io, alloc, cli, fmt, pos.items);

    const limit: usize = blk: {
        const raw = cli.get("--limit") orelse break :blk 100;
        break :blk std.fmt.parseInt(usize, raw, 10) catch {
            return fail(io, alloc, fmt, "bad_args", "invalid --limit (non-negative integer; 0 = unlimited)");
        };
    };

    // validate everything BEFORE touching COM
    const OpKind = enum { list_accounts, list_items, list_vouchers, get_account, get_item, get_voucher };
    var opk: OpKind = undefined;
    var key: []const u8 = "";
    var key_int: i64 = 0;
    if (eql(verb, "list")) {
        if (pos.items.len < 2)
            return fail(io, alloc, fmt, "bad_args", "op list needs a kind: accounts | items | vouchers");
        const k = pos.items[1];
        if (eql(k, "accounts")) opk = .list_accounts else if (eql(k, "items")) opk = .list_items else if (eql(k, "vouchers")) opk = .list_vouchers else return fail(io, alloc, fmt, "bad_args", "unknown list kind (use accounts, items or vouchers)");
    } else if (eql(verb, "get")) {
        if (pos.items.len < 3)
            return fail(io, alloc, fmt, "bad_args", "op get needs a kind and a key: account|item <name> | voucher <code>");
        const k = pos.items[1];
        key = pos.items[2];
        if (eql(k, "account")) {
            opk = .get_account;
        } else if (eql(k, "item")) {
            opk = .get_item;
        } else if (eql(k, "voucher")) {
            opk = .get_voucher;
            key_int = std.fmt.parseInt(i64, key, 10) catch
                return fail(io, alloc, fmt, "bad_args", "voucher key must be an integer VchCode");
        } else {
            return fail(io, alloc, fmt, "bad_args", "unknown get kind (use account, item or voucher)");
        }
    } else {
        return fail(io, alloc, fmt, "bad_args", "unknown op verb (use catalog, list or get)");
    }
    const op_name: []const u8 = switch (opk) {
        .list_accounts => "list-accounts",
        .list_items => "list-items",
        .list_vouchers => "list-vouchers",
        .get_account => "get-account",
        .get_item => "get-item",
        .get_voucher => "get-voucher",
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
    openSession(&sess, o) catch |err| {
        var cb: [64]u8 = undefined;
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, helpers.errCode(err, &cb), msg);
    };

    const result = switch (opk) {
        .list_accounts => ops.masters.list(&sess, alloc, .account, .{ .limit = limit, .q = cli.get("--q") }),
        .list_items => ops.masters.list(&sess, alloc, .item, .{ .limit = limit, .q = cli.get("--q") }),
        .list_vouchers => ops.vouchers.list(&sess, alloc, .{ .type_name = cli.get("--type"), .limit = limit }),
        .get_account => ops.masters.get(&sess, alloc, .account, key),
        .get_item => ops.masters.get(&sess, alloc, .item, key),
        .get_voucher => ops.vouchers.get(&sess, alloc, key_int),
    } catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NotFound)
            "not_found"
        else if (err == error.BadArgs)
            "bad_args"
        else
            helpers.errCode(err, &cb);
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, mach, msg);
    };
    var res = result;
    defer res.deinit(alloc);

    const out_text = switch (fmt) {
        .json => try envelope.opJson(alloc, op_name, &res),
        .xml => try envelope.opXml(alloc, op_name, &res),
    };
    defer alloc.free(out_text);
    try printOut(io, alloc, out_text);
    try printOut(io, alloc, "\n");
    return 0;
}

/// M3 named reports: `op report <name> [--flags]`. Flags become the
/// JSON args object — one validation path (reports.zig) for CLI + HTTP.
fn cmdOpReport(io: Io, alloc: Allocator, cli: Cli, fmt: Format, pos: []const []const u8) !u8 {
    if (pos.len < 2)
        return fail(io, alloc, fmt, "bad_args", "op report needs a name: account-balance | group-balance | trial-balance | stock-status | day-book | ledger");
    const report = pos[1];

    var entries: std.ArrayList(json.Value.Entry) = .empty;
    var args_owned = false;
    var args: json.Value = .{ .null = {} };
    defer if (args_owned) args.deinit(alloc);
    const str_flags = [_][]const u8{ "name", "group", "item", "from", "to", "date", "q", "type", "party" };
    for (str_flags) |f| {
        var flag_buf: [24]u8 = undefined;
        const flag = std.fmt.bufPrint(&flag_buf, "--{s}", .{f}) catch continue;
        if (cli.get(flag)) |v| try ops.common.put(alloc, &entries, f, .{ .str = try alloc.dupe(u8, v) });
    }
    if (cli.get("--limit")) |raw| {
        const n = std.fmt.parseInt(i64, raw, 10) catch {
            entries.deinit(alloc);
            return fail(io, alloc, fmt, "bad_args", "invalid --limit (non-negative integer; 0 = unlimited)");
        };
        try ops.common.put(alloc, &entries, "limit", .{ .int = n });
    }
    args = try ops.common.objFrom(alloc, &entries);
    args_owned = true;

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
    openSession(&sess, o) catch |err| {
        var cb: [64]u8 = undefined;
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, helpers.errCode(err, &cb), msg);
    };

    const result = ops.reports.run(&sess, alloc, report, &args) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NotFound)
            "not_found"
        else if (err == error.BadArgs)
            "bad_args"
        else
            helpers.errCode(err, &cb);
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, mach, msg);
    };
    var res = result;
    defer res.deinit(alloc);

    const out_text = switch (fmt) {
        .json => try envelope.opJson(alloc, report, &res),
        .xml => try envelope.opXml(alloc, report, &res),
    };
    defer alloc.free(out_text);
    try printOut(io, alloc, out_text);
    try printOut(io, alloc, "\n");
    return 0;
}

/// M2 write verbs: create/update/delete/post/batch. Fields ride in
/// `--json` / `--json-b64` (PowerShell-safe); the positional name is
/// injected into the args object so the exec dispatcher sees one shape.
fn cmdOpWrite(io: Io, alloc: Allocator, cli: Cli, fmt: Format, pos: []const []const u8, verb: []const u8) !u8 {
    var owned_json: ?[]u8 = null;
    defer if (owned_json) |o| alloc.free(o);
    var json_text: ?[]const u8 = null;
    if (cli.get("--json-b64")) |b| {
        owned_json = b64Decode(alloc, b) catch {
            return fail(io, alloc, fmt, "invalid_base64", "invalid --json-b64 (not valid base64)");
        };
        json_text = owned_json.?;
    } else if (cli.get("--json")) |t| {
        json_text = t;
    }

    var args: json.Value = .{ .obj = &.{} };
    var args_owned = false;
    defer if (args_owned) args.deinit(alloc);
    var op_heap: ?[]u8 = null;
    defer if (op_heap) |o| alloc.free(o);
    var op_name: []const u8 = "";

    if (eql(verb, "batch")) {
        const t = json_text orelse
            return fail(io, alloc, fmt, "bad_args", "op batch requires --json '[{\"op\":\"create-account\",\"args\":{...}}, ...]'");
        args = json.parse(alloc, t) catch |err| {
            var cb: [64]u8 = undefined;
            return fail(io, alloc, fmt, helpers.errCode(err, &cb), @errorName(err));
        };
        args_owned = true;
        if (args != .arr)
            return fail(io, alloc, fmt, "bad_args", "batch --json must be a JSON array of entries");
        op_name = "batch";
    } else if (eql(verb, "post")) {
        const t = json_text orelse
            return fail(io, alloc, fmt, "bad_args", "op post requires --json '{\"type\":\"sale\",\"date\":\"YYYY-MM-DD\",...}' (or {\"type\":\"journal\",\"entries\":[...]})");
        args = json.parse(alloc, t) catch |err| {
            var cb: [64]u8 = undefined;
            return fail(io, alloc, fmt, helpers.errCode(err, &cb), @errorName(err));
        };
        args_owned = true;
        if (args != .obj)
            return fail(io, alloc, fmt, "bad_args", "post --json must be a JSON object");
        op_name = "post-voucher";
    } else {
        // delete voucher <code> — integer key, no JSON
        if (eql(verb, "delete") and pos.len >= 3 and eql(pos[1], "voucher")) {
            const code = std.fmt.parseInt(i64, pos[2], 10) catch
                return fail(io, alloc, fmt, "bad_args", "voucher key must be an integer VchCode");
            var ce: std.ArrayList(json.Value.Entry) = .empty;
            try ops.common.put(alloc, &ce, "code", .{ .int = code });
            args = try ops.common.objFrom(alloc, &ce);
            args_owned = true;
            op_heap = try alloc.dupe(u8, "delete-voucher");
            op_name = op_heap.?;
        } else {
            // create|update|delete <account|item> <name> [--json {fields}]
            if (pos.len < 3)
                return fail(io, alloc, fmt, "bad_args", "op needs: <create|update|delete> <account|item|voucher> <name|code> [--json {\"parent\":\"...\"} (create/update)]");
            const kind = pos[1];
            const name = pos[2];
            if (!(eql(kind, "account") or eql(kind, "item")))
                return fail(io, alloc, fmt, "bad_args", "unknown kind (use account or item)");
            const prefix: []const u8 = if (eql(verb, "create"))
                "create-"
            else if (eql(verb, "update"))
                "update-"
            else
                "delete-";
            op_heap = try std.fmt.allocPrint(alloc, "{s}{s}", .{ prefix, kind });
            op_name = op_heap.?;
            args_owned = true; // we always build the args object below

            var fields: json.Value = .{ .obj = &.{} };
            var fields_owned = false;
            defer if (fields_owned) fields.deinit(alloc);
            if (json_text) |t| {
                fields = json.parse(alloc, t) catch |err| {
                    var cb: [64]u8 = undefined;
                    return fail(io, alloc, fmt, helpers.errCode(err, &cb), @errorName(err));
                };
                fields_owned = true;
                if (fields != .obj)
                    return fail(io, alloc, fmt, "bad_args", "--json must be a JSON object");
            }
            // inject the positional name (it wins over any "name" in --json)
            var name_obj: json.Value = .{ .obj = &.{} };
            defer if (name_obj == .obj and name_obj.obj.len > 0) name_obj.deinit(alloc);
            {
                var ne: std.ArrayList(json.Value.Entry) = .empty;
                try ops.common.put(alloc, &ne, "name", .{ .str = try alloc.dupe(u8, name) });
                name_obj = try ops.common.objFrom(alloc, &ne);
            }
            args = ops.common.mergeRoot(alloc, &fields, &name_obj) catch {
                return fail(io, alloc, fmt, "bad_args", "--json fields must be a JSON object of string values");
            };
            args_owned = true;
        }
    }

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
    openSession(&sess, o) catch |err| {
        var cb: [64]u8 = undefined;
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, helpers.errCode(err, &cb), msg);
    };

    const result = (if (eql(op_name, "batch"))
        ops.batch.run(&sess, alloc, &args)
    else
        ops.exec.run(&sess, alloc, op_name, &args)) catch |err| {
        var cb: [64]u8 = undefined;
        const mach = if (err == error.NotFound)
            "not_found"
        else if (err == error.BadArgs)
            "bad_args"
        else
            helpers.errCode(err, &cb);
        const msg = if (sess.lastError().len > 0) sess.lastError() else @errorName(err);
        return fail(io, alloc, fmt, mach, msg);
    };
    var res = result;
    defer res.deinit(alloc);

    const out_text = switch (fmt) {
        .json => try envelope.opJson(alloc, op_name, &res),
        .xml => try envelope.opXml(alloc, op_name, &res),
    };
    defer alloc.free(out_text);
    try printOut(io, alloc, out_text);
    try printOut(io, alloc, "\n");
    return 0; // args/op_heap freed by defers
}
