# 04 - Voucher write round-trip (SALE) against a live company — closes #6.
#   powershell -File tests/live/04-voucher-roundtrip.ps1
#
# Prerequisites in DEMO (verified present; items/series created by this
# script when missing):
#   group    General (item group, MasterType 5)   unit  Pcs.
#   party    Busy Infotech Pvt. Ltd.       MC       Main Store
#   STPT     Local-Exempt (GST-exempt -> no tax computation in the test)
#   series   ZigVch9 (SALE-specific; created via CreateVchSeries)
#   item     ZigItem (created via SaveMasterFromXML)
#
# Also documents GetRecordset semantics (issue #6 part 1): BUSY returns
# no_recordset for ANY unrunnable SQL (missing table OR missing column),
# and returns an empty recordset (rows:[]) for successful empty results.
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

Write-Output '===== A. GetRecordset semantics (documented in com-xml-interface.md) ====='
$okEmpty = QRows "SELECT TOP 1 VchCode FROM Tran1"                 # empty Tran1 -> rows:[]
Check 'successful query on empty table -> rows:[]' ($okEmpty.ok -and $okEmpty.rows.Count -eq 0) ($okEmpty | ConvertTo-Json -Compress)
$badCol = QRows "SELECT MissingCol FROM Master1"                    # bad column -> no_recordset
Check 'missing column -> no_recordset (silent SQL failure)' (-not $badCol.ok -and $badCol.code -eq 'no_recordset') ($badCol | ConvertTo-Json -Compress)
$badTbl = QRows "SELECT TOP 1 X FROM NoSuchTableX"                  # bad table -> same
Check 'missing table -> no_recordset' (-not $badTbl.ok -and $badTbl.code -eq 'no_recordset') ($badTbl | ConvertTo-Json -Compress)
$cnt = QRows "SELECT COUNT(*) AS n FROM Tran1"                      # aggregates still work
Check 'COUNT(*) on empty table -> n=0' ($cnt.ok -and $cnt.rows[0].n -eq 0) ($cnt | ConvertTo-Json -Compress)

Write-Output '===== B. Prerequisites ====='
$grp = QRows "SELECT Code FROM Master1 WHERE MasterType = 5 AND Name = 'General'"
Check 'item group General exists' ($null -ne (FirstCell $grp)) ($grp | ConvertTo-Json -Compress)
$item = QRows "SELECT Code FROM Master1 WHERE MasterType = 6 AND Name = 'ZigItem'"
if ($null -eq (FirstCell $item)) {
    $im = SaveMaster 6 '<Item><Name>ZigItem</Name><ParentGroup>General</ParentGroup><MainUnit>Pcs.</MainUnit></Item>'
    Check 'created item ZigItem' ($im.ok -and $im.result -eq $true) ($im | ConvertTo-Json -Compress)
} else {
    Check 'item ZigItem present' $true "code=$(FirstCell $item)"
}
# Voucher series are stored prefixed with the 2-digit type: '09ZigVch9'.
$series = QRows "SELECT Code FROM Master1 WHERE MasterType = 21 AND Name = '09ZigVch9'"
if ($null -eq (FirstCell $series)) {
    $cs = (& $bb call --comp $comp --method CreateVchSeries --args-b64 (To-B64 '["ZigVch9",9]')) | ConvertFrom-Json
    Check 'created SALE series ZigVch9' ($cs.ok -and ($cs.result -gt 0)) ($cs | ConvertTo-Json -Compress)
} else {
    Check 'series ZigVch9 present' $true "code=$(FirstCell $series)"
}

Write-Output '===== C. SALE voucher via SaveVchFromXML ====='
$sale = '<Sale><VchSeriesName>ZigVch9</VchSeriesName><Date>08-10-2026</Date><VchType>9</VchType>' +
        '<VchNo>901</VchNo><STPTName>Local-Exempt</STPTName>' +
        '<MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>' +
        '<ItemEntries><ItemDetail><SrNo>1</SrNo><ItemName>ZigItem</ItemName><UnitName>Pcs.</UnitName>' +
        '<Qty>1</Qty><Price>100</Price><Amt>100</Amt>' +
        '<STAmount>0</STAmount><STPercent>0</STPercent><TaxBeforeSurcharge>0</TaxBeforeSurcharge>' +
        '<MC>Main Store</MC></ItemDetail></ItemEntries></Sale>'
$saveArgs = To-B64 ('[9,"' + $sale + '",{"$byref":""},false]')
$sv = (& $bb call --comp $comp --method SaveVchFromXML --args-b64 $saveArgs) | ConvertFrom-Json
Check 'SaveVchFromXML accepted' ($sv.ok -and ($sv.result -eq $true)) ($sv | ConvertTo-Json -Compress)

if ($sv.result -eq $true) {
    Write-Output '===== D. Verify in Tran1 ====='
    $v = QRows "SELECT TOP 1 VchCode, VchType, VchNo FROM Tran1 ORDER BY VchCode"
    Check 'Tran1 has the voucher' ($v.ok -and $v.rows.Count -eq 1 -and $v.rows[0].VchType -eq 9) ($v | ConvertTo-Json -Compress)
    $code = $v.rows[0].VchCode

    Write-Output '===== E. Read back GetVchXML (JSON mode = tree) ====='
    $back = (& $bb call --comp $comp --method GetVchXML --args-b64 (To-B64 "[$code, false]")) | ConvertFrom-Json
    $backText = $back | ConvertTo-Json -Depth 8 -Compress
    Check 'voucher XML read back contains item + party' ($back.ok -and $backText -like '*ZigItem*' -and $backText -like '*Busy Infotech*') $backText.Substring(0, [Math]::Min(220, $backText.Length))

    Write-Output '===== F. XML mode read (raw passthrough) ====='
    $raw = (& $bb call --comp $comp --method GetVchXML --args-b64 (To-B64 "[$code, false]") --out xml) -join "`n"
    Check 'xml mode passthrough' ($raw.StartsWith('<Sale') -and $raw -like '*ZigItem*') $raw.Substring(0, [Math]::Min(160, $raw.Length))

    Write-Output '===== G. Delete + verify gone ====='
    $del = (& $bb call --comp $comp --method DeleteVchByCode --args-b64 (To-B64 "[$code, {`"`$byref`":`"`"}]")) | ConvertFrom-Json
    Check 'DeleteVchByCode' ($del.ok -and ($del.result -eq $true)) ($del | ConvertTo-Json -Compress)
    $gone = QRows "SELECT VchCode FROM Tran1"
    Check 'Tran1 empty again' ($gone.ok -and $gone.rows.Count -eq 0) ($gone | ConvertTo-Json -Compress)
}

Finish-Tests '04-voucher-roundtrip'
