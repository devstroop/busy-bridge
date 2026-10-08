# 03 - Request-scoped pure JSON/XML (both transports, both modes).
#   powershell -File tests/live/03-wire-modes.ps1
. (Join-Path $PSScriptRoot 'common.ps1')
$bb = $script:Bridge
$comp = $script:Comp
$base = 'http://127.0.0.1:9820'

Write-Output '===== CLI: JSON mode (default) structurizes XML results ====='
$r = (& $bb call --comp $comp --method GetCompConfigXML --args '[false]') | ConvertFrom-Json
Check 'JSON result is a tree (not an XML string)' ($r.result -is [System.Management.Automation.PSCustomObject]) ($r | ConvertTo-Json -Depth 3 -Compress)
Check 'tree has Company root' ($null -ne $r.result.Company) (($r | ConvertTo-Json -Depth 3 -Compress).Substring(0, 120))

Write-Output '===== CLI: --out xml ====='
$x = (& $bb call --comp $comp --method GetCompConfigXML --args '[false]' --out xml) -join "`n"
Check 'xml-out passthrough is raw doc' ($x.StartsWith('<Company>')) $x.Substring(0, [Math]::Min(80, $x.Length))
$xc = (& $bb classes --out xml) -join "`n"
Check 'classes XML shape' ($xc.StartsWith("<Classes count='")) $xc.Substring(0, [Math]::Min(80, $xc.Length))
$xs = (& $bb surface --member OpenDB --out xml) -join "`n"
Check 'surface XML shape + filter' ($xs.Contains("<Surface prog_id='Busy2L21.CFixedInterface' count='1'") -and $xs.Contains("<Member name='OpenDB'")) $xs.Substring(0, [Math]::Min(120, $xs.Length))
$xq = (& $bb query --comp $comp --sql "SELECT TOP 2 Code, Name FROM Master1" --out xml) -join "`n"
Check 'query rowset (legacy SC=1 shape)' ($xq.Contains("xmlns:rs='urn:schemas-microsoft-com:rowset'") -and $xq.Contains('<z:row')) $xq.Substring(0, [Math]::Min(120, $xq.Length))
$xe = (& $bb query --comp $comp --sql "SELECT * FROM NoSuchTable" --out xml) -join "`n"
Check 'xml error envelope + machine code + exit code' (($LASTEXITCODE -eq 1) -and $xe.StartsWith("<Error code='1' error='no_recordset'>")) "exit=$LASTEXITCODE body=$xe"

Write-Output '===== CLI: JSON-object XML argument (xmlify) round-trip ====='
$obj = '{"Account":{"Name":"ZigPhase3","PrintName":"ZigPhase3","ParentGroup":"Cash-in-hand","Address":{"OF":null,"CountryName":"India","StateName":"Delhi"},"SupplierType":"1","PriceLevel":"@","PriceLevelForPurc":"@","TaxType":"Others","TypeOfDealerGST":"Un-Registered","ReverseChargeType":"Not Applicable","InputType":"Section 17(5)-ITC None"}}'
$save = '[2,' + $obj + ',{"$byref":""},false]'
$s = (& $bb call --comp $comp --method SaveMasterFromXML --args-b64 (To-B64 $save)) -join "`n"
$sj = $s | ConvertFrom-Json
Check 'object arg saved via xmlify' ($sj.ok -and ($sj.result -eq $true)) $s
$v = (& $bb query --comp $comp --sql "SELECT Code FROM Master1 WHERE Name = 'ZigPhase3'") | ConvertFrom-Json
Check 'created master exists' ($v.rows.Count -eq 1) ($v | ConvertTo-Json -Compress)
if ($v.rows.Count -eq 1) {
    $code = $v.rows[0].Code
    $d = (& $bb call --comp $comp --method DeleteMasterByCode --args-b64 (To-B64 "[$code, {`"`$byref`":`"`"}]")) | ConvertFrom-Json
    Check 'cleanup delete' ($d.ok -and $d.result) ($d | ConvertTo-Json -Compress)
    $v2 = (& $bb query --comp $comp --sql "SELECT Code FROM Master1 WHERE Name = 'ZigPhase3'") | ConvertFrom-Json
    Check 'master gone' ($v2.rows.Count -eq 0) ($v2 | ConvertTo-Json -Compress)
}

Write-Output '===== HTTP: Accept negotiation ====='
$job = Start-BridgeServe -Port 9820
try {
    $H = @{ Accept = 'application/xml' }
    $r1 = Invoke-WebRequest "$base/health" -UseBasicParsing -Headers $H
    Check 'health XML + content-type' ($r1.Content.StartsWith('<Health') -and $r1.Headers['Content-Type'] -like 'application/xml*') "$($r1.Headers['Content-Type']) $($r1.Content)"
    $r2 = Invoke-WebRequest "$base/classes" -UseBasicParsing -Headers $H
    Check 'classes XML' ($r2.Content.StartsWith("<Classes count='")) $r2.Content.Substring(0, 60)
    $r3 = Invoke-WebRequest "$base/surface?member=OpenDB" -UseBasicParsing -Headers $H
    Check 'surface XML via ?member' ($r3.Content.Contains("<Member name='OpenDB'")) $r3.Content.Substring(0, 90)
    $bq = '{"sql":"SELECT TOP 2 Code, Name FROM Master1"}'
    $r4 = Invoke-WebRequest "$base/query" -UseBasicParsing -Headers $H -Method Post -Body $bq -ContentType 'application/json'
    Check 'query rowset via Accept' ($r4.Content.Contains('<z:row') -and $r4.Content.Contains('xmlns:rs=')) $r4.Content.Substring(0, 90)
    $r5 = Invoke-WebRequest "$base/call?method=GetCompConfigXML&args=%5Bfalse%5D" -UseBasicParsing -Headers $H
    Check 'GET /call percent-decoded args, raw passthrough' ($r5.Content.StartsWith('<Company>')) $r5.Content.Substring(0, [Math]::Min(70, $r5.Content.Length))
    $rInf = Invoke-WebRequest "$base/info" -UseBasicParsing -Headers $H
    Check 'info XML shape' ($rInf.Content.StartsWith("<Info bridge='busy-bridge'") -and $rInf.Content.Contains("prog_id='Busy2L")) $rInf.Content.Substring(0, [Math]::Min(100, $rInf.Content.Length))
    $rKonst = Invoke-WebRequest "$base/constants" -UseBasicParsing -Headers $H
    Check 'constants XML shape' ($rKonst.Content.StartsWith('<Constants><Masters>') -and $rKonst.Content.Contains("name='SALE'")) $rKonst.Content.Substring(0, [Math]::Min(90, $rKonst.Content.Length))

    Write-Output '--- HTTP raw XML body write round-trip ---'
    $xmlDoc = '<Account><Name>ZigPhase3Http</Name><PrintName>ZigPhase3Http</PrintName><ParentGroup>Cash-in-hand</ParentGroup><Address><OF /><CountryName>India</CountryName><StateName>Delhi</StateName></Address><SupplierType>1</SupplierType><PriceLevel>@</PriceLevel><PriceLevelForPurc>@</PriceLevelForPurc><TaxType>Others</TaxType><TypeOfDealerGST>Un-Registered</TypeOfDealerGST><ReverseChargeType>Not Applicable</ReverseChargeType><InputType>Section 17(5)-ITC None</InputType></Account>'
    $r6 = Invoke-WebRequest "$base/call?method=SaveMasterFromXML&type=2" -UseBasicParsing -Headers $H -Method Post -Body $xmlDoc -ContentType 'application/xml'
    Check 'raw XML body save' ($r6.Content.Contains('<Result>true</Result>')) $r6.Content
    $v = (& $bb query --comp $comp --sql "SELECT Code FROM Master1 WHERE Name = 'ZigPhase3Http'") | ConvertFrom-Json
    Check 'raw-saved master exists' ($v.rows.Count -eq 1) ($v | ConvertTo-Json -Compress)
    if ($v.rows.Count -eq 1) {
        $code = $v.rows[0].Code
        $db = '{"method":"DeleteMasterByCode","args":[' + $code + ',{"$byref":""}]}'
        $r7 = Invoke-WebRequest "$base/call" -UseBasicParsing -Headers $H -Method Post -Body $db -ContentType 'application/json'
        Check 'delete via JSON body + XML response' ($r7.Content.Contains('<Result>true</Result>')) $r7.Content
    }
    $e5 = Invoke-Http "$base/query" 'POST' 'application/xml' '{"sql":"SELECT * FROM NoSuchTable"}' 'application/json'
        Check 'query fail -> xml error 500 + machine code' ($e5.st -eq 500 -and $e5.body.StartsWith("<Error code='500' error='") -and $e5.body.Contains("error='no_recordset'")) "status=$($e5.st) body=$($e5.body)"
    $e4 = Invoke-Http "$base/nope" 'GET' 'application/xml' $null $null
        Check '404 xml error envelope' ($e4.st -eq 404 -and $e4.body.StartsWith("<Error code='404' error='not_found'>")) "status=$($e4.st) body=$($e4.body)"
    $r9 = Invoke-WebRequest "$base/health" -UseBasicParsing
    Check 'default remains JSON' ($r9.Content.Contains('"ok":true')) $r9.Content
} finally {
    Stop-BridgeServe $job
}

Finish-Tests '03-wire-modes'
