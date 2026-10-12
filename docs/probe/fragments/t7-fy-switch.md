# (T7) — company switching + STA/serialization experiment: clean results

Bridge-map live-queue lane T7 (BUSY-004, last item). Base `105e0f4`.
Replayable: `tests/probe/tasks/t7-fy-switch.ps1` (owns its server on
port 9830; ~30 s). **No `src/` changes.**

## Architecture (from code)

- `sessions.zig` — the Switcher pool has **exactly one occupant**: one COM
  session; per-request company (`?comp=` qparam wins, else `X-Company`
  header, else serve `--comp`; `http.zig:168–173`) swaps via BUSY's own
  `CloseDB`+`OpenDB` (~7 s, measured). `/info` exposes a `switches` counter.
- `http.zig` accept loop is **sequential** (`server.accept` in a loop) —
  concurrent HTTP requests are serialized before they can touch COM, so
  the single-apartment (STA) constraint holds structurally: no two
  threads ever access the session simultaneously.
- Bridge serve has **no FY dimension** (`?fy=` accepted and ignored) —
  FY scoping is the auth-contract/server concern (spec S6).

## Live results (COMP0001 default ↔ COMP0002)

| Probe | Result |
|---|---|
| baseline `GetCurrentUserName` (default) | `"Admin"`, 0.1 s |
| first switch → COMP0002 | 6.6 s; `GetCurrentUserName` → `"Busy"` (per-company state — the discriminator flips) |
| company data: `SELECT COUNT(*) FROM Master1` | COMP0001 = **428** vs COMP0002 = **405** (distinct datasets) |
| switch back + repeat | back 5.4 s → 428 again; same-company repeat **0.0 s** (no swap) |
| default after roundtrip | `"Admin"` — **no cross-talk** |
| two parallel same-company calls | both succeed (accept-loop serialization) |
| `?fy=2025` | accepted-ignored (no FY on bridge serve) |

**Verdict**: company switching is safe and self-consistent — per-request
scoping works, swaps cost ~5–7 s only on first touch of a different
company, same-company is free, defaults never leak across companies, and
the STA constraint is structurally enforced by the sequential accept
loop. The busy-server spec S6 (multi-FY sessions) can build on this
Switcher with the `company+FY` key without concurrency surprises.

Fixture: `tests/probe/fixtures/iter27-fy-switch.json`.

Changelog line for the operator: `**T7**: company-switch experiment
clean - ?comp= swap 5.4-6.6s only on change, same-company 0s, no
cross-talk (428/405 discriminators), STA structurally safe (sequential
accept loop); bridge serve has no FY dim (spec S6 scope).`
