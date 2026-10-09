# `/auth` API contract (draft RFC)

**Status: DRAFT — shaped by the P0 probe report
([`docs/probe/2026-10-09-headless-contracts.md`](probe/2026-10-09-headless-contracts.md));
rights schema fixture-blocked (BUSY-002). Implements backlog BUSY-010/011.**

Identity is **BUSY-backed**: the bridge never invents a user store —
credentials are validated through verified COM primitives, rights come
from BUSY, and every write is attributed to the validated username.

## 1. Session model (two tiers, backward compatible)

| Tier | Credential | Scope | Status |
|---|---|---|---|
| Device | `BUSY_BRIDGE_TOKEN` (existing) | transport gate: device ↔ server; loopback posture unchanged | existing, unchanged |
| User | opaque **session token** (new) | identity: user + company + FY; required for `/v1` and `/op` writes once P1 ships | this contract |

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
- Provisional: rights for **regular users** come from BUSY's own
  per-user rights (candidate primitive `CheckUserRightsForReports` on
  `COtherServices1` — shape pending the typed-ByRef fix, report §4).
  The mobile-user rights UDT (`GetMobileUserRightsJSONstr`) is out of
  scope (no BDEP). Until per-user rights are captured, non-super users
  receive deny-all with explicit allow-lists; the super user
  (`admin`) receives full rights.
- Enforcement point: single policy layer on `/v1` + `/op` (BUSY-012).
  Unknown/malformed rights ⇒ **deny**. The client may hide UI by
  rights, but the server never trusts the client's copy.

## 4. Error envelope (existing shape, new codes)

`{"ok": false, "code": "<machine>", "error": "<message>"}` with HTTP
status: `invalid_credentials` 401 · `unauthorized` (no/wrong session)
401 · `session_expired` 401 · `company_not_found` 404 ·
`query_not_allowed` 403 (existing) · `rights_denied` 403 (new, see
below). Login responses never reveal whether the username exists.

## 5. Enforcement summary (once P1 ships)

| Surface | Gate |
|---|---|
| `/info`, `/health` | device tier only (unchanged) |
| `/auth/login` | none (this is the gate) |
| `/auth/me`, `/auth/logout` | session |
| `/v1/*` reads | session + rights (master ranges, report ids) |
| `/v1/*` writes | session + operation rights + attribution (`p_UserName` on the save path) |
| `/op/*` | same as `/v1` (facade parity) |
| raw `/call`, `/query` | device tier **plus** operator flag or explicit admin session (BUSY-013); never available to ordinary sessions |

Loopback dev posture: when bound to loopback **without** a configured
auth requirement, existing tokenless flows keep working (migration
compatibility with today's live suites and busy_app dev mode); the
policy is reported in `/info` (`"auth_mode": "off|token|session"`).

## 6. Open items (fixture/blocker-dependent)

1. ~~Regular-user credential primitive~~ — **RESOLVED** (iteration 6):
   `ValidUserPassword` verified with a +/− fixture pair (report §6).
   `/auth/login` implementation (BUSY-011) is GO.
2. `GetJSON2*`/`SaveVchFromJson` remaining param shapes (0x80020005
   persists on non-ByRef params; matrix next iteration).
3. Audit hooks: `SaveLogInLogOutUserLog` / `SaveUserLOG` activation
   (BUSY-023) — verify headless first.
4. Multi-FY sessions: `fy` semantics for `OpenDBForYear` —
   `UserControl.FinYrs` shows per-user FY prefs exist; wire after
   enumeration lands (BUSY-004).
