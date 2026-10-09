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
    /// Keyset cursor (issue #7 /v1 paging): the `next_cursor` from a
    /// previous page — the last-shown Name. Rows resume strictly after it
    /// (ORDER BY Name ASC), so pages never overlap or skip.
    cursor: ?[]const u8 = null,
};

/// List masters of `kind` normalized to
/// `{kind, count, truncated, items: [{code, name, parent}], page}`.
/// `page` = `{limit, has_more, next_cursor}` (opaque; null cursor on the
/// last page).
pub fn list(sess: *Session, alloc: Allocator, kind: Kind, opts: ListOpts) !json.Value {
    const mt = typeCode(kind);
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
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, kindName(kind)) });
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

// ---------------- M2 writes (issue #7) ----------------

/// Build the ByRef `{"$byref":""}` argument object (owned on `alloc`).
pub fn byrefArg(alloc: Allocator) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "$byref", .{ .str = try alloc.dupe(u8, "") });
    return common.objFrom(alloc, &e);
}

/// Map normalized request fields to BUSY document element names
/// (parent->ParentGroup, unit->MainUnit for items; `name` -> Name).
/// Owned on `alloc`. Unknown fields or non-string values -> BadDocument
/// (callers translate to a precise bad_args message; the raw `doc`
/// passthrough on post-voucher is the escape hatch for richer shapes).
pub fn fieldsToDoc(alloc: Allocator, kind: Kind, name: ?[]const u8, fields: *const json.Value) !json.Value {
    if (fields.* != .obj) return error.BadDocument;
    var out: std.ArrayList(json.Value.Entry) = .empty;
    errdefer {
        var t = json.Value{ .obj = out.items };
        t.deinit(alloc);
        out.deinit(alloc);
    }
    if (name) |n| try common.put(alloc, &out, "Name", .{ .str = try alloc.dupe(u8, n) });
    for (fields.obj) |e| {
        if (std.mem.eql(u8, e.key, "name")) continue; // positional key wins
        if (e.val != .str) return error.BadDocument;
        const dk: []const u8 = if (std.mem.eql(u8, e.key, "parent"))
            "ParentGroup"
        else if (std.mem.eql(u8, e.key, "unit") and kind == .item)
            "MainUnit"
        else
            return error.BadDocument;
        try common.put(alloc, &out, dk, .{ .str = try alloc.dupe(u8, e.val.str) });
    }
    return common.objFrom(alloc, &out);
}

/// Serialize a single-root document object {"Account":{...}} to BUSY XML.
pub fn docToXml(alloc: Allocator, doc: *const json.Value) ![]u8 {
    var el = try xml.fromJson(alloc, doc);
    defer el.deinit(alloc);
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);
    try xml.writeDocument(alloc, &out, &el);
    return out.toOwnedSlice(alloc);
}

/// SaveMasterFromXML with the 5-arg ByRef form:
/// `[type, xml, $err, modify, $code]` -> `outs = [err, masterCode]`
/// (probe-verified: p_MasterCode comes back; p_Source wants an int and
/// is skipped as optional).
fn saveMaster(sess: *Session, alloc: Allocator, mt: i64, xml_text: []const u8, modify: bool) !i64 {
    var e1 = try byrefArg(alloc);
    defer e1.deinit(alloc);
    var e2 = try byrefArg(alloc);
    defer e2.deinit(alloc);
    var args = [_]json.Value{
        .{ .int = mt },
        .{ .str = xml_text },
        e1,
        .{ .bool = modify },
        e2,
    };
    var r = try sess.invoke("SaveMasterFromXML", &args);
    defer r.deinit(sess.alloc);
    const ok = r.ret == .bool and r.ret.bool;
    const err_msg: ?[]const u8 = if (r.outs.len > 0 and r.outs[0] == .str and r.outs[0].str.len > 0)
        r.outs[0].str
    else
        null;
    if (!ok) {
        sess.setErr("{s}", .{err_msg orelse "SaveMasterFromXML rejected the document"});
        return error.BusyRejected;
    }
    if (r.outs.len > 1 and r.outs[1] == .int) return r.outs[1].int;
    return 0; // code unknown — callers may resolve by name
}

/// Create a master: `{kind, code, name, parent?}`.
pub fn create(sess: *Session, alloc: Allocator, kind: Kind, fields: *const json.Value) !json.Value {
    const name = try requireStr(sess, fields, "name", "create master requires \"name\"");
    const parent = try requireStr(sess, fields, "parent", "create master requires \"parent\" (group name)");
    if (kind == .item) _ = try requireStr(sess, fields, "unit", "create item requires \"unit\"");
    _ = parent;

    var doc_fields = fieldsToDoc(alloc, kind, name, fields) catch |err| switch (err) {
        error.BadDocument => {
            sess.setErr("create {s}: fields must be strings; supported: name, parent{s}", .{
                kindName(kind),
                if (kind == .item) ", unit" else "",
            });
            return error.BadArgs;
        },
        else => return err,
    };
    defer doc_fields.deinit(alloc);
    var doc: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &doc, switch (kind) {
        .account => "Account",
        .item => "Item",
    }, doc_fields); // ownership moves into doc
    doc_fields = .{ .null = {} }; // neutered — `doc` frees it now

    var doc_val = try common.objFrom(alloc, &doc);
    defer doc_val.deinit(alloc);
    const xml_text = try docToXml(alloc, &doc_val);
    defer alloc.free(xml_text);

    const code = try saveMaster(sess, alloc, typeCode(kind), xml_text, false);
    return identityResult(sess, alloc, kind, name, fields, code);
}

/// Update a master by name: fetch the FULL document, merge the requested
/// field changes, re-save with modify=true — so untouched BUSY fields are
/// never wiped. Rename is not supported (name is the key).
pub fn update(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8, fields: *const json.Value) !json.Value {
    const base = try get(sess, alloc, kind, name); // NotFound if missing
    var base_mut = base;
    defer base_mut.deinit(alloc);
    const code = base_mut.get("code") orelse return error.UnexpectedRows;
    if (code.* != .int) return error.UnexpectedRows;
    const doc_val = base_mut.get("doc") orelse return error.UnexpectedRows;
    if (doc_val.* != .obj or doc_val.obj.len == 0) {
        sess.setErr("update {s}: BUSY returned no document for '{s}'", .{ kindName(kind), name });
        return error.NotFound;
    }
    // merge mapped changes into the existing root body
    var changes = fieldsToDoc(alloc, kind, null, fields) catch |err| switch (err) {
        error.BadDocument => {
            sess.setErr("update {s}: supported fields: parent{s}", .{ kindName(kind), if (kind == .item) ", unit" else "" });
            return error.BadArgs;
        },
        else => return err,
    };
    defer changes.deinit(alloc);
    if (changes == .obj and changes.obj.len == 0) {
        sess.setErr("update {s}: no fields to change (pass parent{s})", .{ kindName(kind), if (kind == .item) ", unit" else "" });
        return error.BadArgs;
    }
    const root_key = doc_val.obj[0].key;
    const root_body = &doc_val.obj[0].val;
    var merged_body = try common.mergeRoot(alloc, root_body, &changes);
    defer merged_body.deinit(alloc);

    // rebuild {"Root": merged}
    var wrapper: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &wrapper, root_key, merged_body);
    merged_body = .{ .null = {} }; // ownership moved into wrapper
    var doc_val2 = try common.objFrom(alloc, &wrapper);
    defer doc_val2.deinit(alloc);

    const xml_text = try docToXml(alloc, &doc_val2);
    defer alloc.free(xml_text);
    _ = try saveMaster(sess, alloc, typeCode(kind), xml_text, true);

    return identityResult(sess, alloc, kind, name, fields, code.int);
}

/// Delete a master by name: `{kind, name, code, deleted:true}`.
pub fn delete(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8) !json.Value {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ typeCode(kind), quoted });
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
    const code_v = (rows.arr[0].get("Code") orelse return error.UnexpectedRows).*;
    if (code_v != .int) return error.UnexpectedRows;

    var e = try byrefArg(alloc);
    defer e.deinit(alloc);
    var args = [_]json.Value{ .{ .int = code_v.int }, e };
    var r = try sess.invoke("DeleteMasterByCode", &args);
    defer r.deinit(sess.alloc);
    if (!(r.ret == .bool and r.ret.bool)) {
        const m: []const u8 = if (r.outs.len > 0 and r.outs[0] == .str and r.outs[0].str.len > 0)
            r.outs[0].str
        else
            "DeleteMasterByCode rejected";
        sess.setErr("{s}", .{m});
        return error.BusyRejected;
    }
    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, kindName(kind)) });
    try common.put(alloc, &out, "name", .{ .str = try alloc.dupe(u8, name) });
    try common.put(alloc, &out, "code", code_v);
    try common.put(alloc, &out, "deleted", .{ .bool = true });
    return common.objFrom(alloc, &out);
}

/// Shared response for create/update: identity + parent + changed fields.
fn identityResult(
    sess: *Session,
    alloc: Allocator,
    kind: Kind,
    name: []const u8,
    fields: *const json.Value,
    code: i64,
) !json.Value {
    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, kindName(kind)) });
    try common.put(alloc, &out, "code", .{ .int = code });
    try common.put(alloc, &out, "name", .{ .str = try alloc.dupe(u8, name) });
    if (fields.* == .obj) {
        if (fields.get("parent")) |p| {
            if (p.* == .str) try common.put(alloc, &out, "parent", .{ .str = try alloc.dupe(u8, p.str) });
        }
        if (fields.get("unit")) |u| {
            if (u.* == .str) try common.put(alloc, &out, "unit", .{ .str = try alloc.dupe(u8, u.str) });
        }
    }
    _ = sess;
    return common.objFrom(alloc, &out);
}

/// Required string field or BadArgs with a precise message.
pub fn requireStr(sess: *Session, fields: *const json.Value, key: []const u8, msg: []const u8) ![]const u8 {
    if (fields.* != .obj) {
        sess.setErr("{s} (request must be a JSON object)", .{msg});
        return error.BadArgs;
    }
    const v = fields.get(key) orelse {
        sess.setErr("{s}", .{msg});
        return error.BadArgs;
    };
    if (v.* != .str or v.str.len == 0) {
        sess.setErr("{s} (must be a non-empty string)", .{msg});
        return error.BadArgs;
    }
    return v.str;
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

test "fieldsToDoc maps normalized fields" {
    const a = testing.allocator;
    var acc = try json.parse(a, "{\"parent\":\"Cash-in-hand\"}");
    defer acc.deinit(a);
    var d1 = try fieldsToDoc(a, .account, "Zig Acct", &acc);
    defer d1.deinit(a);
    try testing.expectEqualStrings("Zig Acct", d1.get("Name").?.str);
    try testing.expectEqualStrings("Cash-in-hand", d1.get("ParentGroup").?.str);

    var item = try json.parse(a, "{\"parent\":\"General\",\"unit\":\"Pcs.\"}");
    defer item.deinit(a);
    var d2 = try fieldsToDoc(a, .item, "ZigIt", &item);
    defer d2.deinit(a);
    try testing.expectEqualStrings("Pcs.", d2.get("MainUnit").?.str);

    // unknown field rejected (unit is item-only)
    var bad = try json.parse(a, "{\"parent\":\"General\",\"unit\":\"Pcs.\"}");
    defer bad.deinit(a);
    try testing.expectError(error.BadDocument, fieldsToDoc(a, .account, "X", &bad));
    var bad2 = try json.parse(a, "{\"gizmo\":\"x\"}");
    defer bad2.deinit(a);
    try testing.expectError(error.BadDocument, fieldsToDoc(a, .account, "X", &bad2));

    // doc round-trip: XML serialization of a mapped account doc
    var acc2 = try json.parse(a, "{\"parent\":\"Cash-in-hand\"}");
    defer acc2.deinit(a);
    var d3 = try fieldsToDoc(a, .account, "T", &acc2);
    defer d3.deinit(a);
    var wrap: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(a, &wrap, "Account", d3);
    d3 = .{ .null = {} };
    var wv = try common.objFrom(a, &wrap);
    defer wv.deinit(a);
    const xml_text = try docToXml(a, &wv);
    defer a.free(xml_text);
    try testing.expectEqualStrings("<Account><Name>T</Name><ParentGroup>Cash-in-hand</ParentGroup></Account>", xml_text);
}
