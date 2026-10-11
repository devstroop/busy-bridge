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

pub const Kind = enum {
    account,
    item,
    account_group,
    item_group,
    unit,
    unit_conversion,
    bill_sundry,
    store,
    sale_type,
    purchase_type,
    bom,
    tax_category,
    voucher_series,
};

/// One row per kind: route words (plural = list path, singular = get path)
/// and the `constants.masters` name that yields the MasterType code.
/// `route = false` marks internal kinds whose dispatch is special-cased
/// (series: type-partitioned names, prefix-stripping list) — they never
/// match a generic `/op|/v1` path segment.
pub const KindEntry = struct {
    kind: Kind,
    sing: []const u8,
    plur: []const u8,
    cons: []const u8,
    route: bool = true,
    /// SaveMasterFromXML wrapper element (`<Account>`, `<Item>`); null =
    /// writes for this kind are not wired yet (reads only) — `create`
    /// answers a precise BadArgs until the kind's write op lands.
    wrap: ?[]const u8 = null,
};

pub const kinds = [_]KindEntry{
    .{ .kind = .account, .sing = "account", .plur = "accounts", .cons = "ACCOUNT_MASTER", .wrap = "Account" },
    .{ .kind = .item, .sing = "item", .plur = "items", .cons = "ITEM_MASTER", .wrap = "Item" },
    .{ .kind = .account_group, .sing = "account-group", .plur = "account-groups", .cons = "ACCOUNT_GROUP_MASTER" },
    .{ .kind = .item_group, .sing = "item-group", .plur = "item-groups", .cons = "ITEM_GROUP_MASTER" },
    .{ .kind = .unit, .sing = "unit", .plur = "units", .cons = "UNIT_MASTER" },
    .{ .kind = .unit_conversion, .sing = "unit-conversion", .plur = "unit-conversions", .cons = "UNIT_CONVERSION_MASTER" },
    .{ .kind = .bill_sundry, .sing = "bill-sundry", .plur = "bill-sundries", .cons = "BILL_SUNDRY_MASTER" },
    .{ .kind = .store, .sing = "store", .plur = "stores", .cons = "MATERIAL_CENTER_MASTER" },
    .{ .kind = .sale_type, .sing = "sale-type", .plur = "sale-types", .cons = "SALE_TYPE_MASTER" },
    .{ .kind = .purchase_type, .sing = "purchase-type", .plur = "purchase-types", .cons = "PURCHASE_TYPE_MASTER" },
    .{ .kind = .bom, .sing = "bom", .plur = "boms", .cons = "BILL_OF_MATERIAL_MASTER" },
    .{ .kind = .tax_category, .sing = "tax-category", .plur = "tax-categories", .cons = "TAX_CATEGORY_MASTER" },
    .{ .kind = .voucher_series, .sing = "series", .plur = "series", .cons = "VOUCHER_SERIES_MASTER", .route = false },
};

/// How a path segment matched a routed kind: `list` when the segment was
/// the plural route word (`GET /op/units`), false for the singular
/// (`GET /op/unit?name=…`). `sing`/`plur` are the normalized route words,
/// safe for envelope/op names regardless of input case.
pub const KindPath = struct {
    kind: Kind,
    sing: []const u8,
    plur: []const u8,
    list: bool,
};

/// Match one `/op|/v1` path segment (case-insensitive, singular or
/// plural) against the routed kinds; null = not a generic master path
/// (vouchers/reports/series and typos fall through to their own arms).
pub fn kindPath(seg: []const u8) ?KindPath {
    for (kinds) |k| {
        if (!k.route) continue;
        if (std.ascii.eqlIgnoreCase(seg, k.plur))
            return .{ .kind = k.kind, .sing = k.sing, .plur = k.plur, .list = true };
        if (std.ascii.eqlIgnoreCase(seg, k.sing))
            return .{ .kind = k.kind, .sing = k.sing, .plur = k.plur, .list = false };
    }
    return null;
}

pub fn kindFrom(s: []const u8) ?Kind {
    const kp = kindPath(s) orelse return null;
    return kp.kind;
}

pub fn kindName(kind: Kind) []const u8 {
    for (kinds) |k| if (k.kind == kind) return k.sing;
    unreachable;
}

/// MasterType code for the kind (shared by reads and writes).
pub fn typeCode(kind: Kind) i64 {
    for (kinds) |k| if (k.kind == kind) return constants.masterCode(k.cons).?;
    unreachable;
}

/// SaveMasterFromXML wrapper element for the kind, or null when writes
/// for that kind are not wired yet (WP1: reads only — fail with BadArgs).
pub fn wrapElement(kind: Kind) ?[]const u8 {
    for (kinds) |k| if (k.kind == kind) return k.wrap;
    return null;
}

/// Number of routable kinds (surface indexes, catalog generation).
pub fn routedCount() usize {
    var n: usize = 0;
    for (kinds) |k| {
        if (k.route) n += 1;
    }
    return n;
}

/// Plural route words of every routed kind (drives the GET /v1 index).
pub fn pluralNames() [routedCount()][]const u8 {
    var out: [routedCount()][]const u8 = undefined;
    var i: usize = 0;
    for (kinds) |k| {
        if (k.route) {
            out[i] = k.plur;
            i += 1;
        }
    }
    return out;
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
pub const seriesList = read.seriesList;
pub const SeriesOpts = read.SeriesOpts;
pub const seriesOf = read.seriesOf;
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
    try testing.expect(kindFrom("units") == .unit);
    try testing.expect(kindFrom("tax-categories") == .tax_category);
    // internal kinds never match a generic path segment
    try testing.expect(kindFrom("series") == null);
}

test "kindPath distinguishes plural (list) from singular (get)" {
    for (kinds) |k| {
        if (!k.route) continue;
        const as_list = kindPath(k.plur).?;
        try testing.expect(as_list.list);
        try testing.expectEqual(k.kind, as_list.kind);
        const as_get = kindPath(k.sing).?;
        try testing.expect(!as_get.list);
        try testing.expectEqual(k.kind, as_get.kind);
    }
    try testing.expect(kindPath("UNITS").?.list);
    try testing.expect(kindPath("vouchers") == null);
    try testing.expect(kindPath("reports") == null);
    try testing.expect(kindPath("series") == null);
    try testing.expect(kindPath("frobnicate") == null);
}

test "typeCode resolves every kind's MasterType constant" {
    for (kinds) |k| try testing.expect(typeCode(k.kind) > 0);
    try testing.expectEqual(@as(i64, 2), typeCode(.account));
    try testing.expectEqual(@as(i64, 8), typeCode(.unit));
    try testing.expectEqual(@as(i64, 21), typeCode(.voucher_series));
    // routed plurals drive the GET /v1 index
    const plurals = pluralNames();
    try testing.expectEqual(@as(usize, 12), plurals.len);
    try testing.expectEqualStrings("accounts", plurals[0]);
    try testing.expectEqualStrings("units", plurals[4]);
}

test "masters submodules are reachable from the test root" {
    _ = @import("masters/read.zig");
    _ = @import("masters/write.zig");
}
