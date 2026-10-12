# Changelog

All notable changes to `busy-bridge` are recorded here, Keep-a-Changelog
shape. Versions are git tags (`vX.Y.Z`); the binary reports its own
version via `busy-bridge version` (tag-derived since 0.1.0).

## [Unreleased]

- **Docs regression (2026-10-12)**: documentation re-verified against the
  shipped surface — `scripts/docs/check_links.py` 77 local links / 0
  broken; `docs/operations.md` and `docs/function-reference.md`
  regenerate byte-identically (925 ProgIDs; 4,496 members / 16 core
  classes). Drift fixed: README (current `handlers` architecture tree +
  layer rules, `/auth` routes + opt-in session tier, day-book/ledger in
  the report rows, test gate 146, 13 live suites), `architecture.md`
  (dispatch order now session gate + `/auth`, 146 tests, `daybook.zig`
  and `masters/fields.zig` in the folder map), `roadmap.md` (13 suites,
  146/146), `docs/README.md` (backlog 001–012), `separation-readiness.md`
  (gate snapshot refreshed).
- **Collection read-back recurses nested Collections** (BUSY-004,
  report §21): `GetCompList`'s items are themselves VB6 Collections —
  `toJson` now walks VT_DISPATCH `Item()` results that satisfy the
  Collection contract (bounded `max_depth = 3`, cycle-safe, fail-soft
  to the `"<dispatch>"` string). The company picker payload is decoded
  live: `[["DEMO","COMP0001","01/04/2026",1,"","","<guid>","","",""],
  …]` per company (name, code, FY start DD/MM/YYYY, flag, guid).
  Recursion needed an explicit `WalkError` set (mutual inferred-error
  dependency). Discovery script `tests/probe/comp-item-shape.ps1`
  (x86 late-binding); harness run `20261012-023201` 3/3 OK; CLI help
  + probe manifest notes updated.

- **P0 probe iteration 20 (BUSY-002/003/004 sweep)**: `_Collection` return
  enumeration **live-proven** (`fin-years-enumerated` → `[2026]`;
  `comp-list-enumerated` → Count=2, items = nested dispatch = next deep-walk
  step); `GetMobileUserRightsJSONstr` executes with a `udtGeneral`
  (htype 50333065) `$record` — rights schema now fixture-blocked only;
  `udtVchSeriesGrpConfig` (htype 50333725) decoded and the
  `InitUdtVSGrpConfig`/`SaveVchSeriesGrpConfig` writers (on
  `COtherServices`) callable — `$collection`-inside-`$record` passes the
  bridge, content validation remains; `SaveVchFromJson` head pinned
  `[I2, doc, byref-err]` by prefix walk; cold-OpenDB re-measured
  4.1–7.7 s. New `enumerateRet` probe field + 3 manifest probes (results
  committed); report §20 + per-operation `docs/probe/write-capability.md`
  (BUSY-003 acceptance, feeds 020). BUSY-001 closed (harness landed).
- **Series paging fix (WP1 review F3) + prefix tests (F5)** (mirror of
  busy-server): `seriesList` filters the voucher-type partition SQL-side
  (`ListOpts.name_prefix` → `AND Name LIKE '09*'` — DAO's `*` wildcard,
  probe-verified in WP2) so keyset pages hold only matching rows — a
  filtered page is never empty while `has_more=true`. Pure
  `seriesPrefix` (9 → `"09"`, 10 → `"10"`, out-of-range → null) +
  `prefixClause` unit tests; `docs/operations.md` regenerated (list-series
  summary notes SQL-side paging). Tests 144 → 146; live suites 14 (with
  new cursor-follow checks), 06, 11 green vs COMP0001.

- **WP2 master writes: per-kind create/update/delete over the registry**
  (mirrors busy-server PR): `masters/fields.zig` — one probe-verified field
  map per kind (request key -> BUSY element + str/num/bool; booleans
  render "True"/"False", numbers decimal) replaces the `fieldsToDoc`
  if-chain. Capability flags on `KindEntry`, probed live on BUSY 14:
  `wrap` (create/update) set for 10 kinds; `deletable` set for the 5
  kinds whose `DeleteMasterByCode` deletes cleanly (account, item,
  account/item-group, tax-category) — unit, sale/purchase-type, store and
  bill-sundry answer a precise `COM delete is not reliable … (BUSY GUI)`
  BadArgs (BUSY 14's COM delete crashes without deleting);
  unit-conversion/bom/series remain read-only. `kindBySing` drives exec
  dispatch (read-only kinds answer their precise message, not the
  `unknown write op` fallthrough), `isWriteOp`, the generated catalog
  write rows (create/update per writable kind, delete per deletable) and
  the CLI's `op create|update|delete <kind>` kind check; `/op` write
  routes now cover every wired kind's singular path. Create resolves
  BUSY's empty `$code` ByRef by exact-name SQL lookup. `docs/operations.md`
  regenerated; DAO `LIKE` wildcard documented as `*` (not `%`). Tests
  142 → 144; live: server suite `15-master-writes` 46 checks + regressions
  06/07/11/14 + e2e-smoke all green.

- **WP1 picker reads: every master kind + voucher series over `op` CLI,
  `/op` and `/v1`** (app picker surface): `handlers/masters.zig` grows a
  single `kinds` registry (route words, constants name, wrapper element;
  `route=false` for internal kinds) — 12 routed kinds (accounts, items,
  account/item-groups, units, unit-conversions, bill-sundries, stores,
  sale/purchase-types, boms, tax-categories). `kindPath` drives singular/
  plural dispatch on `GET /op/<kind>s|<kind>?name=`, the `/v1` arms and
  the `GET /v1` index; catalog rows (list-X/get-X) are **generated** from
  the table (`docs/operations.md` regenerated) and the CLI accepts any
  kind. **Series**: `op list series [--type T]` / `GET /op|/v1/series
  ?type=T` filter BUSY's stored `<2-digit type><name>` partition (SALE
  stores `09ZigVch9`) and strip the prefix; without `type`, raw stored
  names. Kinds without write ops fail closed (400 unknown write op /
  precise create BadArgs). Tests 139 → 142; live suites 06 + 11
  re-verified, server-side suite `14-master-kinds.ps1` (21 checks) green
  vs COMP0001.

- **Split track — bridge = raw COM binding** (bridge/server separation,
  issue #42 track): `src/lib.zig` is the new **package root** for
  downstream Zig consumers (busy-server now, busy-mcp/busy-cli later).
  It re-exports exactly the raw binding surface — COM engine
  (`core/com.zig` facade + session/surface/record/recordinfo/win32/
  replay corpus), BUSY static knowledge (constants, registry, xmlmeta)
  and util (json/xml/helpers/sqlguard) — and deliberately exposes **no
  business semantics**: typed ops, rights policy and HTTP are the
  server's job and stay out. `build.zig` exposes it as the
  `busy_bridge` module (`dep.module("busy_bridge")`; consumers pick
  target and link ole32/oleaut32/advapi32/bcrypt [+ws2_32]). Smoke
  suites run in a dedicated named test binary (`lib_surface_test`; a
  file belongs to exactly one module, so lib.zig cannot ride the
  executable's test root). Test count 95 → 139 (check_tests counts both
  binaries: main 95 + package 44); layers gate extended with the `lib` rule (imports core+util
  only, never handlers/transport). The executable is unchanged. Next:
  busy-server repo
  consuming this package with handlers+transport moved over and the
  HTTP live suites as the parity gate; `serve` leaves here only after
  that parity is proven.

- **Report-name map extended: `day-book` → repID 18** (GUI-grant assist
  executed): live `CheckUserRightsForReports` re-sweep of user1 (0–60 +
  195–205) shows the granted set **{18, 19, 201, 203}** vs §7's all-false
  baseline (admin: all true — control). Operator-attested names: Day
  Book, Account Ledger (19, known), Bills Rec/Pay (201, Functions.md
  anchor) and one other Bills item (203, not an app name — stays
  unmapped/fail-closed). `rep_ids` gains 18/203 (len 21; bitmask stays
  positional); tests extended (same count, 94). Live suite
  `12-report-rights.ps1` matrix updated: **user1 day-book → 200 on both
  surfaces**; unmapped trial-balance remains the fail-closed 403 proof.
  The rights predicate ignores junk params (no name echo — probed);
  identification rests on grant-diff + operator attestation.
- **BUSY-013 raw-tier lockdown shipped** (contract §5 final tier): under
  `serve --require-session`, `/call` and `/query` (COM/SQL escape hatches)
  now require the operator flag **`--allow-raw`** (device-tier posture) or
  an **admin session** (`rights_all`); ordinary sessions and bare device
  tokens get 403 `raw_tier_denied` / 401. Gate-off dev posture unchanged;
  the boot line gains `"raw_tier":"open|operator|admin"`. Policy helper
  `rawAccess` is pure (shared.zig suite — registered in format.zig's
  discovery block; test 94). Live suite `tests/live/13-raw-tier.ps1`
  (6 checks: lockdown + operator-flag postures; harness notes: POST
  /query + body is the routed form, `ping` over GET /call 500s here —
  use `SELECT 1` as the canary). Probe §16.
- **BUSY-012 report enforcement shipped** (contract §5): when the
  session gate is armed (`serve --require-session`), `GET
  /v1/reports/{name}` and `GET /op/report/{name}` check the session's
  stashed rights bits against a report name→repID map
  (`rights.repIdForName`; `ledger` → 19 = Account Ledger, documented
  in BUSY Functions.md). Unmapped reports **fail closed** (403
  `rights_denied`) for non-super users; super passes. Login stashes a
  compact `rights_all` + `report_mask` on the session (no per-request
  COM); the gate-off dev posture is unchanged. New live suite
  `tests/live/12-report-rights.ps1` (10 checks: admin passes,
  user1 ledger 200 / day-book 403 on both surfaces, no-token 401,
  gate-off open). Other report names map in via the GUI-grant assist
  (grant to user1, re-sweep `CheckUserRightsForReports` — the flipped
  ID is the report; probe §7/§15).
- Collection **INPUT** marshaling (`$collection` marker — BUSY-004):
  `{"$collection":[...]}` sources a VB6 Collection from BUSY's own
  `GetCollectionObj` (CFixedInterface via transient aux — the runtime
  Collection class is unregistered anywhere), Adds items, passes as
  typed `VT_BYREF|VT_DISPATCH` (`ByRef As _Collection`). Live:
  `GetAccDayBookJSON` invokes cleanly with 4+ items; item 3 is the
  report-rights identity (Admin clears BUSY's own gate); returns
  BUSY's JSON (empty for the voucher-less test company). Plus
  `invokeEx(retain_ret)`, `Session.clearErr` (stale-error fix),
  marker parsing split to `markers.zig`.
- Collection read marshaling (`core/com/collection.zig`): VB6
  Collection contract (`Count` + 1-based `Item`) enumerated into JSON
  arrays — new `{"$byref":"collection"}` out marker + `--enumerate-ret`
  (CLI) / `?enumerate_ret=1` (HTTP `/call`) for VT_DISPATCH returns;
  fails closed to `[]`, Release exactly once. Live: `GetUserList(true)`
  → `["Admin","User1"]`, `GetVchTypesForUserRights` → `[9,2,3,10,11,4,5]`
  (voucher-type rights key space; vs `"<dispatch>"` without the flag).
- BUSY-012 per-user rights: `CheckUserRightsForReports` semantics
  probe-verified (super answered unconditionally true; regular users
  discriminate per repID — user1: 19/201 allowed, 0–15 denied;
  p_RepID is VB6 Integer); `handlers/rights.zig` resolves normalized
  contract-§3 rights at `/auth/login` + `/auth/me` (super
  short-circuit, per-repID sweep fail-closed, deny-all fallback);
  `reports` keyed by repID (sparse space 0–15 + {19, 21, 201});
  `voucher_types`/`masters` stay `{}` pending Collection enumeration /
  no primitive. Probe iteration 7 (43 probes) recorded.
- BUSY-010/011 auth per the merged contract (`docs/auth-contract.md`):
  opaque 256-bit user-session tokens (BCryptGenRandom, base64url,
  constant-time compare, idle/absolute TTLs; `transport/user_sessions.zig`);
  `POST /auth/login` on the probe-verified path (company ensure →
  `CheckIfLoginDetRequired` via COtherServices1 aux → `ValidUserPassword`
  on the main dispatch → `GetCompConfigJSON` payload), `GET /auth/me`,
  idempotent `POST /auth/logout`; no user enumeration (identical
  invalid-credentials response for wrong password and unknown users).
  `serve --require-session` arms the /v1+/op session gate
  (`401 unauthorized`), `--super-user` (default Admin) selects the
  provisional full-rights identity (everyone else deny-all until per-user
  rights capture), `--session-idle-ttl`/`--session-abs-ttl` configure
  lifetimes; `auth_mode` (off|token|session) reported in `/info` + boot
  line. Raw `/call` `/query` remain device-tier pending BUSY-013.
- `version` reports the git-describe version plus short commit
  (`busy-bridge 0.1.0 (commit abc1234, …)`); tarball builds without a
  checkout fall back to `0.1.0`/`unknown`.
- Package split (issue 012): ERP facade `core/ops` -> top-level `handlers`
  layer (barrel `src/handlers.zig` + `src/handlers/`); `core` is
  COM-mechanics-only - the golden flow script moved to
  `handlers/golden.zig`, transport imports `handlers`.

## [0.1.0] — 2026-10-09

First tagged release. Windows x86 artifact (`busy-bridge-v0.1.0-windows-x86.zip`
+ `SHA256SUMS`) on the
[releases page](https://github.com/devstroop/busy-bridge/releases/tag/v0.1.0).

### Added

- Raw tier: `classes`, `surface`, `query`, `call` over CLI and HTTP, with
  pure JSON (default) or pure XML wire modes and machine-readable error
  codes (issues 001, 002).
- Guarded query: `--query-mode full|read-only|off` + `--max-rows`
  (serve defaults to read-only; issue 003).
- ERP facade (issue 007): `core/ops` + CLI `op` + HTTP `/op` and versioned
  `/v1` with opaque keyset cursors — masters CRUD, voucher post/delete,
  atomic `batch`, four named reports (M1 reads, M2 writes, M3 reports,
  M4 `/v1`).
- Multi-company serve: swap-based `?comp=`/`X-Company` (~7s per switch;
  issue 005).
- Token auth + exposure policy: non-loopback bind requires a token
  (issue 004).
- Voucher write validation (issue 006); 11 live suites green against DEMO.
- Source restructure (issue 011): responsibility-named barrels, enforced
  layer/size/test-discovery gates (73/73 unit tests), architecture doc.
- Release workflow: `v*` tags build, gate, and publish the checksummed
  x86 artifact (issue 010, in progress — version-from-git lands above).
- Docs: BUSY Rel 14 integration knowledge base, generated function
  reference (4,496 members) and operations catalog.

[Unreleased]: https://github.com/devstroop/busy-bridge/compare/v0.1.0...master
[0.1.0]: https://github.com/devstroop/busy-bridge/releases/tag/v0.1.0

- **`$record` INPUT SOLVED (probe �19)**: bare VT_RECORD
  (`{pvRecord, pRecInfo}` with the real runtime IRecordInfo) is the
  canonical VB6 UDT-param shape � the pre-existing byrefvar default
  was the rejector. `byval` is now the shipped default (BUSY_REC_SHAPE
  sweeps byrefrec/byrefvar); live-proven on `InitUDTAccMast`
  (udtAccMast htype 50332609) and `InitUdtVchData` (50332129) �
  `ok:true` both, vs 0x80020005 for the old shape. CopyVchData
  discriminates cleanly (callee runs; its business check needs nested
  VT_PTR content � the next step). Leak fixed: the byrefvar inner box
  VARIANT is now owned by RecBox (was 16 B/record on the error path).
  Tests 95/95 (+shapeFromName pure suite via the format.zig discovery
  block).
