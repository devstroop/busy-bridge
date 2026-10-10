//! Day-book + ledger reads (SQL-backed, probe §13): normalized transaction
//! reports straight from Tran1/Tran2 — the working alternative to the
//! JSON-getter row hunt (GetAccDayBookJSON still `{}` behind the ICol
//! wall). Conventions (live-verified on COMP0001): Tran2 `RecType = 1`
//! rows are account lines (`MasterCode1` = account, `Value1` signed with
//! **negative = debit**); `RecType = 2` are item lines (not used here).
//! Tran1.Date compares as a whole OLE day double. Never imports transport.
const std = @import("std");
const json = @import("../util/json.zig");
const helpers = @import("../util/helpers.zig");
const constants = @import("../core/constants.zig");
const com = @import("../core/com.zig");
const common = @import("common.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;

/// ISO/DD-MM/DD-MM-YYYY -> whole OLE day bound for SQL comparisons
/// (BUSY stores midnight-normalized doubles; the fractional part is 0).
pub fn oleDay(iso: []const u8) ?i64 {
    const ole = helpers.dateToOle(iso) orelse return null;
    return @intFromFloat(@round(ole));
}

/// BUSY's signed amount convention: negative = debit, positive = credit.
pub fn splitDrCr(v: f64) struct { dr: f64, cr: f64 } {
    if (v < 0) return .{ .dr = -v, .cr = 0 };
    return .{ .dr = 0, .cr = v };
}

fn num(v: *const json.Value) f64 {
    return switch (v.*) {
        .int => |i| @floatFromInt(i),
        .float => |f| f,
        else => 0,
    };
}

fn badDate(sess: *Session, key: []const u8, raw: []const u8) error{BadArgs} {
    sess.setErr("invalid \"{s}\" '{s}' (expected YYYY-MM-DD)", .{ key, raw });
    return error.BadArgs;
}

/// Row date -> ISO string value (BUSY display form -> normalizeDate).
fn dateOut(alloc: Allocator, cell: ?*const json.Value) !json.Value {
    const dv = cell orelse return .{ .null = {} };
    if (try common.stringifyValue(alloc, dv)) |raw| {
        defer alloc.free(raw);
        if (try common.normalizeDate(alloc, raw)) |iso| return .{ .str = iso };
        return .{ .str = try alloc.dupe(u8, raw) };
    }
    return .{ .null = {} };
}

/// {code, name} value from a Master1 code cell + resolved pairs.
fn namedCode(alloc: Allocator, cell: ?*const json.Value, pairs: []const common.NamePair) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    const cv = cell orelse return common.objFrom(alloc, &e);
    if (cv.* != .int) return common.objFrom(alloc, &e);
    try common.put(alloc, &e, "code", .{ .int = cv.int });
    var found: ?[]const u8 = null;
    for (pairs) |p| if (p.code == cv.int) {
        found = p.name;
        break;
    };
    try common.put(alloc, &e, "name", if (found) |n|
        .{ .str = try alloc.dupe(u8, n) }
    else
        .{ .null = {} });
    return common.objFrom(alloc, &e);
}

pub const BookOpts = struct {
    from: []const u8,
    to: []const u8,
    type_name: ?[]const u8 = null,
    party: ?[]const u8 = null,
    limit: usize = 100,
};

/// Day-book: vouchers in a date range, each with its account lines.
/// `{kind, from, to, count, truncated, totals, items, page}` — see the
/// catalog summary for the exact item shape.
pub fn dayBook(sess: *Session, alloc: Allocator, o: BookOpts) !json.Value {
    const o_from = oleDay(o.from) orelse return badDate(sess, "from", o.from);
    const o_to = oleDay(o.to) orelse return badDate(sess, "to", o.to);
    if (o_from > o_to) {
        sess.setErr("\"from\" {s} is after \"to\" {s}", .{ o.from, o.to });
        return error.BadArgs;
    }

    var filters = std.ArrayList(u8).empty;
    defer filters.deinit(alloc);
    if (o.type_name) |t| {
        const tc = constants.voucherCode(t) orelse {
            sess.setErr("unknown voucher type '{s}' (see GET /constants)", .{t});
            return error.BadArgs;
        };
        const piece = try std.fmt.allocPrint(alloc, " AND VchType = {d}", .{tc});
        defer alloc.free(piece);
        try filters.appendSlice(alloc, piece);
    }
    if (o.party) |p| {
        const code = (try common.codeByName(sess, alloc, constants.masterCode("ACCOUNT_MASTER").?, p)) orelse {
            sess.setErr("no account named '{s}'", .{p});
            return error.NotFound;
        };
        const piece = try std.fmt.allocPrint(alloc, " AND MasterCode1 = {d}", .{code});
        defer alloc.free(piece);
        try filters.appendSlice(alloc, piece);
    }

    // headers: limit+1 probes truncation
    const bounds = try std.fmt.allocPrint(alloc, "Date >= {d} AND Date <= {d}", .{ o_from, o_to });
    defer alloc.free(bounds);
    const hsql = if (o.limit == 0)
        try std.fmt.allocPrint(alloc, "SELECT VchCode, VchType, VchNo, Date, VchSeriesCode, MasterCode1 FROM Tran1 WHERE {s}{s} ORDER BY Date, VchCode", .{ bounds, filters.items })
    else
        try std.fmt.allocPrint(alloc, "SELECT TOP {d} VchCode, VchType, VchNo, Date, VchSeriesCode, MasterCode1 FROM Tran1 WHERE {s}{s} ORDER BY Date, VchCode", .{ o.limit + 1, bounds, filters.items });
    defer alloc.free(hsql);
    const heads = try sess.queryToJson(hsql);
    defer {
        var t = heads;
        t.deinit(sess.alloc);
    }
    if (heads != .arr) return error.UnexpectedRows;

    // all account lines in range (one query; grouped by VchCode in Zig)
    const lsql = try std.fmt.allocPrint(alloc, "SELECT VchCode, SrNo, MasterCode1, Value1, ShortNar FROM Tran2 WHERE RecType = 1 AND {s} ORDER BY VchCode, SrNo", .{bounds});
    defer alloc.free(lsql);
    const lines = try sess.queryToJson(lsql);
    defer {
        var t = lines;
        t.deinit(sess.alloc);
    }
    if (lines != .arr) return error.UnexpectedRows;

    // batch-resolve every name (headers: party + series; lines: accounts)
    var codes: std.ArrayList(i64) = .empty;
    defer codes.deinit(alloc);
    for (heads.arr) |*r| {
        if (r.* != .obj) continue;
        if (r.get("MasterCode1")) |p| if (p.* == .int) try codes.append(alloc, p.int);
        if (r.get("VchSeriesCode")) |s| if (s.* == .int) try codes.append(alloc, s.int);
    }
    for (lines.arr) |*r| {
        if (r.* != .obj) continue;
        if (r.get("MasterCode1")) |a| if (a.* == .int) try codes.append(alloc, a.int);
    }
    const pairs = try common.resolveNames(sess, alloc, codes.items);
    defer common.freePairs(alloc, pairs);

    const truncated = if (o.limit == 0) false else heads.arr.len > o.limit;
    const shown: usize = if (o.limit == 0) heads.arr.len else @min(heads.arr.len, o.limit);

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*it| it.deinit(alloc);
        items.deinit(alloc);
    }
    var tot_dr: f64 = 0;
    var tot_cr: f64 = 0;
    for (heads.arr[0..shown]) |*h| {
        if (h.* != .obj) continue;
        const vch = (h.get("VchCode") orelse return error.UnexpectedRows);
        if (vch.* != .int) continue;
        const vch_code = vch.int;

        var fields: std.ArrayList(json.Value.Entry) = .empty;
        try common.put(alloc, &fields, "code", vch.*);

        var te: std.ArrayList(json.Value.Entry) = .empty;
        if (h.get("VchType")) |tv| if (tv.* == .int) {
            try common.put(alloc, &te, "code", .{ .int = tv.int });
            try common.put(alloc, &te, "name", if (constants.voucherName(tv.int)) |tn|
                .{ .str = try alloc.dupe(u8, tn) }
            else
                .{ .null = {} });
        };
        try common.put(alloc, &fields, "type", try common.objFrom(alloc, &te));

        if (h.get("VchNo")) |nv| {
            const no = if (try common.stringifyValue(alloc, nv)) |s|
                json.Value{ .str = s }
            else
                json.Value{ .null = {} };
            try common.put(alloc, &fields, "no", no);
        }
        try common.put(alloc, &fields, "date", try dateOut(alloc, h.get("Date")));
        try common.put(alloc, &fields, "series", try namedCode(alloc, h.get("VchSeriesCode"), pairs));
        try common.put(alloc, &fields, "party", try namedCode(alloc, h.get("MasterCode1"), pairs));

        var larr: std.ArrayList(json.Value) = .empty;
        defer {
            for (larr.items) |*lv| lv.deinit(alloc);
            larr.deinit(alloc);
        }
        var v_dr: f64 = 0;
        var v_cr: f64 = 0;
        for (lines.arr) |*ln| {
            if (ln.* != .obj) continue;
            const lc = ln.get("VchCode") orelse continue;
            if (lc.* != .int or lc.int != vch_code) continue;
            const v = num(ln.get("Value1") orelse &.{ .null = {} });
            const dc = splitDrCr(v);
            v_dr += dc.dr;
            v_cr += dc.cr;
            var le: std.ArrayList(json.Value.Entry) = .empty;
            try common.put(alloc, &le, "account", try namedCode(alloc, ln.get("MasterCode1"), pairs));
            try common.put(alloc, &le, "value", .{ .float = v });
            try common.put(alloc, &le, "debit", .{ .float = dc.dr });
            try common.put(alloc, &le, "credit", .{ .float = dc.cr });
            if (ln.get("ShortNar")) |nar| {
                if (try common.stringifyValue(alloc, nar)) |s| {
                    defer alloc.free(s);
                    try common.put(alloc, &le, "narration", if (s.len > 0)
                        .{ .str = try alloc.dupe(u8, s) }
                    else
                        .{ .null = {} });
                }
            }
            try larr.append(alloc, try common.objFrom(alloc, &le));
        }
        tot_dr += v_dr;
        tot_cr += v_cr;
        try common.put(alloc, &fields, "lines", .{ .arr = try larr.toOwnedSlice(alloc) });
        var vt: std.ArrayList(json.Value.Entry) = .empty;
        try common.put(alloc, &vt, "debit", .{ .float = v_dr });
        try common.put(alloc, &vt, "credit", .{ .float = v_cr });
        try common.put(alloc, &fields, "totals", try common.objFrom(alloc, &vt));
        try items.append(alloc, try common.objFrom(alloc, &fields));
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "day-book") });
    try common.put(alloc, &out, "from", .{ .str = try alloc.dupe(u8, o.from) });
    try common.put(alloc, &out, "to", .{ .str = try alloc.dupe(u8, o.to) });
    try common.put(alloc, &out, "count", .{ .int = @intCast(items.items.len) });
    try common.put(alloc, &out, "truncated", .{ .bool = truncated });
    var gt: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &gt, "debit", .{ .float = tot_dr });
    try common.put(alloc, &gt, "credit", .{ .float = tot_cr });
    try common.put(alloc, &out, "totals", try common.objFrom(alloc, &gt));
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    var page: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &page, "limit", .{ .int = @intCast(o.limit) });
    try common.put(alloc, &page, "has_more", .{ .bool = truncated });
    try common.put(alloc, &out, "page", try common.objFrom(alloc, &page));
    return common.objFrom(alloc, &out);
}

/// Ledger: one account's rows in a date range with running balance.
/// `value`/`balance` follow BUSY's sign convention (negative = debit
/// side); opening = SUM(Value1) before `from`.
pub fn ledger(sess: *Session, alloc: Allocator, name: []const u8, from: []const u8, to: []const u8, limit: usize) !json.Value {
    const o_from = oleDay(from) orelse return badDate(sess, "from", from);
    const o_to = oleDay(to) orelse return badDate(sess, "to", to);
    if (o_from > o_to) {
        sess.setErr("\"from\" {s} is after \"to\" {s}", .{ from, to });
        return error.BadArgs;
    }
    const code = (try common.codeByName(sess, alloc, constants.masterCode("ACCOUNT_MASTER").?, name)) orelse {
        sess.setErr("no account named '{s}'", .{name});
        return error.NotFound;
    };

    // opening balance (SUM before the range; null -> 0)
    const osql = try std.fmt.allocPrint(alloc, "SELECT SUM(Value1) AS Opening FROM Tran2 WHERE RecType = 1 AND MasterCode1 = {d} AND Date < {d}", .{ code, o_from });
    defer alloc.free(osql);
    const orows = try sess.queryToJson(osql);
    defer {
        var t = orows;
        t.deinit(sess.alloc);
    }
    var opening: f64 = 0;
    if (orows == .arr and orows.arr.len > 0) {
        if (orows.arr[0].get("Opening")) |ov| {
            if (ov.* == .int or ov.* == .float) opening = num(ov);
        }
    }

    // rows in range: limit+1 probes truncation
    const sql = if (limit == 0)
        try std.fmt.allocPrint(alloc, "SELECT VchCode, SrNo, Date, VchType, VchNo, Value1, ShortNar FROM Tran2 WHERE RecType = 1 AND MasterCode1 = {d} AND Date >= {d} AND Date <= {d} ORDER BY Date, VchCode, SrNo", .{ code, o_from, o_to })
    else
        try std.fmt.allocPrint(alloc, "SELECT TOP {d} VchCode, SrNo, Date, VchType, VchNo, Value1, ShortNar FROM Tran2 WHERE RecType = 1 AND MasterCode1 = {d} AND Date >= {d} AND Date <= {d} ORDER BY Date, VchCode, SrNo", .{ limit + 1, code, o_from, o_to });
    defer alloc.free(sql);
    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr) return error.UnexpectedRows;

    const truncated = if (limit == 0) false else rows.arr.len > limit;
    const shown: usize = if (limit == 0) rows.arr.len else @min(rows.arr.len, limit);

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*it| it.deinit(alloc);
        items.deinit(alloc);
    }
    var bal: f64 = opening;
    for (rows.arr[0..shown]) |*r| {
        if (r.* != .obj) continue;
        const v = num(r.get("Value1") orelse &.{ .null = {} });
        const dc = splitDrCr(v);
        bal += v;
        var e: std.ArrayList(json.Value.Entry) = .empty;
        try common.put(alloc, &e, "date", try dateOut(alloc, r.get("Date")));
        var ve: std.ArrayList(json.Value.Entry) = .empty;
        try common.put(alloc, &ve, "code", if (r.get("VchCode")) |c| c.* else .{ .null = {} });
        try common.put(alloc, &ve, "type", blk: {
            var tn_val: json.Value = .{ .null = {} };
            if (r.get("VchType")) |tv| {
                if (tv.* == .int) {
                    if (constants.voucherName(tv.int)) |nm| tn_val = .{ .str = try alloc.dupe(u8, nm) };
                }
            }
            break :blk tn_val;
        });
        if (r.get("VchNo")) |nv| {
            const no = if (try common.stringifyValue(alloc, nv)) |s|
                json.Value{ .str = s }
            else
                json.Value{ .null = {} };
            try common.put(alloc, &ve, "no", no);
        }
        try common.put(alloc, &e, "voucher", try common.objFrom(alloc, &ve));
        try common.put(alloc, &e, "value", .{ .float = v });
        try common.put(alloc, &e, "debit", .{ .float = dc.dr });
        try common.put(alloc, &e, "credit", .{ .float = dc.cr });
        try common.put(alloc, &e, "balance", .{ .float = bal });
        if (r.get("ShortNar")) |nar| {
            if (try common.stringifyValue(alloc, nar)) |s| {
                defer alloc.free(s);
                try common.put(alloc, &e, "narration", if (s.len > 0)
                    .{ .str = try alloc.dupe(u8, s) }
                else
                    .{ .null = {} });
            }
        }
        try items.append(alloc, try common.objFrom(alloc, &e));
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "ledger") });
    var ae: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &ae, "code", .{ .int = code });
    try common.put(alloc, &ae, "name", .{ .str = try alloc.dupe(u8, name) });
    try common.put(alloc, &out, "account", try common.objFrom(alloc, &ae));
    try common.put(alloc, &out, "from", .{ .str = try alloc.dupe(u8, from) });
    try common.put(alloc, &out, "to", .{ .str = try alloc.dupe(u8, to) });
    try common.put(alloc, &out, "opening", .{ .float = opening });
    try common.put(alloc, &out, "closing", .{ .float = bal });
    try common.put(alloc, &out, "count", .{ .int = @intCast(items.items.len) });
    try common.put(alloc, &out, "truncated", .{ .bool = truncated });
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    var page: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &page, "limit", .{ .int = @intCast(limit) });
    try common.put(alloc, &page, "has_more", .{ .bool = truncated });
    try common.put(alloc, &out, "page", try common.objFrom(alloc, &page));
    return common.objFrom(alloc, &out);
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "oleDay converts ISO bounds to whole OLE days" {
    try testing.expectEqual(@as(i64, 46113), oleDay("2026-04-01").?);
    try testing.expectEqual(@as(i64, 46477), oleDay("2027-03-31").?);
    try testing.expect(oleDay("not-a-date") == null);
}

test "splitDrCr follows BUSY sign convention (negative = debit)" {
    const a = splitDrCr(-1500);
    try testing.expectEqual(@as(f64, 1500), a.dr);
    try testing.expectEqual(@as(f64, 0), a.cr);
    const b = splitDrCr(25000);
    try testing.expectEqual(@as(f64, 0), b.dr);
    try testing.expectEqual(@as(f64, 25000), b.cr);
    const z = splitDrCr(0);
    try testing.expectEqual(@as(f64, 0), z.dr + z.cr);
}
