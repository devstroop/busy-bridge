//! The operations catalog (facade M1, issue #7): single source of truth
//! for the op surface — consumed by `busy-bridge op catalog` (docs
//! generation) and `GET /op` (machine-readable). Pure data + markdown.
const std = @import("std");

const Allocator = std.mem.Allocator;

pub const Op = struct {
    name: []const u8,
    route: []const u8,
    cli: []const u8,
    params: []const u8,
    summary: []const u8,
};

/// M1 — reads. Writes (M2) and reports (M3) append here; the doc page and
/// GET /op regenerate from this table.
pub const all = [_]Op{
    .{
        .name = "catalog",
        .route = "GET /op",
        .cli = "op catalog",
        .params = "none",
        .summary = "this catalog (plain text on CLI, JSON/XML over HTTP)",
    },
    .{
        .name = "list-accounts",
        .route = "GET /op/accounts",
        .cli = "op list accounts",
        .params = "limit (0 = unlimited, default 100), q (case-insensitive name substring)",
        .summary = "list account masters: {code, name, parent{code,name}}",
    },
    .{
        .name = "get-account",
        .route = "GET /op/account?name=",
        .cli = "op get account <name>",
        .params = "name (exact business name)",
        .summary = "one account: identity + parent + full document tree",
    },
    .{
        .name = "list-items",
        .route = "GET /op/items",
        .cli = "op list items",
        .params = "limit (default 100), q (name substring)",
        .summary = "list item masters: {code, name, parent{code,name}}",
    },
    .{
        .name = "get-item",
        .route = "GET /op/item?name=",
        .cli = "op get item <name>",
        .params = "name (exact business name)",
        .summary = "one item: identity + parent group + full document tree",
    },
    .{
        .name = "list-vouchers",
        .route = "GET /op/vouchers",
        .cli = "op list vouchers",
        .params = "type (canonical name, e.g. sale; default all), limit (default 100)",
        .summary = "list vouchers: {code, type{code,name}, no, date, series{code,name}, party{code,name}}",
    },
    .{
        .name = "get-voucher",
        .route = "GET /op/voucher?code=",
        .cli = "op get voucher <code>",
        .params = "code (Tran1 VchCode)",
        .summary = "one voucher: scalars (no/date/series/party) + full document tree",
    },
};

pub fn find(name: []const u8) ?*const Op {
    for (&all) |*op| if (std.mem.eql(u8, op.name, name)) return op;
    return null;
}

/// Markdown catalog page body — `scripts/docs/generate-ops-doc.ps1`
/// captures this output into docs/operations.md.
pub fn markdown(alloc: Allocator) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    try out.appendSlice(alloc,
        \\| op | HTTP | CLI | parameters | summary |
        \\|---|---|---|---|---|
        \\
    );
    for (all) |op| {
        try out.appendSlice(alloc, "| `");
        try out.appendSlice(alloc, op.name);
        try out.appendSlice(alloc, "` | `");
        try out.appendSlice(alloc, op.route);
        try out.appendSlice(alloc, "` | `busy-bridge ");
        try out.appendSlice(alloc, op.cli);
        try out.appendSlice(alloc, "` | ");
        try out.appendSlice(alloc, op.params);
        try out.appendSlice(alloc, " | ");
        try out.appendSlice(alloc, op.summary);
        try out.appendSlice(alloc, " |\n");
    }
    return out.toOwnedSlice(alloc);
}

// ---------------- tests ----------------

const testing = std.testing;

test "catalog is well-formed" {
    try testing.expect(all.len >= 7);
    for (&all) |*op| {
        try testing.expect(op.name.len > 0);
        try testing.expect(std.mem.startsWith(u8, op.route, "GET /op"));
        try testing.expect(std.mem.startsWith(u8, op.cli, "op "));
    }
    try testing.expect(find("list-accounts") != null);
    try testing.expect(find("nope") == null);

    const md = try markdown(testing.allocator);
    defer testing.allocator.free(md);
    try testing.expect(std.mem.indexOf(u8, md, "| `get-voucher` | `GET /op/voucher?code=` |") != null);
    try testing.expect(std.mem.indexOf(u8, md, "op list vouchers") != null);
}
