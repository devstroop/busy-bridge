# (T4) — day-book/ledger COM-getter sweep: pins + precise negatives (2026-10-12)

Bridge-map lane T4 (BUSY-004). Ad-hoc timed `call`s vs COMP0001 (BUSY Rel 14,
Busy21 resident COM server; `-SkipLockCheck` not needed for direct calls).
Replayable artifacts: `tests/probe/tasks/t4-daybook-layout.ps1` (seed →
sweep → cleanup) + `t4-daybook-probes.json` + fixture
`tests/probe/fixtures/iter24-daybook-layout.json`. **No `src/` changes.**

## Pins (positive)

1. **`GetAccLedgerJSON` full tail accepted** — with the true typelib
   signature (`_Collection, string, double, bool, Date, bool, bool`, from the
   surface dumps) the call `[coll(4+ items), {"$byref":"bstr"}, 0.0, false,
   {"$date":"2026-04-30"}, false, false]` invokes cleanly. §8's
   `DISP_E_TYPEMISMATCH` saga on "p_OpBal/p_Chk*" was **positional
   guessing** — plain scalars are correct. Result `{}` = empty company
   (see corrected fact).
2. **`GetAccDayBookJSON` param 4 (Date) is REQUIRED** — 3-arg calls
   `[coll, byref-bstr, bool]` → `0x8002000F` (DISP_E_PARAMNOTFOUND) for every
   collection shape; the4-arg form always runs.
3. **Rights identity is strictly collection POSITION 3** — `Admin` at
   position 1 → `ok:true, outs:["User don't have rights to view this report."]`;
   same value at position 3 clears the gate (reproduces §8). Position 3 is
   necessary (not sufficient — below).
4. **Seeding method proven**: `op post-voucher` (journal, series Main,
   Cash/Sales) creates Tran1 rows in COMP0001 (codes 1–2) and
   `op delete-voucher` removes them (Tran1 count returns 0) — zero-residue
   round-trip for any future row-level probe of these getters.

## Corrected fact (supersedes the work-map claim)

- **COMP0001 has ZERO vouchers** (`SELECT COUNT(*) FROM Tran1` → 0;
  §8's "three vouchers" lived in a separate data-bearing company, not
  COMP0001). Every `{}` on an empty company is therefore the CORRECT
  response, and empty-company sweeps cannot discriminate layout — hence the
  seed-then-sweep method above.

## Precise negatives (layout STILL unsolved — with data in window)

Two seeded journals (2026-04-05, 2026-04-10; window 01–30/04/2026) — all
variants returned `{"ok":true,"result":"{}"}`:

| # | Collection (positions 1..) | Params |
|---|---|---|
| D1 | party, "Sale", Admin, VT_DATE, VT_DATE | 4-arg tail |
| D3 | "", "", Admin, VT_DATE, VT_DATE | 4-arg |
| D7 | party, "Sale", Admin, str DD/MM ×2 | 4-arg |
| S16/S0/S9 | int VchType 16/0/9, "", Admin, VT_DATE ×2 | 4-arg |
| Sd | VT_DATE, VT_DATE, Admin, "", "" | 4-arg |
| Ss | 16, "", Admin, str DD/MM ×2 | 4-arg |
| D6/Sj | partial=true; junk 4-item control | 4-arg |

Identity@3 is **necessary but not sufficient**. Remaining hypotheses
(ordered by leverage): (a) the getter is gated on session/mobile-user state
(same family as the §18 JSON-save gate — `ValidMobileUserPassword`
pre-state or CS/mobile config); (b) the collection carries UDT/dispatch
items or a larger fixed layout we have not guessed; (c) GUI-only
construction (the VB6 form builds the collection with typed items our
JSON markers cannot express yet — `$collection` of `$record` is T3).

## Next lever

T1 (`ConfigMobileAppSeries` depth-3 decode) + T3 (records-in-collections)
change what can even be SENT; re-run this sweep's script after either
lands. Server spec `docs/specs/daybook-com-path.md` (S4) should record:
COM path remains **blocked on layout**, SQL path stays the production
default — this fragment is its trigger artifact.

Changelog line for the operator (fold in at commit time):
`**T4**: day-book/ledger getter sweep — ledger tail pinned, day-book
Date-param + identity-position facts, COMP0001-empty correction; layout
still unsolved (seed→sweep→cleanup script committed).`
