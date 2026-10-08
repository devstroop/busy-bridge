# 001 · Runtime ProgID discovery

**Labels:** `bug` `robustness` · **Effort:** S · **Status:** closed (2026-10-08) · **Milestone:** H0

## Problem

`cli.zig` hardcodes `DEFAULT_PROG = "Busy2L21.CFixedInterface"`. The suffix
tracks the BUSY release (`Busy2L17` → `Busy2L21` …), so **the next BUSY
upgrade silently breaks every default invocation** of `surface`, `query`,
`call` and `serve` unless the caller passes `--prog-id` explicitly. The docs
even warn users not to hardcode the ProgID — the bridge itself hardcodes it.

## Proposal

Discover the newest available `CFixedInterface` at startup:

1. Probe `CLSIDFromProgID` for `Busy2L{99..21}` descending (cheap, ~ms), or
   enumerate `HKLM\SOFTWARE\Classes` for `Busy2L*.CFixedInterface` and pick
   the highest.
2. Cache the result for the process lifetime.
3. `--prog-id` remains an explicit override (wins over discovery).
4. Surface the chosen ProgID in `GET /info` (issue 002) and `version` output.

## Acceptance criteria

- [x] Default invocation works after a BUSY upgrade with no code change and no flags (validate by simulation: default fails today if `Busy2L21` is masked).
- [x] `--prog-id` still overrides discovery.
- [x] Discovery failure produces a clear error listing what was probed.
- [x] Unit-testable seam (probe function injectable); live test in `tests/live/` unchanged.
- [x] Docs (`docs/com-xml-interface.md`, README) updated to "resolved at runtime".

## Notes

- Discovery cost is per-process; CLI invocations pay it once (measure: `CLSIDFromProgID` on miss is microseconds).
- Related: hardcoded `0.1.0` version string (see [010](010-release-artifacts.md)).
