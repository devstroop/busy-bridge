# (T9) — Record/replay fixtures for CI depth (issue #9)

Bridge-map lane T9. **Files**: `core/com/record.zig` (InvokeOpts-aware
recording), `core/com/replay/tests.zig` (+2 live suites), `handlers/golden.zig`
(headless-shape battery), `handlers/masters/{read}.zig` + `masters.zig`
(shared page-SQL builders), `transport/commands.zig` (record dispatch fix),
`scripts/check_{tests,replay}.ps1` (156 / 31), new live transcript
`core/com/replay/testdata/t9-headless-shapes.jsonl`. LIVE: capture run
2026-10-12 (BUSY Rel 14, COMP0001, one `busy-bridge record` process).

**T9**: replay corpus now pins the headless-reachable shapes — enumerated
Collection returns (GetCompList nested rows, GetAllFinYears `[2026]`), the
masters keyset page pair (exact `listSql`/`keysetClause` SQL, strict
resume), and the `$record`-input UDT initializer (`InitUdtVSGrpConfig`,
htype 50333725, COtherServices) — captured live via `busy-bridge record`
into a committed 9-entry transcript + 2 walk suites; replay gate 31,
count gates 156/31; also unblocked the documented `record --out <file>`
flag (dispatcher validated it as the json|xml wire format first) and fixed
an 82-byte SQL leak in the new golden page-pair step.

## What ran

- `zig-out\bin\busy-bridge.exe record --comp COMP0001 --out
  src\core\com\replay\testdata\t9-headless-shapes.jsonl` →
  `recorded 9 entries`, exit 0, debug-allocator clean.
- Full gate battery on the branch: `zig fmt --check` · `zig build` ·
  `zig build test` · `check_tests 156/156` · `check_layers` (376
  imports) · `check_size` (warnings only) · `check_replay 31/31`
  (host-native binary — replay needs no BUSY, proven by the ubuntu CI
  job each PR).

## What landed (transcript, 9 entries)

1. `OpenDB` COMP0001 ok.
2. `GetCompList` **enumerated** → collection of 10-field rows. Notable
   faithful capture: with COMP0001 *open*, the company picker lists only
   the other company (`COMP0002`) — the open company is excluded live;
   the iter20 probe saw both because it ran company-less.
3. + 4. Masters **keyset page pair**: `SELECT TOP 3 … MasterType = 2
   ORDER BY Name` then the same with `AND Name > 'Add. Cess on GST
   Output'` — page 2 resumes strictly after page 1's last row. SQL is
   built by the *shared* `masters.listSql`/`keysetClause` (extracted
   from `read.zig`), so recorded transcripts can never drift from the
   live cursor builder.
5. `SELECT TOP 2 Code, Name FROM Master1` ok (seeded-series shape).
6. `NoSuchMethod_Bogus` → `NoSuchMember` (error mapping preserved).
7. `SELECT * FROM NoSuchTable_Xyz` → `NoRecordset` (error mapping).
8. `GetAllFinYearsOfSpecificCompCode("COMP0001")` **enumerated** →
   `[2026]` (CFixedInterface1 aux session — the method is not on the
   default `CFixedInterface`).
9. `InitUdtVSGrpConfig` with `$record` `udtVchSeriesGrpConfig` (htype
   50333725, inert defaults, `$collection`-inside-`$record`) → ok,
   ret null (COtherServices aux session — no `OpenDB` member there;
   `handlers.openCompany` opens through the fixed-interface aux).

## Bugs found & fixed on the way

- **`record --out <file>` never worked** (pre-existing): the CLI
  dispatcher validated `--out` as the json|xml wire format for *every*
  command before dispatch, so the documented transcript-path flag died
  with `bad_args`. `record` now dispatches before the format check
  (commands.zig). Verified against pristine origin/master: same failure.
- **82-byte leak per capture** (mine, caught by the debug allocator):
  the golden page-pair passed `masters.listSql`'s heap SQL straight into
  `recordQuery` without freeing. Now `defer alloc.free(page1_sql)`.

## Regeneration flow (documented)

After a BUSY upgrade: rebuild, re-run the `record` command above
(single process; direct comp attach is fine alongside a running
Busy21), commit the new transcript, adjust the walk suite only if the
*pinned* values (e.g. `[2026]`, the keyset boundary names) changed —
shape assertions are deliberately fixture-agnostic where the box
contents may drift (company count), strict where the transcript is
frozen (entry count, error names). `busy_version` mismatch is already
the staleness guard (`stale_warn`).

## Known limits / follow-ups

- The facade reads (`masters.list` cursor exercise, vouchers, reports)
  still bypass the Recorder (pre-existing NOTE in golden.zig) — the
  transcript-grade captures are the raw calls; wiring Recorder through
  ops via a comptime session interface stays the documented 009
  follow-up.
- `GetCompList` row count is intentionally not pinned in the walk suite
  (box-fixture dependent); the transcript itself is exact and the
  engine's sequential matching keeps replays honest.
