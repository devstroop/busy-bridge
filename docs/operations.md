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

