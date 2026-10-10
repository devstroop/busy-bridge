<#
.SYNOPSIS
    BUSY-013 live raw-tier matrix — /call,/query need the operator flag
    (--allow-raw) or an admin session under --require-session; ordinary
    sessions and bare device tokens never reach raw.
.DESCRIPTION
    Serves twice: (A) --require-session lockdown, (B) --require-session
    --allow-raw. See docs/probe/2026-10-09-headless-contracts.md §16.
.EXAMPLE
    pwsh -File 13-raw-tier.ps1
#>
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

$port = 9822
$script:Comp = 'COMP0001'

# PS5.1 WebRequest exceptions are PS-wrapped; the response is on InnerException.
function Invoke-Auth {
    param([string]$url, [string]$method = 'GET', [string]$tok, [string]$body)
    $req = [System.Net.WebRequest]::Create($url)
    $req.Method = $method
    $req.Timeout = 30000
    $req.KeepAlive = $false
    $req.ProtocolVersion = [System.Net.HttpVersion]::Version10
    if ($tok) { $req.Headers.Add('Authorization', "Bearer $tok") }
    if ($body) {
        $req.ContentType = 'application/json'
        $b = [Text.Encoding]::UTF8.GetBytes($body)
        $req.ContentLength = $b.Length
        $s = $req.GetRequestStream()
        $s.Write($b, 0, $b.Length)
        $s.Close()
    }
    try {
        $resp = $req.GetResponse()
    } catch {
        $ex = $_.Exception
        while ($ex -and -not $ex.Response) { $ex = $ex.InnerException }
        $resp = if ($ex) { $ex.Response } else { $null }
    }
    if (-not $resp) { return @{ st = 0; body = 'connection failed' } }
    $code = [int]$resp.StatusCode
    $sr = New-Object IO.StreamReader($resp.GetResponseStream())
    $txt = $sr.ReadToEnd()
    $sr.Close()
    $resp.Close()
    return @{ st = $code; body = $txt }
}

$pwA = if ($env:BUSY_PROBE_ADMIN_PW) { $env:BUSY_PROBE_ADMIN_PW } else { 'admin' }
$pwU = if ($env:BUSY_PROBE_USER1_PW) { $env:BUSY_PROBE_USER1_PW } else { 'password' }

function Login([string]$user, [string]$pw) {
    $body = '{"username":"' + $user + '","password":"' + $pw + '","comp":"' + $script:Comp + '"}'
    $r = Invoke-Auth "http://127.0.0.1:$port/auth/login" 'POST' $null $body
    if ($r.st -ne 200) { return $null }
    return ($r.body | ConvertFrom-Json).result.token
}

try {
    # --- A: lockdown (no --allow-raw) ---------------------------------------
    $job = Start-BridgeServe $port @('--require-session')
    try {
        $base = "http://127.0.0.1:$port"
        $t1 = Login 'user1' $pwU
        $ta = Login 'Admin' $pwA

        $r = Invoke-Auth "$base/query" 'POST' $null ('{"sql":"SELECT 1 AS x"}')
        Check 'no session -> 401' ($r.st -eq 401) "st=$($r.st)"

        $r = Invoke-Auth "$base/query" 'POST' $t1 ('{"sql":"SELECT 1 AS x"}')
        Check 'user1 session /query -> 403 raw_tier_denied' ($r.st -eq 403 -and $r.body -match 'raw_tier_denied') "st=$($r.st)"

        $r = Invoke-Auth "$base/call" 'POST' $t1 ('{"method":"GetAllMastersList","args":[]}')
        Check 'user1 session /call -> 403 raw_tier_denied' ($r.st -eq 403 -and $r.body -match 'raw_tier_denied') "st=$($r.st)"

        $r = Invoke-Auth "$base/query" 'POST' $ta ('{"sql":"SELECT 1 AS x"}')
        Check 'admin session /query -> 200' ($r.st -eq 200) "st=$($r.st)"
    } finally {
        Stop-BridgeServe $job
    }

    # --- B: operator flag (--allow-raw): device tier again ------------------
    $job2 = Start-BridgeServe ($port + 1) @('--require-session', '--allow-raw')
    try {
        $base2 = "http://127.0.0.1:$($port + 1)"

        $r = Invoke-Auth "$base2/query" 'POST' $null ('{"sql":"SELECT 1 AS x"}')
        Check 'flag: no session /query -> 200' ($r.st -eq 200) "st=$($r.st)"

        $r = Invoke-Auth "$base2/query" 'POST' $t1 ('{"sql":"SELECT 1 AS x"}')
        Check 'flag: user1 session -> 200' ($r.st -eq 200) "st=$($r.st)"

        $r = Invoke-Auth "$base2/health" 'GET' $null $null
        Check 'health open in both postures -> 200' ($r.st -eq 200) "st=$($r.st)"
    } finally {
        Stop-BridgeServe $job2
    }

    Finish-Tests -label '13-raw-tier'
} finally {
    # each section stops its own serve job in its inner finally
}
