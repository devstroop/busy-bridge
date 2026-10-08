//! Shared text helpers: no wire-format knowledge, no BUSY knowledge.
const std = @import("std");

const Allocator = std.mem.Allocator;
const Io = std.Io;

pub fn eql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

pub fn startsWithCi(hay: []const u8, needle: []const u8) bool {
    if (hay.len < needle.len) return false;
    return std.ascii.eqlIgnoreCase(hay[0..needle.len], needle);
}

/// Decode a base64 CLI value. Used by --args-b64/--sql-b64 because
/// PowerShell 5.1 mangles embedded double quotes in native-command args.
pub fn b64Decode(alloc: Allocator, s: []const u8) ![]u8 {
    const dec = std.base64.standard.Decoder;
    const size = try dec.calcSizeForSlice(s);
    const buf = try alloc.alloc(u8, size);
    errdefer alloc.free(buf);
    try dec.decode(buf, s);
    return buf;
}

pub fn printOut(io: Io, alloc: Allocator, text: []const u8) !void {
    _ = alloc;
    var buf: [16384]u8 = undefined;
    var w = Io.File.stdout().writer(io, &buf);
    try w.interface.writeAll(text);
    try w.interface.flush();
}
