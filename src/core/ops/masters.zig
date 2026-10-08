//! ERP master reads (facade M1, issue #7): normalized results — business
//! keys in, codes + names out. Mechanical internals: constants lookup ->
//! escaped SQL on Master1 -> optional GetMasterXML detail parsed to a
//! tree. Never imports transport.
const std = @import("std");
const json = @import("../../util/json.zig");
const xml = @import("../../util/xml.zig");
const helpers = @import("../../util/helpers.zig");
const constants = @import("../constants.zig");
const com = @import("../com.zig");
const common = @import("common.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;

pub const Kind = enum { account, item };

pub fn kindFrom(s: []const u8) ?Kind {
    if (std.ascii.eqlIgnoreCase(s, "account")) return .account;
    if (std.ascii.eqlIgnoreCase(s, "item")) return .item;
    if (std.ascii.eqlIgnoreCase(s, "accounts")) return .account;
    if (std.ascii.eqlIgnoreCase(s, "items")) return .item;
    return null;
}

fn typeCode(kind: Kind) i64 {
    return switch (kind) {
        .account => constants.masterCode("ACCOUNT_MASTER").?,
        .item => constants.masterCode("ITEM_MASTER").?,
    };
}

fn groupTypeCode(kind: Kind) i64 {
    return switch (kind) {
        .account => constants.masterCode("ACCOUNT_GROUP_MASTER").?,
        .item => constants.masterCode("ITEM_GROUP_MASTER").?,
    };
}

pub fn kindName(kind: Kind) []const u8 {
    return switch (kind) {
        .account => "account",
        .item => "item",
    };
}

pub const ListOpts = struct {
    /// 0 = unlimited (same convention as --max-rows).
    limit: usize = 100,
    /// Case-insensitive substring filter on Name — applied client-side
    /// because GetRecordset's LIKE silently returns empty (issue #6).
    q: ?[]const u8 = null,
};

/// List masters of `kind` normalized to
/// `{kind, count, truncated, items: [{code, name, parent}]}`.
pub fn list(sess: *Session, alloc: Allocator, kind: Kind, opts: ListOpts) !json.Value {
    const mt = typeCode(kind);
    const sql = if (opts.q == null)
        // fetch limit+1 so "more rows exist" is detectable without a COUNT
        try std.fmt.allocPrint(alloc, "SELECT TOP {d} Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d} ORDER BY Name", .{ opts.limit + 1, mt })
    else
        try std.fmt.allocPrint(alloc, "SELECT Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d} ORDER BY Name", .{mt});
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr) return error.UnexpectedRows;

    // filter (client-side q) + parent-code collection
    var matched: std.ArrayList(usize) = .empty; // indices into rows.arr
    defer matched.deinit(alloc);
    var parent_codes: std.ArrayList(i64) = .empty;
    defer parent_codes.deinit(alloc);
    for (rows.arr, 0..) |*r, idx| {
        if (r.* != .obj) continue;
        const name_v = r.get("Name") orelse continue;
        if (opts.q) |q| {
            if (name_v.* != .str or !common.containsCi(name_v.str, q)) continue;
        }
        try matched.append(alloc, idx);
        if (r.get("ParentGrp")) |p| {
            if (p.* == .int) try parent_codes.append(alloc, p.int);
        }
    }

    const pairs = try common.resolveNames(sess, alloc, parent_codes.items);
    defer common.freePairs(alloc, pairs);

    const truncated = if (opts.limit == 0) false else matched.items.len > opts.limit;
    const shown: usize = if (opts.limit == 0) matched.items.len else @min(matched.items.len, opts.limit);

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*v| v.deinit(alloc);
        items.deinit(alloc);
    }
    for (matched.items[0..shown]) |idx| {
        const r = &rows.arr[idx];
        var fields: std.ArrayList(json.Value.Entry) = .empty;
        const code = (r.get("Code") orelse return error.UnexpectedRows).*;
        try common.put(alloc, &fields, "code", code);
        const name = (r.get("Name") orelse return error.UnexpectedRows).*;
        const name_text = if (try common.stringifyValue(alloc, &name)) |s|
            json.Value{ .str = s }
        else
            json.Value{ .null = {} };
        try common.put(alloc, &fields, "name", name_text);
        // parent: resolved group {code, name} or null
        var parent_val: json.Value = .{ .null = {} };
        if (r.get("ParentGrp")) |p| {
            if (p.* == .int) {
                var pe: std.ArrayList(json.Value.Entry) = .empty;
                try common.put(alloc, &pe, "code", .{ .int = p.int });
                if (common.findName(pairs, p.int)) |pn| {
                    try common.put(alloc, &pe, "name", .{ .str = try alloc.dupe(u8, pn) });
                } else {
                    try common.put(alloc, &pe, "name", .{ .null = {} });
                }
                parent_val = try common.objFrom(alloc, &pe);
            }
        }
        try common.put(alloc, &fields, "parent", parent_val);
        try items.append(alloc, try common.objFrom(alloc, &fields));
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, kindName(kind)) });
    try common.put(alloc, &out, "count", .{ .int = @intCast(shown) });
    try common.put(alloc, &out, "truncated", .{ .bool = truncated });
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    return common.objFrom(alloc, &out);
}

/// Fetch one master by exact business name:
/// `{kind, code, name, parent, doc}` — `doc` is the full GetMasterXML
/// document tree (null when BUSY returns none).
pub fn get(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8) !json.Value {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ typeCode(kind), quoted });
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr or rows.arr.len == 0) {
        sess.setErr("no {s} named '{s}'", .{ kindName(kind), name });
        return error.NotFound;
    }
    const row = &rows.arr[0];
    const code = (row.get("Code") orelse return error.UnexpectedRows).*;
    const canonical = (row.get("Name") orelse return error.UnexpectedRows).*;

    var parent_val: json.Value = .{ .null = {} };
    if (row.get("ParentGrp")) |p| {
        if (p.* == .int) {
            var codes = [_]i64{p.int};
            const pairs = try common.resolveNames(sess, alloc, &codes);
            defer common.freePairs(alloc, pairs);
            var pe: std.ArrayList(json.Value.Entry) = .empty;
            try common.put(alloc, &pe, "code", .{ .int = p.int });
            if (common.findName(pairs, p.int)) |pn| {
                try common.put(alloc, &pe, "name", .{ .str = try alloc.dupe(u8, pn) });
            } else {
                try common.put(alloc, &pe, "name", .{ .null = {} });
            }
            parent_val = try common.objFrom(alloc, &pe);
        }
    }

    // full detail document — parsed to a tree, never a blob
    var doc_val: json.Value = .{ .null = {} };
    if (code == .int) {
        var r = try sess.invoke("GetMasterXML", &.{ .{ .int = code.int }, .{ .bool = false } });
        defer r.deinit(sess.alloc);
        if (r.ret == .str and r.ret.str.len > 0 and r.ret.str[0] == '<') {
            if (xml.parse(alloc, r.ret.str)) |el| {
                var doc = el;
                defer doc.deinit(alloc);
                doc_val = xml.toJson(alloc, &doc) catch .{ .null = {} };
            } else |_| {}
        }
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, kindName(kind)) });
    try common.put(alloc, &out, "code", code);
    // canonical name lives in session-owned rows — copy before those free
    if (canonical == .str) {
        try common.put(alloc, &out, "name", .{ .str = try alloc.dupe(u8, canonical.str) });
    } else {
        try common.put(alloc, &out, "name", .{ .null = {} });
    }
    try common.put(alloc, &out, "parent", parent_val);
    try common.put(alloc, &out, "doc", doc_val);
    return common.objFrom(alloc, &out);
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "kindFrom accepts singular and plural" {
    try testing.expect(kindFrom("account") == .account);
    try testing.expect(kindFrom("ACCOUNTS") == .account);
    try testing.expect(kindFrom("item") == .item);
    try testing.expect(kindFrom("ledger") == null);
    try testing.expectEqualStrings("account", kindName(.account));
}
