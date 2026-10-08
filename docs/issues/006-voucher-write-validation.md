# 006 · Voucher write validation + Tran1 no-recordset semantics

**Labels:** `tests` · **Effort:** S · **Status:** open · **Milestone:** H0

## Problem

The live suites validate **masters** end-to-end (create → read → delete), but the
**voucher** write path — the single most important write in an accounting system —
has never run against a real company: DEMO contains no vouchers.

Worse, during investigation `SELECT TOP 5 Code, VchType FROM Tran1` against DEMO
returned `GetRecordset returned vt=0 (no recordset)` — **not** an empty resultset.
So either voucher tables are invisible until created in the `.bds` era, or
`GetRecordset`'s missing-table behavior differs from the documented model. We do
not yet know which — that ambiguity is itself a documentation bug.

## Proposal

1. **Probe & document the semantics**: run a battery against DEMO —
   `SELECT … FROM Tran1` (exists?), `FROM MissingTable` (vt=0?), aggregate
   `SELECT COUNT(*) FROM Tran1` — and write the observed rule into
   `docs/com-xml-interface.md` ("missing table ⇒ no recordset ⇒ error X; empty
   table ⇒ recordset with 0 rows; distinguish via…"). Add a bridge-side
   improvement if warranted: map vt=0 to a distinct
   `code:"no_recordset"` (exists today) plus a hint when the cause is likely
   a missing table.
2. **Voucher round-trip live test** (`tests/live/04-voucher-roundtrip.ps1`):
   - create a SALE voucher via `SaveVchFromXML` (real STPT from DEMO — read one
     from BUSY's XML export or handcraft against the demo's `Main` series),
   - read it back with `GetVchXML`, deep-compare key fields,
   - `DeleteVchByCode`, verify gone in `Tran1`.
3. If creating a first voucher requires UI-side setup (voucher series, item,
   godowns…), do that setup in DEMO once and document it in the test header —
   a test that encodes its own prerequisites is a fixture.

## Acceptance criteria

- [ ] `tests/live/04-voucher-roundtrip.ps1` passes against DEMO and runs in `run-all.ps1`.
- [ ] Missing-table vs empty-table behavior documented with observed evidence.
- [ ] XML-mode and JSON-mode both exercised for the voucher path (at least read).
- [ ] CI note: unit tests cover the error-mapping change with a stub.

## Notes

Closes the last green-path unknown in the write surface; also feeds the facade
design ([007](007-erp-facade-rfc.md)) — `POST /v1/vouchers` must know this
distinction to return honest errors.
