//! Canonical BUSY integer codes (masters & voucher types) as data.
//! Source: docs/constants.md (migrated from BUSY Constants.doc, verified
//! live: ACCOUNT_MASTER=2, SALE=9). Consumed by the wire format layer for
//! GET /constants; also the future single source for name-based lookups.
const std = @import("std");

pub const NamedCode = struct { name: []const u8, code: i64 };

/// Master type codes (p_MasterType / SaveMasterFromXML args[0]).
/// Note: 23 and 35 are unused in BUSY's own table (gaps preserved).
pub const masters = [_]NamedCode{
    .{ .name = "ACCOUNT_GROUP_MASTER", .code = 1 },
    .{ .name = "ACCOUNT_MASTER", .code = 2 },
    .{ .name = "COST_CENTER_GROUP_MASTER", .code = 3 },
    .{ .name = "COST_CENTER_MASTER", .code = 4 },
    .{ .name = "ITEM_GROUP_MASTER", .code = 5 },
    .{ .name = "ITEM_MASTER", .code = 6 },
    .{ .name = "CURRENCY_MASTER", .code = 7 },
    .{ .name = "UNIT_MASTER", .code = 8 },
    .{ .name = "BILL_SUNDRY_MASTER", .code = 9 },
    .{ .name = "MATERIAL_CENTER_GROUP_MASTER", .code = 10 },
    .{ .name = "MATERIAL_CENTER_MASTER", .code = 11 },
    .{ .name = "FORM_MASTER", .code = 12 },
    .{ .name = "SALE_TYPE_MASTER", .code = 13 },
    .{ .name = "PURCHASE_TYPE_MASTER", .code = 14 },
    .{ .name = "BILL_OF_MATERIAL_MASTER", .code = 15 },
    .{ .name = "UNIT_CONVERSION_MASTER", .code = 16 },
    .{ .name = "CURRENCY_CONVERSION_MASTER", .code = 17 },
    .{ .name = "STANDARD_NARRATION_MASTER", .code = 18 },
    .{ .name = "BROKER_MASTER", .code = 19 },
    .{ .name = "AUTHOR_MASTER", .code = 20 },
    .{ .name = "VOUCHER_SERIES_MASTER", .code = 21 },
    .{ .name = "TDS_MASTER", .code = 22 },
    .{ .name = "BRANCH_MASTER", .code = 24 },
    .{ .name = "TAX_CATEGORY_MASTER", .code = 25 },
    .{ .name = "MASTER_SERIES_GROUP_MASTER", .code = 26 },
    .{ .name = "EMPLOYEE_MASTER", .code = 27 },
    .{ .name = "EMPLOYEE_GROUP_MASTER", .code = 28 },
    .{ .name = "SALARY_COMPONENT_MASTER", .code = 29 },
    .{ .name = "DISCOUNT_STRUCTURE_MASTER", .code = 30 },
    .{ .name = "MARKUP_STRUCTURE_MASTER", .code = 31 },
    .{ .name = "SCHEME_MASTER", .code = 32 },
    .{ .name = "EXECUTIVE_MASTER", .code = 33 },
    .{ .name = "CONTACT_GROUP_MASTER", .code = 34 },
    .{ .name = "CONTACT_MASTER", .code = 36 },
};

/// Voucher type codes (p_VchType / SaveVchFromXML args[0] / ?type=).
pub const vouchers = [_]NamedCode{
    .{ .name = "PURCHASE", .code = 2 },
    .{ .name = "SALE_RETURN", .code = 3 },
    .{ .name = "MATERIAL_RECEIPT", .code = 4 },
    .{ .name = "STOCK_TRANSFER", .code = 5 },
    .{ .name = "PRODUCTION", .code = 6 },
    .{ .name = "UNASSEMBLE", .code = 7 },
    .{ .name = "STOCK_JOURNAL", .code = 8 },
    .{ .name = "SALE", .code = 9 },
    .{ .name = "PURCHASE_RETURN", .code = 10 },
    .{ .name = "MATERIAL_ISSUE", .code = 11 },
    .{ .name = "SALE_ORDER", .code = 12 },
    .{ .name = "PURCHASE_ORDER", .code = 13 },
    .{ .name = "RECEIPT", .code = 14 },
    .{ .name = "CONTRA", .code = 15 },
    .{ .name = "JOURNAL", .code = 16 },
    .{ .name = "DEBIT_NOTE", .code = 17 },
    .{ .name = "CREDIT_NOTE", .code = 18 },
    .{ .name = "PAYMENT", .code = 19 },
    .{ .name = "FORMS_RECEIVED", .code = 21 },
    .{ .name = "FORMS_ISSUED", .code = 22 },
    .{ .name = "SALE_QUOTATION", .code = 26 },
    .{ .name = "PURCHASE_QUOTATION", .code = 27 },
};

pub fn masterCode(name: []const u8) ?i64 {
    for (masters) |m| if (std.mem.eql(u8, m.name, name)) return m.code;
    return null;
}

pub fn voucherCode(name: []const u8) ?i64 {
    for (vouchers) |v| if (std.mem.eql(u8, v.name, name)) return v.code;
    return null;
}

test "constants lookup" {
    const testing = std.testing;
    try testing.expectEqual(@as(i64, 2), masterCode("ACCOUNT_MASTER").?);
    try testing.expectEqual(@as(i64, 6), masterCode("ITEM_MASTER").?);
    try testing.expect(masterCode("NOPE") == null);
    try testing.expectEqual(@as(i64, 9), voucherCode("SALE").?);
    try testing.expectEqual(@as(i64, 2), voucherCode("PURCHASE").?);
    try testing.expect(voucherCode("SALES") == null);
}
