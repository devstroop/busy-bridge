# Changelog

All notable changes to `busy-bridge` are recorded here, Keep-a-Changelog
shape. Versions are git tags (`vX.Y.Z`); the binary reports its own
version via `busy-bridge version` (tag-derived since 0.1.0).

## [Unreleased]

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
