# Fork-parity gate (issue #63): the src/handlers + src/transport slice is
# mirrored between busy-bridge and busy-server. Every legitimate difference
# is an @import rewrite (bridge: relative core/util paths; server:
# @import("busy_bridge").<module>). Anything else is drift - and drift in
# the auth slice would silently diverge the two security postures.
#
# Checks (loud, by construction):
#   1. manifest pairs == actual file-set intersection (new files must be
#      classified; stale manifest entries fail)
#   2. server-only files fail (every server file must be mirrored)
#   3. each pair: identical, imports-only (canon-equal), or allowlisted
#      with reason + pinned hashes (further edits to an allowlisted file
#      fail until consciously re-pinned via -UpdatePins)
#   4. auth slice = zero tolerance: real drift fails even if allowlisted
#   5. unmapped busy_bridge import modules are a config error (exit 2)
#
# Run:            ./scripts/check_fork_parity.ps1 [-ServerRoot <path>]
# Re-pin drift:   ./scripts/check_fork_parity.ps1 -UpdatePins
# Rebuild lists:  ./scripts/check_fork_parity.ps1 -InitManifest
param(
    [string]$BridgeRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$ServerRoot = '',
    [string]$Manifest = '',
    [switch]$InitManifest,
    [switch]$UpdatePins
)
$ErrorActionPreference = 'Stop'
if (-not $ServerRoot) { $ServerRoot = Join-Path (Split-Path $BridgeRoot -Parent) 'busy-server' }
if (-not $Manifest) { $Manifest = Join-Path $PSScriptRoot 'fork-parity-manifest.json' }
# Canonicalize roots: relative paths break the bridge/server prefix-strip
# (enumerated files carry absolute paths; the manifest keys are relative).
$BridgeRoot = (Resolve-Path $BridgeRoot).Path
$ServerRoot = (Resolve-Path $ServerRoot).Path
if (Test-Path $Manifest) { $Manifest = (Resolve-Path $Manifest).Path }

# busy_bridge package exports (lib.zig) -> bridge-tree path. Extend when
# lib.zig gains exports; unmapped modules fail loudly (exit 2).
$module2path = @{
    'com'          = 'core/com.zig'
    'session'      = 'core/com/session.zig'
    'invoke'       = 'core/com/invoke.zig'
    'recordset'    = 'core/com/recordset.zig'
    'surface'      = 'core/com/surface.zig'
    'record'       = 'core/com/record.zig'
    'recordinfo'   = 'core/com/recordinfo.zig'
    'markers'      = 'core/com/markers.zig'
    'marshal'      = 'core/com/marshal.zig'
    'collection'   = 'core/com/collection.zig'
    'result'       = 'core/com/result.zig'
    'utf16'        = 'core/com/utf16.zig'
    'replay_tests' = 'core/com/replay/tests.zig'
    'win32'        = 'core/com/win32.zig'
    'constants'    = 'core/constants.zig'
    'registry'     = 'core/registry.zig'
    'xmlmeta'      = 'core/xmlmeta.zig'
    'json'         = 'util/json.zig'
    'helpers'      = 'util/helpers.zig'
    'sqlguard'     = 'util/sqlguard.zig'
    'xml'          = 'util/xml.zig'
    'xml_write'    = 'util/xml/write.zig'
}

# The auth slice: zero tolerance for real drift (issue #63).
$authSlice = @(
    'handlers/auth.zig',
    'handlers/rights.zig',
    'transport/auth.zig',
    'transport/http.zig',
    'transport/http/routes_auth.zig',
    'transport/http/routes_ops.zig',
    'transport/http/shared.zig',
    'transport/sessions.zig',
    'transport/user_sessions.zig',
    'transport/v1.zig'
)

function Get-RelFiles($root) {
    Get-ChildItem -Path (Join-Path $root 'src') -Recurse -Include *.zig |
        Where-Object { $_.FullName -match '[\\/]src[\\/](handlers|transport)([\\/]|\.zig$)' } |
        ForEach-Object { $_.FullName.Substring(($root.Length + 5)).Replace('\', '/') }
}

function Get-CanonText($rel, $side) {
    $path = Join-Path (Join-Path $script:rootOf[$side] 'src') $rel
    $text = ([IO.File]::ReadAllText($path)).Replace("`r`n", "`n")
    if ($side -eq 'bridge') {
        return [regex]::Replace($text, '@import\("((?:\.\./)*(?:core|util)(?:/[A-Za-z0-9_]+)*\.zig)"\)', {
            param($m)
            $p = $m.Groups[1].Value -replace '^(?:\.\./)+', ''
            return '@import("canon:' + $p + '")'
        })
    }
    # server side
    $canon = [regex]::Replace($text, '@import\("busy_bridge"\)\.([A-Za-z0-9_]+)', {
        param($m)
        $mod = $m.Groups[1].Value
        if ($script:module2path.ContainsKey($mod)) { return '@import("canon:' + $script:module2path[$mod] + '")' }
        $script:unmapped.Add($mod)
        return $m.Value
    })
    if ($canon -match '@import\("busy_bridge"\)') { $script:unmapped.Add("bare package import in $rel") }
    return $canon
}

function Get-Sha256($text) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [Text.Encoding]::UTF8.GetBytes($text)
        return (($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString('x2') }) -join '')
    } finally { $sha.Dispose() }
}

$rootOf = @{ bridge = $BridgeRoot; server = $ServerRoot }
$unmapped = New-Object System.Collections.Generic.List[string]
$violations = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path (Join-Path $BridgeRoot 'src'))) { Write-Output "config error: no src/ under BridgeRoot '$BridgeRoot'"; exit 2 }
if (-not (Test-Path (Join-Path $ServerRoot 'src'))) { Write-Output "config error: no src/ under ServerRoot '$ServerRoot'"; exit 2 }

$bFiles = @(Get-RelFiles $BridgeRoot)
$sFiles = @(Get-RelFiles $ServerRoot)
$pairsActual = @($bFiles | Where-Object { $sFiles -contains $_ } | Sort-Object)
$bridgeOnlyActual = @($bFiles | Where-Object { $sFiles -notcontains $_ } | Sort-Object)
$serverOnlyActual = @($sFiles | Where-Object { $bFiles -notcontains $_ } | Sort-Object)

# ---- manifest handling -----------------------------------------------------
if ($InitManifest) {
    $old = if (Test-Path $Manifest) { Get-Content $Manifest -Raw | ConvertFrom-Json } else { $null }
    $allow = @{}
    if ($old -and $old.PSObject.Properties.Name -contains 'allowlist' -and $old.allowlist) {
        $old.allowlist.PSObject.Properties | ForEach-Object { $allow[$_.Name] = $_.Value }
    }
    $doc = [ordered]@{
        schema              = 1
        note                = 'Fork-parity manifest (issue #63). pairs = mirrored files; bridge_only = bridge-only by design; allowlist = known real drift, each entry needs reason + pinned sha256 of the CANON (import-normalized, LF) text. Regenerate lists with -InitManifest, re-pin drift with -UpdatePins.'
        auth_zero_tolerance = $authSlice
        pairs               = $pairsActual
        bridge_only         = $bridgeOnlyActual
        allowlist           = $allow
    }
    [IO.File]::WriteAllText($Manifest, (($doc | ConvertTo-Json -Depth 6) + "`n"))
    Write-Output ("manifest written: {0} pairs, {1} bridge-only, {2} allowlist entries" -f $pairsActual.Count, $bridgeOnlyActual.Count, $allow.Count)
    exit 0
}

if (-not (Test-Path $Manifest)) { Write-Output "config error: manifest not found: $Manifest (run -InitManifest)"; exit 2 }
$mf = Get-Content $Manifest -Raw | ConvertFrom-Json
$pairsMf = @($mf.pairs)
$bridgeOnlyMf = @($mf.bridge_only)
$allowlist = @{}
if ($mf.PSObject.Properties.Name -contains 'allowlist' -and $mf.allowlist) {
    $mf.allowlist.PSObject.Properties | ForEach-Object { $allowlist[$_.Name] = $_.Value }
}

# 1. manifest vs actual file sets
foreach ($f in $pairsActual) { if ($pairsMf -notcontains $f) { $violations.Add("pair '$f' exists in both repos but is not in the manifest (run -InitManifest, then classify)") } }
foreach ($f in $pairsMf) { if ($pairsActual -notcontains $f) { $violations.Add("manifest pair '$f' no longer exists on both sides (run -InitManifest)") } }
foreach ($f in $bridgeOnlyActual) { if ($bridgeOnlyMf -notcontains $f) { $violations.Add("bridge-only file '$f' is not in the manifest bridge_only list (run -InitManifest)") } }
foreach ($f in $bridgeOnlyMf) { if ($bridgeOnlyActual -notcontains $f) { $violations.Add("manifest bridge_only entry '$f' is no longer bridge-only (run -InitManifest)") } }
# 2. server-only files are always a violation (unmirrored or unclassified)
foreach ($f in $serverOnlyActual) { $violations.Add("server-only file '$f' has no bridge counterpart (mirror it or document via -InitManifest flow)") }
foreach ($f in $authSlice) { if ($pairsMf -notcontains $f) { $violations.Add("auth-slice file '$f' is not a manifested pair - the zero-tolerance slice must stay mirrored") } }

# 3./4. per-pair comparison
$identical = 0; $impOnly = 0; $allowlisted = 0
foreach ($f in $pairsMf) {
    if ($pairsActual -notcontains $f) { continue } # already reported above
    $bRaw = ([IO.File]::ReadAllText((Join-Path (Join-Path $BridgeRoot 'src') $f))).Replace("`r`n", "`n")
    $sRaw = ([IO.File]::ReadAllText((Join-Path (Join-Path $ServerRoot 'src') $f))).Replace("`r`n", "`n")
    if ($bRaw -eq $sRaw) { $identical++; continue }
    $bCanon = Get-CanonText $f 'bridge'
    $sCanon = Get-CanonText $f 'server'
    if ($bCanon -eq $sCanon) { $impOnly++; continue }
    $inAllow = $allowlist.ContainsKey($f)
    if (-not $inAllow) {
        $preview = ''
        $bl = $bCanon -split "`n"; $sl = $sCanon -split "`n"
        $max = [Math]::Max($bl.Count, $sl.Count)
        for ($i = 0; $i -lt $max; $i++) {
            $blv = if ($i -lt $bl.Count) { $bl[$i] } else { '<EOF>' }
            $slv = if ($i -lt $sl.Count) { $sl[$i] } else { '<EOF>' }
            if ($blv -cne $slv) { $preview = "first diff at line $($i + 1)"; break }
        }
        $violations.Add("DRIFT '$f' is not imports-only ($preview) - sync the repos or add an allowlist entry with reason (-UpdatePins)")
        if ($authSlice -contains $f) { $violations.Add("AUTH ZERO-TOLERANCE: '$f' has real drift between the repos") }
        continue
    }
    # allowlisted: pin check
    $entry = $allowlist[$f]
    $bSha = Get-Sha256 $bCanon; $sSha = Get-Sha256 $sCanon
    $pinOk = ($entry.bridge_sha256 -eq $bSha -and $entry.server_sha256 -eq $sSha)
    if (-not $pinOk) {
        $violations.Add("allowlisted '$f' drifted beyond its pinned hashes - review both sides, then re-pin with -UpdatePins (reason: $($entry.reason))")
        if ($authSlice -contains $f) { $violations.Add("AUTH ZERO-TOLERANCE: allowlisted '$f' changed - port instead of re-pinning") }
        continue
    }
    $allowlisted++
    if ($authSlice -contains $f) { $violations.Add("AUTH ZERO-TOLERANCE: '$f' is allowlisted - auth files must stay imports-only") }
}

# 5. unmapped import modules -> config error
if ($unmapped.Count -gt 0) {
    Write-Output 'FORK PARITY CONFIG ERROR - unmapped busy_bridge import form(s):'
    $unmapped | Sort-Object -Unique | ForEach-Object { Write-Output "  $_" }
    Write-Output 'extend $module2path in scripts/check_fork_parity.ps1 (lib.zig exports)'
    exit 2
}

if ($UpdatePins) {
    $changed = 0
    foreach ($k in @($allowlist.Keys)) {
        if ($pairsActual -notcontains $k) { continue }
        $bCanon = Get-CanonText $k 'bridge'
        $sCanon = Get-CanonText $k 'server'
        if ($bCanon -eq $sCanon) {
            Write-Output "note: allowlisted '$k' is now imports-only - drop the entry (run -InitManifest to rebuild)"
            continue
        }
        $e = $allowlist[$k]
        $nb = Get-Sha256 $bCanon; $ns = Get-Sha256 $sCanon
        if ($e.bridge_sha256 -ne $nb -or $e.server_sha256 -ne $ns) {
            $e.bridge_sha256 = $nb; $e.server_sha256 = $ns
            $changed++
            Write-Output "re-pinned '$k'"
        }
    }
    $doc = [ordered]@{
        schema              = $mf.schema
        note                = $mf.note
        auth_zero_tolerance = @($mf.auth_zero_tolerance)
        pairs               = $pairsMf
        bridge_only         = $bridgeOnlyMf
        allowlist           = $mf.allowlist
    }
    [IO.File]::WriteAllText($Manifest, (($doc | ConvertTo-Json -Depth 6) + "`n"))
    Write-Output ("pins updated: {0} entr(ies); manifest rewritten" -f $changed)
    exit 0
}

if ($violations.Count -gt 0) {
    Write-Output "FORK PARITY CHECK FAILED ($($violations.Count) violation(s)):"
    foreach ($v in $violations) { Write-Output "  $v" }
    exit 1
}
Write-Output ("fork parity OK: {0} pairs ({1} identical, {2} imports-only, {3} pinned drift), {4} bridge-only, 0 server-only; roots: bridge={5} server={6}" -f $pairsMf.Count, $identical, $impOnly, $allowlisted, $bridgeOnlyMf.Count, $BridgeRoot, $ServerRoot)
exit 0
