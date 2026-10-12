## (T2) — invoke.zig size-gate split (prep)

- **T2**: split the JSON args -> VARIANT fill/read-back machinery out of `src/core/com/invoke.zig` (was 400/400 — pinned at the size gate, blocking every future edit) into a new SAME-LAYER module `src/core/com/invoke_args.zig`; `invoke.zig` now carries only `invoke`/`invokeEx` + `InvokeOpts` (143 lines). Pure move: public surface, error strings and behavior unchanged (replay suite byte-identical).

### What moved where

Everything moved verbatim (identifier prefixes aside) into `invoke_args.zig`, wrapped in a `Slots` struct that owns the 12 per-arg slot arrays:

| Moved out of `invokeEx` | New home (`src/core/com/invoke_args.zig`) |
|---|---|
| 12 box-array allocations + the init loop (storage, byref_slots, is_byref, byref_kind, f8/i4/i8/bstr/bool/disp boxes, inboxes, recboxes) | `Slots.init` / `Slots.deinit` (OOM-safe via internal errdefer) |
| The marker-aware fill loop: `$date` -> VT_DATE, the `marshal.fillInputMarker` call-site block ($i2/$collection/$record), the `$byref` typed-box switch, plain `variantFromValue`, omitted-param `VT_ERROR`/`DISP_E_PARAMNOTFOUND` | `Slots.fill` |
| rgvarg reversal | `Slots.reversed` |
| Failed-Invoke box release (callee-written bstr/disp/inbox/recbox) | `Slots.releaseCalleeWrites` |
| Typed/Variant out-param read-back -> JSON `outs` (incl. bstr free, dispatch `"<dispatch>"`, collection enumeration) | `Slots.readBack` |
| `freeInbox` / `freeRecBox` / `clearStorageVar` helpers | private fns in `invoke_args.zig` |

The fill-abort watermark semantics are preserved: `invokeEx`'s `errdefer slots.freeFilled(self)` mirrors the old `errdefer for (0..filled)` exactly (declared after `defer slots.deinit` so contents are VariantClear'd/freed before the arrays are freed).

Kept in `invoke.zig`: `GetIDsOfNames`, `DISPPARAMS` + `Invoke`, error surfacing (`loadErrorInfo` / `setErr` strings verbatim), `enumerate_ret`/`retain_ret` return handling, `InvokeOpts`, and all re-exports.

**No other source file was touched**: `marshal.zig`/`recordinfo.zig`/`udtdesc.zig`/`markers.zig` unchanged (the `marshal.fillInputMarker` call site merely relocated); `session.zig`, `recordset.zig`, `collection.zig` keep importing `invoke.zig` as before. `src/transport/format.zig` has no aggregation refs to invoke (grep-verified).

### Line counts (before -> after)

| File | Before | After |
|---|---|---|
| `src/core/com/invoke.zig` | 400 | **143** (accept: ≤330) |
| `src/core/com/invoke_args.zig` | — | **336** (new; ≤400 limit, warn band only) |

### Public-surface + error-string check

- Public surface unchanged: `invoke`, `invokeEx`, `CallResult`, `InvokeOpts`, and the marker re-exports `ByrefKind` / `byrefKindFromMarker` (still re-exported from `markers.zig` via `invoke.zig`) plus `variantFromValue` / `valueFromVariant` (via `marshal.zig`) — `src/lib.zig` needs no edit; its `hasDecl` surface tests pass inside the 148.
- Error strings: setErr/error-set inventory diff between HEAD `invoke.zig` and the new `invoke.zig` + `invoke_args.zig` is EMPTY. The two relocated strings (`invalid $date '...' (YYYY-MM-DD / DD-MM-YYYY)` and `unknown $byref marker '...' (use "", f8, i4, cy, i8, bstr, bool, dispatch)`) live verbatim in `invoke_args.zig`; `GetIDsOfNames('...') -> 0x...` and `Invoke('...') failed 0x...` stayed in `invoke.zig`.
- Test count unchanged (148) — no tests added/removed, `scripts/check_tests.ps1` `$Expected` untouched. No LIVE COM used (unit + replay only, per task).

### Gates (run from the worktree root, 2026-10-12)

1. `zig fmt src` + `zig fmt --check build.zig src` — exit 0 (no files rewritten)
2. `zig build` — exit 0
3. `zig build test` — exit 0
4. `scripts\check_tests.ps1` — `check_tests: 148/148 discovered tests passed` / `check_tests OK`
5. `scripts\check_layers.ps1` — `layer check OK: 369 imports across 75 files`
6. `scripts\check_size.ps1` — `size gate OK` (invoke_args.zig listed in the 300-400 warn band)
7. `scripts\check_replay.ps1` — `check_replay: 29/29 replay tests passed` / `check_replay OK`

### Follow-ups (operator)

- None blocking. When `invoke_args.zig` eventually approaches 400, its natural next seam is `readBack` (vs `fill`) — but336 leaves ample room.
- Work is UNCOMMITTED on `feat/t2-invoke-split` (base 7222024) per the task contract; integrate with the T1/T3/T11 fragments as usual.
