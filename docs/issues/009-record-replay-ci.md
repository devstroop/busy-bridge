# 009 · Record/replay fixtures for CI depth

**Labels:** `tests` `ci` · **Effort:** M · **Status:** in progress (M1 landed 2026-10-09: format + Replay + recorder + host CI; ops-generic replay is the follow-up) · **Milestone:** H3

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

- [x] Recorder produces transcripts with one command (`busy-bridge record
      --comp C [--out F]`, read-only golden flows; write flows deferred — the
      seed transcript covers CRUD shapes as synthetic entries until a BUSY
      machine regenerates it).
- [x] Replay tests cover: OpenDB success/failure, master CRUD args+results,
      recordset walking (multi-row, null cells, empty result), XML-result parsing,
      `vt=0` error mapping (as recorded error names → the same Zig sets).
- [x] `zig build replay-test` runs replay tests on Linux + Windows CI, no BUSY
      (host-native binary rooted at `src/replay.zig`; COM-touching modules are
      never analyzed — `callconv(.winapi)` externs do not compile on arm64 hosts).
- [x] Transcript staleness guard: recording date + BUSY version embedded; test warns on mismatch.
- [ ] Follow-up: drive `core/ops` against Replay via a comptime session
      interface, so facade logic (not just Session values) runs under replay.

## Notes

Sizing risk: the recorder must capture *ownership-correct* snapshots (JSON
strings only — never COM pointers). All captured values already flow through
JSON at the Session boundary, so this is tractable.
