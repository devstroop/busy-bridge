# 06 - Operations facade reads (issue #7, M1): normalized CRUD with
#      mechanical internals, exercised on CLI + HTTP in both wire formats.
#   powershell -File tests/live/06-ops-reads.ps1
#
# Prerequisites (fixture — created when missing; mirrors 04):
#   item group General (MasterType 5)  unit Pcs.  party Busy Infotech Pvt. Ltd.
#   MC Main Store   STPT Local-Exempt   series ZigVch9 (SALE, stored 09ZigVch9)
#   item ZigItem
# Raw tier must stay byte-identical: suites 01-05 are the regression gate.
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

Write-Output '===== A. CLI reads ====='
$o = (& $bb op catalog | Out-String)
Check 'op catalog lists all ops' ($o.Contains('get-voucher') -and $o.Contains('GET /op/vouchers')) $o

$o = (& $bb op list accounts --comp $comp --limit 2 | Out-String)
$p = ($o | ConvertFrom-Json).result
Check 'list accounts: limit honored + truncated flag' ($p.count -eq 2 -and $p.truncated -eq $true -and $p.items[0].parent.name) $o

$o = (& $bb op list accounts --comp $comp --q cash --limit 10 | Out-String)
$p = ($o | ConvertFrom-Json).result
Check 'q filter finds Cash with resolved parent' `
    ($p.count -ge 1 -and $p.items[0].name -eq 'Cash' -and $p.items[0].parent.name -eq 'Cash-in-hand') $o

$o = (& $bb op get account 'Depreciation A/c' --comp $comp | Out-String)
$p = ($o | ConvertFrom-Json).result
Check 'get account: identity + parent + doc tree (no XML blob)' `
    ($p.kind -eq 'account' -and $p.code -gt 0 -and $p.parent.name -and $p.doc.Account.Name -eq 'Depreciation A/c') $o

$o = (& $bb op list items --comp $comp | Out-String)
$p = ($o | ConvertFrom-Json).result
$names = @($p.items | ForEach-Object { $_.name })
Check 'list items contains fixture ZigItem' ($names -contains 'ZigItem') $o

$o = (& $bb op get item ZigItem --comp $comp | Out-String)
$p = ($o | ConvertFrom-Json).result
Check 'get item: doc carries unit + group' `
    ($p.code -eq 1289 -and $p.parent.name -eq 'General' -and $p.doc.Item.MainUnit -eq 'Pcs.') $o

$o = (& $bb op list vouchers --comp $comp --type nope | Out-String)
$p = $o | ConvertFrom-Json
Check 'bad voucher type -> bad_args' ($LASTEXITCODE -eq 1 -and $p.code -eq 'bad_args') $o

$o = (& $bb op get account 'No Such Thing' --comp $comp | Out-String)
$p = $o | ConvertFrom-Json
Check 'missing account -> not_found' ($LASTEXITCODE -eq 1 -and $p.code -eq 'not_found') $o

$o = (& $bb op get voucher notanint --comp $comp | Out-String)
$p = $o | ConvertFrom-Json
Check 'non-integer voucher code -> bad_args' ($LASTEXITCODE -eq 1 -and $p.code -eq 'bad_args') $o

$o = (& $bb op list accounts --comp $comp --limit 1 --out xml | Out-String)
Check 'XML mode: <Op> envelope' ($o.StartsWith('<Op><name>list-accounts</name><result>')) $o

Write-Output '===== B. Voucher normalization round-trip ====='
$grp = QRows "SELECT Code FROM Master1 WHERE MasterType = 5 AND Name = 'General'"
Check 'fixture: item group General' ($null -ne (FirstCell $grp)) ($grp | ConvertTo-Json -Compress)
$item = QRows "SELECT Code FROM Master1 WHERE MasterType = 6 AND Name = 'ZigItem'"
if ($null -eq (FirstCell $item)) {
    $im = SaveMaster 6 '<Item><Name>ZigItem</Name><ParentGroup>General</ParentGroup><MainUnit>Pcs.</MainUnit></Item>'
    Check 'fixture: created ZigItem' ($im.ok -and $im.result -eq $true) ($im | ConvertTo-Json -Compress)
}
$series = QRows "SELECT Code FROM Master1 WHERE MasterType = 21 AND Name = '09ZigVch9'"
if ($null -eq (FirstCell $series)) {
    $cs = (& $bb call --comp $comp --method CreateVchSeries --args-b64 (To-B64 '["ZigVch9",9]')) | ConvertFrom-Json
    Check 'fixture: created series ZigVch9' ($cs.ok -and ($cs.result -gt 0)) ($cs | ConvertTo-Json -Compress)
}

$sale = '<Sale><VchSeriesName>ZigVch9</VchSeriesName><Date>08-10-2026</Date><VchType>9</VchType>' +
        '<VchNo>902</VchNo><STPTName>Local-Exempt</STPTName>' +
        '<MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>' +
        '<ItemEntries><ItemDetail><SrNo>1</SrNo><ItemName>ZigItem</ItemName><UnitName>Pcs.</UnitName>' +
        '<Qty>1</Qty><Price>100</Price><Amt>100</Amt>' +
        '<STAmount>0</STAmount><STPercent>0</STPercent><TaxBeforeSurcharge>0</TaxBeforeSurcharge>' +
        '<MC>Main Store</MC></ItemDetail></ItemEntries></Sale>'
$sv = (& $bb call --comp $comp --method SaveVchFromXML --args-b64 (To-B64 ('[9,"' + $sale + '",{"$byref":""},false]'))) | ConvertFrom-Json
Check 'posted SALE voucher (raw write path)' ($sv.ok -and $sv.result -eq $true) ($sv | ConvertTo-Json -Compress)

if ($sv.result -eq $true) {
    $o = (& $bb op list vouchers --comp $comp --type sale | Out-String)
    $p = ($o | ConvertFrom-Json).result
    $vch = $p.items | Select-Object -First 1
    Check 'list vouchers: normalized row (type/party/series/date resolved)' `
        ($p.count -eq 1 -and $vch.type.name -eq 'SALE' -and $vch.no -eq '902' -and
         $vch.party.name -eq 'Busy Infotech Pvt. Ltd.' -and $vch.series.name -eq '09ZigVch9' -and
         $vch.date -eq '2026-10-08') $o

    $o = (& $bb op get voucher $vch.code --comp $comp | Out-String)
    $g = ($o | ConvertFrom-Json).result
    Check 'get voucher: scalars + doc tree + ISO date' `
        ($g.code -eq $vch.code -and $g.root -eq 'Sale' -and $g.no -eq '902' -and
         $g.party -eq 'Busy Infotech Pvt. Ltd.' -and $g.date -eq '2026-10-08' -and
         $null -ne $g.doc.Sale.ItemEntries) $o

    $del = (& $bb call --comp $comp --method DeleteVchByCode --args-b64 (To-B64 "[$($vch.code), {`"`$byref`":`"`"}]")) | ConvertFrom-Json
    Check 'cleanup: DeleteVchByCode' ($del.ok -and $del.result -eq $true) ($del | ConvertTo-Json -Compress)
    $after = (& $bb op list vouchers --comp $comp | Out-String)
    Check 'Tran1 empty again via op list' (((($after | ConvertFrom-Json).result.count)) -eq 0) $after
}

Write-Output '===== C. HTTP facade ====='
$job = Start-BridgeServe -Port 9845
$base = 'http://127.0.0.1:9845'

$r = Invoke-Http "$base/op" 'GET' 'application/json' $null $null
$p = $r.body | ConvertFrom-Json
Check 'GET /op -> catalog with all operations' `
    ($r.st -eq 200 -and $p.op -eq 'catalog' -and $p.result.operations.Count -ge 7) "st=$($r.st)"

$r = Invoke-Http "$base/op/accounts?limit=2" 'GET' 'application/json' $null $null
$p = ($r.body | ConvertFrom-Json).result
Check 'GET /op/accounts?limit=2 -> 2 rows + truncated' `
    ($r.st -eq 200 -and $p.count -eq 2 -and $p.truncated -eq $true) "st=$($r.st)"

$r = Invoke-Http "$base/op/account?name=Cash" 'GET' 'application/json' $null $null
$p = ($r.body | ConvertFrom-Json).result
Check 'GET /op/account?name=Cash -> code + parent' `
    ($r.st -eq 200 -and $p.code -eq 1 -and $p.parent.name -eq 'Cash-in-hand') "st=$($r.st)"

$r = Invoke-Http "$base/op/items" 'GET' 'application/json' $null $null
$p = ($r.body | ConvertFrom-Json).result
Check 'GET /op/items -> ZigItem' `
    ($r.st -eq 200 -and (@($p.items | Where-Object { $_.name -eq 'ZigItem' }).Count -eq 1)) "st=$($r.st)"

$r = Invoke-Http "$base/op/vouchers" 'GET' 'application/json' $null $null
$p = ($r.body | ConvertFrom-Json).result
Check 'GET /op/vouchers -> empty list is ok:true' ($r.st -eq 200 -and $p.count -eq 0) "st=$($r.st)"

$r = Invoke-Http "$base/op/voucher?code=999999" 'GET' 'application/json' $null $null
$p = $r.body | ConvertFrom-Json
Check 'GET /op/voucher missing -> 404 not_found' ($r.st -eq 404 -and $p.code -eq 'not_found') "st=$($r.st)"

$r = Invoke-Http "$base/op/account" 'GET' 'application/json' $null $null
$p = $r.body | ConvertFrom-Json
Check 'GET /op/account without name -> 400 bad_args' ($r.st -eq 400 -and $p.code -eq 'bad_args') "st=$($r.st)"

$r = Invoke-Http "$base/op/accounts?limit=1" 'GET' 'application/xml' $null $null
Check 'Accept xml -> <Op> envelope with result' ($r.st -eq 200 -and $r.body.StartsWith('<Op><name>list-accounts</name><result>')) $r.body

$r = Invoke-Http "$base/info" 'GET' 'application/json' $null $null
$p = $r.body | ConvertFrom-Json
Check '/info routes include /op' ($p.routes -contains '/op') ($p.routes -join ',')

Stop-BridgeServe $job
Finish-Tests '06-ops-reads'
