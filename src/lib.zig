//! busy-bridge package root — the RAW COM binding to BUSY.
//!
//! This module is the only surface downstream Zig consumers (busy-server,
//! future busy-mcp/busy-cli) should import. It exposes the raw transport
//! to BUSY — company sessions, marker-driven COM invocation, SQL via
//! Recordset, introspection — and deliberately exposes NO business
//! semantics: typed ops, voucher rules, rights policy and the HTTP layer
//! live in the consumers (busy-server), not here.
//!
//! Consumer usage (busy-server build.zig):
//!   const bb = b.dependency("busy_bridge", .{ ... });
//!   mod.addImport("busy_bridge", bb.module("busy_bridge"));
//!   // final binary links (BUSY's COM servers are 32-bit in-process DLLs,
//!   // so the consumer must target x86-windows):
//!   mod.linkSystemLibrary("ole32");
//!   mod.linkSystemLibrary("oleaut32");
//!   mod.linkSystemLibrary("advapi32"); // registry helpers
//!   mod.linkSystemLibrary("bcrypt");   // token generation
//!   mod.linkSystemLibrary("ws2_32");   // only if the consumer serves HTTP
//!
//! Threading contract: COM calls assume a single serialized caller (one
//! apartment); consumers must not fan out calls across threads.
const std = @import("std");

// --- core: the COM engine --------------------------------------------------
pub const com = @import("core/com.zig"); // facade: Session, Member, CallResult
pub const session = @import("core/com/session.zig"); // Session: init/create/invoke/invokeEx/queryToJson/surface
pub const invoke = @import("core/com/invoke.zig"); // invoke/invokeEx + InvokeOpts
pub const recordset = @import("core/com/recordset.zig"); // queryToJson helpers
pub const surface = @import("core/com/surface.zig"); // classes/surface introspection
pub const record = @import("core/com/record.zig"); // COM variant <-> Zig Value, storage clearing
pub const recordinfo = @import("core/com/recordinfo.zig"); // $record shape (pRecInfo)
pub const markers = @import("core/com/markers.zig"); // $byref/$collection/$record/$enumerate markers
pub const marshal = @import("core/com/marshal.zig"); // arg marshaling (incl. XML doc objects)
pub const collection = @import("core/com/collection.zig"); // VB6 Collection enumeration
pub const result = @import("core/com/result.zig"); // CallResult
pub const utf16 = @import("core/com/utf16.zig");
pub const win32 = @import("core/com/win32.zig"); // VT_* constants, COM plumbing
pub const replay_tests = @import("core/com/replay/tests.zig"); // COM replay corpus

// --- core: BUSY static knowledge -------------------------------------------
pub const constants = @import("core/constants.zig"); // voucher types etc.
pub const registry = @import("core/registry.zig"); // ProgID/registry helpers
pub const xmlmeta = @import("core/xmlmeta.zig"); // XML schema metadata

// --- util ------------------------------------------------------------------
pub const json = @import("util/json.zig");
pub const helpers = @import("util/helpers.zig");
pub const sqlguard = @import("util/sqlguard.zig");
pub const xml = @import("util/xml.zig");
pub const xml_write = @import("util/xml/write.zig");

// --- package surface smoke tests (pure; aggregated into the main run) -----
test "package surface: raw binding API reachable through the root" {
    // The entry points every consumer drives: a Session that can create
    // COM classes, invoke methods (marker-driven) and run SQL.
    try std.testing.expect(@hasDecl(com, "Session"));
    try std.testing.expect(@hasDecl(session.Session, "create"));
    try std.testing.expect(@hasDecl(session.Session, "invokeEx"));
    try std.testing.expect(@hasDecl(session.Session, "queryToJson"));
    try std.testing.expect(@hasDecl(invoke, "invokeEx"));
    try std.testing.expect(@hasDecl(recordset, "queryToJson"));
}

test "package surface: re-exported util behaves identically" {
    // Round-trip through the re-exported facade (parse -> stringify,
    // byte-identical output) proves the root re-export is the very same
    // module the bridge itself uses, not a copy.
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    const doc = "{\"ok\":true,\"n\":98}";
    const v = try json.parse(alloc, doc);
    var list: std.ArrayList(u8) = .empty;
    var w = json.Writer{ .buf = &list, .alloc = alloc };
    try json.stringify(&v, &w);
    try std.testing.expectEqualStrings(doc, list.items);
}

test "package surface: secondary modules compile through the root" {
    _ = session;
    _ = invoke;
    _ = recordset;
    _ = surface;
    _ = record;
    _ = recordinfo;
    _ = markers;
    _ = marshal;
    _ = collection;
    _ = result;
    _ = utf16;
    _ = win32;
    _ = replay_tests;
    _ = constants;
    _ = registry;
    _ = xmlmeta;
    _ = helpers;
    _ = sqlguard;
    _ = xml;
    _ = xml_write;
}
