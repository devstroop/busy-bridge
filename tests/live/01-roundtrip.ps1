# 01 - JSON master CRUD round-trip against a live company.
#   powershell -File tests/live/01-roundtrip.ps1
. (Join-Path $PSScriptRoot 'common.ps1')
$Name = 'ZigBridgeTest'

$xml = '<Account><Name>' + $Name + '</Name><PrintName>' + $Name + '</PrintName><ParentGroup>Cash-in-hand</ParentGroup><Address><OF /><CountryName>India</CountryName><StateName>Delhi</StateName></Address><SupplierType>1</SupplierType><PriceLevel>@</PriceLevel><PriceLevelForPurc>@</PriceLevelForPurc><TaxType>Others</TaxType><TypeOfDealerGST>Un-Registered</TypeOfDealerGST><ReverseChargeType>Not Applicable</ReverseChargeType><InputType>Section 17(5)-ITC None</InputType></Account>'
$saveArgs = To-B64 ('["2","' + $xml + '",{"$byref":""},false]')
# note: '2' = ACCOUNT_MASTER (master/voucher code tables: GET /constants)

Write-Output 'STEP 1: pre-check (must be empty)'
$pre = (& $script:Bridge query --comp $script:Comp --sql "SELECT Code FROM Master1 WHERE Name = '$Name'") | ConvertFrom-Json
Check 'no leftover master from a previous run' ($pre.rows.Count -eq 0) ($pre | ConvertTo-Json -Compress)

Write-Output 'STEP 2: SaveMasterFromXML (create)'
$save = (& $script:Bridge call --comp $script:Comp --method SaveMasterFromXML --args-b64 $saveArgs) | ConvertFrom-Json
Check 'save succeeded' ($save.ok -and ($save.result -eq $true)) ($save | ConvertTo-Json -Compress)

Write-Output 'STEP 3: verify created'
$created = (& $script:Bridge query --comp $script:Comp --sql "SELECT Code, Name FROM Master1 WHERE Name = '$Name'") | ConvertFrom-Json
Check 'master exists with expected name' ($created.rows.Count -eq 1 -and $created.rows[0].Name -eq $Name) ($created | ConvertTo-Json -Compress)
$code = $created.rows[0].Code

if ($code) {
    Write-Output 'STEP 4: read back via GetMasterXML'
    $back = (& $script:Bridge call --comp $script:Comp --method GetMasterXML --args-b64 (To-B64 "[$code, false]")) | ConvertFrom-Json
    # result is a structured tree in JSON mode (Phase 3) — serialize before matching
    $backText = $back | ConvertTo-Json -Depth 6 -Compress
    Check 'XML round-trip contains the name' ($back.ok -and ($backText -like "*$Name*")) $backText.Substring(0, [Math]::Min(200, $backText.Length))

    Write-Output 'STEP 5: DeleteMasterByCode'
    $del = (& $script:Bridge call --comp $script:Comp --method DeleteMasterByCode --args-b64 (To-B64 "[$code, {`"`$byref`":`"`"}]")) | ConvertFrom-Json
    Check 'delete succeeded' ($del.ok -and ($del.result -eq $true)) ($del | ConvertTo-Json -Compress)

    Write-Output 'STEP 6: verify gone'
    $gone = (& $script:Bridge query --comp $script:Comp --sql "SELECT Code FROM Master1 WHERE Name = '$Name'") | ConvertFrom-Json
    Check 'master removed' ($gone.rows.Count -eq 0) ($gone | ConvertTo-Json -Compress)
}

Finish-Tests '01-roundtrip'
