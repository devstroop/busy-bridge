# Replay count gate (issue 009 companion to check_tests.ps1).
#
# `zig build replay-test` runs the host-native binary: the replay entry
# plus the replay suites plus the pure json/xml suites it imports
# (2 + 9 + 18 = 29). Like check_tests, this asserts the EXACT count so a
# silently dropped suite turns CI red instead of green.
#
#   powershell scripts/check_replay.ps1            # enforce (default)
#   powershell scripts/check_replay.ps1 -ReportOnly  # print count, exit 0
#
# NOTE: both test binaries are named test.exe — run this right after
# `zig build replay-test` (as CI does) so the newest binary is the replay
# one. Never run check_tests and check_replay concurrently.
param([switch]$ReportOnly)

$ErrorActionPreference = 'Stop'
$repo = Resolve-Path (Join-Path $PSScriptRoot '..')

# 2 entry blocks (src/replay.zig + transport/replay_suite.zig) + 9 replay
# suites (core/com/replay/tests.zig) + 18 pure json/xml suites pulled in
# via top-level imports. Update in the same commit as any intentional
# add/remove — the diff makes the intent reviewable.
$Expected = 29

Push-Location $repo
try {
    zig build replay-test
    if ($LASTEXITCODE -ne 0) { Write-Output "check_replay: zig build replay-test FAILED (exit $LASTEXITCODE)"; exit 1 }

    # The replay artifact is named replay_test.exe (build.zig) so it can
    # never be confused with the main suite's test.exe in the shared
    # cache dir (last build wins there — a cached replay build used to
    # make this gate read the main binary's count).
    $exe = Get-ChildItem -Recurse -Path (Join-Path $repo '.zig-cache') -Filter 'replay_test.exe' -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $exe) { Write-Output 'check_replay: replay_test.exe not found in .zig-cache'; exit 1 }

    $ErrorActionPreference = 'Continue'
    $out = & $exe.FullName 2>&1 | Out-String
    $exe_exit = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    if ($exe_exit -ne 0) { Write-Output $out; Write-Output "check_replay: test binary exited $exe_exit"; exit 1 }

    if ($out -notmatch 'All (\d+) tests passed') {
        Write-Output $out
        Write-Output 'check_replay: could not parse the test summary line'
        exit 1
    }
    $actual = [int]$Matches[1]
    Write-Output "check_replay: $actual/$Expected replay tests passed"

    if ($actual -ne $Expected) {
        if ($ReportOnly) {
            Write-Output "check_replay: count differs from $Expected (report-only: exit 0)"
            exit 0
        }
        Write-Output "check_replay FAILED: ran $actual tests, expected $Expected."
        Write-Output 'An unintentional drop means a suite fell out of the replay root;'
        Write-Output 'an intentional change means updating $Expected here.'
        exit 1
    }
    Write-Output 'check_replay OK'
    exit 0
} finally {
    Pop-Location
}
