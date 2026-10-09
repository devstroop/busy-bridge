# Separation readiness

*Evidence file for splitting this repository into meaningful project(s).
Scope of this phase: **the bridge repo only** — the workspace siblings
(`BUSY Research/`, `BUSY Integration/`, `conversation.txt`) are external
material and were left untouched. The design of the target projects is
deliberately NOT decided here — it is the next planning step.*

*Status: READY (2026-10-09). Owner: issue-011 follow-up work.*

## 1. Self-containment (audit results)

Audited every tracked file for dependencies on the parent workspace.

| Finding | Classification | Action |
|---|---|---|
| `scripts/docs/extract.ps1` defaulted `-Source` to `..\..\..\BUSY Integration` | **functional dependency on a sibling** | ✅ fixed — `-Source` is now required and fails fast with a usage message (`f9e1ce9`); the originals are external input by design (the committed `docs/archive/` is their output) |
| `README.md`, `docs/README.md` ("BUSY integration knowledge base" titles) | descriptive prose, no path | none — rewording would erase provenance |
| `docs/archive/MANIFEST.md` ("original BUSY Integration" doc-set name) | provenance | none |
| `docs/archive/Custom Validation.md` `alt="C:\Users\Sonia\…"` | pandoc-preserved metadata from the original vendor document (different author/machine); `src=` is repo-relative | none — archive is immutable by policy |
| Absolute `C:\…` paths in tests/docs | BUSY's install location (`C:\BusyWin`) — runtime environment, not workspace coupling | none |

Result: **no load-bearing path outside the repository.** Remaining
matches are doc-set *names* (provenance), not references.

## 2. Gate status (all green, 2026-10-09)

| Gate | Status |
|---|---|
| `zig fmt --check` / `zig build` / `zig build test` (73/73) | ✅ |
| `scripts/check_layers.ps1` (234 imports / 54 files) | ✅ |
| `scripts/check_size.ps1` (0 violations; allowlist: 2 by-design) | ✅ |
| `scripts/check_tests.ps1` — **new**: asserts the exact discovered test count (73) | ✅ |
| `scripts/docs/check_links.py` (73 links) | ✅ |
| **GitHub Actions CI on master** | ✅ `success` — was **red** until `faeb7ff` fixed a real bug the discovery fix had exposed (see §4) |
| Live `run-all.ps1` (11 suites, serialized vs BUSY) | ✅ at last run (post-issue-011 merge) |

CI runs: fmt → layers → size → build → unit tests → **test-count gate** →
smoke (version/classes). No step trusts another's silence: failures are
loud by construction.

## 3. The cut line (import matrix)

Every `@import` in `src/`, aggregated by source layer → target layer
(0 ESCAPE edges = nothing climbs out of `src/`):

| from \ to | util | core | transport | root |
|---|---|---|---|---|
| **util** | 18 | 0 | 0 | 0 |
| **core** | 22 | 83 | **0** | 0 |
| **transport** | 34 | 26 | 49 | 0 |
| **root** (main.zig) | 0 | 0 | 2 | — |

Reading:
- **`core` + `util` depend on nothing above them** → they are the natural
  library boundary (the future COM-interface project): 123 internal edges,
  zero outward.
- **`transport` depends down only** (60 edges into core/util) and is
  gate-enforced (`check_layers.ps1`: core never imports transport).
- **`root` imports only transport** — the composition root.

The dependency graph already *is* two pieces: library (util+core) and
application (transport+root). Any target split — whether 2 projects
(lib + app) or finer — follows this line; gates keep it honest after the
cut (relative cross-package imports get rejected by a package-aware
`check_layers`).

## 4. What the red CI taught (fixed)

`faeb7ff`: `batch.run` resolved the registry ProgID **before** validating
entry shapes, so on CI runners (no BUSY) `NoBusyProgId` masked the
`BadArgs` the unit test promised ("validates batch entry shapes before
touching COM"). The test had never run on CI until the issue-011 discovery
fix started executing it. Now: a `validateEntry` pre-pass runs before any
registry/COM access (same refuse-before-COM pattern as `cmdQuery`).
**Lesson for the split: a green local run on a BUSY machine is not a
green CI run — the gates must run where the environment differs.**

## 5. Test distribution preview (for the future cut)

82 discovered tests, by where they'd land under a lib/app split:

| Target | Tests | Contents |
|---|---|---|
| library (util + core + shared renderers) | 65 | json/xml codec, helpers, sqlguard, constants/registry/xmlmeta, all `handlers/*`, envelope + format suites |
| application (HTTP edge) | 8 | `auth` (6), `sessions` (1), `v1` (1) |
| CLI | 0 | (none today) |

`check_tests.ps1` asserts 82 repo-wide today; after the cut it becomes
the per-package discovery gate (each package gets its own expected count
— the lesson from `b7d51d0` applied mechanically).

## 6. Open decisions (input for the next planning session)

1. **How many projects and their names** — the matrix says library vs
   application; the granularity (2 vs 3–4: CLI/server split) is the
   design call to make next. Earlier working notes: CLI/server share
   `format`/`envelope`/option-parsing → either both stay with the app,
   or those move into the library.
2. **Repo mechanics when chosen** — same-repo packages first vs direct
   repo split; `build.zig.zon` pinning (commit SHA pre-release, tags at
   issue 010) for the library consumer.
3. **Binary layout** — recommendation on record: keep the single
   `busy-bridge` binary (`serve` preserved — docs + all 11 live suites
   depend on it); split exes only at release time.
4. **License** — deferred by explicit decision (2026-10-09); revisit
   before any public release (issue 010).
5. **Workspace siblings** — stay outside the projects; whether any
   research material should be *copied into* a project is a design
   question for that project's docs, made at split time.

## 7. Loose ends

- `busy-bridge.worktrees/dev` — physical directory remains (metadata
  already deregistered; branch `dev` fully merged at `0e6faf1` and
  pushed). Blocked by an open editor file; delete the folder after
  closing it. Nothing in it is unreferenced work.
- CI deprecation notices observed (actions/checkout@v4 → Node 20,
  ubuntu-latest → 26.04 label migration Oct 2026) — informational;
  revisit when they become failures.
