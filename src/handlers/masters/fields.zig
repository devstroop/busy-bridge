//! Per-kind normalized-field maps (WP0/WP2): request key -> BUSY document
//! element, with the value type BUSY expects. Probe-verified live against
//! COMP0001 (tests/live/wp2-probe*.ps1): element names come from
//! GetMasterXML dumps of existing masters, minimal shapes from escalating
//! SaveMasterFromXML saves, types from BUSY's own serialization ("True"/
//! "False" text for booleans, plain integers for numbers).
//! Unknown keys or wrong value types -> error.BadDocument (callers turn
//! that into a precise bad_args listing the kind's fields). `name` is
//! positional and always maps to `<Name>` — it never appears here.
const std = @import("std");
const m = @import("../masters.zig");

pub const Kind = m.Kind;

/// Value type accepted for the field on the request side. All render as
/// XML text: strings copy through, numbers print decimal, booleans emit
/// BUSY's "True"/"False" (observed on every read-back).
pub const Ty = enum { str, num, bool };

pub const Field = struct {
    /// normalized request key (JSON field name)
    key: []const u8,
    /// BUSY document element name (XML tag)
    elem: []const u8,
    ty: Ty,
};

/// Field map for the kind. Read-only kinds (unit-conversion, bom,
/// voucher-series) keep their probe-discovered maps for documentation;
/// their writes are blocked before field mapping.
pub fn fieldsFor(kind: Kind) []const Field {
    return switch (kind) {
        .account => &[_]Field{
            .{ .key = "parent", .elem = "ParentGroup", .ty = .str },
        },
        .item => &[_]Field{
            .{ .key = "parent", .elem = "ParentGroup", .ty = .str },
            .{ .key = "unit", .elem = "MainUnit", .ty = .str },
        },
        .account_group => &[_]Field{
            .{ .key = "parent", .elem = "ParentGroupName", .ty = .str },
        },
        .item_group => &[_]Field{
            .{ .key = "parent", .elem = "ParentGroup", .ty = .str },
            .{ .key = "primary_group", .elem = "PrimaryGroup", .ty = .bool },
        },
        .unit => &[_]Field{
            .{ .key = "print_name", .elem = "PrintName", .ty = .str },
            .{ .key = "uqc", .elem = "UQC", .ty = .str },
            .{ .key = "uqc_ewaybill", .elem = "UQCEWayBill", .ty = .str },
        },
        .unit_conversion => &[_]Field{
            .{ .key = "main_unit", .elem = "MainUnitName", .ty = .str },
            .{ .key = "sub_unit", .elem = "SubUnitName", .ty = .str },
            .{ .key = "con_factor", .elem = "ConFactor", .ty = .num },
        },
        .bill_sundry => &[_]Field{
            .{ .key = "print_name", .elem = "PrintName", .ty = .str },
            .{ .key = "percent_of_amount", .elem = "PercentOfAmount", .ty = .num },
            .{ .key = "bsnature", .elem = "BSNature", .ty = .str },
            .{ .key = "type", .elem = "Type", .ty = .num },
            .{ .key = "amount_basis", .elem = "AmountBasis", .ty = .num },
            .{ .key = "point_of_calculation", .elem = "PointOfCalculation", .ty = .num },
            .{ .key = "no_of_pbs", .elem = "NoOfPBS", .ty = .num },
            .{ .key = "sub_total_desc", .elem = "SubTotalDesc", .ty = .str },
            .{ .key = "sales_acc_name", .elem = "SalesAccName", .ty = .str },
            .{ .key = "purc_acc_name", .elem = "PurcAccName", .ty = .str },
        },
        .store => &[_]Field{
            .{ .key = "print_name", .elem = "PrintName", .ty = .str },
            .{ .key = "parent", .elem = "ParentGroup", .ty = .str },
            .{ .key = "stock_account", .elem = "StockAccount", .ty = .str },
            .{ .key = "purchase_account", .elem = "PurchaseAccount", .ty = .str },
            .{ .key = "sales_account", .elem = "SalesAccount", .ty = .str },
            .{ .key = "stock_belongs_to_you", .elem = "StockBelongsToYou", .ty = .bool },
        },
        .sale_type => &[_]Field{
            .{ .key = "sale_account", .elem = "SaleAccount", .ty = .str },
            .{ .key = "taxable", .elem = "Taxable", .ty = .bool },
            .{ .key = "tax_percent", .elem = "TaxPercent", .ty = .num },
            .{ .key = "vat_gst_type", .elem = "VATGSTType", .ty = .num },
            .{ .key = "type", .elem = "Type", .ty = .num },
            .{ .key = "input_tax_credit", .elem = "InputTaxCredit", .ty = .bool },
            .{ .key = "percent_of_amount", .elem = "PercentOfAmount", .ty = .num },
        },
        .purchase_type => &[_]Field{
            .{ .key = "purchase_account", .elem = "PurchaseAccount", .ty = .str },
            .{ .key = "taxable", .elem = "Taxable", .ty = .bool },
            .{ .key = "tax_percent", .elem = "TaxPercent", .ty = .num },
            .{ .key = "vat_gst_type", .elem = "VATGSTType", .ty = .num },
            .{ .key = "type", .elem = "Type", .ty = .num },
            .{ .key = "input_tax_credit", .elem = "InputTaxCredit", .ty = .bool },
            .{ .key = "percent_of_amount", .elem = "PercentOfAmount", .ty = .num },
        },
        .tax_category => &[_]Field{}, // only <Name>; branch entries stay GUI/doc-passthrough
        .bom => &[_]Field{}, // doc-gated: needs the produced item + unit shape
        .voucher_series => &[_]Field{}, // series writes are not wired
    };
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "field maps resolve probe-verified keys per kind" {
    const find = struct {
        fn f(kind: Kind, key: []const u8) ?Field {
            for (fieldsFor(kind)) |f_| {
                if (std.mem.eql(u8, f_.key, key)) return f_;
            }
            return null;
        }
    }.f;
    // string fields + the account vs account-group parent element split
    try testing.expectEqualStrings("ParentGroup", find(.account, "parent").?.elem);
    try testing.expect(find(.account, "parent").?.ty == .str);
    try testing.expectEqualStrings("ParentGroupName", find(.account_group, "parent").?.elem);
    // item-only field stays item-only
    try testing.expect(find(.account, "unit") == null);
    try testing.expectEqualStrings("MainUnit", find(.item, "unit").?.elem);
    // typed fields: number + bool
    try testing.expect(find(.sale_type, "tax_percent").?.ty == .num);
    try testing.expectEqualStrings("TaxPercent", find(.sale_type, "tax_percent").?.elem);
    try testing.expect(find(.item_group, "primary_group").?.ty == .bool);
    try testing.expect(find(.unit_conversion, "con_factor").?.ty == .num);
    // read-only / empty maps
    try testing.expectEqual(@as(usize, 0), fieldsFor(.tax_category).len);
    try testing.expectEqual(@as(usize, 0), fieldsFor(.bom).len);
    // store/unit probe shapes
    try testing.expectEqualStrings("ParentGroup", find(.store, "parent").?.elem);
    try testing.expectEqualStrings("UQC", find(.unit, "uqc").?.elem);
}
