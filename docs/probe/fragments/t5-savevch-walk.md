# (T5) — SaveVchFromJson full shape pinned; content wall = session/config, not schema

Bridge-map live-queue lane T5 (BUSY-003). Base `c20187d` (master with T3
recovery + T1). Live vs COMP0001 (BUSY Rel 14). **No `src/` changes** —
probe artifacts only. Related: T1×T3 cross-check resolved (a
`$collection` of udtVchSeriesGrpConfig records now reaches the
`ConfigMobileAppSeries` callee — invisible validation, not
`unsupported_arg_type`).

## Pin: the full 9-param shape (both hosts)

`SaveVchFromJson` exists on **CFixedInterface1 and COtherServices1**
(identical 9-param names: `p_VchType, p_JSONStr, p_ErrStr, p_Vchcode,
p_ChkIfMobileUser, p_UserName, p_CSUserCol, p_SavedAsCancelled,
p_ErrCode`). The shape that invokes cleanly on BOTH:

```
[{"$i2":<vchType>}, <doc BSTR>, {"$byref":"bstr"}, <I4 vchcode>,
 <bool chkMobile>, "<user BSTR>", {"$collection":[]},
 <bool savedAsCancelled>, "<errCode BSTR>"]
```

**`p_ErrCode` is a plain string byval** — the §14 SaveMastFromJson tail
lesson repeats; no prefix walk needed beyond one full-shape call (no
`PARAMNOTFOUND`/`TYPEMISMATCH` anywhere).

## Content wall (precise negative)

Every document raises the **invisible validation** ("COM call failed, no
IErrorInfo"), nothing persists (`Tran1` count stays 0 after each):

| Variant | Result |
|---|---|
| `{}` (§14 baseline) | raise |
| §14-keyed guesses (series Main/ZigVch9, DD/MM + DD-MM-YYYY dates, MasterName1) | raise |
| `{"JSON":[…]}` wrapper; fuller keys (VchNo, SalePurcAccName, ShortNar); `tmpVchSeriesCode` | raise |
| **BUSY's own native row verbatim** (`GetJSONFromRecordset` capture of a freshly posted journal; wrapper + unwrapped; `chkMobile` true/false) | raise |

Verdict: the parser's wall is **not schema-guessable from udtVchData
field names** — consistent with §18's per-user mobile/CS-series config
gate (T6's territory: the config home, or the GUI fixture). XML stays
the production write path; a parallel `post-voucher-json` op (server
spec S5) should ship only after a fixture-backed save passes.

## Method notes

- Native-row capture: `GetJSONFromRecordset` (COtherServices1,
  `(string, string)`) returns `{"JSON":[{<raw Tran1 columns>}]}` — codes
  not names (VchSeriesCode=265, not "Main").
- Zero-residue: seeded journal (code 1) deleted via `op delete-voucher`;
  `Tran1` restored to 0.

Artifacts: `tests/probe/tasks/t5-savevch-walk.ps1` (replayable seed →
battery → cleanup), `t5-savevch-probes.json` (pinned-shape + baseline
probes), fixture `iter25-savevch-walk.json`.

Changelog line for the operator: `**T5**: SaveVchFromJson 9-param shape
pinned on both hosts (ErrCode = plain string tail); content wall proven
session/config-bound — native-row verbatim still raises; XML stays
production.`
