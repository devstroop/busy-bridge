# T5 sweep: SaveVchFromJson shape battery (bridge work-map lane T5).
# Seed -> shape/content battery (native-row capture) -> cleanup.
#   tests/probe/tasks/t5-savevch-walk.ps1 [-Comp COMP0001] [-SkipSeed]
param([string]$Comp = $(if ($env:BUSY_COMP) { $env:BUSY_COMP } else { 'COMP0001' }), [switch]$SkipSeed)
$ErrorActionPreference = 'Stop'
$repo = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$bb = Join-Path $repo 'zig-out\bin\busy-bridge.exe'
if (-not (Test-Path $bb)) { throw "bridge not built ($bb)" }
function ToB64([string]$s) { [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($s)) }
function CallM([string]$m, [string]$pid_, [string]$a) {
    (& $bb call --method $m --prog-id $pid_ --comp $Comp --args-b64 (ToB64 $a) 2>&1 | Out-String).Trim()
}
$vch = 0
if (-not $SkipSeed) {
    $jdoc = '{"type":"journal","date":"2026-04-08","doc":{"Journal":{"VchSeriesName":"Main","Date":"08-04-2026","VchType":"16","AccEntries":{"AccDetail":[{"SrNo":1,"AccountName":"Cash","AmountType":1,"AmtMainCur":22},{"SrNo":2,"AccountName":"Sales","AmountType":2,"AmtMainCur":22}]}}}}'
    $pr = (& $bb op post voucher --comp $Comp --json-b64 (ToB64 $jdoc) 2>&1 | Out-String | ConvertFrom-Json)
    if (-not $pr.ok) { throw ('seed failed: ' + $pr.error) }
    $vch = $pr.result.code
    Write-Output ('seeded vchcode=' + $vch)
}
$tail = ',{"$byref":"bstr"},0,false,"Admin",{"$collection":[]},false,""]'
$docs = [ordered]@{
    'empty'      = '{}'
    'main-series' = '{"VchType":9,"VchSeriesName":"Main","Date":"10/04/2026","MasterName1":"Zig Test Party"}'
    'zig-series'  = '{"VchType":9,"VchSeriesName":"ZigVch9","Date":"10/04/2026","MasterName1":"Zig Test Party"}'
    'ddmm-date'   = '{"VchType":9,"VchSeriesName":"Main","Date":"10-04-2026","MasterName1":"Zig Test Party"}'
    'fuller-keys' = '{"VchType":9,"VchSeriesName":"Main","Date":"10/04/2026","VchNo":"1","MasterName1":"Zig Test Party","SalePurcAccName":"Sales","ShortNar":"ZZ T5"}'
}
foreach ($k in $docs.Keys) {
    Write-Output ($k + ': ' + (CallM 'SaveVchFromJson' 'Busy2L21.CFixedInterface1' ('[{"$i2":9},' + ($docs[$k] | ConvertTo-Json -Compress) + $tail)))
}
if ($vch -gt 0) {
    $row = CallM 'GetJSONFromRecordset' 'Busy2L21.COtherServices1' ('["SELECT * FROM Tran1 WHERE VchCode=' + $vch + '",""]') | ConvertFrom-Json
    if ($row.ok) {
        $native = $row.result
        Write-Output ('native-row verbatim: ' + (CallM 'SaveVchFromJson' 'Busy2L21.CFixedInterface1' ('[{"$i2":16},' + ($native | ConvertTo-Json -Compress) + $tail)))
        $null = & $bb op delete voucher $vch --comp $Comp 2>&1
        Write-Output ('deleted seeded voucher ' + $vch)
    } else { Write-Output ('native capture failed: ' + $row.error) }
}
Write-Output ('Tran1 count: ' + ((& $bb query --comp $Comp --sql 'SELECT COUNT(*) AS n FROM Tran1' 2>&1 | Out-String | ConvertFrom-Json).rows[0].n))
