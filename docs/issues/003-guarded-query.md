# 003 · Guarded query (SQL safety modes)

**Labels:** `security` · **Effort:** M · **Status:** open · **Milestone:** H0

## Problem

`POST /query` executes **arbitrary SQL** against the company database. That is a
feature for an internal tool and a critical liability the moment anything
remote, multi-tenant, or agent-driven touches it: `DROP`-class statements,
cross-company reads via `GetRecordsetFromCompanyDB`, or simply heavy scans on
a single-threaded serve loop. Today the only guard is "loopback by default".

## Proposal

Add a per-process **query mode**, applied to *both* transports:

| Mode | Behavior | Default |
|---|---|---|
| `full` | current behavior | CLI (`query`, `call`) |
| `read-only` | statement must start with `SELECT`/`WITH` (after comment/whitespace strip); single statement (no `;` tail); enforce a row cap via `TOP`/`LIMIT` rewrite or post-truncation flag | `serve` |
| `off` | `/query` route disabled entirely | available flag |

Details:
- Parser-light validation (first keyword + semicolon check) is enough — document it as a *guardrail*, not a SQL firewall; true isolation = SQL Server read-only credentials.
- Rejection returns the standard error envelope with `code: "query_not_allowed"`.
- Row cap: optional `--max-rows N` (default e.g. 10,000) with `"truncated": true` in the response — protects the single-threaded server and mobile clients alike.

## Acceptance criteria

- [ ] `serve` refuses `DELETE/UPDATE/DROP/…` with `code:"query_not_allowed"`; `SELECT`/`WITH` pass.
- [ ] Multi-statement input (`SELECT 1; DROP TABLE x`) rejected in guarded mode.
- [ ] CLI stays `full` by default; `--query-mode` flag documented in README.
- [ ] Unit tests for the validator (accept/reject corpus) + live test for the refusal path.
- [ ] Row-cap behavior tested (cap=2 on a 3-row query → 2 rows + truncated flag).

## Notes

Gate for any non-loopback exposure ([004](004-remote-exposure-auth.md)) and for the MCP read tool ([008](008-mcp-server.md)) — MCP's query tool should run `read-only` unconditionally.
