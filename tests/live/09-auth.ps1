# 09 - token auth & exposure policy (issue #4) against a live company.
#   powershell -File tests/live/09-auth.ps1
# Covers: non-loopback refusal without token; 401 envelope for missing/wrong
# token on every route except /info; both token headers; env-var token;
# nosniff; XML 401 negotiation. Loopback-without-token (gate disarmed) is
# covered by suites 01-08, which run with no token configured.
. (Join-Path $PSScriptRoot 'common.ps1')

function Invoke-Tok($url, $method, $accept, $tokHdr, $xtok, $bodyText, $ct) {
    # HttpWebRequest so 4xx bodies stay readable (Invoke-WebRequest buries them).
    try {
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.Method = $method
        $req.Timeout = 8000
        if ($accept) { $req.Accept = $accept }
        if ($tokHdr) { $req.Headers.Add('Authorization', $tokHdr) }
        if ($xtok) { $req.Headers.Add('X-Bridge-Token', $xtok) }
        if ($bodyText) {
            $req.ContentType = $ct
            $bytes = [Text.Encoding]::UTF8.GetBytes($bodyText)
            $req.ContentLength = $bytes.Length
            $s = $req.GetRequestStream(); $s.Write($bytes, 0, $bytes.Length); $s.Close()
        }
        $resp = $req.GetResponse()
        $sr = New-Object System.IO.StreamReader($resp.GetResponseStream())
        return @{ st = [int]$resp.StatusCode; body = $sr.ReadToEnd(); ct = $resp.ContentType
                  nosniff = $resp.Headers['X-Content-Type-Options'] }
    } catch {
        $we = $_.Exception
        while ($we -and -not ($we -is [System.Net.WebException])) { $we = $we.InnerException }
        if ($we -and $we.Response) {
            $r = $we.Response
            $sr = New-Object System.IO.StreamReader($r.GetResponseStream())
            return @{ st = [int]$r.StatusCode; body = $sr.ReadToEnd(); ct = $r.ContentType
                      nosniff = $r.Headers['X-Content-Type-Options'] }
        }
        return @{ st = -1; body = ''; ct = ''; nosniff = ''; err = $_.Exception.Message }
    }
}

function Start-TokenServe([int]$Port, [string[]]$Extra) {
    $job = Start-Job -ScriptBlock {
        param($exe, $comp, $port, $extra)
        if (-not $extra) { $extra = @() }
        & $exe serve --comp $comp --port $port @extra
    } -ArgumentList $script:Bridge, $script:Comp, $Port, $Extra
    # /health itself is gated when armed, so any HTTP answer means "up".
    $r = $null
    for ($i = 0; $i -lt 24; $i++) {
        Start-Sleep -Milliseconds 500
        $r = Invoke-Tok "http://127.0.0.1:$Port/health" 'GET' $null $null $null $null $null
        if ($r.st -eq 200 -or $r.st -eq 401) { return $job }
    }
    Receive-Job $job | Write-Output
    Stop-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job -Force -ErrorAction SilentlyContinue
    throw "token serve did not come up on port $Port (st=$($r.st) err=$($r.err))"
}

function Stop-TokenServe($job) {
    Stop-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job -Force -ErrorAction SilentlyContinue
}

$tok = 'live-auth-9f2c-tok'
$envTok = 'live-auth-env-77aa'
$portA = 9830   # --token flag
$portB = 9831   # BUSY_BRIDGE_TOKEN env
$baseA = "http://127.0.0.1:$portA"
$baseB = "http://127.0.0.1:$portB"

$jobA = $null
$jobB = $null
try {
    Write-Output '--- AC: non-loopback bind without token refuses to start ---'
    $out = (& $script:Bridge serve --host 0.0.0.0 --port 9899 2>&1 | Out-String)
    $ec = $LASTEXITCODE
    Check 'refuses 0.0.0.0 without token (exit 1)' ($ec -eq 1) "exit=$ec"
    Check 'actionable error: code token_required' ($out -match 'token_required') $out
    Check 'error says how to fix (token flag/env)' ($out -match 'BUSY_BRIDGE_TOKEN' -and ($out -like '*--token*')) $out

    Write-Output '--- serve with --token on loopback ---'
    $jobA = Start-TokenServe $portA @('--token', $tok)
    $boot = (Receive-Job $jobA -Keep | Where-Object { $_ -match '"listening"' } | Select-Object -First 1)
    Check 'boot line reports auth:true' ($boot -match '"auth":true') "$boot"

    Write-Output '--- 401 envelope without token ---'
    $r = Invoke-Tok "$baseA/health" 'GET' $null $null $null $null $null
    Check 'health without token -> 401' ($r.st -eq 401) "st=$($r.st)"
    Check 'body is error envelope code:unauthorized' ($r.body.Contains('"ok":false') -and $r.body.Contains('"code":"unauthorized')) $r.body
    Check '401 carries nosniff' ($r.nosniff -eq 'nosniff') "nosniff=$($r.nosniff)"

    $r = Invoke-Tok "$baseA/query" 'POST' $null $null $null ('{"sql":"SELECT 1 AS x"}') 'application/json'
    Check 'query without token -> 401' ($r.st -eq 401) "st=$($r.st)"

    $r = Invoke-Tok "$baseA/nope" 'GET' $null $null $null $null $null
    Check 'unknown route without token -> 401 (not 404)' ($r.st -eq 401) "st=$($r.st)"

    Write-Output '--- wrong token ---'
    $r = Invoke-Tok "$baseA/health" 'GET' $null 'Bearer wrong-token' $null $null $null
    Check 'wrong Bearer -> 401' ($r.st -eq 401) "st=$($r.st)"
    $r = Invoke-Tok "$baseA/health" 'GET' $null $null 'wrong-token' $null $null
    Check 'wrong X-Bridge-Token -> 401' ($r.st -eq 401) "st=$($r.st)"

    Write-Output '--- correct token, both headers ---'
    $r = Invoke-Tok "$baseA/health" 'GET' $null "Bearer $tok" $null $null $null
    Check 'Bearer accepted -> 200' ($r.st -eq 200 -and $r.body.Contains('"status"')) "st=$($r.st) $($r.body)"
    Check '200 carries nosniff' ($r.nosniff -eq 'nosniff') "nosniff=$($r.nosniff)"
    $r = Invoke-Tok "$baseA/health" 'GET' $null $null $tok $null $null
    Check 'X-Bridge-Token accepted -> 200' ($r.st -eq 200) "st=$($r.st)"
    $r = Invoke-Tok "$baseA/health" 'GET' $null 'bearer lowercase-ok' $null $null $null
    Check 'bearer scheme is case-insensitive' ($r.st -eq 401) "st=$($r.st) (lowercase wrong token still 401)"
    $r = Invoke-Tok "$baseA/health" 'GET' $null "BEARER $tok" $null $null $null
    Check 'BEARER scheme accepted' ($r.st -eq 200) "st=$($r.st)"

    Write-Output '--- /info exempt, gated routes still work with token ---'
    $r = Invoke-Tok "$baseA/info" 'GET' $null $null $null $null $null
    Check '/info reachable without token -> 200' ($r.st -eq 200) "st=$($r.st)"
    Check '/info is identity, not data' ($r.body.Contains('"routes"')) $r.body
    $r = Invoke-Tok "$baseA/query" 'POST' $null "Bearer $tok" $null ('{"sql":"SELECT TOP 1 Code FROM Master1"}') 'application/json'
    Check 'query with token -> 200 rows' ($r.st -eq 200 -and $r.body.Contains('"ok":true')) "st=$($r.st) $($r.body)"

    Write-Output '--- XML negotiation on the gate ---'
    $r = Invoke-Tok "$baseA/health" 'GET' 'application/xml' $null $null $null $null
    Check 'XML unauthorized -> 401 xml envelope' ($r.st -eq 401 -and "$($r.ct)" -like 'application/xml*' -and $r.body -match 'unauthorized') "st=$($r.st) ct=$($r.ct) $($r.body)"

    Write-Output '--- BUSY_BRIDGE_TOKEN env var ---'
    $env:BUSY_BRIDGE_TOKEN = $envTok
    $jobB = Start-TokenServe $portB @()
    $r = Invoke-Tok "$baseB/health" 'GET' $null "Bearer $envTok" $null $null $null
    Check 'env token accepted -> 200' ($r.st -eq 200) "st=$($r.st)"
    $r = Invoke-Tok "$baseB/health" 'GET' $null "Bearer $tok" $null $null $null
    Check 'flag token not confused with env token -> 401' ($r.st -eq 401) "st=$($r.st)"
} finally {
    $env:BUSY_BRIDGE_TOKEN = $null
    if ($jobA) { Stop-TokenServe $jobA }
    if ($jobB) { Stop-TokenServe $jobB }
}

Finish-Tests '09-auth'
