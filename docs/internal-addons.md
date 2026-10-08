# Internal AddOns (custom data entry screens)

> Migrated from *Custom Data Entry Screen (using Internal AddOn).docx*.
> Sample project: [`../examples/vb6-addon/`](../examples/vb6-addon/).

An **Internal AddOn** is an external ActiveX DLL that appears *inside* BUSY
as its own menu entry (menu **Add-Ons**), reading/writing the **currently
open company** — no company selection needed inside the add-on.

## Architecture (as documented, still accurate)

BUSY is three-tier: the EXE (`Busy.EXE`) is the UI tier, the DLL
(`Busy2L.dll`) holds business logic + data access. Any application can use
that logic layer — an add-on is exactly that: a VB6 ActiveX DLL receiving a
live `CFixedInterface` instance from BUSY.

## Building the add-on

1. VB6 → **ActiveX DLL** project (say `Prj_MyAddOn`).
2. Add a class named exactly **`IBusyWin`** with two entry points:

```vb
Public g_FI As Object   ' CFixedInterface instance handed over by BUSY

Public Sub ActivateDB(p_Data As Collection)
    ' called first: connection context
    g_Provider = p_Data(6)
    g_User     = p_Data(1)
    Set g_FI   = p_Data(50)   ' the live CFixedInterface object
End Sub

Public Sub Start()
    ' called second: show your UI
    Set fMain = New frmMain
    fMain.Show vbModal
End Sub
```

- `ActivateDB` receives a `Collection`; element **50** is the ready-to-use
  `CFixedInterface` (XML save/fetch + SQL work exactly as in
  [com-xml-interface.md](com-xml-interface.md)).
- `Start` launches your first form (modal).

## Registering the menu

Create `AddOns.ini` in **`C:\BusyWin\System`**:

```ini
Prj_MyAddOn;My Add-On
```

Format: `<DLL project name>;<menu caption>`. Restart BUSY — the entry
appears under *Add-Ons*.

## Rel 14 notes

- Mechanism and `IBusyWin` contract unchanged; the shipped sample project
  (class `IBusyWin`, `frmMain`, `AddOns.ini`) is preserved in
  [`../examples/vb6-addon/`](../examples/vb6-addon/).
- **New since the old docs:** add-ons may be **.NET** assemblies as well —
  see `CallInternalAddOnDotNetDll` in
  [function-reference.md](function-reference.md).
- The add-on's `CFixedInterface` runs inside BUSY's process — respect the
  company-open rules in [com-xml-interface.md](com-xml-interface.md).
- Full original text:
  [archive/Custom Data Entry Screen(using Internal AddOn).md](<archive/Custom Data Entry Screen(using Internal AddOn).md>).
