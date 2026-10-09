//! ERP master operations (facade M1/M2, issue #7): shared kinds + type
//! codes with reads/writes split into submodules (011 phase 1a):
//!   masters/read.zig   list, get   — normalized reads, keyset paging
//!   masters/write.zig  create, update, delete — SaveMasterFromXML round-trips
//! This barrel is the stable surface: every `masters.*` name below is
//! re-exported here, so import paths and call sites never change.
//! Never imports transport.
const std = @import("std");
const json = @import("../util/json.zig");
const constants = @import("../core/constants.zig");
const com = @import("../core/com.zig");

const Session = com.Session;

const read = @import("masters/read.zig");
const write = @import("masters/write.zig");

pub const Kind = enum { account, item };

pub fn kindFrom(s: []const u8) ?Kind {
    if (std.ascii.eqlIgnoreCase(s, "account")) return .account;
    if (std.ascii.eqlIgnoreCase(s, "item")) return .item;
    if (std.ascii.eqlIgnoreCase(s, "accounts")) return .account;
    if (std.ascii.eqlIgnoreCase(s, "items")) return .item;
    return null;
}

pub fn kindName(kind: Kind) []const u8 {
    return switch (kind) {
        .account => "account",
        .item => "item",
    };
}

/// MasterType code for the kind (shared by reads and writes).
pub fn typeCode(kind: Kind) i64 {
    return switch (kind) {
        .account => constants.masterCode("ACCOUNT_MASTER").?,
        .item => constants.masterCode("ITEM_MASTER").?,
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

// reads (masters/read.zig)
pub const list = read.list;
pub const get = read.get;
// writes (masters/write.zig)
pub const byrefArg = write.byrefArg;
pub const fieldsToDoc = write.fieldsToDoc;
pub const docToXml = write.docToXml;
pub const create = write.create;
pub const update = write.update;
pub const delete = write.delete;

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "kindFrom accepts singular and plural" {
    try testing.expect(kindFrom("account") == .account);
    try testing.expect(kindFrom("ACCOUNTS") == .account);
    try testing.expect(kindFrom("item") == .item);
    try testing.expect(kindFrom("ledger") == null);
    try testing.expectEqualStrings("account", kindName(.account));
}

test "masters submodules are reachable from the test root" {
    _ = @import("masters/read.zig");
    _ = @import("masters/write.zig");
}
