# 05 - Query guard: --query-mode and --max-rows on both transports (issue #3).
#   powershell -File tests/live/05-query-guard.ps1
#
# Modes: full (CLI default: any SQL) | read-only (serve default: a single
# SELECT/WITH statement) | off (facility refuses everything).
# Refusals use the standard error envelope with code "query_not_allowed"
# (HTTP 403 / CLI exit 1). Parser-light guardrail — see README "Query
# safety". Row cap: --max-rows (default 10000), JSON adds "truncated":true.
. (Join-Path $PSScriptRoot 'common.ps1')
$bb = $script:Bridge
$comp = $script:Comp

Write-Output '===== A. CLI: modes ====='
$o = (& $bb query --comp $comp --sql 'SELECT TOP 5 Code, Name FROM Master1' | Out-String)
$exit = $LASTEXITCODE
Check 'CLI default full: SELECT runs' ($exit -eq 0 -and $o.Contains('"rows":[')) $o

$o = (& $bb query --comp $comp --query-mode read-only --sql 'DELETE FROM Master1' | Out-String)
$p = $o | ConvertFrom-Json
Check 'CLI read-only: DELETE refused' ($LASTEXITCODE -eq 1 -and $p.code -eq 'query_not_allowed') $o

$o = (& $bb query --comp $comp --query-mode read-only --sql 'SELECT TOP 1 Code FROM Master1; DELETE FROM Master1' | Out-String)
$p = $o | ConvertFrom-Json
Check 'CLI read-only: multi-statement refused' ($LASTEXITCODE -eq 1 -and $p.code -eq 'query_not_allowed') $o

$o = (& $bb query --comp $comp --query-mode off --sql 'SELECT TOP 1 Code FROM Master1' | Out-String)
$p = $o | ConvertFrom-Json
Check 'CLI off: even SELECT refused' ($LASTEXITCODE -eq 1 -and $p.code -eq 'query_not_allowed') $o

$o = (& $bb query --comp $comp --query-mode read-only --sql 'SELECT TOP 1 Code FROM Master1' | Out-String)
Check 'CLI read-only: SELECT passes' ($LASTEXITCODE -eq 0 -and $o.Contains('"rows":[')) $o

$o = (& $bb query --comp $comp --query-mode nope --sql 'SELECT 1' | Out-String)
$p = $o | ConvertFrom-Json
Check 'invalid --query-mode -> bad_args' ($LASTEXITCODE -eq 1 -and $p.code -eq 'bad_args') $o

Write-Output '===== B. CLI: row cap ====='
$o = (& $bb query --comp $comp --max-rows 2 --sql 'SELECT TOP 5 Code, Name FROM Master1' | Out-String)
$p = $o | ConvertFrom-Json
Check 'cap=2 on 5-row query -> 2 rows + truncated' `
    ($LASTEXITCODE -eq 0 -and $p.rows.Count -eq 2 -and $p.truncated -eq $true) $o

$o = (& $bb query --comp $comp --max-rows 0 --sql 'SELECT TOP 5 Code, Name FROM Master1' | Out-String)
$p = $o | ConvertFrom-Json
Check 'max-rows 0 -> unlimited, no flag' `
    ($LASTEXITCODE -eq 0 -and $p.rows.Count -eq 5 -and $null -eq $p.truncated) $o

Write-Output '===== C. serve: read-only default (no flags) ====='
$job = Start-BridgeServe -Port 9841
$r = Invoke-Http 'http://127.0.0.1:9841/query' 'POST' 'application/json' '{"sql":"DELETE FROM Master1"}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'serve default read-only: DELETE -> 403 query_not_allowed' `
    ($r.st -eq 403 -and $p.code -eq 'query_not_allowed') "st=$($r.st) $($r.body)"

$r = Invoke-Http 'http://127.0.0.1:9841/query' 'POST' 'application/json' `
    '{"sql":"SELECT TOP 1 Code FROM Master1; DROP TABLE Master1"}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'serve default read-only: multi-statement -> 403' `
    ($r.st -eq 403 -and $p.code -eq 'query_not_allowed') "st=$($r.st) $($r.body)"

$r = Invoke-Http 'http://127.0.0.1:9841/query' 'POST' 'application/json' `
    '{"sql":"SELECT TOP 2 Code, Name FROM Master1"}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'serve default read-only: SELECT passes' `
    ($r.st -eq 200 -and $p.ok -eq $true -and $p.rows.Count -eq 2) "st=$($r.st) $($r.body)"

$r = Invoke-Http 'http://127.0.0.1:9841/query' 'POST' 'application/xml' '{"sql":"DELETE FROM Master1"}' 'application/json'
Check 'refusal honors Accept: xml (<Error code=403 error=query_not_allowed>)' `
    ($r.st -eq 403 -and $r.body -like "*code='403'*query_not_allowed*") "st=$($r.st) $($r.body)"
Stop-BridgeServe $job

Write-Output '===== D. serve: cap via --max-rows ====='
$job = Start-BridgeServe -Port 9842 -Extra @('--query-mode', 'read-only', '--max-rows', '2')
$r = Invoke-Http 'http://127.0.0.1:9842/query' 'POST' 'application/json' `
    '{"sql":"SELECT TOP 5 Code, Name FROM Master1"}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'serve cap=2 -> 2 rows + truncated:true' `
    ($r.st -eq 200 -and $p.rows.Count -eq 2 -and $p.truncated -eq $true) "st=$($r.st) $($r.body)"

$r = Invoke-Http 'http://127.0.0.1:9842/query' 'POST' 'application/xml' `
    '{"sql":"SELECT TOP 5 Code, Name FROM Master1"}' 'application/json'
$rowCount = ([regex]::Matches($r.body, '<z:row ')).Count
Check 'xml mode also caps (2 rows; legacy shape has no marker)' `
    ($r.st -eq 200 -and $rowCount -eq 2) "st=$($r.st) rows=$rowCount"
Stop-BridgeServe $job

Write-Output '===== E. serve: --query-mode off ====='
$job = Start-BridgeServe -Port 9843 -Extra @('--query-mode', 'off')
$r = Invoke-Http 'http://127.0.0.1:9843/query' 'POST' 'application/json' `
    '{"sql":"SELECT TOP 1 Code FROM Master1"}' 'application/json'
$p = $r.body | ConvertFrom-Json
Check 'serve off: SELECT -> 403 query_not_allowed' `
    ($r.st -eq 403 -and $p.code -eq 'query_not_allowed') "st=$($r.st) $($r.body)"

$r = Invoke-Http 'http://127.0.0.1:9843/query' 'POST' 'application/json' '{"nonsense"' 'application/json'
Check 'serve off: /query refuses before body parsing (route disabled)' `
    ($r.st -eq 403) "st=$($r.st) $($r.body)"
Stop-BridgeServe $job

Finish-Tests '05-query-guard'
