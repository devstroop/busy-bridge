# Regenerate docs/operations.md from the single-source catalog table
# (src/core/ops/catalog.zig) via `busy-bridge op catalog`.
#   powershell -File scripts/docs/generate-ops-doc.ps1
$ErrorActionPreference = 'Stop'
$repo = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$exe = Join-Path $repo 'zig-out\bin\busy-bridge.exe'
if (-not (Test-Path $exe)) { throw "busy-bridge not built - run 'zig build' in $repo" }

$body = & $exe op catalog
if ($LASTEXITCODE -ne 0) { throw 'op catalog failed' }

$header = @'
# Operations API catalog (generated)

**Do not edit by hand** - regenerate with:

    powershell -File scripts/docs/generate-ops-doc.ps1

Source of truth: `src/core/ops/catalog.zig` (the same table serves
`busy-bridge op catalog` and `GET /op`). Overview: repository README,
section "Operations API".
'@

$md = $header + "`n`n" + (@($body) -join "`n") + "`n"
$out = Join-Path $repo 'docs\operations.md'
Set-Content -Path $out -Value $md -Encoding UTF8
Write-Output "wrote $out"
