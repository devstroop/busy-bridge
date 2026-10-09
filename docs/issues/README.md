# Future-direction issues

Paste-ready GitHub issues (title + labels + body) supporting the
[roadmap](../roadmap.md). Create a remote (`gh repo create …`) and import, or
use them as a plain backlog.

| # | Issue | Labels | Effort | Status | Depends on |
|---|---|---|---|---|---|
| 001 | [Runtime ProgID discovery](001-runtime-progid-discovery.md) | bug, robustness | S | ✅ closed 2026-10-08 | — |
| 002 | [Contract hardening: constants, /info, error codes](002-contract-hardening.md) | enhancement, api | S | ✅ closed 2026-10-08 | — |
| 003 | [Guarded query (SQL safety modes)](003-guarded-query.md) | security | M | ✅ closed 2026-10-09 | — |
| 004 | [Remote exposure: auth & exposure policy](004-remote-exposure-auth.md) | security | M | ✅ closed 2026-10-09 | 002 |
| 005 | [Multi-company sessions in serve](005-multi-company-sessions.md) | enhancement | M | ✅ closed 2026-10-09 | — |
| 006 | [Voucher write validation + Tran1 semantics](006-voucher-write-validation.md) | tests | S | ✅ closed 2026-10-09 | — |
| 007 | [ERP-centric facade v1 (RFC)](007-erp-facade-rfc.md) | rfc, enhancement | L | ✅ closed 2026-10-09 | 002, 005 |
| 008 | [MCP server over the facade](008-mcp-server.md) | enhancement, ai | M | open | 007, 004 |
| 009 | [Record/replay fixtures for CI](009-record-replay-ci.md) | tests, ci | M | open | — |
| 010 | [Release artifacts & real versioning](010-release-artifacts.md) | ops | S | open | remote |
| 011 | [Source restructure: split oversized modules](011-source-restructure.md) | refactor, chore | M | ✅ closed 2026-10-09 | — |
| 012 | [Package split: busy-com driver + app](https://github.com/devstroop/busy-bridge/issues/12) | refactor, architecture | M | open — **tracked on GitHub** | 011 |

> **Active issues are maintained on [GitHub Issues](https://github.com/devstroop/busy-bridge/issues)**
> (012 there = this table's 012; 011 also migrated as a closed record).
> This table and the sibling files are the closed **001–011 history archive** —
> no new issue files are added here.
