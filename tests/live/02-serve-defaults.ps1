# 02 - HTTP serve defaults (JSON) against a live company.
#   powershell -File tests/live/02-serve-defaults.ps1
. (Join-Path $PSScriptRoot 'common.ps1')
$base = 'http://127.0.0.1:9820'

$job = Start-BridgeServe -Port 9820
try {
    Write-Output '--- GET /health ---'
    $h = Invoke-WebRequest "$base/health" -UseBasicParsing | ConvertFrom-Json
    Check 'health is JSON ok' ($h.ok -eq $true -and $h.status -eq 'up') ($h | ConvertTo-Json -Compress)

    Write-Output '--- GET /surface ---'
    $s = (Invoke-WebRequest "$base/surface" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'surface has members' ($s.members.Count -gt 0) "count=$($s.members.Count)"

    Write-Output '--- POST /query ---'
    $b1 = '{"sql":"SELECT TOP 2 Code, Name FROM Master1 ORDER BY Code"}'
    $q = (Invoke-WebRequest "$base/query" -UseBasicParsing -Method Post -Body $b1 -ContentType 'application/json').Content | ConvertFrom-Json
    Check 'query returns rows' ($q.ok -and $q.rows.Count -ge 1) ($q | ConvertTo-Json -Compress)

    Write-Output '--- POST /call (scalar) ---'
    $b2 = '{"method":"GetCurrentUserName","args":[]}'
    $c = (Invoke-WebRequest "$base/call" -UseBasicParsing -Method Post -Body $b2 -ContentType 'application/json').Content | ConvertFrom-Json
    Check 'GetCurrentUserName = Busy' ($c.ok -and ($c.result -eq 'Busy')) ($c | ConvertTo-Json -Compress)

    Write-Output '--- POST /call (xml-out -> JSON tree, never a blob) ---'
    $b3 = '{"method":"GetCompConfigXML","args":[false]}'
    $t = (Invoke-WebRequest "$base/call" -UseBasicParsing -Method Post -Body $b3 -ContentType 'application/json').Content | ConvertFrom-Json
    Check 'result is a structured tree' ($t.ok -and ($null -ne $t.result.Company)) (($t | ConvertTo-Json -Depth 3 -Compress).Substring(0, [Math]::Min(160, 160)))

    Write-Output '--- GET /classes ---'
    $cl = (Invoke-WebRequest "$base/classes" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'classes registered' ($cl.classes.Count -gt 0) "count=$($cl.classes.Count)"

    Write-Output '--- GET /info ---'
    $inf = (Invoke-WebRequest "$base/info" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'info identity (version, discovered prog_id, routes)' (
        $inf.ok -and $inf.version -eq '0.1.0' -and $inf.prog_id -like 'Busy2L*' -and
        $inf.company -eq $script:Comp -and $inf.routes -contains '/constants'
    ) ($inf | ConvertTo-Json -Compress)

    Write-Output '--- GET /constants ---'
    $konst = (Invoke-WebRequest "$base/constants" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'constants tables (ACCOUNT=2, SALE=9)' (
        $konst.ok -and $konst.masters.ACCOUNT_MASTER -eq 2 -and $konst.vouchers.SALE -eq 9
    ) ($konst | ConvertTo-Json -Compress)

    Write-Output '--- GET /nope (404) ---'
    $e4 = Invoke-Http "$base/nope" 'GET' '' $null $null
    Check '404 JSON envelope' ($e4.st -eq 404 -and $e4.body.Contains('"ok":false')) "status=$($e4.st) body=$($e4.body)"
} finally {
    Stop-BridgeServe $job
}

Finish-Tests '02-serve-defaults'
