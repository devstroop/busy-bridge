# T4 sweep: day-book/ledger COM-getter layout (bridge work-map lane T4).
# Seed -> sweep -> cleanup so empty-company {} cannot mask layout answers.
#   tests/probe/tasks/t4-daybook-layout.ps1 [-Comp COMP0001] [-SkipSeed]
# Needs the built bridge CLI (busy-bridge.exe). Deletes what it seeds via
# `op delete-voucher`; verify Tran1 count afterwards. One run at a time.
param([string]$Comp = $(if ($env:BUSY_COMP) { $env:BUSY_COMP } else { 'COMP0001' }), [switch]$SkipSeed)
$ErrorActionPreference = 'Stop'
$repo = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$bb = Join-Path $repo 'zig-out\bin\busy-bridge.exe'
if (-not (Test-Path $bb)) { throw "bridge not built ($bb)" }

function ToB64([string]$s) { [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($s)) }
function CallM([string]$method, [string]$progId, [string]$jsonArgs) {
    & $bb call --method $method --prog-id $progId --comp $Comp --args-b64 (ToB64 $jsonArgs) 2>&1 | Out-String
}
function PostJ([string]$iso, [string]$ddmm) {
    $doc = '{"type":"journal","date":"' + $iso + '","doc":{"Journal":{"VchSeriesName":"Main","Date":"' + $ddmm + '","VchType":"16","AccEntries":{"AccDetail":[{"SrNo":1,"AccountName":"Cash","AmountType":1,"AmtMainCur":15},{"SrNo":2,"AccountName":"Sales","AmountType":2,"AmtMainCur":15}]}}}}'
    (& $bb op post voucher --comp $Comp --json-b64 (ToB64 $doc) 2>&1 | Out-String)
}
function TranCount() {
    $o = & $bb query --comp $Comp --sql 'SELECT COUNT(*) AS n FROM Tran1' 2>&1 | Out-String | ConvertFrom-Json
    $o.rows[0].n
}

$codes = @()
if (-not $SkipSeed) {
    Write-Output '== seed: two journals in window 2026-04'
    foreach ($p in @(@('2026-04-05', '05-04-2026'), @('2026-04-10', '10-04-2026'))) {
        $r = (PostJ $p[0] $p[1]).Trim() | ConvertFrom-Json
        if (-not $r.ok) { throw ('seed failed: ' + $r.error) }
        $codes += $r.result.code
        Write-Output ('  posted vchcode=' + $r.result.code)
    }
}
Write-Output ('Tran1 count before sweep: ' + (TranCount))

$tail = ',{"$byref":"bstr"},false,{"$date":"2026-04-30"}]'
$layouts = [ordered]@{
    'party/type/user/vtdate' = '[{"$collection":["Zig Test Party","Sale","Admin",{"$date":"2026-04-01"},{"$date":"2026-04-30"}]}' + $tail
    'int16-first'            = '[{"$collection":[16,"","Admin",{"$date":"2026-04-01"},{"$date":"2026-04-30"}]}' + $tail
    'int0-first'             = '[{"$collection":[0,"","Admin",{"$date":"2026-04-01"},{"$date":"2026-04-30"}]}' + $tail
    'date-first-min'         = '[{"$collection":[{"$date":"2026-04-01"},{"$date":"2026-04-30"},"Admin","",""]}' + $tail
    'str-dates'              = '[{"$collection":[16,"","Admin","01/04/2026","30/04/2026"]}' + $tail
    'identity-pos1-refused'  = '[{"$collection":["Admin",{"$date":"2026-04-01"},{"$date":"2026-04-30"},"Zig Test Party","Sale"]}' + $tail
}
foreach ($k in $layouts.Keys) {
    $o = (CallM 'GetAccDayBookJSON' 'Busy2L21.COtherServices1' $layouts[$k]).Trim()
    if ($o.Length -gt 200) { $o = $o.Substring(0, 200) + '...' }
    Write-Output ('daybook ' + $k + ': ' + $o)
}
$ledger = '[{"$collection":["x","x","Admin","y"]},{"$byref":"bstr"},0.0,false,{"$date":"2026-04-30"},false,false]'
Write-Output ('ledger tail-pinned: ' + (CallM 'GetAccLedgerJSON' 'Busy2L21.COtherServices1' $ledger).Trim())

if (-not $SkipSeed) {
    foreach ($c in $codes) {
        $null = & $bb op delete voucher $c --comp $Comp 2>&1
        Write-Output ('deleted seeded voucher ' + $c)
    }
    Write-Output ('Tran1 count after cleanup: ' + (TranCount))
}
