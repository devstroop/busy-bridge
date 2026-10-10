# Changelog

All notable changes to `busy-bridge` are recorded here, Keep-a-Changelog
shape. Versions are git tags (`vX.Y.Z`); the binary reports its own
version via `busy-bridge version` (tag-derived since 0.1.0).

## [Unreleased]

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
