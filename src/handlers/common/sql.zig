//! SQL/session helpers for the ERP ops (issue #7 / 011 phase 2): batched
//! Master1 name resolution, code-by-name lookup, sibling service ProgIDs.
//! The only `common/` submodule that needs a Session — everything else
//! here is a pure transform over its results.
const std = @import("std");
const json = @import("../../util/json.zig");
const helpers = @import("../../util/helpers.zig");
const registry = @import("../../core/registry.zig");
const Session = @import("../../core/com.zig").Session;

const Allocator = std.mem.Allocator;

/// Resolve Master1 names for a set of codes (one batched IN query; Code is
/// the global primary key). Returns owned pairs; missing codes are simply
/// absent — caller emits null.
pub const NamePair = struct { code: i64, name: []const u8 };

pub fn resolveNames(sess: *Session, alloc: Allocator, codes: []const i64) ![]NamePair {
    var distinct: std.ArrayList(i64) = .empty;
    defer distinct.deinit(alloc);
    for (codes) |c| {
        if (c == 0) continue;
        var seen = false;
        for (distinct.items) |d| {
            if (d == c) seen = true;
        }
        if (!seen) try distinct.append(alloc, c);
    }
    if (distinct.items.len == 0) return try alloc.alloc(NamePair, 0);

    var in_list: std.ArrayList(u8) = .empty;
    defer in_list.deinit(alloc);
    for (distinct.items, 0..) |c, i| {
        if (i != 0) try in_list.append(alloc, ',');
        var b: [24]u8 = undefined;
        try in_list.appendSlice(alloc, std.fmt.bufPrint(&b, "{d}", .{c}) catch unreachable);
    }
    const sql = try std.fmt.allocPrint(alloc, "SELECT Code, Name FROM Master1 WHERE Code IN ({s})", .{in_list.items});
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    var out: std.ArrayList(NamePair) = .empty;
    errdefer {
        for (out.items) |p| alloc.free(p.name);
        out.deinit(alloc);
    }
    if (rows != .arr) return out.toOwnedSlice(alloc);
    for (rows.arr) |*r| {
        if (r.* != .obj) continue;
        const code_v = r.get("Code") orelse continue;
        const name_v = r.get("Name") orelse continue;
        if (code_v.* != .int or name_v.* != .str) continue;
        try out.append(alloc, .{ .code = code_v.int, .name = try alloc.dupe(u8, name_v.str) });
    }
    return out.toOwnedSlice(alloc);
}

pub fn findName(pairs: []const NamePair, code: i64) ?[]const u8 {
    for (pairs) |p| if (p.code == code) return p.name;
    return null;
}

pub fn freePairs(alloc: Allocator, pairs: []NamePair) void {
    for (pairs) |p| alloc.free(p.name);
    alloc.free(pairs);
}

/// Resolve a master's Code by type + exact name (owned result, null when
/// missing). Single query — reports use it before their service calls.
pub fn codeByName(sess: *Session, alloc: Allocator, master_type: i64, name: []const u8) !?i64 {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ master_type, quoted });
    defer alloc.free(sql);
    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr or rows.arr.len == 0) return null;
    const v = (rows.arr[0].get("Code") orelse return null).*;
    if (v != .int) return null;
    return v.int;
}

/// `Busy2L21.CFixedInterface` + class name -> `Busy2L21.<class>` (same
/// generation from the registry scan). Owned — caller frees.
pub fn classProgId(alloc: Allocator, class_name: []const u8) ![]u8 {
    const fi = registry.newestFixedInterface() orelse return error.NoBusyProgId;
    const i = std.mem.indexOf(u8, fi, "CFixedInterface") orelse return error.NoBusyProgId;
    return std.fmt.allocPrint(alloc, "{s}{s}", .{ fi[0..i], class_name });
}

// ---------------- tests ----------------

const testing = std.testing;

test "classProgId derives sibling service classes" {
    const a = testing.allocator;
    if (registry.newestFixedInterface()) |_| {
        const p = try classProgId(a, "CMasterServices");
        defer a.free(p);
        try testing.expect(std.mem.endsWith(u8, p, "CMasterServices"));
        try testing.expect(std.mem.indexOf(u8, p, "CFixedInterface") == null);
    }
}
