//! UTF-8 <-> UTF-16 helpers for COM BSTR interop.
const std = @import("std");

const Allocator = std.mem.Allocator;

pub fn toUtf16(alloc: Allocator, s: []const u8) ![:0]u16 {
    return try std.unicode.utf8ToUtf16LeAllocZ(alloc, s);
}

pub fn fromUtf16(alloc: Allocator, w: [*:0]u16, len: usize) ![]u8 {
    return try std.unicode.utf16LeToUtf8Alloc(alloc, w[0..len]);
}
