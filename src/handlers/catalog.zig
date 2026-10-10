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
    // ---- M2 writes (issue #7): one exec dispatcher for CLI + HTTP ----
    .{
        .name = "create-account",
        .route = "POST /op/account",
        .cli = "op create account <name> --json {..}",
        .params = "name (positional or in JSON), parent (group name)",
        .summary = "create an account master; returns {kind, code, name, parent}",
    },
    .{
        .name = "update-account",
        .route = "PUT /op/account?name=",
        .cli = "op update account <name> --json {..}",
        .params = "name (key), fields: parent — merged into the full existing document",
        .summary = "update by name; untouched BUSY fields preserved",
    },
    .{
        .name = "delete-account",
        .route = "DELETE /op/account?name=",
        .cli = "op delete account <name>",
        .params = "name (exact business name)",
        .summary = "delete an account master -> {code, deleted:true}",
    },
    .{
        .name = "create-item",
        .route = "POST /op/item",
        .cli = "op create item <name> --json {..}",
        .params = "name, parent (group), unit (main unit)",
        .summary = "create an item master; returns {kind, code, name, parent, unit}",
    },
    .{
        .name = "update-item",
        .route = "PUT /op/item?name=",
        .cli = "op update item <name> --json {..}",
        .params = "name (key), fields: parent, unit",
        .summary = "update by name; untouched BUSY fields preserved",
    },
    .{
        .name = "delete-item",
        .route = "DELETE /op/item?name=",
        .cli = "op delete item <name>",
        .params = "name (exact business name)",
        .summary = "delete an item master -> {code, deleted:true}",
    },
    .{
        .name = "post-voucher",
        .route = "POST /op/voucher",
        .cli = "op post --json {..}",
        .params = "type (sale|journal, or any type with doc), date YYYY-MM-DD, series (default Main), no?, sale: stpt, party, store?, lines[]; journal: entries[] {account, amount, dr}; or doc: {Root:{...}} passthrough",
        .summary = "post a voucher; returns {code, type, posted:true} (VchCode via ByRef)",
    },
    .{
        .name = "delete-voucher",
        .route = "DELETE /op/voucher?code=",
        .cli = "op delete voucher <code>",
        .params = "code (integer VchCode)",
        .summary = "delete a voucher -> {code, deleted:true}",
    },
    .{
        .name = "batch",
        .route = "POST /op/batch",
        .cli = "op batch --json [..]",
        .params = "array of {op, args} write entries",
        .summary = "run write ops inside BeginTran/CommitTran; any failure rolls back all (code: batch_rolled_back)",
    },
    // ---- M3 reports (issue #7): named operations over the balance /
    // ---- stock report methods (typed out-params probe-verified) ----
    .{
        .name = "account-balance",
        .route = "GET /op/report/account-balance",
        .cli = "op report account-balance --name X --from D --to D",
        .params = "name (account), from, to (YYYY-MM-DD)",
        .summary = "single account opening/closing balance for a period",
    },
    .{
        .name = "group-balance",
        .route = "GET /op/report/group-balance",
        .cli = "op report group-balance --group X --from D --to D",
        .params = "group (account group), from, to",
        .summary = "group incl. children: opening, debit, credit movement",
    },
    .{
        .name = "trial-balance",
        .route = "GET /op/report/trial-balance",
        .cli = "op report trial-balance --from D --to D",
        .params = "from, to",
        .summary = "every root account group + book totals (dr == -cr when balanced; BUSY's debit column is signed)",
    },
    .{
        .name = "stock-status",
        .route = "GET /op/report/stock-status",
        .cli = "op report stock-status --date D [--item X] [--q F]",
        .params = "date, item? (exact), q? (substring), limit (default 100, 0 = unlimited)",
        .summary = "per-item main/alt quantity on hand at a date (GetItemValue)",
    },
    // ---- transaction reports (SQL-backed, probe §13) ----
    .{
        .name = "day-book",
        .route = "GET /op/report/day-book",
        .cli = "op report day-book --from D --to D [--type T] [--party P]",
        .params = "from, to (YYYY-MM-DD), type? (canonical name, e.g. sale), party? (account name), limit (default 100, 0 = unlimited)",
        .summary = "vouchers in a period, each with account lines + debit/credit totals (Tran1+Tran2)",
    },
    .{
        .name = "ledger",
        .route = "GET /op/report/ledger",
        .cli = "op report ledger --name X --from D --to D",
        .params = "name (account), from, to, limit (default 100, 0 = unlimited)",
        .summary = "one account's rows in a period with running balance; value/balance signed negative = debit (BUSY convention)",
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
    try testing.expect(all.len >= 20);
    for (&all) |*op| {
        try testing.expect(op.name.len > 0);
        try testing.expect(std.mem.indexOf(u8, op.route, "/op") != null);
        try testing.expect(std.mem.startsWith(u8, op.cli, "op "));
    }
    try testing.expect(find("list-accounts") != null);
    try testing.expect(find("post-voucher") != null);
    try testing.expect(find("batch") != null);
    try testing.expect(find("nope") == null);

    const md = try markdown(testing.allocator);
    defer testing.allocator.free(md);
    try testing.expect(std.mem.indexOf(u8, md, "| `get-voucher` | `GET /op/voucher?code=` |") != null);
    try testing.expect(std.mem.indexOf(u8, md, "op list vouchers") != null);
    try testing.expect(std.mem.indexOf(u8, md, "POST /op/batch") != null);
}
