//! Request-scoped wire formats: JSON (default) and XML.
//!
//! Split (011 phase 3):
//!   format/wire.zig          Format enum + Accept/--out negotiation
//!   format/call.zig          JSON-mode call transforms (enrich/xmlify/passthrough)
//!   format/xml_envelopes.zig response payload builders (error/constants/info/
//!                            health/classes/surface/rowset/call envelopes)
//! This barrel is the stable surface: every `format.*` name below is
//! re-exported, so import paths and call sites never change.
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

const wire = @import("format/wire.zig");
const call = @import("format/call.zig");
const envelopes = @import("format/xml_envelopes.zig");

// wire.zig — negotiation
pub const Format = wire.Format;
pub const ct_json = wire.ct_json;
pub const ct_xml = wire.ct_xml;
pub const fromOutFlag = wire.fromOutFlag;
pub const acceptFormat = wire.acceptFormat;
pub const bodyIsXml = wire.bodyIsXml;
// call.zig — JSON-mode call transforms
pub const enrichCallResult = call.enrichCallResult;
pub const xmlifyArgsInPlace = call.xmlifyArgsInPlace;
pub const isPassthrough = call.isPassthrough;
// xml_envelopes.zig — response payload builders
pub const errorXml = envelopes.errorXml;
pub const constantsJson = envelopes.constantsJson;
pub const constantsXml = envelopes.constantsXml;
pub const infoJson = envelopes.infoJson;
pub const infoXml = envelopes.infoXml;
pub const healthXml = envelopes.healthXml;
pub const classesXml = envelopes.classesXml;
pub const surfaceXml = envelopes.surfaceXml;
pub const rowsXml = envelopes.rowsXml;
pub const callXml = envelopes.callXml;

// ---------------- tests ----------------

const testing = std.testing;

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
    _ = @import("../handlers.zig"); // issue #7 ops layer (pure suites)
    _ = @import("envelope.zig");
    _ = @import("auth.zig"); // issue #4 token gate (pure suites)
    _ = @import("sessions.zig"); // issue #5 multi-company switcher (pure suites)
    _ = @import("v1.zig"); // issue #7 /v1 facade (pure suites)
    _ = @import("format/wire.zig"); // issue #11 phase 3 split suites
    _ = @import("format/call.zig");
    _ = @import("format/xml_envelopes.zig");
    _ = @import("../core/com/replay/tests.zig"); // issue #9 replay suites (host-agnostic)
}
