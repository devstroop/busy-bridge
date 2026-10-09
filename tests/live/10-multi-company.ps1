# 10 - Multi-company serve sessions (issue #5): one serve process answers
# queries against two companies via ?comp= / X-Company, with swap-based
# switching (BUSY COM company state is process-global, first-open-wins -
# see src/transport/sessions.zig header comment).
#
# Requires a SECOND company on disk. None ships with BUSY; the fixture is
# a file-level clone of COMP0001 made once by hand:
#   Copy-Item -Recurse C:\BusyWin\DATA\COMP0001 C:\BusyWin\DATA\COMP0002
# (verified accepted by OpenDB: the clone opens and queries independently).
# The two are distinguished below by a marker master created ONLY in
# COMP0002 through the bridge, so the test proves data isolation, not just
# a second open handle.
#   powershell -File tests/live/10-multi-company.ps1
. (Join-Path $PSScriptRoot 'common.ps1')
$base = 'http://127.0.0.1:9820'
$comp2 = if ($env:BUSY_COMP2) { $env:BUSY_COMP2 } else { 'COMP0002' }
$Marker = 'ZigMultiCoMarker'

if (-not (Test-Path (Join-Path 'C:\BusyWin\DATA' $comp2))) {
    Write-Output "SKIP: company $comp2 not present under C:\BusyWin\DATA (clone COMP0001 to create it)"
    exit 0
}

# Cleanup helper: remove the marker master from comp2 (idempotent).
function Remove-Marker {
    $q = (& $script:Bridge query --comp $comp2 --sql "SELECT Code FROM Master1 WHERE Name = '$Marker'") | ConvertFrom-Json
    if ($q.rows.Count -gt 0) {
        $code = $q.rows[0].Code
        & $script:Bridge call --comp $comp2 --method DeleteMasterByCode --args-b64 (To-B64 "[$code, {`"`$byref`":`"`"}]") | Out-Null
    }
}

Remove-Marker

$job = Start-BridgeServe -Port 9820
try {
    Write-Output '--- boot: default company is COMP0001 ---'
    $inf = (Invoke-WebRequest "$base/info" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'info company = default --comp' ($inf.company -eq $script:Comp) ($inf | ConvertTo-Json -Compress)
    Check 'info reports multi-company' ($inf.switches -eq 0) ($inf | ConvertTo-Json -Compress)

    Write-Output '--- default query hits COMP0001 (marker absent) ---'
    $b1 = '{"sql":"SELECT Code FROM Master1 WHERE Name = ''ZigMultiCoMarker''"}'
    $q1 = (Invoke-WebRequest "$base/query" -UseBasicParsing -Method Post -Body $b1 -ContentType 'application/json').Content | ConvertFrom-Json
    Check 'default company has no marker' ($q1.ok -and $q1.rows.Count -eq 0) ($q1 | ConvertTo-Json -Compress)

    Write-Output '--- seed marker ONLY in COMP0002 (via CLI, separate process) ---'
    $xml = '<Account><Name>' + $Marker + '</Name><PrintName>' + $Marker + '</PrintName><ParentGroup>Cash-in-hand</ParentGroup><Address><OF /><CountryName>India</CountryName><StateName>Delhi</StateName></Address><SupplierType>1</SupplierType><PriceLevel>@</PriceLevel><PriceLevelForPurc>@</PriceLevelForPurc><TaxType>Others</TaxType><TypeOfDealerGST>Un-Registered</TypeOfDealerGST><ReverseChargeType>Not Applicable</ReverseChargeType><InputType>Section 17(5)-ITC None</InputType></Account>'
    $saveArgs = To-B64 ('["2","' + $xml + '",{"$byref":""},false]')
    $save = (& $script:Bridge call --comp $comp2 --method SaveMasterFromXML --args-b64 $saveArgs) | ConvertFrom-Json
    Check 'marker created in COMP0002' ($save.ok -and ($save.result -eq $true)) ($save | ConvertTo-Json -Compress)

    Write-Output '--- ?comp=COMP0002 switches and sees the marker ---'
    # A company swap costs ~7s against live BUSY (CloseDB+OpenDB is BUSY's
    # own cost, serialized by the single-threaded accept loop; measured
    # 2026-10-09). Invoke-Http's shared 8s timeout is too tight for swaps,
    # so company-switching checks use a local 30s-timeout variant.
    function Invoke-HttpSlow($url) {
        try {
            $req = [System.Net.HttpWebRequest]::Create($url)
            $req.Method = 'POST'; $req.Timeout = 30000; $req.Accept = 'application/json'
            $req.ContentType = 'application/json'
            $b = [Text.Encoding]::UTF8.GetBytes('{"sql":"SELECT Code FROM Master1 WHERE Name = ''ZigMultiCoMarker''"}')
            $req.ContentLength = $b.Length
            $s = $req.GetRequestStream(); $s.Write($b, 0, $b.Length); $s.Close()
            $r = $req.GetResponse()
            $sr = New-Object System.IO.StreamReader($r.GetResponseStream())
            return @{ st = [int]$r.StatusCode; body = $sr.ReadToEnd() }
        } catch {
            $we = $_.Exception; while ($we -and -not ($we -is [System.Net.WebException])) { $we = $we.InnerException }
            if ($we -and $we.Response) {
                $sr = New-Object System.IO.StreamReader($we.Response.GetResponseStream())
                return @{ st = [int]$we.Response.StatusCode; body = $sr.ReadToEnd() }
            }
            return @{ st = -1; body = ''; err = $_.Exception.Message }
        }
    }
    $q2 = Invoke-HttpSlow "$base/query?comp=$comp2"
    Check 'comp2 query via ?comp= sees marker' ($q2.st -eq 200 -and $q2.body.Contains('"Code"')) $q2.body

    Write-Output '--- default (no comp) still COMP0001: isolation ---'
    $q3 = (Invoke-WebRequest "$base/query" -UseBasicParsing -Method Post -Body $b1 -ContentType 'application/json').Content | ConvertFrom-Json
    Check 'default still does not see marker (swap back)' ($q3.ok -and $q3.rows.Count -eq 0) ($q3 | ConvertTo-Json -Compress)

    Write-Output '--- X-Company header switches ---'
    $req = [System.Net.HttpWebRequest]::Create("$base/query")
    $req.Method = 'POST'; $req.Accept = 'application/json'; $req.Headers.Add('X-Company', $comp2)
    $req.ContentType = 'application/json'
    $bytes = [Text.Encoding]::UTF8.GetBytes('{"sql":"SELECT Code FROM Master1 WHERE Name = ''ZigMultiCoMarker''"}')
    $req.ContentLength = $bytes.Length
    $st = $req.GetRequestStream(); $st.Write($bytes, 0, $bytes.Length); $st.Close()
    $resp = $req.GetResponse(); $sr = New-Object System.IO.StreamReader($resp.GetResponseStream())
    $q4text = $sr.ReadToEnd(); $resp.Close()
    Check 'comp2 query via X-Company sees marker' ($q4text.Contains('"Code"')) $q4text

    Write-Output '--- /info reflects active company + switch count ---'
    $inf2 = (Invoke-WebRequest "$base/info" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'switches counted' ($inf2.switches -ge 2) ($inf2 | ConvertTo-Json -Compress)

    Write-Output '--- unknown company -> 404 company_not_found ---'
    $e = Invoke-Http "$base/query?comp=NOSUCHCO" 'POST' '' '{"sql":"SELECT 1"}' 'application/json'
    Check 'unknown company 404 + machine code' ($e.st -eq 404 -and $e.body.Contains('"code":"company_not_found"')) "st=$($e.st) body=$($e.body)"

    Write-Output '--- unknown company via X-Company -> 404 ---'
    $req2 = [System.Net.HttpWebRequest]::Create("$base/query")
    $req2.Method = 'POST'; $req2.Accept = 'application/json'; $req2.Headers.Add('X-Company', 'NOSUCHCO')
    $req2.ContentType = 'application/json'
    $req2.ContentLength = $bytes.Length
    $st2 = $req2.GetRequestStream(); $st2.Write($bytes, 0, $bytes.Length); $st2.Close()
    try { $resp2 = $req2.GetResponse(); $stcode = [int]$resp2.StatusCode; $b2 = '' ; $resp2.Close() }
    catch {
        $we = $_.Exception; while ($we -and -not ($we -is [System.Net.WebException])) { $we = $we.InnerException }
        $stcode = [int]$we.Response.StatusCode
        $sr2 = New-Object System.IO.StreamReader($we.Response.GetResponseStream()); $b2 = $sr2.ReadToEnd()
    }
    Check 'unknown X-Company 404 + machine code' ($stcode -eq 404 -and $b2.Contains('"code":"company_not_found"')) "st=$stcode body=$b2"

    Write-Output '--- after failures the default company still answers ---'
    $q5 = (Invoke-WebRequest "$base/query" -UseBasicParsing -Method Post -Body $b1 -ContentType 'application/json').Content | ConvertFrom-Json
    Check 'default company intact after failed switches' ($q5.ok -and $q5.rows.Count -eq 0) ($q5 | ConvertTo-Json -Compress)

    Write-Output '--- stress: 20 alternating requests across both companies ---'
    $stressOk = $true; $stressDetail = ''
    for ($i = 0; $i -lt 20; $i++) {
        $wantMarker = ($i % 2 -eq 1)
        $url = if ($wantMarker) { "$base/query?comp=$comp2" } else { "$base/query" }
        $r = Invoke-HttpSlow $url
        $has = $r.body.Contains('"Code"')
        if ($r.st -ne 200 -or $has -ne $wantMarker) {
            $stressOk = $false
            $stressDetail = "i=$i wantMarker=$wantMarker st=$($r.st) has=$has"
            break
        }
    }
    Check '20 alternating switches return the right company data' $stressOk $stressDetail
} finally {
    Stop-BridgeServe $job
    Remove-Marker
}

Finish-Tests '10-multi-company'
