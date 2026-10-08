# 005 · Multi-company sessions in serve

**Labels:** `enhancement` · **Effort:** M · **Status:** open · **Milestone:** H1

## Problem

`serve --comp COMP0001` binds **one company for the process lifetime** — the
session is created at startup and shared by every request. An ERP web/mobile
app needs company *switching* (and later, many companies). Today that means
one bridge process per company: clunky to deploy, no shared caching, and the
"open company" state is invisible to clients.

Constraints that shape the design (from live testing):
- one open company per data directory; headless + GUI on same company = crash;
- COM session is STA → **serialize access per session**; current single-threaded
  accept loop already does this for one session.

## Proposal

**Session pool keyed by company code**, lazy-opened on first use:

- Company selection per request: `?comp=COMP0001` (query) or `X-Company` header —
  default = the `--comp` given at startup (back-compat).
- Pool: `map[compCode]Session`, opened on demand, `CloseDB`+release on LRU/eviction
  (`--max-companies`, default small, e.g. 4).
- **Per-company mutex**: requests for the same company run serially (STA + BUSY
  file locks); *different* companies may run in parallel **only if** proven safe —
  start conservative: one global lock, document, then measure.
- `/info` lists open companies; unknown company → standard envelope,
  `code:"company_not_found"` (discover via existing `GetCompList`).
- CLI commands unchanged (single-shot open/close).

## Acceptance criteria

- [ ] One `serve` process answers queries against **two** companies in one live test.
- [ ] Default `--comp` behavior unchanged (existing live tests pass untouched).
- [ ] Unknown company → `code:"company_not_found"`; pool respects `--max-companies`.
- [ ] Concurrency documented: what is serialized, what is parallel, why (STA, file locks).
- [ ] Stress: N sequential requests across 2 companies, no leaks (debug allocator clean).

## Notes

Foundation of facade ([007](007-erp-facade-rfc.md)) — resources need `company`
as first-class context. Keep raw tier semantics: pool is transport-level, not domain.
