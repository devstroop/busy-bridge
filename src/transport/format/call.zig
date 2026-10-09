//! Call-result transforms (issue #11 phase 3): the JSON-mode promise
//! (XML blobs never leak to JSON consumers) and the both-modes doc-arg
//! serialization. Classification lives in core/xmlmeta; this module is
//! the transport-side application of it.
const std = @import("std");
const json = @import("../../util/json.zig");
const xml = @import("../../util/xml.zig");
const xml_write = @import("../../util/xml/write.zig");
const busyc = @import("../../core/com.zig");
const xmlmeta = @import("../../core/xmlmeta.zig");

const Allocator = std.mem.Allocator;

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

// ---------------- tests ----------------

const testing = std.testing;

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
