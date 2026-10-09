//! JSON-value glue for the ERP ops (issue #7 / 011 phase 2): object
//! builders, scalar stringification, deep copy/merge, small accessors.
//! Pure — no session, no BUSY knowledge. Shared by every op module.
const std = @import("std");
const json = @import("../../util/json.zig");

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

/// Merge `src` fields into a deep copy of `dst` (both objects): every
/// top-level key of `src` overwrites/creates in the result. Used by
/// update ops — we fetch the FULL existing document, merge only the
/// requested changes, and re-save, so BUSY never wipes untouched fields.
/// `dst`/`src` are borrowed; the result is owned by `alloc`.
pub fn mergeRoot(alloc: Allocator, dst: *const json.Value, src: *const json.Value) !json.Value {
    if (dst.* != .obj or src.* != .obj) return error.BadDocument;
    var out: std.ArrayList(json.Value.Entry) = .empty;
    errdefer {
        // free entries + buffer; a Value.deinit over out.items would free
        // the slice with len != capacity (wrong-size free) and then
        // out.deinit would free it again (issue 011: latent double-free)
        for (out.items) |*e| {
            e.val.deinit(alloc);
            alloc.free(e.key);
        }
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

test "mergeRoot overwrites and keeps untouched fields" {
    const a = testing.allocator;
    var dst = try json.parse(a,
        \\{"Name":"ZigItem","ParentGroup":"General","MainUnit":"Pcs.","Extra":{"A":"1"}}
    );
    defer dst.deinit(a);
    var src = try json.parse(a,
        \\{"ParentGroup":"Machinery","NewField":"x"}
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
