//! Wire envelopes: shape results/errors as JSON documents for the CLI and
//! HTTP transports. These formats are protocol concerns, not domain data.
const std = @import("std");
const json = @import("../util/json.zig");
const xml_mod = @import("../util/xml.zig");
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

/// Operations facade, JSON mode (issue #7):
/// `{"ok":true,"op":"list-accounts","result":{...}}` — mirrors the raw
/// `call` envelope shape (result lives at `.result`).
pub fn opJson(alloc: Allocator, op_name: []const u8, v: *const json.Value) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,\"op\":");
    try w.str(op_name);
    try w.raw(",\"result\":");
    try json.stringify(v, &w);
    try w.raw("}");
    return out.toOwnedSlice(alloc);
}

/// Operations facade, XML mode: single-root `<Op><name>…</name><
/// result>…</result></Op>` through the standard JSON→XML mapping
/// (util/xml copies all content, so `v` stays caller-owned).
pub fn opXml(alloc: Allocator, op_name: []const u8, v: *const json.Value) ![]u8 {
    const name_key = try alloc.dupe(u8, "name");
    errdefer alloc.free(name_key);
    const name_val = try alloc.dupe(u8, op_name);
    errdefer alloc.free(name_val);
    const res_key = try alloc.dupe(u8, "result");
    errdefer alloc.free(res_key);
    const root_key = try alloc.dupe(u8, "Op");
    errdefer alloc.free(root_key);

    // `result` entry BORROWS v (fromJson copies; we never free it here)
    var inner = [_]json.Value.Entry{
        .{ .key = name_key, .val = .{ .str = name_val } },
        .{ .key = res_key, .val = v.* },
    };
    var root = [_]json.Value.Entry{
        .{ .key = root_key, .val = .{ .obj = &inner } },
    };
    const wrapper = json.Value{ .obj = &root };

    var el = try xml_mod.fromJson(alloc, &wrapper);
    defer el.deinit(alloc); // frees Element's own copies
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);
    try xml_mod.writeElement(alloc, &out, &el);
    // wrapper/inner keys and name_val were ours; `v` and Element copies are not
    alloc.free(name_key);
    alloc.free(name_val);
    alloc.free(res_key);
    alloc.free(root_key);
    return out.toOwnedSlice(alloc);
}

test "op envelopes render both formats" {
    const testing = std.testing;
    const a = testing.allocator;
    var v = try json.parse(a,
        \\{"kind":"account","count":1,"items":[{"code":116,"name":"Sundry Debtors"}]}
    );
    defer v.deinit(a);

    const j = try opJson(a, "list-accounts", &v);
    defer a.free(j);
    try testing.expect(std.mem.startsWith(u8, j, "{\"ok\":true,\"op\":\"list-accounts\",\"result\":{"));

    const x = try opXml(a, "list-accounts", &v);
    defer a.free(x);
    try testing.expect(std.mem.startsWith(u8, x, "<Op><name>list-accounts</name><result>"));
    try testing.expect(std.mem.indexOf(u8, x, "<name>Sundry Debtors</name>") != null);
    try testing.expect(std.mem.endsWith(u8, x, "</result></Op>"));
    // borrow held: v still intact after opXml
    try testing.expectEqual(@as(i64, 116), v.get("items").?.arr[0].get("code").?.int);
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
