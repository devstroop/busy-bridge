# 008 · MCP server over the operations layer

**Labels:** `enhancement` `ai` · **Effort:** M · **Status:** open · **Milestone:** H2
**Blocked by:** [007](007-erp-facade-rfc.md) M1, [004](004-remote-exposure-auth.md)

## Problem

An AI agent must not face 4,496 raw methods: tool-choice paralysis,
hallucinated argument shapes, context blowup, and no safety story. Yet an MCP
surface over BUSY is high value — the agent can answer "what did we sell to
X?" or "post this purchase" with real data.

## Proposal

A thin MCP server (separate process, speaking to the bridge over loopback
HTTP or embedding `core/ops` directly) exposing:

**Tools (~12–20, coarse-grained, ERP vocabulary):**

| Group | Tools |
|---|---|
| read | `list_accounts`, `list_items`, `get_account`, `list_vouchers` (date/type filters), `get_voucher`, `stock_status`, `trial_balance` |
| write | `create_master`, `post_voucher` (M2 only; optional `dry_run` validation) |
| meta | `run_guarded_query` (read-only mode hardwired), `bridge_info` |

**Resources (not tools):** `busy://constants`, `busy://surface` (introspection
for advanced use), `busy://schema/<entity>` — keeps big data out of the tool list.

**Guardrails:**
- tools map 1:1 to `core/ops` (or `/op/*`) — never raw `/call` except `run_guarded_query`,
- auth token from [004](004-remote-exposure-auth.md); SQL in read-only mode ([003](003-guarded-query.md)),
- write tools off by default (`--enable-writes`),
- every tool carries JSON-schema input validation before hitting the bridge.

## Acceptance criteria

- [ ] MCP spec-compliant server (stdio or HTTP transport) boots with zero BUSY knowledge of its own — all semantics from `core/ops`.
- [ ] Tool count ≤ 20; schemas generated from op catalog where possible.
- [ ] Read-only mode proven: attempting a write tool without `--enable-writes` → structured refusal.
- [ ] One end-to-end demo: an agent answers a factual question from DEMO data and performs a guarded write with approval.
- [ ] Docs: `docs/mcp.md` (setup, tool catalog, safety model).

## Notes

Interoperate with BUSY's own mobile concepts (`ConfigMobileAppSeries` is a BUSY
COM member) — do not repurpose BUSY's names for our tools.
