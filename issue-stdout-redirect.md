# Issue: stdout file-redirect corruption — every `printOut` writes at file offset 0

**Title suggestion:** `CLI: file-redirected stdout is corrupted (each printOut writes at offset 0; pipes/consoles OK)`
**Labels suggestion:** `bug`, `cli`, `tests`
**Affected versions:** 0.1.0 (repro on `7222024`, the PR #50 merge base; any build of this CLI with Zig 0.17.0 std.Io). Windows repro below; on POSIX the same positional-write pattern would corrupt identically (`pwrite` at offset 0).

## Summary

When stdout is redirected to a **file**, busy-bridge corrupts its own output:
every write lands at **file position 0**, so multi-call outputs overwrite
their own beginning (the trailing `"\n"` eats the opening `{` of the JSON
error envelope; the `unknown command:` prefix is replaced by the Usage
text). Pipes and consoles are unaffected, which is why the probe harness
— which captures via pipes — never saw it (`docs/probe/2026-10-09-headless-contracts.md`
§1.8). Single-write commands (`version`, `help`) happened to be correct
because one write at offset 0 into a fresh file is the same as an append.

## Repro (PowerShell 5.1, from the worktree root)

> NOTE: plain `>` in PS 5.1 writes **UTF-16**; use `cmd /c` for a raw
> byte-accurate redirect.

```powershell
$exe = "$PWD\zig-out\bin\busy-bridge.exe"

# 1) error envelope (two printOut calls: payload, then "\n")
cmd /c "`"$exe`" classes --out bogus > out.txt"

# observed (pre-fix) — first byte of out.txt:
[Convert]::ToHexString([IO.File]::ReadAllBytes('out.txt')[0..0])   # -> 0A  (LF!)
# expected:
#                                                              7B  ('{')
# out.txt length 79, pipe capture length 80 (trailing \n missing)

# 2) unknown command (four printOut calls)
cmd /c "`"$exe`" frobnicate > out2.txt"
[Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes('out2.txt')[0..23])
# observed (pre-fix): "busy-bridge - programmatic in"   <- Usage text
# expected:            "unknown command: frobnicate"
```

### Byte evidence (pre-fix, commit 7222024 + this worktree's unmodified source)

| command | redirect (`cmd /c >`) | pipe capture | identical? |
|---|---|---|---|
| `version` | len 72, `62 75 73 79 ...` ("busy-bridge 0.1.0-...") | len 72, same bytes | yes (single write) |
| `help` | len 2975 = Usage | len 2975, same | yes (single write) |
| `frobnicate` | len 2975 = **Usage only**, first byte `62` ('b') | len 3004, starts `75 6e 6b 6e 6f 77 6e ...` = "unknown command: frobnicate\n\n" + Usage | **NO** |
| `classes --out bogus` | len 79, **first byte `0a`**, last bytes `22 7d` (`"}`) | len 80, first byte `7b` (`{`), last bytes `22 7d 0a` (`"}\n`) | **NO** |

The `{`-eaten-by-trailing-newline symptom from report §1.8 is exactly the
second row: `fail()` calls `printOut(json)` then `printOut("\n")`; the
second call writes 1 byte at offset 0, turning `{"ok":false,...}` into
`\n"ok":false,...`.

## Root cause

`src/util/helpers.zig` — `printOut()` created a **fresh**
`Io.File.stdout().writer(io, &buf)` on every call:

```zig
var w = Io.File.stdout().writer(io, &buf);   // Writer.init -> mode = .positional, pos = 0
```

`.positional` mode flushes through
`io.vtable.fileWritePositional(..., offset = w.pos = 0)`; on Windows the
Threaded backend (`std/Io/Threaded.zig`, `writeFilePositionalWindows`)
calls `NtWriteFile(..., ByteOffset = 0)` — an **absolute** file offset,
independent of the file object's current position. So each `printOut`
call rewrites from byte 0. Pipes and consoles are not regular files: the
kernel ignores the explicit `ByteOffset`, so they advanced sequentially
and were unaffected (and the probe harness only ever used pipes). On
POSIX the equivalent path is `pwrite(..., offset=0)` with the same
result.

## Proposed fix (applied in this branch, left uncommitted for the operator)

One-line core change in `printOut` — use the **streaming** writer, which
passes `ByteOffset = NULL` and therefore appends at the file object's
current position:

```zig
var w = Io.File.stdout().writerStreaming(io, &buf);
```

Alternative/backup options if this regresses: a single buffered writer
kept for the process lifetime (one write per command), or a
`GetFileType` check that falls back to console-style sequential writes
for `FILE_TYPE_DISK`.

### Verification (all done, evidence in `docs/probe/fragments/t11-stdout-redirect.md`)

- Redirect output is now byte-identical to pipe output for `version`,
  `help`, `frobnicate`, `classes --out bogus` (first byte of the error
  envelope is `7b` again; `unknown command: ` prefix restored).
- Pipe captures of `version` and `help` (plus the two multi-call cases)
  are byte-identical before/after the fix (SHA-256 compared) — no change
  for pipes/consoles.
- Gates: `zig fmt --check`, `zig build`, `zig build test` (148/148),
  `scripts/check_tests.ps1`, `scripts/check_layers.ps1`,
  `scripts/check_size.ps1` — all green.

## Why no unit test

The corruption only manifests when the *process* stdout handle is a
regular file; the `zig test` harness's stdout is a pipe (or captured),
and `printOut` writes to the real process stdout handle which cannot be
swapped in-process. A test writing to a temp file through
`File.writer`/`writerStreaming` would only re-assert Zig std semantics,
not guard this call site. The regression is covered by the byte-level
repro above, which is scriptable as a smoke check if desired.
