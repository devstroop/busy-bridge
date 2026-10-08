# 07 - Operations facade WRITES (issue #7, M2): master CRUD, voucher
#      posts (structured sale/journal + doc passthrough), batch
#      transactions with commit AND rollback, HTTP write routes.
#   powershell -File tests/live/07-ops-writes.ps1
#
# Prerequisites (fixture, created when missing; mirrors 04/06):
#   item group General (MasterType 5)  unit Pcs.  party Busy Infotech Pvt. Ltd.
#   MC Main Store   STPT Local-Exempt   series ZigVch9 (SALE)   item ZigItem
# Cleanup: all ZZ-prefixed fixtures are deleted by this script.
. (Join-Path $PSScriptRoot 'common.ps1')
$bb = $script:Bridge
$comp = $script:Comp

function QRows($sql) { (& $bb query --comp $comp --sql $sql) | ConvertFrom-Json }
function FirstCell($rows) {
    if ($rows.ok -and $rows.rows.Count -gt 0) { return $rows.rows[0].PSObject.Properties.Value | Select-Object -First 1 }
    return $null
}
function SaveMaster($type, $xml) {
    $a = To-B64 ("[" + $type + ',"' + $xml + '",{"$byref":""},false]')
    return (& $bb call --comp $comp --method SaveMasterFromXML --args-b64 $a) | ConvertFrom-Json
}
function OpJson([string]$verb, [string]$sub, [string]$json, [string]$name) {
    # op <verb> [kind] [name] --json-b64 ...
    $args = @('op', $verb)
    if ($sub) { $args += $sub }
    if ($name) { $args += $name }
    $args += @('--comp', $comp)
    if ($null -ne $json) { $args += @('--json-b64', (To-B64 $json)) }
    $out = (& $bb @args | Out-String)
    return @{ text = $out; json = ($out | ConvertFrom-Json); exit = $LASTEXITCODE }
}
function TryDelete([string]$kind, [string]$name) {
    $null = & $bb op delete $kind $name --comp $comp 2>&1
}

Write-Output '===== A. Master CRUD (CLI) ====='
TryDelete 'account' 'ZZ M2 T Acct'
TryDelete 'item' 'ZZ M2 T Itm'

$r = OpJson 'create' 'account' '{"parent":"Cash-in-hand"}' 'ZZ M2 T Acct'
Check 'create account -> ByRef code' ($r.exit -eq 0 -and $r.json.result.code -gt 0) $r.text
$acode = $r.json.result.code

$r = OpJson 'get' 'account' $null 'ZZ M2 T Acct'
Check 'get new account -> parent resolved' ($r.json.result.parent.name -eq 'Cash-in-hand') $r.text

$r = OpJson 'update' 'account' '{"parent":"Sundry Debtors"}' 'ZZ M2 T Acct'
Check 'update parent accepted' ($r.exit -eq 0 -and $r.json.result.parent -eq 'Sundry Debtors') $r.text

$r = OpJson 'get' 'account' $null 'ZZ M2 T Acct'
$doc = $r.json.result.doc.Account
Check 'update preserved untouched doc fields' `
    ($r.json.result.parent.name -eq 'Sundry Debtors' -and $doc.Name -eq 'ZZ M2 T Acct' -and $null -ne $doc.TaxType) $r.text

$r = OpJson 'create' 'item' '{"parent":"General","unit":"Pcs."}' 'ZZ M2 T Itm'
Check 'create item -> code' ($r.exit -eq 0 -and $r.json.result.code -gt 0) $r.text

$r = OpJson 'create' 'account' '{}' 'ZZ M2 NoParent'
Check 'create without parent -> bad_args' ($r.exit -eq 1 -and $r.json.code -eq 'bad_args' -and $r.json.error -like '*parent*') $r.text
$null = & $bb op delete account 'ZZ M2 NoParent' --comp $comp 2>&1

$r = OpJson 'delete' 'account' $null 'ZZ M2 T Acct'
Check 'delete account -> deleted:true' ($r.exit -eq 0 -and $r.json.result.deleted -eq $true) $r.text
$r = OpJson 'get' 'account' $null 'ZZ M2 T Acct'
Check 'deleted account gone (not_found)' ($r.exit -eq 1 -and $r.json.code -eq 'not_found') $r.text
$r = OpJson 'delete' 'item' $null 'ZZ M2 T Itm'
Check 'delete item' ($r.exit -eq 0 -and $r.json.result.deleted -eq $true) $r.text

Write-Output '===== B. Voucher posts (CLI) ====='
$r = OpJson 'post' $null '{"type":"journal","date":"2026-10-08","entries":[{"account":"Depreciation A/c","amount":75,"dr":true},{"account":"Cash","amount":75}]}' $null
Check 'post journal -> ByRef VchCode' ($r.exit -eq 0 -and $r.json.result.code -gt 0 -and $r.json.result.type.name -eq 'JOURNAL') $r.text
$jcode = $r.json.result.code

$o = (& $bb op get voucher $jcode --comp $comp | Out-String)
$g = ($o | ConvertFrom-Json).result
Check 'journal read back: root + scalars' ($g.root -eq 'Journal' -and $g.date -eq '2026-10-08') $o

$r = OpJson 'post' $null '{"type":"journal","date":"2026-10-08","entries":[{"account":"Cash","amount":10,"dr":true},{"account":"Sales","amount":9}]}' $null
Check 'unbalanced journal -> bad_args with sums' ($r.exit -eq 1 -and $r.json.code -eq 'bad_args' -and $r.json.error -like '*do not balance*') $r.text

$r = OpJson 'post' $null '{"type":"payment","date":"2026-10-08"}' $null
Check 'structured type without builder -> bad_args mentions doc' ($r.exit -eq 1 -and $r.json.error -like '*doc*') $r.text

$r = OpJson 'post' $null '{"type":"sale","date":"2026-10-08","series":"ZigVch9","no":"930","stpt":"Local-Exempt","party":"Busy Infotech Pvt. Ltd.","store":"Main Store","lines":[{"item":"ZigItem","qty":2,"price":100}]}' $null
Check 'post sale structured -> code + no' ($r.exit -eq 0 -and $r.json.result.code -gt 0 -and $r.json.result.no -eq '930') $r.text
$scode = $r.json.result.code

$o = (& $bb op get voucher $scode --comp $comp | Out-String)
$g = ($o | ConvertFrom-Json).result
Check 'sale read back: doc computed amounts (2x100)' `
    ($g.root -eq 'Sale' -and $g.no -eq '930' -and $g.doc.Sale.ItemEntries.ItemDetail.Amt -eq '200') $o

$o = (& $bb op list vouchers --comp $comp --type sale | Out-String)
$row = (($o | ConvertFrom-Json).result.items) | Select-Object -First 1
Check 'normalized list row (type/party/ISO date)' `
    ($row.type.name -eq 'SALE' -and $row.party.name -eq 'Busy Infotech Pvt. Ltd.' -and $row.date -eq '2026-10-08') $o

# doc passthrough: raw journal document for a non-structured path
$rawdoc = '{"type":"journal","date":"2026-10-08","doc":{"Journal":{"VchSeriesName":"Main","Date":"08-10-2026","VchType":"16","AccEntries":{"AccDetail":[{"SrNo":1,"AccountName":"Cash","AmountType":1,"AmtMainCur":15},{"SrNo":2,"AccountName":"Sales","AmountType":2,"AmtMainCur":15}]}}}}'
$r = OpJson 'post' $null $rawdoc $null
Check 'doc passthrough post (any type)' ($r.exit -eq 0 -and $r.json.result.code -gt 0) $r.text
$rcode = $r.json.result.code

$r = OpJson 'delete' 'voucher' $null ([string]$scode)
Check 'delete sale voucher' ($r.exit -eq 0 -and $r.json.result.deleted -eq $true) $r.text

Write-Output '===== C. Batch transactions ====='
$batch = '[{"op":"create-account","args":{"name":"ZZ Batch A","parent":"Cash-in-hand"}},{"op":"create-item","args":{"name":"ZZ Batch I","parent":"General","unit":"Pcs."}}]'
$r = OpJson 'batch' $null $batch $null
Check 'batch commit: both created' ($r.exit -eq 0 -and $r.json.result.committed -eq $true -and $r.json.result.count -eq 2) $r.text

$batch = '[{"op":"delete-account","args":{"name":"ZZ Batch A"}},{"op":"delete-item","args":{"name":"ZZ Batch I"}}]'
$r = OpJson 'batch' $null $batch $null
Check 'batch commit: both deleted' ($r.exit -eq 0 -and $r.json.result.committed -eq $true) $r.text
$after = (& $bb op get account 'ZZ Batch A' --comp $comp | Out-String)
Check 'batch-deleted account gone' (($after | ConvertFrom-Json).code -eq 'not_found') $after

$batch = '[{"op":"create-account","args":{"name":"ZZ Rollback Me","parent":"Cash-in-hand"}},{"op":"post-voucher","args":{"type":"journal","date":"2026-10-08","entries":[{"account":"Cash","amount":10,"dr":true},{"account":"Sales","amount":9}]}}]'
$r = OpJson 'batch' $null $batch $null
$errmsg = [string]$r.json.error
Check 'failed batch -> batch_rolled_back with entry context' `
    ($r.exit -eq 1 -and $r.json.code -eq 'batch_rolled_back' -and
     $errmsg.Contains('op[1]') -and $errmsg.Contains('do not balance')) $r.text
$after = (& $bb op get account 'ZZ Rollback Me' --comp $comp | Out-String)
Check 'rollback undid entry[0] (account never created)' (($after | ConvertFrom-Json).code -eq 'not_found') $after

$r = OpJson 'batch' $null '[{"op":"list-accounts","args":{}}]' $null
Check 'batch rejects read ops' ($r.exit -eq 1 -and $r.json.error -like '*batchable write op*') $r.text

Write-Output '===== D. HTTP write routes ====='
$job = Start-BridgeServe -Port 9847
$base = 'http://127.0.0.1:9847'

$r = Invoke-Http "$base/op/account" 'POST' 'application/json' '{"name":"ZZ Http A","parent":"Cash-in-hand"}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'POST /op/account -> 200 + code' ($r.st -eq 200 -and $p.result.code -gt 0) "st=$($r.st) $($r.body)"

$r = Invoke-Http "$base/op/account?name=ZZ Http A" 'PUT' 'application/json' '{"parent":"Sundry Creditors"}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'PUT /op/account -> updated' ($r.st -eq 200 -and $p.result.parent -eq 'Sundry Creditors') "st=$($r.st) $($r.body)"

$r = Invoke-Http "$base/op/voucher" 'POST' 'application/json' `
    '{"type":"sale","date":"2026-10-08","series":"ZZ NoSuchSeries","stpt":"Local-Exempt","party":"Busy Infotech Pvt. Ltd.","lines":[{"item":"ZigItem","qty":1,"price":10}]}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'BUSY rejects invalid series -> 422 busy_rejected' `
    ($r.st -eq 422 -and $p.code -eq 'busy_rejected' -and $r.body -like '*Invalid voucher series*') "st=$($r.st) $($r.body)"

$batch = '[{"op":"create-account","args":{"name":"ZZ Http Roll","parent":"Cash-in-hand"}},{"op":"post-voucher","args":{"type":"journal","date":"2026-10-08","entries":[{"account":"Cash","amount":5,"dr":true},{"account":"Sales","amount":4}]}}]'
$r = Invoke-Http "$base/op/batch" 'POST' 'application/json' $batch 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'HTTP batch rollback -> 422 batch_rolled_back' ($r.st -eq 422 -and $p.code -eq 'batch_rolled_back') "st=$($r.st) $($r.body)"
$r = Invoke-Http "$base/op/account?name=ZZ Http Roll" 'DELETE' 'application/json' $null $null
$p = $r.body | ConvertFrom-Json
Check 'rolled-back entry absent (DELETE -> 404)' ($r.st -eq 404 -and $p.code -eq 'not_found') "st=$($r.st)"

$r = Invoke-Http "$base/op/account?name=ZZ Http A" 'DELETE' 'application/json' $null $null
Check 'DELETE /op/account -> 200' ($r.st -eq 200) "st=$($r.st) $($r.body)"
$r = Invoke-Http "$base/op/account?name=ZZ Http A" 'DELETE' 'application/json' $null $null
$p = $r.body | ConvertFrom-Json
Check 'DELETE again -> 404 not_found' ($r.st -eq 404 -and $p.code -eq 'not_found') "st=$($r.st)"

$r = Invoke-Http "$base/op/account" 'PUT' 'application/json' '{"parent":"Cash-in-hand"}' 'application/json'
Check 'PUT without name -> 400' ($r.st -eq 400) "st=$($r.st)"

Stop-BridgeServe $job

Write-Output '===== E. Fixtures clean ====='
$left = QRows "SELECT COUNT(*) AS n FROM Master1 WHERE Name = 'ZZ M2 T Acct' OR Name = 'ZZ M2 T Itm' OR Name = 'ZZ Batch A' OR Name = 'ZZ Batch I' OR Name = 'ZZ Rollback Me' OR Name = 'ZZ Http A' OR Name = 'ZZ Http Roll'"
Check 'no ZZ fixtures left behind' ((FirstCell $left) -eq 0) ($left | ConvertTo-Json -Compress)

# exhaustive Tran1 cleanup: delete every remaining voucher this run can
# see (BUSY, notably, accepts journal entries for accounts that do not
# exist - it is not the validator of record)
$remaining = @()
$lv = (& $bb op list vouchers --comp $comp | Out-String) | ConvertFrom-Json
if ($lv.ok) { $remaining = @($lv.result.items | ForEach-Object { $_.code }) }
foreach ($c in $remaining) { $null = & $bb op delete voucher $c --comp $comp 2>&1 }
$vl = (& $bb op list vouchers --comp $comp | Out-String)
Check 'Tran1 empty after cleanup' ((($vl | ConvertFrom-Json).result.count) -eq 0) $vl

Finish-Tests '07-ops-writes'
