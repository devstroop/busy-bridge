//! ERP voucher operations (facade M1/M2, issue #7): shared ListOpts with
//! reads/writes split into submodules (011 phase 1b):
//!   vouchers/read.zig   list, get    — Tran1 + GetVchXML normalized reads
//!   vouchers/write.zig  post, delete — SaveVchFromXML document builders
//! This barrel is the stable surface: every `vouchers.*` name below is
//! re-exported here, so import paths and call sites never change.
//! Never imports transport.
const std = @import("std");

const read = @import("vouchers/read.zig");
const write = @import("vouchers/write.zig");

pub const ListOpts = struct {
    /// Canonical voucher type name (e.g. "sale") — resolved via constants
    /// (case-insensitive). null = all types.
    type_name: ?[]const u8 = null,
    /// 0 = unlimited.
    limit: usize = 100,
    /// Keyset cursor (issue #7 /v1 paging): the `next_cursor` from a
    /// previous page — the last-shown VchCode (decimal, encoded). Paging
    /// orders by VchCode DESC (VchCode is monotonic, so pages are stable);
    /// the default no-cursor order stays Date DESC for display.
    cursor: ?[]const u8 = null,
};

// reads (vouchers/read.zig)
pub const list = read.list;
pub const get = read.get;
// writes (vouchers/write.zig)
pub const buildSaleDoc = write.buildSaleDoc;
pub const buildJournalDoc = write.buildJournalDoc;
pub const post = write.post;
pub const delete = write.delete;

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "voucher list rejects unknown type names" {
    // BadArgs path needs a session; the constants guard itself is pure:
    const constants = @import("../constants.zig");
    try testing.expect(constants.voucherCode("sale") != null);
    try testing.expect(constants.voucherCode("not-a-type") == null);
}

test "vouchers submodules are reachable from the test root" {
    _ = @import("vouchers/read.zig");
    _ = @import("vouchers/write.zig");
}
