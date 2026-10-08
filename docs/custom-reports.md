# Custom reports (VBScript)

> Migrated from *Designing Custom Report.doc*. Workflow and scripting model
> verified as intact on Rel 14; example script:
> [`../examples/vbscript/reports/Acc Day Book.bcr`](../examples/vbscript/reports/).

Custom reports render a BUSY-format report whose *format* is not built in,
using a per-format **VBScript** script that pulls data through predefined
objects and pushes rows to an on-screen grid.

## Prerequisites (unchanged)

- A **UMS license file** (`<dealer>.ums`) copied into the `BusyWin` folder.
- The license is **bound to hard-disk serial numbers** — design only on
  machines whose disk serials the BUSY office has bound
  (*Help → Show Hard Disk Serial No.* to collect them).
- Without the license the *Design Custom Report* menu is not visible.

## Designing a report

1. *Administration → Utilities → Custom Report/Scripts → Design Custom
   Report* → **Add New**.
2. Pick the base report **format**, give it a **title**.
3. **Report Options** — input parameters (e.g. `Start_Date`, `End_Date`,
   `Account_Name`) with user-facing captions.
4. **Configure Report Heading Fields** — columns: *Heading*, *Data Type*
   (Text/Date/Numeric/Numeric-with-Dr./Cr.), *Alignment*, *No. of
   Characters* (width), *No. of Decimal*, *Show Total*.
5. **Report Logic** → *Edit Script* opens the VBScript in VBSEdit.
6. Save; the format appears in the report menu for printing.

## Scripting objects (predefined)

| Object | Purpose | Example |
|---|---|---|
| `BusyLib` | BUSY helper functions | `BusyLib.MasterCode2Name(code)` |
| `BusyConst` | all BUSY constants | `BusyConst.ACC_MAST` |
| `BusyRepOpt` | values of the report options | `BusyRepOpt.OptStartDate` |
| `BusyCompConfig` | company Features/Options | `BusyCompConfig.CurDecimal`, `BusyCompConfig.QtyDecimal` |

## Scripting procedures (predefined)

- `Grid_Throw_Data(p_Data)` — emit one column value for the current row.
- `Grid_Next_Row(p_OnEnterInfo)` — advance to the next row; pass a voucher
  code in `p_OnEnterInfo` to drill into the voucher on Enter (audit-trail
  behavior), `""` for none.
- `Grid_Next_Row_With_Special_Effects(p_OnEnterInfo, p_SEConst)` — same,
  with visual effects.

## Rel 14 notes

- The mechanism and menu path remain as documented; example script files
  (`.bcr`) are plain text and ship in
  [`../examples/vbscript/reports/`](../examples/vbscript/reports/).
- From the outside you can detect formats registered in a company via the
  COM helper `CheckCustomReportFormatExists` (see
  [function-reference.md](function-reference.md)).
- Full original text: [archive/Designing Custom Report.md](<archive/Designing Custom Report.md>).
