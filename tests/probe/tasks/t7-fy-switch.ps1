# T7 experiment: company switching + STA/serialization on bridge serve
# (bridge work-map lane T7; BUSY-004). Owns its server; one run at a time.
#   tests/probe/tasks/t7-fy-switch.ps1 [-Port 9830] [-Comp COMP0001] [-Other COMP0002]
param([int]$Port = 9830, [string]$Comp = 'COMP0001', [string]$Other = 'COMP0002')
$ErrorActionPreference = 'Stop'
$repo = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$bb = Join-Path $repo 'zig-out\bin\busy-bridge.exe'
if (-not (Test-Path $bb)) { throw "bridge not built ($bb)" }
$base = "http://127.0.0.1:$Port"
function Ht([string]$method, [string]$url, [string]$body) {
    $wr = [Net.WebRequest]::Create($url)
    $wr.Method = $method; $wr.Timeout = 60000
    if ($body) {
        $wr.ContentType = 'application/json'
        $b = [Text.Encoding]::UTF8.GetBytes($body)
        $wr.ContentLength = $b.Length
        $s = $wr.GetRequestStream(); $s.Write($b, 0, $b.Length); $s.Close()
    }
    try { $r = $wr.GetResponse() } catch [System.Net.WebException] { $r = $_.Exception.Response }
    $code = if ($r) { [int]$r.StatusCode } else { -1 }
    $txt = ''
    if ($r) { $sr = New-Object IO.StreamReader($r.GetResponseStream()); $txt = $sr.ReadToEnd(); $sr.Close(); $r.Close() }
    return @{ st = $code; body = $txt }
}
function CallM([string]$m, [string]$qs) {
    $r = Ht 'POST' ("$base/call" + $qs) ('{"method":"' + $m + '"}')
    return $r
}
# ---- own server ----
$proc = Start-Process -FilePath $bb -ArgumentList @('serve', '--port', "$Port", '--comp', $Comp) -PassThru -WindowStyle Hidden
try {
    $up = $false
    for ($i = 0; $i -lt 40; $i++) { Start-Sleep -Milliseconds 500; try { $h = Ht 'GET' "$base/info" $null; if ($h.st -eq 200) { $up = $true; break } } catch {} }
    if (-not $up) { throw 'serve did not come up' }
    Write-Output ('info: ' + (Ht 'GET' "$base/info" $null).body.Trim())

    # 1. baseline (default company)
    $t0 = Get-Date; $c1 = CallM 'GetCurrentUserName' ''; $d1 = ((Get-Date) - $t0).TotalSeconds
    Write-Output ("default user (" + [math]::Round($d1,1) + 's): ' + $c1.body.Trim())

    # 2. first switch to $Other (expected ~7s CloseDB+OpenDB swap)
    $t0 = Get-Date; $c2 = CallM 'GetCurrentUserName' "?comp=$Other"; $d2 = ((Get-Date) - $t0).TotalSeconds
    Write-Output ("switch->" + $Other + ' (' + [math]::Round($d2,1) + 's): ' + $c2.body.Trim())

    # 3. company-scoped discriminator (COMP0001 carries ZZ fixture rows)
    $sql = '{"sql":"SELECT COUNT(*) AS n FROM Master1"}'
    $qA1 = Ht 'POST' "$base/query?comp=$Comp" $sql
    $qB  = Ht 'POST' "$base/query?comp=$Other" $sql
    Write-Output ('count[' + $Comp + ']: ' + $qA1.body.Trim())
    Write-Output ('count[' + $Other + ']: ' + $qB.body.Trim())

    # 4. switch back + fast path
    $t0 = Get-Date; $null = Ht 'POST' "$base/query?comp=$Comp" $sql; $d4 = ((Get-Date) - $t0).TotalSeconds
    $t0 = Get-Date; $qA2 = Ht 'POST' "$base/query?comp=$Comp" $sql; $d5 = ((Get-Date) - $t0).TotalSeconds
    Write-Output ('switch-back (' + [math]::Round($d4,1) + 's), repeat (' + [math]::Round($d5,1) + 's): ' + $qA2.body.Trim())

    # 5. default-company requests unaffected by switches (no cross-talk)
    $c1b = CallM 'GetCurrentUserName' ''
    Write-Output ('default after roundtrip: ' + $c1b.body.Trim())

    # 6. two parallel same-company calls (serve accept loop serializes)
    $jobs = 1..2 | ForEach-Object { Start-Job -ScriptBlock { param($u) try { (Invoke-WebRequest -Uri $u -Method POST -Body '{"method":"GetCurrentUserName"}' -ContentType 'application/json' -UseBasicParsing).Content } catch { 'ERR:' + $_.Exception.Message } } -ArgumentList "$base/call" }
    $par = $jobs | Wait-Job | Receive-Job; $jobs | Remove-Job
    Write-Output ('parallel: ' + ($par -join ' | '))

    # 7. FY dimension: bridge serve has no ?fy= (server-side S6 scope)
    $fy = Ht 'POST' "$base/call?fy=2025" '{"method":"GetCurrentUserName"}'
    Write-Output ('?fy=2025 accepted-ignored: ' + $fy.body.Trim())
} finally {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    Write-Output 'serve stopped'
}
