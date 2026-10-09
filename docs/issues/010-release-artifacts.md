# 010 · Release artifacts & real versioning

**Labels:** `ops` · **Effort:** S · **Status:** in progress (release flow
shipped 2026-10-09; version-from-git + CHANGELOG landing) · **Milestone:** H3
**Blocked by:** a GitHub remote (push was deferred at session end)

## Problem

- `version` reported a hardcoded `0.1.0` (baked at compile time via
  `comptime`), unrelated to any tag — now git-derived (see proposal 2).
- There was no remote, no tags, no CHANGELOG — the only distribution path
  was cloning this folder and running `zig build`. Remote, `v0.1.0`, and
  the tag-triggered release workflow now exist.
- Nothing proved the CI actually passed on GitHub (it was written but never
  run against the service) — CI + Release are both green on the remote.

## Proposal

1. **Push** the repo (`gh auth login` → `gh repo create busy-bridge --private
   --source . --push`) — CI runs on push; fix whatever the first real run finds.
2. **Version from git**: build step injects version+commit
   (`build.zig` → `build options` module fed by `git describe --tags --always --dirty`);
   `version` prints `busy-bridge x.y.z (commit abc1234, zig …)`.
3. **Release flow**: annotated tags `vX.Y.Z` → CI release job attaches
   the x86-windows `.exe` + `SHA256SUMS` to the GitHub release (cross-compiled
   artifact from the Linux job is also possible — decide: Windows-native build
   is the safer provenance).
4. **CHANGELOG.md** (Keep-a-Changelog shape) seeded from the commit history
   (7 commits currently tell the whole story).

## Acceptance criteria

- [x] CI green on the GitHub remote (all jobs: fmt, layers, build, tests, smoke).
- [ ] `busy-bridge version` shows tag-derived version + short commit
      (implemented; green CI run pending on merge).
- [x] `v0.1.0` tagged; release page carries checksummed artifact.
- [x] CHANGELOG covers 0.1.0; `docs/README.md` links release/download instructions.
- [x] Reproducible: fresh clone + `zig build` yields the released binary behavior (no hidden local state).

## Notes

Also resolves the long-standing open item: push was skipped at session end
only because `gh` was unauthenticated — nothing technical blocks this.
