# BUSY constants (masters & voucher types)

> Full migration of *BUSY Constants.doc*. These integer codes are inputs to
> `p_MasterType` / `p_VchType` (COM) and to `?type=` / `args[0]` in the
> bridge. Codes verified against live DEMO data (`Account master = 2`,
> `SALE = 9`).

## Master types

| Code | Constant | Code | Constant |
|---|---|---|---|
| 1 | `ACCOUNT_GROUP_MASTER` | 19 | `BROKER_MASTER` |
| 2 | `ACCOUNT_MASTER` | 20 | `AUTHOR_MASTER` |
| 3 | `COST_CENTER_GROUP_MASTER` | 21 | `VOUCHER_SERIES_MASTER` |
| 4 | `COST_CENTER_MASTER` | 22 | `TDS_MASTER` |
| 5 | `ITEM_GROUP_MASTER` | 24 | `BRANCH_MASTER` |
| 6 | `ITEM_MASTER` | 25 | `TAX_CATEGORY_MASTER` |
| 7 | `CURRENCY_MASTER` | 26 | `MASTER_SERIES_GROUP_MASTER` |
| 8 | `UNIT_MASTER` | 27 | `EMPLOYEE_MASTER` |
| 9 | `BILL_SUNDRY_MASTER` | 28 | `EMPLOYEE_GROUP_MASTER` |
| 10 | `MATERIAL_CENTER_GROUP_MASTER` | 29 | `SALARY_COMPONENT_MASTER` |
| 11 | `MATERIAL_CENTER_MASTER` | 30 | `DISCOUNT_STRUCTURE_MASTER` |
| 12 | `FORM_MASTER` | 31 | `MARKUP_STRUCTURE_MASTER` |
| 13 | `SALE_TYPE_MASTER` | 32 | `SCHEME_MASTER` |
| 14 | `PURCHASE_TYPE_MASTER` | 33 | `EXECUTIVE_MASTER` |
| 15 | `BILL_OF_MATERIAL_MASTER` | 34 | `CONTACT_GROUP_MASTER` |
| 16 | `UNIT_CONVERSION_MASTER` | 36 | `CONTACT_MASTER` |
| 17 | `CURRENCY_CONVERSION_MASTER` | | |
| 18 | `STANDARD_NARRATION_MASTER` | | |

(23 and 35 are unused in the source document — gaps preserved.)

## Voucher types

| Code | Constant | Code | Constant |
|---|---|---|---|
| 2 | `PURCHASE` | 14 | `RECEIPT` |
| 3 | `SALE_RETURN` | 15 | `CONTRA` |
| 4 | `MATERIAL_RECEIPT` | 16 | `JOURNAL` |
| 5 | `STOCK_TRANSFER` | 17 | `DEBIT_NOTE` |
| 6 | `PRODUCTION` | 18 | `CREDIT_NOTE` |
| 7 | `UNASSEMBLE` | 19 | `PAYMENT` |
| 8 | `STOCK_JOURNAL` | 21 | `FORMS_RECEIVED` |
| 9 | `SALE` | 22 | `FORMS_ISSUED` |
| 10 | `PURCHASE_RETURN` | 26 | `SALE_QUOTATION` |
| 11 | `MATERIAL_ISSUE` | 27 | `PURCHASE_QUOTATION` |
| 12 | `SALE_ORDER` | | |
| 13 | `PURCHASE_ORDER` | | |

## Usage

```powershell
# SAVE AN ACCOUNT MASTER (master type 2)
$a = '[2, {"Account":{"Name":"...", ...}}, {"$byref":""}, false]'
busy-bridge call --comp COMP0001 --method SaveMasterFromXML --args-b64 <b64>

# legacy web service: add a SALE voucher (voucher type 9)
#   SC:2  VchType: 9  VchXML: <Sale>...</Sale>

# in-process VBScript (reports/validations) the same values are exposed as
# BusyConst.ACC_MAST, BusyConst.SALE, ...
```

> The original also carried the complete *BUSY Functions* catalog — that is
> now [function-reference.md](function-reference.md), generated from the
> live type library instead of a stale document.
