# 11 - /v1 resource facade + cursor paging (issue #7) against a live company.
#   powershell -File tests/live/11-v1.ps1
. (Join-Path $PSScriptRoot 'common.ps1')
$base = 'http://127.0.0.1:9820'

function Invoke-V1($url, $method, $bodyText) {
    # JSON GET/POST helper (positive paths only)
    $r = Invoke-Http $url $method 'application/json' $bodyText 'application/json'
    return $r
}

$job = Start-BridgeServe -Port 9820
try {
    Write-Output '--- GET /v1 (surface index) ---'
    $idx = (Invoke-WebRequest "$base/v1" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'v1 index names resources' (
        $idx.ok -and $idx.resource -eq 'v1/index' -and
        ($idx.result.resources -contains 'accounts') -and ($idx.result.resources -contains 'vouchers')
    ) ($idx | ConvertTo-Json -Compress)

    Write-Output '--- list accounts: limit + page envelope ---'
    $p1 = (Invoke-WebRequest "$base/v1/accounts?limit=3" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'page 1: 3 items, has_more, opaque cursor' (
        $p1.ok -and $p1.resource -eq 'v1/accounts' -and $p1.result.items.Count -eq 3 -and
        $p1.result.page.limit -eq 3 -and $p1.result.page.has_more -eq $true -and
        $p1.result.page.next_cursor -and $p1.result.page.next_cursor -notmatch '[+/=]'
    ) ($p1 | ConvertTo-Json -Compress)

    Write-Output '--- follow cursor: page 2 disjoint + ordered ---'
    $cur = [uri]::EscapeDataString($p1.result.page.next_cursor)
    $p2 = (Invoke-WebRequest "$base/v1/accounts?limit=3&cursor=$cur" -UseBasicParsing).Content | ConvertFrom-Json
    $n1 = @($p1.result.items | ForEach-Object { $_.name })
    $n2 = @($p2.result.items | ForEach-Object { $_.name })
    Check 'page 2: no overlap with page 1' (
        -not (@($n2 | Where-Object { $n1 -contains $_ }).Count -gt 0)
    ) "p1=[$($n1 -join ',')] p2=[$($n2 -join ',')]"
    Check 'page 2: strictly after page 1 last name (keyset order)' (
        $n2[0] -gt $n1[-1]
    ) "last1=$($n1[-1]) first2=$($n2[0])"

    Write-Output '--- walk all pages: total == full-list count ---'
    $seen = New-Object System.Collections.Generic.HashSet[string]
    foreach ($n in $n1) { $null = $seen.Add($n) }
    foreach ($n in $n2) { $null = $seen.Add($n) }
    $c = $p2.result.page.next_cursor
    $pages = 2
    while ($c) {
        $cu = [uri]::EscapeDataString($c)
        $px = (Invoke-WebRequest "$base/v1/accounts?limit=3&cursor=$cu" -UseBasicParsing).Content | ConvertFrom-Json
        foreach ($it in $px.result.items) { $null = $seen.Add($it.name) }
        $c = $px.result.page.next_cursor
        $pages++
        if ($pages -gt 500) { break } # safety: DEMO has ~200 accounts
    }
    $full = (Invoke-WebRequest "$base/v1/accounts?limit=0" -UseBasicParsing).Content | ConvertFrom-Json
    Check "paged walk saw every account exactly once ($pages pages)" (
        $seen.Count -eq $full.result.items.Count
    ) "seen=$($seen.Count) full=$($full.result.items.Count)"

    Write-Output '--- q + cursor compose ---'
    $qa = (Invoke-WebRequest "$base/v1/accounts?limit=1&q=Cash" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'q filter works in v1' ($qa.result.items.Count -ge 1 -and $qa.result.items[0].name -like '*Cash*') ($qa | ConvertTo-Json -Compress)

    Write-Output '--- bad cursor -> 400 bad_args ---'
    $bad = Invoke-V1 "$base/v1/accounts?cursor=!!notb64!!" 'GET' $null
    Check 'bad cursor rejected with machine code' ($bad.st -eq 400 -and $bad.body.Contains('"code":"bad_args"')) "st=$($bad.st) body=$($bad.body)"

    Write-Output '--- bad limit -> 400 bad_args ---'
    $badl = Invoke-V1 "$base/v1/accounts?limit=abc" 'GET' $null
    Check 'bad limit rejected' ($badl.st -eq 400 -and $badl.body.Contains('"code":"bad_args"')) "st=$($badl.st) body=$($badl.body)"

    Write-Output '--- get account by path name (URL-encoded) ---'
    $acc = (Invoke-WebRequest "$base/v1/accounts/Cash" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'get by name: identity resolved' ($acc.ok -and $acc.result.name -eq 'Cash' -and $acc.result.code -gt 0) ($acc | ConvertTo-Json -Compress)
    $missing = Invoke-V1 "$base/v1/accounts/ZigNoSuchAcct7f3a" 'GET' $null
    Check 'unknown name -> 404 not_found' ($missing.st -eq 404 -and $missing.body.Contains('"code":"not_found"')) "st=$($missing.st)"

    Write-Output '--- XML mode: v1 list envelope ---'
    $xmlr = Invoke-Http "$base/v1/accounts?limit=2" 'GET' 'application/xml' $null $null
    Check 'XML list: Op envelope with resource name' (
        $xmlr.st -eq 200 -and $xmlr.body.StartsWith('<Op><name>v1/accounts</name><result>') -and $xmlr.body.Contains('<next_cursor>')
    ) $xmlr.body.Substring(0, [Math]::Min(180, $xmlr.body.Length))

    Write-Output '--- create/update/delete account round-trip via /v1 ---'
    $Name = 'ZigV1Test'
    & $script:Bridge query --comp $script:Comp --sql "SELECT Code FROM Master1 WHERE Name = '$Name'" | Out-Null
    $created = Invoke-V1 "$base/v1/accounts" 'POST' ('{"name":"' + $Name + '","parent":"Cash-in-hand"}')
    Check 'POST /v1/accounts creates' ($created.st -eq 200 -and $created.body.Contains('"' + $Name + '"')) $created.body
    $got = (Invoke-WebRequest "$base/v1/accounts/$Name" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'created account readable' ($got.ok -and $got.result.name -eq $Name) ($got | ConvertTo-Json -Compress)
    $del = Invoke-V1 "$base/v1/accounts/$Name" 'DELETE' $null
    Check 'DELETE /v1/accounts/{name}' ($del.st -eq 200) $del.body
    $gone = Invoke-V1 "$base/v1/accounts/$Name" 'GET' $null
    Check 'deleted account -> 404' ($gone.st -eq 404) "st=$($gone.st)"

    Write-Output '--- vouchers: post 3 journals, page with limit=2, delete ---'
    $vchCodes = @()
    for ($i = 1; $i -le 3; $i++) {
        $doc = '{"type":"journal","date":"2026-08-1' + $i + '","entries":[{"account":"Depreciation A/c","amount":' + (100 + $i) + ',"dr":true},{"account":"Cash","amount":' + (100 + $i) + '}]}'
        $pv = Invoke-V1 "$base/v1/vouchers" 'POST' $doc
        if ($pv.st -ne 200) { Write-Output "voucher $i post failed: $($pv.body)" }
    }
    $v1p = (Invoke-WebRequest "$base/v1/vouchers?limit=2" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'voucher page 1: 2 items + cursor' ($v1p.result.items.Count -eq 2 -and $v1p.result.page.has_more -eq $true -and $v1p.result.page.next_cursor) ($v1p | ConvertTo-Json -Compress)
    $vc = [uri]::EscapeDataString($v1p.result.page.next_cursor)
    $v2p = (Invoke-WebRequest "$base/v1/vouchers?limit=2&cursor=$vc" -UseBasicParsing).Content | ConvertFrom-Json
    $c1 = @($v1p.result.items | ForEach-Object { $_.code })
    $c2 = @($v2p.result.items | ForEach-Object { $_.code })
    Check 'voucher page 2: codes strictly lower (keyset DESC)' (
        $c2.Count -ge 1 -and $c2[0] -lt $c1[-1]
    ) "p1=[$($c1 -join ',')] p2=[$($c2 -join ',')]"
    # cleanup: delete the 3 test vouchers via /v1
    $all = (Invoke-WebRequest "$base/v1/vouchers?limit=5" -UseBasicParsing).Content | ConvertFrom-Json
    foreach ($it in $all.result.items) {
        if ($it.type.name -eq 'Journal' -and $it.date -like '2026-08-1*') {
            $null = Invoke-V1 "$base/v1/vouchers/$($it.code)" 'DELETE' $null
        }
    }
    $left = (Invoke-WebRequest "$base/v1/vouchers?limit=5" -UseBasicParsing).Content | ConvertFrom-Json
    Check 'test vouchers cleaned up' (@($left.result.items | Where-Object { $_.date -like '2026-08-1*' }).Count -eq 0) ($left | ConvertTo-Json -Compress)

    Write-Output '--- reports via /v1 ---'
    $tb = Invoke-V1 "$base/v1/reports/trial-balance?from=2026-04-01&to=2027-03-31" 'GET' $null
    Check 'trial-balance via v1' ($tb.st -eq 200 -and $tb.body.Contains('"totals"')) $tb.body.Substring(0, [Math]::Min(160, $tb.body.Length))
    $brep = Invoke-V1 "$base/v1/reports/nonesuch" 'GET' $null
    Check 'unknown report -> 400 bad_args' ($brep.st -eq 400 -and $brep.body.Contains('"code":"bad_args"')) "st=$($brep.st)"

    Write-Output '--- unknown /v1 route -> 404 ---'
    $nr = Invoke-V1 "$base/v1/nothing" 'GET' $null
    Check 'unknown v1 route 404' ($nr.st -eq 404) "st=$($nr.st)"
} finally {
    Stop-BridgeServe $job
}

Finish-Tests '11-v1'
