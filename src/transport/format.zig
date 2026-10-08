//! Request-scoped wire formats: JSON (default) and XML.
//!
//! Negotiation:
//!   CLI     --out json|xml          (default json)
//!   HTTP    Accept: application/xml -> XML response (default JSON)
//!   HTTP    Content-Type: application/xml on POST /call -> raw XML request
//!           body (method/type/modify ride in the query string)
//!
//! JSON mode stays XML-free for document results: Get*XML output is parsed
//! into a structured tree, Save*/Add*XML input accepts a single-key document
//! object and is serialized to BUSY's XML before the COM call (a raw XML
//! string argument is passed through unchanged for backward compatibility).
//!
//! XML mode envelopes (see tests for exact shapes):
//!   query -> ADO rowset XML identical in structure to the legacy web
//!            service SC=1 response (consumers migrating from port 981)
//!   Get*XML -> raw document passthrough, byte-identical
//!   errors -> <Error code="...">message</Error> (code = HTTP status / exit)
const std = @import("std");
const json = @import("../util/json.zig");
const xml = @import("../util/xml.zig");
const xml_write = @import("../util/xml/write.zig");
const busyc = @import("../core/com.zig");
const xmlmeta = @import("../core/xmlmeta.zig");
const constants = @import("../core/constants.zig");

const Allocator = std.mem.Allocator;

pub const Format = enum { json, xml };

pub const ct_json = "application/json";
pub const ct_xml = "application/xml";

pub fn fromOutFlag(s: []const u8) !Format {
    if (std.mem.eql(u8, s, "json")) return .json;
    if (std.mem.eql(u8, s, "xml")) return .xml;
    return error.BadOutFormat;
}

fn containsCi(hay: []const u8, needle: []const u8) bool {
    if (needle.len == 0 or hay.len < needle.len) return false;
    var i: usize = 0;
    while (i + needle.len <= hay.len) : (i += 1) {
        if (std.ascii.eqlIgnoreCase(hay[i .. i + needle.len], needle)) return true;
    }
    return false;
}

/// HTTP Accept negotiation: any flavor of xml wins; everything else JSON.
pub fn acceptFormat(accept: []const u8) Format {
    return if (containsCi(accept, "xml")) .xml else .json;
}

pub fn bodyIsXml(content_type: []const u8) bool {
    return containsCi(content_type, "xml");
}

/// JSON mode: replace an xml-out method's string result with the parsed
/// document tree so JSON consumers never see an XML blob. Unparseable
/// results stay strings (robustness over strictness).
pub fn enrichCallResult(alloc: Allocator, method: []const u8, res: *busyc.CallResult) !void {
    if (xmlmeta.kind(method) != .out) return;
    if (res.ret != .str) return;
    if (res.ret.str.len == 0 or res.ret.str[0] != '<') return;
    var doc = xml.parse(alloc, res.ret.str) catch return;
    const tree = xml.toJson(alloc, &doc) catch {
        doc.deinit(alloc);
        return;
    };
    doc.deinit(alloc);
    res.ret.deinit(alloc);
    res.ret = tree;
}

/// Both modes: for xml-in methods a single-key document object at args[1]
/// (`{"Account":{...}}`) is serialized to BUSY XML in place. Raw XML strings
/// and non-objects pass through untouched. Non single-key objects fail with
/// error.BadDocument (the shape is ambiguous without a root name).
pub fn xmlifyArgsInPlace(alloc: Allocator, method: []const u8, args: []json.Value) !void {
    if (xmlmeta.kind(method) != .in) return;
    if (args.len < 2) return;
    if (args[1] != .obj) return;
    var doc = try xml.fromJson(alloc, &args[1]);
    defer doc.deinit(alloc);
    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);
    try xml_write.writeDocument(alloc, &out, &doc);
    const text = try out.toOwnedSlice(alloc);
    errdefer alloc.free(text);
    args[1].deinit(alloc);
    args[1] = .{ .str = text };
}

/// XML mode: raw passthrough applies only to classified xml-out methods
/// whose result really is a document.
pub fn isPassthrough(method: []const u8, res: *const busyc.CallResult) bool {
    if (xmlmeta.kind(method) != .out) return false;
    if (res.ret != .str) return false;
    return res.ret.str.len > 0 and res.ret.str[0] == '<';
}

// ---------------- XML response builders ----------------

fn scalarInto(alloc: Allocator, out: *std.ArrayList(u8), v: *const json.Value) !void {
    switch (v.*) {
        .null => {},
        .str => |s| try xml_write.escapeText(alloc, out, s),
        .bool => |b| try out.appendSlice(alloc, if (b) "true" else "false"),
        .int => |i| {
            var b: [32]u8 = undefined;
            try out.appendSlice(alloc, std.fmt.bufPrint(&b, "{d}", .{i}) catch unreachable);
        },
        .float => |f| {
            var b: [64]u8 = undefined;
            try out.appendSlice(alloc, std.fmt.bufPrint(&b, "{d}", .{f}) catch unreachable);
        },
        .arr, .obj => {
            // complex non-document value: embed its JSON text (marked below)
            var tmp: std.ArrayList(u8) = .empty;
            defer tmp.deinit(alloc);
            var w = json.Writer{ .buf = &tmp, .alloc = alloc };
            try json.stringify(v, &w);
            try xml_write.escapeText(alloc, out, tmp.items);
        },
    }
}

fn taggedScalar(alloc: Allocator, out: *std.ArrayList(u8), tag: []const u8, v: *const json.Value) !void {
    if (v.* == .null) {
        try out.appendSlice(alloc, "<");
        try out.appendSlice(alloc, tag);
        try out.appendSlice(alloc, "/>");
        return;
    }
    try out.appendSlice(alloc, "<");
    try out.appendSlice(alloc, tag);
    if (v.* == .arr or v.* == .obj) try out.appendSlice(alloc, " json='true'");
    try out.appendSlice(alloc, ">");
    try scalarInto(alloc, out, v);
    try out.appendSlice(alloc, "</");
    try out.appendSlice(alloc, tag);
    try out.appendSlice(alloc, ">");
}

pub fn errorXml(alloc: Allocator, code: []const u8, machine: []const u8, msg: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    try out.appendSlice(alloc, "<Error code='");
    try xml_write.escapeAttr(alloc, &out, code);
    try out.appendSlice(alloc, "' error='");
    try xml_write.escapeAttr(alloc, &out, machine);
    try out.appendSlice(alloc, "'>");
    try xml_write.escapeText(alloc, &out, msg);
    try out.appendSlice(alloc, "</Error>");
    return out.toOwnedSlice(alloc);
}

/// GET /constants — canonical master/voucher code tables (core/constants.zig)
/// as data; the machine-readable twin of docs/constants.md.
pub fn constantsJson(alloc: Allocator) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,\"masters\":{");
    for (constants.masters, 0..) |m, i| {
        if (i != 0) try w.raw(",");
        try w.field(m.name);
        var b: [24]u8 = undefined;
        try w.raw(std.fmt.bufPrint(&b, "{d}", .{m.code}) catch unreachable);
    }
    try w.raw("},\"vouchers\":{");
    for (constants.vouchers, 0..) |v, i| {
        if (i != 0) try w.raw(",");
        try w.field(v.name);
        var b: [24]u8 = undefined;
        try w.raw(std.fmt.bufPrint(&b, "{d}", .{v.code}) catch unreachable);
    }
    try w.raw("}}");
    return out.toOwnedSlice(alloc);
}

pub fn constantsXml(alloc: Allocator) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var b: [24]u8 = undefined;
    try out.appendSlice(alloc, "<Constants><Masters>");
    for (constants.masters) |m| {
        try out.appendSlice(alloc, "<Master code='");
        try out.appendSlice(alloc, std.fmt.bufPrint(&b, "{d}", .{m.code}) catch unreachable);
        try out.appendSlice(alloc, "' name='");
        try xml_write.escapeAttr(alloc, &out, m.name);
        try out.appendSlice(alloc, "'/>");
    }
    try out.appendSlice(alloc, "</Masters><Vouchers>");
    for (constants.vouchers) |v| {
        try out.appendSlice(alloc, "<Voucher code='");
        try out.appendSlice(alloc, std.fmt.bufPrint(&b, "{d}", .{v.code}) catch unreachable);
        try out.appendSlice(alloc, "' name='");
        try xml_write.escapeAttr(alloc, &out, v.name);
        try out.appendSlice(alloc, "'/>");
    }
    try out.appendSlice(alloc, "</Vouchers></Constants>");
    return out.toOwnedSlice(alloc);
}

/// GET /info — identity/capabilities of the running serve process.
pub fn infoJson(alloc: Allocator, version: []const u8, prog_id: []const u8, comp: ?[]const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,\"bridge\":\"busy-bridge\",\"version\":");
    try w.str(version);
    try w.raw(",\"prog_id\":");
    try w.str(prog_id);
    try w.raw(",\"company\":");
    if (comp) |c| try w.str(c) else try w.raw("null");
    try w.raw(",\"formats\":[\"json\",\"xml\"],\"routes\":[\"/health\",\"/info\",\"/constants\",\"/surface\",\"/classes\",\"/query\",\"/call\",\"/op\",\"/op/accounts\",\"/op/account\",\"/op/items\",\"/op/item\",\"/op/vouchers\",\"/op/voucher\",\"/op/batch\"]}");
    return out.toOwnedSlice(alloc);
}

pub fn infoXml(alloc: Allocator, version: []const u8, prog_id: []const u8, comp: ?[]const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    try out.appendSlice(alloc, "<Info bridge='busy-bridge' version='");
    try xml_write.escapeAttr(alloc, &out, version);
    try out.appendSlice(alloc, "' prog_id='");
    try xml_write.escapeAttr(alloc, &out, prog_id);
    try out.appendSlice(alloc, "' company='");
    if (comp) |c| try xml_write.escapeAttr(alloc, &out, c);
    try out.appendSlice(alloc, "'><Format>json</Format><Format>xml</Format><Route path='/health'/><Route path='/info'/><Route path='/constants'/><Route path='/surface'/><Route path='/classes'/><Route path='/query'/><Route path='/call'/><Route path='/op'/><Route path='/op/accounts'/><Route path='/op/account'/><Route path='/op/items'/><Route path='/op/item'/><Route path='/op/vouchers'/><Route path='/op/voucher'/><Route path='/op/batch'/></Info>");
    return out.toOwnedSlice(alloc);
}

pub fn healthXml(alloc: Allocator) ![]u8 {
    return try alloc.dupe(u8, "<Health status='up'/>");
}

pub fn classesXml(alloc: Allocator, classes: []const []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var buf: [32]u8 = undefined;
    try out.appendSlice(alloc, "<Classes count='");
    try out.appendSlice(alloc, std.fmt.bufPrint(&buf, "{d}", .{classes.len}) catch unreachable);
    try out.appendSlice(alloc, "'>");
    for (classes) |c| {
        try out.appendSlice(alloc, "<Class>");
        try xml_write.escapeText(alloc, &out, c);
        try out.appendSlice(alloc, "</Class>");
    }
    try out.appendSlice(alloc, "</Classes>");
    return out.toOwnedSlice(alloc);
}

pub fn surfaceXml(
    alloc: Allocator,
    prog_id: []const u8,
    members: []const busyc.Member,
    filter: ?[]const u8,
) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var buf: [32]u8 = undefined;
    var shown: usize = 0;
    for (members) |m| {
        if (filter) |f| {
            if (!std.ascii.eqlIgnoreCase(m.name, f)) continue;
        }
        shown += 1;
    }
    try out.appendSlice(alloc, "<Surface prog_id='");
    try xml_write.escapeAttr(alloc, &out, prog_id);
    try out.appendSlice(alloc, "' count='");
    try out.appendSlice(alloc, std.fmt.bufPrint(&buf, "{d}", .{shown}) catch unreachable);
    try out.appendSlice(alloc, "'>");
    for (members) |m| {
        if (filter) |f| {
            if (!std.ascii.eqlIgnoreCase(m.name, f)) continue;
        }
        try out.appendSlice(alloc, "<Member name='");
        try xml_write.escapeAttr(alloc, &out, m.name);
        try out.appendSlice(alloc, "' kind='");
        try xml_write.escapeAttr(alloc, &out, m.kind);
        try out.appendSlice(alloc, "' nparams='");
        try out.appendSlice(alloc, std.fmt.bufPrint(&buf, "{d}", .{m.nparams}) catch unreachable);
        try out.appendSlice(alloc, "' nopt='");
        try out.appendSlice(alloc, std.fmt.bufPrint(&buf, "{d}", .{m.nopt}) catch unreachable);
        try out.appendSlice(alloc, "'>");
        for (m.params) |p| {
            try out.appendSlice(alloc, "<Param>");
            try xml_write.escapeText(alloc, &out, p);
            try out.appendSlice(alloc, "</Param>");
        }
        try out.appendSlice(alloc, "</Member>");
    }
    try out.appendSlice(alloc, "</Surface>");
    return out.toOwnedSlice(alloc);
}

fn dtFor(v: *const json.Value) []const u8 {
    return switch (v.*) {
        .int => |i| if (i >= std.math.minInt(i32) and i <= std.math.maxInt(i32)) "i4" else "i8",
        .float => "r8",
        .bool => "boolean",
        else => "string",
    };
}

/// ADO rowset XML — structural match for the legacy web service SC=1 body:
/// same namespaces, Schema/ElementType/AttributeType/datatype, rs:data rows.
/// Rows end with a trailing newline (Content-Length accounts for it).
pub fn rowsXml(alloc: Allocator, rows: *const json.Value) ![]u8 {
    if (rows.* != .arr) return error.BadRows;
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var buf: [32]u8 = undefined;

    const cols: []const json.Value.Entry = if (rows.arr.len > 0 and rows.arr[0] == .obj)
        rows.arr[0].obj
    else
        &.{};

    try out.appendSlice(alloc,
        \\<xml xmlns:s='uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882'
        \\xmlns:dt='uuid:C2F41010-65B3-11d1-A29F-00AA00C14882'
        \\xmlns:rs='urn:schemas-microsoft-com:rowset'
        \\xmlns:z='#RowsetSchema'>
        \\<s:Schema id='RowsetSchema'>
        \\<s:ElementType name='row' content='eltOnly'>
    );
    for (cols, 0..) |c, i| {
        try out.appendSlice(alloc, "<s:AttributeType name='");
        try xml_write.escapeAttr(alloc, &out, c.key);
        try out.appendSlice(alloc, "' rs:number='");
        try out.appendSlice(alloc, std.fmt.bufPrint(&buf, "{d}", .{i + 1}) catch unreachable);
        try out.appendSlice(alloc, "'>");
        var nullable = c.val == .null;
        for (rows.arr[1..]) |r| {
            if (r != .obj) continue;
            if (r.get(c.key)) |fv| {
                if (fv.* == .null) nullable = true;
            }
        }
        try out.appendSlice(alloc, "<s:datatype dt:type='");
        try out.appendSlice(alloc, dtFor(&c.val));
        try out.appendSlice(alloc, "' rs:maybenull='");
        try out.appendSlice(alloc, if (nullable) "true" else "false");
        try out.appendSlice(alloc, "'/>");
        try out.appendSlice(alloc, "</s:AttributeType>");
    }
    try out.appendSlice(alloc,
        \\<s:extends type='rs:row'/>
        \\</s:ElementType>
        \\</s:Schema>
        \\<rs:data>
    );
    for (rows.arr) |r| {
        if (r != .obj) continue;
        try out.appendSlice(alloc, "<z:row");
        for (r.obj) |cell| {
            try out.append(alloc, ' ');
            try xml_write.escapeAttr(alloc, &out, cell.key);
            try out.appendSlice(alloc, "='");
            try scalarInto(alloc, &out, &cell.val);
            try out.append(alloc, '\'');
        }
        try out.appendSlice(alloc, "/>");
    }
    try out.appendSlice(alloc,
        \\</rs:data>
        \\</xml>
    );
    return out.toOwnedSlice(alloc);
}

pub fn callXml(alloc: Allocator, method: []const u8, res: *const busyc.CallResult) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    try out.appendSlice(alloc, "<Call method='");
    try xml_write.escapeAttr(alloc, &out, method);
    try out.appendSlice(alloc, "'>");
    try taggedScalar(alloc, &out, "Result", &res.ret);
    try out.appendSlice(alloc, "<Outs>");
    for (res.outs) |*o| try taggedScalar(alloc, &out, "Out", o);
    try out.appendSlice(alloc, "</Outs>");
    try out.appendSlice(alloc, "</Call>");
    return out.toOwnedSlice(alloc);
}

// ---------------- tests ----------------

const testing = std.testing;

test "negotiation" {
    try testing.expectEqual(Format.json, acceptFormat("application/json"));
    try testing.expectEqual(Format.json, acceptFormat(""));
    try testing.expectEqual(Format.json, acceptFormat("*/*"));
    try testing.expectEqual(Format.xml, acceptFormat("application/xml"));
    try testing.expectEqual(Format.xml, acceptFormat("text/xml;q=0.9, application/json;q=0.8"));
    try testing.expectEqual(Format.xml, acceptFormat("APPLICATION/XML"));
    try testing.expect(bodyIsXml("application/xml; charset=utf-8"));
    try testing.expect(!bodyIsXml("application/json"));
    try testing.expectEqual(Format.json, try fromOutFlag("json"));
    try testing.expectEqual(Format.xml, try fromOutFlag("xml"));
    try testing.expectError(error.BadOutFormat, fromOutFlag("yaml"));
}

test "envelope shapes" {
    const err = try errorXml(testing.allocator, "404", "not_found", "unknown <route> & more");
    defer testing.allocator.free(err);
    try testing.expectEqualStrings("<Error code='404' error='not_found'>unknown &lt;route&gt; &amp; more</Error>", err);

    const h = try healthXml(testing.allocator);
    defer testing.allocator.free(h);
    try testing.expectEqualStrings("<Health status='up'/>", h);

    const cl = try classesXml(testing.allocator, &.{ "Busy2L21.A", "Busy2L21.B&C" });
    defer testing.allocator.free(cl);
    try testing.expectEqualStrings("<Classes count='2'><Class>Busy2L21.A</Class><Class>Busy2L21.B&amp;C</Class></Classes>", cl);
}

test "rowset shape matches legacy SC=1 structure" {
    const rows = try json.parse(testing.allocator,
        \\[{"Code":1,"Name":"Cash"},{"Code":2,"Name":null}]
    );
    defer {
        var t = rows;
        t.deinit(testing.allocator);
    }
    const out = try rowsXml(testing.allocator, &rows);
    defer testing.allocator.free(out);
    try testing.expect(std.mem.startsWith(u8, out, "<xml xmlns:s='uuid:BDC6E3F0"));
    try testing.expect(std.mem.indexOf(u8, out, "<s:AttributeType name='Code' rs:number='1'>") != null);
    try testing.expect(std.mem.indexOf(u8, out, "dt:type='i4' rs:maybenull='false'") != null);
    try testing.expect(std.mem.indexOf(u8, out, "<s:AttributeType name='Name' rs:number='2'>") != null);
    try testing.expect(std.mem.indexOf(u8, out, "dt:type='string' rs:maybenull='true'") != null);
    try testing.expect(std.mem.indexOf(u8, out, "<s:extends type='rs:row'/>") != null);
    try testing.expect(std.mem.indexOf(u8, out, "<z:row Code='1' Name='Cash'/>") != null);
    try testing.expect(std.mem.indexOf(u8, out, "<z:row Code='2' Name=''/>") != null);
    var end = out;
    while (end.len > 0 and end[end.len - 1] == '\n') end = end[0 .. end.len - 1];
    try testing.expect(std.mem.endsWith(u8, end, "</xml>"));
}

test "xmlifyArgsInPlace converts a document object at args[1]" {
    var args = try json.parse(testing.allocator, "[2, {\"Account\": {\"Name\": \"ZigT\"}}, true]");
    defer args.deinit(testing.allocator);
    try xmlifyArgsInPlace(testing.allocator, "SaveMasterFromXML", args.arr);
    try testing.expect(args.arr[1] == .str);
    try testing.expectEqualStrings("<Account><Name>ZigT</Name></Account>", args.arr[1].str);

    // raw string args stay untouched
    var args2 = try json.parse(testing.allocator, "[2, \"<Account/>\", true]");
    defer args2.deinit(testing.allocator);
    try xmlifyArgsInPlace(testing.allocator, "SaveMasterFromXML", args2.arr);
    try testing.expectEqualStrings("<Account/>", args2.arr[1].str);

    // non-xml methods never touched
    var args3 = try json.parse(testing.allocator, "[{\"a\": 1}]");
    defer args3.deinit(testing.allocator);
    try xmlifyArgsInPlace(testing.allocator, "SomeOther", args3.arr);
    try testing.expect(args3.arr[0] == .obj);
}

test "enrichCallResult replaces XML blobs with trees" {
    var res = busyc.CallResult{
        .ret = .{ .str = try testing.allocator.dupe(u8, "<Account><Name>Cash</Name></Account>") },
        .outs = &.{},
    };
    defer res.deinit(testing.allocator);
    // passthrough applies to the raw string result, before enrichment
    try testing.expect(isPassthrough("GetMasterXML", &res));
    try testing.expect(!isPassthrough("GetCurrentUserName", &res));
    try enrichCallResult(testing.allocator, "GetMasterXML", &res);
    try testing.expect(res.ret == .obj);
    const root = res.ret.get("Account").?;
    try testing.expectEqualStrings("Cash", root.get("Name").?.str);
}

test "callXml envelopes result and outs" {
    var res = busyc.CallResult{
        .ret = .{ .bool = true },
        .outs = try testing.allocator.alloc(json.Value, 1),
    };
    defer res.deinit(testing.allocator);
    res.outs[0] = .{ .str = try testing.allocator.dupe(u8, "bad <thing>") };
    const out = try callXml(testing.allocator, "SaveMasterFromXML", &res);
    defer testing.allocator.free(out);
    try testing.expectEqualStrings(
        "<Call method='SaveMasterFromXML'><Result>true</Result><Outs><Out>bad &lt;thing&gt;</Out></Outs></Call>",
        out,
    );
}

test "xmlmeta classification is reachable from transport" {
    _ = @import("../core/xmlmeta.zig");
}

// `zig build test` roots at src/main.zig; tests only run for files pulled in
// from a test block, so aggregate the cross-tree suites here (legal for the
// transport layer: it may import core + util).
test "test aggregation for the build test root" {
    _ = @import("../util/xml.zig"); // facade pulls parse/write/map suites
    _ = @import("../util/helpers.zig");
    _ = @import("../util/sqlguard.zig"); // issue #3 query guard corpus
    _ = @import("../core/registry.zig");
    _ = @import("../core/constants.zig");
    _ = @import("../core/ops.zig"); // issue #7 ops layer (pure suites)
    _ = @import("envelope.zig");
}
