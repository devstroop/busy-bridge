# RFC: ERP-centric facade over busy-bridge

**Question:** should ERP-facing (BUSY-domain) operations live at the same
layer as generic code, or in a separate project layer?

**Decision: same repository, separate strict layer** — a top-level
*handlers* layer on top of `core/com`, exposed through the existing
transports. Extract into its own package only when a second consumer
appears (the Zig `addModule` boundary is mechanical *because* the layer
rules hold).

## Problem

The bridge currently exposes **raw COM mechanics**: method names, JSON arg
arrays, `{"$byref":…}` out-params, master-type integers. A consumer writing
"a sale for this party" must know:

- `SaveVchFromXML` and its 8-arg signature,
- the voucher-type integer (`SALE=9`),
- the BUSY XML document schema,
- ByRef error conventions.

That is API-surface exposure, not *ERP* exposure. Integrators want
operations — `createAccount`, `postSale`, `closingStock` — independent of
BUSY's serialization quirks.

## Proposed layer

```text
src/
├── core/
│   └── com/       raw COM/IDispatch          (exists)
├── handlers/      ERP-level operations       (renamed from core/ops, issue 012)
│   ├── masters.zig      create/update/delete/fetch masters by concept
│   ├── vouchers.zig     post/fetch vouchers, bill-wise data
│   └── reports.zig      balances, stock, trial balance helpers
```

Rules (enforced by `scripts/check_layers.ps1`):

- `handlers` → may import `core/**`, `util/*` — **never** `transport` (facade renamed from `ops` for issue #12: left `core/`)
- `transport` may import `handlers` — commands/HTTP gain an operations API
  alongside the existing raw escape hatch
- raw `call`/`surface` remain available — nothing is hidden

Example target surface (JSON mode):

```json
POST /op/create-master
{"kind":"account","name":"Zig Acct","parent":"Cash-in-hand"}

POST /op/post-voucher
{"type":"sale","series":"Main","date":"08-10-2026","account":"...", "lines":[...]}
```

Each operation internally: type-code lookup (from
[constants](../docs/constants.md)) → XML document build → `Save*FromXML` →
structured error mapping. The XML codec from Phase 2 does the heavy lifting.

## Why not a separate repo/package now

| Option | Verdict |
|---|---|
| Same layer as COM code (no boundary) | ❌ leaks serialization details into transport; untestable without BUSY |
| **Separate layer, same repo (chosen)** | ✅ atomic refactors, one CI, layer checker enforces direction; docs/README live beside it |
| Separate package | ⏸ when a second consumer (another repo/product) needs `handlers` without the bridge |

## Migration impact

- additive: no wire-format change (Phase 3 contract untouched),
- new routes are opt-in (`/op/*`), CLI grows `op` subcommands,
- tests: pure unit tests for XML building (no BUSY) + live round-trips in
  `tests/live/`.

## Status

**M1 (reads) + M2 (writes) + M3 (reports) implemented** —
`handlers/{masters,vouchers,exec,batch,reports,catalog}.zig` behind
`busy-bridge op …` and `GET|POST|PUT|DELETE /op/*` (README “Operations
API”, [catalog](operations.md), live suites `06-ops-reads`,
`07-ops-writes`, `08-reports` — including `BeginTran`/`CommitTran`/
`RollBackTran` batch transactions through COtherServices and named
report operations over CMasterServices/GetItemValue with typed ByRef
out-params). **All RFC milestones complete — issue #7 closed.**
