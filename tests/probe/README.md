# Headless COM probe harness (BUSY-001)

Runs each target BUSY COM primitive in a **child process** with a hard
timeout, capturing the result envelope, ByRef `outs`, exit code and
duration — so a UI-raising or hung call can be killed without taking
down anything else. Foundation for the P0 contract probes (BUSY-002
login/rights, BUSY-003 write contracts, BUSY-004 reads/sessions).

## Safety rules

- **One BUSY session per company data dir.** Stop `busy-bridge serve`
  and close the BUSY GUI before running. The harness opens `COMP0001`
  (DEMO) by default.
- Write probes use throwaway names (`ZZ Probe Temp`) and include their
  own cleanup probes in the manifest.
- UI-trap probes (`SelectUser`, `AskYesNo`, `ShowMsg`) run with a short
  timeout; `TIMEOUT` is the expected, recorded outcome (then killed).

## Usage

```powershell
# build the bridge first: zig build
powershell -NoProfile -File tests\probe\invoke-probes.ps1
powershell -NoProfile -File tests\probe\invoke-probes.ps1 -Filter 'login-|rights-'
powershell -NoProfile -File tests\probe\invoke-probes.ps1 -Comp DEMO -DefaultTimeout 40
```

Results land in `tests/probe/results/<timestamp>/` (one JSON per
probe + `summary.json`). Findings are distilled into
`docs/probe/`; fixtures are committed under `fixtures/` when they
become contract evidence (BUSY-00x acceptance).

## Manifest

`probes.json` — `{ meta, probes[] }`; each probe:

| field | meaning |
|---|---|
| `id` / `issue` / `group` / `notes` | bookkeeping (issues = proposed BUSY-0xx ids) |
| `method` | COM method name on `CFixedInterface` (default class) |
| `args` | JSON array passed to `--args-b64`; `{"$byref":""}` = out-param |
| `useComp` | open COMP0001 via `OpenDB` before invoking |
| `timeoutSec` | per-probe override (UI traps: 8s) |
| `expect` | `any` (discovery) · `OK` · `REFUSED` · `TIMEOUT` |

Discovery probes deliberately guess argument shapes (`{}` documents,
empty collections): the captured error text *is* the finding — refine
the manifest iteratively and keep superseded results as the trail.

## Fixture credentials

String args of the form `"@env:VAR"` expand to environment variables
before the probe runs — **credentials never enter the repo**
(GitGuardian-clean by design; a missing variable fails the probe with
a clear message). The live login fixtures need:

```powershell
$env:BUSY_PROBE_ADMIN_PW = '<admin password>'
$env:BUSY_PROBE_USER1_PW = '<user1 password>'
powershell -File tests\probe\invoke-probes.ps1 -Filter 'vupw-'
```
