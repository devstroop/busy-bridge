# 007 · ERP-centric facade v1 (work item tracking the RFC)

**Labels:** `rfc` `enhancement` · **Effort:** L · **Status:** open · **Milestone:** H1
**Design:** [docs/erp-operations-layer.md](../erp-operations-layer.md) (layer decision: **same repo, strict layer**)

## Problem

The bridge exposes raw COM mechanics (method names, JSON arg arrays,
`$byref` out-params, integer type codes). Web/mobile apps — the stated
downstream consumers — need *ERP operations*, not serialization details:
"post a sale", "create account", "closing stock". Raw is the right
foundation; it is the wrong product surface. Details and layering: see the
RFC doc above.

## Proposal (summary)

1. **`core/ops` layer** (per RFC): masters / vouchers / reports operations,
   each = type-code lookup → XML build (existing codec) → `Save*FromXML` /
   `GetRecordset` → structured result. Never imports `transport`.
2. **Transport exposure** alongside the raw tier:
   - CLI: `busy-bridge op <verb> …` subcommands,
   - HTTP: `/op/*` routes (additive; raw `/call` `/query` unchanged).
3. **Design decisions to settle during M1** (record in RFC):
   - identity: business keys (`name`+`parent`) vs codes — expose codes in
     responses, accept names where unique;
   - paging/filtering standard shape (`limit`/`cursor`) for list ops;
   - company context: `?comp=`/`X-Company` once [005](005-multi-company-sessions.md) lands;
   - batch/transaction: honor `BeginTran`/`CommitTran` for multi-write ops.

## Milestones

- **M1 — reads**: list/fetch account, item, voucher + balances (unblocks
  read-only app prototypes and the MCP read tools).
- **M2 — writes**: create/update master, post voucher with structured errors.
- **M3 — reports**: trial balance / stock status as named operations.

## Acceptance criteria (per milestone)

- [ ] Layer rules extended if needed (`core/ops` declared in
      `check_layers.ps1`); CI green.
- [ ] Every op has: pure unit tests (XML building, no BUSY) + a live test in
      `tests/live/` against DEMO.
- [ ] Raw tier byte-identical behavior (existing suites pass untouched).
- [ ] Docs: op catalog page generated from code (single source of truth);
      README section "Operations API".
- [ ] M2 blocked by nothing; M3 needs DEMO report formats present.

## Notes

Security composition: `/op/*` and raw routes share one gate — auth ([004](004-remote-exposure-auth.md))
and query-guard ([003](003-guarded-query.md)) apply at the transport edge, not per-route.
