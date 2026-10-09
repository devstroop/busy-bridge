//! XML/JSON response payload builders (issue #11 phase 3): static
//! capability documents (error, constants, info, health, classes,
//! surface), the legacy-compatible ADO rowset, and the <Call> envelope.
//! Negotiation lives in wire.zig; call-result transforms in call.zig.
const std = @import("std");
const json = @import("../../util/json.zig");
const xml_write = @import("../../util/xml/write.zig");
const busyc = @import("../../core/com.zig");
const constants = @import("../../core/constants.zig");

const Allocator = std.mem.Allocator;

// ---------------- scalar helpers (rowset + call envelope) ----------------

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

// ---------------- static capability documents ----------------

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
/// `switches` = successful per-request company switches (issue #5).
/// `auth_mode` (contract §5): off | token | session — the credential
/// policy this serve enforces.
pub fn infoJson(alloc: Allocator, version: []const u8, prog_id: []const u8, comp: ?[]const u8, switches: u64, auth_mode: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"ok\":true,\"bridge\":\"busy-bridge\",\"version\":");
    try w.str(version);
    try w.raw(",\"prog_id\":");
    try w.str(prog_id);
    try w.raw(",\"company\":");
    if (comp) |c| try w.str(c) else try w.raw("null");
    try w.raw(",\"switches\":");
    var sbuf: [20]u8 = undefined;
    try w.raw(std.fmt.bufPrint(&sbuf, "{d}", .{switches}) catch unreachable);
    try w.raw(",\"auth_mode\":");
    try w.str(auth_mode);
    try w.raw(",\"formats\":[\"json\",\"xml\"],\"routes\":[\"/health\",\"/info\",\"/constants\",\"/surface\",\"/classes\",\"/query\",\"/call\",\"/auth/login\",\"/auth/me\",\"/auth/logout\",\"/op\",\"/op/accounts\",\"/op/account\",\"/op/items\",\"/op/item\",\"/op/vouchers\",\"/op/voucher\",\"/op/batch\",\"/op/report\",\"/v1\"]}");
    return out.toOwnedSlice(alloc);
}

pub fn infoXml(alloc: Allocator, version: []const u8, prog_id: []const u8, comp: ?[]const u8, switches: u64, auth_mode: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    try out.appendSlice(alloc, "<Info bridge='busy-bridge' version='");
    try xml_write.escapeAttr(alloc, &out, version);
    try out.appendSlice(alloc, "' prog_id='");
    try xml_write.escapeAttr(alloc, &out, prog_id);
    try out.appendSlice(alloc, "' company='");
    if (comp) |c| try xml_write.escapeAttr(alloc, &out, c);
    try out.appendSlice(alloc, "' switches='");
    var sbuf: [20]u8 = undefined;
    try out.appendSlice(alloc, std.fmt.bufPrint(&sbuf, "{d}", .{switches}) catch unreachable);
    try out.appendSlice(alloc, "' auth_mode='");
    try xml_write.escapeAttr(alloc, &out, auth_mode);
    try out.appendSlice(alloc, "'><Format>json</Format><Format>xml</Format><Route path='/health'/><Route path='/info'/><Route path='/constants'/><Route path='/surface'/><Route path='/classes'/><Route path='/query'/><Route path='/call'/><Route path='/auth/login'/><Route path='/auth/me'/><Route path='/auth/logout'/><Route path='/op'/><Route path='/op/accounts'/><Route path='/op/account'/><Route path='/op/items'/><Route path='/op/item'/><Route path='/op/vouchers'/><Route path='/op/voucher'/><Route path='/op/batch'/><Route path='/op/report'/><Route path='/v1'/></Info>");
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

// ---------------- ADO rowset + call envelope ----------------

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
