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

## 4. Iteration 4 — regular-user pivot (2026-10-10)

Operator configuration: super user `admin` (+ correct pw), regular user
`user1` (+ correct pw); **mobile-app category deliberately unused** (BDEP
friction — decision recorded here and in the auth contract). GUI closed
before the run; the new lock pre-flight in `invoke-probes.ps1`
verified the company free first. Run: 35 probes, OK=18.

**Verified login contract booleans (regular users):**

| Primitive (host class) | admin | user1 | unknown |
|---|---|---|---|
| `CheckIfLoginDetRequired` (COtherServices1) | `true` | `true` | `true` (indistinguishable — no user enumeration) |
| `ChkIfMobileUser` (CMasterServices) | `false` | `false` | — |
| `MobileUserNameExists` (CFixedInterface1) | `false` | — | — |
| `GetCurrentUserName` (headless COM) | **`"Admin"`** — attribution identity is the configured super user | | |

**Trap reclassification:** `SelectUser` returns `null` and `AskYesNo`
returns `false` immediately headless (no UI main-loop → fail-fast, not
hang); `ShowMsg` fails `DISP_E_PARAMNOTFOUND` (arg-count guess, not a
hang). The earlier TIMEOUT verdicts were **false positives**: the 8 s
trap timeout fired inside the then-~10 s lock-wait `OpenDB`, before the
invoke ran. The genuine, iteration-spanning UI trap is exactly one:
**`CheckIfLoginDetRequiredFromDatabase`**.

**OpenDB timing explained:** cold `OpenDB` dropped from ~10 s to
~4.2 s after the operator closed BUSY cleanly — the old 10 s was
lock-wait residue from the force-killed serve. No mystery left.

**The one remaining login blocker — typed ByRef marshaling:**
`ValidUserNamePasswrdForParty` (the regular-user credential check) and
`CheckUserRightsForReports` fail `DISP_E_TYPEMISMATCH` (0x80020005) on
every shape tried. Root cause: their type-library entries declare
concrete VB6 types (`string`, `_Collection`, `bool`) whose *default*
passing is typed ByRef (`VT_BSTR|BYREF`, `VT_DISPATCH|BYREF`,
`VT_BOOL`), while the bridge's `{"$byref":…}` only produces
`VT_VARIANT|BYREF` (which works on `CFixedInterface` methods because
their params are declared `Variant`). Fix: extend the bridge `$byref`
wrapper with a type tag (e.g. `{"$byref":"", "$vt":"bstr"}`) in
`core/com/invoke` — unblocks VUP, report-rights, the `GetJSON2*`
helpers, `SaveVchFromJson`'s ByRef err params and the approval probe in
one stroke. **Until it lands the login contract is GO-but-unverifiable.**

Remaining iteration-5 items: typed-ByRef shape verification (post-fix),
`GetCollectionObj` chaining idea for `_Collection` args, `ShowMsg`
arg-count correction, `SaveVchFromJson` matrix (post-ByRef).

## 5. Iteration 5 — typed-ByRef lands; VUP proven mobile-gated (2026-10-10)

**Bridge fix shipped** (`core/com/invoke`): `$byref` markers extended
with `bstr` / `bool` / `dispatch` (VB6-style typed ByRef —
`VT_BSTR|BYREF`, `VT_BOOL|BYREF`, `VT_DISPATCH|BYREF` boxes with proper
read-back: BSTR freed, dispatch Released exactly once, failure-path
cleanup). 83/83 unit tests, all gates green.

**The login blocker moved from *our* marshaling to *BUSY's* feature
gate.** All five `ValidUserNamePasswrdForParty` probes now invoke
cleanly — and every one returns:

```
false, outs: ["<dispatch>", "Mobile App feature is not enabled in BUSY company."]
```

`ValidUserNamePasswrdForParty` is BUSY's **mobile-app login validator**
— gated behind the mobile/BDEP feature the operator deliberately does
not enable. The operator's BDEP instinct is hereby **proven by BUSY's
own error string**; VUP is out of the login path. Same pattern on
`ChkMobileUserRightsForReports` ("Mobile User don't have rights to view
this report"). `CheckUserRightsForReports` is callable but its
semantics are unconfirmed (repID=0 guess → false, empty err).

**Regular-user login candidates for iteration 6:**
1. `GetUserList` / `GetUserProfile` (`BusyExt21.COtherServices`) —
   user enumeration + profile; may expose the user-table shape.
2. Common-DB SQL: `GetRecordsetFromCompanyDB` /
   `ExecuteQueryInADOForSQL` / `ExecuteQueryInDB` (on
   `CFixedInterface`) — the `UserControl` table (archive common-tables
   list) is the likely regular-user store; password format unknown.
3. `IsCSLoginExists` / `CheckCSUserPwd` (`COtherServices`) — *probably*
   cloud-sync again; probe to exclude.

Still blocked (next iterations): `GetJSON2*`/`SaveVchFromJson`
(0x80020005 persists — remaining non-ByRef param shapes), day-book/
ledger (collection INPUT args), `ShowMsg` (arg count).

## 7. Iteration 7 — per-user report rights SEMANTICS pinned (2026-10-10)

BUSY-012's candidate primitive, **`CheckUserRightsForReports`
(`COtherServices1`) — VERIFIED** with the archived signature
(`docs/function-reference.md`): `(p_UserName, p_RepID, p_BranchCode,
p_VchSeriesGrpCode, p_masterSeriesGrpCode, p_MastName, p_ErrStr)` —
7 params, `p_ErrStr` typed-ByRef `bstr`. 42 probes (35 sweep + 7
targeted) against live COMP0001:

| Matrix | Result |
|---|---|
| admin × repID 0–15, 19, 21, 201 | **true**, empty errStr (super answered unconditionally — no row check observed) |
| user1 × repID 0–15 | **false** |
| user1 × 19 (Account Ledger), 201 (Bills Rec/Pay) | **true** — real per-report discrimination |
| admin × 99999 | invoke REFUSED `0x8002000a` (DISP_E_OVERFLOW) — `p_RepID` is VB6 Integer (max 32767); a type-range artifact, not semantic validation. In-range semantic validity otherwise unconfirmed |

Report-ID anchors from the archived function doc (`BUSY Functions.md`):
Account Ledger = 19, Account Register = 21, Bills Rec/Pay = 201 —
the repID space is **sparse**, not contiguous. The bridge's rights
sweep covers 0–15 (live) + {19, 21, 201} (documented).

Also in this iteration:
- `GetVchTypesForUserRights` (`COtherServices1`, 0 params) →
  `<dispatch>` Collection — the voucher-type rights key space,
  blocked on Collection enumeration (same gap as day-book/ledger).
- `GetRightsMsg` (`COtherServices`) → `" do not have the rights "`
  (BUSY's own fragment — useful for client-facing messages).
- `ChkUserRightsForGSTConfiguration` → `true` (0 params; context
  ambiguous headless — no per-user discrimination observed; unused).
- Common/FY DB table sweep for rights stores: `UserRights`, `Rights`,
  `RightsControl`, … — **none exist**; the archived "Database
  Structure" common tables (Tran10/Config/RepOptValue/ExternalData/
  Locks) carry no per-user rights either. BUSY's per-user rights are
  **COM-only** — `CheckUserRightsForReports` is the access path.

**Shipped on the finding** (`handlers/rights.zig`): login + `/auth/me`
now resolve normalized rights (contract §3) through
`CheckUserRightsForReports` — super user short-circuits to full;
regular users get one call per repID, fail-closed per report; any
resolution failure falls back to deny-all. Live-verified: admin
19/19 reports true; user1 `[19, 201]` true, 0–15 false — identical on
`/me`. Remaining gaps (documented, deny-by-default):
`voucher_types` (Collection enumeration) and the report
**name** ↔ repID map for `/op/report/*` enforcement (identify via a
GUI grant to user1 + re-sweep: the flipped ID is the report).

**Collection read-back landed on the same day** (`core/com/collection.zig`):
the VB6 Collection contract (`Count` + 1-based `Item`, direct
`IDispatch::Invoke(DISPATCH_PROPERTYGET)` — no IEnumVARIANT QI) is
walked into a JSON array via the new `{"$byref":"collection"}` out
marker and `--enumerate-ret` (CLI) / `?enumerate_ret=1` (HTTP `/call`)
for `VT_DISPATCH` return values; enumeration failure fails closed to
`[]`, release exactly once. Live-verified A/B:
`GetVchTypesForUserRights` → **`[9, 2, 3, 10, 11, 4, 5]`** (the
voucher-type rights key space, BUSY type codes) vs `"<dispatch>"`
without the flag; `GetUserList(true)` → **`["Admin", "User1"]`**.
The voucher-type RIGHTS stay `{}` — BUSY exposes no per-user,
per-voucher-type primitive (reports-only); the discovered key space
is recorded for the day one exists.

## 6. Iteration 6 — the login primitive FOUND (2026-10-10)

**`ValidUserPassword(p_Name, p_Password)` — the regular-user
credential validator — VERIFIED end-to-end on live BUSY.** It was in
the archived 2017 function doc all along (missed by the earlier grep
pattern `Passwrd` vs `Password`) and exists live on **`CFixedInterface`
itself** (the bridge default class — no `--prog-id` gymnastics) and
`COtherServices`. Plain 2-string in, bool out — no ByRef, no UDT, no
mobile gate.

| Fixture | Result |
|---|---|
| `("admin","<correct pw>")` | **true** |
| `("admin","<wrong pw>")` | false |
| `("user1","<correct pw>")` | **true** |
| `("user1","<wrong pw>")` | false |
| `("ghost","x")` | false — unknown user indistinguishable from wrong password (contract §4) |

The login path now has all four legs verified:
`OpenDB` → `CheckIfLoginDetRequired` (§4) → **`ValidUserPassword`** →
`GetCompConfigJSON` (§1.5). **BUSY-011 GO.**

**Also landed this iteration:**
- `query --db common` (new): routes through
  `GetRecordsetFromCompanyDB` with the same rowset walk + guard —
  opens the whole company/common DB.
- **`UserControl` table found** (common DB): rows
  `Name` ("Admin"/"User1" — stored capitalized), `RecType` (1 and 7
  per user), `C1–C4` (null), `B1–B15` (false), `I1–I4`/`L1–L4` (0),
  `FinYrs` ("01/04/2026" per-user FY pref). No password column exposed
  — BUSY keeps credentials behind `ValidUserPassword` (fine: we never
  want to touch password material anyway).
- `MSysObjects` (Jet catalog) — blocked (no_recordset);
  `Users` table doesn't exist; `UserControl` is the one.
- `GetUserList(p_IncludeSuperUser)` (BusyExt21.COtherServices) — works,
  returns a Collection (`<dispatch>`; content = collection-marshaling
  gap, not urgent for login).
- Excluded: `IsCSLoginExists` fails headless (COM, no IErrorInfo) —
  cloud-sync path, as suspected. `CheckCSUserPwd` needs a server-info
  UDT — same verdict by signature.




