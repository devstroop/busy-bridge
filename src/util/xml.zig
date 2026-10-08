//! Minimal XML codec for BUSY document exchange (Phase 2 — no transport
//! wiring yet; that is Phase 3's request-scoped format selection).
//!   parse.zig — well-formed-subset parser -> owned Element tree
//!   write.zig — canonical serializer (byte-identical for BUSY output)
//!   map.zig   — json.Value mapping conventions (the future wire contract)
//! ../testdata/ holds raw samples captured from the live DEMO company.
const std = @import("std");
const parse_mod = @import("xml/parse.zig");
const write_mod = @import("xml/write.zig");
const map_mod = @import("xml/map.zig");

pub const Attr = parse_mod.Attr;
pub const Node = parse_mod.Node;
pub const Element = parse_mod.Element;
pub const parse = parse_mod.parse;
pub const writeDocument = write_mod.writeDocument;
pub const writeElement = write_mod.writeElement;
pub const toJson = map_mod.toJson;
pub const fromJson = map_mod.fromJson;
pub const text_key = map_mod.text_key;
pub const attr_prefix = map_mod.attr_prefix;

test {
    _ = @import("xml/parse.zig");
    _ = @import("xml/write.zig");
    _ = @import("xml/map.zig");
}

// Byte-identity round-trips over raw samples captured from live BUSY DEMO:
// parse -> write must reproduce BUSY's own serialization exactly.
test "captured BUSY samples roundtrip byte-identical" {
    const fixtures = .{
        "xml/testdata/compconfig.xml",
        "xml/testdata/mastconfig.xml",
        "xml/testdata/currentuser.xml",
        "xml/testdata/master-cash.xml",
        "xml/testdata/master-pl.xml",
    };
    inline for (fixtures) |f| {
        const src = @embedFile(f);
        var doc = try parse(std.testing.allocator, src);
        defer doc.deinit(std.testing.allocator);
        var out: std.ArrayList(u8) = .empty;
        defer out.deinit(std.testing.allocator);
        try writeDocument(std.testing.allocator, &out, &doc);
        try std.testing.expectEqualStrings(src, out.items);
    }
}

// The captured currentuser.xml has repeated sibling names — the array
// mapping must keep them all (this is the regression that matters most).
test "captured duplicate siblings map to arrays losslessly" {
    const json = @import("json.zig");
    const src = @embedFile("xml/testdata/currentuser.xml");
    var doc = try parse(std.testing.allocator, src);
    defer doc.deinit(std.testing.allocator);
    const v = try toJson(std.testing.allocator, &doc);
    defer {
        var t = v;
        t.deinit(std.testing.allocator);
    }
    const root = v.get("UserProfile").?;
    const dup = root.get("ShowMsgCentreStartUp").?;
    try std.testing.expect(dup.* == .arr);
    try std.testing.expect(dup.arr.len >= 2);

    // json -> xml -> json must be stable
    var doc2 = try fromJson(std.testing.allocator, &v);
    defer doc2.deinit(std.testing.allocator);
    var v2 = try toJson(std.testing.allocator, &doc2);
    defer v2.deinit(std.testing.allocator);
    var a: std.ArrayList(u8) = .empty;
    defer a.deinit(std.testing.allocator);
    var b: std.ArrayList(u8) = .empty;
    defer b.deinit(std.testing.allocator);
    var wa = json.Writer{ .buf = &a, .alloc = std.testing.allocator };
    try json.stringify(&v, &wa);
    var wb = json.Writer{ .buf = &b, .alloc = std.testing.allocator };
    try json.stringify(&v2, &wb);
    try std.testing.expectEqualStrings(a.items, b.items);
}
