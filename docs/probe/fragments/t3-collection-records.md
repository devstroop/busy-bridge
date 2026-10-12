## (T3) — `$collection` items marshal `{"$record"}` UDT rows (records inside collections)

- **T3**: `$collection` input items now support `{"$record":{htype,fields}}` —
  a Collection can hold VT_RECORD UDT rows (RecBox chain ownership; unlocks
  `SaveVchSeriesGrpConfigForMultipleSeriesCreation` and richer day-book
  input items). Tests 148 → 152.

Scope: `feat/t3-collection-records` (base `7222024` = merged PR #50) —
`$collection`-inside-`$record` (iter22) was already in the base; this task
generalizes the *items* of a collection from scalars to records.

### What changed

- **`src/core/com/collitem.zig` (new, same layer)** — the T3 safety
  hinge: a pure `classify` planner (`scalar` / `date` / `record` /
  `keyed_*`) decides how each collection item marshals, and
  `recordItemVariant` builds `{"$record":{htype,fields}}` items via the
  proven `recordFromHreftype` path, **unwrapped to a byval VT_RECORD**
  (the shape `Collection.Add` receives; byref boxing is a byval-param
  convention, not an item convention). 4 pure tests (no COM).
- **`src/core/com/marshal.zig`** — `RecBox` gains `next`; `freeRecChain`
  /`chainAppend` manage record-item chains. `fillInputMarker`: the
  `$collection` branch threads the arg's recbox slot into
  `inputCollection`, the `$record` branch attaches `RecordInst.coll_recs`
  (nested record items of embedded collection fields) via `next`.
  `inputCollection` classifies items through `collitem.classify`;
  record items are added as byval VT_RECORD and are **never
  VariantClear'd** (RecordClear would call through the trap-thunked
  IRecordInfo vtable); the scalar/date/keyed paths are unchanged.
- **`src/core/com/recordinfo.zig`** — `RecordInst` gains `coll_recs`;
  `recordFromUdtTi` chains record-item RecBoxes built inside embedded
  `$collection` VT_DISPATCH fields (errdefer-freed on failure, handed
  to the parent record's box on success).
- **`src/core/com/invoke.zig`** — `freeRecBox` walks the chain (line
  count 400 → 399; no other change).

### Ownership / lifetime model

One `recboxes[i]` slot owns a **chain** of RecBoxes per arg (head = the
direct `$record` arg box or the first collection-item box; `next` links
the rest). Nested `$collection`-in-`$record`-in-`$collection` works to
arbitrary depth: each record build attaches its nested chain via
`chainAppend`. Every buffer frees exactly once, **after** the target
invoke (post-invoke loop / errdefer loop in `invokeEx`), so the buffers
stay alive while BUSY's Collection and the callee may read them.

### Class-map correction

`SaveVchSeriesGrpConfigForMultipleSeriesCreation(Variant, Variant)`
(`p_CodeCol`, `p_SeriesName`) is on **`Busy2L21.CFixedInterface1`** per
the per-class surface dumps (`BUSY Research/surface/Busy2L21_CFixedInterface1.txt:470`,
`docs/function-reference.md`) — not `COtherServices` (its sibling
`SaveVchSeriesGrpConfig` lives there). The probe manifest targets
CFixedInterface1.

### Gates (all green, worktree-local)

- `zig fmt src` + `zig fmt --check build.zig src` → exit 0
- `zig build` → exit 0
- `zig build test` → exit 0; `scripts/check_tests.ps1` → **152/152**
  (`$Expected` 148 → 152 + history line; the 4 collitem tests are
  discovered in the main suite only)
- `scripts/check_layers.ps1` → OK (367 imports / 75 files)
- `scripts/check_size.ps1` → OK (marshal 353, recordinfo 311, collitem
  195, invoke 399 — all ≤ 400)

### Live verification (operator; NOT run in this phase)

```powershell
# from the worktree root (bbwt\t3), after zig build
powershell -NoProfile -ExecutionPolicy Bypass -File tests\probe\invoke-probes.ps1 -Manifest tests\probe\tasks\t3-collection-records-probes.json -SkipLockCheck
```

Acceptance: `t3-multiseries-record-rows` (or the `-str-name` variant)
must reach the callee — envelope `ok:true`, **any** business result;
`unsupported_arg_type`/`BadArgs` = regression. `t3-control-scalar-collection-regression`
(iter22 `series-grp-write-full` shape) must stay `ok:true`;
`t3-multiseries-scalar-codes-control` discriminates whether `p_CodeCol`
wants plain codes rather than UDT rows. `-SkipLockCheck` is expected
(the long-running Busy21 COM server holds COMP0001 locks; direct comp
calls attach fine — iter20 precedent). Shared fixtures
(`comp-list-enumerated` / `fin-years-enumerated`) are untouched by this
diff.

### Risks / open points

- **Add-time copy**: `Collection.Add` copies the item variant on the
  BUSY side (VB6 runtime `VariantCopy` → `RecordCopy` via the record's
  `pRecInfo`). The bridge never clears the item itself, but if the
  runtime copy misbehaves headless the probe will show it as a callee
  failure — not a marshaling (`unsupported_arg_type`) failure.
- **p_SeriesName shape** is guessed (1-item Collection vs plain BSTR) —
  the manifest carries both variants plus a scalar-code control.
- `marshal.zig` now carries a size WARN (353 > 300); the record-item
  build logic deliberately lives in `collitem.zig` to stay clear of the
  400 gate.

### Acceptance re-run + harness depth bug (operator verification)

- The manifest's first run failed with `bad_args: "$collection field 'VchSeriesCodeCol' must be a JSON array"` — **not a bridge bug**: `tests/probe/invoke-probes.ps1` serialized args with `ConvertTo-Json -Depth 6`, truncating the nested `$collection`-in-`$record`-in-`$collection` marker into garbage. Bumped to `-Depth 12` (comment added).
- After the fix all three 2-param probes reach the callee: `COM call failed (no IErrorInfo)` — the invisible-validation business wall of the §22 family (same result as a hand-built `--args-b64` direct call), **not** `unsupported_arg_type`/`bad_args`. Manifest expects set to `any` (business results vary).
- Scalar-collection regression probe: OK. Direct `$record` iter22 shapes (InitUdtVSGrpConfig / SaveVchSeriesGrpConfig): ok:true — no regression.
- Net: records-in-collections marshal end-to-end; unlocking real persistence remains a content/config question (T6/S4 territory), not a marshaling one.
