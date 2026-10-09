//! ERP voucher reads (issue #7 M1 / 011 phase 1b): normalized list/get
//! from Tran1 + GetVchXML. Business keys in (type name, voucher code),
//! codes + names out. Shared ListOpts lives in the barrel
//! (`../vouchers.zig`); writes live in `write.zig`.
const std = @import("std");
const json = @import("../../../util/json.zig");
const xml = @import("../../../util/xml.zig");
const constants = @import("../../constants.zig");
const com = @import("../../com.zig");
const common = @import("../common.zig");
const v = @import("../vouchers.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;
const ListOpts = v.ListOpts;

/// List vouchers normalized to
/// `{kind, count, truncated, items: [{code, type, no, date, series, party}],
/// page: {limit, has_more, next_cursor}}`.
pub fn list(sess: *Session, alloc: Allocator, opts: ListOpts) !json.Value {
    var where: []const u8 = "";
    var where_owned: ?[]u8 = null;
    defer if (where_owned) |w| alloc.free(w);
    if (opts.type_name) |t| {
        const tc = constants.voucherCode(t) orelse {
            sess.setErr("unknown voucher type '{s}' (see GET /constants)", .{t});
            return error.BadArgs;
        };
        where_owned = try std.fmt.allocPrint(alloc, " WHERE VchType = {d}", .{tc});
        where = where_owned.?;
    }
    // keyset cursor: resume strictly below the last-shown code
    var keyset_owned: ?[]u8 = null;
    defer if (keyset_owned) |k| alloc.free(k);
    if (opts.cursor) |cur| {
        const decoded = common.decodeCursor(alloc, cur) catch {
            sess.setErr("invalid cursor (use next_cursor from a previous page)", .{});
            return error.BadArgs;
        };
        defer alloc.free(decoded);
        const code = std.fmt.parseInt(i64, decoded, 10) catch {
            sess.setErr("invalid cursor (use next_cursor from a previous page)", .{});
            return error.BadArgs;
        };
        const conj: []const u8 = if (opts.type_name != null) " AND" else " WHERE";
        keyset_owned = try std.fmt.allocPrint(alloc, "{s} VchCode < {d}", .{ conj, code });
        if (where_owned) |w| {
            const combined = try std.fmt.allocPrint(alloc, "{s}{s}", .{ w, keyset_owned.? });
            alloc.free(w);
            where_owned = combined;
            where = combined;
        } else {
            where = keyset_owned.?;
        }
    }
    // paging order must match the keyset (VchCode DESC); display order otherwise
    const order: []const u8 = if (opts.cursor != null) "VchCode DESC" else "Date DESC, VchCode DESC";
    // limit=0 = unlimited: no TOP clause at all
    var top_owned: ?[]u8 = null;
    defer if (top_owned) |t| alloc.free(t);
    var top: []const u8 = "";
    if (opts.limit != 0) {
        top_owned = try std.fmt.allocPrint(alloc, "TOP {d} ", .{opts.limit + 1});
        top = top_owned.?;
    }
    const sql = try std.fmt.allocPrint(alloc, "SELECT {s}VchCode, VchType, VchNo, Date, VchSeriesCode, MasterCode1 FROM Tran1{s} ORDER BY {s}", .{ top, where, order });
    defer alloc.free(sql);

    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr) return error.UnexpectedRows;

    // batch-resolve party + series names (one query, codes are global)
    var codes: std.ArrayList(i64) = .empty;
    defer codes.deinit(alloc);
    for (rows.arr) |*r| {
        if (r.* != .obj) continue;
        if (r.get("MasterCode1")) |p| if (p.* == .int) try codes.append(alloc, p.int);
        if (r.get("VchSeriesCode")) |s| if (s.* == .int) try codes.append(alloc, s.int);
    }
    const pairs = try common.resolveNames(sess, alloc, codes.items);
    defer common.freePairs(alloc, pairs);

    const truncated = if (opts.limit == 0) false else rows.arr.len > opts.limit;
    const shown: usize = if (opts.limit == 0) rows.arr.len else @min(rows.arr.len, opts.limit);

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*v2| v2.deinit(alloc);
        items.deinit(alloc);
    }
    for (rows.arr[0..shown]) |*r| {
        var fields: std.ArrayList(json.Value.Entry) = .empty;

        const code = (r.get("VchCode") orelse return error.UnexpectedRows).*;
        try common.put(alloc, &fields, "code", code);

        // type: {code, name} from the canonical constants table
        var te: std.ArrayList(json.Value.Entry) = .empty;
        if (r.get("VchType")) |tv| {
            if (tv.* == .int) {
                try common.put(alloc, &te, "code", .{ .int = tv.int });
                if (constants.voucherName(tv.int)) |tn| {
                    try common.put(alloc, &te, "name", .{ .str = try alloc.dupe(u8, tn) });
                } else {
                    try common.put(alloc, &te, "name", .{ .null = {} });
                }
            }
        }
        try common.put(alloc, &fields, "type", try common.objFrom(alloc, &te));

        if (r.get("VchNo")) |nv| {
            const no = if (try common.stringifyValue(alloc, nv)) |s|
                json.Value{ .str = s }
            else
                json.Value{ .null = {} };
            try common.put(alloc, &fields, "no", no);
        }

        if (r.get("Date")) |dv| {
            var date_val: json.Value = .{ .null = {} };
            if (try common.stringifyValue(alloc, dv)) |raw| {
                defer alloc.free(raw);
                if (try common.normalizeDate(alloc, raw)) |iso| {
                    date_val = .{ .str = iso };
                } else {
                    date_val = .{ .str = try alloc.dupe(u8, raw) };
                }
            }
            try common.put(alloc, &fields, "date", date_val);
        }

        // series + party: resolved {code, name} or null
        for ([2]struct { key: []const u8, col: []const u8 }{
            .{ .key = "series", .col = "VchSeriesCode" },
            .{ .key = "party", .col = "MasterCode1" },
        }) |slot| {
            var resolved: json.Value = .{ .null = {} };
            if (r.get(slot.col)) |sv| {
                if (sv.* == .int) {
                    var se: std.ArrayList(json.Value.Entry) = .empty;
                    try common.put(alloc, &se, "code", .{ .int = sv.int });
                    if (common.findName(pairs, sv.int)) |sn| {
                        try common.put(alloc, &se, "name", .{ .str = try alloc.dupe(u8, sn) });
                    } else {
                        try common.put(alloc, &se, "name", .{ .null = {} });
                    }
                    resolved = try common.objFrom(alloc, &se);
                }
            }
            try common.put(alloc, &fields, slot.key, resolved);
        }

        try items.append(alloc, try common.objFrom(alloc, &fields));
    }

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "voucher") });
    try common.put(alloc, &out, "count", .{ .int = @intCast(shown) });
    try common.put(alloc, &out, "truncated", .{ .bool = truncated });
    try common.put(alloc, &out, "items", .{ .arr = try items.toOwnedSlice(alloc) });
    // page envelope (issue #7 /v1): next_cursor = base64url(last shown VchCode)
    var page: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &page, "limit", .{ .int = @intCast(opts.limit) });
    try common.put(alloc, &page, "has_more", .{ .bool = truncated });
    if (truncated and shown > 0) {
        const last = rows.arr[shown - 1].get("VchCode") orelse return error.UnexpectedRows;
        if (last.* == .int) {
            var b: [24]u8 = undefined;
            const text = try std.fmt.bufPrint(&b, "{d}", .{last.int});
            try common.put(alloc, &page, "next_cursor", .{ .str = try common.encodeCursor(alloc, text) });
        } else {
            try common.put(alloc, &page, "next_cursor", .{ .null = {} });
        }
    } else {
        try common.put(alloc, &page, "next_cursor", .{ .null = {} });
    }
    try common.put(alloc, &out, "page", try common.objFrom(alloc, &page));
    return common.objFrom(alloc, &out);
}

/// Fetch one voucher by code: `{kind, code, root, no, date, series, party,
/// doc}` — `doc` is the full GetVchXML document tree.
pub fn get(sess: *Session, alloc: Allocator, code: i64) !json.Value {
    var r = try sess.invoke("GetVchXML", &.{ .{ .int = code }, .{ .bool = false } });
    defer r.deinit(sess.alloc);
    if (r.ret != .str or r.ret.str.len == 0 or r.ret.str[0] != '<') {
        sess.setErr("no voucher with code {d}", .{code});
        return error.NotFound;
    }

    var el = xml.parse(alloc, r.ret.str) catch {
        sess.setErr("voucher {d}: BUSY returned unparseable XML", .{code});
        return error.NotFound;
    };
    defer el.deinit(alloc);
    const tree = try xml.toJson(alloc, &el);

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "voucher") });
    try common.put(alloc, &out, "code", .{ .int = code });

    if (tree == .obj and tree.obj.len > 0) {
        // document root name (e.g. "Sale") — BUSY's own doc vocabulary
        try common.put(alloc, &out, "root", .{ .str = try alloc.dupe(u8, tree.obj[0].key) });
        const body = &tree.obj[0].val;

        if (try common.childStr(alloc, body, "VchNo")) |no| {
            try common.put(alloc, &out, "no", .{ .str = no });
        } else {
            try common.put(alloc, &out, "no", .{ .null = {} });
        }
        if (try common.childStr(alloc, body, "Date")) |raw| {
            defer alloc.free(raw);
            if (try common.normalizeDate(alloc, raw)) |iso| {
                try common.put(alloc, &out, "date", .{ .str = iso });
            } else {
                try common.put(alloc, &out, "date", .{ .str = try alloc.dupe(u8, raw) });
            }
        } else {
            try common.put(alloc, &out, "date", .{ .null = {} });
        }
        if (try common.childStr(alloc, body, "VchSeriesName")) |s| {
            try common.put(alloc, &out, "series", .{ .str = s });
        } else {
            try common.put(alloc, &out, "series", .{ .null = {} });
        }
        if (try common.childStr(alloc, body, "MasterName1")) |p| {
            try common.put(alloc, &out, "party", .{ .str = p });
        } else {
            try common.put(alloc, &out, "party", .{ .null = {} });
        }
    } else {
        try common.put(alloc, &out, "root", .{ .null = {} });
        try common.put(alloc, &out, "no", .{ .null = {} });
        try common.put(alloc, &out, "date", .{ .null = {} });
        try common.put(alloc, &out, "series", .{ .null = {} });
        try common.put(alloc, &out, "party", .{ .null = {} });
    }
    try common.put(alloc, &out, "doc", tree);
    return common.objFrom(alloc, &out);
}
