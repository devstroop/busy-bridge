//! Shared text/JSON output helpers used by both the CLI and HTTP layers.
const std = @import("std");
const json = @import("json.zig");

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

pub fn emitJson(io: Io, alloc: Allocator, v: *const json.Value) !void {
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try json.stringify(v, &w);
    try out.append(alloc, '\n');
    try printOut(io, alloc, out.items);
}

pub fn errJsonText(alloc: Allocator, msg: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":false,");
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
