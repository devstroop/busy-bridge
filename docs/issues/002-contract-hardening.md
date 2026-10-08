# 002 · Contract hardening: constants.json, GET /info, error codes

**Labels:** `enhancement` `api` · **Effort:** S · **Status:** open · **Milestone:** H0

## Problem

Downstream consumers (apps, agents, even our own tests) currently have three
avoidable frictions:

1. **Integer codes** — master/voucher types (`2` = Account, `9` = SALE) exist
   only in `docs/constants.md`; every consumer ends up hardcoding numbers.
2. **No identity endpoint** — clients cannot learn bridge version, resolved
   ProgID (see [001](001-runtime-progid-discovery.md)), open company, or
   capabilities without parsing prose.
3. **Errors are unstructured strings** — `{"ok":false,"error":"…"}` and
   `<Error code='500'>` carry only HTTP/exit status; no machine code to branch on.

## Proposal

1. **`GET /constants`** (both formats): serve the canonical code tables as data:
   ```json
   {"masters": {"ACCOUNT": 2, "ITEM": 6, ...},
    "vouchers": {"SALE": 9, "PURCHASE": 2, ...}}
   ```
   Source of truth: a small `core/constants.zig` (single table, also powers a
   future `--name SALE` convenience). Docs table becomes generated output.
2. **`GET /info`**: `{bridge_version, zig, prog_id, company, host, formats:["json","xml"], routes:[…]}` (+ XML shape).
3. **Error codes**: every failure carries a stable `code` field beside the
   human message (`"code": "invoke_failed" | "open_db_failed" | "bad_args" | "query_failed" | …`), derived
   from the Zig error name (already known at each site) — in JSON *and* XML envelopes.

## Acceptance criteria

- [ ] `/constants` returns the full tables from `docs/constants.md` (round-trip test vs doc).
- [ ] `/info` accurate for the running process (version, resolved ProgID, company).
- [ ] Every error path in `commands.zig`/`http.zig` includes a `code` (grep-testable).
- [ ] Unit tests + `tests/live` checks; README + docs/constants.md reference `/constants` as canonical.
- [ ] Backward compatible: existing `error`/`description` fields unchanged.

## Notes

Blocks the facade ([007](007-erp-facade-rfc.md)), which needs name↔code maps and stable error taxonomy. Effort is small because the tables already exist in docs.
