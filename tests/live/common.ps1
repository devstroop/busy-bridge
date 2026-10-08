# Shared helpers for the live-BUSY test scripts in this folder.
# Dot-source from a sibling test:
#   . (Join-Path $PSScriptRoot 'common.ps1')
#
# Requirements: busy-bridge built (zig build) and a BUSY company to test
# against (default COMP0001; override with $env:BUSY_COMP).
# Bridge override: $env:BUSY_BRIDGE_EXE
$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$script:RepoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$script:Bridge = if ($env:BUSY_BRIDGE_EXE) { $env:BUSY_BRIDGE_EXE }
                 else { Join-Path $script:RepoRoot 'zig-out\bin\busy-bridge.exe' }
if (-not (Test-Path $script:Bridge)) {
    throw "busy-bridge not built - run 'zig build' in $($script:RepoRoot)"
}
$script:Bridge = (Resolve-Path $script:Bridge).Path
$script:Comp = if ($env:BUSY_COMP) { $env:BUSY_COMP } else { 'COMP0001' }
$script:TestFails = 0

function Check($name, $cond, $detail) {
    if ($cond) { Write-Output "PASS  $name" }
    else { Write-Output "FAIL  $name :: $detail"; $script:TestFails++ }
}

function To-B64([string]$s) {
    [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($s))
}

function Invoke-BB {
    # invoke the bridge; returns output lines (LASTEXITCODE in $global:LASTEXITCODE)
    & $script:Bridge @Args
}

function Invoke-Http($url, $method, $accept, $bodyText, $contentType) {
    # Raw HttpWebRequest: Invoke-WebRequest drains error bodies into its own
    # exception, so negative-path checks must use this (unwraps wrapped exs).
    try {
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.Method = $method
        $req.Timeout = 8000
        if ($accept) { $req.Accept = $accept }
        if ($bodyText) {
            $req.ContentType = $contentType
            $bytes = [Text.Encoding]::UTF8.GetBytes($bodyText)
            $req.ContentLength = $bytes.Length
            $s = $req.GetRequestStream(); $s.Write($bytes, 0, $bytes.Length); $s.Close()
        }
        $resp = $req.GetResponse()
        $sr = New-Object System.IO.StreamReader($resp.GetResponseStream())
        return @{ st = [int]$resp.StatusCode; body = $sr.ReadToEnd(); ct = $resp.ContentType }
    } catch {
        $we = $_.Exception
        while ($we -and -not ($we -is [System.Net.WebException])) { $we = $we.InnerException }
        if ($we -and $we.Response) {
            $r = $we.Response
            $sr = New-Object System.IO.StreamReader($r.GetResponseStream())
            return @{ st = [int]$r.StatusCode; body = $sr.ReadToEnd(); ct = $r.ContentType }
        }
        return @{ st = -1; body = ''; ct = ''; err = $_.Exception.Message }
    }
}

function Start-BridgeServe([int]$Port = 9820) {
    $job = Start-Job -ScriptBlock {
        param($exe, $comp, $port)
        & $exe serve --comp $comp --port $port
    } -ArgumentList $script:Bridge, $script:Comp, $Port
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Milliseconds 500
        try {
            $r = Invoke-WebRequest "http://127.0.0.1:$Port/health" -UseBasicParsing -TimeoutSec 2
            if ($r.StatusCode -eq 200) { return $job }
        } catch { }
    }
    Receive-Job $job | Write-Output
    Stop-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job -Force -ErrorAction SilentlyContinue
    throw "busy-bridge serve did not come up on port $Port"
}

function Stop-BridgeServe($job) {
    Stop-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job -Force -ErrorAction SilentlyContinue
}

function Finish-Tests([string]$label) {
    if ($script:TestFails -gt 0) {
        Write-Output ''
        Write-Output "$label FAILED: $($script:TestFails) check(s)"
        exit 1
    }
    Write-Output ''
    Write-Output "$label ALL CHECKS PASSED"
    exit 0
}
