//! Wire envelopes: shape results/errors as JSON documents for the CLI and
//! HTTP transports. These formats are protocol concerns, not domain data.
const std = @import("std");
const json = @import("../util/json.zig");
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
