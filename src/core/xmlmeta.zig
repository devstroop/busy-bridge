//! Domain knowledge: which BUSY COM methods carry XML documents.
//!
//! Rule derived from BUSY's own naming (verified against the live
//! CFixedInterface surface): document methods contain "XML";
//!   Get*XML      -> returns a document (string result)   [direction .out]
//!   Save*/Add*/Modify*XML -> takes the document as argument index 1
//!                            (argument 0 is the type code) [.in]
//! Anything else, including unknown "XML"-named methods, is `.none`, which
//! keeps conversion conservative (never rewrite what we do not recognize).
const std = @import("std");

pub const Kind = enum {
    none,
    /// method returns an XML document as its result string
    out,
    /// method takes an XML document at args[1]
    in,
};

pub fn kind(method: []const u8) Kind {
    if (std.mem.indexOf(u8, method, "XML") == null) return .none;
    if (std.mem.startsWith(u8, method, "Get")) return .out;
    if (std.mem.startsWith(u8, method, "Save") or
        std.mem.startsWith(u8, method, "Add") or
        std.mem.startsWith(u8, method, "Modify")) return .in;
    return .none;
}

test "classification" {
    const testing = std.testing;
    try testing.expectEqual(Kind.out, kind("GetMasterXML"));
    try testing.expectEqual(Kind.out, kind("GetCompConfigXML"));
    try testing.expectEqual(Kind.out, kind("GetVchXML"));
    try testing.expectEqual(Kind.in, kind("SaveMasterFromXML"));
    try testing.expectEqual(Kind.in, kind("SaveVchFromXML"));
    try testing.expectEqual(Kind.in, kind("AddVchFromXML"));
    try testing.expectEqual(Kind.in, kind("AddMasterFromPredefinedXML"));
    try testing.expectEqual(Kind.none, kind("GetCurrentUserName"));
    try testing.expectEqual(Kind.none, kind("OpenDB"));
    try testing.expectEqual(Kind.none, kind("SomethingXMLUnknown")); // no Get/Save/Add prefix
}
