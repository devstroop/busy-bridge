# Custom validations (VBScript)

> Migrated from *Custom Validation.docx*. Workflow and scripting model
> verified as intact on Rel 14; example scripts:
> [`../examples/vbscript/validations/`](../examples/vbscript/validations/).

Custom validations enforce entry-time rules (or inject information) from a
VBScript attached to a form — e.g. *"Party cannot be saved without a mobile
number"*, or *"auto-fill narration from the Party's optional fields"*.

## Enabling the menu (unchanged)

*Administration → Utilities → Customization → Custom Validation* becomes
visible either by:

1. copying the UMS license (`*.UMS`) into `BusyWin`, **or**
2. starting BUSY with **`CD`** in the shortcut's command-line arguments.

Scripts can be **bound to a serial/dongle number** and password-protected
against modification/deletion.

## Configuring a script

| Format | You specify |
|---|---|
| **Vouchers** | voucher type + form type (+ series name; blank = all series) |
| **Masters** | master type + form type |
| **Main Form** | BUSY main form, or actions on company **open/close** |

Then *Edit Script* writes the logic in VBSEdit.

## Scripting objects (predefined)

| Object | Purpose | Example |
|---|---|---|
| `BusyLib` | BUSY helper functions | `BusyLib.MasterCode2Name(code)` |
| `BusyConst` | BUSY constants | `BusyConst.ACC_MAST` |
| `BusyCompConfig` | company Features/Options | `BusyCompConfig.CurDecimal` |
| `BusyForm` | controls/properties of the active form | `BusyForm.txtName.Text` |

## Voucher data classes (non-visible controls)

Visible controls are read/written through `BusyForm`; everything else
through these classes (index = row of the respective grid):

| Class | Represents | Example |
|---|---|---|
| `BusyVchData` | voucher header (udtVchData) | `BusyVchData.VehicleNo` |
| `BusyItemData` | item-grid row | `BusyItemData.Desc1(p_Row)` |
| `BusyBSData` | bill-sundry row | `BusyBSData.BSCode(p_Row)` |
| `BusyAccData` | accounting-grid row | `BusyAccData.AmountType(p_Row)` |
| `BusyBatchData` | batch row | `BusyBatchData.BatchNo(p_ItemRow, p_BatchRow)` |
| `BusyParamData` | parameter row | `BusyParamData.BCN(p_ItemRow, p_ParamRow)` |
| `BusySNData` | serial-number row | `BusySNData.Desc1(p_ItemRow, p_SNRow)` |
| `BusyJobData` | job-work row | `BusyJobData.JobID(p_ItemRow, p_JobRow)` |
| `BusyCCData` | cost-centre row | `BusyCCData.CCName(p_AccCode, p_CCRow)` |
| `BusyBillRefData` | bill-reference row | `BusyBillRefData.BillRefNo(p_AccCode, p_BillRefRow)` |

The original document continues with the full **events list** — see
[archive/Custom Validation.md](<archive/Custom Validation.md>) for the
complete event catalogue (it is too long to duplicate faithfully here).

## Rel 14 notes

- Mechanism intact; from the outside a company's registered formats are
  detectable via `CheckCustomValidationFormatExists`
  ([function-reference.md](function-reference.md)).
- Example `.bcd` scripts (plain text) ship in
  [`../examples/vbscript/validations/`](../examples/vbscript/validations/).
