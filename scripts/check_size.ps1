# File-size gate (issue 011 - source restructure).
#
# Modes:
#   powershell scripts/check_size.ps1              # ENFORCE (default): exit 1 on violations
#   powershell scripts/check_size.ps1 -ReportOnly  # preview: full report, always exit 0
#
# Limits:
#   src/**/*.zig    fail > 400 lines; warn > 300 lines
#   tests/**/*.ps1  fail > 200 lines (tests split together with their subject)
#
# Every exemption needs a WHY. Two kinds, both live in $exempt:
#   [transitional] - issue 011 phase entry; DELETE it in the same commit as
#                    the phase that splits the file (the list only shrinks)
#   [by design]    - permanent; structure chosen deliberately
param([switch]$ReportOnly)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$src = Join-Path $root 'src'
$tests = Join-Path $root 'tests'

$srcFailLimit = 400
$srcWarnLimit = 300
$testFailLimit = 200

$exempt = @{
    # --- transitional: issue 011 phases (delete the entry when the phase lands) ---
    'src/transport/http.zig'     = '[transitional] issue 011 phase 5: route() split into http/{shared,routes_meta,routes_raw,routes_ops}.zig'
    'src/transport/commands.zig' = '[transitional] issue 011 phase 4: cmd* split into commands/{raw,ops}.zig'
    'src/transport/format.zig'   = '[transitional] issue 011 phase 3: split into format/{wire,call,xml_envelopes}.zig'
    # --- by design (permanent) ---
    'src/util/xml/parse.zig'     = '[by design] single cohesive parse state machine, fixtures-tested as a unit; splitting would fragment it'
    'src/core/ops/reports.zig'   = '[by design] named report operations, one probe-verified call pattern each; single responsibility'
}

$violations = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$exempted = New-Object System.Collections.Generic.List[string]
$scanned = 0

function Evaluate-File([string]$fullPath, [int]$failLimit, [int]$warnLimit, [string]$rel) {
    $script:scanned++
    $lines = [IO.File]::ReadAllLines($fullPath).Length
    if ($lines -le $warnLimit) { return }
    $why = $script:exempt[$rel]
    if ($null -ne $why) {
        if ($lines -gt $failLimit) {
            $script:exempted.Add(("{0,-32} {1,4} lines  {2}" -f $rel, $lines, $why))
        }
        return
    }
    if ($lines -gt $failLimit) {
        $script:violations.Add(("{0} - {1} lines (limit {2}); over-limit files must be split (docs/issues/011-source-restructure.md) or carry an exemption with a written reason" -f $rel, $lines, $failLimit))
    } else {
        $script:warnings.Add(("{0} - {1} lines (warn threshold {2})" -f $rel, $lines, $warnLimit))
    }
}

Get-ChildItem -Path $src -Recurse -Filter *.zig | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1) -replace '\\', '/'
    Evaluate-File $_.FullName $srcFailLimit $srcWarnLimit $rel
}
if (Test-Path $tests) {
    Get-ChildItem -Path $tests -Recurse -Filter *.ps1 | ForEach-Object {
        $rel = $_.FullName.Substring($root.Length + 1) -replace '\\', '/'
        Evaluate-File $_.FullName $testFailLimit $testFailLimit $rel
    }
}

if ($exempted.Count -gt 0) {
    Write-Output 'EXEMPT (documented):'
    foreach ($e in $exempted) { Write-Output "  $e" }
}
if ($warnings.Count -gt 0) {
    Write-Output 'WARN (approaching the limit):'
    foreach ($w in $warnings) { Write-Output "  $w" }
}
Write-Output ("scanned {0} file(s)" -f $scanned)

if ($violations.Count -gt 0) {
    Write-Output "SIZE GATE FAILED ($($violations.Count)):"
    foreach ($v in $violations) { Write-Output "  $v" }
    if ($ReportOnly) {
        Write-Output '(report-only: exit 0 regardless)'
        exit 0
    }
    exit 1
}
Write-Output 'size gate OK'
exit 0
