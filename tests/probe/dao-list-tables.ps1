$tmp = Join-Path $env:TEMP 'busydb'
# DAO 3.6 (dao360.dll) — no .35 ProgID on this box; CLSID from probe §13.
# 32-bit only: this script must run under SysWOW64 powershell.exe.
# BUSY password-protects its MDBs; try the common candidates.
$type = [type]::GetTypeFromCLSID([guid]'{00000100-0000-0010-8000-00AA006D2EA4}')
$dao = [Activator]::CreateInstance($type)
$pwds = @('', 'busy', 'BUSY', 'Busy', 'admin', 'password', 'busyinfo', 'busyinfotech')
$f1 = Join-Path $tmp 'common.mdb'
$f2 = Join-Path $tmp 'fy2026.mdb'
foreach ($f in @($f1, $f2)) {
    Write-Output ('=== ' + (Split-Path $f -Leaf) + ' ===')
    $opened = $false
    foreach ($p in $pwds) {
        if ($opened) { break }
        try {
            $opt = ';PWD=' + $p
            $db = $dao.OpenDatabase($f, $true, $false, $opt)
            Write-Output ('  opened with PWD="' + $p + '"')
            $opened = $true
            $n = $db.TableDefs.Count
            for ($i = 0; $i -lt $n; $i++) {
                $td = $db.TableDefs.Item($i)
                $name = $td.Name
                if ($name -notlike 'MSys*') {
                    $rows = ''
                    try { $rs = $td.OpenRecordset(0); $rows = $rs.RecordCount; $rs.Close() } catch {}
                    Write-Output ('  ' + $name + '  (rows~' + $rows + ')')
                }
            }
            $db.Close()
        } catch {
            if ($_.Exception.Message -notmatch 'password') { Write-Output ('  err("' + $p + '"): ' + $_.Exception.Message) }
        }
    }
    if (-not $opened) { Write-Output '  no password candidate worked' }
}
