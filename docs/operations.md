# Operations API catalog (generated)

**Do not edit by hand** - regenerate with:

    powershell -File scripts/docs/generate-ops-doc.ps1

Source of truth: `src/core/ops/catalog.zig` (the same table serves
`busy-bridge op catalog` and `GET /op`). Overview: repository README,
section "Operations API".

| op | HTTP | CLI | parameters | summary |
|---|---|---|---|---|
| `catalog` | `GET /op` | `busy-bridge op catalog` | none | this catalog (plain text on CLI, JSON/XML over HTTP) |
| `list-accounts` | `GET /op/accounts` | `busy-bridge op list accounts` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list account masters: {code, name, parent{code,name}} |
| `get-account` | `GET /op/account?name=` | `busy-bridge op get account <name>` | name (exact business name) | one account: identity + parent + full document tree |
| `list-items` | `GET /op/items` | `busy-bridge op list items` | limit (default 100), q (name substring) | list item masters: {code, name, parent{code,name}} |
| `get-item` | `GET /op/item?name=` | `busy-bridge op get item <name>` | name (exact business name) | one item: identity + parent group + full document tree |
| `list-vouchers` | `GET /op/vouchers` | `busy-bridge op list vouchers` | type (canonical name, e.g. sale; default all), limit (default 100) | list vouchers: {code, type{code,name}, no, date, series{code,name}, party{code,name}} |
| `get-voucher` | `GET /op/voucher?code=` | `busy-bridge op get voucher <code>` | code (Tran1 VchCode) | one voucher: scalars (no/date/series/party) + full document tree |
| `create-account` | `POST /op/account` | `busy-bridge op create account <name> --json {..}` | name (positional or in JSON), parent (group name) | create an account master; returns {kind, code, name, parent} |
| `update-account` | `PUT /op/account?name=` | `busy-bridge op update account <name> --json {..}` | name (key), fields: parent — merged into the full existing document | update by name; untouched BUSY fields preserved |
| `delete-account` | `DELETE /op/account?name=` | `busy-bridge op delete account <name>` | name (exact business name) | delete an account master -> {code, deleted:true} |
| `create-item` | `POST /op/item` | `busy-bridge op create item <name> --json {..}` | name, parent (group), unit (main unit) | create an item master; returns {kind, code, name, parent, unit} |
| `update-item` | `PUT /op/item?name=` | `busy-bridge op update item <name> --json {..}` | name (key), fields: parent, unit | update by name; untouched BUSY fields preserved |
| `delete-item` | `DELETE /op/item?name=` | `busy-bridge op delete item <name>` | name (exact business name) | delete an item master -> {code, deleted:true} |
| `post-voucher` | `POST /op/voucher` | `busy-bridge op post --json {..}` | type (sale|journal, or any type with doc), date YYYY-MM-DD, series (default Main), no?, sale: stpt, party, store?, lines[]; journal: entries[] {account, amount, dr}; or doc: {Root:{...}} passthrough | post a voucher; returns {code, type, posted:true} (VchCode via ByRef) |
| `delete-voucher` | `DELETE /op/voucher?code=` | `busy-bridge op delete voucher <code>` | code (integer VchCode) | delete a voucher -> {code, deleted:true} |
| `batch` | `POST /op/batch` | `busy-bridge op batch --json [..]` | array of {op, args} write entries | run write ops inside BeginTran/CommitTran; any failure rolls back all (code: batch_rolled_back) |
| `account-balance` | `GET /op/report/account-balance` | `busy-bridge op report account-balance --name X --from D --to D` | name (account), from, to (YYYY-MM-DD) | single account opening/closing balance for a period |
| `group-balance` | `GET /op/report/group-balance` | `busy-bridge op report group-balance --group X --from D --to D` | group (account group), from, to | group incl. children: opening, debit, credit movement |
| `trial-balance` | `GET /op/report/trial-balance` | `busy-bridge op report trial-balance --from D --to D` | from, to | every root account group + book totals (dr == -cr when balanced; BUSY's debit column is signed) |
| `stock-status` | `GET /op/report/stock-status` | `busy-bridge op report stock-status --date D [--item X] [--q F]` | date, item? (exact), q? (substring), limit (default 100, 0 = unlimited) | per-item main/alt quantity on hand at a date (GetItemValue) |

