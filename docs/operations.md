# Operations API catalog (generated)

**Do not edit by hand** - regenerate with:

    powershell -File scripts/docs/generate-ops-doc.ps1

Source of truth: `src/handlers/catalog.zig` (the same table serves
`busy-bridge op catalog` and `GET /op`). Overview: repository README,
section "Operations API".

| op | HTTP | CLI | parameters | summary |
|---|---|---|---|---|
| `catalog` | `GET /op` | `busy-bridge op catalog` | none | this catalog (plain text on CLI, JSON/XML over HTTP) |
| `list-accounts` | `GET /op/accounts` | `busy-bridge op list accounts` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list account masters: {code, name, parent{code,name}} |
| `get-account` | `GET /op/account?name=` | `busy-bridge op get account <name>` | name (exact business name) | one account: identity + parent + full document tree |
| `list-items` | `GET /op/items` | `busy-bridge op list items` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list item masters: {code, name, parent{code,name}} |
| `get-item` | `GET /op/item?name=` | `busy-bridge op get item <name>` | name (exact business name) | one item: identity + parent + full document tree |
| `list-account-groups` | `GET /op/account-groups` | `busy-bridge op list account-groups` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list account-group masters: {code, name, parent{code,name}} |
| `get-account-group` | `GET /op/account-group?name=` | `busy-bridge op get account-group <name>` | name (exact business name) | one account-group: identity + parent + full document tree |
| `list-item-groups` | `GET /op/item-groups` | `busy-bridge op list item-groups` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list item-group masters: {code, name, parent{code,name}} |
| `get-item-group` | `GET /op/item-group?name=` | `busy-bridge op get item-group <name>` | name (exact business name) | one item-group: identity + parent + full document tree |
| `list-units` | `GET /op/units` | `busy-bridge op list units` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list unit masters: {code, name, parent{code,name}} |
| `get-unit` | `GET /op/unit?name=` | `busy-bridge op get unit <name>` | name (exact business name) | one unit: identity + parent + full document tree |
| `list-unit-conversions` | `GET /op/unit-conversions` | `busy-bridge op list unit-conversions` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list unit-conversion masters: {code, name, parent{code,name}} |
| `get-unit-conversion` | `GET /op/unit-conversion?name=` | `busy-bridge op get unit-conversion <name>` | name (exact business name) | one unit-conversion: identity + parent + full document tree |
| `list-bill-sundries` | `GET /op/bill-sundries` | `busy-bridge op list bill-sundries` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list bill-sundry masters: {code, name, parent{code,name}} |
| `get-bill-sundry` | `GET /op/bill-sundry?name=` | `busy-bridge op get bill-sundry <name>` | name (exact business name) | one bill-sundry: identity + parent + full document tree |
| `list-stores` | `GET /op/stores` | `busy-bridge op list stores` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list store masters: {code, name, parent{code,name}} |
| `get-store` | `GET /op/store?name=` | `busy-bridge op get store <name>` | name (exact business name) | one store: identity + parent + full document tree |
| `list-sale-types` | `GET /op/sale-types` | `busy-bridge op list sale-types` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list sale-type masters: {code, name, parent{code,name}} |
| `get-sale-type` | `GET /op/sale-type?name=` | `busy-bridge op get sale-type <name>` | name (exact business name) | one sale-type: identity + parent + full document tree |
| `list-purchase-types` | `GET /op/purchase-types` | `busy-bridge op list purchase-types` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list purchase-type masters: {code, name, parent{code,name}} |
| `get-purchase-type` | `GET /op/purchase-type?name=` | `busy-bridge op get purchase-type <name>` | name (exact business name) | one purchase-type: identity + parent + full document tree |
| `list-boms` | `GET /op/boms` | `busy-bridge op list boms` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list bom masters: {code, name, parent{code,name}} |
| `get-bom` | `GET /op/bom?name=` | `busy-bridge op get bom <name>` | name (exact business name) | one bom: identity + parent + full document tree |
| `list-tax-categories` | `GET /op/tax-categories` | `busy-bridge op list tax-categories` | limit (0 = unlimited, default 100), q (case-insensitive name substring) | list tax-category masters: {code, name, parent{code,name}} |
| `get-tax-category` | `GET /op/tax-category?name=` | `busy-bridge op get tax-category <name>` | name (exact business name) | one tax-category: identity + parent + full document tree |
| `create-account` | `POST /op/account` | `busy-bridge op create account <name> --json {..}` | name (positional or in JSON), fields: parent | create the account master; returns {kind, code, name} |
| `update-account` | `PUT /op/account?name=` | `busy-bridge op update account <name> --json {..}` | name (key), fields: parent ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `delete-account` | `DELETE /op/account?name=` | `busy-bridge op delete account <name>` | name (exact business name) | delete a account master -> {code, deleted:true} |
| `create-item` | `POST /op/item` | `busy-bridge op create item <name> --json {..}` | name (positional or in JSON), fields: parent, unit | create the item master; returns {kind, code, name} |
| `update-item` | `PUT /op/item?name=` | `busy-bridge op update item <name> --json {..}` | name (key), fields: parent, unit ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `delete-item` | `DELETE /op/item?name=` | `busy-bridge op delete item <name>` | name (exact business name) | delete a item master -> {code, deleted:true} |
| `create-account-group` | `POST /op/account-group` | `busy-bridge op create account-group <name> --json {..}` | name (positional or in JSON), fields: parent | create the account-group master; returns {kind, code, name} |
| `update-account-group` | `PUT /op/account-group?name=` | `busy-bridge op update account-group <name> --json {..}` | name (key), fields: parent ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `delete-account-group` | `DELETE /op/account-group?name=` | `busy-bridge op delete account-group <name>` | name (exact business name) | delete a account-group master -> {code, deleted:true} |
| `create-item-group` | `POST /op/item-group` | `busy-bridge op create item-group <name> --json {..}` | name (positional or in JSON), fields: parent, primary_group | create the item-group master; returns {kind, code, name} |
| `update-item-group` | `PUT /op/item-group?name=` | `busy-bridge op update item-group <name> --json {..}` | name (key), fields: parent, primary_group ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `delete-item-group` | `DELETE /op/item-group?name=` | `busy-bridge op delete item-group <name>` | name (exact business name) | delete a item-group master -> {code, deleted:true} |
| `create-unit` | `POST /op/unit` | `busy-bridge op create unit <name> --json {..}` | name (positional or in JSON), fields: print_name, uqc, uqc_ewaybill | create the unit master; returns {kind, code, name} |
| `update-unit` | `PUT /op/unit?name=` | `busy-bridge op update unit <name> --json {..}` | name (key), fields: print_name, uqc, uqc_ewaybill ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `create-bill-sundry` | `POST /op/bill-sundry` | `busy-bridge op create bill-sundry <name> --json {..}` | name (positional or in JSON), fields: print_name, percent_of_amount, bsnature, type, amount_basis, point_of_calculation, no_of_pbs, sub_total_desc, sales_acc_name, purc_acc_name | create the bill-sundry master; returns {kind, code, name} |
| `update-bill-sundry` | `PUT /op/bill-sundry?name=` | `busy-bridge op update bill-sundry <name> --json {..}` | name (key), fields: print_name, percent_of_amount, bsnature, type, amount_basis, point_of_calculation, no_of_pbs, sub_total_desc, sales_acc_name, purc_acc_name ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `create-store` | `POST /op/store` | `busy-bridge op create store <name> --json {..}` | name (positional or in JSON), fields: print_name, parent, stock_account, purchase_account, sales_account, stock_belongs_to_you | create the store master; returns {kind, code, name} |
| `update-store` | `PUT /op/store?name=` | `busy-bridge op update store <name> --json {..}` | name (key), fields: print_name, parent, stock_account, purchase_account, sales_account, stock_belongs_to_you ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `create-sale-type` | `POST /op/sale-type` | `busy-bridge op create sale-type <name> --json {..}` | name (positional or in JSON), fields: sale_account, taxable, tax_percent, vat_gst_type, type, input_tax_credit, percent_of_amount | create the sale-type master; returns {kind, code, name} |
| `update-sale-type` | `PUT /op/sale-type?name=` | `busy-bridge op update sale-type <name> --json {..}` | name (key), fields: sale_account, taxable, tax_percent, vat_gst_type, type, input_tax_credit, percent_of_amount ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `create-purchase-type` | `POST /op/purchase-type` | `busy-bridge op create purchase-type <name> --json {..}` | name (positional or in JSON), fields: purchase_account, taxable, tax_percent, vat_gst_type, type, input_tax_credit, percent_of_amount | create the purchase-type master; returns {kind, code, name} |
| `update-purchase-type` | `PUT /op/purchase-type?name=` | `busy-bridge op update purchase-type <name> --json {..}` | name (key), fields: purchase_account, taxable, tax_percent, vat_gst_type, type, input_tax_credit, percent_of_amount ΓÇö merged into the full existing document | update by name; untouched BUSY fields preserved |
| `create-tax-category` | `POST /op/tax-category` | `busy-bridge op create tax-category <name> --json {..}` | name (positional or in JSON) | create the tax-category master; returns {kind, code, name} |
| `delete-tax-category` | `DELETE /op/tax-category?name=` | `busy-bridge op delete tax-category <name>` | name (exact business name) | delete a tax-category master -> {code, deleted:true} |
| `list-series` | `GET /op/series` | `busy-bridge op list series [--type T]` | type? (canonical voucher type, e.g. sale ΓÇö strips the stored 2-digit prefix), limit (default 100), q (name substring) | voucher series: {code, name, parent} ΓÇö raw stored names unless type given (then prefix-free; type pages SQL-side, never empty while has_more) |
| `list-vouchers` | `GET /op/vouchers` | `busy-bridge op list vouchers` | type (canonical name, e.g. sale; default all), limit (default 100) | list vouchers: {code, type{code,name}, no, date, series{code,name}, party{code,name}} |
| `get-voucher` | `GET /op/voucher?code=` | `busy-bridge op get voucher <code>` | code (Tran1 VchCode) | one voucher: scalars (no/date/series/party) + full document tree |
| `post-voucher` | `POST /op/voucher` | `busy-bridge op post --json {..}` | type (sale|journal, or any type with doc), date YYYY-MM-DD, series (default Main), no?, sale: stpt, party, store?, lines[]; journal: entries[] {account, amount, dr}; or doc: {Root:{...}} passthrough | post a voucher; returns {code, type, posted:true} (VchCode via ByRef) |
| `delete-voucher` | `DELETE /op/voucher?code=` | `busy-bridge op delete voucher <code>` | code (integer VchCode) | delete a voucher -> {code, deleted:true} |
| `batch` | `POST /op/batch` | `busy-bridge op batch --json [..]` | array of {op, args} write entries | run write ops inside BeginTran/CommitTran; any failure rolls back all (code: batch_rolled_back) |
| `account-balance` | `GET /op/report/account-balance` | `busy-bridge op report account-balance --name X --from D --to D` | name (account), from, to (YYYY-MM-DD) | single account opening/closing balance for a period |
| `group-balance` | `GET /op/report/group-balance` | `busy-bridge op report group-balance --group X --from D --to D` | group (account group), from, to | group incl. children: opening, debit, credit movement |
| `trial-balance` | `GET /op/report/trial-balance` | `busy-bridge op report trial-balance --from D --to D` | from, to | every root account group + book totals (dr == -cr when balanced; BUSY's debit column is signed) |
| `stock-status` | `GET /op/report/stock-status` | `busy-bridge op report stock-status --date D [--item X] [--q F]` | date, item? (exact), q? (substring), limit (default 100, 0 = unlimited) | per-item main/alt quantity on hand at a date (GetItemValue) |
| `day-book` | `GET /op/report/day-book` | `busy-bridge op report day-book --from D --to D [--type T] [--party P]` | from, to (YYYY-MM-DD), type? (canonical name, e.g. sale), party? (account name), limit (default 100, 0 = unlimited) | vouchers in a period, each with account lines + debit/credit totals (Tran1+Tran2) |
| `ledger` | `GET /op/report/ledger` | `busy-bridge op report ledger --name X --from D --to D` | name (account), from, to, limit (default 100, 0 = unlimited) | one account's rows in a period with running balance; value/balance signed negative = debit (BUSY convention) |

