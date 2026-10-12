# Write-path capability record (BUSY-003 acceptance)

Per-operation status of BUSY's two write paths — the evidence index
feeding the JSON write-path work (BUSY-020). Sources: probe report
iterations (§ numbers below) + WP2 master-write probes
(`busy-server` `tests/live/wp2-probe*.ps1` evidence, 2026-10-11).

Legend: **XML** = `SaveMasterFromXML`/`SaveVchXML` family ·
**JSON** = `SaveMastFromJson`/`SaveVchFromJson` family.

| Operation | XML | JSON | Evidence |
|---|---|---|---|
| Master create (unit, account-group, item-group, store, tax-category; sale/purchase-type + bill-sundry with extra fields) | **verified** | shape accepted, **content keys unresolved** | XML: WP2 ladders (live creates + reads); JSON: §14 (callee runs; `{}` doc → invisible validation raise) + §23 (udtAccMast-keyed docs for account-group/tax-category reach the callee; minimal Name/PrintName/ParentGrpName insufficient) |
| Master update (full-tree fetch-merge-resave) | **verified** | pending | WP2 (all 10 writable kinds) |
| Master delete (account, item, account-group, item-group, tax-category only) | **verified** | pending | WP2 COM-delete crash matrix (unit/store/type/sundry deletes crash BUSY — doc-gated) |
| Unit-conversion write | doc-gated | doc-gated | SaveMasterFromXML crashes on MasterType 16 in all arg forms (WP2) |
| BOM write | n/a on Rel 14 | n/a | `GetBOMMastData` absent (WP2) |
| Voucher save (standard) | verified | **series-gate blocked (fixture)** | JSON: §20 head pin + §23 tail3 numeric family — schema-correct minimal docs return `Invalid voucher series.` on both Main and ZigVch9 (same wall as old-mobile form) |
| Voucher save (old-mobile form) | verified | runs, **series-gate blocked** | §14: end-to-end invoke; `Invalid voucher series.` = per-user mobile-series config missing headless; §18 gate predicates; §20 writers callable (content wall) |
| Series-group config write (`SaveVchSeriesGrpConfig`) | n/a | **callable, content wall** | §20: `udtVchSeriesGrpConfig` (htype 50333725) `$record` accepted; validation raise needs real series-code collection |
| Mobile-app series config (`ConfigMobileAppSeries`) | n/a | UDT not decoded | §18/§20: VT_PTR chain deeper than `surface --types` walks |
| Rights JSON (`GetMobileUserRightsJSONstr`) | n/a | **shape solved, fixture-blocked** | §20: `udtGeneral` (htype 50333065) `$record` executes; needs a mobile user in the company |
| Day-book/ledger JSON reads | n/a | input solved, layout open | §8 (collection input + Admin@3 identity) / §20; date-position sweep still `{}` |
| `GetJSONFromRecordset` (SQL → BUSY JSON) | — | **verified** | §14 |

Notes

- XML stays the **production write path** until a fixture-backed JSON
  save passes end-to-end (§3 decision, still current).
- The invisible-validation class ("COM call failed, no IErrorInfo") is
  consistent across `SaveMastFromJson`, `SaveVchFromJson` and
  `SaveVchSeriesGrpConfig`: BUSY raises without IErrorInfo; the fix
  path is schema-correct content, not error plumbing.
- Headless fixture blockers: mobile user + series grant (GUI one-time)
  — everything else on this table is now probe- or code-reachable.
