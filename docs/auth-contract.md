# `/auth` API contract

**Status: SHIPPED** — user sessions (BUSY-010/011), per-repID report
rights (BUSY-012) and the raw tier (BUSY-013) are implemented and
suite-tested on both sides of the fork (live suites 09-auth,
12-report-rights, 13-raw-tier in busy-bridge and busy-server). Sessions
are opt-in (`serve --require-session`), the raw tier is opt-in
(`serve --allow-raw`); the resulting posture matrix is in both
READMEs' Security sections. Origin: the P0 probe report
([`docs/probe/2026-10-09-headless-contracts.md`](probe/2026-10-09-headless-contracts.md)).

**Ownership / consumers**: the canonical runtime is **busy-server**
(private; fork of this repo's serve — kept in lockstep by the
fork-parity gate, see [`docs/fork-parity.md`](fork-parity.md)); the
**busy_app** client consumes `/auth/*` and the session posture. This
contract is normative for both runtimes; when the two repos' transport
slices drift, the gate (not this document) is the tripwire.

Identity is **BUSY-backed**: the bridge never invents a user store —
credentials are validated through verified COM primitives, rights come
from BUSY, and every write is attributed to the validated username.

## 1. Session model (two tiers, backward compatible)

| Tier | Credential | Scope | Status |
|---|---|---|---|
| Device | `BUSY_BRIDGE_TOKEN` (existing) | transport gate: device ↔ server; loopback posture unchanged | existing, unchanged |
| User | opaque **session token** (shipped, BUSY-011) | identity: user + company + FY; required for `/v1` and `/op` writes when `serve --require-session` is set | this contract |

Rules:
- Session tokens: 256-bit CSPRNG, base64url; stored server-side
  (in-memory map is acceptable for single-process `serve`; record shape
  fixed so a persistent store can drop in). Never logged.
- Sessions are **bound** to `username + company + FY`. A company/FY
  change rebinds explicitly (`/auth/login` again); there is no silent
  cross-context continuation.
- Expiry: idle TTL 12 h, absolute TTL 7 d (configurable at serve
  start). Expired → `session_expired` (401).
- Passwords are never stored, persisted, or logged — validated by the
  primitive, discarded.

## 2. Endpoints

All three routes are implemented (`src/transport/http/routes_auth.zig`,
mirrored server-side; live suite 09-auth).

### `POST /auth/login`
```json
// request
{ "username": "Busy", "password": "…", "comp": "COMP0001", "fy": 0 }
// 200 response
{ "ok": true, "result": {
    "token": "…", "user": "Busy", "is_mobile_user": false,
    "company": "COMP0001", "fy": 0,
    "config": { "CompName": "DEMO", "BegFY": "04/01/2026", "CurFY": "04/01/2026", "…": "GetCompConfigJSON payload" },
    "rights": { } } }
```
- `comp` required (credential validation needs an open company —
  probe-verified); `fy` optional (0 = current).
- Validation path (probe-verified on their host class; regular BUSY
  company users — **no mobile-app/BDEP dependency** by operator
  decision, iteration-4 report §4):
  1. open company (`OpenDB`, existing session machinery),
  2. `CheckIfLoginDetRequired(user)` (`COtherServices1`) — verified:
     `true` for admin and user1, `true` for unknown users too (no user
     enumeration),
  3. **Regular-user credential check — VERIFIED** (iteration 6):
     `ValidUserPassword(user, pwd)` on **`CFixedInterface`** (default
     class) — plain 2-string → bool, no ByRef/UDT/mobile gate. Live
     fixtures: `admin` + correct pw → true, `user1` + correct pw → true, both
     wrong-password cases → false, unknown user → false
     (indistinguishable — §4 holds). Report §6.
  4. `GetCompConfigJSON(skipBranch, fy, false)` (`CFixedInterface1`)
     → `config` payload.
- Attribution identity of a headless COM session is the configured
  super user (`GetCurrentUserName` → `"Admin"`) — session writes are
  attributed to the **validated request username**, never to this.
- `CheckIfLoginDetRequiredFromDatabase` is a **UI trap** — never used.
  `ValidMobileUserPassword`/`GetMobileUserRightsJSONstr` (mobile-user
  category) are **out of scope** — the operator model is regular
  company users only.
- Failures: `invalid_credentials` (401) — **identical response for
  unknown user and wrong password**; `company_not_found` (404);
  `busy_rejected` for primitive refusals.

### `GET /auth/me`
Requires session token. Returns
`{ ok, result: { user, is_mobile_user, company, fy, rights } }`.
`rights` is the **normalized** rights object (below). Cache-Control:
no-store.

### `POST /auth/logout`
Revokes the token (idempotent; unknown/expired token → 200 anyway).
Records BUSY-side login/logout where the verified primitive allows.

## 3. Rights schema (normalized — deny by default)

```json
"rights": {
  "voucher_types": { "sale": "write", "purchase": "read", "…": "none" },
  "masters":       { "accounts": { "read": true, "write": true,
                     "scope_parent_codes": [116] },
                     "items": { "…": "…" } },
  "reports":       { "trial-balance": true, "day-book": false },
  "can_authorise": false
}
```
- **Shipped (BUSY-012)** — resolution site `src/handlers/rights.zig`
  `resolve()`, called at login and on the `/auth/me` replay:
  - `reports` are **BUSY-backed per repID**: the super user
    short-circuits to full; regular users get one
    `CheckUserRightsForReports(repID)` call per id in `rep_ids` through
    a transient `COtherServices1` aux (company state is
    process-global). Any invoke error **fails closed** for that report.
  - `voucher_types` and `masters` stay `{}` (deny-all): no COM
    primitive exists for vouchers and the masters key space is blocked
    on `GetVchTypesForRights` Collection enumeration.
  - `can_authorise` stays `false` (no primitive yet).
  - Super-user rights are keyed to the configured `--super-user`
    (default `Admin`) and the session stash (`rights_all` /
    `report_mask`), not re-derived per request.
- Enforcement point: single policy layer on `/v1` + `/op` (BUSY-012).
  Unknown/malformed rights ⇒ **deny**. The client may hide UI by
  rights, but the server never trusts the client's copy.

## 4. Error envelope (existing shape, new codes)

`{"ok": false, "code": "<machine>", "error": "<message>"}` with HTTP
status: `invalid_credentials` 401 · `unauthorized` (no/wrong session)
401 · `session_expired` 401 · `company_not_found` 404 ·
`query_not_allowed` 403 (existing) · `rights_denied` 403 ·
`raw_tier_denied` 403 (raw `/call`/`/query` without admin session or
`--allow-raw`). Login responses never reveal whether the username
exists.

## 5. Enforcement summary (shipped)

| Surface | Gate |
|---|---|
| `/info`, `/health` | device tier only (unchanged) |
| `/auth/login` | none (this is the gate) |
| `/auth/me`, `/auth/logout` | session |
| `/v1/*` reads | session + rights (master ranges, report ids) |
| `/v1/*` writes | session + operation rights + attribution (`p_UserName` on the save path) |
| `/op/*` | same as `/v1` (facade parity) |
| raw `/call`, `/query` | device tier **plus** `--allow-raw` (any session, operator tier) or an explicit admin session (BUSY-013); never available to ordinary sessions |

The gates above apply when `--require-session` is set; without it the
server runs the legacy device-tier posture (below). Derivation sites:
`auth_mode` and `raw_tier` in `src/transport/http.zig` `serve()`
(`auth_mode = session|token|off`, `raw_tier = open|operator|admin`),
surfaced on the boot line and in `GET /info` (`"auth_mode"`,
`"raw_tier"`) — the posture of a live server is always observable
without reading flags off the process list. The flag-combination →
posture matrix lives in both READMEs' Security sections.

Loopback dev posture: when bound to loopback **without** a configured
auth requirement, existing tokenless flows keep working (migration
compatibility with today's live suites and busy_app dev mode); the
policy is reported in `/info` (`"auth_mode": "off|token|session"`).

## 6. Open items

1. `GetJSON2*`/`SaveVchFromJson` remaining param shapes (0x80020005
   persists on non-ByRef params; matrix next iteration).
2. Audit hooks: `SaveLogInLogOutUserLog` / `SaveUserLOG` activation
   (BUSY-023) — verify headless first.
3. Multi-FY sessions: `fy` semantics for `OpenDBForYear` —
   `UserControl.FinYrs` shows per-user FY prefs exist; wire after
   enumeration lands (BUSY-004). Tracked server-side (workmap);
   busy-server currently ignores `fy` on login.
4. Voucher/master rights population (`voucher_types`/`masters` stay
   `{}`): needs `GetVchTypesForRights` Collection enumeration (T3
   `$collection`-of-records work, busy-bridge PR #50).
