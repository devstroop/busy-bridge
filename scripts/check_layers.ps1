# Enforces the src/ layer dependency rules (Phase 1 architecture):
#   util/**      -> std, builtin, util/**
#   core/**      -> + core/**          (never transport)
#   transport/** -> + transport/**
#   main.zig     -> transport/** only  (never core/util directly)
# Exits non-zero and lists violations when a layer imports across its border.
$ErrorActionPreference = 'Stop'
$src = (Resolve-Path (Join-Path $PSScriptRoot '..\src')).Path

$rules = @{
    'util'      = @('util')
    'core'      = @('util', 'core')
    'transport' = @('util', 'core', 'transport')
}

$violations = New-Object System.Collections.Generic.List[string]
$checked = 0
$files = @(Get-ChildItem -Path $src -Recurse -Filter *.zig)

foreach ($file in $files) {
    $rel = $file.FullName.Substring($src.Length + 1)
    $layer = if ($rel -match '[\\/]') { ($rel -split '[\\/]')[0] } else { 'root' }
    $text = [IO.File]::ReadAllText($file.FullName)
    foreach ($m in [regex]::Matches($text, '@import\("([^"]+)"\)')) {
        $imp = $m.Groups[1].Value
        if ($imp -eq 'std' -or $imp -eq 'builtin') { continue }
        $checked++
        $base = Split-Path $file.FullName -Parent
        $resolved = [IO.Path]::GetFullPath((Join-Path $base $imp))
        $prefix = $src + [IO.Path]::DirectorySeparatorChar
        if (-not $resolved.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            $violations.Add("$rel : import '$imp' escapes src/")
            continue
        }
        $trel = $resolved.Substring($prefix.Length)
        $target = if ($trel -match '[\\/]') { ($trel -split '[\\/]')[0] } else { 'root' }
        $allowed = if ($layer -eq 'root') { @('transport') } else { $rules[$layer] }
        if ($allowed -notcontains $target) {
            $violations.Add("$rel ($layer) imports '$imp' -> layer '$target' (allowed: $($allowed -join ', '))")
        }
    }
}

if ($violations.Count -gt 0) {
    Write-Output "LAYER CHECK FAILED ($($violations.Count) violation(s)):"
    foreach ($v in $violations) { Write-Output "  $v" }
    exit 1
}
Write-Output "layer check OK: $checked imports across $($files.Count) files"
