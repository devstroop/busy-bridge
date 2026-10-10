//! $byref marker parsing (pure — split from invoke.zig for the size
//! gate): the typed VB6 ByRef box kinds and their string tags.
const std = @import("std");

/// $byref box kinds (issue #7 M3 + iteration-5 typed VB6 ByRef).
pub const ByrefKind = enum { variant, f8, i4, cy, i8, bstr, bool, dispatch, collection };

/// Pure marker parsing (unit-tested): $byref string -> box kind.
pub fn byrefKindFromMarker(s: []const u8) ?ByrefKind {
    if (s.len == 0) return .variant;
    if (std.mem.eql(u8, s, "f8")) return .f8;
    if (std.mem.eql(u8, s, "i4")) return .i4;
    if (std.mem.eql(u8, s, "cy")) return .cy;
    if (std.mem.eql(u8, s, "i8")) return .i8;
    if (std.mem.eql(u8, s, "bstr")) return .bstr;
    if (std.mem.eql(u8, s, "bool")) return .bool;
    if (std.mem.eql(u8, s, "dispatch")) return .dispatch;
    if (std.mem.eql(u8, s, "collection")) return .collection;
    return null;
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "byrefKindFromMarker maps every $byref marker" {
    try testing.expectEqual(ByrefKind.variant, byrefKindFromMarker("").?);
    try testing.expectEqual(ByrefKind.f8, byrefKindFromMarker("f8").?);
    try testing.expectEqual(ByrefKind.i4, byrefKindFromMarker("i4").?);
    try testing.expectEqual(ByrefKind.cy, byrefKindFromMarker("cy").?);
    try testing.expectEqual(ByrefKind.i8, byrefKindFromMarker("i8").?);
    // iteration-5 typed VB6 ByRef (login/rights/write contracts):
    try testing.expectEqual(ByrefKind.bstr, byrefKindFromMarker("bstr").?);
    try testing.expectEqual(ByrefKind.bool, byrefKindFromMarker("bool").?);
    try testing.expectEqual(ByrefKind.dispatch, byrefKindFromMarker("dispatch").?);
    // collection read-back (VB6 Collection -> JSON array):
    try testing.expectEqual(ByrefKind.collection, byrefKindFromMarker("collection").?);
    try testing.expect(null == byrefKindFromMarker("bogus"));
    try testing.expect(null == byrefKindFromMarker("BSTr")); // case-sensitive
}
