//! Named report operations (issue #7 M3): balances and stock status as
//! normalized ERP reads. Mechanical internals: name -> code lookup, then
//! the services/fixed-interface report methods with typed out-param
//! boxes ({"$byref":"f8"}) and {"$date":...} VT_DATE inputs — probe-
//! verified signatures are recorded at each fn. Never imports transport.
const std = @import("std");
const json = @import("../util/json.zig");
const helpers = @import("../util/helpers.zig");
const constants = @import("../core/constants.zig");
const com = @import("../core/com.zig");
const common = @import("common.zig");
const masters = @import("masters.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;

/// Dispatch one named report with a JSON-args object (shared by CLI and
/// HTTP — one validation path, precise session messages -> bad_args).
pub fn run(sess: *Session, alloc: Allocator, report: []const u8, args: *const json.Value) !json.Value {
    if (args.* != .obj) {
        sess.setErr("report args must be a JSON object", .{});
        return error.BadArgs;
    }
    if (std.mem.eql(u8, report, "account-balance")) {
        const name = try masters.requireStr(sess, args, "name", "account-balance requires \"name\" (account)");
        const from = try requireDate(sess, args, "from", "account-balance requires \"from\" (YYYY-MM-DD)");
        const to = try requireDate(sess, args, "to", "account-balance requires \"to\" (YYYY-MM-DD)");
        return accountBalance(sess, alloc, name, from, to);
    }
    if (std.mem.eql(u8, report, "group-balance")) {
        const name = try masters.requireStr(sess, args, "group", "group-balance requires \"group\" (account group name)");
        const from = try requireDate(sess, args, "from", "group-balance requires \"from\" (YYYY-MM-DD)");
        const to = try requireDate(sess, args, "to", "group-balance requires \"to\" (YYYY-MM-DD)");
        return groupBalance(sess, alloc, name, from, to);
    }
    if (std.mem.eql(u8, report, "trial-balance")) {
        const from = try requireDate(sess, args, "from", "trial-balance requires \"from\" (YYYY-MM-DD)");
        const to = try requireDate(sess, args, "to", "trial-balance requires \"to\" (YYYY-MM-DD)");
        return trialBalance(sess, alloc, from, to);
    }
    if (std.mem.eql(u8, report, "stock-status")) {
        const date = try requireDate(sess, args, "date", "stock-status requires \"date\" (YYYY-MM-DD)");
        var limit: usize = 100;
        if (args.get("limit")) |l| {
            if (l.* != .int or l.int < 0) {
                sess.setErr("\"limit\" must be a non-negative integer (0 = unlimited)", .{});
                return error.BadArgs;
            }
            limit = @intCast(l.int);
        }
        const q: ?[]const u8 = if (args.get("q")) |qv| (if (qv.* == .str) qv.str else null) else null;
        const item: ?[]const u8 = if (args.get("item")) |iv| (if (iv.* == .str) iv.str else null) else null;
        return stockStatus(sess, alloc, date, limit, q, item);
    }
    sess.setErr("unknown report '{s}' (account-balance | group-balance | trial-balance | stock-status)", .{report});
    return error.BadArgs;
}

/// Validate a date field (ISO / DD-MM-YYYY / DD/MM/YYYY). Returns the
/// BORROWED slice — callers dupe when echoing into results.
fn requireDate(sess: *Session, args: *const json.Value, key: []const u8, msg: []const u8) ![]const u8 {
    const raw = try masters.requireStr(sess, args, key, msg);
    if (helpers.dateToOle(raw) == null) {
        sess.setErr("invalid \"{s}\" '{s}' (expected YYYY-MM-DD)", .{ key, raw });
        return error.BadArgs;
    }
    return raw;
}

fn byrefMarker(alloc: Allocator, tag: []const u8) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "$byref", .{ .str = try alloc.dupe(u8, tag) });
    return common.objFrom(alloc, &e);
}

fn dateArg(alloc: Allocator, iso: []const u8) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "$date", .{ .str = try alloc.dupe(u8, iso) });
    return common.objFrom(alloc, &e);
}

fn outF64(outs: []const json.Value, i: usize) f64 {
    if (i >= outs.len) return 0;
    return switch (outs[i]) {
        .float => |f| f,
        .int => |v| @floatFromInt(v),
        else => 0,
    };
}

/// Single account opening/closing balance.
/// GetAccOpeningClosingBalDateWise (CMasterServices) — probe-verified:
/// [code, $date end, f8, f8, $date start] -> outs [opening, closing].
pub fn accountBalance(sess: *Session, alloc: Allocator, name: []const u8, from: []const u8, to: []const u8) !json.Value {
    const code = (try common.codeByName(sess, alloc, constants.masterCode("ACCOUNT_MASTER").?, name)) orelse {
        sess.setErr("no account named '{s}'", .{name});
        return error.NotFound;
    };
    // the method lives on CMasterServices — transient session (the
    // company state is shared in-process; probe-verified in M2)
    const prog = try common.classProgId(alloc, "CMasterServices");
    defer alloc.free(prog);
    var ts = try Session.init(sess.alloc);
    defer ts.deinit();
    try ts.create(prog);
    var b1 = try byrefMarker(alloc, "f8");
    defer b1.deinit(alloc);
    var b2 = try byrefMarker(alloc, "f8");
    defer b2.deinit(alloc);
    var d_end = try dateArg(alloc, to);
    defer d_end.deinit(alloc);
    var d_start = try dateArg(alloc, from);
    defer d_start.deinit(alloc);
    var a = [_]json.Value{ .{ .int = code }, d_end, b1, b2, d_start };
    var r = try ts.invoke("GetAccOpeningClosingBalDateWise", &a);
    defer r.deinit(ts.alloc);

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "account-balance") });
    try common.put(alloc, &out, "account", .{ .str = try alloc.dupe(u8, name) });
    try common.put(alloc, &out, "code", .{ .int = code });
    try common.put(alloc, &out, "from", .{ .str = try alloc.dupe(u8, from) });
    try common.put(alloc, &out, "to", .{ .str = try alloc.dupe(u8, to) });
    try common.put(alloc, &out, "opening", .{ .float = outF64(r.outs, 0) });
    try common.put(alloc, &out, "closing", .{ .float = outF64(r.outs, 1) });
    return common.objFrom(alloc, &out);
}

/// Group balance incl. children for a period.
/// GetAccGrpBalances (CMasterServices) — probe-verified:
/// [code, $date from, $date to, f8, f8, f8, directChild=false, vsGrp=0]
/// -> outs [opening, debit, credit].
pub fn groupBalance(sess: *Session, alloc: Allocator, name: []const u8, from: []const u8, to: []const u8) !json.Value {
    const code = (try common.codeByName(sess, alloc, constants.masterCode("ACCOUNT_GROUP_MASTER").?, name)) orelse {
        sess.setErr("no account group named '{s}'", .{name});
        return error.NotFound;
    };
    return groupBalanceByCode(sess, alloc, name, code, from, to);
}

fn groupBalanceByCode(sess: *Session, alloc: Allocator, name: []const u8, code: i64, from: []const u8, to: []const u8) !json.Value {
    // GetAccGrpBalances lives on CMasterServices — transient session
    const prog = try common.classProgId(alloc, "CMasterServices");
    defer alloc.free(prog);
    var ts = try Session.init(sess.alloc);
    defer ts.deinit();
    try ts.create(prog);
    var b1 = try byrefMarker(alloc, "f8");
    defer b1.deinit(alloc);
    var b2 = try byrefMarker(alloc, "f8");
    defer b2.deinit(alloc);
    var b3 = try byrefMarker(alloc, "f8");
    defer b3.deinit(alloc);
    var d_start = try dateArg(alloc, from);
    defer d_start.deinit(alloc);
    var d_end = try dateArg(alloc, to);
    defer d_end.deinit(alloc);
    var a = [_]json.Value{
        .{ .int = code },
        d_start,
        d_end,
        b1,
        b2,
        b3,
        .{ .bool = false }, // include children
        .{ .int = 0 }, // voucher-series group: none
    };
    var r = try ts.invoke("GetAccGrpBalances", &a);
    defer r.deinit(ts.alloc);

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "group-balance") });
    try common.put(alloc, &out, "group", .{ .str = try alloc.dupe(u8, name) });
    try common.put(alloc, &out, "code", .{ .int = code });
    try common.put(alloc, &out, "from", .{ .str = try alloc.dupe(u8, from) });
    try common.put(alloc, &out, "to", .{ .str = try alloc.dupe(u8, to) });
    try common.put(alloc, &out, "opening", .{ .float = outF64(r.outs, 0) });
    try common.put(alloc, &out, "debit", .{ .float = outF64(r.outs, 1) });
    try common.put(alloc, &out, "credit", .{ .float = outF64(r.outs, 2) });
    return common.objFrom(alloc, &out);
}

/// Trial balance: every root account group (ParentGrp = 0) with its
/// period movement, plus book totals. NOTE (live-verified): BUSY's
/// debit column is SIGNED — a debit leg can surface as a negative
/// number at some roots — so the invariant is totals.debit ==
/// -totals.credit, not equality of the raw columns.
pub fn trialBalance(sess: *Session, alloc: Allocator, from: []const u8, to: []const u8) !json.Value {
    const sql = "SELECT Code, Name FROM Master1 WHERE MasterType = 1 AND ParentGrp = 0 ORDER BY Name";
    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr) return error.UnexpectedRows;

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*v| v.deinit(alloc);
        items.deinit(alloc);
    }
    var t_open: f64 = 0;
    var t_debit: f64 = 0;
    var t_credit: f64 = 0;
    for (rows.arr) |*rr| {
        if (rr.* != .obj) continue;
        const code_v = (rr.get("Code") orelse continue).*;
        const name_v = (rr.get("Name") orelse continue).*;
        if (code_v != .int or name_v != .str) continue;
        const row = try groupBalanceByCode(sess, alloc, name_v.str, code_v.int, from, to);
        var row_mut = row;
        t_open += f64Field(&row_mut, "opening");
        t_debit += f64Field(&row_mut, "debit");
        t_credit += f64Field(&row_mut, "credit");
        try items.append(alloc, row_mut);
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "trial-balance") });
    try common.put(alloc, &out, "from", .{ .str = try alloc.dupe(u8, from) });
    try common.put(alloc, &out, "to", .{ .str = try alloc.dupe(u8, to) });
    try common.put(alloc, &out, "count", .{ .int = @intCast(items.items.len) });
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    var totals: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &totals, "opening", .{ .float = t_open });
    try common.put(alloc, &totals, "debit", .{ .float = t_debit });
    try common.put(alloc, &totals, "credit", .{ .float = t_credit });
    try common.put(alloc, &out, "totals", try common.objFrom(alloc, &totals));
    return common.objFrom(alloc, &out);
}

fn f64Field(v: *json.Value, key: []const u8) f64 {
    if (v.* != .obj) return 0;
    const f = v.get(key) orelse return 0;
    return switch (f.*) {
        .float => |x| x,
        .int => |i| @floatFromInt(i),
        else => 0,
    };
}

/// Stock status at a date, per item.
/// GetItemValue (CFixedInterface itself) — probe-verified full form:
/// [code, $date, mc=0(all), opTrial=false, svp, svm, bookOnly=false,
/// f8, f8] -> outs [mainQty, altQty].
pub fn stockStatus(
    sess: *Session,
    alloc: Allocator,
    date: []const u8,
    limit: usize,
    q: ?[]const u8,
    item: ?[]const u8,
) !json.Value {
    const sql = if (q == null and item == null)
        try std.fmt.allocPrint(alloc, "SELECT TOP {d} Code, Name FROM Master1 WHERE MasterType = {d} ORDER BY Name", .{ limit + 1, constants.masterCode("ITEM_MASTER").? })
    else
        try std.fmt.allocPrint(alloc, "SELECT Code, Name FROM Master1 WHERE MasterType = {d} ORDER BY Name", .{constants.masterCode("ITEM_MASTER").?});
    defer alloc.free(sql);
    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr) return error.UnexpectedRows;

    var matched: std.ArrayList(usize) = .empty;
    defer matched.deinit(alloc);
    for (rows.arr, 0..) |*rr, idx| {
        if (rr.* != .obj) continue;
        const name_v = rr.get("Name") orelse continue;
        if (item) |want| {
            if (name_v.* != .str or !std.mem.eql(u8, name_v.str, want)) continue;
        } else if (q) |filter| {
            if (name_v.* != .str or !common.containsCi(name_v.str, filter)) continue;
        }
        try matched.append(alloc, idx);
    }

    const truncated = if (limit == 0) false else matched.items.len > limit;
    const shown: usize = if (limit == 0) matched.items.len else @min(matched.items.len, limit);

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*v| v.deinit(alloc);
        items.deinit(alloc);
    }
    for (matched.items[0..shown]) |idx| {
        const rr = &rows.arr[idx];
        const code = (rr.get("Code") orelse return error.UnexpectedRows).*;
        const name_v = (rr.get("Name") orelse return error.UnexpectedRows).*;
        if (code != .int or name_v != .str) continue;

        var d = try dateArg(alloc, date);
        defer d.deinit(alloc);
        var q1 = try byrefMarker(alloc, "f8");
        defer q1.deinit(alloc);
        var q2 = try byrefMarker(alloc, "f8");
        defer q2.deinit(alloc);
        var a = [_]json.Value{
            code,
            d,
            .{ .int = 0 }, // material center: 0 = all stores
            .{ .bool = false },
            .{ .float = 0 },
            .{ .float = 0 },
            .{ .bool = false },
            q1,
            q2,
        };
        var r = try sess.invoke("GetItemValue", &a);
        defer r.deinit(sess.alloc);

        var e: std.ArrayList(json.Value.Entry) = .empty;
        try common.put(alloc, &e, "code", code);
        try common.put(alloc, &e, "name", .{ .str = try alloc.dupe(u8, name_v.str) });
        try common.put(alloc, &e, "qty_main", .{ .float = outF64(r.outs, 0) });
        try common.put(alloc, &e, "qty_alt", .{ .float = outF64(r.outs, 1) });
        try items.append(alloc, try common.objFrom(alloc, &e));
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "stock-status") });
    try common.put(alloc, &out, "date", .{ .str = try alloc.dupe(u8, date) });
    try common.put(alloc, &out, "count", .{ .int = @intCast(items.items.len) });
    try common.put(alloc, &out, "truncated", .{ .bool = truncated });
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    return common.objFrom(alloc, &out);
}

// ---------------- tests (pure validation) ----------------

const testing = std.testing;

test "run validates report names and required fields" {
    const a = testing.allocator;
    var sess = try Session.init(a);
    defer sess.deinit();

    var empty = try json.parse(a, "{}");
    defer empty.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, "nonsense", &empty));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "account-balance") != null);
    // missing required date fields -> precise message
    var acc = try json.parse(a, "{\"name\":\"Cash\"}");
    defer acc.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, "account-balance", &acc));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "\"from\"") != null);
    // invalid date format
    var bad_date = try json.parse(a, "{\"name\":\"Cash\",\"from\":\"nope\",\"to\":\"2027-03-31\"}");
    defer bad_date.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, "account-balance", &bad_date));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "YYYY-MM-DD") != null);
    // stock-status rejects bad limit
    var bad_limit = try json.parse(a, "{\"date\":\"2026-10-09\",\"limit\":-1}");
    defer bad_limit.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, "stock-status", &bad_limit));
}

test "requireDate accepts BUSY and ISO forms" {
    const a = testing.allocator;
    var sess = try Session.init(a);
    defer sess.deinit();
    var args = try json.parse(a, "{\"d\":\"08-10-2026\"}");
    defer args.deinit(a);
    const v = try requireDate(&sess, &args, "d", "x");
    try testing.expectEqualStrings("08-10-2026", v);
}
