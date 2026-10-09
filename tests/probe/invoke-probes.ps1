# BUSY-001 — probe orchestrator: one child process per COM primitive,
# hard timeout + kill (UI traps), uniform capture. See README.md.
# Capture uses PIPE redirects (System.Diagnostics.Process): file-based
# Start-Process redirects corrupt output — bridge writes land at file
# position 0 (separate bug, to be filed); pipes are position-free.
param(
    [string]$Bridge = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'zig-out\bin\busy-bridge.exe'),
    [string]$Manifest = (Join-Path $PSScriptRoot 'probes.json'),
    [string]$Comp = 'COMP0001',
    [int]$DefaultTimeout = 25,
    [string]$Filter = ''
)
$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

if (-not (Test-Path $Bridge)) { throw "bridge not built - run zig build ($Bridge)" }
$run = Join-Path $PSScriptRoot ('results\' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $run -Force | Out-Null
$mf = Get-Content $Manifest -Raw | ConvertFrom-Json
$probes = @($mf.probes | Where-Object { $_.id -match $Filter })
if ($probes.Count -eq 0) { throw "no probes matched filter '$Filter'" }

$summary = @()
foreach ($p in $probes) {
    # -InputObject: piping an empty array to ConvertTo-Json yields nothing.
    $b64 = [Convert]::ToBase64String(
        [Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject $p.args -Compress -Depth 6)))
    $argStr = "call --method $($p.method) --args-b64 $b64"
    if ($p.progId) { $argStr += " --prog-id $($p.progId)" }
    if ($p.useComp) { $argStr += " --comp $Comp" }
    $to = if ($p.timeoutSec) { [int]$p.timeoutSec } else { $DefaultTimeout }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $Bridge
    $psi.Arguments = $argStr
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $proc = [Diagnostics.Process]::Start($psi)
    $outTask = $proc.StandardOutput.ReadToEndAsync()
    $errTask = $proc.StandardError.ReadToEndAsync()
    $exited = $proc.WaitForExit($to * 1000)
    $status = $null
    if (-not $exited) {
        $proc.Kill()               # UI trap or hung COM - killed, recorded
        $proc.WaitForExit(5000)
        $status = 'TIMEOUT'
    }
    $sw.Stop()
    $stdout = $outTask.Result
    $stderr = $errTask.Result
    $exit = $proc.ExitCode
    $parsed = $null
    try { $parsed = $stdout | ConvertFrom-Json } catch { }
    if (-not $status) {
        $status = if ($parsed -and $parsed.ok) { 'OK' }
                  elseif ($parsed) { 'REFUSED' } else { 'UNPARSEABLE' }
    }
    $match = if (-not $p.expect -or $p.expect -eq 'any') { 'n/a' }
             elseif ($p.expect -eq $status) { 'MATCH' } else { 'MISMATCH' }
    $rec = [ordered]@{
        id = $p.id; issue = $p.issue; group = $p.group; method = $p.method
        useComp = [bool]$p.useComp; args = $p.args
        status = $status; expect = $p.expect; match = $match
        exitCode = $exit; durationMs = [int]$sw.ElapsedMilliseconds
        result = $parsed; stdout = $stdout; stderr = $stderr
        notes = $p.notes
    }
    $rec | ConvertTo-Json -Depth 12 | Set-Content (Join-Path $run "$($p.id).json") -Encoding UTF8
    $summary += [pscustomobject]$rec
    Write-Output ("{0,-8} {1,-32} {2} ({3} ms){4}" -f $status, $p.id, $p.method,
        [int]$sw.ElapsedMilliseconds, $(if ($match -eq 'MISMATCH') { " !!expected $($p.expect)" } else { '' }))
}
$summary | ConvertTo-Json -Depth 12 | Set-Content (Join-Path $run 'summary.json') -Encoding UTF8
$counts = $summary | Group-Object status | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Output ''
Write-Output "probe run complete: $($summary.Count) probes -> $run"
Write-Output ("statuses: " + ($counts -join ' '))
$bad = @($summary | Where-Object { $_.match -eq 'MISMATCH' })
if ($bad.Count -gt 0) { Write-Output "MISMATCH: $($bad.Count) (see summary.json)" }
