//! ERP master reads (issue #7 M1 / 011 phase 1a): normalized list/get —
//! business keys in, codes + names out. Mechanical internals: constants
//! lookup -> escaped SQL on Master1 -> optional GetMasterXML detail
//! parsed to a tree. Shared kinds/type codes live in the barrel
//! (`../masters.zig`); writes live in `write.zig`.
const std = @import("std");
const json = @import("../../util/json.zig");
const xml = @import("../../util/xml.zig");
const helpers = @import("../../util/helpers.zig");
const com = @import("../../core/com.zig");
const common = @import("../common.zig");
const m = @import("../masters.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;
const Kind = m.Kind;
const ListOpts = m.ListOpts;

/// List masters of `kind` normalized to
/// `{kind, count, truncated, items: [{code, name, parent}], page}`.
/// `page` = `{limit, has_more, next_cursor}` (opaque; null cursor on the
/// last page).
pub fn list(sess: *Session, alloc: Allocator, kind: Kind, opts: ListOpts) !json.Value {
    const mt = m.typeCode(kind);
    var keyset: []const u8 = "";
    var keyset_owned: ?[]u8 = null;
    defer if (keyset_owned) |k| alloc.free(k);
    if (opts.cursor) |cur| {
        const decoded = common.decodeCursor(alloc, cur) catch {
            sess.setErr("invalid cursor (use next_cursor from a previous page)", .{});
            return error.BadArgs;
        };
        defer alloc.free(decoded);
        const quoted = try helpers.sqlQuote(alloc, decoded);
        defer alloc.free(quoted);
        const ks = try std.fmt.allocPrint(alloc, " AND Name > '{s}'", .{quoted});
        keyset = ks;
        keyset_owned = ks;
    }
    // limit=0 = unlimited: no TOP clause at all
    var top_owned: ?[]u8 = null;
    defer if (top_owned) |t| alloc.free(t);
    var top: []const u8 = "";
    if (opts.limit != 0) {
        top_owned = try std.fmt.allocPrint(alloc, "TOP {d} ", .{opts.limit + 1});
        top = top_owned.?;
    }
    const sql = if (opts.q == null)
        // fetch limit+1 so "more rows exist" is detectable without a COUNT
        try std.fmt.allocPrint(alloc, "SELECT {s}Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d}{s} ORDER BY Name", .{ top, mt, keyset })
    else
        try std.fmt.allocPrint(alloc, "SELECT Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d}{s} ORDER BY Name", .{ mt, keyset });
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
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, m.kindName(kind)) });
    try common.put(alloc, &out, "count", .{ .int = @intCast(shown) });
    try common.put(alloc, &out, "truncated", .{ .bool = truncated });
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    // page envelope (issue #7 /v1): next_cursor = base64url(last shown Name)
    var page: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &page, "limit", .{ .int = @intCast(opts.limit) });
    try common.put(alloc, &page, "has_more", .{ .bool = truncated });
    if (truncated and shown > 0) {
        const last = rows.arr[matched.items[shown - 1]].get("Name") orelse return error.UnexpectedRows;
        if (try common.stringifyValue(alloc, last)) |last_name| {
            defer alloc.free(last_name);
            try common.put(alloc, &page, "next_cursor", .{ .str = try common.encodeCursor(alloc, last_name) });
        } else {
            try common.put(alloc, &page, "next_cursor", .{ .null = {} });
        }
    } else {
        try common.put(alloc, &page, "next_cursor", .{ .null = {} });
    }
    try common.put(alloc, &out, "page", try common.objFrom(alloc, &page));
    return common.objFrom(alloc, &out);
}

/// Fetch one master by exact business name:
/// `{kind, code, name, parent, doc}` — `doc` is the full GetMasterXML
/// document tree (null when BUSY returns none).
pub fn get(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8) !json.Value {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code, Name, ParentGrp FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ m.typeCode(kind), quoted });
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr or rows.arr.len == 0) {
        sess.setErr("no {s} named '{s}'", .{ m.kindName(kind), name });
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
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, m.kindName(kind)) });
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
