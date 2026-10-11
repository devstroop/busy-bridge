//! ERP master writes (issue #7 M2 / 011 phase 1b→1a): normalized
//! create/update/delete over SaveMasterFromXML — fetch-merge-resave so
//! untouched BUSY fields are never wiped. Shared kinds/type codes live
//! in the barrel (`../masters.zig`); reads live in `read.zig`.
const std = @import("std");
const json = @import("../../util/json.zig");
const xml = @import("../../util/xml.zig");
const helpers = @import("../../util/helpers.zig");
const com = @import("../../core/com.zig");
const common = @import("../common.zig");
const m = @import("../masters.zig");
const read = @import("read.zig");
const fields = @import("fields.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;
const Kind = m.Kind;

/// Build the ByRef `{"$byref":""}` argument object (owned on `alloc`).
pub fn byrefArg(alloc: Allocator) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "$byref", .{ .str = try alloc.dupe(u8, "") });
    return common.objFrom(alloc, &e);
}

/// Map normalized request fields to BUSY document elements through the
/// per-kind field registry (`fields.zig`, WP2): parent -> ParentGroup
/// (ParentGroupName on account groups), unit -> MainUnit for items,
/// `name` -> Name, plus each kind's probe-verified keys. Values render as
/// XML text — strings copy, numbers print decimal, booleans emit BUSY's
/// "True"/"False". Owned on `alloc`. Unknown fields or wrong value types
/// -> BadDocument (callers translate to a precise bad_args message).
pub fn fieldsToDoc(alloc: Allocator, kind: Kind, name: ?[]const u8, fval: *const json.Value) !json.Value {
    if (fval.* != .obj) return error.BadDocument;
    var out: std.ArrayList(json.Value.Entry) = .empty;
    errdefer {
        // free entries + buffer; a Value.deinit over out.items would free
        // the slice with len != capacity (wrong-size free) and then
        // out.deinit would free it again (issue 011: latent double-free,
        // crashed the never-run test under the safe test allocator)
        for (out.items) |*e| {
            e.val.deinit(alloc);
            alloc.free(e.key);
        }
        out.deinit(alloc);
    }
    if (name) |n| try common.put(alloc, &out, "Name", .{ .str = try alloc.dupe(u8, n) });
    for (fval.obj) |e| {
        if (std.mem.eql(u8, e.key, "name")) continue; // positional key wins
        const fd = findField(kind, e.key) orelse return error.BadDocument;
        const val: json.Value = switch (fd.ty) {
            .str => blk: {
                if (e.val != .str) return error.BadDocument;
                break :blk json.Value{ .str = try alloc.dupe(u8, e.val.str) };
            },
            .num => blk: {
                switch (e.val) {
                    .int => |i| break :blk json.Value{ .str = try std.fmt.allocPrint(alloc, "{d}", .{i}) },
                    .float => |f2| break :blk json.Value{ .str = try std.fmt.allocPrint(alloc, "{d}", .{f2}) },
                    else => return error.BadDocument,
                }
            },
            .bool => blk: {
                if (e.val != .bool) return error.BadDocument;
                break :blk json.Value{ .str = try alloc.dupe(u8, if (e.val.bool) "True" else "False") };
            },
        };
        try common.put(alloc, &out, fd.elem, val);
    }
    return common.objFrom(alloc, &out);
}

/// Registry lookup for one request key.
fn findField(kind: Kind, key: []const u8) ?fields.Field {
    for (fields.fieldsFor(kind)) |f| if (std.mem.eql(u8, f.key, key)) return f;
    return null;
}

/// "parent, unit" — the kind's writable field keys for error messages
/// (owned on `alloc`; empty when the kind's only element is `<Name>`).
fn supportedFieldsText(alloc: Allocator, kind: Kind) ![]u8 {
    var buf: std.ArrayList(u8) = .empty;
    errdefer buf.deinit(alloc);
    for (fields.fieldsFor(kind), 0..) |f, i| {
        if (i > 0) try buf.appendSlice(alloc, ", ");
        try buf.appendSlice(alloc, f.key);
    }
    return buf.toOwnedSlice(alloc);
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

/// Create a master: `{kind, code, name, parent?, unit?}`.
pub fn create(sess: *Session, alloc: Allocator, kind: Kind, fields_arg: *const json.Value) !json.Value {
    // Fail-closed gate first (WP2): the dispatcher now reaches every kind,
    // so read-only kinds answer precisely before any field validation.
    const wrap_name = m.wrapElement(kind) orelse {
        sess.setErr("create {s}: writes for this kind are not wired yet (reads only)", .{m.kindName(kind)});
        return error.BadArgs;
    };
    const name = try m.requireStr(sess, fields_arg, "name", "create master requires \"name\"");
    if (m.needsParent(kind)) _ = try m.requireStr(sess, fields_arg, "parent", "create master requires \"parent\" (group name)");
    if (kind == .item) _ = try m.requireStr(sess, fields_arg, "unit", "create item requires \"unit\"");

    var doc_fields = fieldsToDoc(alloc, kind, name, fields_arg) catch |err| switch (err) {
        error.BadDocument => {
            const list = try supportedFieldsText(alloc, kind);
            defer alloc.free(list);
            const detail = if (list.len == 0)
                try std.fmt.allocPrint(alloc, "supported: name", .{})
            else
                try std.fmt.allocPrint(alloc, "supported: name, {s}", .{list});
            defer alloc.free(detail);
            sess.setErr("create {s}: fields must be strings, numbers or booleans; {s}", .{ m.kindName(kind), detail });
            return error.BadArgs;
        },
        else => return err,
    };
    defer doc_fields.deinit(alloc);
    var doc: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &doc, wrap_name, doc_fields); // ownership moves into doc
    doc_fields = .{ .null = {} }; // neutered — `doc` frees it now

    var doc_val = try common.objFrom(alloc, &doc);
    defer doc_val.deinit(alloc);
    const xml_text = try docToXml(alloc, &doc_val);
    defer alloc.free(xml_text);

    const code0 = try saveMaster(sess, alloc, m.typeCode(kind), xml_text, false);
    // BUSY's $code ByRef comes back empty for some master types (probe:
    // account-group/item-group/tax-category create) - resolve the real
    // Master1 Code by exact name so responses never report code 0.
    const code = if (code0 == 0) try resolveCode(sess, alloc, kind, name) else code0;
    return identityResult(sess, alloc, kind, name, fields_arg, code);
}

/// Exact-name Code lookup (owned temporaries freed; 0 when absent).
fn resolveCode(sess: *Session, alloc: Allocator, kind: Kind, name: []const u8) !i64 {
    const quoted = try helpers.sqlQuote(alloc, name);
    defer alloc.free(quoted);
    const sql = try std.fmt.allocPrint(alloc, "SELECT TOP 1 Code FROM Master1 WHERE MasterType = {d} AND Name = '{s}'", .{ m.typeCode(kind), quoted });
    defer alloc.free(sql);
    const rows = try sess.queryToJson(sql);
    defer {
        var t = rows;
        t.deinit(sess.alloc);
    }
    if (rows != .arr or rows.arr.len == 0) return 0;
    const cv = (rows.arr[0].get("Code") orelse return 0).*;
    if (cv == .int) return cv.int;
    return 0;
}

/// Update a master by name: fetch the FULL document, merge the requested
/// field changes, re-save with modify=true — so untouched BUSY fields are
/// never wiped. Rename is not supported (name is the key).
pub fn update(sess: *Session, alloc: Allocator, kind: Kind, fields_arg: *const json.Value) !json.Value {
    // fail-closed gate first (mirrors create; WP2)
    if (m.wrapElement(kind) == null) {
        sess.setErr("update {s}: writes for this kind are not wired yet (reads only)", .{m.kindName(kind)});
        return error.BadArgs;
    }
    const name = try m.requireStr(sess, fields_arg, "name", "update requires \"name\" (the master to change)");
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
    var changes = fieldsToDoc(alloc, kind, null, fields_arg) catch |err| switch (err) {
        error.BadDocument => {
            const list = try supportedFieldsText(alloc, kind);
            defer alloc.free(list);
            const detail = if (list.len == 0)
                try std.fmt.allocPrint(alloc, "no writable fields for this kind", .{})
            else
                try std.fmt.allocPrint(alloc, "supported fields: {s}", .{list});
            defer alloc.free(detail);
            sess.setErr("update {s}: fields must be strings, numbers or booleans; {s}", .{ m.kindName(kind), detail });
            return error.BadArgs;
        },
        else => return err,
    };
    defer changes.deinit(alloc);
    if (changes == .obj and changes.obj.len == 0) {
        const list = try supportedFieldsText(alloc, kind);
        defer alloc.free(list);
        if (list.len == 0) {
            sess.setErr("update {s}: this kind has no updatable fields via the API", .{m.kindName(kind)});
        } else {
            sess.setErr("update {s}: no fields to change (pass one of: {s})", .{ m.kindName(kind), list });
        }
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

    return identityResult(sess, alloc, kind, name, fields_arg, code.int);
}

/// Delete a master by name: `{kind, name, code, deleted:true}`.
pub fn delete(sess: *Session, alloc: Allocator, kind: Kind, fields_arg: *const json.Value) !json.Value {
    // Probe-verified capability (WP2): BUSY 14's COM delete crashes with
    // no IErrorInfo and does NOT delete for units, sale/purchase-types,
    // stores and bill-sundries — and read-only kinds have nothing to
    // delete through this API. Fail closed before any field validation.
    if (!m.canDelete(kind)) {
        sess.setErr("delete {s}: COM delete is not reliable for this kind on BUSY 14 (delete from the BUSY GUI)", .{m.kindName(kind)});
        return error.BadArgs;
    }
    const name = try m.requireStr(sess, fields_arg, "name", "delete requires \"name\"");
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
    fields_arg: *const json.Value,
    code: i64,
) !json.Value {
    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, m.kindName(kind)) });
    try common.put(alloc, &out, "code", .{ .int = code });
    try common.put(alloc, &out, "name", .{ .str = try alloc.dupe(u8, name) });
    if (fields_arg.* == .obj) {
        if (fields_arg.get("parent")) |p| {
            if (p.* == .str) try common.put(alloc, &out, "parent", .{ .str = try alloc.dupe(u8, p.str) });
        }
        if (fields_arg.get("unit")) |u| {
            if (u.* == .str) try common.put(alloc, &out, "unit", .{ .str = try alloc.dupe(u8, u.str) });
        }
    }
    _ = sess;
    return common.objFrom(alloc, &out);
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "fieldsToDoc maps normalized fields through the registry" {
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

    // typed values: number -> decimal text, boolean -> BUSY's "True"
    var st = try json.parse(a, "{\"sale_account\":\"Sales\",\"tax_percent\":18,\"taxable\":true}");
    defer st.deinit(a);
    var d3 = try fieldsToDoc(a, .sale_type, "ZigST", &st);
    defer d3.deinit(a);
    try testing.expectEqualStrings("Sales", d3.get("SaleAccount").?.str);
    try testing.expectEqualStrings("18", d3.get("TaxPercent").?.str);
    try testing.expectEqualStrings("True", d3.get("Taxable").?.str);

    // account-group parent lands on ParentGroupName (probe dump)
    var ag = try json.parse(a, "{\"parent\":\"Current Assets\"}");
    defer ag.deinit(a);
    var dag = try fieldsToDoc(a, .account_group, "ZigAG", &ag);
    defer dag.deinit(a);
    try testing.expectEqualStrings("Current Assets", dag.get("ParentGroupName").?.str);

    // unknown field / wrong value type -> BadDocument
    var bad = try json.parse(a, "{\"parent\":\"General\",\"unit\":\"Pcs.\"}");
    defer bad.deinit(a);
    try testing.expectError(error.BadDocument, fieldsToDoc(a, .account, "X", &bad));
    var bad2 = try json.parse(a, "{\"gizmo\":\"x\"}");
    defer bad2.deinit(a);
    try testing.expectError(error.BadDocument, fieldsToDoc(a, .account, "X", &bad2));
    var bad3 = try json.parse(a, "{\"taxable\":\"yes\"}"); // bool field given a string
    defer bad3.deinit(a);
    try testing.expectError(error.BadDocument, fieldsToDoc(a, .sale_type, "X", &bad3));
    var bad4 = try json.parse(a, "{\"tax_percent\":\"18\"}"); // num field given a string
    defer bad4.deinit(a);
    try testing.expectError(error.BadDocument, fieldsToDoc(a, .sale_type, "X", &bad4));

    // doc round-trip: XML serialization of a mapped account doc
    var acc2 = try json.parse(a, "{\"parent\":\"Cash-in-hand\"}");
    defer acc2.deinit(a);
    var d3b = try fieldsToDoc(a, .account, "T", &acc2);
    defer d3b.deinit(a);
    var wrap: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(a, &wrap, "Account", d3b);
    d3b = .{ .null = {} };
    var wv = try common.objFrom(a, &wrap);
    defer wv.deinit(a);
    const xml_text = try docToXml(a, &wv);
    defer a.free(xml_text);
    try testing.expectEqualStrings("<Account><Name>T</Name><ParentGroup>Cash-in-hand</ParentGroup></Account>", xml_text);
}
