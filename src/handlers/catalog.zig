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

/// M1 — reads. Writes (M2) and reports (M3) live in `tail`; the per-kind
/// master read rows (list-X / get-X) are GENERATED from `masters.kinds`
/// so a new kind in that table lights up the catalog, `op catalog` and
/// docs/operations.md at once. The doc page and GET /op regenerate from
/// this table. WP2: write rows are generated the same way — see
/// `kindWriteOps` below (fields.zig supplies the per-kind keys).
const masters = @import("masters.zig");
const fields = @import("masters/fields.zig");

fn kindReadOps() [masters.routedCount() * 2]Op {
    @setEvalBranchQuota(100_000);
    var out: [masters.routedCount() * 2]Op = undefined;
    var i: usize = 0;
    for (masters.kinds) |k| {
        if (!k.route) continue;
        out[i] = .{
            .name = "list-" ++ k.plur,
            .route = "GET /op/" ++ k.plur,
            .cli = "op list " ++ k.plur,
            .params = "limit (0 = unlimited, default 100), q (case-insensitive name substring)",
            .summary = "list " ++ k.sing ++ " masters: {code, name, parent{code,name}}",
        };
        out[i + 1] = .{
            .name = "get-" ++ k.sing,
            .route = "GET /op/" ++ k.sing ++ "?name=",
            .cli = "op get " ++ k.sing ++ " <name>",
            .params = "name (exact business name)",
            .summary = "one " ++ k.sing ++ ": identity + parent + full document tree",
        };
        i += 2;
    }
    return out;
}

/// Comptime join of a kind's writable field keys ("parent, unit").
fn fieldKeys(kind: masters.Kind) []const u8 {
    comptime {
        var s: []const u8 = "";
        for (fields.fieldsFor(kind)) |f| {
            s = s ++ (if (s.len == 0) f.key else ", " ++ f.key);
        }
        return s;
    }
}

/// create + optional update + optional delete rows per kind — generated
/// from the same capability flags the handlers gate on: create/update for
/// every writable kind (wrap != null), update only when the kind has
/// fields (tax-category's only element is <Name>), delete only when the
/// COM delete probe-verified clean. Read-only kinds (unit-conversion,
/// bom, series) are deliberately absent: their ops answer a precise
/// BadArgs instead of a catalog-listed success path.
const writeRowCount: usize = blk: {
    @setEvalBranchQuota(100_000);
    var n: usize = 0;
    for (masters.kinds) |k| {
        if (k.wrap == null) continue;
        n += 1;
        if (fields.fieldsFor(k.kind).len > 0) n += 1;
        if (k.deletable) n += 1;
    }
    break :blk n;
};

fn kindWriteOps() [writeRowCount]Op {
    @setEvalBranchQuota(100_000);
    var out: [writeRowCount]Op = undefined;
    var i: usize = 0;
    for (masters.kinds) |k| {
        if (k.wrap == null) continue;
        const keys = fieldKeys(k.kind);
        out[i] = .{
            .name = "create-" ++ k.sing,
            .route = "POST /op/" ++ k.sing,
            .cli = "op create " ++ k.sing ++ " <name> --json {..}",
            .params = "name (positional or in JSON)" ++ (if (keys.len == 0) "" else ", fields: " ++ keys),
            .summary = "create the " ++ k.sing ++ " master; returns {kind, code, name}",
        };
        i += 1;
        if (fields.fieldsFor(k.kind).len > 0) {
            out[i] = .{
                .name = "update-" ++ k.sing,
                .route = "PUT /op/" ++ k.sing ++ "?name=",
                .cli = "op update " ++ k.sing ++ " <name> --json {..}",
                .params = "name (key), fields: " ++ keys ++ " — merged into the full existing document",
                .summary = "update by name; untouched BUSY fields preserved",
            };
            i += 1;
        }
        if (k.deletable) {
            out[i] = .{
                .name = "delete-" ++ k.sing,
                .route = "DELETE /op/" ++ k.sing ++ "?name=",
                .cli = "op delete " ++ k.sing ++ " <name>",
                .params = "name (exact business name)",
                .summary = "delete a " ++ k.sing ++ " master -> {code, deleted:true}",
            };
            i += 1;
        }
    }
    return out;
}

const head = [_]Op{
    .{
        .name = "catalog",
        .route = "GET /op",
        .cli = "op catalog",
        .params = "none",
        .summary = "this catalog (plain text on CLI, JSON/XML over HTTP)",
    },
};

const tail = [_]Op{
    .{
        .name = "list-series",
        .route = "GET /op/series",
        .cli = "op list series [--type T]",
        .params = "type? (canonical voucher type, e.g. sale — strips the stored 2-digit prefix), limit (default 100), q (name substring)",
        .summary = "voucher series: {code, name, parent} — raw stored names unless type given (then prefix-free; type pages SQL-side, never empty while has_more)",
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
    // ---- M2 writes: create/update/delete rows per kind are GENERATED
    // by kindWriteOps() above (registry capability flags + field maps);
    // account/item ride the same generator as every other kind now ----
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

pub const all = head ++ kindReadOps() ++ kindWriteOps() ++ tail;

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
    // generated per-kind rows + the series list row
    try testing.expect(find("list-units") != null);
    try testing.expect(find("get-unit") != null);
    try testing.expect(find("get-tax-category") != null);
    try testing.expect(find("list-series") != null);
    try testing.expect(std.mem.indexOf(u8, md, "GET /op/tax-categories") != null);
    // WP2 generated write rows: wired kinds present, capability-gated
    // kinds absent (create+update+delete for account; unit has no delete;
    // tax-category has no update (no fields); read-only kinds none)
    try testing.expect(find("create-account") != null);
    try testing.expect(find("update-account") != null);
    try testing.expect(find("delete-account") != null);
    try testing.expect(find("create-unit") != null);
    try testing.expect(find("update-sale-type") != null);
    try testing.expect(find("delete-unit") == null);
    try testing.expect(find("delete-store") == null);
    try testing.expect(find("update-tax-category") == null);
    try testing.expect(find("create-unit-conversion") == null);
    try testing.expect(find("create-bom") == null);
    try testing.expect(find("delete-series") == null);
    try testing.expect(std.mem.indexOf(u8, md, "POST /op/store") != null);
    try testing.expect(std.mem.indexOf(u8, md, "PUT /op/account-group?name=") != null);
}
