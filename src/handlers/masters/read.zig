//! ERP master reads (issue #7 M1 / 011 phase 1a): normalized list/get —
//! business keys in, codes + names out. Mechanical internals: constants
//! lookup -> escaped SQL on Master1 -> optional GetMasterXML detail
//! parsed to a tree. Shared kinds/type codes live in the barrel
//! (`../masters.zig`); writes live in `write.zig`.
const std = @import("std");
const json = @import("../../util/json.zig");
const xml = @import("../../util/xml.zig");
const helpers = @import("../../util/helpers.zig");
const com = @import("../../core/com.zig");
const constants = @import("../../core/constants.zig");
const common = @import("../common.zig");
const m = @import("../masters.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;
const Kind = m.Kind;
const ListOpts = m.ListOpts;

/// List masters of `kind` normalized to
/// `{kind, count, truncated, items: [{code, name, parent}], page}`.
/// `page` = `{limit, has_more, next_cursor}` (opaque; null cursor on the
/// last page).
pub fn list(sess: *Session, alloc: Allocator, kind: Kind, opts: ListOpts) !json.Value {
    const mt = m.typeCode(kind);
    var keyset: []const u8 = "";
    var keyset_owned: ?[]u8 = null;
    defer if (keyset_owned) |k| alloc.free(k);
    if (opts.cursor) |cur| {
        const decoded = common.decodeCursor(alloc, cur) catch {
            sess.setErr("invalid cursor (use next_cursor from a previous page)", .{});
            return error.BadArgs;
        };
        defer alloc.free(decoded);
        const quoted = try helpers.sqlQuote(alloc, decoded);
        defer alloc.free(quoted);
        const ks = try std.fmt.allocPrint(alloc, " AND Name > '{s}'", .{quoted});
        keyset = ks;
        keyset_owned = ks;
    }
    // SQL-side exact-prefix filter (series type partitions; F3): every
    // fetched row matches, so client-side filtering can't hollow out a page.
    var pf_clause: []const u8 = "";
    var pf_owned: ?[]u8 = null;
    defer if (pf_owned) |p| alloc.free(p);
    if (opts.name_prefix) |pf| {
        pf_owned = try prefixClause(alloc, pf);
        pf_clause = pf_owned.?;
    }
    // limit=0 = unlimited: no TOP clause at all
    var top_owned: ?[]u8 = null;
    defer if (top_owned) |t| alloc.free(t);
    var top: []const u8 = "";
    if (opts.limit != 0) {
        top_owned = try std.fmt.allocPrint(alloc, "TOP {d} ", .{opts.limit + 1});
        top = top_owned.?;
    }
    const sql = if (opts.q == null)
        // fetch limit+1 so "more rows exist" is detectable without a COUNT
        try std.fmt.allocPrint(alloc, "SELECT {s}Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d}{s}{s} ORDER BY Name", .{ top, mt, keyset, pf_clause })
    else
        try std.fmt.allocPrint(alloc, "SELECT Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d}{s}{s} ORDER BY Name", .{ mt, keyset, pf_clause });
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr) return error.UnexpectedRows;

    // filter (client-side q) + parent-code collection
    var matched: std.ArrayList(usize) = .empty; // indices into rows.arr
    defer matched.deinit(alloc);
    var parent_codes: std.ArrayList(i64) = .empty;
    defer parent_codes.deinit(alloc);
    for (rows.arr, 0..) |*r, idx| {
        if (r.* != .obj) continue;
        const name_v = r.get("Name") orelse continue;
        if (opts.q) |q| {
            if (name_v.* != .str or !common.containsCi(name_v.str, q)) continue;
        }
        try matched.append(alloc, idx);
        if (r.get("ParentGrp")) |p| {
            if (p.* == .int) try parent_codes.append(alloc, p.int);
        }
    }

    const pairs = try common.resolveNames(sess, alloc, parent_codes.items);
    defer common.freePairs(alloc, pairs);

    const truncated = if (opts.limit == 0) false else matched.items.len > opts.limit;
    const shown: usize = if (opts.limit == 0) matched.items.len else @min(matched.items.len, opts.limit);

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*v| v.deinit(alloc);
        items.deinit(alloc);
    }
    for (matched.items[0..shown]) |idx| {
        const r = &rows.arr[idx];
        var fields: std.ArrayList(json.Value.Entry) = .empty;
        const code = (r.get("Code") orelse return error.UnexpectedRows).*;
        try common.put(alloc, &fields, "code", code);
        const name = (r.get("Name") orelse return error.UnexpectedRows).*;
        const name_text = if (try common.stringifyValue(alloc, &name)) |s|
            json.Value{ .str = s }
        else
            json.Value{ .null = {} };
        try common.put(alloc, &fields, "name", name_text);
        // parent: resolved group {code, name} or null
        var parent_val: json.Value = .{ .null = {} };
        if (r.get("ParentGrp")) |p| {
            if (p.* == .int) {
                var pe: std.ArrayList(json.Value.Entry) = .empty;
                try common.put(alloc, &pe, "code", .{ .int = p.int });
                if (common.findName(pairs, p.int)) |pn| {
                    try common.put(alloc, &pe, "name", .{ .str = try alloc.dupe(u8, pn) });
                } else {
                    try common.put(alloc, &pe, "name", .{ .null = {} });
                }
                parent_val = try common.objFrom(alloc, &pe);
            }
        }
        try common.put(alloc, &fields, "parent", parent_val);
        try items.append(alloc, try common.objFrom(alloc, &fields));
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, m.kindName(kind)) });
    try common.put(alloc, &out, "count", .{ .int = @intCast(shown) });
    try common.put(alloc, &out, "truncated", .{ .bool = truncated });
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    // page envelope (issue #7 /v1): next_cursor = base64url(last shown Name)
    var page: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &page, "limit", .{ .int = @intCast(opts.limit) });
    try common.put(alloc, &page, "has_more", .{ .bool = truncated });
    if (truncated and shown > 0) {
        const last = rows.arr[matched.items[shown - 1]].get("Name") orelse return error.UnexpectedRows;
        if (try common.stringifyValue(alloc, last)) |last_name| {
            defer alloc.free(last_name);
            try common.put(alloc, &page, "next_cursor", .{ .str = try common.encodeCursor(alloc, last_name) });
        } else {
            try common.put(alloc, &page, "next_cursor", .{ .null = {} });
        }
    } else {
        try common.put(alloc, &page, "next_cursor", .{ .null = {} });
    }
    try common.put(alloc, &out, "page", try common.objFrom(alloc, &page));
    return common.objFrom(alloc, &out);
}

/// Fetch one master by exact business name:
/// `{kind, code, name, parent, doc}` — `doc` is the full GetMasterXML
/// document tree (null when BUSY returns none).
pub fn get(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8) !json.Value {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ m.typeCode(kind), quoted });
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr or rows.arr.len == 0) {
        sess.setErr("no {s} named '{s}'", .{ m.kindName(kind), name });
        return error.NotFound;
    }
    const row = &rows.arr[0];
    const code = (row.get("Code") orelse return error.UnexpectedRows).*;
    const canonical = (row.get("Name") orelse return error.UnexpectedRows).*;

    var parent_val: json.Value = .{ .null = {} };
    if (row.get("ParentGrp")) |p| {
        if (p.* == .int) {
            var codes = [_]i64{p.int};
            const pairs = try common.resolveNames(sess, alloc, &codes);
            defer common.freePairs(alloc, pairs);
            var pe: std.ArrayList(json.Value.Entry) = .empty;
            try common.put(alloc, &pe, "code", .{ .int = p.int });
            if (common.findName(pairs, p.int)) |pn| {
                try common.put(alloc, &pe, "name", .{ .str = try alloc.dupe(u8, pn) });
            } else {
                try common.put(alloc, &pe, "name", .{ .null = {} });
            }
            parent_val = try common.objFrom(alloc, &pe);
        }
    }

    // full detail document — parsed to a tree, never a blob
    var doc_val: json.Value = .{ .null = {} };
    if (code == .int) {
        var r = try sess.invoke("GetMasterXML", &.{ .{ .int = code.int }, .{ .bool = false } });
        defer r.deinit(sess.alloc);
        if (r.ret == .str and r.ret.str.len > 0 and r.ret.str[0] == '<') {
            if (xml.parse(alloc, r.ret.str)) |el| {
                var doc = el;
                defer doc.deinit(alloc);
                doc_val = xml.toJson(alloc, &doc) catch .{ .null = {} };
            } else |_| {}
        }
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, m.kindName(kind)) });
    try common.put(alloc, &out, "code", code);
    // canonical name lives in session-owned rows — copy before those free
    if (canonical == .str) {
        try common.put(alloc, &out, "name", .{ .str = try alloc.dupe(u8, canonical.str) });
    } else {
        try common.put(alloc, &out, "name", .{ .null = {} });
    }
    try common.put(alloc, &out, "parent", parent_val);
    try common.put(alloc, &out, "doc", doc_val);
    return common.objFrom(alloc, &out);
}

/// Voucher-series options: the `list` shape plus BUSY's type-partitioned
/// name handling (see `seriesList`).
pub const SeriesOpts = struct {
    limit: usize = 100,
    q: ?[]const u8 = null,
    cursor: ?[]const u8 = null,
    /// Canonical voucher type (e.g. `sale`): rows are filtered to that
    /// type's partition and the stored 2-digit prefix is stripped from
    /// `name`. Null returns names exactly as stored (`09ZigVch9`).
    type_name: ?[]const u8 = null,
};

/// Pure prefix match: the bare series name when `name` starts with
/// `prefix`, else null. Live fixture: `CreateVchSeries("ZigVch9", 9)`
/// stores `09ZigVch9` — BUSY partitions series by voucher type, so all
/// rows of one type sort together under their 2-digit prefix.
pub fn seriesOf(name: []const u8, prefix: []const u8) ?[]const u8 {
    if (prefix.len == 0 or !std.mem.startsWith(u8, name, prefix)) return null;
    return name[prefix.len..];
}

/// Zero-padded 2-digit type prefix for a voucher code: 9 → `"09"`,
/// 10 → `"10"`, 32 → `"32"`. null = out of range (callers answer a
/// precise BadArgs). Pure so the ≥10 code path is unit-testable (F5) —
/// `std.fmt` width specs no longer zero-pad on Zig 0.17, hence digits.
pub fn seriesPrefix(code: i64) ?[2]u8 {
    if (code < 0 or code > 99) return null;
    const tens: u8 = @intCast(@divTrunc(code, 10));
    const ones: u8 = @intCast(@mod(code, 10));
    return .{ '0' + tens, '0' + ones };
}

/// SQL fragment for an exact-prefix filter (owned; DAO wildcard `*` —
/// `%` silently matches nothing, WP2 probe).
fn prefixClause(alloc: Allocator, prefix: []const u8) ![]u8 {
    const quoted = try helpers.sqlQuote(alloc, prefix);
    defer alloc.free(quoted);
    return std.fmt.allocPrint(alloc, " AND Name LIKE '{s}*'", .{quoted});
}

/// Voucher series (MasterType 21) as a picker list: the same envelope as
/// `list` (`{kind:"series", count, truncated, items, page}`), optionally
/// filtered to one voucher type with prefix-free names. With `type_name`
/// the partition is filtered SQL-side (`Name LIKE '09*'` — DAO's `*`
/// wildcard), so the keyset cursor pages through matching rows only:
/// every page is full and `page.has_more` is accurate (WP1 review F3;
/// enabled by the WP2 probe that proved `*`, not `%`, is the wildcard).
pub fn seriesList(sess: *Session, alloc: Allocator, opts: SeriesOpts) !json.Value {
    var prefix: ?[]u8 = null;
    defer if (prefix) |p| alloc.free(p);
    if (opts.type_name) |tn| {
        const code = constants.voucherCode(tn) orelse {
            sess.setErr("unknown voucher type '{s}' (canonical name, e.g. sale)", .{tn});
            return error.BadArgs;
        };
        // BUSY stores a zero-padded 2-digit type prefix (SALE=9 -> "09";
        // codes >= 10 keep both digits) — digits come from the pure,
        // unit-tested seriesPrefix (F5).
        const pp = seriesPrefix(code) orelse {
            sess.setErr("voucher type '{s}' has an out-of-range code", .{tn});
            return error.BadArgs;
        };
        prefix = try alloc.dupe(u8, &pp);
    }
    var v = try list(sess, alloc, .voucher_series, .{ .limit = opts.limit, .q = opts.q, .cursor = opts.cursor, .name_prefix = prefix });
    errdefer v.deinit(alloc);
    const p = prefix orelse return v;
    if (v != .obj) return error.UnexpectedRows;

    // mutable entry pointers (Value.get is const by contract)
    var items_e: ?*json.Value.Entry = null;
    var count_e: ?*json.Value.Entry = null;
    for (v.obj) |*e| {
        if (std.mem.eql(u8, e.key, "items")) items_e = e;
        if (std.mem.eql(u8, e.key, "count")) count_e = e;
    }
    const items_val: *json.Value = &(items_e orelse return error.UnexpectedRows).val;
    if (items_val.* != .arr) return error.UnexpectedRows;
    const old_arr = items_val.arr;
    var kept: std.ArrayList(json.Value) = .empty;
    var dropped: std.ArrayList(json.Value) = .empty;
    defer kept.deinit(alloc);
    defer dropped.deinit(alloc);
    for (old_arr) |*item| {
        if (item.* != .obj) continue;
        var matched = false;
        for (item.obj) |*e| {
            if (!std.mem.eql(u8, e.key, "name")) continue;
            if (e.val != .str) break;
            const bare = seriesOf(e.val.str, p) orelse break;
            if (bare.len != e.val.str.len) {
                const owned = try alloc.dupe(u8, bare);
                alloc.free(e.val.str);
                e.val.str = owned;
            }
            matched = true;
            break;
        }
        if (matched)
            try kept.append(alloc, item.*)
        else
            try dropped.append(alloc, item.*); // shallow; strings stay in old_arr for now
    }
    const kept_len = kept.items.len;
    // From here on nothing can fail: ownership moves, then the shell swaps.
    const new_arr = try kept.toOwnedSlice(alloc);
    for (dropped.items) |*d| d.deinit(alloc);
    alloc.free(old_arr); // the slice only — kept items moved, dropped freed above
    items_val.arr = new_arr;
    if (count_e) |ce| {
        if (ce.val == .int) ce.val.int = @intCast(kept_len);
    }
    return v;
}

test "seriesOf strips only a matching type prefix" {
    const testing = std.testing;
    try testing.expectEqualStrings("ZigVch9", seriesOf("09ZigVch9", "09").?);
    try testing.expectEqualStrings("", seriesOf("09", "09").?);
    try testing.expect(seriesOf("Main", "09") == null);
    try testing.expect(seriesOf("09ZigVch9", "08") == null);
    try testing.expect(seriesOf("09ZigVch9", "") == null);
    // two-digit prefixes (codes >= 10) — live rows: 10Main … 32Main
    try testing.expectEqualStrings("Main", seriesOf("10Main", "10").?);
    try testing.expectEqualStrings("ZigVch9", seriesOf("32ZigVch9", "32").?);
    try testing.expect(seriesOf("19Main", "10") == null);
    try testing.expect(seriesOf("09ZigVch9", "10") == null);
}

test "seriesPrefix builds zero-padded two-digit codes (F5)" {
    const testing = std.testing;
    const p9 = seriesPrefix(9).?;
    const p5 = seriesPrefix(5).?;
    const p0 = seriesPrefix(0).?;
    try testing.expectEqualStrings("09", &p9);
    try testing.expectEqualStrings("05", &p5);
    try testing.expectEqualStrings("00", &p0);
    // >= 10: both digits explicit (std.fmt width no longer zero-pads)
    const p10 = seriesPrefix(10).?;
    const p16 = seriesPrefix(16).?;
    const p32 = seriesPrefix(32).?;
    const p99 = seriesPrefix(99).?;
    try testing.expectEqualStrings("10", &p10);
    try testing.expectEqualStrings("16", &p16);
    try testing.expectEqualStrings("32", &p32);
    try testing.expectEqualStrings("99", &p99);
    // out of range -> null (callers answer BadArgs)
    try testing.expect(seriesPrefix(-1) == null);
    try testing.expect(seriesPrefix(100) == null);
    // round-trip through the stripper the picker uses
    try testing.expectEqualStrings("Main", seriesOf("10Main", &p10).?);
}

test "prefixClause renders the DAO star wildcard" {
    const testing = std.testing;
    const a = testing.allocator;
    const c = try prefixClause(a, "09");
    defer a.free(c);
    try testing.expectEqualStrings(" AND Name LIKE '09*'", c);
}
