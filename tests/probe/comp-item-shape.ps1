# Iteration 21 discovery: GetCompList items are nested VB6 Collections.
# Probe the inner items. Run under x86 PowerShell.
$obj = New-Object -ComObject Busy2L21.CFixedInterface
$list = $obj.GetCompList('C:\BusyWin\DATA\')
Write-Output ('outer count=' + $list.Count())
for ($i = 1; $i -le $list.Count(); $i++) {
    $inner = $list.Item($i)
    Write-Output ('--- outer item ' + $i + ': inner count=' + $inner.Count())
    for ($j = 1; $j -le $inner.Count(); $j++) {
        $v = $inner.Item($j)
        $kind = if ($null -eq $v) { 'null' } else { $v.GetType().FullName }
        $shown = try { [string]$v } catch { '<toString failed>' }
        Write-Output ('    [' + $j + '] ' + $kind + ' = ' + $shown)
    }
}


