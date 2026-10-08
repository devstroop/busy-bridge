//! Serialize an element tree back to XML text.
//!
//! Canonical escaping: text escapes `& < >`; attribute values additionally
//! escape `"`. Re-escaping `>` keeps byte-identity with BUSY's own output
//! (it always writes `&gt;`), which the fixture round-trip tests enforce.
const std = @import("std");
const parse = @import("parse.zig");

const Allocator = std.mem.Allocator;

pub fn writeDocument(alloc: Allocator, out: *std.ArrayList(u8), root: *const parse.Element) !void {
    try writeElement(alloc, out, root);
}

pub fn writeElement(alloc: Allocator, out: *std.ArrayList(u8), e: *const parse.Element) !void {
    try out.append(alloc, '<');
    try out.appendSlice(alloc, e.name);
    for (e.attrs) |a| {
        try out.append(alloc, ' ');
        try out.appendSlice(alloc, a.name);
        try out.appendSlice(alloc, "=\"");
        try escapeInto(alloc, out, a.value, true);
        try out.append(alloc, '"');
    }
    if (e.selfclosing and e.children.len == 0) {
        try out.appendSlice(alloc, " />");
        return;
    }
    try out.append(alloc, '>');
    for (e.children) |*c| switch (c.*) {
        .text => |t| try escapeInto(alloc, out, t, false),
        .element => |*ch| try writeElement(alloc, out, ch),
    };
    try out.appendSlice(alloc, "</");
    try out.appendSlice(alloc, e.name);
    try out.append(alloc, '>');
}

fn escapeInto(alloc: Allocator, out: *std.ArrayList(u8), s: []const u8, attr: bool) !void {
    for (s) |c| {
        switch (c) {
            '&' => try out.appendSlice(alloc, "&amp;"),
            '<' => try out.appendSlice(alloc, "&lt;"),
            '>' => try out.appendSlice(alloc, "&gt;"),
            '"' => try out.appendSlice(alloc, if (attr) "&quot;" else "\""),
            else => try out.append(alloc, c),
        }
    }
}

// ---------------- tests ----------------

const testing = std.testing;

test "text escaping" {
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(testing.allocator);
    var doc = try parse.parse(testing.allocator, "<A>x &amp; y &lt;z&gt;</A>");
    defer doc.deinit(testing.allocator);
    try writeDocument(testing.allocator, &out, &doc);
    try testing.expectEqualStrings("<A>x &amp; y &lt;z&gt;</A>", out.items);
}

test "attr escaping" {
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(testing.allocator);
    var doc = try parse.parse(testing.allocator, "<A q=\"a &amp; b &quot;c&quot;\"/>");
    defer doc.deinit(testing.allocator);
    try writeDocument(testing.allocator, &out, &doc);
    try testing.expectEqualStrings("<A q=\"a &amp; b &quot;c&quot;\" />", out.items);
}

test "selfclosing and nesting" {
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(testing.allocator);
    var doc = try parse.parse(testing.allocator, "<A><B/><C>t</C></A>");
    defer doc.deinit(testing.allocator);
    try writeDocument(testing.allocator, &out, &doc);
    try testing.expectEqualStrings("<A><B /><C>t</C></A>", out.items);
}
