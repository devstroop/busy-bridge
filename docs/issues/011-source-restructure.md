# 011 · Source restructure: split oversized modules + structure gates

**Labels:** `refactor` `chore` · **Effort:** M · **Status:** in progress (Phase 0) · **Milestone:** H3

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
- [ ] **Phase 2 — common**: → `common/value.zig` (~150, put/objFrom/merge/dup/
      stringify) + `common/sql.zig` (~120, resolveNames/codeByName) +
      `common/dates.zig` (~60) + `common/cursor.zig` (~50). One commit —
      the barrel must stay complete.
- [ ] **Phase 3 — format**: → `format/wire.zig` (negotiation) +
      `format/call.zig` (enrichCallResult/xmlifyArgs + tests) +
      `format/xml_envelopes.zig` (errorXml/info/constants/surface/rows/callXml).
      ⚠️ `format.zig`'s final `test { }` block is the **`zig build test`
      discovery root** — it stays; new files get `_ = @import` entries there.
      Compare test count before/after.
- [ ] **Phase 4 — commands**: → `commands/raw.zig` (classes/surface/query/
      call) + `commands/ops.zig` (cmdOp/report/write); `run()` dispatcher
      stays, move `cmd*` bodies verbatim.
- [ ] **Phase 5 — http (last, highest risk)**: `http/`shared.zig` (Route,
      errPayload, qparam, opOk/opErr) + `http/routes_meta.zig` +
      `http/routes_raw.zig` + `http/routes_ops.zig`. `route()` = thin
      ordered dispatcher (company-ensure → v1 → meta → raw → ops → 404);
      each module returns `!?Route`, `null` = fall through (proven `v1.zig`
      pattern). `serve()`/`handleConn`/auth gate do not move.
- [ ] **Phase 6 — docs + wrap-up**: architecture note (folder map, barrel
      convention, "how to add a route/op"), tick phases, final full gates +
      live run-all; merge `dev → master` **only after** coordinating with
      the session that owns `master`.

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
