# Generates docs/function-reference.md from the LIVE BUSY type library via
# `busy-bridge surface` — the current, authoritative replacement for the
# 2017-era "BUSY Functions.docx". Regenerate after BUSY upgrades:
#
#   powershell -File scripts/docs/generate-function-reference.ps1
#
# Default: the core integration classes. -All adds every registered Busy*
# class detail (large). Single class: -ProgId Busy2L21.CFixedInterface
param(
    [string]$Exe,
    [string]$Out = (Join-Path $PSScriptRoot '..\..\docs\function-reference.md'),
    [switch]$All
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

if (-not $Exe) { $Exe = (Join-Path $PSScriptRoot '..\..\zig-out\bin\busy-bridge.exe') }
if (-not (Test-Path $Exe)) { throw "busy-bridge not built: $Exe (run zig build first)" }
$Exe = (Resolve-Path $Exe).Path

$core = @(
    'Busy2L21.CFixedInterface', 'Busy2L21.CFixedInterface1',
    'Busy2L21.CMasterServices', 'Busy2L21.CTranServices',
    'Busy2L21.COtherServices', 'Busy2L21.COtherServices1',
    'Busy2L21.CBCServices', 'Busy2L21.CIBCServices',
    'Busy2L21.CUMSServices', 'Busy2L21.CVATServices',
    'Busy2LA21.CServices_2LA', 'Busy2LB21.CServices_2LB',
    'Busy2LZ21.CADOServices',
    'BusyExt21.CMasterServices', 'BusyExt21.CTranServices', 'BusyExt21.COtherServices'
)

$targets = $core
if ($All) {
    $idx = (& $Exe classes) | ConvertFrom-Json
    $targets = $idx.classes
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# BUSY function reference (generated)')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('<!-- GENERATED FILE — do not edit. Regenerate with:')
[void]$sb.AppendLine('     powershell -File scripts/docs/generate-function-reference.ps1 -->')
[void]$sb.AppendLine('')
[void]$sb.AppendLine("Generated from the live type library of BUSY Rel 14 on $(Get-Date -Format yyyy-MM-dd)")
[void]$sb.AppendLine('via `busy-bridge surface`. This replaces the 2017-era *BUSY Functions.docx*:')
[void]$sb.AppendLine('every signature below is exactly what the installed BUSY exposes today.')
[void]$sb.AppendLine('')

$total = 0
$indexRows = @()
foreach ($p in $targets) {
    $json = & $Exe surface --prog-id $p
    if ($LASTEXITCODE -ne 0) { Write-Warning "surface failed: $p"; continue }
    $s = $json | ConvertFrom-Json
    $n = $s.members.Count
    $total += $n
    $indexRows += "| [$p](#$(($p.ToLower() -replace '[^a-z0-9]+', '-').Trim('-'))) | $n |"
}

[void]$sb.AppendLine("## Index ($($targets.Count) classes, $total members)")
[void]$sb.AppendLine('')
[void]$sb.AppendLine('| Class | Members |')
[void]$sb.AppendLine('|---|---|')
foreach ($r in $indexRows) { [void]$sb.AppendLine($r) }
[void]$sb.AppendLine('')

foreach ($p in $targets) {
    $json = & $Exe surface --prog-id $p
    if ($LASTEXITCODE -ne 0) { continue }
    $s = $json | ConvertFrom-Json
    [void]$sb.AppendLine("## $($s.prog_id)")
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('| Member | Kind | Params | N | Opt |')
    [void]$sb.AppendLine('|---|---|---|---|---|')
    foreach ($m in $s.members) {
        $params = ($m.params -join ', ')
        [void]$sb.AppendLine("| ``$($m.name)`` | $($m.kind) | $params | $($m.nparams) | $($m.nopt) |")
    }
    [void]$sb.AppendLine('')
}

New-Item -ItemType Directory -Force -Path (Split-Path $Out) | Out-Null
[IO.File]::WriteAllText($Out, $sb.ToString(), (New-Object Text.UTF8Encoding $false))
Write-Output "wrote $Out ($total members across $($targets.Count) classes)"
