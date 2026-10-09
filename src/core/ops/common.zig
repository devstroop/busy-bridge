//! Mechanical glue shared by the ERP operations (facade M1, issue #7).
//! Pure helpers are unit-tested without BUSY; the two session helpers
//! (query/name resolution) live here because every op uses them.
//! Never imports transport.
const std = @import("std");
const json = @import("../../util/json.zig");
const helpers = @import("../../util/helpers.zig");
const registry = @import("../registry.zig");
const Session = @import("../com.zig").Session;

const Allocator = std.mem.Allocator;

/// Append `{key: v}` with an owned key copy (Value.deinit frees keys).
pub fn put(
    alloc: Allocator,
    list: *std.ArrayList(json.Value.Entry),
    key: []const u8,
    v: json.Value,
) !void {
    try list.append(alloc, .{ .key = try alloc.dupe(u8, key), .val = v });
}

/// Finish an object from accumulated entries.
pub fn objFrom(alloc: Allocator, list: *std.ArrayList(json.Value.Entry)) !json.Value {
    return .{ .obj = try list.toOwnedSlice(alloc) };
}

/// Scalar -> owned text (null for objects/arrays — caller keeps raw or
/// omits). Integral floats print without a decimal point. Strings are
/// trimmed: BUSY fixed-width text columns come back space-padded (found
/// live: Tran1.VchNo -> "                      902").
pub fn stringifyValue(alloc: Allocator, v: *const json.Value) anyerror!?[]u8 {
    switch (v.*) {
        .str => |s| return try alloc.dupe(u8, std.mem.trim(u8, s, " \t\r\n\x0B\x0C")),
        .int => |i| {
            var b: [24]u8 = undefined;
            return try alloc.dupe(u8, try std.fmt.bufPrint(&b, "{d}", .{i}));
        },
        .float => |f| {
            var b: [32]u8 = undefined;
            if (@trunc(f) == f) {
                return try alloc.dupe(u8, try std.fmt.bufPrint(&b, "{d}", .{@as(i64, @intFromFloat(f))}));
            }
            return try alloc.dupe(u8, try std.fmt.bufPrint(&b, "{d}", .{f}));
        },
        .bool => |b| return try alloc.dupe(u8, if (b) "true" else "false"),
        else => return null,
    }
}

/// Case-insensitive substring — `q` filters run client-side because BUSY's
/// GetRecordset silently returns empty for LIKE predicates (issue #6).
pub fn containsCi(hay: []const u8, needle: []const u8) bool {
    if (needle.len == 0) return true;
    if (needle.len > hay.len) return false;
    var i: usize = 0;
    while (i + needle.len <= hay.len) : (i += 1) {
        if (std.ascii.eqlIgnoreCase(hay[i .. i + needle.len], needle)) return true;
    }
    return false;
}

/// Date -> ISO `YYYY-MM-DD`. Accepts BUSY's display forms `DD/MM/YYYY`
/// and `DD-MM-YYYY`, passes ISO through; anything else returns null
/// (caller keeps the raw text — robustness over strictness).
pub fn normalizeDate(alloc: Allocator, s: []const u8) anyerror!?[]u8 {
    if (s.len == 10 and s[4] == '-' and s[7] == '-') return try alloc.dupe(u8, s); // already ISO
    if (s.len == 10 and (s[2] == '/' or s[2] == '-') and s[5] == s[2]) {
        return try std.fmt.allocPrint(alloc, "{s}-{s}-{s}", .{ s[6..10], s[3..5], s[0..2] });
    }
    return null;
}

/// Inverse: ISO `YYYY-MM-DD` (or already-BUSY `DD-MM-YYYY`/`DD/MM/YYYY`)
/// -> BUSY's write format `DD-MM-YYYY` (what SaveVchFromXML expects —
/// the vendor templates and every live write used dashes).
pub fn toBusyDate(alloc: Allocator, s: []const u8) anyerror!?[]u8 {
    if (s.len == 10 and s[2] == '-' and s[5] == '-' and s[6] >= '0' and s[6] <= '9')
        return try alloc.dupe(u8, s); // already DD-MM-YYYY
    if (s.len == 10 and s[2] == '/' and s[5] == '/' and s[6] >= '0' and s[6] <= '9')
        return try std.fmt.allocPrint(alloc, "{s}-{s}-{s}", .{ s[0..2], s[3..5], s[6..10] });
    if (s.len == 10 and s[4] == '-' and s[7] == '-') // ISO
        return try std.fmt.allocPrint(alloc, "{s}-{s}-{s}", .{ s[8..10], s[5..7], s[0..4] });
    return null;
}

/// Merge `src` fields into a deep copy of `dst` (both objects): every
/// top-level key of `src` overwrites/creates in the result. Used by
/// update ops — we fetch the FULL existing document, merge only the
/// requested changes, and re-save, so BUSY never wipes untouched fields.
/// `dst`/`src` are borrowed; the result is owned by `alloc`.
pub fn mergeRoot(alloc: Allocator, dst: *const json.Value, src: *const json.Value) !json.Value {
    if (dst.* != .obj or src.* != .obj) return error.BadDocument;
    var out: std.ArrayList(json.Value.Entry) = .empty;
    errdefer {
        var tmp = json.Value{ .obj = out.items };
        tmp.deinit(alloc);
        out.deinit(alloc);
    }
    // start from dst (owned copies)
    for (dst.obj) |e| {
        try out.append(alloc, .{ .key = try alloc.dupe(u8, e.key), .val = try dupValue(alloc, &e.val) });
    }
    // overwrite/create from src
    for (src.obj) |e| {
        var replaced = false;
        for (out.items) |*slot| {
            if (std.mem.eql(u8, slot.key, e.key)) {
                slot.val.deinit(alloc);
                slot.val = try dupValue(alloc, &e.val);
                replaced = true;
                break;
            }
        }
        if (!replaced) try out.append(alloc, .{ .key = try alloc.dupe(u8, e.key), .val = try dupValue(alloc, &e.val) });
    }
    return .{ .obj = try out.toOwnedSlice(alloc) };
}

/// Deep owned copy of any Value.
pub fn dupValue(alloc: Allocator, v: *const json.Value) !json.Value {
    switch (v.*) {
        .null => return .{ .null = {} },
        .bool => |b| return .{ .bool = b },
        .int => |i| return .{ .int = i },
        .float => |f| return .{ .float = f },
        .str => |s| return .{ .str = try alloc.dupe(u8, s) },
        .arr => |a| {
            var out = try alloc.alloc(json.Value, a.len);
            var n: usize = 0;
            errdefer {
                for (out[0..n]) |*e| e.deinit(alloc);
                alloc.free(out);
            }
            for (a, 0..) |*e, i| {
                out[i] = try dupValue(alloc, e);
                n += 1;
            }
            return .{ .arr = out };
        },
        .obj => |entries| {
            var out = try alloc.alloc(json.Value.Entry, entries.len);
            var n: usize = 0;
            errdefer {
                for (out[0..n]) |*e| {
                    e.val.deinit(alloc);
                    alloc.free(e.key);
                }
                alloc.free(out);
            }
            for (entries, 0..) |e, i| {
                out[i] = .{ .key = try alloc.dupe(u8, e.key), .val = try dupValue(alloc, &e.val) };
                n += 1;
            }
            return .{ .obj = out };
        },
    }
}

/// Resolve Master1 names for a set of codes (one batched IN query; Code is
/// the global primary key). Returns owned pairs; missing codes are simply
/// absent — caller emits null.
pub const NamePair = struct { code: i64, name: []const u8 };

pub fn resolveNames(sess: *Session, alloc: Allocator, codes: []const i64) ![]NamePair {
    var distinct: std.ArrayList(i64) = .empty;
    defer distinct.deinit(alloc);
    for (codes) |c| {
        if (c == 0) continue;
        var seen = false;
        for (distinct.items) |d| {
            if (d == c) seen = true;
        }
        if (!seen) try distinct.append(alloc, c);
    }
    if (distinct.items.len == 0) return try alloc.alloc(NamePair, 0);

    var in_list: std.ArrayList(u8) = .empty;
    defer in_list.deinit(alloc);
    for (distinct.items, 0..) |c, i| {
        if (i != 0) try in_list.append(alloc, ',');
        var b: [24]u8 = undefined;
        try in_list.appendSlice(alloc, std.fmt.bufPrint(&b, "{d}", .{c}) catch unreachable);
    }
    const sql = try std.fmt.allocPrint(alloc, "SELECT Code, Name FROM Master1 WHERE Code IN ({s})", .{in_list.items});
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    var out: std.ArrayList(NamePair) = .empty;
    errdefer {
        for (out.items) |p| alloc.free(p.name);
        out.deinit(alloc);
    }
    if (rows != .arr) return out.toOwnedSlice(alloc);
    for (rows.arr) |*r| {
        if (r.* != .obj) continue;
        const code_v = r.get("Code") orelse continue;
        const name_v = r.get("Name") orelse continue;
        if (code_v.* != .int or name_v.* != .str) continue;
        try out.append(alloc, .{ .code = code_v.int, .name = try alloc.dupe(u8, name_v.str) });
    }
    return out.toOwnedSlice(alloc);
}

/// `Busy2L21.CFixedInterface` + class name -> `Busy2L21.<class>` (same
/// generation from the registry scan). Owned — caller frees.
pub fn classProgId(alloc: Allocator, class_name: []const u8) ![]u8 {
    const fi = registry.newestFixedInterface() orelse return error.NoBusyProgId;
    const i = std.mem.indexOf(u8, fi, "CFixedInterface") orelse return error.NoBusyProgId;
    return std.fmt.allocPrint(alloc, "{s}{s}", .{ fi[0..i], class_name });
}

test "classProgId derives sibling service classes" {
    const a = testing.allocator;
    if (registry.newestFixedInterface()) |_| {
        const p = try classProgId(a, "CMasterServices");
        defer a.free(p);
        try testing.expect(std.mem.endsWith(u8, p, "CMasterServices"));
        try testing.expect(std.mem.indexOf(u8, p, "CFixedInterface") == null);
    }
}

pub fn findName(pairs: []const NamePair, code: i64) ?[]const u8 {
    for (pairs) |p| if (p.code == code) return p.name;
    return null;
}

/// Opaque paging cursors for /v1 lists (issue #7): base64url (no padding)
/// of the raw keyset key text (master Name, or the decimal VchCode).
/// URL-safe and padding-free, so a cursor survives a query-string
/// round-trip unchanged; clients must treat it as opaque.
pub fn encodeCursor(alloc: Allocator, key: []const u8) ![]u8 {
    const Enc = std.base64.url_safe_no_pad.Encoder;
    const out = try alloc.alloc(u8, Enc.calcSize(key.len));
    const enc = Enc.encode(out, key);
    std.debug.assert(enc.len == out.len);
    return out;
}

pub fn decodeCursor(alloc: Allocator, s: []const u8) ![]u8 {
    const Dec = std.base64.url_safe_no_pad.Decoder;
    const n = Dec.calcSizeForSlice(s) catch return error.BadArgs;
    const out = try alloc.alloc(u8, n);
    errdefer alloc.free(out);
    Dec.decode(out, s) catch return error.BadArgs;
    return out;
}

test "cursor codec round-trips names and codes; garbage is BadArgs" {
    const a = testing.allocator;
    const c1 = try encodeCursor(a, "Cash-in-hand");
    defer a.free(c1);
    const d1 = try decodeCursor(a, c1);
    defer a.free(d1);
    try testing.expectEqualStrings("Cash-in-hand", d1);
    // URL-safe: no '+', '/', or '=' padding in the alphabet output
    for (c1) |ch| try testing.expect(ch != '+' and ch != '/' and ch != '=');

    const c2 = try encodeCursor(a, "1293");
    defer a.free(c2);
    const d2 = try decodeCursor(a, c2);
    defer a.free(d2);
    try testing.expectEqualStrings("1293", d2);

    try testing.expectError(error.BadArgs, decodeCursor(a, "!!not base64!!"));
}

/// Resolve a master's Code by type + exact name (owned result, null when
/// missing). Single query — reports use it before their service calls.
pub fn codeByName(sess: *Session, alloc: Allocator, master_type: i64, name: []const u8) !?i64 {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ master_type, quoted });
    defer alloc.free(sql);
    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr or rows.arr.len == 0) return null;
    const v = (rows.arr[0].get("Code") orelse return null).*;
    if (v != .int) return null;
    return v.int;
}

pub fn freePairs(alloc: Allocator, pairs: []NamePair) void {
    for (pairs) |p| alloc.free(p.name);
    alloc.free(pairs);
}

/// String child of an object (single level), owned copy — for pulling
/// VchNo/Date/etc. out of a parsed voucher document.
pub fn childStr(alloc: Allocator, v: *const json.Value, key: []const u8) anyerror!?[]u8 {
    if (v.* != .obj) return null;
    const child = v.get(key) orelse return null;
    if (child.* != .str) return null;
    return try alloc.dupe(u8, child.str);
}

// ---------------- tests ----------------

const testing = std.testing;

test "stringifyValue scalars" {
    const a = testing.allocator;
    var s = json.Value{ .str = try a.dupe(u8, "hi") };
    defer s.deinit(a);
    const o = (try stringifyValue(a, &s)).?;
    defer a.free(o);
    try testing.expectEqualStrings("hi", o);

    const i = json.Value{ .int = 42 };
    const oi = (try stringifyValue(a, &i)).?;
    defer a.free(oi);
    try testing.expectEqualStrings("42", oi);

    const f = json.Value{ .float = 901.0 }; // integral float: no decimal point
    const of = (try stringifyValue(a, &f)).?;
    defer a.free(of);
    try testing.expectEqualStrings("901", of);

    // fixed-width columns come back space-padded -> trimmed
    var padded = json.Value{ .str = try a.dupe(u8, "                      902") };
    defer padded.deinit(a);
    const op = (try stringifyValue(a, &padded)).?;
    defer a.free(op);
    try testing.expectEqualStrings("902", op);

    const n = json.Value{ .null = {} };
    try testing.expect((try stringifyValue(a, &n)) == null);
}

test "normalizeDate" {
    const a = testing.allocator;
    const iso = (try normalizeDate(a, "2026-10-08")).?;
    defer a.free(iso);
    try testing.expectEqualStrings("2026-10-08", iso);
    const slash = (try normalizeDate(a, "08/10/2026")).?;
    defer a.free(slash);
    try testing.expectEqualStrings("2026-10-08", slash);
    const dash = (try normalizeDate(a, "08-10-2026")).?;
    defer a.free(dash);
    try testing.expectEqualStrings("2026-10-08", dash);
    try testing.expect((try normalizeDate(a, "not a date")) == null);
    try testing.expect((try normalizeDate(a, "8/10/2026")) == null);
}

test "toBusyDate write format" {
    const a = testing.allocator;
    const iso = (try toBusyDate(a, "2026-10-08")).?;
    defer a.free(iso);
    try testing.expectEqualStrings("08-10-2026", iso);
    const busy = (try toBusyDate(a, "08-10-2026")).?;
    defer a.free(busy);
    try testing.expectEqualStrings("08-10-2026", busy); // idempotent
    const slash = (try toBusyDate(a, "08/10/2026")).?;
    defer a.free(slash);
    try testing.expectEqualStrings("08-10-2026", slash);
    try testing.expect((try toBusyDate(a, "garbage")) == null);
    // round-trip with normalizeDate
    const rt = (try normalizeDate(a, (try toBusyDate(a, "2026-01-02")).?)).?;
    defer a.free(rt);
    try testing.expectEqualStrings("2026-01-02", rt);
}

test "mergeRoot overwrites and keeps untouched fields" {
    const a = testing.allocator;
    var dst = try json.parse(a,
        \\\\{"Name":"ZigItem","ParentGroup":"General","MainUnit":"Pcs.","Extra":{"A":"1"}}
    );
    defer dst.deinit(a);
    var src = try json.parse(a,
        \\\\{"ParentGroup":"Machinery","NewField":"x"}
    );
    defer src.deinit(a);
    var m = try mergeRoot(a, &dst, &src);
    defer m.deinit(a);
    try testing.expectEqualStrings("ZigItem", m.get("Name").?.str); // kept
    try testing.expectEqualStrings("Machinery", m.get("ParentGroup").?.str); // overwritten
    try testing.expectEqualStrings("Pcs.", m.get("MainUnit").?.str); // kept
    try testing.expectEqualStrings("x", m.get("NewField").?.str); // added
    // deep copy: mutating src's tree must not affect merged result
    try testing.expect(m.get("Extra").?.get("A").?.str.ptr != dst.get("Extra").?.get("A").?.str.ptr);
}

test "containsCi" {
    try testing.expect(containsCi("Sundry Debtors", "debt"));
    try testing.expect(containsCi("Sundry Debtors", ""));
    try testing.expect(!containsCi("abc", "abcdef"));
    try testing.expect(!containsCi("abc", "zz"));
}

test "put/objFrom owns keys and values" {
    const a = testing.allocator;
    var list: std.ArrayList(json.Value.Entry) = .empty;
    try put(a, &list, "code", .{ .int = 7 });
    try put(a, &list, "name", .{ .str = try a.dupe(u8, "x") });
    var obj = try objFrom(a, &list);
    defer obj.deinit(a);
    try testing.expectEqual(@as(usize, 2), obj.obj.len);
    try testing.expectEqual(@as(i64, 7), obj.get("code").?.int);
}
