# 010 · Release artifacts & real versioning

**Labels:** `ops` · **Effort:** S · **Status:** open · **Milestone:** H3
**Blocked by:** a GitHub remote (push was deferred at session end)

## Problem

- `version` reports a hardcoded `0.1.0` (baked at compile time via
  `comptime`), unrelated to any tag.
- There is no remote, no tags, no CHANGELOG — the only distribution path is
  cloning this folder and running `zig build`.
- Nothing proves the CI actually passes on GitHub (it was written but never
  run against the service).

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

- [ ] CI green on the GitHub remote (all jobs: fmt, layers, build, tests, smoke).
- [ ] `busy-bridge version` shows tag-derived version + short commit.
- [ ] `v0.1.0` tagged; release page carries checksummed artifact.
- [ ] CHANGELOG covers 0.1.0; `docs/README.md` links release/download instructions.
- [ ] Reproducible: fresh clone + `zig build` yields the released binary behavior (no hidden local state).

## Notes

Also resolves the long-standing open item: push was skipped at session end
only because `gh` was unauthenticated — nothing technical blocks this.
