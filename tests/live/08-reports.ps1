# 08 - Named reports (issue #7, M3): account/group/trial balances and
#      stock status as operations — with a non-zero end-to-end proof
#      (post a journal, watch balances move, verify debit == credit,
#      delete, watch them return to zero).
#   powershell -File tests/live/08-reports.ps1
#
# Prerequisites (fixture, created when missing): account group structure
# (DEMO roots), account "Depreciation A/c", account "Cash", item ZigItem
# (stock 0). Cleanup: journal voucher removed by this script.
. (Join-Path $PSScriptRoot 'common.ps1')
$bb = $script:Bridge
$comp = $script:Comp

function OpJson([string]$verb, [string]$sub, [string]$json, [string]$name) {
    $args = @('op', $verb)
    if ($sub) { $args += $sub }
    if ($name) { $args += $name }
    $args += @('--comp', $comp)
    if ($null -ne $json) { $args += @('--json-b64', (To-B64 $json)) }
    $out = (& $bb @args | Out-String)
    return @{ text = $out; json = ($out | ConvertFrom-Json); exit = $LASTEXITCODE }
}
function Report([string]$name, [hashtable]$flags) {
    $args = @('op', 'report', $name, '--comp', $comp)
    foreach ($k in $flags.Keys) { $args += @("--$k", [string]$flags[$k]) }
    $out = (& $bb @args | Out-String)
    return @{ text = $out; json = ($out | ConvertFrom-Json); exit = $LASTEXITCODE }
}

Write-Output '===== A. Baseline (empty FY) ====='
$r = Report 'account-balance' @{ name = 'Cash'; from = '2026-04-01'; to = '2027-03-31' }
Check 'account-balance Cash -> envelope + zeros' `
    ($r.exit -eq 0 -and $r.json.result.kind -eq 'account-balance' -and $r.json.result.code -eq 1 -and
     $r.json.result.opening -eq 0 -and $r.json.result.closing -eq 0 -and $r.json.result.from -eq '2026-04-01') $r.text

$r = Report 'account-balance' @{ name = 'No Such Acc'; from = '2026-04-01'; to = '2027-03-31' }
Check 'missing account -> not_found' ($r.exit -eq 1 -and $r.json.code -eq 'not_found') $r.text

$r = Report 'account-balance' @{ name = 'Cash'; from = 'junk' }
Check 'bad date -> bad_args with YYYY-MM-DD hint' ($r.exit -eq 1 -and $r.json.code -eq 'bad_args' -and $r.json.error -like '*YYYY-MM-DD*') $r.text

$r = Report 'flux-capacitor' @{}
Check 'unknown report -> bad_args lists reports' ($r.exit -eq 1 -and $r.json.error -like '*stock-status*') $r.text

$r = Report 'stock-status' @{ date = '2026-10-09' }
Check 'stock-status: ZigItem present, qty numeric (0 on hand)' `
    ($r.exit -eq 0 -and $r.json.result.count -ge 1 -and
     (@($r.json.result.items | Where-Object { $_.name -eq 'ZigItem' }).Count -eq 1) -and
     ($r.json.result.items | Where-Object { $_.name -eq 'ZigItem' }).qty_main -eq 0) $r.text

$r = Report 'stock-status' @{ date = '2026-10-09'; q = 'zzz-no-match' }
Check 'stock-status q filter -> empty + truncated flag present' `
    ($r.exit -eq 0 -and $r.json.result.count -eq 0 -and $r.json.result.truncated -eq $false) $r.text

Write-Output '===== B. Non-zero proof: journal moves balances ====='
$post = OpJson 'post' $null '{"type":"journal","date":"2026-08-15","entries":[{"account":"Depreciation A/c","amount":500,"dr":true},{"account":"Cash","amount":500}]}' $null
Check 'posted journal (Dr Depreciation / Cr Cash 500)' ($post.exit -eq 0 -and $post.json.result.code -gt 0) $post.text
$vcode = 0
if ($post.exit -eq 0) { $vcode = $post.json.result.code }

$r = Report 'account-balance' @{ name = 'Cash'; from = '2026-04-01'; to = '2027-03-31' }
$cashClose = $r.json.result.closing
Check 'Cash balance moved (nonzero closing)' ($r.exit -eq 0 -and [double]$cashClose -ne 0) $r.text

$r2 = Report 'account-balance' @{ name = 'Depreciation A/c'; from = '2026-04-01'; to = '2027-03-31' }
$depClose = $r2.json.result.closing
Check 'Depreciation A/c balance moved (nonzero closing)' ($r2.exit -eq 0 -and [double]$depClose -ne 0) $r2.text
Check 'balances oppose (Cash vs Depreciation)' ([double]$cashClose -ne [double]$depClose) "cash=$cashClose dep=$depClose"

$r = Report 'group-balance' @{ group = 'Current Assets'; from = '2026-04-01'; to = '2027-03-31' }
$movement = [double]$r.json.result.debit + [double]$r.json.result.credit
Check 'group-balance Current Assets shows 500 movement' `
    ($r.exit -eq 0 -and [math]::Abs($movement - 500) -lt 0.01) $r.text

$r = Report 'trial-balance' @{ from = '2026-04-01'; to = '2027-03-31' }
$tb = $r.json.result
Check 'trial-balance: 10 root groups' ($r.exit -eq 0 -and $tb.count -eq 10 -and $tb.items.Count -eq 10) $r.text
# BUSY's debit column is SIGNED (a debit leg surfaced as -500 at the
# Revenue Accounts root) — the accounting invariant is dr == -cr.
Check 'trial-balance: signed totals balance (dr == -cr, nonzero)' `
    ([math]::Abs([double]$tb.totals.debit + [double]$tb.totals.credit) -lt 0.01 -and
     [math]::Abs([double]$tb.totals.debit) -gt 0) ($r.text.Substring(0, [Math]::Min(300, $r.text.Length)))
# sum of root movements equals totals
$sumDebit = ($tb.items | ForEach-Object { [double]$_.debit } | Measure-Object -Sum).Sum
Check 'totals equal sum of root rows' ([math]::Abs($sumDebit - [double]$tb.totals.debit) -lt 0.01) "sum=$sumDebit total=$($tb.totals.debit)"

Write-Output '===== C. Cleanup returns balances to zero ====='
if ($vcode -gt 0) {
    $del = OpJson 'delete' 'voucher' $null ([string]$vcode)
    Check 'journal deleted' ($del.exit -eq 0 -and $del.json.result.deleted -eq $true) $del.text
}
$r = Report 'account-balance' @{ name = 'Cash'; from = '2026-04-01'; to = '2027-03-31' }
Check 'Cash back to zero after delete' ($r.exit -eq 0 -and $r.json.result.closing -eq 0) $r.text
$r = Report 'trial-balance' @{ from = '2026-04-01'; to = '2027-03-31' }
Check 'trial totals back to zero' ($r.exit -eq 0 -and [double]$r.json.result.totals.debit -eq 0) $r.text

Write-Output '===== D. HTTP reports ====='
$job = Start-BridgeServe -Port 9849
$base = 'http://127.0.0.1:9849'

$r = Invoke-Http "$base/op/report/trial-balance?from=2026-04-01&to=2027-03-31" 'GET' 'application/json' $null $null
$p = ($r.body | ConvertFrom-Json).result
Check 'GET /op/report/trial-balance -> 10 groups' ($r.st -eq 200 -and $p.count -eq 10) "st=$($r.st)"

$r = Invoke-Http "$base/op/report/account-balance?name=Cash&from=2026-04-01&to=2027-03-31" 'GET' 'application/json' $null $null
$p = ($r.body | ConvertFrom-Json).result
Check 'GET account-balance -> code1 + zeros' ($r.st -eq 200 -and $p.code -eq 1 -and $p.closing -eq 0) "st=$($r.st)"

$r = Invoke-Http "$base/op/report/stock-status?date=2026-10-09&item=ZigItem" 'GET' 'application/json' $null $null
$p = ($r.body | ConvertFrom-Json).result
Check 'GET stock-status item filter' ($r.st -eq 200 -and $p.count -eq 1) "st=$($r.st)"

$r = Invoke-Http "$base/op/report/account-balance?name=Cash" 'GET' 'application/json' $null $null
$p = $r.body | ConvertFrom-Json
Check 'missing params -> 400 bad_args' ($r.st -eq 400 -and $p.code -eq 'bad_args') "st=$($r.st)"

$r = Invoke-Http "$base/op/report/bogus" 'GET' 'application/json' $null $null
Check 'unknown report -> 400' ($r.st -eq 400) "st=$($r.st)"

$r = Invoke-Http "$base/op/report/group-balance?group=Cash-in-hand&from=2026-04-01&to=2027-03-31" 'GET' 'application/xml' $null $null
Check 'Accept xml -> <Op> envelope' ($r.st -eq 200 -and $r.body.StartsWith('<Op><name>group-balance</name>')) $r.body

Stop-BridgeServe $job
Finish-Tests '08-reports'
