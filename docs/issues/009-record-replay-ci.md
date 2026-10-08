# 009 · Record/replay fixtures for CI depth

**Labels:** `tests` `ci` · **Effort:** M · **Status:** open · **Milestone:** H3

## Problem

CI runs 29 unit tests (pure codec/negotiation), but every *behavioral* test —
`query`, `call`, `serve` — needs a machine with BUSY + an open company. GitHub
runners have neither, so regressions in `com/` (the FFI core: variant
marshaling, IDispatch invocation, recordset walking) ship undetected. The XML
codec already solved this once with captured fixtures
(`src/util/xml/testdata/`, byte-identity round-trips); the COM layer has no
equivalent.

## Proposal

**Record/replay at the Session boundary**, following the fixture pattern that
already works:

1. **Recorder** (dev machine with BUSY): wraps a real `Session`, captures
   each `invoke`/`queryToJson` interaction — member name, marshaled args
   (JSON), result (JSON) or error — into a committed JSON transcript
   (`src/core/com/testdata/*.jsonl`).
2. **Replay Session**: a `Session`-shaped implementation that answers from the
   transcript (no FFI). Production code stays untouched; the recorder/replay
   live behind a build option or test-only seam (e.g. `Session.mode = .replay`).
3. **Scope the transcripts**: the golden scenarios = the live suites'
   flows (OpenDB, Save/Get/Delete master XML, GetRecordset rows,
   GetCompConfigXML, error paths incl. `no recordset` once [006](006-voucher-write-validation.md) defines them).
4. CI gains a `replay` test job: Linux + Windows, no BUSY.

Alternative considered: stub at the *route* level (mock JSON in/out) — weaker
(loses argument-marshaling coverage), rejected; the whole point is exercising
`invoke`'s variant logic.

## Acceptance criteria

- [ ] Recorder produces transcripts for all live-suite scenarios with one command.
- [ ] Replay tests cover: OpenDB success/failure, master CRUD args+results,
      recordset walking (multi-row, null cells, empty result), XML-result parsing,
      `vt=0` error mapping.
- [ ] `zig build test` on Linux CI runs replay tests (no Windows-only code paths — replay must be host-agnostic).
- [ ] Transcript staleness guard: recording date + BUSY version embedded; test warns on mismatch.

## Notes

Sizing risk: the recorder must capture *ownership-correct* snapshots (JSON
strings only — never COM pointers). All captured values already flow through
JSON at the Session boundary, so this is tractable.
