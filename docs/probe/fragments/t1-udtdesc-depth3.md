# (T1) — `ConfigMobileAppSeries` param decoded: it is a ByRef-VARIANT (no static UDT exists)

Bridge-map lane T1. **Files**: `udtdesc.zig` (bounded indirection walk) +
`surface.zig` (ELEMDESC pointer selection). LIVE: verify-only (surface
dumps + runtime call probes). Base `f031e18` (pre-T3-recovery master).

## The decode (definitive)

`ConfigMobileAppSeries` (CFixedInterface1, 1 param) — the last headless
lead on the JSON-save gate — **has no typelib UDT**. With the corrected
ELEMDESC pointer (FUNCDESC+8, heap-pointer-shaped; the old off52
heuristic landed on lucky heap neighbors) and the bounded walk,
`BUSY_UDT_DEBUG` shows the chain: `hop0 vt=26 (VT_PTR) → hop1 vt=12
(VT_VARIANT)`. The param is `ByRef Variant` — the GUI passes a runtime
record/collection inside the Variant; the TYPELIB cannot describe it, so
**the absence of an `udt` block is now provably correct, not a decode
gap**. (`SaveVchSeriesGrpConfigForMultipleSeriesCreation(Variant, Variant)`
is the same family.)

## Code changes

- `describeParamUdt`: single-level `26→29` resolve → bounded walk
  (max 4 indirections, self-pointer cycle guard); any other vt ends it
  (null = not a statically-describable UDT param — unchanged contract).
- `surface` UDT-describe: cand pointer from FUNCDESC+8 (empirically the
  `lprgelemdescParam` slot on this runtime; +4 reads 0) instead of the
  off52-neighborhood heuristic.
- Regressions (live, byte-level names+htypes): `InitUdtVSGrpConfig` →
  udtVchSeriesGrpConfig/50333725 ✓ · `GetMobileUserRightsJSONstr` →
  udtGeneral/50333065 ✓ · `CopyVchData` → udtVchData/50332129 ✓.

## Runtime probes (what the Variant accepts; COMP0001)

| Payload | Result |
|---|---|
| `$collection` scalars ([1290]) | callee runs (invisible validation) |
| `$collection` strings (["ZigVch9"]) | callee runs |
| direct `$record` udtVchSeriesGrpConfig | callee runs |
| `$collection` of records | `unsupported_arg_type` **on pre-T3 master** — retest after the T3 recovery PR (#56) lands |

All non-error outcomes are the §22-family invisible validation — the
content/config wall (T6 territory), never a shape wall.

## Fixture

`tests/probe/fixtures/t1-config-mobile-app-udt.json` — the definitive
answer + runtime matrix.

Changelog line for the operator: `**T1**: ConfigMobileAppSeries param
proved ByRef-VARIANT (VT_PTR→VT_VARIANT) — udt absence is correct;
describeParamUdt bounded walk + FUNCDESC+8 pointer fix (regression-free).`
