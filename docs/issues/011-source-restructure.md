# 011 · Source restructure: split oversized modules + structure gates

**Labels:** `refactor` `chore` · **Effort:** M · **Status:** closed (2026-10-09) · **Milestone:** H3

## Problem

Six source files exceed 400 physical lines (up to 754), each mixing two or
more responsibilities. Large files make the future repo split (COM lib vs
server, see Decision records) an archaeology project instead of a `git mv`.

| File | Physical lines | Mixed responsibilities |
|---|---|---|
| `src/transport/http.zig` | 754 | conn I/O + auth gate + serve bootstrap + 425-line `route()` if-chain |
| `src/transport/commands.zig` | 683 | raw CLI (classes/surface/query/call) + `op` CLI (read/write/report) |
| `src/core/ops/vouchers.zig` | 630 | reads (list/get) + writes (doc builders/post/delete) |
| `src/transport/format.zig` | 518 | negotiation + call-result enrichment + XML envelopes + **test-aggregation root** |
| `src/core/ops/masters.zig` | 537 | reads (list/get) + writes (doc build/create/update/delete) |
| `src/core/ops/common.zig` | 406 | JSON value helpers + dates + SQL name-resolution + cursor codec |

## Invariants (all phases)

1. **Compatibility** — `foo.zig` coexists with `foo/`; barrels re-export every
   public name so `@import` paths and call sites (`masters.list`, `common.put`…)
   never change mid-restructure.
2. **Behavior** — no intentional behavior changes mixed into structural
   commits; the 11 live suites are the wire contract.
3. **Verification** — per commit: `zig fmt --check` · `zig build` ·
   `zig build test` · `check_layers.ps1` · `check_size.ps1` ·
   `check_links.py`; **live `run-all.ps1` before each phase merges**,
   serialized (port 9820 + one BUSY session per company — announce first).

## Size policy (enforced from Phase 1)

- `scripts/check_size.ps1` — **fail > 400** physical lines per `src/**/*.zig`,
  warn > 300; `tests/**/*.ps1` fail > 200.
- **Default = enforce** (exit 1); `-ReportOnly` = preview, always exit 0.
- Allowlist (`$exempt` in the script) is narrow, every entry carries a WHY:
  - `[transitional]` — this issue's phases; **the entry is deleted in the same
    commit that splits the file** (the list only shrinks);
  - `[by design]` — permanent (currently: `util/xml/parse.zig`,
    `core/ops/reports.zig`).

## Phases (one phase = one commit = gates green)

- [x] **Phase 0 — gates + records (Commit A)**: `check_size.ps1` (both modes
      verified at baseline: 6 exempt, 0 violations, 50 files), this issue,
      README workflow update, roadmap decision-record amendments.
      *No source moves. Requires review before Phase 1.*
- [x] **Phase 1a — masters**: `masters.zig` → barrel (98: kinds, typeCode,
      ListOpts, requireStr, re-exports) + `masters/read.zig` (208: list, get)
      + `masters/write.zig` (278: fieldsToDoc/docToXml/saveMaster/create/
      update/delete + tests). Dead `groupTypeCode` (zero references) removed.
      Test count unchanged: 43/43.
- [x] **Phase 1b — vouchers**: `vouchers.zig` → barrel (49: ListOpts,
      re-exports) + `vouchers/read.zig` (245: list, get) +
      `vouchers/write.zig` (379: buildSale/Journal, post, saveVch,
      postResult, delete + both doc-builder tests). Test count green.
      *Note: landed together with the test-discovery fix (b7d51d0) —
      26 tests had never run before that commit.*
- [x] **Phase 2 — common**: barrel (46) + `common/value.zig` (215:
      put/objFrom/merge/dup/stringify/containsCi/childStr + 4 tests) +
      `common/sql.zig` (110: resolveNames/codeByName/classProgId + 1
      test) + `common/dates.zig` (69 + 2 tests) + `common/cursor.zig`
      (48 + 1 test). One commit — the barrel stayed complete. Tests: 73.
- [x] **Phase 3 — format**: barrel (75: Format/negotiation re-exports +
      **test-aggregation root**, extended with the new submodules) +
      `format/wire.zig` (56: enum + Accept/--out negotiation + negotiation
      test) + `format/call.zig` (95: enrich/xmlify/passthrough + 2 tests) +
      `format/xml_envelopes.zig` (365: error/constants/info/health/classes/
      surface/rowset/call builders + 3 tests). Test count unchanged: 73
      (6 moved, verified by namespaced name).
- [x] **Phase 4 — commands**: dispatcher (84: run/fail/failText/
      versionString — fail helpers now `pub`, children import them back via
      a lazy cycle proven in phase 1) + `commands/raw.zig` (276:
      classes/surface/query/call) + `commands/ops.zig` (370: cmdOp/report/
      write). `run()` switch unchanged. Tests: 73.
- [x] **Phase 5 — http (last, highest risk)**: dispatcher (296: handleConn,
      serve, auth gate — never moved — and the ordered `route()` =
      company-ensure → meta → v1 → ops → raw → 404) + `http/shared.zig`
      (114: ConnCtx/Route + errPayload/ctOf/qparam/badReq/denyQuery/
      opOk/opErr) + `http/routes_meta.zig` (83) + `http/routes_ops.zig`
      (210) + `http/routes_raw.zig` (177). Each group returns `!?Route`,
      null = fall through (proven v1.zig pattern). `opOk` now returns
      `!?Route` so groups return it directly. Tests: 73. Size-gate
      transitional list now EMPTY (only by-design entries remain).
- [x] **Phase 6 — docs + wrap-up**: `docs/architecture.md` (folder map,
      barrel convention, test-discovery rules with name-level verification,
      route dispatch contract, how-to-extend, gate table); README links it
      + fixed stale "all three suites" → 11; **size gate wired into CI**
      (`ci.yml` step after the layer check). Final gates + live run green.
- [x] **Merge `dev → master`**: done 2026-10-09 — fast-forward `51a99ec →
      0e6faf1` (master never moved during the restructure), pushed; post-
      merge serialized live run on master: all 11 suites green.

## Decision records

1. **File-size policy** — 400-line cap on `src/**/*.zig` (200 on live-test
   `.ps1`); exceeding it requires a split or a documented allowlist entry.
   Enforced by `scripts/check_size.ps1` in CI/structure gates.
2. **Repo split (COM interface lib vs server)** — **deferred, not scheduled.**
   The `core/` vs `transport/` layer line already *is* the future cut
   (`check_layers.ps1` enforces it). Revisit only when a trigger fires:
   - a second **in-process** consumer of `core` (not via HTTP), or
   - independent release cadence needed (review at issue 010).
   **Precondition:** this restructure lands (barrels = module boundaries),
   making the split a `git mv` + `build.zig` edit. Same-repo decision stands
   until then (see roadmap, architectural stance).

## Coordination rules

- All work in the **`dev` worktree** (`busy-bridge.worktrees/dev`); the main
  worktree belongs to the other session (`master`).
- `git merge origin/master` into `dev` before each phase starts — never
  restructure on a stale base.
- Live suites serialized: announce before `run-all.ps1`; BUSY allows one
  session per company and `serve` binds fixed port 9820.
