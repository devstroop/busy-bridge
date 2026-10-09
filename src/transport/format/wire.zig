//! Wire-format negotiation (issue #11 phase 3): the Format enum, content
//! types, and Accept/flag parsing. Self-contained — no XML, no BUSY.
//!
//! Negotiation:
//!   CLI     --out json|xml          (default json)
//!   HTTP    Accept: application/xml -> XML response (default JSON)
//!   HTTP    Content-Type: application/xml on POST /call -> raw XML request
//!           body (method/type/modify ride in the query string)
const std = @import("std");

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
