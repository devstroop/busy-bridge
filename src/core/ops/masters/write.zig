//! ERP master writes (issue #7 M2 / 011 phase 1b→1a): normalized
//! create/update/delete over SaveMasterFromXML — fetch-merge-resave so
//! untouched BUSY fields are never wiped. Shared kinds/type codes live
//! in the barrel (`../masters.zig`); reads live in `read.zig`.
const std = @import("std");
const json = @import("../../../util/json.zig");
const xml = @import("../../../util/xml.zig");
const helpers = @import("../../../util/helpers.zig");
const com = @import("../../com.zig");
const common = @import("../common.zig");
const m = @import("../masters.zig");
const read = @import("read.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;
const Kind = m.Kind;

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
    const name = try m.requireStr(sess, fields, "name", "create master requires \"name\"");
    const parent = try m.requireStr(sess, fields, "parent", "create master requires \"parent\" (group name)");
    if (kind == .item) _ = try m.requireStr(sess, fields, "unit", "create item requires \"unit\"");
    _ = parent;

    var doc_fields = fieldsToDoc(alloc, kind, name, fields) catch |err| switch (err) {
        error.BadDocument => {
            sess.setErr("create {s}: fields must be strings; supported: name, parent{s}", .{
                m.kindName(kind),
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

    const code = try saveMaster(sess, alloc, m.typeCode(kind), xml_text, false);
    return identityResult(sess, alloc, kind, name, fields, code);
}

/// Update a master by name: fetch the FULL document, merge the requested
/// field changes, re-save with modify=true — so untouched BUSY fields are
/// never wiped. Rename is not supported (name is the key).
pub fn update(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8, fields: *const json.Value) !json.Value {
    const base = try read.get(sess, alloc, kind, name); // NotFound if missing
    var base_mut = base;
    defer base_mut.deinit(alloc);
    const code = base_mut.get("code") orelse return error.UnexpectedRows;
    if (code.* != .int) return error.UnexpectedRows;
    const doc_val = base_mut.get("doc") orelse return error.UnexpectedRows;
    if (doc_val.* != .obj or doc_val.obj.len == 0) {
        sess.setErr("update {s}: BUSY returned no document for '{s}'", .{ m.kindName(kind), name });
        return error.NotFound;
    }
    // merge mapped changes into the existing root body
    var changes = fieldsToDoc(alloc, kind, null, fields) catch |err| switch (err) {
        error.BadDocument => {
            sess.setErr("update {s}: supported fields: parent{s}", .{ m.kindName(kind), if (kind == .item) ", unit" else "" });
            return error.BadArgs;
        },
        else => return err,
    };
    defer changes.deinit(alloc);
    if (changes == .obj and changes.obj.len == 0) {
        sess.setErr("update {s}: no fields to change (pass parent{s})", .{ m.kindName(kind), if (kind == .item) ", unit" else "" });
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
    _ = try saveMaster(sess, alloc, m.typeCode(kind), xml_text, true);

    return identityResult(sess, alloc, kind, name, fields, code.int);
}

/// Delete a master by name: `{kind, name, code, deleted:true}`.
pub fn delete(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8) !json.Value {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ m.typeCode(kind), quoted });
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
    const code_v = (rows.arr[0].get("Code") orelse return error.UnexpectedRows).*;
    if (code_v != .int) return error.UnexpectedRows;

    var e = try byrefArg(alloc);
    defer e.deinit(alloc);
    var args = [_]json.Value{ .{ .int = code_v.int }, e };
    var r = try sess.invoke("DeleteMasterByCode", &args);
    defer r.deinit(sess.alloc);
    if (!(r.ret == .bool and r.ret.bool)) {
        const msg: []const u8 = if (r.outs.len > 0 and r.outs[0] == .str and r.outs[0].str.len > 0)
            r.outs[0].str
        else
            "DeleteMasterByCode rejected";
        sess.setErr("{s}", .{msg});
        return error.BusyRejected;
    }
    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, m.kindName(kind)) });
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
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, m.kindName(kind)) });
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

// ---------------- tests (pure) ----------------

const testing = std.testing;

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
