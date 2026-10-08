//! XML element tree <-> json.Value mapping. The conventions are the wire
//! contract for Phase 3 (request-scoped pure JSON/XML):
//!   - element with only text        -> JSON string (numbers stay strings!)
//!   - empty element                 -> null
//!   - repeated sibling names        -> array, first-appearance key order
//!   - attributes                    -> "@name" keys
//!   - mixed text + elements         -> "$text" key
//! Lossless: no type coercion in either direction.
const std = @import("std");
const json = @import("../json.zig");
const parse = @import("parse.zig");

const Allocator = std.mem.Allocator;

pub const text_key = "$text";
pub const attr_prefix = '@';

fn isWs(s: []const u8) bool {
    for (s) |c| if (!std.ascii.isWhitespace(c)) return false;
    return true;
}

/// Document form: `{"RootName": <content>}` — the root name rides along so
/// `fromJson(toJson(x))` can rebuild the exact document.
pub fn toJson(alloc: Allocator, root: *const parse.Element) !json.Value {
    const content = try contentToJson(alloc, root);
    errdefer {
        var tmp = content;
        tmp.deinit(alloc);
    }
    var entries = try alloc.alloc(json.Value.Entry, 1);
    entries[0] = .{ .key = try alloc.dupe(u8, root.name), .val = content };
    return .{ .obj = entries };
}

pub fn contentToJson(alloc: Allocator, e: *const parse.Element) anyerror!json.Value {
    var has_element = false;
    var has_any_text = false;
    var has_nontws_text = false;
    for (e.children) |c| switch (c) {
        .element => has_element = true,
        .text => |t| {
            if (t.len > 0) has_any_text = true;
            if (!isWs(t)) has_nontws_text = true;
        },
    };
    const has_attrs = e.attrs.len > 0;

    // plain cases: no attrs, no child elements
    if (!has_attrs and !has_element) {
        if (!has_any_text) return .null;
        var buf: std.ArrayList(u8) = .empty;
        errdefer buf.deinit(alloc);
        for (e.children) |c| switch (c) {
            .text => |t| try buf.appendSlice(alloc, t),
            .element => unreachable,
        };
        return .{ .str = try buf.toOwnedSlice(alloc) };
    }

    // object form
    var entries: std.ArrayList(json.Value.Entry) = .empty;
    errdefer {
        for (entries.items) |*ent| {
            ent.val.deinit(alloc);
            alloc.free(ent.key);
        }
        entries.deinit(alloc);
    }

    for (e.attrs) |a| {
        try entries.append(alloc, .{
            .key = try std.fmt.allocPrint(alloc, "{c}{s}", .{ attr_prefix, a.name }),
            .val = .{ .str = try alloc.dupe(u8, a.value) },
        });
    }

    if (has_element and has_nontws_text) {
        var buf: std.ArrayList(u8) = .empty;
        errdefer buf.deinit(alloc);
        for (e.children) |c| switch (c) {
            .text => |t| if (!isWs(t)) try buf.appendSlice(alloc, t),
            .element => {},
        };
        try entries.append(alloc, .{
            .key = try alloc.dupe(u8, text_key),
            .val = .{ .str = try buf.toOwnedSlice(alloc) },
        });
    }

    // group child elements by name, preserving first-appearance order;
    // repeats upgrade the entry to an array.
    for (e.children) |c| {
        const child = switch (c) {
            .element => |*ch| ch,
            .text => continue,
        };
        const val = try contentToJson(alloc, child);
        var placed = false;
        for (entries.items) |*ent| {
            if (std.mem.eql(u8, ent.key, child.name)) {
                switch (ent.val) {
                    .arr => |*a| {
                        const grown = try alloc.realloc(a.*, a.len + 1);
                        grown[grown.len - 1] = val;
                        ent.val = .{ .arr = grown };
                    },
                    else => {
                        const old = ent.val;
                        const pair = try alloc.alloc(json.Value, 2);
                        pair[0] = old;
                        pair[1] = val;
                        ent.val = .{ .arr = pair };
                    },
                }
                placed = true;
                break;
            }
        }
        if (!placed) {
            try entries.append(alloc, .{
                .key = try alloc.dupe(u8, child.name),
                .val = val,
            });
        }
    }

    return .{ .obj = try entries.toOwnedSlice(alloc) };
}

/// Inverse of `toJson`: expects a single-member object `{"RootName": ...}`.
pub fn fromJson(alloc: Allocator, v: *const json.Value) anyerror!parse.Element {
    if (v.* != .obj or v.obj.len != 1) return error.BadDocument;
    return contentFromJson(alloc, v.obj[0].key, &v.obj[0].val);
}

pub fn contentFromJson(alloc: Allocator, name: []const u8, v: *const json.Value) anyerror!parse.Element {
    var children: std.ArrayList(parse.Node) = .empty;
    errdefer {
        parse.freeChildren(alloc, children.items);
        children.deinit(alloc);
    }
    var attrs: std.ArrayList(parse.Attr) = .empty;
    errdefer {
        parse.freeAttrs(alloc, attrs.items);
        attrs.deinit(alloc);
    }

    switch (v.*) {
        .null => {},
        .bool, .int, .float, .str => {
            const t = try scalarText(alloc, v);
            errdefer alloc.free(t);
            try children.append(alloc, .{ .text = t });
        },
        .arr => return error.BadContent,
        .obj => |entries| for (entries) |ent| {
            if (std.mem.eql(u8, ent.key, text_key)) {
                const t = try scalarText(alloc, &ent.val);
                errdefer alloc.free(t);
                try children.append(alloc, .{ .text = t });
            } else if (ent.key.len > 0 and ent.key[0] == attr_prefix) {
                const t = try scalarText(alloc, &ent.val);
                errdefer alloc.free(t);
                try attrs.append(alloc, .{
                    .name = try alloc.dupe(u8, ent.key[1..]),
                    .value = t,
                });
            } else switch (ent.val) {
                .arr => |items| for (items) |*item| {
                    var child = try contentFromJson(alloc, ent.key, item);
                    errdefer child.deinit(alloc);
                    try children.append(alloc, .{ .element = child });
                },
                else => {
                    var child = try contentFromJson(alloc, ent.key, &ent.val);
                    errdefer child.deinit(alloc);
                    try children.append(alloc, .{ .element = child });
                },
            }
        },
    }

    const empty = children.items.len == 0;
    return .{
        .name = try alloc.dupe(u8, name),
        .selfclosing = empty,
        .attrs = try attrs.toOwnedSlice(alloc),
        .children = try children.toOwnedSlice(alloc),
    };
}

fn scalarText(alloc: Allocator, v: *const json.Value) ![]const u8 {
    return switch (v.*) {
        .null => try alloc.dupe(u8, ""),
        .str => |s| try alloc.dupe(u8, s),
        .bool => |b| try alloc.dupe(u8, if (b) "true" else "false"),
        .int => |i| try std.fmt.allocPrint(alloc, "{d}", .{i}),
        .float => |f| try std.fmt.allocPrint(alloc, "{d}", .{f}),
        else => error.BadValue,
    };
}

// ---------------- tests ----------------

const testing = std.testing;
const write = @import("write.zig");

test "text only becomes string, empty becomes null" {
    var doc = try parse.parse(testing.allocator, "<A><N>Cash</N><E/></A>");
    defer doc.deinit(testing.allocator);
    const v = try contentToJson(testing.allocator, &doc);
    defer {
        var t = v;
        t.deinit(testing.allocator);
    }
    const n = v.get("N").?;
    try testing.expectEqualStrings("Cash", n.str);
    try testing.expect(v.get("E").?.* == .null);
}

test "repeated siblings become arrays preserving order" {
    var doc = try parse.parse(testing.allocator, "<A><X>1</X><Y>t</Y><X>2</X><X>3</X></A>");
    defer doc.deinit(testing.allocator);
    const v = try contentToJson(testing.allocator, &doc);
    defer {
        var t = v;
        t.deinit(testing.allocator);
    }
    try testing.expectEqual(@as(usize, 2), v.obj.len); // X first, then Y
    try testing.expectEqualStrings("X", v.obj[0].key);
    try testing.expectEqualStrings("Y", v.obj[1].key);
    try testing.expectEqual(@as(usize, 3), v.obj[0].val.arr.len);
    try testing.expectEqualStrings("2", v.obj[0].val.arr[1].str);
}

test "attributes use @ prefix, mixed content uses $text" {
    var doc = try parse.parse(testing.allocator, "<A k=\"v\">raw<B/></A>");
    defer doc.deinit(testing.allocator);
    const v = try contentToJson(testing.allocator, &doc);
    defer {
        var t = v;
        t.deinit(testing.allocator);
    }
    try testing.expectEqualStrings("v", v.get("@k").?.str);
    try testing.expectEqualStrings("raw", v.get(text_key).?.str);
    try testing.expect(v.get("B").?.* == .null);
}

test "json -> xml -> json is stable" {
    // input is in canonical output order (attrs, $text, children) so the
    // re-mapped JSON must stringify identically
    const src =
        \\{"Root":{"@a":"1","$text":"mid","Name":"Cash","Qty":"5","Items":[{"I":"a"},{"I":"b"}],"Flag":null}}
    ;
    var v = try json.parse(testing.allocator, src);
    defer v.deinit(testing.allocator);
    var doc = try fromJson(testing.allocator, &v);
    defer doc.deinit(testing.allocator);
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(testing.allocator);
    try write.writeDocument(testing.allocator, &out, &doc);
    try testing.expectEqualStrings(
        \\<Root a="1">mid<Name>Cash</Name><Qty>5</Qty><Items><I>a</I></Items><Items><I>b</I></Items><Flag /></Root>
    , out.items);

    var v2 = try toJson(testing.allocator, &doc);
    defer v2.deinit(testing.allocator);
    var a: std.ArrayList(u8) = .empty;
    defer a.deinit(testing.allocator);
    var b: std.ArrayList(u8) = .empty;
    defer b.deinit(testing.allocator);
    var wa = json.Writer{ .buf = &a, .alloc = testing.allocator };
    try json.stringify(&v, &wa);
    var wb = json.Writer{ .buf = &b, .alloc = testing.allocator };
    try json.stringify(&v2, &wb);
    try testing.expectEqualStrings(a.items, b.items);
}
