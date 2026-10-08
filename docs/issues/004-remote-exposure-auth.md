# 004 · Remote exposure: auth & exposure policy

**Labels:** `security` · **Effort:** M · **Status:** open · **Milestone:** H1 (gate for H2)

## Problem

`serve` speaks a powerful protocol (arbitrary `call`/`query`, full write
access) with **no authentication**, over plaintext HTTP. Defaults are safe
(loopback), but nothing prevents `--host 0.0.0.0` — and the mobile/web apps
([H2](../roadmap.md)) *require* remote exposure. There is currently no safe
way to expose this beyond localhost/reverse-proxy-in-front.

## Proposal

1. **Token auth**: `--token <t>` (or `BUSY_BRIDGE_TOKEN`) → require
   `Authorization: Bearer <t>` (or `X-Bridge-Token`) on every route except `/info`.
   - `serve` **refuses non-loopback binds without a token** (fail fast with a
     clear message) — the single most important rule here.
   - CLI unaffected (same-process trust).
2. **Exposure policy documented** in README: loopback default; remote =
   token + TLS. TLS itself = reverse-proxy (Caddy/nginx) guidance, not
   reimplemented in the bridge.
3. **Hardening defaults**: disable `--host` wildcard resolution surprises
   (require explicit IP/hostname), add `X-Content-Type-Options: nosniff`,
   and (cheap) simple rate/timeout knobs is out of scope — see below.

Out of scope (note in issue): per-user auth, RBAC, sessions — the facade
([007](007-erp-facade-rfc.md)) and company-level rights
(`*ForAuthorisation` COM primitives) own that layer.

## Acceptance criteria

- [ ] `serve --host 0.0.0.0` without token → refuses to start, actionable error.
- [ ] With token: missing/wrong token → `401` + standard error envelope with `code:"unauthorized"`; `/health` exempt? (**Decision:** not exempt — keep surface minimal; liveness via TCP or `--health-public` flag if needed).
- [ ] Unit tests for the auth gate; live test covers 401 path.
- [ ] README "Security" section: threat model, loopback default, proxy TLS recipe, explicit warning that SQL guard ([003](003-guarded-query.md)) composes with this.

## Notes

Blocks web/mobile ([H2](../roadmap.md)) and MCP ([008](008-mcp-server.md)). Depends on error `code`s ([002](002-contract-hardening.md)) for the 401 envelope.
