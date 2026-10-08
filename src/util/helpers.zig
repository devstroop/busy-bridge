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

/// Percent-decode a query-string value (`%XX` only; '+' stays literal —
/// query components use %20 for spaces, not form encoding).
pub fn urlDecode(alloc: Allocator, s: []const u8) ![]u8 {
    if (std.mem.indexOfScalar(u8, s, '%') == null) return alloc.dupe(u8, s);
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var i: usize = 0;
    while (i < s.len) {
        if (s[i] == '%' and i + 2 < s.len) {
            const hx = std.fmt.parseInt(u8, s[i + 1 .. i + 3], 16) catch {
                try out.append(alloc, '%');
                i += 1;
                continue;
            };
            try out.append(alloc, hx);
            i += 3;
            continue;
        }
        try out.append(alloc, s[i]);
        i += 1;
    }
    return out.toOwnedSlice(alloc);
}

test "urlDecode" {
    const testing = std.testing;
    const a = try urlDecode(testing.allocator, "a%20b/c");
    defer testing.allocator.free(a);
    const b = try urlDecode(testing.allocator, "%5Bfalse%5D");
    defer testing.allocator.free(b);
    const c = try urlDecode(testing.allocator, "50%");
    defer testing.allocator.free(c);
    const d = try urlDecode(testing.allocator, "a+b");
    defer testing.allocator.free(d);
    const e = try urlDecode(testing.allocator, "plain");
    defer testing.allocator.free(e);
    try testing.expectEqualStrings("a b/c", a);
    try testing.expectEqualStrings("[false]", b);
    try testing.expectEqualStrings("50%", c); // bare % kept
    try testing.expectEqualStrings("a+b", d); // '+' untouched
    try testing.expectEqualStrings("plain", e);
}
