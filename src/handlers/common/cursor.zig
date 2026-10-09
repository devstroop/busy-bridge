//! Opaque paging cursors for /v1 lists (issue #7 / 011 phase 2):
//! base64url (no padding) of the raw keyset key text (master Name, or
//! the decimal VchCode). URL-safe and padding-free, so a cursor
//! survives a query-string round-trip unchanged; clients must treat it
//! as opaque (encode/decode are internal).
const std = @import("std");

const Allocator = std.mem.Allocator;

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

// ---------------- tests ----------------

const testing = std.testing;

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
