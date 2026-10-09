# Enforces the src/ layer dependency rules (Phase 1 architecture):
#   util/**      -> std, builtin, util/**
#   core/**      -> + core/**          (never transport)
#   handlers/**  -> + handlers/** + core/** + util/**   (ERP facade, never transport)
#   transport/** -> + transport/** + handlers/**
#   main.zig     -> transport/** only  (never core/util directly)
# Exits non-zero and lists violations when a layer imports across its border.
$ErrorActionPreference = 'Stop'
$src = (Resolve-Path (Join-Path $PSScriptRoot '..\src')).Path

$rules = @{
    'util'      = @('util')
    'core'      = @('util', 'core')
    'handlers'  = @('util', 'core', 'handlers')
    'transport' = @('util', 'core', 'handlers', 'transport')
}

$violations = New-Object System.Collections.Generic.List[string]
$checked = 0
$files = @(Get-ChildItem -Path $src -Recurse -Filter *.zig)

foreach ($file in $files) {
    $rel = $file.FullName.Substring($src.Length + 1)
    # top-level files inherit the layer of their same-named folder (handlers.zig -> handlers)
    $leaf = if ($rel -match '[\\/]') { ($rel -split '[\\/]')[0] } else { [IO.Path]::GetFileNameWithoutExtension($rel) }
    $layer = if ($rules.ContainsKey($leaf)) { $leaf } else { 'root' }
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
        # top-level targets resolve by their same-named folder (../handlers.zig -> handlers)
        $tleaf = if ($trel -match '[\\/]') { ($trel -split '[\\/]')[0] } else { [IO.Path]::GetFileNameWithoutExtension($trel) }
        $target = if ($rules.ContainsKey($tleaf)) { $tleaf } else { 'root' }
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
