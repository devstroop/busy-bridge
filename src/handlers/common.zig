//! Mechanical glue shared by the ERP operations (facade M1, issue #7).
//! Split into responsibility-named submodules (011 phase 2):
//!   common/value.zig   object builders, scalar stringify, merge/deep-copy
//!   common/dates.zig   BUSY display forms <-> ISO
//!   common/cursor.zig  opaque keyset paging cursors
//!   common/sql.zig     session queries (resolveNames, codeByName) + ProgIDs
//! This barrel is the stable surface: every `common.*` name below is
//! re-exported, so import paths and call sites never change.
//! Never imports transport.
const std = @import("std");

const value = @import("common/value.zig");
const dates = @import("common/dates.zig");
const cursor = @import("common/cursor.zig");
const sql = @import("common/sql.zig");

// value.zig
pub const put = value.put;
pub const objFrom = value.objFrom;
pub const stringifyValue = value.stringifyValue;
pub const containsCi = value.containsCi;
pub const mergeRoot = value.mergeRoot;
pub const dupValue = value.dupValue;
pub const childStr = value.childStr;
// dates.zig
pub const normalizeDate = dates.normalizeDate;
pub const toBusyDate = dates.toBusyDate;
// cursor.zig
pub const encodeCursor = cursor.encodeCursor;
pub const decodeCursor = cursor.decodeCursor;
// sql.zig
pub const NamePair = sql.NamePair;
pub const resolveNames = sql.resolveNames;
pub const findName = sql.findName;
pub const freePairs = sql.freePairs;
pub const codeByName = sql.codeByName;
pub const classProgId = sql.classProgId;

// ---------------- tests (submodule suites live there) ----------------

test "common submodules are reachable from the test root" {
    _ = @import("common/value.zig");
    _ = @import("common/dates.zig");
    _ = @import("common/cursor.zig");
    _ = @import("common/sql.zig");
}
