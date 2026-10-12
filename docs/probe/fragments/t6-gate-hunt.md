# (T6) — series-gate config-home hunt: definitive negative + the GUI-only wall

Bridge-map live-queue lane T6 (BUSY-003/002). Base `223ec7b`. Live vs
COMP0001 (BUSY Rel 14). **No `src/` changes.** Carries T3's
records-in-collections + T1's decode as levers.

## Sweeps and batteries (all negative, precisely)

1. **40-table existence sweep** (20 candidates × FY + common: TRAN13–16,
   MASTER22–30, MobileUsers, MobileAppSeries, VchSeriesGrpConfig,
   SeriesGrpConfig, CSUserRights, UserControl2, UserRights, VchSeriesRights,
   MUser, VchSeriesGrp, GrpConfig…): **zero hits**. The config home is not
   among guessable names (consistent with it18).
2. **Qry-leak technique (new, works)**: BUSY's own SQL-string getters leak
   schema — `MastCode2NameQry` → `Help1`; `GenMAI_BD_VOIQry` →
   `VchOtherInfo`, `MasterAddressInfo`, `BillingDet` (added to the schema
   map; none series/mobile-config related). `GetVoucherSeriesGrpQry` remains
   the only series-grp SQL: TRAN10 (`MASTERCODE1`/`MASTERCODE2`/`RECTYPE=7`).
3. **Writers**: `ConfigMobileAppSeries` raises invisible validation on EVERY
   payload tried (full udtVchSeriesGrpConfig record incl. nested collections;
   scalar/string collections; keyed pairs → `unsupported_arg_type`);
   `SaveVoucherSeriesGrp` (collection) → ok:true result:null. Gates
   (`IfVchSeriesBelongs2RestrictedUser(1290)=true`,
   `UserHasAccessToMobileApp("Admin")=false`) and TRAN10 (0 rows) immobile
   after every attempt.
4. **Cur-user datum**: `GetVchSeriesGrpCodeForCurUser` → `0` (the headless
   session user has no series-group).

## The definitive wall: mobile-user creation is GUI-only

Full `Mobile*` method census across every class surface dump:

- Existence/state: `MobileUserNameExists`, `ChkIfMobileUser`,
  `ChkMobileUserExist`, `ValidMobileUserPassword`, `IsMasterTaggedWithMobileUser`
- Mutation: **`ModifyMobileUser()` — zero params** (a GUI-dialog launcher,
  not a data API; treat as UI trap), `SaveMobileAppConfig(udtCompConfig, string)`
  (company-level config, not user creation)
- Readers: `GetMobileUserRightsJSONstr(udtGeneral)`,
  `GetMasterRightsColForMobileUser(udtGeneral, short)`,
  `ChkMobileUserRightsForReports(...)`

**There is no `SaveMobileUser`/`CreateMobileUser` anywhere.** Combined with
"T5: every JSON save denies because no mobile/CS config exists", the chain
closes: the §14 option (a) **operator GUI fixture (create one mobile user +
series grant) is the only unlock** for BUSY-002's schema capture AND the
JSON-save gate. Headless writers cannot conjure the user the gate keys on.

## Next actions (ordered)

1. **Operator**: one-time GUI fixture in COMP0001 (mobile user e.g. `user1`
   with password + grant series `ZigVch9`/`Main` via the mobile-app config
   screens).
2. Re-run: `tests/probe/tasks/t5-savevch-walk.ps1` (does a save finally
   persist?) · `rights-udt-shape` probe (capture the rights JSON schema —
   BUSY-002 acceptance) · gate baselines (restricted/mobile should flip).
3. If saves persist: XML-vs-JSON capability record flips (server spec S5
   becomes actionable); if the gate still denies with a real mobile user,
   the config home question reopens with real data to diff.

Fixture: `tests/probe/fixtures/iter26-gate-hunt.json`.
Repeatable probes: `t6-cur-user-grp` (baseline datum), `t6-mobile-exists`
(fixture-blocked marker).

Changelog line for the operator: `**T6**: gate-config hunt closed —
40-table sweep empty, Qry-leak schema harvesting documented (Help1/
VchOtherInfo/MasterAddressInfo/BillingDet), and the Mobile* census proves
user creation is GUI-only; the operator fixture is the definitive unlock.`
