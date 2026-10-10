# Runs every live-BUSY test script sequentially (separate processes so
# each gets clean state and reports its own exit code).
#   powershell -File tests/live/run-all.ps1
$ErrorActionPreference = 'Continue'
$here = $PSScriptRoot
$scripts = @(
    '01-roundtrip.ps1',
    '02-serve-defaults.ps1',
    '03-wire-modes.ps1',
    '04-voucher-roundtrip.ps1',
    '05-query-guard.ps1',
    '06-ops-reads.ps1',
    '07-ops-writes.ps1',
    '08-reports.ps1',
    '09-auth.ps1',
    '10-multi-company.ps1',
    '11-v1.ps1',
    '12-report-rights.ps1'
)
$failed = 0
foreach ($t in $scripts) {
    Write-Output ''
    Write-Output "========== $t =========="
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $here $t)
    if ($LASTEXITCODE -ne 0) { $failed++ }
}
Write-Output ''
if ($failed -gt 0) {
    Write-Output "RUN-ALL: $failed of $($scripts.Count) script(s) FAILED"
    exit 1
}
Write-Output "RUN-ALL: all $($scripts.Count) live scripts passed"
exit 0
