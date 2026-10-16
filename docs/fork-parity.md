# Fork parity (bridge ↔ server)

*Status: 2026-10-16. Enforces
[issue #63](https://github.com/devstroop/busy-bridge/issues/63); the
server-side companion is
[busy-server#8](https://github.com/devstroop/busy-server/issues/8).*

## Why

`src/handlers/**` and `src/transport/**` are **mirrored** between this
repo and `busy-server`: the same files, with the only legitimate
difference being `@import` rewrites (bridge imports `core`/`util`
relatively; server imports the shipped package:
`@import("busy_bridge").<module>`). The auth slice — the session gate,
token gate, raw-tier policy, rights — lives **entirely inside this
mirrored slice**, so a one-sided edit would silently diverge the two
security postures. This gate makes that impossible to land unnoticed.

## What the gate checks

`scripts/check_fork_parity.ps1` (PowerShell 5.1+, no zig/BUSY needed):

1. **Manifest completeness** — every file under `src/handlers` +
   `src/transport` must be classified in
   [`scripts/fork-parity-manifest.json`](../scripts/fork-parity-manifest.json):
   `pairs` (mirrored) or `bridge_only` (CLI/serve/replay live only here);
   a server-only file is always a violation.
2. **Imports-only normalization** — both sides are canonicalized (bridge
   relative `core|util` import paths and server `busy_bridge` modules map
   to the same canonical token) and compared. Equal ⇒ pass.
3. **Allowlist with pinned hashes** — real drift is allowed only with a
   manifest entry carrying a written `reason` **and** `bridge_sha256` /
   `server_sha256` pins of the canonical text. Any further edit to an
   allowlisted file fails until it is consciously re-pinned with
   `-UpdatePins`.
4. **Auth zero-tolerance** — the ten auth-slice files may never carry
   real drift, pinned or not.
5. **Unmapped import forms fail loudly** (exit 2): a new `lib.zig`
   export used from the server without extending `$module2path` in the
   script is a config error, never a silent pass.

## Current accounting (snapshot 2026-10-16, bridge b08b7e2 / server 55001a2)

37 mirrored pairs: 7 byte-identical, 26 imports-only, 4 pinned drift:

| File | Reason |
|---|---|
| `handlers/golden.zig` | T9 golden-read flow (#9 / PR #62) landed bridge-side; server port pending |
| `handlers/masters.zig` | T9 `listSql`/`keysetClause` re-exports; server port pending |
| `handlers/masters/read.zig` | T9 keyset pagination; server port pending |
| `transport/cli.zig` | by design: bridge CLI command surface vs server serve-only usage |

4 bridge-only files by design: `transport/commands.zig`,
`transport/commands/ops.zig`, `transport/commands/raw.zig`,
`transport/replay_suite.zig`.

## Running

```powershell
powershell scripts/check_fork_parity.ps1                     # sibling ../busy-server
powershell scripts/check_fork_parity.ps1 -ServerRoot <path>  # explicit (CI does this)
powershell scripts/check_fork_parity.ps1 -UpdatePins         # re-pin reviewed drift
powershell scripts/check_fork_parity.ps1 -InitManifest       # rebuild pair lists (keeps allowlist)
```

CI: the `fork-parity` job in `.github/workflows/ci.yml` checks out
`devstroop/busy-server` at its default branch and runs the gate — a
deliberate one-sided auth edit turns CI red (issue #63 acceptance).

## Relationship to the other gates

`check_layers.ps1` enforces import direction **inside** this repo; this
gate enforces **cross-repo identity** of the mirrored slice. Until the
package split ([issue #12](https://github.com/devstroop/busy-bridge/issues/12))
deduplicates the fork, every mirrored change must land in **both** repos
(port discipline) — the gate is the safety net, and it **retires when
the split dedups the slice**.
