//! Wire envelopes: shape results/errors as JSON documents for the CLI and
//! HTTP transports. These formats are protocol concerns, not domain data.
const std = @import("std");
const json = @import("../util/json.zig");
const helpers = @import("../util/helpers.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const printOut = helpers.printOut;

pub fn emitJson(io: Io, alloc: Allocator, v: *const json.Value) !void {
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try json.stringify(v, &w);
    try out.append(alloc, '\n');
    try printOut(io, alloc, out.items);
}

pub fn errJsonText(alloc: Allocator, code: []const u8, msg: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":false,");
    try w.field("code");
    try w.str(code);
    try w.raw(",");
    try w.field("error");
    try w.str(msg);
    try w.raw("}");
    return out.toOwnedSlice(alloc);
}

pub fn fieldText(alloc: Allocator, key: []const u8, v: *const json.Value) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.field(key);
    try json.stringify(v, &w);
    return out.toOwnedSlice(alloc);
}

/// Wrap a JSON value as {"ok":true, key: value} text.
pub fn okWrap(alloc: Allocator, key: []const u8, v: *const json.Value) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,");
    try w.field(key);
    try json.stringify(v, &w);
    try w.raw("}");
    return out.toOwnedSlice(alloc);
}

/// Shallow view of `rows` limited to `cap` rows (0 = no cap) for
/// serialization. The original value keeps its full ownership, so the
/// caller's deferred deinit still frees everything exactly once.
pub fn rowView(rows: *const json.Value, cap: usize) json.Value {
    var v = rows.*;
    if (cap > 0 and v == .arr and v.arr.len > cap) v.arr = v.arr[0..cap];
    return v;
}

/// Query payload with the row cap (issue #3): writes at most `cap` rows
/// (0 = all) and appends `"truncated":true` when rows were dropped —
/// omitted otherwise, so capped-out responses stay byte-identical to the
/// original `{"ok":true,"rows":[...]}` shape.
pub fn rowsJson(alloc: Allocator, rows: *const json.Value, cap: usize) ![]u8 {
    if (rows.* != .arr) return error.BadRows;
    const view = rowView(rows, cap);
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,\"rows\":[");
    for (view.arr, 0..) |*r, i| {
        if (i != 0) try w.raw(",");
        try json.stringify(r, &w);
    }
    try w.raw("]");
    if (view.arr.len < rows.arr.len) {
        try w.raw(",\"truncated\":true");
    }
    try w.raw("}");
    return out.toOwnedSlice(alloc);
}

test "rowsJson row cap + truncated flag" {
    const testing = std.testing;
    const rows = try json.parse(testing.allocator,
        \\[{"a":1},{"a":2},{"a":3}]
    );
    defer {
        var t = rows;
        t.deinit(testing.allocator);
    }
    // cap below the row count -> capped rows + flag
    const capped = try rowsJson(testing.allocator, &rows, 2);
    defer testing.allocator.free(capped);
    const p1 = try json.parse(testing.allocator, capped);
    defer {
        var t = p1;
        t.deinit(testing.allocator);
    }
    try testing.expect(p1.get("truncated").?.* == .bool);
    try testing.expect(p1.get("truncated").?.bool);
    try testing.expectEqual(@as(usize, 2), p1.get("rows").?.arr.len);

    // cap >= rows / cap 0 (unlimited) -> no flag, all rows
    const wide = try rowsJson(testing.allocator, &rows, 10);
    defer testing.allocator.free(wide);
    try testing.expect(std.mem.indexOf(u8, wide, "\"truncated\"") == null);
    const uncapped = try rowsJson(testing.allocator, &rows, 0);
    defer testing.allocator.free(uncapped);
    try testing.expectEqualStrings(wide, uncapped);
    const p2 = try json.parse(testing.allocator, uncapped);
    defer {
        var t = p2;
        t.deinit(testing.allocator);
    }
    try testing.expectEqual(@as(usize, 3), p2.get("rows").?.arr.len);

    // rowView never mutates the source
    const view = rowView(&rows, 1);
    try testing.expectEqual(@as(usize, 1), view.arr.len);
    try testing.expectEqual(@as(usize, 3), rows.arr.len);
}
