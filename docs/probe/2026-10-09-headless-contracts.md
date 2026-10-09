# P0 headless-contract probe report — 2026-10-09

Sprint-1 evidence for the portable-client backlog (proposed BUSY-001…004).
Harness: [`tests/probe/`](../../tests/probe/) · raw runs:
`tests/probe/results/20261009-*` (30 probes, iterations 1–3).
Environment: BUSY Rel 14, `COMP0001` (DEMO, FY 2026-27), bridge
`0.1.0-6-gd637ea7`, no BUSY GUI / no `serve` running.

## 1. Headline findings

1. **The mobile/auth/JSON primitives are NOT on `CFixedInterface`.**
   Definitive host-class map (per-class surface dumps + live probes):

   | Members | Host class |
   |---|---|
   | `CheckIfLoginDetRequired(FromDatabase)`, `GetAccDayBookJSON`, `GetAccLedgerJSON`, `GetJSON2VchData`, `GetJSON2AccMast`, `SaveVchFromJson`, `SaveMastFromJson`, `ChkMobileUserRightsForReports` | `Busy2L21.COtherServices1` (saves dual-homed on `CFixedInterface1`) |
   | `ValidMobileUserPassword`, `ChkIfMobileUser`, `GetMobileUserRightsJSONstr` | `Busy2L21.CMasterServices` |
   | `MobileUserNameExists`, `GetSessionID`, `GetCompConfigJSON`, `GetAllFinYearsOfSpecificCompCode`, `SelectUser` | `Busy2L21.CFixedInterface1` |
   | `ChkMobileUserExist`, `GetApprovalStatusFromBusy` | `BusyExt21.COtherServices` |
   | `GetCompList` | `Busy2L21.CFixedInterface` |

   The bridge `call`/`serve` default class is `CFixedInterface` — every
   future auth/config facade work must target these classes explicitly
   (`--prog-id` / per-handler class selection).

2. **Login contract (verified live, company open required):**
   - `CheckIfLoginDetRequired("Busy")` → `false` (admin needs no login);
     without an open company: `invoke_failed (no IErrorInfo)` — the
     primitive **requires a company session**.
   - `ValidMobileUserPassword("Busy","Busy"|"wrong")` → `false` both ways
     (Busy is not a mobile user; DEMO has **no mobile users configured**:
     `ChkIfMobileUser=false`, `MobileUserNameExists=false`).
   - ⚠️ **`CheckIfLoginDetRequiredFromDatabase` is a UI trap**: hangs
     (modal GUI) for both valid and invalid credentials — killed at 8–25 s
     every run. **Never callable headless.** Join `SelectUser`, `AskYesNo`,
     `ShowMsg` on the blocklist.

3. **Rights schema probe is fixture-blocked, not contract-blocked**: with
   no mobile user in the company there is nothing to ask rights *for*, and
   `GetMobileUserRightsJSONstr` takes a **UDT** (`udtMobileUser`) our
   Variant marshaling cannot express (0x80020005 DISP_E_TYPEMISMATCH).
   Next session: create one mobile user + rights in the GUI, then re-probe
   (and/or extend the bridge with VT_RECORD support).

4. **JSON-native saves: NO-GO for now (hybrid plan holds).**
   `SaveVchFromJson`/`SaveMastFromJson`/`GetJSON2*` accept argument
   *counts* but fail type-checking (0x80020005 → all-byref shape:
   0x8002000E DISP_E_PARAMNOTFOUND). The exact per-parameter Variant
   shape is unresolved — iterative one-param-at-a-time probing continues
   (BUSY-003); **XML path stays the production write path** until a
   fixture-backed save passes.

5. **Session/config primitives verified:**
   - `GetSessionID()` → `1` (int) ✓ · `GetCurrentUserName` → `Busy` ✓ ·
     `GetCurrentUserBranchCode` ✓
   - `GetCompList("C:\BusyWin\DATA\")` → works (1-arg legacy form; the
     0-arg live type-lib signature fails `DISP_E_BADPARAMCOUNT`) —
     returns a **Collection** (`<dispatch>` in the bridge).
   - `GetAllFinYearsOfSpecificCompCode("COMP0001")` → Collection too.
   - **`GetCompConfigJSON(skipBranch, 0, false)` → 16 KB JSON string**:
     `CompName/PrintName/CINNo/Country/State/BegFY/CurFY/BooksStart/
     addresses/tel/email/industry…` (`BegFY=CurFY=04/01/2026`) — the
     picker/FY/config payload for `/v1/config`, JSON-native.

6. **Collection/array arguments are a bridge marshaling gap.**
   `GetAccDayBookJSON`/`GetAccLedgerJSON` need an input Collection
   (`p_ICol`); JSON-array args fail pre-invoke
   (`unsupported_arg_type` via the OpenDB-fallback path). Day-book/ledger
   via these APIs are **blocked on the bridge growing collection
   creation/marshaling** (or an alternative entrypoint).

7. **Timing:** fresh-process `OpenDB` ≈ **10 s** (every `--comp` child),
   vs <1 s when `serve` is warm. Unexplained; investigate stale-lock vs
   cold-open cost (BUSY-004 note). Login/no-comp probes ≈ 0.5 s.

8. **Harness self-findings:** the bridge corrupts output when stdout is a
   **file** redirect (every write lands at file position 0 — `{` eaten by
   the trailing newline); pipes/consoles unaffected, so no live test ever
   saw it. Filed as its own bug; the harness captures via pipes.

## 2. Status matrix (iteration 3, 30 probes)

| Group | OK | REFUSED | TIMEOUT |
|---|---|---|---|
| login (6) | 2* | 2 (company-gated pre-comp) | 2 (`CheckIfLoginDetRequiredFromDatabase` = UI trap) |
| rights (5) | 2 | 3 (UDT shape / no mobile users) | — |
| session (6) | 6 | — | — |
| reads (3) | 1 (config JSON) | 2 (collection args) | — |
| writes (7) | 3 (XML control + duplicate + delete) | 4 (JSON shape) | — |
| ui-traps (3) | — | — | 3 (expected; killed) |

\* The two login "no IErrorInfo" refusals were re-probed manually **with
company open** and both returned clean booleans (§1.2) — the manifest now
runs them with `useComp: true`.

## 3. Go / no-go for the next sprint

| Item | Decision |
|---|---|
| `/auth` login via `ValidMobileUserPassword` + `CheckIfLoginDetRequired` (company open; `CMasterServices`/`COtherServices1`) | **GO** — implement BUSY-010/011 |
| `CheckIfLoginDetRequiredFromDatabase` | **NO-GO** headless (UI trap) |
| JSON-save write path (BUSY-020) | **NO-GO pending shape resolution**; XML stays |
| Day book/ledger JSON endpoints (BUSY-041) | **blocked** on collection marshaling |
| Rights normalization (`/auth/me`) | **blocked** on a mobile-user fixture in the company + UDT marshaling |
| Company/FY picker (`GetCompList` + fin-years + `GetCompConfigJSON`) | **GO** — config JSON directly usable; collections need bridge enumeration support |

## 4. Next probes (iteration 4, on the BUSY machine)

1. Create a mobile user + rights + a master range in the BUSY GUI; re-run
   the rights group; capture the real `GetMobileUserRightsJSONstr` shape
   (VT_RECORD work or a JSON-accepting twin).
2. One-param-at-a-time `SaveVchFromJson` matrix (bool vs int, byref
   inner types, `p_ErrCode` as int-byref).
3. Collection enumeration for the bridge (walk `_Collection` COM objects)
   → unblocks `GetCompList`/fin-years/day-book/ledger probes.
4. Investigate the 10 s cold `OpenDB`.

