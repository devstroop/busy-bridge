# 12 - Report rights enforcement (BUSY-012, contract §5): the session
#      gate + per-report rights on /v1/reports/* and /op/report/*.
#      Admin (super) passes everything; user1 (BUSY-granted Account
#      Ledger 19 + Day Book 18) gets ledger/day-book 200; unmapped
#      trial-balance fails closed (403 rights_denied). Fixture:
#      COMP0001 users admin/user1 (env: BUSY_PROBE_ADMIN_PW /
#      BUSY_PROBE_USER1_PW).
#   powershell -File tests/live/12-report-rights.ps1
. (Join-Path $PSScriptRoot 'common.ps1')
# Any exception outside a Check = hard failure (no false greens).
$ErrorActionPreference = 'Stop'
$port = 9846

function Invoke-Auth([string]$url, [string]$method, [string]$tok, [string]$body) {
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
    try { $resp = $req.GetResponse() } catch {
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

function Login([string]$user, [string]$pw) {
    $body = '{"username":"' + $user + '","password":"' + $pw + '","comp":"' + $script:Comp + '"}'
    $r = Invoke-Auth "http://127.0.0.1:$port/auth/login" 'POST' $null $body
    $j = $r.body | ConvertFrom-Json
    return $j.result.token
}

$pwA = if ($env:BUSY_PROBE_ADMIN_PW) { $env:BUSY_PROBE_ADMIN_PW } else { 'admin' }
$pwU = if ($env:BUSY_PROBE_USER1_PW) { $env:BUSY_PROBE_USER1_PW } else { 'password' }
$job = Start-BridgeServe $port @('--require-session')
try {
    Write-Output '===== A. login ====='
    $ta = Login 'admin' $pwA
    $tu = Login 'user1' $pwU
    Check 'admin login issues token' ($null -ne $ta -and $ta.Length -eq 43) "len=$($ta.Length)"
    Check 'user1 login issues token' ($null -ne $tu -and $tu.Length -eq 43) "len=$($tu.Length)"

    Write-Output '===== B. session gate ====='
    $r = Invoke-Auth "http://127.0.0.1:$port/v1/reports/ledger?name=Cash-in-hand&from=2026-04-01&to=2027-03-31" 'GET' $null $null
    Check 'no token -> 401' ($r.st -eq 401) "st=$($r.st)"

    Write-Output '===== C. admin (super) passes everything ====='
    $r = Invoke-Auth "http://127.0.0.1:$port/v1/reports/ledger?name=Cash-in-hand&from=2026-04-01&to=2027-03-31" 'GET' $ta $null
    Check 'admin /v1/reports/ledger -> 200' ($r.st -eq 200 -and $r.body.Contains('"kind":"ledger"')) "st=$($r.st) $($r.body.Substring(0, [Math]::Min(160, $r.body.Length)))"
    $r = Invoke-Auth "http://127.0.0.1:$port/v1/reports/day-book?from=2026-04-01&to=2027-03-31" 'GET' $ta $null
    Check 'admin /v1/reports/day-book -> 200 (super bypasses map)' ($r.st -eq 200 -and $r.body.Contains('"kind":"day-book"')) "st=$($r.st)"

    Write-Output '===== D. user1: granted ledger (19) + day-book (18); unmapped trial-balance denied ====='
    $r = Invoke-Auth "http://127.0.0.1:$port/v1/reports/ledger?name=Cash-in-hand&from=2026-04-01&to=2027-03-31" 'GET' $tu $null
    Check 'user1 /v1/reports/ledger -> 200 (Account Ledger = 19)' ($r.st -eq 200 -and $r.body.Contains('"kind":"ledger"')) "st=$($r.st) $($r.body.Substring(0, [Math]::Min(160, $r.body.Length)))"
    $r = Invoke-Auth "http://127.0.0.1:$port/v1/reports/day-book?from=2026-04-01&to=2027-03-31" 'GET' $tu $null
    Check 'user1 /v1/reports/day-book -> 200 (Day Book = 18)' ($r.st -eq 200 -and $r.body.Contains('"kind":"day-book"')) "st=$($r.st) $($r.body.Substring(0, [Math]::Min(160, $r.body.Length)))"
    $r = Invoke-Auth "http://127.0.0.1:$port/v1/reports/trial-balance?from=2026-04-01&to=2027-03-31" 'GET' $tu $null
    Check 'user1 /v1/reports/trial-balance -> 403 (unmapped)' ($r.st -eq 403) "st=$($r.st)"

    Write-Output '===== E. /op/report parity ====='
    $r = Invoke-Auth "http://127.0.0.1:$port/op/report/ledger?name=Cash-in-hand&from=2026-04-01&to=2027-03-31" 'GET' $tu $null
    Check 'user1 /op/report/ledger -> 200' ($r.st -eq 200 -and $r.body.Contains('"kind":"ledger"')) "st=$($r.st)"
    $r = Invoke-Auth "http://127.0.0.1:$port/op/report/day-book?from=2026-04-01&to=2027-03-31" 'GET' $tu $null
    Check 'user1 /op/report/day-book -> 200 (repID 18)' ($r.st -eq 200 -and $r.body.Contains('"kind":"day-book"')) "st=$($r.st)"

    Write-Output '===== F. enforcement rides the session gate only ====='
    # dev posture (no --require-session): report routes open (operator tier)
    $job2 = Start-BridgeServe ($port + 1) @()
    try {
        $r = Invoke-Auth "http://127.0.0.1:$($port + 1)/v1/reports/ledger?name=Cash-in-hand&from=2026-04-01&to=2027-03-31" 'GET' $null $null
        Check 'gate off -> report open without session' ($r.st -eq 200) "st=$($r.st)"
    } finally {
        Stop-BridgeServe $job2
    }
} finally {
    Stop-BridgeServe $job
}

Finish-Tests '12-report-rights'
