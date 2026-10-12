## (T11) — stdout file-redirect corruption: diagnosed + fixed (2026-10-12, worktree bbwt/t11, branch feat/t11-stdout-fix, base 7222024)

- **T11**: CLI stdout file-redirect fixed — `printOut` (src/util/helpers.zig) used the default **positional** `Io.File.stdout().writer` (fresh writer per call ⇒ `pos=0` ⇒ `NtWriteFile(ByteOffset=0)`), so with a FILE redirect every call rewrote from file offset 0 (trailing `"\n"` ate `{` in error envelopes; `unknown command:` was replaced by Usage). Switched to `writerStreaming` (NULL byte offset ⇒ appends at file position); pipes/consoles byte-identical (sha256-verified for `version`/`help`/`frobnicate`/`classes --out bogus`). Issue text: `issue-stdout-redirect.md` (worktree root).

### Repro evidence (pre-fix, PS 5.1; `>` in PS is UTF-16 — always use `cmd /c` for raw redirects)

| command | `cmd /c "... > file"` (pre-fix) | pipe capture | verdict |
|---|---|---|---|
| `version` | len 72, starts `62 75 73 79` ("busy-bridge…") | len 72, same | OK (single write at offset 0 of a fresh file) |
| `help` | len 2975 = Usage | len 2975, same | OK (single write) |
| `frobnicate` | len 2975 = **Usage only**, first byte `62` ('b') | len 3004, starts "unknown command: frobnicate\n\n" | **corrupt** |
| `classes --out bogus` | len 79, **first byte `0a`**, ends `"}` | len 80, first byte `7b` (`{`), ends `"}\n` | **corrupt** — exactly report §1.8's "`{` eaten by trailing newline" (`fail()` = payload write + `"\n"` write; second write lands at offset 0) |

Repro artifacts kept in `_t11repro/` (baseline + post-fix redirect/pipe captures).

### Root cause

- `helpers.printOut` = the CLI's only stdout writer (grep: no other `File.stdout`/`getStdOut` path; `std.debug.print` sites go to **stderr**, unaffected).
- `Io.File.stdout().writer(io, &buf)` → `File/Writer.init`: `mode = .positional, pos = 0` every call.
- Flush → `fileWritePositional(..., offset=0)` → zig 0.17.0 `std/Io/Threaded.zig` `writeFilePositionalWindows` → `NtWriteFile(..., ByteOffset=0)` = **absolute** offset, ignoring the file object's current position ⇒ each `printOut` overwrites from byte 0.
- Pipes/consoles aren't regular files: kernel ignores the explicit ByteOffset ⇒ sequential ⇒ unaffected (probe harness captures via pipes → never saw it). POSIX equivalent would be `pwrite` at offset 0 (same corruption).

### Fix (uncommitted in worktree; operator integrates)

`src/util/helpers.zig` `printOut`: `Io.File.stdout().writer(...)` → `writerStreaming(...)` (+7-line comment). Streaming passes `ByteOffset=NULL` → appends at file position. Backup options if it regresses: process-lifetime buffered writer (one write per command) or `GetFileType`-based sequential fallback. No error strings / JSON shape changed; single-line behavioral core change.

### Verification (post-fix)

- redirect == pipe byte-for-byte: `version` (72), `help` (2975), `frobnicate` (3004), `classes --out bogus` (80, was 79 pre-fix since the trailing `\n` is no longer lost) — error envelope first byte `7b`, `unknown command: ` prefix back.
- pipe == pre-fix baseline (sha256): all four identical ⇒ pipe/console behavior unchanged. Console (inline run) renders `version`/usage correctly.
- Gates (all green, run from worktree root): `zig fmt src` + `zig fmt --check build.zig src` = 0; `zig build` = 0; `zig build test` = 0 (**148** tests, unchanged); `scripts\check_tests.ps1` → `check_tests: 148/148 discovered tests passed / check_tests OK`; `scripts\check_layers.ps1` → `layer check OK: 362 imports across 74 files`; `scripts\check_size.ps1` → `scanned 92 file(s) / size gate OK` (warnings only; helpers.zig = 226 lines).

### Why no unit test

The corruption requires the *process* stdout handle to be a regular file; `zig test`'s stdout is a pipe/captured handle and the real stdout can't be swapped in-process. A temp-file test of `File.writer` vs `writerStreaming` would only assert Zig std semantics, not guard this call site — the byte-level repro (scriptable as a smoke check) is the regression net. Documented in `issue-stdout-redirect.md`.
