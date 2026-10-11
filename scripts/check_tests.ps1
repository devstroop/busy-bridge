# Test-discovery gate (issue 011 lesson, separation-readiness).
#
# `zig build test` discovers tests only through test-block references —
# a file can silently drop out of an aggregation block and its tests just
# stop running while everything else stays green (26 tests were lost this
# way for months; found only by counting). This gate asserts the EXACT
# number of discovered tests.
#
#   powershell scripts/check_tests.ps1          # enforce (default)
#   powershell scripts/check_tests.ps1 -ReportOnly   # print count, exit 0
#
# When you ADD or REMOVE tests on purpose, update $Expected in the same
# commit — the diff makes the intent reviewable.
param([switch]$ReportOnly)

$ErrorActionPreference = 'Stop'
$repo = Resolve-Path (Join-Path $PSScriptRoot '..')

# Keep in sync with the test blocks (src/transport/format.zig aggregation
# + src/handlers.zig aggregation + per-file tests). Includes the 9 replay
# suites (issue 009) aggregated via format.zig; the 2 replay entry blocks
# live only in the host replay binary (see check_replay.ps1, expects 29).
# History: 82 (iteration-4) -> 83 (+byrefKindFromMarker, typed ByRef).
# 89 -> 91 (+daybook.zig: oleDay, splitDrCr).
# 91 -> 93 (+rights.zig: repIdForName, canViewReport).
# 94 -> 95 (+recordinfo.zig: shapeFromName, the $record shape knob).
# 95 -> 139 (main 95 + lib_surface_test 44: src/lib.zig package surface
#            smoke suites + the pure core/util suites its re-exports pull
#            in — same tests the main aggregation runs, plus 3 new).
$Expected = 139

# 1) canonical run (cached when nothing changed; fails fast with zig's own
#    failure output if any test fails)
Push-Location $repo
try {
    zig build test
    if ($LASTEXITCODE -ne 0) { Write-Output "check_tests: zig build test FAILED (exit $LASTEXITCODE)"; exit 1 }

    # 2) count: run the freshly built test binaries directly — the build
    #    runner hides the summary on cache hits, the binaries never do.
    #    Two binaries exist: the main suite (test.exe) and the package
    #    surface suite (lib_surface_test.exe — src/lib.zig belongs to the
    #    busy_bridge module and cannot ride the executable's root).
    #    PS 5.1 caveat: redirected native stderr becomes ErrorRecords that
    #    throw under EAP=Stop — the runner prints progress on stderr, so
    #    relax the preference around these invocations.
    $bins = [ordered]@{ 'test.exe' = $null; 'lib_surface_test.exe' = $null }
    foreach ($name in @($bins.Keys)) {
        $bins[$name] = Get-ChildItem -Recurse -Path (Join-Path $repo '.zig-cache') -Filter $name -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if (-not $bins[$name]) { Write-Output "check_tests: $name not found in .zig-cache"; exit 1 }
    }

    $ErrorActionPreference = 'Continue'
    $actual = 0
    foreach ($name in @('test.exe', 'lib_surface_test.exe')) {
        $out = & $bins[$name].FullName 2>&1 | Out-String
        $exe_exit = $LASTEXITCODE
        if ($exe_exit -ne 0) {
            $ErrorActionPreference = 'Stop'
            Write-Output $out
            Write-Output "check_tests: $name exited $exe_exit"
            exit 1
        }
        if ($out -notmatch 'All (\d+) tests passed') {
            $ErrorActionPreference = 'Stop'
            Write-Output $out
            Write-Output "check_tests: could not parse the test summary line of $name"
            exit 1
        }
        $actual += [int]$Matches[1]
    }
    $ErrorActionPreference = 'Stop'
    Write-Output "check_tests: $actual/$Expected discovered tests passed"

    if ($actual -ne $Expected) {
        if ($ReportOnly) {
            Write-Output "check_tests: count differs from $Expected (report-only: exit 0)"
            exit 0
        }
        Write-Output "check_tests FAILED: discovered $actual tests, expected $Expected."
        Write-Output 'A drop means a file fell out of an aggregation block (see docs/architecture.md'
        Write-Output '"Test discovery"); an intentional change means updating $Expected here.'
        exit 1
    }
    Write-Output 'check_tests OK'
    exit 0
} finally {
    Pop-Location
}
