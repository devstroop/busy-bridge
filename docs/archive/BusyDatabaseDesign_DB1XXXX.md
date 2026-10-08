<!-- generated from BusyDatabaseDesign_DB1XXXX.xls by scripts/docs/xls_to_md.py -->
# BusyDatabaseDesign_DB1XXXX.xls

## AMCWarrDet

| col0 | col1 |
|---|---|
|  |  |
|  | AMCWarrDet Entity Mapping |
|  |  |
|  Fields |  |
|  |  |
| VchCode | Vchcode |
| SrNo | Serial No |
| RecType | Constants |
| Date | Contract Start Date |
| VchNo | VchNo |
| RefNo | Reference No |
| ItemSerialNo | Serial No of Item in Voucher |
| MasterCode1 | Item Code |
| MasterCode2 | Party Code |
| Value1 | Qty of Item |
| CM1 | Unit Code of the Item |
| Narration | Narration of AMC/warranty |
| ContEndDate | Expiry date of AMC/Warranty |
| I1 | Contract Type Constants |
| Status | Status of Contract |

## BillingDet

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  |  |  |  |  |
|  | BillingDet Entity Mapping |  |  |  |
|  |  |  |  |  |
|  Fields | Sales | Purchase | Sales Return | Purchase Return |
|  |  |  |  |  |
| VchCode | VchCode | VchCode | VchCode | VchCode |
| PartyName | PartyName | PartyName | PartyName | PartyName |
| Address1 | Address1 | Address1 | Address1 | Address1 |
| Address2 | Address2 | Address2 | Address2 | Address2 |
| Address3 | Address3 | Address3 | Address3 | Address3 |
| Address4 | Address4 | Address4 | Address4 | Address4 |
| STNo | TIN No. of the party | TIN No. of the party | TIN No. of the party | TIN No. of the party |
| CSTNo | Central Sales Tax Number | Central Sales Tax Number | Central Sales Tax Number | Central Sales Tax Number |
| EccCode | Ecc Code | Ecc Code | Ecc Code | Ecc Code |
| ExciseRegNo | Excise Registration number | Excise Registration number | Excise Registration number | Excise Registration number |
| PLA No | PLA number | PLA number | PLA number | PLA number |
| Range | Range | Range | Range | Range |
| Division | Division | Division | Division | Division |
| Collectorate | Collectorate | Collectorate | Collectorate | Collectorate |
| MobileNo | Mobile Number | Mobile Number | Mobile Number | Mobile Number |
| Email | Email | Email | Email | Email |
| DrugLicenseNo | Drug license No | Drug license No | Drug license No | Drug license No |

## BRSOpBal

| col0 | col1 |
|---|---|
|  |  |
|  | BRSOpBal Entity Mapping |
|  |  |
|  Fields | Account Master --> Cheque Deposited / Issued |
|  |  |
| SrNo | Serial No |
| MasterCode1 | Bank Account |
| MasterCode2 | Corresponding Account to which cheque deposited / issued |
| OpAmt | Amount |
| Type | Cheque Issued or Deposited |
| ShortNar | Short Narration |
| EntryDate | Date of Deposit / Issued |
| ClrDate | Clearing Date |
| OldVchCode | Old VchCode |
| VchNo | Vch no |

## Checklist

| col0 | col1 | col2 |
|---|---|---|
|  |  |  |
|  | Checklist Entity Mapping |  |
|  |  |  |
|  Fields | Master | Voucher |
|  |  |  |
| Type | Constant Value for Master | Constant value for Voucher |
| Code | Master Code | Voucher Code |
| Action | Constant value for Add / Modify / Approve | Constant value for Add / Modify / Approve |
| ActionTime | Time & Date on which action taken | Time & Date on which action taken |
| UserName | User name  | User name  |
| D1 | Main Qty | Opening Amount |
| D2 | Alt Qty | Opening Main Qty |
| D3 | Amount | Opening Alt Qty |
| D4 |  |  |
| D5 |  |  |
| Notes | Approval Notes | Approval Notes |
| ComputerName | Name of Computer | Name of Computer |

## DailyMessage

| col0 | col1 |
|---|---|
|  |  |
|  | Update Daily Message Utility |
|  |  |
|  Fields |  |
| Date | Date |
| NoOfDays | No. of days, msg is valid |
| VchType | Voucher Type |
| VSCode | Voucher Code |
| Msg1 | Message 1 |
| Msg2 | Message 2 |
| Msg3 |  |
| Msg4 |  |

## DailySum

| col0 | col1 | col2 |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |
|  Fields |  |  |
| MasterCode1 | Account Code | Item Code |
| MasterCode2 | 0 | Material Centre Code |
| MasterType | Acc_Mast | Item_Mast |
| Date | Vch Date | Vch Date |
| Dr1 | Debit Amount | Debit Amount |
| Dr2 |  |  |
| Dr3 |  |  |
| Cr1 | Credit Amount | Credit Amount |
| Cr2 |  |  |
| Cr3 |  |  |
| D1 |  |  |
| D2 |  |  |
| D3 |  |  |
| D4 |  |  |

## DataSync

| col0 |
|---|
|  |
|  Fields |
|  |
| UID |
| BranchCode |
| RecType |
| Type |
| VMType |
| MasterName |
| VchNo |
| Date |
| VchSrCode |
| Createdby |
| CreationTime |
| LastModifiedBy |
| LastModificationTime |
| ApprovedBy |
| ApprovalTime |
| ServerInTime |
| 1 |
| M2 |
| MasterName1 |
| ComputerName |
| OldVchSrName |
| OldVchType |
| VchSrName |
| DeletedBy |
| DeletionTime |
| SrNo |
| CheckType |
| ClearFullVch |
| D1 |
| D2 |
| D3 |
| D4 |
| D5 |
| OldMasterName |
| OldDate |
| OldVchNo |
| OldIdentity |

## EmpLADet

| col0 | col1 |
|---|---|
|  |  |
|  Fields | Employee Loan & Advance |
|  |  |
| EmpCode | Employee Code |
| LAType | Loan / Advance |
| SrNo | Serial Number |
| DueDate | Due Date |
| Amount | Amount |
| IntAmount | Interest Amount |
| Total | Total Amount |
| Remarks | Remarks |

## EventLog

| col0 | col1 |
|---|---|
|  |  |
|  Fields | For maintaining User Log |
|  |  |
| Username | Currentl Logged In User |
| Date | Date |
| WorkedOn |  |
| Description |  |
| UID | Auto Increment |
| ComputerName | Computer Name |
| VersionNo | Major,Minor (Revision) |
| S1 | Logged In / Logged Out |
| SessionID | Login Session ID = 1 |

## DeletedInfo

| col0 | col1 |
|---|---|
|  |  |
|  | DeletedInfo  |
|  |  |
|  Fields |  |
|  |  |
| Type | Type |
| VchMastType | VchMastType |
| Identity | Identity |
| DeletedBy | Name |
| DeletionTime | Now |
| OrgVchAmtBaseCur | Total Voucher Amount Original |
| ModVchAmtBaseCur | Total Voucher Amount Modified |
| Computer Name | Name of Computer |

## Excise

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 |
|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |
|  | Excise Entity Mapping |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Sales | Purchase | Sales Return | Purchase Return | Payment | Receipt | Debit Note | Credit Note | Journal | Adjustment of Excise amounts |
|  |  |  |  |  |  |  |  |  |  |  |
| RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode |
| DocName | DocName | DocName | DocName | DocName | DocName | DocName | DocName | DocName | DocName | DocName |
| VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo=" " |
| SrNo | SrNo.(auto gen) | SrNo.(auto gen) | SrNo.(auto gen) | SrNo.(auto gen) | SrNo.(auto gen) | SrNo.(auto gen) |  |  |  | SrNo.(auto gen) |
| Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date |
| Value | BED amount | BED amount | BED amount | BED amount | value | Amount | Value | Value | Value | value |
| Balance | Balance | Balance | Balance | Balance |  | Balance |  |  |  | Balance |
| Value1 | AED amount | AED amount | AED amount | AED amount | value1 | 0 | 0 | 0 | 0 | Value1 |
| Balance1 |  | Balance1 | Balance1 | Balance1 | 0 | 0 |  |  |  | 0 |
| Value2 | Cess Amount | Cess Amount | Cess Amount | Cess Amount | Value |  | Value2 | Value2 | Value2 | Value2 |
| Balance2 |  |  |  |  |  |  |  |  |  |  |
| Value3 | SHE Cess Amount | SHE Cess Amount | SHE Cess Amount | SHE Cess Amount | Value | Value | Value | Value | Value | Value |
| ValueType | constant | constant | constant | constant | constant | constant | ValueType | ValueType | ValueType | Constant |
| DateOfDeposit |  |  |  |  | Deposit Date |  | DepositDate | DepositDate | DepositDate |  |
| Dummy |  |  |  |  |  |  |  |  |  |  |
| SupplierType |  |  |  |  |  |  |  |  |  |  |
| ChallanNo |  |  |  |  | Challan Number |  |  |  | Challan Number |  |
| BankCode |  |  |  |  | Bank Code |  |  |  | Bank Code |  |
| PeriodEnding |  |  |  |  | Period for which tax deposited |  |  |  | Period for which tax deposited |  |
| D1 | ServceTaxCredit Allowed | ServceTaxCredit Allowed | ServceTaxCredit Allowed | ServceTaxCredit Allowed | ServceTaxCredit Allowed - For Service Tax Interests - For Excise | ServceTaxCredit Allowed |  |  | ServceTaxCredit Allowed - For Service Tax Interests - For Excise |  |
| D2 |  |  |  |  | Arrears |  |  |  | Arrears |  |
| D3 |  |  |  |  | Other Interest |  |  |  | Other Interest |  |
| D4 |  |  |  |  | Other Arrears |  |  |  | Other Arrears |  |
| D5 |  |  |  |  | Misc Payment |  |  |  | Misc Payment |  |
| BranchCode | Branch Code | Branch Code | Branch Code | Branch Code |  |  |  |  |  |  |
| ClearanceType | Clearance Type |  |  |  |  |  |  |  |  |  |
| Notification Availed | Notification Availed |  |  |  |  |  |  |  |  |  |
| NotificationNo | Notification No |  |  |  |  |  |  |  |  |  |

## ExternalData

| col0 | col1 |
|---|---|
|  |  |
|  | ExternalData |
|  |  |
| Fields |  |
|  |  |
| KeyType |  |
| KeyCode |  |
| AppName |  |
| CanEditKeyData |  |
| CanDeleteKey |  |
| I1 |  |
| L1 |  |
| D1 |  |
| B1 |  |
| DT1 |  |
| C1 |  |
| Connected |  |
| ConnectedCode |  |

## Folio1

| col0 | col1 | col2 | col3 | col4 | col5 | col6 |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |
|  | Folio1 Entity Mapping |  |  |  |  |  |
|  |  |  |  |  |  |  |
|  Fields | ACC_MAST  | AGRP_MAST | CC_MAST  | CCGRP_MAST  |  ITEM_MAST  | IGRP_MAST  |
|  |  |  |  |  |  |  |
| MasterCode | Mastercode | Mastercode | Mastercode | Mastercode | Mastercode | Mastercode |
| MasterType | Mastertype | Mastertype | Mastertype | Mastertype | Mastertype | Mastertype |
| D1 | Opening Balance |  | Opening Balance |  | OpStockMainUnit qty |  |
| D2 | OpBalInAltCur |  |  |  | OpStockAltUnit qty |  |
| D3 |  |  |  |  | OpAmount qty |  |
| D4 | Prev. year bal. |  |  |  |  |  |
| D5 |  |  |  |  |  |  |
| D6 |  |  |  |  |  |  |
| D7 |  |  |  |  |  |  |
| D8 |  |  |  |  |  |  |
| D9 |  |  |  |  |  |  |
| D10 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D11 | Debit Main Curr (From Month 1 to 12) | Debit Main Curr (From Month 1 to 12) | Debit Sale (From Month 1 to 12) | Debit Sale (From Month 1 to 12) | Qty Out (Main unit) (From Month 1 to 12) | Qty Out (Main unit) (From Month 1 to 12) |
| D12 |  |  |  |  |  |  |
| D13 |  |  |  |  |  |  |
| D14 |  |  |  |  |  |  |
| D15 |  |  |  |  |  |  |
| D16 |  |  |  |  |  |  |
| D17 |  |  |  |  |  |  |
| D18 |  |  |  |  |  |  |
| D19 |  |  |  |  |  |  |
| D20 |  |  |  |  |  |  |
| D21 |  |  |  |  |  |  |
| D22 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D23 | Credit Main Curr (From Moth 1 to 12) | Credit Main Curr (From Moth 1 to 12) | Credit Sale (From Moth 1 to 12) | Credit Sale (From Moth 1 to 12) | Quantity In (Main Unit)(From Month 1 to 12) | Quantity In (Main Unit)(From Month 1 to 12) |
| D24 |  |  |  |  |  |  |
| D25 |  |  |  |  |  |  |
| D26 |  |  |  |  |  |  |
| D27 |  |  |  |  |  |  |
| D28 |  |  |  |  |  |  |
| D29 |  |  |  |  |  |  |
| D30 |  |  |  |  |  |  |
| D31 |  |  |  |  |  |  |
| D32 |  |  |  |  |  |  |
| D33 |  |  |  |  |  |  |
| D34 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D35 | Debit Alt Curr (From Month 1 to 12) | Debit Alt Curr(From Month 1 to 12) | Debit Purchase (From Month 1 to 12) | Debit Purchase (From Month 1 to 12) | Quantity Out (Alt Unit)(From Month 1to 12) | Quantity Out (Alt Unit)(From Month 1to 12) |
| D36 |  |  |  |  |  |  |
| D37 |  |  |  |  |  |  |
| D38 |  |  |  |  |  |  |
| D39 |  |  |  |  |  |  |
| D40 |  |  |  |  |  |  |
| D41 |  |  |  |  |  |  |
| D42 |  |  |  |  |  |  |
| D43 |  |  |  |  |  |  |
| D44 |  |  |  |  |  |  |
| D45 |  |  |  |  |  |  |
| D46 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D47 | Credit Alt Curr (From Month1 to 12) | Credit Alt Curr (From Month1 to 12) | Credit Purchase (From Month1 to 12) | Credit Purchase (From Month1 to 12) | Quantity In (Alt Unit)(From Month 1 to 12) | Quantity In (Alt Unit)(From Month 1 to 12) |
| D48 |  |  |  |  |  |  |
| D49 |  |  |  |  |  |  |
| D50 |  |  |  |  |  |  |
| D51 |  |  |  |  |  |  |
| D52 |  |  |  |  |  |  |
| D53 |  |  |  |  |  |  |
| D54 |  |  |  |  |  |  |
| D55 |  |  |  |  |  |  |
| D56 |  |  |  |  |  |  |
| D57 |  |  |  |  |  |  |
| D58 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D59 |  |  | Debit Income (From Month 1to 12) | Debit Income (From Month 1to 12) | Value Qty Out(From Month 1 to1 2) | Value Qty Out(From Month 1 to1 2) |
| D60 |  |  |  |  |  |  |
| D61 |  |  |  |  |  |  |
| D62 |  |  |  |  |  |  |
| D63 |  |  |  |  |  |  |
| D64 |  |  |  |  |  |  |
| D65 |  |  |  |  |  |  |
| D66 |  |  |  |  |  |  |
| D67 |  |  |  |  |  |  |
| D68 |  |  |  |  |  |  |
| D69 |  |  |  |  |  |  |
| D70 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D71 |  |  | Credit Income (From Moth 1 to 12) | Credit Income (From Moth 1 to 12) | Value Qty In (From Moth 1 to 12) | Value Qty In (From Moth 1 to 12) |
| D72 |  |  |  |  |  |  |
| D73 |  |  |  |  |  |  |
| D74 |  |  |  |  |  |  |
| D75 |  |  |  |  |  |  |
| D76 |  |  |  |  |  |  |
| D77 |  |  |  |  |  |  |
| D78 |  |  |  |  |  |  |
| D79 |  |  |  |  |  |  |
| D80 |  |  |  |  |  |  |
| D81 |  |  |  |  |  |  |
| D82 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D83 |  |  | Debit Expense (From Month 1 to 12) | Debit Expense (From Month 1 to 12) |  |  |
| D84 |  |  |  |  |  |  |
| D85 |  |  |  |  |  |  |
| D86 |  |  |  |  |  |  |
| D87 |  |  |  |  |  |  |
| D88 |  |  |  |  |  |  |
| D89 |  |  |  |  |  |  |
| D90 |  |  |  |  |  |  |
| D91 |  |  |  |  |  |  |
| D92 |  |  |  |  |  |  |
| D93 |  |  |  |  |  |  |
| D94 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D95 |  |  | Credit Expense (From Month 1 to 12) | Credit Expense (From Month 1 to 12) |  |  |
| D96 |  |  |  |  |  |  |
| D97 |  |  |  |  |  |  |
| D98 |  |  |  |  |  |  |
| D99 |  |  |  |  |  |  |
| D100 |  |  |  |  |  |  |
| D101 |  |  |  |  |  |  |
| D102 |  |  |  |  |  |  |
| D103 |  |  |  |  |  |  |
| D104 |  |  |  |  |  |  |
| D105 |  |  |  |  |  |  |
| D106 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D107 |  |  |  |  |  |  |
| D108 |  |  |  |  |  |  |
| D109 |  |  |  |  |  |  |
| D110 |  |  |  |  |  |  |
| D111 | Budget annual | Budget annual |  |  |  |  |
| D112 | Budget (From month 1to 12) | Budget (From month 1to 12) |  |  |  |  |
| D113 |  |  |  |  |  |  |
| D114 |  |  |  |  |  |  |
| D115 |  |  |  |  |  |  |
| D116 |  |  |  |  |  |  |
| D117 |  |  |  |  |  |  |
| D118 |  |  |  |  |  |  |
| D119 |  |  |  |  |  |  |
| D120 |  |  |  |  |  |  |
| D121 |  |  |  |  |  |  |
| D122 |  |  |  |  |  |  |
| D123 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
| D124 | Target annual | Target annual |  |  |  |  |
| D125 | Target (From month 1 to 12) | Target (From month 1 to 12) |  |  |  |  |
| D126 |  |  |  |  |  |  |
| D127 |  |  |  |  |  |  |
| D128 |  |  |  |  |  |  |
| D129 |  |  |  |  |  |  |
| D130 |  |  |  |  |  |  |
| D131 |  |  |  |  |  |  |
| D132 |  |  |  |  |  |  |
| D133 |  |  |  |  |  |  |
| D134 |  |  |  |  |  |  |
| D135 |  |  |  |  |  |  |
| D136 |  |  |  |  |  |  |
| D137 |  |  |  |  |  |  |
| D138 |  |  |  |  |  |  |
| D139 |  |  |  |  |  |  |
| D140 |  |  |  |  |  |  |
| D141 |  |  |  |  |  |  |
| D142 |  |  |  |  |  |  |
| D143 |  |  |  |  |  |  |
| D144 |  |  |  |  |  |  |
| D145 |  |  |  |  |  |  |
| D146 |  |  |  |  |  |  |
| D147 |  |  |  |  |  |  |
| D148 |  |  |  |  |  |  |
| D149 |  |  |  |  |  |  |
| D150 |  |  |  |  |  |  |
| B1 |  |  |  |  |  |  |
| B2 |  |  |  |  |  |  |
| B3 |  |  |  |  |  |  |
| B4 |  |  |  |  |  |  |
| B5 |  |  |  |  |  |  |
| B6 |  |  |  |  |  |  |
| B7 |  |  |  |  |  |  |
| B8 |  |  |  |  |  |  |
| B9 |  |  |  |  |  |  |
| B10 |  |  |  |  |  |  |
| B11 |  |  |  |  |  |  |
| B12 |  |  |  |  |  |  |

## Help1

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 | col13 | col14 | col15 | col16 | col17 | col18 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Help1 Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Acc _Mast | AGRP_MAST | CC_MAST  | CCGRP_MAST  | BROKER_MAST  | AUTHOR_MAST  |  ITEM_MAST  | IGRP_MAST  | MC_MAST  | MCGRP_MAST  | UNIT_MAST  | BS_MAST | BOM_MAST  | FORM_MAST  | ST_MAST  | PT_MAST  | TDS_Mast | Cur_Mast |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| RecType | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant |
| NameAlias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name/Alias | Name | Name | Name | Name | Name | Name |
| Code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | master code | master code | Master code | master code | master code | Master code | Master code | Master code | Master code | Master code | Master code |
| MasterType | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type |
| NameOrAlias | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant | Constant |
| AdditionalInfo | Additional info in drop down list string |  |  |  |  |  | Additional info in drop down list string |  |  |  |  |  |  |  |  |  |  |  |
| ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup | ParentGroup |
| MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries | MasterSeries |
| Status | Constants |  |  |  |  |  | Constants |  |  |  |  |  |  |  |  |  |  |  |
| DefaultMCCode |  |  |   |  |  |  | MC Code of Item |  |  |  |  |  |  |  |  |  |  |  |
| AddInfoBt1 | Additional Info in String |  |  |  |  |  | Additional Info in String |  |  |  |  |  |  |  |  |  |  |  |
| AddInfoBt2 | Additional Info in String |  |  |  |  |  | Additional Info in String |  |  |  |  |  |  |  |  |  |  |  |
| AddInfoBt3 | Additional Info in String |  |  |  |  |  | Additional Info in String |  |  |  |  |  |  |  |  |  |  |  |
| AddInfoBt4 | Additional Info in String |  |  |  |  |  | Additional Info in String |  |  |  |  |  |  |  |  |  |  |  |

## Help2

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 | col13 | col14 | col15 | col16 | col17 | col18 | col19 | col20 | col21 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Help2 Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Acc_mast | Item_mast | MC_MAST  | Sales Order | Purchase Order | Sales | Purchase | Sales Return | Purchase return | Payment | Receipt | Journal | Contra | Debit Note | Credit Note | Mat. Iss. | Mat. Rec. | Production | Unassemble | Stock Journal | Stock Transfer |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| RecType1 | H2_MASTER | H2_MASTER | H2_MASTER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER | H2_VOUCHER |
| RecType2 | Optional Field No. | Optional Field No. | Optional Field No | OptionalFieldNo. | OptionalFieldNo. | Optional Field No. | Optional Field No. | Optional Field No. | Optional Field No. | Optional Field no. | Optional Field no. | opt field no. | opt field no. | Optional Field No. | Optional Field No. | Optional Field No. | Optionsl Field No. | OptionalField No. | OptionalField No. | OptionalFielNo. | Optional Field No. |
| RecType3 | Master type | Master type | Master type | SeriesCode | SeriesCode | SeriesCode | SeriesCode | SeriesCode | SeriesCode | Series Code | Series Code | Series Code | SeriesCode | SeriesCode | SeriesCode | SeriesCode | SeriesCode | SeriesCode | SeriesCode | SeriesCode | SeriesCode |
| Name | Optional Field value | Optional Field value | Optional Field value | Optional Field value/Additional Field with Item | Optional Field value/Additional Field with Item | Optional Field value/Transport DetailsAdditional Field with Item | Optional Field value/Transport DetailsAdditional Field with Item | Optional Field value/Transport DetailsAdditional Field with Item | Optional Field value/Transport DetailsAdditional Field with Item | Optional Field value/Short Narrations | Optional Field value/Short Narrations | opt. Field value | Optional Field value/Short Narrations | Optional Field value/Short Narrations | Optional Field value/Short Narrations | Optional Field value/Transport, GrNo.,Vehicle, Station | Optional Field value/Transport, GrNo.,Vehicle, Station | Optional Field value/Additional Field with Item | Optional Field value/Additional Field with Item | Optional Field value/Additional Field with Item | Optional Field value/Transport, GrNo.,Vehicle, Station |

## ItemDesc

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | ItemDesc Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Sales Order | Purchase Order | Purchase | Sales | Sales Return | Purchase Return | Production | Unassemble | Stock Journal | Stock Transfer | Material Issue | Material Received |
|  |  |  |  |  |  |  |  |  |  |  |  |  |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode |
| SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo |
| Desc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |  ItemDesc1 |
| Desc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |  ItemDesc2 |
| Desc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |  ItemDesc3 |
| Desc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |  ItemDesc4 |
| Desc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |  ItemDesc5 |
| Desc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |  ItemDesc6 |
| Desc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |  ItemDesc7 |
| Desc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |  ItemDesc8 |
| Desc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |  ItemDesc9 |
| Desc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |  ItemDesc10 |
| D1 |  |  | Free Qty | Free Qty | Free Qty | Free Qty |  |  |  | Free Qty | Free Qty | Free Qty |
| D2 |  |  | Free Qty in Main Unit | Free Qty in Main Unit | Free Qty in Main Unit | Free Qty in Main Unit |  |  |  | Free Qty in Main Unit | Free Qty in Main Unit | Free Qty in Main Unit |
| D3 |  |  | Free Qty in Alt. Unit | Free Qty in Alt. Unit | Free Qty in Alt. Unit | Free Qty in Alt. Unit |  |  |  | Free Qty in Alt. Unit | Free Qty in Alt. Unit | Free Qty in Alt. Unit |
| I1 |  |  |  |  |  |  |  |  |  |  |  |  |

## ItemParamDet

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 |
|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |
|  | ItemParamDet Entity Mapping |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Item_Mast | Sales | Purchase | Sales Return | Purchase Return | Production | Unassemble | Stock Journal | Stock Transfer | Material Issue | Material Received |
| Date | F.Y.BegDate | VchDate | VchDate | VchDate | VchDate | VchDate | VchDate | VchDate | VchDate | VchDate | VchDate |
| VchType |  | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType |
| VchCode |  | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode |
| VchNo |  | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo |
| VchItemSN |  | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber | ItemSerialNumber |
| ItemCode | Item Code | Item Code | Item Code | Item Code | Item Code | Item Code | Item Code | Item Code | Item Code | Item Code | Item Code |
| MCCode | MC Code | MC Code | MC Code | MC Code | MC Code | MC Code | MC Code | MC Code | MC Code | MC Code | MC Code |
| SrNo | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No |
| C1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 | Param Name1 |
| C2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 | Param Name2 |
| C3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 | Param Name3 |
| C4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 | Param Name4 |
| C5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 | Param Name5 |
| C6 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 | ParamAlias1 |
| C7 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 | ParamAlias2 |
| C8 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 | ParamAlias3 |
| C9 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 | ParamAlias4 |
| C10 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 | ParamAlias5 |
| Value1 | MainQty | MainQty | MainQty | MainQty | MainQty | MainQty | MainQty | MainQty | MainQty | MainQty | MainQty |
| Value2 | AlternateQty | AlternateQty | AlternateQty | AlternateQty | AlternateQty | AlternateQty | AlternateQty | AlternateQty | AlternateQty | AlternateQty | AlternateQty |
| D1 | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice | MainUnitPrice |
| D2 | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice | AltUnitPrice |
| D3 | MRP | MRP | MRP | MRP | MRP | MRP | MRP | MRP | MRP | MRP | MRP |
| D4 | Sale Price | Sale Price | Sale Price | Sale Price | Sale Price | Sale Price | Sale Price | Sale Price | Sale Price | Sale Price | Sale Price |
| D5 | Amount | Amount | Amount | Amount | Amount | Amount | Amount | Amount | Amount | Amount | Amount |
| D6 |  |  |  |  |  |  |  |  |  |  |  |
| RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType |
| BCN | BCN number | BCN Number | BCN number | BCN Number | BCN number |  |  |  | BCN Number | BCN Number | BCN number |
| AutoBCN | Auto BCN number | 0 | Auto BCN number | 0 | Auto BCN number |  |  |  | Auto BCN Number | 0 | Auto BCN number |
| OrgDate | Original Date | Original Date | Original Date | Original Date | Original Date | Original Date | Original Date | Original Date | Original Date | Original Date | Original Date |

## Item SerialNo

| col0 | col1 | col2 | col3 | col4 | col5 |
|---|---|---|---|---|---|
|  |  |  |  |  |  |
|  | ItemSerialNo Entity Mapping |  |  |  |  |
|  |  |  |  |  |  |
|  Fields | Sales | Purchase | Sales Return  | Purchase PurchaseReturn | Item Master |
| VchCode | Vch Code | Vch Code | Vch Code | Vch Code |  |
| VchType | Vch Type | Vch Type | Vch Type | Vch Type |  |
| VchNo | Vch Number | Vch Number | Vch Number | Vch Number |  |
| VchItemSN | Voucher Item Serial Number | Voucher Item Serial Number | Voucher Item Serial Number | Voucher Item Serial Number |  |
| Date | Voucher Date | Voucher Date | Voucher Date | Voucher Date | Fin year Beg Date |
| ItemCode | Item Code | Item Code | Item Code | Item Code | Item Code |
| MCCode | Material Centre Code | Material Centre Code | Material Centre Code | Material Centre Code | Material Centre Code |
| GridSN | Item Serial No Grids' Serial No | Item Serial No Grids' Serial No | Item Serial No Grids' Serial No | Item Serial No Grids' Serial No | Item Serial No Grids' Serial No |
| SerialNo | Manual Serial Number | Manual Serial Number | Manual Serial Number | Manual Serial Number | Manual Serial Number |
| AutoSrNo | Auto generated Serial No | Auto generated Serial No | Auto generated Serial No | Auto generated Serial No |  |
| Value1 | Item Main Qty | Item Main Qty | Item Main Qty | Item Main Qty | Item Main Qty |
| Value2 | Item Alt Qty | Item Alt Qty | Item Alt Qty | Item Alt Qty | Item Alt Qty |
| D1 | Item Main Unit Price | Item Main Unit Price | Item Main Unit Price | Item Main Unit Price | Item Main Unit Price |
| D2 | Item Alt Unit Price | tem Alt Unit Price | tem Alt Unit Price | tem Alt Unit Price | tem Alt Unit Price |
| D3 | Item Sr No. MRP | Item Sr No. MRP | Item Sr No. MRP | Item Sr No. MRP | Item Sr No. MRP |
| D4 | Item Sr No. Sales Price | Item Sr No. Sales Price | Item Sr No. Sales Price | Item Sr No. Sales Price | Item Sr No. Sales Price |
| MonthVal | Month used in voucher date | Month used in voucher date | Month used in voucher date | Month used in voucher date | Fin year bef month |
| C1 | Serial No Description1 | Serial No Description1 | Serial No Description1 | Serial No Description1 | Serial No Description1 |
| C2 | Serial No Description2 | Serial No Description2 | Serial No Description2 | Serial No Description2 | Serial No Description2 |
| C3 | Serial No Description3 | Serial No Description3 | Serial No Description3 | Serial No Description3 | Serial No Description3 |
| C4 | Serial No Description4 | Serial No Description4 | Serial No Description4 | Serial No Description4 | Serial No Description4 |
| C5 | Serial No Description5 | Serial No Description5 | Serial No Description5 | Serial No Description5 | Serial No Description5 |
| C6 | Serial No Description6 | Serial No Description6 | Serial No Description6 | Serial No Description6 | Serial No Description6 |
| C7 | Serial No Description7 | Serial No Description7 | Serial No Description7 | Serial No Description7 | Serial No Description7 |
| C8 | Serial No Description8 | Serial No Description8 | Serial No Description8 | Serial No Description8 | Serial No Description8 |
| C9 | Serial No Description9 | Serial No Description9 | Serial No Description9 | Serial No Description9 | Serial No Description9 |
| C10 | Serial No Description10 | Serial No Description10 | Serial No Description10 | Serial No Description10 | Serial No Description10 |
| WarrantyMonth | Warranty Months | Warranty Months | Warranty Months | Warranty Months | Warranty Months |

## ItemSNInstallDet

| col0 | col1 |
|---|---|
|  |  |
|  | Item Serial Number Installation Details |
|  |  |
|  Fields |  |
| InstallCode | InstallationCode |
| InstallDate | Installation Date |
| ItemCode | ItemCode |
| SerialNo | Serial No |
| InvoiceNo | Bill No |
| InvoiceDate | Bill Date |
| PartyCode | PartyCode |
| Organization | Organization name |
| TradeDesc | Trade description |
| ContactPerson | Contact person name |
| Designation | Designation of contact person |
| Address1 | Address |
| Address2 | Address |
| CountryCode | Country Code |
| StateCode | State Code |
| CityCode | City Code |
| PinCode | Pin Code |
| MobileNo | Mobile number |
| PhoneNo | Phone number |
| FaxNo | Fax number |
| EmailID | Email ID |
| Narration | Narration |
| WarrMonth | Months of warranty |

## Last Update

| col0 |
|---|
|  |
| This document is updated till BUSY 17(1.0) version. |

## Locks

| col0 | col1 |
|---|---|
|  |  |
|  | Locks Entity Mapping |
|  |  |
|  Fields |  |
|  |  |
| Type |  |
| IBR |  |
| MBU |  |
| CSU |  |
| STU |  |
| Working |  |
| BSSTD |  |
| TERBR |  |
| BSR |  |
| CCCF |  |
| SuppType |  |
| BSNF |  |
| BST |  |
| OSPO |  |
| OBAMC |  |
| TDSSHE |  |
| TESRNO |  |
| Major |  |
| Minor |  |
| RW35 |  |
| MEBR |  |
| MEBR1 |  |
| MFFSA |  |
| SMPL |  |
| GSTU |  |
| MUSPO |  |
| DFYW |  |
| BATCH |  |
| BATCHMRPSRNOPARAM |  |
| ENTRYTAXRATE |  |
| STPTMC |  |
| CHALLANNO |  |
| PARAMDET |  |
| MASTFP |  |
| MASTFP1 |  |
| RMVLOCDB |  |
| POSSERIESFTBNSNAME |  |
| STSCGUPDT |  |
| ITEMSRNOLEN |  |
| RGMAST |  |
| MAINDBVER |  |
| PartialDbVer |  |
| COMPEGRPMAST |  |
| URefBal |  |
| B1 |  |
| CompContGRPMast |  |
| AreaMast |  |
| ContDeptMast |  |
| SourceMast |  |
| NxtActionMast |  |
| SubStatusMast |  |
| FAQGrpMast |  |

## Master1

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 | col13 | col14 | col15 | col16 | col17 | col18 | col19 | col20 | col21 | col22 | col23 | col24 | col25 | col26 | col27 | col28 | col29 | col30 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |                                                                                Master1 Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | ACC_MAST  | AGRP_MAST | CCGRP_MAST  | CC_MAST  | BROKER_MAST  | AUTHOR_MAST  |  ITEM_MAST  | IGRP_MAST  | MC_MAST  | MCGRP_MAST  | UNIT_MAST  | UNITCON_MAST  | BS_MAST | BOM_MAST  | FORM_MAST  | ST_MAST  | PT_MAST  | TDS_Mast | Cur_Mast | CurCon_Mast | TaxCategory_Mast | MasterSeriesGroup_Mast | Branch Master | EMP_MAST | EMP_GRP_MAST | SALARY_COMPONENT_MAST | CONTACT_MAST | CONTACT_GRP_MAST | EXECUTIVE_MAST | SCHEME_MAST |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Code | Master code-auto generated | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master code | Master Code | Master Code | Master Code | Code | Code | Code | Code | Master code | Code | code | Master code | Code | Code |
| MasterType | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Master Type | Mastertype | Master Type | Mastertype | Mastertype |
| Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | MainUnitName +SubUnitName | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name | Name |
| Alias | Alias | Alias | Alias | Alias | Alias | Alias | Alias | Alias | Alias | Alias |  |  | Alias |  |  |  |  |  |  |  |  |  | Alias | Alias | Alias | Alias | Alias | Alias | Alias | Alias |
| PrintName | PrintName | PrintName | PrintName | PrintName | PrintName | PrintName | PrintName |  | PrintName |  | PrintName |  | PrintName |  | PrintName | Sales Category |  |  | PrintName |  |  |  |  | Print Name |  | Print Name | Print Name | Print Name | Print Name | Print Name |
| ParentGrp | Parent Group code | Parent Group code | Parent Group code | Parent Group code |  |  | Parent group code | Parent Group code | Parent group code | Parent Group code |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Parent Group code |  | Grp Code | Parent Group code |  |  |
| Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp |  |  |  |  |  |  |  | Stamp |  |  | Stamp |  |  |
| CM1 | 0 | Stock Acc Code | Stock Acc Code |  | Sales Brokerage Cr Acc Code | Party Code | Main Unit code | Stock Acc Code | StockAccCode | Stock Acc Code |  | MainUnitCode | SalesAccCode | ItemCode |  | SaleAccCode | PurchaseAccCode |  |  |  |  |  |  | BankCode | Stock Acc Code | Acc Code | Ledger Code | Stock Acc Code |  | Party Code |
| CM2 | TDSCatCode | SalesAccCode | SalesAccCode |  | Sales Brokerage Dr Acc Code |  | Alt Unit code | SalesAccCode | SalesAccCode | SalesAccCode |  | SubUnitCode | PurcAccCode | UnitCode |  | FormIssuableCode | FormIssuableCode |  |  |  |  |  | Vch Series Grp Code | CrAccCode | SalesAccCode |  | Salutation Code | SalesAccCode |  |  |
| CM3 | BrokerCode | PurcAccCode | PurcAccCode |  | 0 |  | SaleAccCode | PurcAccCode | PurcAccCode | PurcAccCode |  |  | PartySalesAccCode | MCCode1 |  | Form Receivable Code | FormReceivableCode |  |  |  |  |  | Mast Series Grp Code | BonusBankCode | PurcAccCode |  | Trade Code | PurcAccCode |  |  |
| CM4 | Tax Category Code | BillRefGrpCode | BillRefGrpCode |  | Purc Brokerage Dr Acc Code |  | PurcAccCode | BillRefGrpCode | AccCodeAffectedByMC | BillRefGrpCode |  |  | PartyPurcAccCode | MCCode2 |  | Tax Acc Code | Tax Acc Code |  |  |  |  |  |  |  | BillRefGrpCode |  |  | BillRefGrpCode |  |  |
| CM5 | General Ledger Code |  |  |  |  |  | AuthorCode |  | BillRefGrpCode |  |  |  | AccCode in case of Mat Issue  |  |  | SchgAccCode | SchgAccCode |  |  |  |  |  |  | Leave Encashment BankCode |  |  |  |  |  |  |
| D1 | MaxCrdtLmt | MaxCrdtLmt | MaxCrdtLmt |  | Brokerage Rate |  | ConFactor |  |  |  |  | ConFactor | Percent Of Amount | Quantity |  | Tax Percentage | Tax Percentage |  |  |  |  |  | Waiting Time |  | MaxCrdtLmt | Default Value |  | MaxCrdtLmt |  |  |
| D2 | DepForIstHalf |  |  |  |  |  | MRP |  |  |  |  |  | Default Value | ExtraExpensePerUnit |  | Percent of Amount | Percent of Amount |  |  |  |  |  |  |  |  | Limit Value |  |  |  |  |
| D3 | DepForIIndHalf |  |  |  |  |  | SalePrice |  |  |  |  |  |  |  |  | SchgPercent | SchgPercent |  |  |  |  |  |  |  |  | Edu Cess percent |  |  |  |  |
| D4 | DepAccordToCompAct |  |  |  |  |  | PurcPrice |  |  |  |  |  |  |  |  | Tax Percent (SGST) (Only for GST India)  | Tax Percent (SGST) (Only for GST India)  |  |  |  |  |  |  |  |  | Schg Percent |  |  |  |  |
| D5 | UnclearDepositedAmt |  |  |  |  |  | MinimumLevel |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D6 | UnclearIssuedAmt |  |  |  |  |  | ReorderLevel |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D7 | OpBalITAct |  |  |  |  |  | MaximumLevel |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D8 | FBT Amt Percent | FBT Amount Percent | FBT Amount Percent |  |  |  | Royalty percentage | FBT Amount Percent |  | FBT Amount Percent |  |  |  |  |  |  |  |  |  |  |  |  |  |  | FBT Amount Percent |  |  | FBT Amount Percent |  |  |
| D9 | FBT Tax Percent | FBT Tax Percent | FBT Tax Percent |  |  |  | StockValPrice | FBT Tax Percent |  | FBT Tax Percent |  |  |  |  |  |  |  |  |  |  |  |  |  |  | FBT Tax Percent |  |  | FBT Tax Percent |  |  |
| D10 | FBT CESS Percent | FBT CESS Percent | FBT CESS Percent |  |  |  | Minimum Sale price | FBT CESS Percent |  | FBT CESS Percent |  |  |  |  |  |  |  |  |  |  |  |  |  |  | FBT CESS Percent |  |  | FBT CESS Percent |  |  |
| D11 | FBT Surcharge | FBT Surcharge | FBT Surcharge |  |  |  | Sale Markup | FBT Surcharge |  | FBT Surcharge |  |  |  |  |  |  |  |  |  |  |  |  |  |  | FBT Surcharge |  |  | FBT Surcharge |  |  |
| D12 |  |  |  |  |  |  | Purc Markup |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D13 | Brokerage |  |  |  |  |  | Discount on MRP for Royalty calculation |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D14 | Dr Interest Rate |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D15 | Cr Interest Rate |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D16 |  |  |  |  |  |  | Sales Discount |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D17 |  |  |  |  |  |  | Purchase Discount |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I1 | CreditDaysForPurc |  |  |  | Brokerage Mode |  | MinimumDays | Parametrized Stock Config Mode |  |  |  |  | Type |  | RegTypeNum | Type | Type |  | CurConvType |  |  |  |  | Gender |  |  |  |  | HandlesCallsFor | Scheme Type |
| I2 | CreditDaysForSale |  |  |  | Sales Brokerage Dr Acc From |  | ReorderDays | No of Stock Parameter required |  |  |  |  | AmountBasis |  |  | Register Type |  |  |  |  |  |  |  | Status |  |  |  |  |  | Party Range |
| I3 | PriceLevel |  |  |  | Purc Brokerage Dr Acc From |  | MaximumDays |  |  |  |  |  | Point Of Calculation |  |  | Sub Register Type |  |  |  |  |  |  |  |  |  |  |  |  |  | Apply Scheme |
| I4 | TDS DeducteeCat Code |  |  |  |  |  | StockValMethod |  |  |  |  |  | No of Previous Bill Sundry |  |  |  |  |  |  |  |  |  |  | Payment Mode |  |  |  |  |  | Basis |
| I5 | Tax Type |  |  |  |  |  |  |  |  |  |  |  | Nature of Bill Sundry |  |  |  |  |  |  |  |  |  |  | Salary Mode |  |  |  |  |  | Clubbed On |
| I6 | Supplier Type | CreditDaysForPurc | CreditDaysForPurc |  |  |  |  | CreditDaysForPurc | CreditDaysForPurc | CreditDaysForPurc |  |  | Round Off Type |  |  |  |  |  |  |  |  |  |  | BonusPaymentMode | CreditDaysForPurc |  |  | CreditDaysForPurc |  | OF No |
| I7 | TypeOfDealer | CreditDaysForSale | CreditDaysForSale |  |  |  | Default Prices Applied On Sales | CreditDaysForSale | CreditDaysForSale | CreditDaysForSale |  |  |  |  |  |  |  |  |  |  |  |  |  | Leave Encashment PaymentMode | CreditDaysForSale |  |  | CreditDaysForSale |  | Vch Amt type |
| I8 | PriceLevelForPurc |  |  |  |  |  | Default Prices Applied On Purc |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Overtime Payment Mode |  |  |  |  |  |  |
| I9 | Brokerage Mode |  |  |  |  |  | Conversion Factor Mode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I10 | TypeOfLedger |  |  |  |  |  | Sizing Info Applied On |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I11 |  |  |  |  |  |  | Warranty Months |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Level |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| SrNo |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B1 | AltCurReq | DefineCreditLimit |  |  | Set Default Brokerage  | Is Connect with Party | CriticalLevels |  | StockBelongsToYou |  |  |  | AffectSale |  |  | FirstPointTaxPaid | FirstPointTaxPaid |  |  |  |  |  | Tag Vch Series Group | IF RESIGNED | DefineCreditLimit | AffectLeave | Specify DOB | DefineCreditLimit |  | Item Wise or Not |
| B2 | BillByBillBalancing | Define Budgets |  |  |  |  | BatchByBatch |  | CarryStockToNextYear |  |  |  | AffectPurc |  |  | Exempted | Exempted |  |  |  |  |  | Tag Mast Series Group |  | Define Budgets | AffectLeaveEncash | SpecifyDOA | Define Budgets |  | Item Grp wise or Not |
| B3 | AllocateAmntToItems | Define Targets |  |  |  |  | TEApplicable |  | IfAccountingInStkTfr |  |  |  | AffectMatIss |  |  | MultiTax | MultiTax |  |  |  |  |  | Configure VAT |  | Define Targets | AffectBonus | ConnectWithLedger | Define Targets |  | Inclusive of VAT |
| B4 | Budgets.Define |  |  |  |  |  |  |  |  |  |  |  | AffectMatRec |  |  | RegDealer | RegDealer |  |  |  |  |  | Configure Excise | Overtime Applicable or Not |  | AffectOvertime |  |  |  |  |
| B5 | Targets.Define |  |  |  |  |  |  |  |  |  |  |  | AffectStkTfr |  |  | InputTaxCredit | InputTaxCredit |  |  |  |  |  | Accept Offline data | Bonus Applicable or not |  | AffectAbsent |  |  |  |  |
| B6 | DefineCreditLimit |  |  |  |  |  |  |  |  |  |  |  | Add Previous Bill Sundry |  |  | Tax Free | Tax Free |  |  |  |  |  | DisableVchSeriesFilterOnReport | BonusPmtModeSameAsSalary |  | RoundOff |  |  |  |  |
| B7 | CarryPendingMaterial |  |  |  |  |  |  |  |  |  |  |  | PostOverNAboveInSale |  |  |  | Un-registered Dealer |  |  |  |  |  | DisableMastSeriesFilterOnReport | Leave Encashment PmtModeSameAsSalary |  | Tag Contribution |  |  |  |  |
| B8 | Reg Dealer |  |  |  |  |  |  |  |  |  |  |  | PostOverNAboveInPurc |  |  |  | Lumpsum Dealer |  |  |  |  |  | ConfigureServiceTax | Overtime PmtModeSameAsSalary |  | Affect CTC |  |  |  |  |
| B9 | FBT Applicable | FBT Applicable |  |  |  |  |  |  |  |  |  |  | AffectAccountingInSale |  |  | Freeze Tax in Sale | Freeze Tax in Purchase |  |  |  |  |  |  | Loan Applicable or Not | FBT Applicable | IncludeBonusAmtInPT |  | FBT Applicable |  |  |
| B10 | TDS Applicable |  |  |  |  |  |  |  |  |  |  |  | AffectAccountingInPurc |  |  | Freeze Tax in Sale Return | Freeze Tax in Purchase Return |  |  |  |  |  |  | Advance Applicable |  | IncludeLEAmtInPT |  |  |  |  |
| B11 |  |  |  |  |  |  |  |  |  |  |  |  | SaleAccToBeSpecifyInVch |  |  | Export |  |  |  |  |  |  |  |  |  | IncludeOTAmtInPT |  |  |  |  |
| B12 | Assign Broker |  |  |  |  |  |  |  |  |  |  |  | PartySaleAccToBeSpcifyInVch |  |  |  | Capital Purchase |  |  |  |  |  |  |  |  | AffectTDS |  |  |  |  |
| B13 | Default Broker |  |  |  |  |  |  |  |  |  |  |  | PurcAccToBeSpecifyInVch |  |  | Tax Inclusive | Tax Inclusive |  |  |  |  |  |  |  |  | Component is Editabel or Not |  |  |  |  |
| B14 | Freeze Broker |  |  |  |  |  |  |  |  |  |  |  | PartyPurcAccToBeSpecifyInVch |  |  | Hide Item Tax Rate Window | Hide Item Tax Rate Window |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B15 | Freeze Brokerage |  |  |  |  |  |  |  |  |  |  |  | AffectAccounting in Mat. Iss = 1 Not AffectAccounting in Mat. Iss = 0 |  |  | Stock Transfer | Stock Transfer |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B16 | GSTApplicable |  |  |  |  |  |  |  |  |  |  |  | AffectAccounting in Mat. Iss = 1 Not AffectAccounting in Mat. Iss = 0 |  |  | Tax Rate on MRP | Tax Rate on MRP |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B17 | EnableSmsQuery |  |  |  |  |  |  |  |  |  |  |  | Not AccToBeSpecifyInVch in Mat Iss = 0 AccToBeSpecifyInVch in Mat Iss = 1 |  |  | Lower Rate of Tax | Lower Rate of Tax |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B18 | EnableEmailQuery |  |  |  |  |  | Default Brokerage |  |  |  |  |  | Not PartyAccToBeSpecifyInVch in Mat Iss =0 PartyAccToBeSpecifyInVch in Mat Iss =1 |  |  | LocalStkTransfer | LocalStkTransfer |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B19 | SpecifyDefST |  |  |  |  |  | Freeze MC Code |  |  |  |  |  | Not AccToBeSpecifyInVch in Mat Rcpt = 0 AccToBeSpecifyInVch in Mat Rcpt = 1 |  |  | ExportHighSeaSalePurc  | ExportHighSeaSalePurc  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B20 | SpecifyDefPT |  |  |  |  |  |  |  |  |  |  |  | Not PartyAccToBeSpecifyInVch in Mat Rcpt =0 PartyAccToBeSpecifyInVch in Mat Rcpt =1 |  |  | NonVATGoods | NonVATGoods |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B21 | FreezeDefST |  |  |  |  |  | Do not Maintain Stk Bal  |  |  |  |  |  | Not Adjust In Party in Mat iss =0 Adjust In Party in Mat iss =1 |  |  | SkipInVat | SkipInVat |  |  |  |  |  |  |  |  |  |  |  |  |  |
| External |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| C1 | DefaultChequeFormat |  |  |  |  |  | Tarrif heading |  |  |  | UnitName4Excise |  | Sub Total description |  |  | DocDesc & DocHeading | DocDesc & DocHeading | Section Code | SubCorName |  |  |  |  | PF No |  |  |  |  |  |  |
| CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY | CREATEDBY |  |  |  |  | CREATEDBY |  |  | CREATEDBY |  |  |
| CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime | CreationTime |  |  |  |  | CreationTime |  |  | CreationTime |  |  |
| MODIFIEDBY | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by | Modified by |  |  |  |  | Modified by |  |  | Modified by |  |  |
| ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime | ModificationTime |  |  |  |  | ModificationTime |  |  | ModificationTime |  |  |
| Note1 | Notes  |  |  |  |  |  | Notes |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Note2 | Notes  |  |  |  |  |  | Notes |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I12 |  |  |  |  |  |  | Item Serial No Type |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I13 |  |  |  |  |  |  | Item Serial No Frequency |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| L1 |  |  |  |  |  |  | Item Auto Sr No |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| C2 | ChequePrintName |  |  |  |  |  | Structure Name |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Father Name |  |  |  |  |  |  |
| I14 |  |  |  |  |  |  | Purchase Warranty Month |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I15 |  |  |  |  |  |  | Sale Warranty Month |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B22 | FreezeDefPT |  |  |  |  |  | Track Serial No Warranty |  |  |  |  |  | Not AdjustInParty in case of Mat. Rcpt = 0 AdjustInParty in case of Mat. Rcpt = 1 |  |  | SaleInTransit | SaleInTransit |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B23 | EnableChequePrinting |  |  |  |  |  | Track Purchase Warranty |  |  |  |  |  | PostOverNAbove in case of Mat. Issue |  |  | AdjustTaxInSalesAcc | AdjustTaxInSalesAcc |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B24 | BranchwiseBalReq |  |  |  |  |  | Track Sales Warranty |  |  |  |  |  | PostOverNAbove in case of Mat. Rcpt |  |  | MRPOverNAbove | MRPOverNAbove |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I15 |  |  |  |  |  |  | SaleWarrantyMonth |  |  |  |  |  |  |  |  | Sales Account Info | Purchase Account Info |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B25 | EnablePartyWiseWebReporting |  |  |  |  |  | Enable Parameterized Stock |  |  |  |  |  | MRPOverNAbove |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| CM6 | Default Sale Type Code |  |  |  |  |  | Default MC Code |  |  |  |  |  | PartyAccCode in case of Mat Issue  |  |  | ServiceAccCode | ServiceAccCode |  |  |  |  |  |  |  |  |  |  |  |  |  |
| CM7 | Default Purc Type Code |  |  |  |  |  | Broker Code |  |  |  |  |  | PartyAccCode in case of Mat Rcpt |  |  | SGST Acc Code  (GST INDIA)  | SGST Acc Code  (GST INDIA)  |  |  |  |  |  |  | Overtime Bank code |  |  |  |  |  |  |
| B29 |  |  |  |  |  |  | Broker Assigned |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B32 |  |  |  |  |  |  | Freeze Broker |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B33 |  |  |  |  |  |  | Freeze Brokerage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D19 |  |  |  |  |  |  | Brokerage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I17 |  |  |  |  |  |  | Brokerage Mode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| MasterNotes | Notes  |  |  |  |  |  | Notes |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Master Notes |
| SyncStatus | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not |  |  |  |  | Synchronization Status - whether data is sync or not | Synchronization Status - whether data is sync or not |  |  | Synchronization Status - whether data is sync or not |  |  |
| Source | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party |  |  |  |  | Source of Data Sync - Branch Office or Third Party | Source of Data Sync - Branch Office or Third Party |  |  | Source of Data Sync - Branch Office or Third Party |  |  |
| CM8 |  |  |  |  |  |  | Tax Category Code |  |  |  |  |  | MRPartyAccCode |  |  |  |  |  |  |  |  |  |  | Loan Acc Code |  |  |  |  |  |  |
| CM9 |  |  |  |  |  |  | Vendor Code |  |  |  |  |  | StkAccCode |  |  |  |  |  |  |  |  |  |  | Advance Acc Code |  |  |  |  |  |  |
| CM10 |  |  |  |  |  |  |  |  |  |  |  |  | StkPartyAccCode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| CM11 |  |  |  |  |  |  |  |  |  |  |  |  | Other Bill Sundry Code |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D20 |  |  |  |  |  |  | Sale Price from Purchase Price Value |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I16 |  |  |  |  |  |  | Installation Warranty Month |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I17 |  |  |  |  |  |  | Brokerage Mode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I18 |  |  |  |  |  |  | Sale Price from Purchase Price Level |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I19 |  |  |  |  |  |  | Sale Price from Purchase Price Mode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I20 |  |  |  |  |  |  | Sale Price from Purchase Price Round Off Limit |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I21 |  |  |  |  |  |  | Sale Price from Purchase Price Round Off Nearest To |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B26 |  |  |  |  |  |  |  |  |  |  |  |  | StkTfrAffectAccounting |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B27 |  |  |  |  |  |  | Track Installation Wararnty |  |  |  |  |  | StkAccToBeSpecifyInVch |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B28 |  |  |  |  |  |  | Enabel MRP wise Stock |  |  |  |  |  | StkPartyAccToBeSpecifyInVch |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B29 |  |  |  |  |  |  | Assifn Broker |  |  |  |  |  | StkAdjustInParty |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B30 |  |  |  |  |  |  | Assign Default MC |  |  |  |  |  | StkPostOverNAbove |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B31 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B32 |  |  |  |  |  |  | Freeze Broker |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B33 |  |  |  |  |  |  | Feeze Brokerage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B34 |  |  |  |  |  |  | Assign Vendor |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B35 |  |  |  |  |  |  | Sale Price from Purchase Price After Discount |  |  |  |  |  | If Selective Calc Of BS = 1 If Not Selective Calc Of BS = 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| L2 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| AuthorisedBy | ApprovedBy |  |  |  |  |  | Approved By |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| AuthorisationTime | ApprovalTime |  |  |  |  |  | Approval Date & Time |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| ApprovalStatus | ApprovalStatus |  |  |  |  |  | Status - Approved , Not Required / Not Approved |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| MasterSeriesGrp | MasterSeriesGrp |  |  |  |  |  | Master Series Group Code |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| BlockMaster | Master Blocked |  |  |  |  |  | Block Master - Y / N |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Block Master - Y / N |  |  |  |  |  |  |
| BlockNotes | Blocked Notes |  |  |  |  |  | Notes String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Notes String |  |  |  |  |  |  |
| DeactivateMaster | MasterDeactive |  |  |  |  |  | Decativate master - Y / N |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Decativate master - Y / N |  |  |  |  |  |  |
| C3 |  |  |  |  |  |  | Sale Compound Discount |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Acc NO |  |  |  |  |  |  |
| C4 |  |  |  |  |  |  | Purchase Compound Discount |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Bonus Acc No + Leave Encashment Acc No + overtime Acc No |  |  |  |  |  |  |
| BlockedVchType | Blocked Vchtype String |  |  |  |  |  | String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| C5 |  |  |  |  |  |  | Sale Compound Markup |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ESI NO |  |  |  |  |  |  |
| C6 |  |  |  |  |  |  | Purchase Compound Markup |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| M1 |  |  |  |  |  |  |  |  |  |  |  |  | Item Component found in Bill Sundry String |  |  |  |  |  |  |  |  |  |  | TDS info string |  |  |  |  |  | Vch Det String |
| OldIdentity |  |  |  |  |  |  | When Modify - Identity of Master |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| TPF1 | 0 |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | False |  |  |  |  |  | False |
| TPF2 | 0 |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | False |  |  |  |  |  | False |
| I22 |  |  |  |  |  |  | Saved Batch Expiry Date |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| RejectionStatus |  |  |  |  |  |  | Entry Not Rejected = 0 , else = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D21 |  |  |  |  |  |  | Sale Price DU |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D22 |  |  |  |  |  |  | Purchase Price DU |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D23 |  |  |  |  |  |  | Min Sales Price DU |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D24 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D25 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I22 |  |  |  |  |  |  | Saved Batch Exp Days |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I23 |  |  |  |  |  |  | Batch Specify Date |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I24 |  |  |  |  |  |  | Contract Type |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| HSN Code |  |  |  |  |  |  | HSN Code (INDIA GST) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| SENO |  |  |  |  |  |  | SENo (INDIA GST) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

## MasterAddressInfo

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 |
|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |
|  | MasterAddressInfo Entity Mapping |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  Fields | ACC_ MAST | BROKER_MAST  | AUTHOR_MAST  |  ITEM_MAST  | MC_MAST  | EMPLOYEE_MAST  | CONTACT_MAST | EXECUTIVE_MAST | SCHEME_MAST |
|  |  |  |  |  |  |  |  |  |  |
| MasterCode | Master code | Master Code | Master code | Master code | MasterCode | MasterCode | MasterCode | MasterCode |  |
| Address1 | Address1 | Address1 | Address1 | Item desc1 | Address1 | Address1 | Address1 | Address1 |  |
| Address2 | Address2 | Address2 | Address2 | Item desc2 | Address2 | Address2 | Address2 | Address2 |  |
| Address3 | Address3 | Address3 | Address3 | Item desc3 | Address3 | Address3 | Address3 | Address3 |  |
| Address4 | Address4 | Address4 | Address4 | Item desc4 | Address4 | Address4 | Address4 | Address4 |  |
| TelNo | TelNo |  |  | category 'O' - Price, discount; category 'P' - Price, discount |  | Tel No | Tel No | Tel No |  |
| Fax | Fax |  |  | category 'G'-discount;category 'H' - Price, discount |  | Fax No | Fax No | Fax No |  |
| Email | Email |  |  | category 'I' - Price, discount; category 'J' - Price, discount |  | Email | Email | Email |  |
| Mobile | Mobile |  |  |  |  | Mobile No | Mobile No | Mobile No |  |
| LST | LST |  |  | category 'Y' - Price, discount |  |  |  |  |  |
| CST | CST |  |  | category 'Z' - Price , discount |  |  |  |  |  |
| ST37 | IE Code |  |  | category 'A' - Price, discount |  |  |  |  |  |
| TINNo | TelNo |  |  |  |  |  |  |  |  |
| ITPAN | ITPAN |  |  | category 'D'- Price, discount |  |  |  |  |  |
| ITWARD | ITWARD |  |  | category 'E' - Price, discount |  |  |  |  |  |
| Contact | Contact |  |  | category 'M' - Price , discount; category 'N' - Price, discount |  |  |  |  |  |
| ExciseRegNo | ExciseRegNo |  |  | category 'F' - Price,  discount, Category 'G' - Price |  |  |  |  |  |
| ECCCode | ECCCode |  |  | category 'C' - Price, discount |  |  |  |  |  |
| PLANo | PLANo |  |  | category 'B' - Price, discount |  |  |  |  |  |
| Division | Division |  |  | category 'Q' - Price , discount; category 'R' - Price, discount; category 'S'- Price , discount, category 'T' - Price, discount |  |  |  |  |  |
| Range | Range |  |  | category 'U' - Price, discount; category 'V' - Price, discount; category 'W'- Price ,discount; category 'X' - Price, discount |  |  |  |  |  |
| Collectorate | Collectorate |  |  | category 'K' - Price, discount; category 'L' - Price, discount |  |  |  |  |  |
| OF1 | Optional Field1 |  |  | Optional field1 | Optional field1 | Optional field1 |  |  |  |
| OF2 | Optional Field2 |  |  | Optional field2 | Optional field2 | Optional field2 |  |  |  |
| OF3 | Optional Field3 |  |  | Optional field3 | Optional field3 |  |  |  |  |
| OF4 | Optional Field4 |  |  | Optional field4 | Optional field4 |  |  |  |  |
| OF5 | Optional Field5 |  |  | Optional field5 | Optional field5 |  |  |  |  |
| OF6 | Optional Field6 |  |  | Optional field6 | Optional field6 |  |  |  |  |
| OF7 | Optional Field7 |  |  | Optional field7 | Optional field7 |  |  |  |  |
| OF8 | Optional Field8 |  |  | Optional field8 | Optional field8 |  |  |  |  |
| OF9 | Optional Field9 |  |  | Optional field9 | Optional field9 |  |  |  |  |
| OF10 | Optional Field10 |  |  | Optional field10 | Optional field10 |  |  |  |  |
| SupplierType |  |  |  |  |  |  |  |  |  |
| ServiceTaxNo | ServiceTaxNo |  |  |  |  |  |  |  |  |
| TelNoResi | TelNoResi |  |  |  |  |  |  |  |  |
| GST No | GST |  |  |  |  |  |  |  |  |
| StateCodeLong | State Code |  |  |  |  |  | State Code |  |  |
| CountryCodeLong | Country Code |  |  |  |  |  | Country Code |  |  |
| CityCodeLong |  |  |  |  |  |  | City code |  |  |
| PINCode | PIN Code |  |  |  |  |  |  |  |  |
| DLNO | Drug License Number |  |  |  |  |  |  |  |  |
| DLNO2 |  |  |  |  |  |  |  |  |  |
| Transport | trasnport |  |  |  |  |  |  |  |  |
| Station | station |  |  |  |  |  |  |  |  |
| AccNo | Account number |  |  |  |  |  |  |  |  |
| Date1 |  |  |  |  |  | Date of Birth |  |  |  |
| Date2 |  |  |  |  |  | Date of Joining |  |  |  |
| Date3 |  |  |  |  |  |  |  |  |  |
| Date4 |  |  |  |  |  | Date of Leaving |  |  |  |
| Date5 |  |  |  |  |  | Passport Expiry date |  |  |  |
| Date6 |  |  |  |  |  | Visa Expiry Date |  |  |  |
| Date7 |  |  |  |  |  | Contract Start Date |  |  |  |
| Date8 |  |  |  |  |  | Contract Expiry Date |  |  |  |
| C1 |  |  |  |  |  | Employee Spouse Name | Contact Printable Address1 |  |  |
| C2 |  |  |  |  |  | Emp. Designation | Contact Printable Address2 |  |  |
| C3 |  |  |  |  |  | PAN | Contact Printable Address3 |  |  |
| C4 |  |  |  |  |  | Passport No | Contact Printable Address4 |  |  |
| C5 |  |  |  |  |  | Country of Issue | Contact Printable Address5 |  |  |
| C6 |  |  |  |  |  | Visa No |  |  |  |
| C7 |  |  |  |  |  | Work Permit No |  |  |  |
| C8 |  |  |  |  |  |  |  |  |  |
| C9 |  |  |  |  |  |  |  |  |  |
| C10 |  |  |  |  |  |  |  |  |  |
| M1 |  |  |  |  |  |  |  |  |  |
| LBT |  |  |  |  |  |  |  |  |  |
| LBTNO | LBT No |  |  |  |  |  |  |  |  |
| AreaCode |  |  |  |  |  |  | Area Code |  |  |
| AreaCodeLong | Area Code |  |  |  |  |  |  |  |  |
| ContDeptCodeLong |  |  |  |  |  |  | Contact Deptt. Code |  |  |

## MasterSupport

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | BOM_MAST- RM details  | BOM_MAST- BP details  | TDS _Mast | Item_Mast | CurCon_Mast | ST_Mast | PT_Mast | Tax Category Master | EMPLOYEE_MAST | CONTACT_MAST | EXECUTIVE_MAST | SCHEME_MAST |
|  |  |  |  |  |  |  |  |  |  |  |  |  |
| MasterCode | Code | Code | Code | Code | Code | Master Code | Master Code | Branch Code |   |  |  | MasterCode |
| CM1 | ItemCode | ItemCode |  | Author Code | Name | Sale Account | Purchase Account |  |  |  |  | Item Code/ Grp Code |
| CM2 | MainUnitCode | MainUnitCode |  |  |  | Tax Acc Code | Tax Acc Code |  |  |  |  | scheme Item Code |
| D1 | MainQty | MainQty | ThresholdLimit | Royalty/Prices | SellingRate | Tax Rate | Tax Rate | Tax Rate Local |  |  |  | Qty |
| D2 |  |  | TDS Percent | Discount | BuyingRate | SGST Tax Rate (Only Used for GST India) | SGST Tax Rate (Only Used for GST India) | Tax Rate Central |  |  |  | Scheme Qty |
| D3 |  |  | Surcharge Percent |  | StdRate |  |  | Schg Rate Local |  |  |  | Discount |
| D4 |  |  | Cess Percent |  |  |  |  | Schg Rate Central |  |  |  | Amount |
| D5 |  |  |  |  |  |  |  | Entry Tax Rate |  |  |  | Value |
| I1 | ItemType | ItemType | Payee Category Code | SrNo. | SrNo. | Tax Type | Tax Type | Tax Type Local |  |  |  | Serial No |
| I2 | SrNo | SrNo | Sr.No. | VchType  |  |  |  | Item Type |  |  |  | Scheme Type |
| I3 |  |  |  |                                                                                                   |  |  |  |  |  |  |  | Basis |
| Date | Now | Now |  |  | Date |  |  | Tax W.E.From Date |  |  |  | Start Date |
| MasterType | MasterType | MasterType | MasterType | MasterType | MasterType |  |  | Master Type |  |  |  | Mastertype |
| B1 |  |  |  |  |  |  |  | Tax On MRP |  |  |  | Specify Time |
| C1 |  |  |  | Compound Sale Discount |  |  |  | HSN Code |  |  |  |  |
| C2 |  |  |  | Compound Purc Discount |  |  |  | SE No |  |  |  | OF Value |
| C3 |  |  |  | Compound Sale Markup |  |  |  | Comm Code No |  |  |  | Compound Discount |
| D6 |  |  | TDS Normal Rate Without PAN | Minimum Sales Price |  |  |  | Service Tax Rate |  |  |  | Price |
| D7 |  |  |  | Self Valuation Price |  |  |  | Percent of Amount |  |  |  | Qty1 |
| I4 |  |  |  | Critical Level Maximum Days |  |  |  |  |  |  |  | Unit Type |
| I5 |  |  |  |  |  |  |  |  |  |  |  | Scheme Unit Type |
| I6 |  |  |  |  |  |  |  |  |  |  |  | OF Type |
| I7 |  |  |  |  |  |  |  |  |  |  |  | OF Sub Type |
| I8 |  |  |  |  |  |  |  |  |  |  |  | Disc Effect |
| C4 |  |  |  | Compound Purc Markup |  |  |  | Trade Name |  |  |  |  |
| C5 |  |  |  |  |  |  |  | Trade Code |  |  |  |  |
| D8 |  |  |  | Sale Markup  |  |  |  | SGST TaxRate |  |  |  | Amount 1 |
| D9 |  |  |  | Purc Markup  |  |  |  |  |  |  |  | Value1 |
| B2 |  |  |  |  |  |  |  | If MRP is Over and Above |  |  |  |  |
| B3 |  |  |  |  |  |  |  |  |  |  |  |  |
| B4 |  |  |  |  |  |  |  |  |  |  |  |  |
| RecType |  |  |  |  |  |  |  |  |  |  |  | Rectype |
| Date1 |  |  |  |  |  |  |  |  |  |  |  | EndDate |
| CM3 |  |  |  |  |  |  |  |  |  |  |  | Unit Code |
| CM4 |  |  |  |  |  | Tax Acc Code (SGST Acc) (Only used for GST India) | Tax Acc Code (SGST Acc) (Only used for GST India) |  |  |  |  | Scheme Unit Code |
| CM5 |  |  |  |  |  |  |  |  |  |  |  | BS Code |
| D10 |  |  |  | Sale Price of Dual Unit |  |  |  |  |  |  |  |  |
| D11 |  |  |  | Purc Price of Dual Unit |  |  |  |  |  |  |  |  |
| D12 |  |  |  | Min Sale Price of Dual Unit |  |  |  |  |  |  |  |  |
| DATE2 |  |  |  |  |  |  |  |  |  |  |  | Start Time |
| DATE3 |  |  |  |  |  |  |  |  |  |  |  | End Time |

## MastFootPrint

| col0 | col1 |
|---|---|
|  |  |
|  |  |
|  |  |
|  Fields |  |
|  |  |
| MasterCode | Code of Master |
| Name | Name of Master |
| MasterType | Master Type |
| Stamp | Integer Value , if created Stamp =1 else Stamp +1 |
| PartialFP | string |
| RemainFP | string |

## OEDDet

| col0 | col1 | col2 | col3 | col4 | col5 |
|---|---|---|---|---|---|
|  |  |  |  |  |  |
|  | OEDDet Entity Mapping |  |  |  |  |
|  |  |  |  |  |  |
|  Fields | Sales | Puchase | Sales Return | Purchase Return | Payment |
|  |  |  |  |  |  |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode |
| OEDRate | OEDRate | OEDRate |  | 0 |  |
| OEDAmount | OEDAmount | OEDAmount | OEDAmount | OEDAmount | OEDAmount |
| CessRate | Cess rate | Cess rate |  |  |  |
| CessAmount | CessAmount | CessAmount | Cess Amount |  | Cess Amount |
| HECessRate  | HE Cess Rate | HE Cess Rate |  |  |  |
| HeCessAmount | He Cess Amount | He Cess Amount | He Cess Amount |  | He Cess Amount |
| D1 |  |  |  |  |  |
| I1 |  |  |  |  |  |
| L1 |  |  |  |  |  |

## OrgSalePurc

| col0 | col1 |
|---|---|
|  |  |
|  | OrgSalePurc Entity Mapping |
|  |  |
| Fields | Sales Return Voucher |
|  |  |
| VchCode | Voucher Code |
| VchNo | Voucher Number |
| VchDate | Voucher Date |
| TaxableAmt | Taxable Amount |
| TaxAmt | Tax Amount |
| RegType | Register No |

## PackingDetails

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  | Packing Details |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |
| Fields | Sale | Purchase | Sale Return | Purchase Return | Mat. Issued to Party | Material Received from Party | Stock Transfer | Production |
| SrNo | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No | Serial No |
| VchCode | Voucher Code | Voucher Code | Voucher Code | Voucher Code | Voucher Code | Voucher Code | Voucher Code | Voucher Code |
| PackageNo | Package Number | Package Number | Package Number | Package Number | Package Number | Package Number | Package Number | Package Number |
| Weight | Weight | Weight | Weight | Weight | Weight | Weight | Weight | Weight |
| EstimatedValue | Estinmated Value | Estinmated Value | Estinmated Value | Estinmated Value | Estinmated Value | Estinmated Value | Estinmated Value | Estinmated Value |
| Size | Size | Size | Size | Size | Size | Size | Size | Size |
| Description | Description | Description | Description | Description | Description | Description | Description | Description |
| Remarks | Remarks | Remarks | Remarks | Remarks | Remarks | Remarks | Remarks | Remarks |
| MarkaNo | Marka No | Marka No | Marka No | Marka No | Marka No | Marka No | Marka No | Marka No |
| Quantity | Qty | Qty | Qty | Qty | Qty | Qty | Qty | Qty |
| Unit | Unit | Unit | Unit | Unit | Unit | Unit | Unit | Unit |
| PackingMode | Packing Mode | Packing Mode | Packing Mode | Packing Mode | Packing Mode | Packing Mode | Packing Mode | Packing Mode |

## Patches

| col0 |
|---|
|  |
|  |
|  |
| Fields |
| DummyFlds |
| MasterNotes |
| MBO |
| UFSU |
| DUFITC |
| CheckList |
| SPACc |
| UMBDB1 |
| BCNAltQty |
| UMB1 |
| ExpBatch |
| QuoteDefaultSeries |
| BatchStckTfr |
| ImpactBSSalePurc |
| DiscMarkupConfig |
| PickQtyAltQty |
| VchAudit |
| DiscHelpData |
| ItemSrNoLen |
| SalaryDefaultSeries |
| FinalResults |
| PDCT3 |
| TEMCwiseRef |
| SupplierDutyDet |
| PaidDays |
| PUSJMC |
| CRSalesDefaultSeries |
| IndentDefaultySeries |
| UFRD |
| DefaultSettlementMode |

## PhyStckSubDetails

| col0 | col1 |
|---|---|
|  |  |
|  |  |
|  |  |
| Fields | Physical Stock Voucher |
| RecType | Rec Type |
| VchCode | Voucher Code |
| VchType | Voucher Type |
| VchNo | Voucher Number |
| MasterCode1 | Item Code |
| MasterCode2 | MC Code |
| SrNo |  |
| Date |  |
| DueDate |  |
| No |  |
| Value1 | Main Qty |
| Value2 | Alt Qty |
| Value3 |  |
| Balance1 |  |
| Balance2 | Sale Price |
| Balance3 | Item MRP |
| ItemSrNo |  |
| MfgDate |  |
| NewRefAmount |  |
| MonthVal |  |
| WarrantyMonth |  |
| OrgDate |  |
| C1 | Param1 |
| C2 | Param2 |
| C3 | Param3 |
| C4 |  |
| C5 |  |
| C6 |  |
| C7 |  |
| C8 |  |
| C9 |  |
| C10 |  |
| D1 | Main Unit |
| D2 | Alt Unit |
| D3 |  |
| D4 |  |
| D5 |  |
| D6 |  |
| B1 | Show Zero Qty Ref |

## POSDet

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  |  |  |  |  |
|  | POSDet Entity Mapping |  |  |  |
|  |  |  |  |  |
|  Fields | Sales | Puchase | Sales Return | Purchase Return |
|  |  |  |  |  |
| VchCode | Voucher code | Voucher code | Voucher code | Voucher code |
| CashAmt | Amt in Cash | Amt in Cash | Amt in Cash | Amt in Cash |
| ChequeAmt | Amt through Cheque | Amt through Cheque | Amt through Cheque | Amt through Cheque |
| CCAmt1 | Amt through CreditCard 1 | Amt through CreditCard 1 | Amt through CreditCard 1 | Amt through CreditCard 1 |
| CCAmt2 | Amt through CreditCard 2 | Amt through CreditCard 2 | Amt through CreditCard 2 | Amt through CreditCard 2 |
| CCAmt3 | Amt through CreditCard 3 | Amt through CreditCard 3 | Amt through CreditCard 3 | Amt through CreditCard 3 |
| CashNarr | Narration for cash amt | Narration for cash amt | Narration for cash amt | Narration for cash amt |
| ChequeNarr | Narration for cheque amt | Narration for cheque amt | Narration for cheque amt | Narration for cheque amt |
| CCNarr1 | Narration for Credit card amt 1 | Narration for Credit card amt 1 | Narration for Credit card amt 1 | Narration for Credit card amt 1 |
| CCNarr2 | Narration for Credit card amt 2 | Narration for Credit card amt 2 | Narration for Credit card amt 2 | Narration for Credit card amt 2 |
| CCNarr3 | Narration for Credit card amt 3 | Narration for Credit card amt 3 | Narration for Credit card amt 3 | Narration for Credit card amt 3 |
| CashRcvdAmt | Cash tendered amt | Cash tendered amt | Cash tendered amt | Cash tendered amt |
| CashACcCode |  |  |  |  |
| CCAccCode1 |  |  |  |  |
| CCAccCode2 |  |  |  |  |
| CCAccCode3 |  |  |  |  |
| ChequeAccCode |  |  |  |  |

## RepColSize

| col0 | col1 |
|---|---|
|  |  |
|  |  |
|  |  |
| Fields | To Save Report Columns Size |
| RepId | Report ID |
| SubID | Sub ID |
| ColID | Column ID |
| ColSize | Column Size |
| FormatName | Format Name |
| CustomRepFormatName | Custom Report Format Name |
| WideScreen | If Wide Screen |

## RepOptValue

| col0 | col1 |
|---|---|
|  |  |
|  | RepOptValues  |
|  |  |
| Fields |  |
|  |  |
| RepId | RepId |
| ReportType | ReportType |
| ValueType | ValueType |
| SrNo | SrNo |
| Value | Value |
| MasterType | MasterType |
| FieldId | FieldID |
| FieldValue | FieldValue |
| SubRepID | Sub Rep ID |
| FormatName | Format Name |

## STDet

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 |
|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |
|  | STDet Entity Mapping |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
| Fields | Sales | Purchase | Sales Return | Purchase Return | Debit Note | Credit Note | Journal | Payment | Receipt |
|  |  |  |  |  |  |  |  |  |  |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode |
| STCategory | STCategory | STCategory | STCategory | STCategory | STCategory | STCategory | STCategory | STCategory | STCategory |
| STAssValue | STAssValue | STAssValue | STAssValue | STAssValue | STAssValue | STAssValue | STAssValue | STAssValue | STAssValue |
| STRate | STRate | STRate | STRate | STRate | STRate | STRate | STRate | STRate | STRate |
| STCessRate | STCessRate | STCessRate | STCessRate | STCessRate | STCessRate | STCessRate | STCessRate | STCessRate | STCessRate |
| STHECEssRate |  |  |  | STSHECEssRate | STSHECEssRate | STSHECEssRate | STSHECEssRate | STSHECEssRate | STSHECEssRate |

## TDS

| col0 | col1 | col2 | col3 |
|---|---|---|---|
|  |  |  |  |
|  | TDS Entity Mapping |  |  |
|  |  |  |  |
| Fields | Payment | Receipt | Journal |
|  |  |  |  |
| Method | Method | Method | Method |
| RefNo | RefNo | RefNo | RefNo |
| RefCode | RefCode | RefCode | RefCode |
| SrNo | SrNo | SrNo | SrNo |
| VchCode | VchCode | VchCode | VchCode |
| VchType | VchType | VchType | VchType |
| Mastercode1 | PartyCode | PartyCode | PartyCode |
| MasterCode2 | CategoryCode | CategoryCode | CategoryCode |
| EntryDate | EntryDate | EntryDate | EntryDate |
| DateOfCredit | DateOfCredit | DateOfCredit | DateOfCredit |
| VchAmt | VchAmt | VchAmt | VchAmt |
| TDSRate | TDSRate | TDSRate | TDSRate |
| TDSAmt | TDSAmt | TDSAmt | TDSAmt |
| SurchargeAmt | SurchargeAmt | SurchargeAmt | SurchargeAmt |
| CessRate | CessRate | CessRate | CessRate |
| CessAmt | CessAmt | CessAmt | CessAmt |
| Interest | Interest | Interest | 0 |
| OtherAmt | Others | Others | 0 |
| LowerRate |  |  | LowerRate |
| Reason |  |  | Reason |
| ChallanNo | ChallanNo | ChallanNo |  |
| ChequeNo | ChequeNo | ChequeNo |  |
| Quarter | Quarter | Quarter |  |
| SHECessRate | SHECessRate | SHECessRate | SHECessRate |
| SHECessAmt | SHECessAmount | SHECessAmount | SHECessAmount |
| ChequeDate | ChequeDate | ChequeDate | ChequeDate |
| RecType | Constant | Constant | Constant |

## TradingExcise

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  |  |  |  |  |
|  | TradingExcise Entity Mapping |  |  |  |
|  |  |  |  |  |
|  Fields | Sales | Purchase | Sales Return | Purchase Return |
|  |  |  |  |  |
| RefCode | RefCode | RefCode | RefCode | RefCode |
| Method | Method | Method | Method | Method |
| VchCode | VchCode | VchCode | VchCode | VchCode |
| SrNo | SrNo | SrNo | SrNo | SrNo |
| VchType | VchType | VchType | VchType | VchType |
| RefNo | RefNo | RefNo | RefNo | RefNo |
| PartyCode | PartyCode | PartyCode | PartyCode | PartyCode |
| VchNo | VchNo | VchNo | VchNo | VchNo |
| Date | Date | Date | Date | Date |
| ItemCode | ItemCode | ItemCode | ItemCode | ItemCode |
| Qty | Qty | Qty | Qty | Qty |
| Balance |  | Balance |  |  |
| Status |  | Status |  |  |
| AssValue |  | AssValue |  |  |
| DutyRate |  | DutyRate |  |  |
| DutyType |  | DutyType |  |  |
| DutyAmt | DutyAmt | DutyAmt | DutyAmt | DutyAmt |
| DutyRate1 |  | DutyRate |  |  |
| DutyType1 |  | DutyType1 |  |  |
| DutyAmt1 | DutyAmt1 | DutyAmt1 | DutyAmt1 | DutyAmt1 |
| DutyRate2 |  | DutyRate2 |  |  |
| DutyType2 |  | DutyType2 |  |  |
| DutyAmt2 | DutyAmt2 | DutyAmt2 | DutyAmt2 | DutyAmt2 |
| DutyRate3 |  | DutyRate3 |  |  |
| DutyType3 |  | DutyType3 |  |  |
| DutyAmt3 | DutyAmt3 | DutyAmt3 | DutyAmt3 | DutyAmt3 |
| MfrQty |  | MfrQty |  |  |
| MfrCode |  | MfrCode |  |  |
| MfrBillNo |  | MfrBillNo |  |  |
| MfrBillDate |  | MfrBillDate |  |  |
| RG23DPageNo |  | RG23DPageNo |  |  |
| RG23DSrNo |  | RG23DSrNo |  |  |
| AutoRG23DPageNo |  | Auto RG 23D Page Number |  |  |
| AutoRG23DSrNO |  | Auto RG-23D Serial Number |  |  |
| SuppRG23DPageNo |  | Supplier's RG 23D Page Number |  |  |
| SuppRG23DSrNo |  | Supplier's RG23D Serial Number |  |  |
| MCCode |  | Material Centre Code |  |  |
| SuppAssValue | Supp Ass Value | Supplier's Assessable Value | Supplier's Assessable Value | Supplier's Assessable Value |
| SuppDutyAmt | Supp Excise Amt | Supp Excise Amt | Supp Excise Amt | Supp Excise Amt |
| SuppDutyAmt1 | Supp OED | Supp OED | Supp OED | Supp OED |
| SuppDutyAmt2 | Supp Cess | Supp Cess | Supp Cess | Supp Cess |
| SuppDutyAmt3 | Supp HECESS | Supp HECESS | Supp HECESS | Supp HECESS |
| CarryRefZeroQty | If Carry Ref Zero Qty | If Carry Ref Zero Qty | If Carry Ref Zero Qty | If Carry Ref Zero Qty |
| MfrInvoicePrepDateTime | Mfr Invoice Prep Date Time | Mfr Invoice Prep Date Time | Mfr Invoice Prep Date Time | Mfr Invoice Prep Date Time |
| MfrGoodsRemovalDateTime | Mfr Goods Remove  Date Time | Mfr Goods Remove  Date Time | Mfr Goods Remove  Date Time | Mfr Goods Remove  Date Time |
| ActualSuppAssValue | Original Supply Ass Value | Original Supply Ass Value | Original Supply Ass Value | Original Supply Ass Value |
| ActualSuppDutyAmt | Original Supply Excise Duty | Original Supply Excise Duty | Original Supply Excise Duty | Original Supply Excise Duty |
| ActualSuppDutyAmt1 | Org Supp OED | Org Supp OED | Org Supp OED | Org Supp OED |
| ActualSuppDutyAmt2 | Org Supp CESS | Org Supp CESS | Org Supp CESS | Org Supp CESS |
| ActualSuppDutyAmt3 | Org Supp HECess | Org Supp HECess | Org Supp HECess | Org Supp HECess |
| ActualSuppQty | Actual Supp Qty | Actual Supp Qty | Actual Supp Qty | Actual Supp Qty |
| SuppOriginalDateSpecified | Supp Original Date Specified | Supp Original Date Specified | Supp Original Date Specified | Supp Original Date Specified |

## Tran1

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 | col13 | col14 | col15 | col16 | col17 | col18 | col19 | col20 | col21 | col22 | col23 | col24 | col25 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  | z |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Tran1 Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Sales Order | Purchase Order | Sale Quotation | Purchase Quotation | Sales | Purchase | Sales Return | Purchase Return | Payment | Receipt | Journal | Contra | Debit Note | Credit Note | Stock Transfer | Production | Unassemble | Stock Journal | Mat. Issu. | Mat. Rec. | Salary Calculation | Purchase Indent | Call Receipt | Call Allocation | Call Report |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | Vchcode | VchCode | Vchcode | Vchcode | Vchcode |
| VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | Vchytype | VchType | Vchtype | Vchtype | Vchtype |
| Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date |
| StockUpdationDate | Date | Date | Date | Date | StockUpdationDate | StockUpdationDate | StockUpdationDate | StockUpdationDate | PDC Date | PDC Date |  |  |  |  | Date | date | Date | date | Date | Date | Salary Date | Date | Time | time | time |
| Status |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | Vch No | VchNo | Vch No | Vch No | VchNo |
| VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | Vch series code | VchSeriesCode | Vch series code | Vch series code | Vch series code |
| MasterCode1 | Party code | Party code | Party code | Party code | Party code | Party code | Party code | Party code | 0 | 0 | 0 | 0 | PartyCode | PartyCode | Mat. Centre (from)code | Mat. Centre code | Mat. Centre code | Mat. Centre code | Party code | Party code |  | MC Code | Contact Code | Contact Code |  |
| MasterCode2 | MC Code | MC Code | MC Code | MC Code | Mat. Centre code | Mat. Centre code | Mat. Centre code | Mat. Centre code | 0 | 0 | 0 | 0 | 0 | 0 | Mat. Centre (to)code | BOM code | BOM code | Mat. Centre code | Mat. Centre code | Mat. Centre code |  | Executive Code | CRM Source Code | Executive Code | CRM Source Code |
| Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp | Stamp |
| AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo | AutoVchNo |
| CM1 | Sales typeCode | Purchase TypeCode | Sales typeCode | Purchase TypeCode | Sales typeCode | Purchase TypeCode | Sales typeCode | Purchase typeCode |  |  |  |  |  |  |  | MC Code | MC Code | MC Code | Sale Type Code | Purchase Type Code | Bank Code |  |  |  |  |
| CM2 |  |  |  |  | FormRecCode | FormRecCode |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | Credit Acc Code |  | Call Sub Status Code | Call Sub Status Code | Call Sub Status Code |
| CM3 |  |  |  |  | FormIssCode | FormIssCode |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  | Next Action Code | Next Action Code | Next Action Code |
| CM4 | Broker Code | Broker Code | Broker Code | Broker Code | BrokerCode | BrokerCode | BrokerCode | BrokerCode |  |  |  |  |  |  | 0 | 0 | 0 | 0 | BrokerCode | BrokerCode |  | BrokerCode | Executive Code |  |  |
| CM5 | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | 0 | 0 | 0 | 0 | AltCurCode | AltCurCode |  | AltCurCode |  |  |  |
| FormRecAmt |  |  |  |  | FormRecAmount | FormRecAmount |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| FormIssAmt |  |  |  |  | FormIssAmt | FormIssAmt |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| CurConRate | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor | CurConFactor |  |  |  |  |  |  |  | CurConFactor |  |  |  |
| ExciseApplicable |  |  |  |  | ExciseApplicable | ExciseApplicable | ExciseApplicable | ExciseApplicable | ExciseApplicable | ExciseApplicable |  | ExciseApplicable |  |  | 0 | 0 | 0 | 0 | 0 | 0 | False | False | False | False | False |
| ExciseDocName |  |  |  |  | ExciseDocName | ExciseDocName | ExciseDocName | ExciseDocName | ExciseDocName | ExciseDocName |  | ExciseDocName |  |  | " " | " " | " " | " " | " " | " " |  |  |  |  |  |
| ExciseValue |  |  |  |  | ExciseValue | ExciseValue | ExciseValue | ExciseValue | ExciseValue | ExciseValue |  | ExciseValue |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| ExciseType |  |  |  |  | ExciseType | ExciseType | ExciseType | ExciseType | ExciseType | ExciseType |  | ExciseType |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| ExcisableAmount |  |  |  |  | ExciseableAmount | ExciseableAmount | ExciseableAmount | ExciseableAmount |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| ExciseRate |  |  |  |  | ExciseRate | ExciseRate | ExciseRate | ExciseRate |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| TEApplicable |  |  |  |  | TEApplicable | TEApplicable | TEApplicable | TEApplicable |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| TDSApplicable |  |  |  |  |  |  |  |  | TDS Applicable | TDS Applicable | TDSApplicable |  |  |  | 0 | 0 | 0 |  | 0 |  |  |  |  |  |  |
| FormRecStatus | 0 | 0 |  |  | FormRecStatus | FormRecStatus |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| FormIssStatus | 0 | 0 |  |  | FormIssStatus | FormIssStatus |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| ChallanStatus |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 |  | 0 |  |  |  |  |  |  |
| STApplicable |  |  |  |  | STApplicable | STApplicable | STApplicable |  | ST Applicable | ST Applicable |  |  |  |  | 0 | 0 | 0 |  | 0 |  |  |  |  |  |  |
| STType |  |  |  |  | STType | STType | STType |  | STType | STType |  |  |  |  | 0 | 0 | 0 |  | 0 |  |  |  |  |  |  |
| DocPrinted | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document | Boolean Flag depending on Printing of document |
| External | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source | If Data is pushed by other Source |
| CREATEDBY |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| CreationTime |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| AthourisedBy |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| AthourisationTime |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| MODIFIEDBY | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName | UserProfileName |  |  |  |  |  |
| ModificationTime | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now | Now |  |  |  |  |  |
| PriceCategory | Price Category | Price Category | Price Category | Price Category | Price Category | 0 | Price Category |  |  |  |  |  |  |  | 0 | 0 | 0 |  | Price Category | Price Category |  |  |  |  |  |
| VATInfo |  |  |  |  |  |  |  |  | Input VAT Adjustment Details | Input VAT Adjustment Details | Input VAT Adjustment Details |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| POSEnabled | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 |  |  |  |  |  |  | POS Enabled = 1 Not Enable =0 |  |  |  | POS Enabled = 1 Not Enable =0 | POS Enabled = 1 Not Enable =0 |  |  |  |  |  |
| AutoGenerated Type |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| VchAmtBaseCur | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount in Base currency | Voucher amount in Base currency | Voucher amount in Base currency | Voucher amount in Base currency | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries | Value of Item Generated | Value of Items Unassembled | Value of Item Generated | Voucher amount including Bill Sundries | Voucher amount including Bill Sundries |  |  |  |  |  |
| VchSalePurcAmt | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | 0 | 0 | 0 | 0 | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries | 0 | 0 | 0 | Voucher amount excluding Bill Sundries | Voucher amount excluding Bill Sundries |  |  |  |  |  |
| Cancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled | VchCancelled |  |
| BrokerageMode | BrokerageMode | BrokerageMode | BrokerageMode | BrokerageMode | Brokerage Mode | Brokerage Mode | Brokerage Mode | Brokerage Mode |  |  |  |  |  |  |  |  |  |  | Brokerage Mode | Brokerage Mode |  |  |  |  |  |
| Brokerage | Rate of Brokerage | Rate of Brokerage | Rate of Brokerage | Rate of Brokerage | Rate of Brokerage | Rate of Brokerage | Rate of Brokerage | Rate of Brokerage |  |  |  |  |  |  |  |  |  |  | Rate of Brokerage | Rate of Brokerage |  |  |  |  |  |
| BrokerageAmt | Brokerage Amount | Brokerage Amount | Brokerage Amount | Brokerage Amount | Brokerage Amount | Brokerage Amount | Brokerage Amount | Brokerage Amount |  |  |  |  |  |  |  |  |  |  | Brokerage Amount | Brokerage Amount |  |  |  |  |  |
| TranType |  |  |  |  | Direct = 0 Against Challan =6 | Direct = 0 Against Challan =6 | Direct = 0 Against Challan =6 | Direct = 0 Against Challan =6 | Whether it is PDC or Regular Payment | Whether it is PDC or Regular Receipt |  |  |  |  |  |  |  |  | To be Tracked with Party = 0 Not to be Tracked with Party = 2 Sale Challan/ Purchase Challan = 3 Purchase Return Challan/Sale Return Challan = 4 Challan Reversal = 5 Issued after Job Work =7 Issued for Job Work =8 | To be Tracked with Party = 0 Not to be Tracked with Party = 2 Sale Challan/ Purchase Challan = 3 Purchase Return Challan/Sale Return Challan = 4 Challan Reversal = 5 Issued after Job Work =7 Issued for Job Work =8 | Salary = 0 Overtime =51 Leave Encashment =52 Bonus =53 |  | TranType | TranType | TranType |
| FreeQtyUsed |  |  |  |  | Free Qty given | Free Qty given | Free Qty given | Free Qty given |  |  |  |  |  |  | Free Qty given |  |  |  | Free Qty given | Free Qty given |  |  |  |  |  |
| Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled | Voucher Cancelled |  | Voucher Cancelled |  |  |  |
| D1 |  |  |  |  |  | Entry Tax Amount |  | Entry Tax Amount |  |  |  |  |  |  |  | ExtraExpenseInBOM |  |  |  |  | Bonus Percent | Entry Tax Amount |  |  |  |
| CM6 |  |  |  |  | Sale Account | Purchase Account | Sale Account | Purchase Account |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| OrignalVchAmtBaseCur | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount | Voucher Total Amount |  |  |  |  |  |
| ApprovalStatus | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status | Approval Status |  | Approval Status |  |  |  |
| SyncStatus | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N |  | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N | Sync Status - Y / N |
| Source | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | 0=Self Feeded | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync | Source  0 = Self Feeded 1= Data Sync |
| AuditStatus | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited | 0= Unaudited 1= Audited |  | 0= Unaudited 1= Audited |  |  |  |
| ExtraExpense |  |  |  |  |  | Voucher Additional Expense |  |  |  |  |  |  |  |  | Voucher Additional Expense | Voucher Additional Expense | Voucher Additional Expense | Voucher Additional Expense |  | Voucher Additional Expense |  |  |  |  |  |
| ExtraExpenseNarr1 |  |  |  |  |  | Voucher Additional Expense Narration 1 |  |  |  |  |  |  |  |  | Voucher Additional Expense Narration 1 | Voucher Additional Expense Narration 1 | Voucher Additional Expense Narration 1 | Voucher Additional Expense Narration 1 |  | Voucher Additional Expense Narration 1 |  |  |  |  |  |
| ExtraExpenseNar2 |  |  |  |  |  | Voucher Additional Expense Narration 2 |  |  |  |  |  |  |  |  | Voucher Additional Expense Narration 2 | Voucher Additional Expense Narration 2 | Voucher Additional Expense Narration 2 | Voucher Additional Expense Narration 2 |  | Voucher Additional Expense Narration 2 |  |  |  |  |  |
| C1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Call No |  | Call No for report |
| Date1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Payroll - Structure Date |  |  |  |  |
| Date2 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Bonus Start Date |  |  |  |  |
| I1 | Scheme Type | Scheme Type | Scheme Type | Scheme Type | Scheme Type | Scheme Type | Scheme Type | Scheme Type |  |  |  |  |  |  |  |  |  |  | Scheme Master Type | Scheme Master Type | Salary Type |  |  |  |  |
| I2 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Salary Month |  |  |  |  |
| I3 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Total Days in the Month |  |  |  |  |
| I4 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Working Hours in a Day |  |  |  |  |
| I5 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Working Minutes in a Month |  |  |  |  |
| I6 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Production Calculaion Base |  |  |  |  |
| I7 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Payment Mode |  |  |  |  |
| I8 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I9 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I10 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| B1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Full n Final - Y/ N |  |  |  |  |
| OldIdentity | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) |  | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) | old voucher identity in case of sync(HO-BO) |
| TPF1 | 0 | 0 | False | False | False | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  | False |  |  |  |
| TPF2 | 0 | 0 | False | False | False | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  | False |  |  |  |
| RejectionStatus | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected | 0= Not Rejeced 1= Rejected |  |  |  |
| L1 |  |  |  |  |  |  |  |  | Previous Year Voucher Code in case of Post Dated Cheque | Previous Year Voucher Code in case of Post Dated Cheque |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| SourceDet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| NepaliDate | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format | Date in Nepali Format |  |  |  |
| NepaliFY | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format | Financial Year in Nepali Format |  |  |  |
| CM7 | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code |  |  |  |  |  |  |  |  |  |  | Scheme Master Code | Scheme Master Code |  |  |  |  |  |

## Tran2

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 | col13 | col14 | col15 | col16 | col17 | col18 | col19 | col20 | col21 | col22 | col23 | col24 | col25 | col26 | col27 | col28 | col29 | col30 | col31 | col32 | col33 | col34 | col35 | col36 | col37 | col38 | col39 | col40 | col41 | col42 | col43 | col44 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Tran2 Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Sales Order - Item  | Sales Order - Bill S  | Purchase Order - Item   | Purchase Order-Bill S  | Sales - Item Info | Sales - Bill Sundry Info | Sales - Acc Info | Purchase - Item Info | Purchase - Bill S | Purchase - Acc Info | Sales Return - Item Info | Sales Return - Bill Sundry Info | Sales Return - Acc Info | Pur. Return - Item Info | Pur. Return - Bill Sundry Info | Pur. Return - Acc Info | Payment - Acc Info | Payment - Item Info | Receipt - Acc Info | Receipt - Item Info | Journal - Acc Info | Journal - Item Info | Contra - Acc Info | Debit Note -  Acc Info | Debit Note - Item Info | Credit Note - Acc Info | Credit Note - Item Info | Stock Transfer -Item Info | Stock Transfer -Item(RM) Info | Stock Transfer -Bill Sundry Info | Production - Item (Data arr)Info | Production - Item Info(RM) | Unassemble -Item (Data arr)Info | Unassemble -Item Info(RM) | Stock Journal -Item(Data arr)Info | Stock Journal -Item Info(RM) | Mat. Iss. - Item Info | Mat. Iss. - Bill Sundry Info | Mat. Rec. - Item Info | Mat. Rec. - Bill Sundry Info | Salary Calculation | Salary Component Info | PURCHASE_INDENT | Call Info |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | RecType | Rectype | Rectype | Rectype | Rectype |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | Vch Code | Vchcode | Vchcode |
| MasterCode1 | Item code | Bill SUndry code | Item code | Bill Sundry code | Item code | Bill Sundry mast code | AccMast code | Item code | Bill Sundry Mast code | AccMast code | Item code | Bill Sundry mast code | AccMast code | Item code | Bill Sundry mast code | AccMast code | AccMast code | ItemMast code | AccMast code | ItemMast code | AccMast code | ItemMast code | AccMast code | AccMast code | ItemMast code | AccMast code | ItemMast code | Item code | Item code | Bill Sundry mast code | Item code | Item code | Item code | Item code | Item code | Item code | Item code | Bill Sundry mast code | Item code | Bill Sundry mast code | Emp MastCode | Component Code | Item Code | Item Code |
| MasterCode2 | MC Code | 0 | MC Code | 0 | Material Centre code | 0 | 0 | Material Centre code | 0 | 0 | Material Centre code | 0 | 0 | Material Centre code | 0 | 0 | 0 | Material Centre code | 0 | Material Centre code | 0 | Material Centre code | 0 | 0 | Mccode | 0 | Mccode | Material Centre (To)code | Material Centre (From)code | 0 | Material Centre code | Material Centre code | Material Centre code | Material Centre code | Material Centre code | Material Centre code | Material Centre code | 0 | Material Centre code | 0 |  | Emp Code | MC Code |  |
| SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | Sr No | Sr NO | Sr No | Sr no |
| VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | Vchtype | VchType | Vchtype | vchtype |
| Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | date |
| VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | Vch No | Vchno | Vch No | Call No |
| VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | Vch Series Code | VchSeries Code | Vch Series Code | Vch Series Code |
| Value1 | QtyMainUnit | PercentVal | QtyMainUnit | PercentVal | QtyMainUnit | PercentVal | AmtMainCur | QtyMainUnit | PercentVal | AmtMainCur | QtyMainUnit | PercentVal | AmtMainCur | QtyMainUnit | PercentVal | AmtMainCur | AmtMainCur |  | AmtMainCur |  | AmtMainCur |  | AmtMainCur | AmtMainCur | 0 | AmtMainCur | 0 | QtyMainUnit | QtyMainUnit | PercentVal | QtyMainUnit | QtyMainUnit | QtyMainUnit | QtyMainUnit | QtyMainUnit | QtyMainUnit | QtyMainUnit | PercentVal | QtyMainUnit | PercentVal | Gross Salary | Vale | Qty Main Unit |  |
| Value2 | QtyAltUnit | PercentOperatedOn | QtyAltUnit | PercentOperatedOn | QtyAltUnit | PercentOperatedOn | AmtAltCur | QtyAltUnit | PercentOperatedOn | AmtAltCur | QtyAltUnit | PercentOperatedOn | AmtAltCur | QtyAltUnit | PercentOperatedOn | AmtAltCur | AmtAltCur |  | AmtAltCur |  | AmtAltCur |  | AmtAltCur | AmtAltCur | 0 | AmtAltCur | 0 | QtyAltUnit | QtyAltUnit | PercentOperatedOn | QtyAltUnit | QtyAltUnit | QtyAltUnit | QtyAltUnit | QtyAltUnit | QtyAltUnit | QtyAltUnit | PercentOperatedOn | QtyAltUnit | PercentOperatedOn | Net Salary | Base Amt | Qty Alt Unit |  |
| Value3 | NettAmount | Amt | NettAmount | Amt | NettAmount | Amt |  | NettAmount | Amt |  | NettAmount | Amt |  | NettAmount | Amt |  |  | Amount |  | Amount |  | Amount |  |  | Amount |  | Amount | NettAmount | NettAmount | Amt | NettAmount | NettAmount | NettAmount | NettAmount | NettAmount | NettAmount | NettAmount | Amt | NettAmount | Amt | Net Payable | Actual Value | Nett Amt |  |
| Balance1 |  |  |  |  | Item Bal at MatCentre (Main Unit) | 0 | AccBal(Main Curr) | Item Bal at MatCentre (Main Unit) | 0 | AccBal(Main Curr) | Item Bal at MatCentre (Main Unit) | 0 | AccBal(Main Curr) | Item Bal at MatCentre (Main Unit) | 0 | AccBal(Main Curr) | AccBal(Main Curr) |  | AccBal(Main Curr) |  | AccBal(Main Curr) |  | AccBal(Main Curr) | AccBal(Main Curr) |  |  |  | Item Bal at MatCentre (Main Unit) | Item Bal at MatCentre (Main Unit) | 0 | Item Bal at MatCentre (Main Unit) | Item Bal at MatCentre (Main Unit) | Item Bal at MatCentre (Main Unit) | Item Bal at MatCentre (Main Unit) | Item Bal at MatCentre (Main Unit) | Item Bal at MatCentre (Main Unit) | Item Bal at MatCentre (Main Unit) | 0 | Item Bal at MatCentre (Main Unit) |  |  |  |  |  |
| Balance2 |  |  |  |  | Item Bal at MatCentre (Alt Unit) | 0 | AccBal(Alt Curr) | Item Bal at MatCentre (Alt Unit) | 0 | AccBal(Alt Curr) | Item Bal at MatCentre (Alt Unit) | 0 | AccBal(Alt Curr) | Item Bal at MatCentre (Alt Unit) | 0 | AccBal(Alt Curr) | AccBal(Alt Curr) |  | AccBal(Alt Curr) |  | AccBal(Alt Curr) |  | AccBal(Alt Curr) | AccBal(Alt Curr) |  |  |  | Item Bal at MatCentre (Alt Unit) | Item Bal at MatCentre (Alt Unit) | 0 | Item Bal at MatCentre (Alt Unit) | Item Bal at MatCentre (Alt Unit) | Item Bal at MatCentre (Alt Unit) | Item Bal at MatCentre (Alt Unit) | Item Bal at MatCentre (Alt Unit) | Item Bal at MatCentre (Alt Unit) | Item Bal at MatCentre (Alt Unit) | 0 | Item Bal at MatCentre (Alt Unit) |  |  |  |  |  |
| Balance3 |  |  |  |  | Value | 0 |  | Value | 0 |  | Value | 0 |  | Value | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Value | Value | 0 | Value | Value | Value | Value | Value | Value | Value | 0 | Value |  |  |  |  |  |
| ItemBal1 |  |  |  |  | Total ItemBal (MainUnit) | 0 |  | Total ItemBal (MainUnit) | 0 |  | Total ItemBal (MainUnit) | 0 |  | Total ItemBal (MainUnit) | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Total ItemBal (MainUnit) | Total ItemBal (MainUnit) | 0 | Total ItemBal (MainUnit) | Total ItemBal (MainUnit) | Total ItemBal (MainUnit) | Total ItemBal (MainUnit) | Total ItemBal (MainUnit) | Total ItemBal (MainUnit) | Total ItemBal (MainUnit) | 0 | Total ItemBal (MainUnit) |  |  |  |  |  |
| ItemBal2 |  |  |  |  | Total ItemBal (AltUnit) | 0 |  | Total ItemBal (AltUnit) | 0 |  | Total ItemBal (AltUnit) | 0 |  | Total ItemBal (AltUnit) | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Total ItemBal (AltUnit) | Total ItemBal (AltUnit) | 0 | Total ItemBal (AltUnit) | Total ItemBal (AltUnit) | Total ItemBal (AltUnit) | Total ItemBal (AltUnit) | Total ItemBal (AltUnit) | Total ItemBal (AltUnit) | Total ItemBal (AltUnit) | 0 | Total ItemBal (AltUnit) |  |  |  |  |  |
| ItemBal3 |  |  |  |  | ValueTotalItemBal | 0 |  | ValueTotalItemBal | 0 |  | ValueTotalItemBal | 0 |  | ValueTotalItemBal | 0 |  |  |  |  |  |  |  |  |  |  |  |  | ValueTotalItemBal | ValueTotalItemBal | 0 | ValueTotalItemBal | ValueTotalItemBal | ValueTotalItemBal | ValueTotalItemBal | ValueTotalItemBal | ValueTotalItemBal | ValueTotalItemBal | 0 | ValueTotalItemBal |  |  |  |  |  |
| CashFlow |  |  |  |  | 0 | 0 | CashFlow |  | 0 | CashFlow | 0 | 0 | CashFlow |  | 0 | CashFlow | CashFlow |  | CashFlow |  | CashFlow |  | 0 | 0 |  | 0 |  | 0 |  | 0 | 0 | 0 | 0 | 0 |  |  |  | 0 |  |  |  |  |  |  |
| ShortNar | Item Additional info | BS narration | Item Additional info | BS narration | Item Additional info | BS narration | ShortNar | Item Additional info | BS narration | ShortNar | Item Additional info | BS narration | ShortNar | Item Additional info | BS narration | ShortNar | ShortNar |  | ShortNar |  | ShortNar |  | ShortNar | ShortNar |  | ShortNar |  | Item Additional info | Item Additional info | 0 | Item Additional info | Item Additional info | Item Additional info | Item Additional info | Item Additional info | Item Additional info | Item Additional info | 0 | Item Additional info |  |  |  |  | Remarks of item |
| D1 | Qty | CurConRate | Qty | CurConRate | Qty | CurConRate | AltCurConRate | Qty | CurConRate | AltCurConRate | Qty | CurConRate | AltCurConRate | Qty | CurConRate | AltCurConRate | AltCurConRate |  | AltCurConRate |  | AltCurConRate |  | AltCurConRate | AltCurConRate |  | AltCurConRate |  | Qty | Qty | 0 | Qty | Qty | Qty | Qty | Qty | Qty | Qty | 0 | Qty | CurConRate | No Of Leaves | Percent Val | Qty | Qty |
| D2 | Price | AmtAltCur | Price | AmtAltCur | Price | AmtAltCur |  | Price | AmtAltCur |  | Price | AmtAltCur |  | Price | AmtAltCur |  |  |  |  |  |  |  |  |  |  |  |  | Price | Price | 0 | Price | Price | Price | Price | Price | Price | Price | 0 | Price |  | No Of Absents | Comp Value | Price |  |
| D3 | PriceAltUnit | PercentAltCur | PriceAltUnit | PercentAltCur | PriceAltUnit | PercentAltCur |  | PriceAltUnit | PercentAltCur |  | PriceAltUnit | PercentAltCur |  | PriceAltUnit | 0 |  |  |  |  |  |  |  |  |  |  |  |  | PriceAltUnit | PriceAltUnit | 0 | PriceAltUnit | PriceAltUnit | PriceAltUnit | PriceAltUnit | PriceAltUnit | PriceAltUnit | PriceAltUnit | 0 | PriceAltUnit |  | CTC | Comp Base Value | Price Alt Unit |  |
| D4 | ListPrice | PercentOperatedOnAltCur | ListPrice | PercentOperatedOnAltCur | ListPrice | PercentOperatedOnAltCur |  | ListPrice | PercentOperatedOnAltCur |  | ListPrice | PercentOperatedOnAltCur |  | ListPrice | PercentOperatedOnAltCur |  |  |  |  |  |  |  |  |  |  |  |  | ListPrice | ListPrice | 0 | ListPrice | ListPrice | ListPrice | ListPrice | ListPrice | ListPrice | ListPrice | 0 | ListPrice |  | EarningTotal | Comp Actual Value | List Price |  |
| D5 | Amt |  | Amt |  | Amt | 0 |  | Amt | 0 |  | Amt | 0 |  | Amt | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Amt | Amt | 0 | Amt | Amt | Amt | Amt | Amt | Amt | Amt | 0 | Amt |  | DeductionTotal |  | Amt |  |
| D6 | NettPrice |  | NettPrice |  | NettPrice | 0 |  | NettPrice | 0 |  | NettPrice | 0 |  | NettPrice | 0 |  |  |  |  |  |  |  |  |  |  |  |  | NettPrice | NettPrice | 0 | NettPrice | NettPrice | NettPrice | NettPrice | NettPrice | NettPrice | NettPrice | 0 | NettPrice |  | AdjustmentTotal |  | Nett Price |  |
| D7 | CurConRate |  | CurConRate |  | CurConRate | 0 |  | CurConRate | 0 |  | CurConRate | 0 |  | CurConRate | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 0 |  |  |  |  |  |  |  | 0 |  |  | ContributionTotal |  | CurCon Rate |  |
| D8 | MainUCFactor |  | MainUCFactor |  | MainUCFactor | 0 |  | MainUCFactor | 0 |  | MainUCFactor | 0 |  | MainUCFactor | 0 |  |  |  |  |  |  |  |  |  |  |  |  | MainUCFactor | MainUCFactor | 0 | MainUCFactor | MainUCFactor | MainUCFactor | MainUCFactor | MainUCFactor | MainUCFactor | MainUCFactor | 0 | MainUCFactor |  | ActualGrossSalary |  | Main UC Factor |  |
| D9 | DiscountPercent |  | DiscountPercent |  | DiscountPercent | 0 |  | DiscountPercent | 0 |  | DiscountPercent | 0 |  | DiscountPercent | 0 |  |  |  |  |  |  |  |  |  |  |  |  | DiscountPercent | DiscountPercent | 0 | DiscountPercent | DiscountPercent | DiscountPercent | DiscountPercent | DiscountPercent | DiscountPercent | DiscountPercent | 0 | DiscountPercent |  | ActualNetSalary |  | Discount Percent |  |
| D10 | Discount |  | Discount |  | Discount | 0 |  | Discount | 0 |  | Discount | 0 |  | Discount | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Discount | Discount | 0 | Discount | Discount | Discount | Discount | Discount | Discount | Discount | 0 | Discount |  | ActualNetPayable |  | Discount |  |
| D11 | STAmount |  | STAmount |  | STAmount | 0 |  | STAmount | 0 |  | STAmount | 0 |  | STAmount | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Wastage Percent | 0 | Wastage Percent |  | ActualCTC |  | ST Amt/ Wastage Percentage |  |
| D12 | STPercent |  | STPercent |  | STPercent | 0 |  | STPercent | 0 |  | STPercent | 0 |  | STPercent | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Wastage qty | 0 | Wastage qty |  | UnitsProduced |  | ST Percent/ Wastage Qty |  |
| D13 | Amt Allocated to Qty |  | Amt Allocated to Qty |  | Amt Allocated to Qty | 0 |  | Amt Allocated to Qty | 0 |  | Amt Allocated to Qty | 0 |  | Amt Allocated to Qty | 0 |  |  | AmtAllocatedToQty |  | AmtAllocatedToQty |  | AmtAllocatedToQty |  |  | AmtAllocatedToQty |  | AmtAllocatedToQty | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  | 0 |  |  | PerUnitWages |  | Amt Allocated to Qty |  |
| D14 | TaxBeforeSurcharge |  | TaxBeforeSurcharge |  | TaxBeforeSurcharge | 0 |  | TaxBeforeSurcharge | 0 |  | TaxBeforeSurcharge | 0 |  | TaxBeforeSurcharge | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  | Wastage qty main | 0 | Wastage qty main |  | LeavesToEncash |  | Tax Before Schg / WastageQtyMainUnit |  |
| D15 | STSurchargePrcent |  | STSurchargePrcent |  | STSurchargePrcent | 0 |  | STSurchargePrcent | 0 |  | STSurchargePrcent | 0 |  | STSurchargePrcent | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  | Wastage qty alt | 0 | Wastage qty alt |  | PaidDays |  | ST Schg Rate/ WastageQtyAltUnit |  |
| D16 | STSurchargeAmt |  | STSurchargeAmt |  | STSurchargeAmt | 0 |  | STSurchargeAmt | 0 |  | STSurchargeAmt | 0 |  | STSurchargeAmt | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  | Wastage amt | 0 | Wastage amt |  |  |  | ST Schg Amt/ WastageAmt |  |
| D17 | Alt Qty Con Factor |  | Alt Qty Con Factor |  | AltQtyConFactor | 0 |  | AltQtyConFactor | 0 |  | AltQtyConFactor | 0 |  | AltQtyConFactor | 0 |  |  |  |  |  |  |  |  |  |  |  |  | AltQtyConFactor | AltQtyConFactor | 0 | 0 | 0 | 0 | 0 |  |  | AltQtyConFactor | 0 | 0 |  |  |  | Alt Qty Con Factor |  |
| D18 | ItemMRP |  | ItemMRP |  | ItemMRP | 0 |  | ItemMRP | 0 |  | ItemMRP | 0 |  | ItemMRP | 0 |  |  |  |  |  |  |  |  |  |  |  |  | ItemMRP | ItemMRP | 0 | 0 | 0 | 0 | 0 | ItemMRP | ItemMRP | ItemMRP | 0 | 0 |  |  |  | Item MRP |  |
| CM1 | PartyCode | Sale/Purc Acc Code | PartyCode | Sale/Purc Acc Code | PartyCode | Sale/Purc Acc Code |  | PartyCode | Sale/Purc Acc Code |  | PartyCode | Sale/Purc Acc Code |  | PartyCode | Sale/Purc Acc Code |  |  | PartyCode |  | PartyCode |  | PartyCode |  |  | PartyCode |  | PartyCode | Material Centre (From)code | Material Centre (To)code | Sale/Purc Acc Code | BOMCode | BOMCode | BOMCode | BOMCode | Material Centre Code | Material Centre Code | PartyCode | Sale/Purc Acc Code | PartyCode | Sale/Purc Acc Code |  |  | Party Code |  |
| CM2 | MainUnitCode | Party Code | MainUnitCode | Party Code | MainUnitCode | Party Code |  | MainUnitCode | Party Code |  | MainUnitCode | Party Code |  | MainUnitCode | Party Code |  |  | MainUnitCode |  | MainUnitCode |  | MainUnitCode |  |  | MainUnitCode |  | MainUnitCode | MainUnitCode | MainUnitCode | Party Code | MainUnitCode | MainUnitCode | MainUnitCode | MainUnitCode | MainUnitCode | MainUnitCode | MainUnitCode | Party Code | MainUnitCode | Party Code |  |  | MainUnit Code | main unit Code |
| CM3 | Transaction_UnitCode |  | Transaction_UnitCode |  | Transaction_UnitCode | 0 |  | AltUnitCode | 0 |  | AltUnitCode | 0 |  | AltUnitCode | 0 |  |  | AltUnitCode |  | AltUnitCode |  | AltUnitCode |  |  | AltUnitCode |  | AltUnitCode | AltUnitCode | AltUnitCode | 0 | AltUnitCode | AltUnitCode | AltUnitCode | AltUnitCode | AltUnitCode | AltUnitCode | AltUnitCode | 0 | AltUnitCode |  |  |  | Unit Code | unit Code |
| CM4 | Sale type Code |  | 0 |  | SaleTypeCode | 0 |  | PurchaseTypeCode | 0 |  | SaleTypeCode | 0 |  | StPtCode | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  | STPT Code |  |
| CM5 | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | tmpAltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode | AltCurCode |  | AltCurCode |  | AltCurCode |  | AltCurCode | AltCurCode |  | AltCurCode |  | 0 | 0 | AltCurCode | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AltCurCode | 0 | AltCurCode |  |  | Alt Cur Code |  |
| CM6 | Broker Code |  | Broker Code |  | BrokerCode | 0 |  | BrokerCode | 0 |  | BrokerCode | 0 |  | BrokerCode | 0 |  | Broker Code |  | Broker Code |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  | Broker Code |  |
| B1 | Item Exmpted = true/False |  | Item Exmpted = true/False |  | Exempted | 0 |  | Exempted | 0 |  | Exempted | 0 |  | Exempted | 0 |  | Settlement enable =1 Settlement Not enable =0  |  | Settlement enable =1 Settlement Not enable =0  |  |  |  |  |  |  |  |  | Exempted | Exempted | 0 | Exempted | Exempted | Exempted | Exempted | 0 | 0 | Exempted | 0 | Exempted |  | Edited by User | Used in Structure | Exempt |  |
| B2 | Item taxpaid = True/false |  | Item taxpaid = True/false |  | TaxPaid | 0 |  | TaxPaid | 0 |  | TaxPaid | 0 |  | TaxPaid | 0 |  |  |  |  |  |  |  |  |  |  |  |  | TaxPaid | TaxPaid | 0 | TaxPaid | TaxPaid | TaxPaid | TaxPaid | 0 | 0 | TaxPaid | 0 | TaxPaid |  |  |  | Tax Paid |  |
| B3 | only consumption = true/false |  | only consumption = true/false |  | OnlyConsumption | 0 |  | OnlyConsumption | 0 |  | OnlyConsumption | 0 |  | OnlyConsumption | 0 |  |  |  |  |  |  |  |  |  |  |  |  | OnlyConsumption | OnlyConsumption | 0 | OnlyConsumption | OnlyConsumption | OnlyConsumption | OnlyConsumption | 0 | 0 | OnlyConsumption | 0 | OnlyConsumption |  |  |  | Only Consumption |  |
| B4 | Taxfree = true/false |  | Taxfree = true/false |  | Taxfree = true/false | 0 |  | Taxfree = true/false | 0 |  | Taxfree = true/false | 0 |  | Taxfree = true/false | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Taxfree = true/false | Taxfree = true/false | 0 | Taxfree = true/false | Taxfree = true/false | Taxfree = true/false | Taxfree = true/false |  |  | Taxfree = true/false | 0 | Taxfree = true/false |  |  |  | Tax Free |  |
| B5 | Unregistered = true/false |  | Unregistered = true/false |  | Unregistered = true/false | 0 |  | Unregistered = true/false | 0 |  | Unregistered = true/false | 0 |  | Unregistered = true/false | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Unregistered = true/false | Unregistered = true/false | 0 | Unregistered = true/false | Unregistered = true/false | Unregistered = true/false | Unregistered = true/false |  |  | Unregistered = true/false | 0 | Unregistered = true/false |  |  |  | UregUnRegistered |  |
| B6 | Lumpsum = true/false |  | Lumpsum = true/false |  | Lumpsum = true/false | 0 |  | Lumpsum = true/false | 0 |  | Lumpsum = true/false | 0 |  | Lumpsum = true/false | 0 |  |  |  |  |  |  |  |  |  |  |  |  | Lumpsum = true/false | Lumpsum = true/false | 0 | Lumpsum = true/false | Lumpsum = true/false | Lumpsum = true/false | Lumpsum = true/false |  |  | Lumpsum = true/false | 0 | Lumpsum = true/false |  |  |  | Lumpsum |  |
| B7 | 0 | 0 | 0 | 0 | 0 | 0 |  | 0 | 0 |  | 0 | 0 |  | 0 | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  | 0 | 0 | 0 |  |  |  |  |  |
| B8 |  |  |  |  | 0 | 0 |  | 0 | 0 |  | 0 | 0 |  | 0 | 0 |  |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  | 0 | 0 | 0 |  |  |  |  |  |
| ClrDate |  |  |  |  | 0 | 0 |  | 0 | 0 |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  | 0 |  | 0 |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |
| PriceCategory | Price Category |  | Price Category |  | Price Category | 0 | 0 | 0 | 0 | 0 | Price Category | 0 | 0 | 0 | 0 | 0 |  |  |  |  |  |  |  |  |  |  |  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |  |  | 0 | 0 | 0 |  |  |  |  |  |
| D19 | PriceAltCur |  | PriceAltCur |  | PriceAltCur |  |  | PriceAltCur |  |  | PriceAltCur |  |  | PriceAltCur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Price Alt Cur |  |
| D20 | PriceAltUnitAltCur |  | PriceAltUnitAltCur |  | PriceAltUnitAltCur |  |  | PriceAltUnitAltCur |  |  | PriceAltUnitAltCur |  |  | PriceAltUnitAltCur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | PriceAltUnitAltCur |  |
| D21 | ListPriceAltCur |  | ListPriceAltCur |  | ListPriceAltCur |  |  | ListPriceAltCur |  |  | ListPriceAltCur |  |  | ListPriceAltCur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ListPriceAltCur |  |
| D22 | AmtAltCur |  | AmtAltCur |  | AmtAltCur |  |  | AmtAltCur |  |  | AmtAltCur |  |  | AmtAltCur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | AmtAltCur |  |
| D23 | ItemMRPAltCur |  | ItemMRPAltCur |  | ItemMRPAltCur |  |  | ItemMRPAltCur |  |  | ItemMRPAltCur |  |  | ItemMRPAltCur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ItemMRPAltCur |  |
| D24 | DiscInAltCur |  | DiscInAltCur |  | DiscInAltCur |  |  | DiscInAltCur |  |  | DiscInAltCur |  |  | DiscInAltCur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | DiscountInAltCur |  |
| D25 | DiscPerAltCur |  | DiscPerAltCur |  | DiscPerAltCur |  |  | DiscPerAltCur |  |  | DiscPerAltCur |  |  | DiscPerAltCur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | DiscountPercentAltCur |  |
| C1 | Compound Discount |  | Compound Discount |  | Compound Discount |  |  | Compound Discount |  |  | Compound Discount |  |  | Compound Discount |  |  |  | Compound Discount |  | Compound Discount |  | Compound Discount |  |  | Compound Discount |  | Compound Discount | Compound Discount |  |  |  |  |  |  |  |  | Compound Discount |  | Compound Discount |  |  |  | CompoundDiscount |  |
| CFMode | Alt per Main = 0 Main per Alt =1 |  | Alt per Main = 0 Main per Alt =1 |  | Alt per Main = 0 Main per Alt =1 |  |  | Alt per Main = 0 Main per Alt =1 |  |  | Alt per Main = 0 Main per Alt =1 |  |  | Alt per Main = 0 Main per Alt =1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Alt per Main = 0 Main per Alt =1 |  |
| D26 |  |  |  |  | Sale Price |  |  | Sale Price |  |  | Sale Price |  |  | Sale Price |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Sales Price |  |
| TranType |  |  |  |  | Direct = 0 Against Challan =6 |  |  | Direct = 0 Against Challan =6 |  |  | Direct = 0 Against Challan =6 |  |  | Direct = 0 Against Challan =6 |  |  | Whether PDC or Regular Payment | Whether PDC or Regular Payment |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Salary = 0 Overtime = 51 Leave Encashment = 52 Bonus = 53 | 0 | Both = 0 Enquiry = 1 Support = 2 |
| IsReturnQty | 0 | 0 | 0 | 0 | Whether Returned quantity |  |  | Whether Returned quantity |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Is Return Qty |  |
| D27 | Brokerage |  | Brokerage |  | Brokerage |  |  | Brokerage |  |  | Brokerage |  |  | Brokerage |  |  | Brokerage |  | Brokerage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Brokerage |  |
| D28 | Brokerage Amt |  | Brokerage Amt |  | Brokerage Amt |  |  | Brokerage Amt |  |  | Brokerage Amt |  |  | Brokerage Amt |  |  | Brokerage Amt |  | Brokerage Amt |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Brokerage Amt |  |
| I1 | Brokerage Mode |  | Brokerage Mode |  | Brokerage Mode |  |  | Brokerage Mode |  |  | Brokerage Mode |  |  | Brokerage Mode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Brokerage Mode/Item Sr No |  |
| D29 | Markup Percent |  | Markup Percent |  | Markup Percent |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Markup Percent |  |
| D30 | Markup  |  | Markup  |  | Markup  |  |  | Markup  |  |  | Markup  |  |  | Markup  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Markup  |  | Markup  |  |  |  | Markup |  |
| D31 | Markup in Alt Cur |  | Markup in Alt Cur |  | Markup in Alt Cur |  |  | Markup in Alt Cur |  |  | Markup in Alt Cur |  |  | Markup in Alt Cur |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Markup in Alt Cur |  | Markup in Alt Cur |  |  |  | MarkupInAltCur |  |
| D32 | Markup Percent Alt Currency |  | Markup Percent Alt Currency |  | Markup Percent Alt Currency |  |  | Markup Percent Alt Currency |  |  | Markup Percent Alt Currency |  |  | Markup Percent Alt Currency |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Markup Percent Alt Currency |  | Markup Percent Alt Currency |  |  |  | MarkupPercentAltCur |  |
| CM7 | Discount Structure Master Code |  | Discount Structure Master Code |  | Discount Structure Master Code |  |  | Discount Structure Master Code |  |  | Discount Structure Master Code |  |  | Discount Structure Master Code |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Discount Structure Master Code |  | Discount Structure Master Code |  |  |  | DS Code |  |
| CM8 | Markup Structure Master Code |  | Markup Structure Master Code |  | Markup Structure Master Code |  |  | Markup Structure Master Code |  |  | Markup Structure Master Code |  |  | Markup Structure Master Code |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Markup Structure Master Code |  | Markup Structure Master Code |  |  |  | MS Code |  |
| C2 | Compound Markup  |  | Compound Markup  |  | Compound Markup  |  |  | Compound Markup  |  |  | Compound Markup  |  |  | Compound Markup  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Compound Markup  |  | Compound Markup  |  |  |  | CompoundMarkup   |  |
| C3 | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID | Job ID |  |  |  |  |
| ReconStatus |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I2 | Scheme Type | Scheme Type | Scheme Type | Scheme Type | Scheme Type | Scheme Type |  | Scheme Type | Scheme Type |  | Scheme Type | Scheme Type |  | Scheme Type | Scheme Type |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Scheme Type |  | Scheme Type |  | Minutes in a day | Contribution Sub Det | Scheme Master Type |  |
| I3 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Working Hours | Contribution Sub Det | Scheme Parent Row Sr No |  |
| I4 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Working Minutes | Contribution Sub Det |  |  |
| I5 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Leave Hours | Contribution Sub Det |  |  |
| I6 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Leave Minutes | Contribution Sub Det |  |  |
| I7 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Total No of days | Contribution Sub Det |  |  |
| I8 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Contribution Sub Det |  |  |
| I9 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| I10 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Total Contribution Count |  |  |
| TrackingStatus | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status | Tracking Status |  |  |  |  |
| TrackingNo | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number |  |  |  |  |
| CM9 | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code | Scheme Master Code |  | Scheme Master Code | Scheme Master Code |  | Scheme Master Code | Scheme Master Code |  | Scheme Master Code | Scheme Master Code |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Scheme Master Code |  | Scheme Master Code |  |  |  | Scheme Master Code |  |

## Tran3

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 | col13 | col14 | col15 | col16 | col17 | col18 | col19 | col20 | col21 | col22 | col23 | col24 | col25 | col26 | col27 | col28 | col29 | col30 | col31 | col32 | col33 | col34 | col35 | col36 | col37 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Tran3 Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Acc Mast - Acc ref | Item Mast - Batch Info | Sales Order -Order ref | Purchase Order -Order ref | Sales - Acc Ref. Info | Sales - Item Ref. Info(Batches Det) | Sales - Order Ref. Info | Sales - Challan Ref Info | Purchase - Acc Ref. Info | Purchase -Item Ref. Info(Batches Det) | Purchase -Order Ref. Info | Purchase - Challan Ref Info | Sales Return - Acc Ref. Info | Sales  Return -Item Ref. Info(Batches Det) | Sales Return -  Challan Ref Info | Pur. Return - Acc Ref. Info | Pur. Return - Item Ref. Info(Batches Det) | Purchase Ret. -  Challan Ref Info | Payment - Acc Ref. Info | Receipt - Acc Ref. Info | Journal - Acc Ref. Info | Debit Note - Acc Ref. Info | Credit Note - Acc Ref. Info | Stock Transfer -Item Ref. Info(Batches Det) | Stock Transfer -Item Ref. Info(Batches Det) | Prod.- Item Ref. Info(Batches Det) | Unassemble - Item Ref. Info(Batches Det) | Stock Journal -Item Ref. Info(Batches Det) | Mat Issue - Order Ref. Info | Mat. Iss. - Item Ref. Info(Batches Det) | Mat. Iss. - Challan Ref Info | Mat Rec. - Order Ref. Info | Mat. Rec.- Item Ref. Info(Batches Det) | Mat. Rec. - Challan Ref Info | Sale Quotation Ref | Purchase Quotation Ref | Purchase Indent Refs |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode | RefCode |
| RecType | RecType | RecType | RecType | RecType | RecType  | RecType  | RecType | RecType | RecType  | RecType  | RecType | RecType | RecType  | RecType  | RecType | RecType  | RecType  | RecType | RecType  | RecType  | RecType  | RecType  | RecType  | RecType  | RecType  | RecType  | RecType  | RecType  | RecType | RecType  | RecType | RecType | RecType  | RecType | RecType | RecType | RecType |
| Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method | Method |
| VchCode |  |  | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode |
| VchType |  |  | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType |
| MasterCode1 | Party code | Item code | Item Code | Item Code | Party code | Item code | Item code | Item code | Party code | item code | Item code | Item code | Party code | Item code | Item code | party code | Item code | Item code | Party code | Party code | party code | Party code | Party code | Item code | Item code | Item code | Item code | Item code | Item code | Item code | Item code | Item code | item code | Item code | Item code | Item code | Item code |
| MasterCode2 | 0 | Material Centre code | Party Code | Party Code | 0 | Mat. Cntr. Code | Party code | Party code | 0 | Mat. Cntr. Code | Party code | Party code | 0 | Mat. Cntr. Code | Party code | 0 | Mat. Cntr. Code | Party code | 0 | 0 | 0 | 0 | 0 | Mat. Cntr (From) Code | Mat. Cntr(To) Code | Mat. Cntr. Code | Mat. Cntr. Code | Mat. Cntr. Code | Party code | Mat. Cntr. Code | Party code | Party code | Mat. Cntr . Code | Party code | Party code | Party code | Party code |
| SrNo | SrNo | SrNo. | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo |
| Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date |
| DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate | DueDate |
| No | Ref no | Batch No. | Ref no | Ref no | Vch no | Batch no | Ref no. | Ref no. | Vch no. | Batch no | Ref no. | Ref no. | Vch no | Batch no | Ref no. | Vch no | Batch no | Ref no. | Vch no | Vch no | Vch no | Vch no | Vch no | Batch no | Batch no | Batch no | Batch no | Batch no | Ref no. | Batch no | Ref no. | Ref no. | Batch no | Ref no. | Ref no. | Ref no. | Ref no. |
| Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status | Status |
| Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type | Type |
| BrokerCode | Broker Code |  | 0 | 0 | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode | BrokerCode |  |  |  |  |  | BrokerCode |  | BrokerCode | BrokerCode |  | BrokerCode | BrokerCode | BrokerCode |  |
| Value1 | Value  | Main Qty | Value main | Value main | Value main | Main Qty | Value main | Value main | Value main | Main Qty | Value main | Value main | Value main | Main Qty | Value main | Value main | Main Qty | Value main | Value main | Value main | Value1 | Value1 | Value1 | Value main | Main Qty | Main Qty | Main Qty | Main Qty | Value main | Main Qty | Value main | Value main | Main Qty | Value main | Value main | Value main | Value main |
| Value2 |  | Alt Qty | value alt | value alt | 0 | Alt Qty | value alt | value alt | 0 | Alt Qty | value alt | value alt | 0 | Alt Qty | value alt | 0 | Alt Qty | value alt | 0 | 0 | 0 | 0 | 0 | value alt | Alt Qty | Alt Qty | Alt Qty | Alt Qty | value alt | Alt Qty | value alt | value alt | Alt Qty | value alt | value alt | value alt | value alt |
| Value3 |  | Main Transaction Price | Order Price (Main) | Order Price (Main) | 0 | Main Transaction Price | 0 | Main Transaction Price | 0 | Main Transaction Price | 0 | Main Transaction Price | 0 | Main Transaction Price | Main Transaction Price | 0 | Main Transaction Price | Main Transaction Price | 0 | 0 | 0 | 0 | 0 | 0 | Main Transaction Price | Main Transaction Price | Main Transaction Price | Main Transaction Price | 0 | Main Transaction Price | Main Transaction Price | 0 | Main Transaction Price | Main Transaction Price | Main Transaction Price | Main Transaction Price |  |
| Balance1 |  | Alt Transaction Price | Order Price (Alt) | Order Price (Alt) |  | Alt Transaction Price |  | Alt Transaction Price |  | Alt Transaction Price |  | Alt Transaction Price |  | Alt Transaction Price | Alt Transaction Price |  | Alt Transaction Price | Alt Transaction Price |  |  |  |  |  |  | Alt Transaction Price | Alt Transaction Price | Alt Transaction Price | Alt Transaction Price |  | Alt Transaction Price | Alt Transaction Price |  | Alt Transaction Price | Alt Transaction Price | Alt Transaction Price | Alt Transaction Price |  |
| Balance2 |  | Item MRP |  |  | 0 | Item MRP |  |  |  | Item MRP |  |  |  | Item MRP |  | 0 | Item MRP |  | 0 | 0 | 0 | 0 | 0 |  | Item MRP | Item MRP | Item MRP | Item MRP |  | Item MRP |  |  | Item MRP |  |  |  |  |
| Balance3 |  | Sale Price | 0 | 0 | 0 | Sale Price | 0 |  | 0 | Sale Price | 0 |  | 0 | Sale Price |  | 0 | Sale Price |  | 0 | 0 | 0 | 0 | 0 | 0 | Sale Price | Sale Price | Sale Price | Sale Price | 0 | Sale Price |  | 0 | Sale Price |  |  |  |  |
| ItemSrNo |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| MfgDate |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| TranType |  |  |  |  |  |  |  | Transaction Type |  |  |  | Transaction Type |  |  | Transaction Type |  |  | Transaction Type |  |  |  |  |  |  |  |  |  |  |  |  | Transaction Type |  |  | Transaction Type |  |  |  |
| CM1 |  |  | Material Centre | Material Centre |  |  |  | Material Centre |  |  |  | Material Centre |  |  | Material Centre |  |  | Material Centre |  |  |  |  |  |  |  |  |  |  |  |  | Material Centre |  |  | Material Centre | Material Centre | Material Centre | Material Centre |
| ApprovalStatus | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved | 1= Approved  0 = Approval Not Required 2 = Un approved |
| NewRefAmt | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount | New Reference Amount |  |  |  |
| Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration | Reference Narration |  |  |  |
| BranchCode | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) | Branch Code (if created from asnyBranch) |  |  |  |
| CM2 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | Executive Code |
| PackingUnitType |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| SmallUnit |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| D2 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| MRPDU |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| SalesPriceDU |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

## Tran4

| col0 | col1 |
|---|---|
|  |  |
|  | Tran4 Entity Mapping |
|  |  |
|  Fields |  ITEM_MAST  |
|  |  |
| SrNo | SrNo |
| MasterCode1 | ItemCode |
| MasterCode2 | MCCode |
| D1 | OpStockMainUnit |
| D2 | OpStockAltUnit |
| D3 | OpAmount |
| BranchCode | Branch Code |
| RecType | Rec Type  |
| D4 | Op Stock Main Unit |
| D5 | Op. Stock in Packing Unit |

## Tran5

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Tran5 Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Sales | Purchase | Sales Return | Purchase Return | Payment | Receipt | Journal | Debit Note | Credit Note | Material Issue | Material Receipt | Stock Transfer |
|  |  |  |  |  |  |  |  |  |  |  |  |  |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VChCode | VChCode | VChCode |
| MasterCode1 | CCCode | CCCode | CCCode | CCCode | CCCode | CCCode | CCCode | CCCode | CCCode | CCCode | CCCode | CCCode |
| MasterCode2 | AccCode | AccCode | AccCode | AccCode | AccCode | AccCode | AccCode | AccCode | AccCode | 0 | 0 | 0 |
| SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo | SrNo |
| VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType | VchType |
| Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date | Date |
| VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo | VchNo |
| VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode |
| Value1 | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur | AmtMainCur |
| Value2 |  |  |  |  |  |  |  |  |  |  |  |  |
| Balance1 |  |  |  |  |  |  | !Value1 +CC Opn. Bal | !Value1 +CC Opn. Bal | !Value1 +CC Opn. Bal | !Value1 +CC Opn. Bal | !Value1 +CC Opn. Bal | !Value1 +CC Opn. Bal |
| Balance2 |  |  |  |  |  |  |  |  |  |  |  |  |
| TranType | TranType | TranType | TranType | TranType | TranType | TranType | TranType |  |  |  |  |  |
| ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar | ShortNar |
| Tracking Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status | Tracking No Status |
| Tracking No | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number | Tracking Number |

## Tran6

| col0 |
|---|
|  |
| Tran6 Entity Mapping |
|  |
|  Fields |
|  |
| SrNo |
| MasterCode1 |
| MasterCode2 |
| StockType |
| D1 |
| D2 |
| D3 |

## Tran7

| col0 | col1 |
|---|---|
|  |  |
|  |  |
| Fields |  |
|  |  |
| MasterCode | MasterCode |

## Tran8

| col0 | col1 | col2 |
|---|---|---|
|  |  |  |
|  | Tran8 Entity Mapping |  |
|  |  |  |
|  Fields | Forms Received | Forms Issued |
|  |  |  |
| VchCode | VchCode | VchCode |
| VchType | VchType | VchType |
| Date | Date | Date |
| FormRecDate |  | FormRecDate |
| FormNo | FormNo | FormNo |
| PartyCode | PartyCode | PartyCode |
| FormCode | FormCode | FormCode |
| Stamp | Stamp | Stamp |
| Nar1 | Nar1 | Nar1 |
| AutoVchNo | AutoVchNo | AutoVchNo |
| CREATEDBY | CREATEDBY | CREATEDBY |
| CreationTime | CreationTime | CreationTime |
| Athourised By | Athourised By | Athourised By |
| Athourisation Time | Athourisation Time | Athourisation Time |
| MODIFIEDBY | Modified by | Modified by |
| ModificationTime | ModificationTime | ModificationTime |
| StateCode | StateCode |  |
| Series | Form Series |  |
| Issuing Office | Form Issuing Office |  |

## Tran9

| col0 | col1 | col2 |
|---|---|---|
|  |  |  |
|  | Tran9 Entity Mapping |  |
|  |  |  |
|  Fields | Forms Received | Forms Issued |
|  |  |  |
| VchCode | Vch Code | Vch Code |
| PartyCode | Party Code | Party Code |
| FormCode | Form Code | Form Code |
| SrNo | Serial number | Serial number |
| VchType | VchType | VchType |
| Date | Date | Date |
| FormNo | Form Number | Form number |
| BillCode | Bill Code | Bill Code |
| Amount | Amount | Amount |

## Tran10

| col0 | col1 | col2 | col3 |
|---|---|---|---|
|  |  |  |  |
|  | Tran10 Entity Mapping |  |  |
|  |  |  |  |
| Fields | Item Quantity Discount Structure | Party Item Price structure | Target |
|  |  |  |  |
| RecType | RecType | RecType |  |
| VchType | VchType | VchType |  |
| I1 | Discount basis |  |  |
| SrNo | SrNo. |  |  |
| MasterCode1 | Party Code | Party Code |  |
| MasterCode2 |  | ItemCode |  |
| D1 | Discount Percentage | Discount Percentage |  |
| D2 | Price | Price |  |
| D3 | Absolute discount amount | Discount amount |  |
| D4 | Qty | MRP |  |
| C1 | Compound Discount Percentage | Compound Discount Percentage |  |
| I2 |  |  | Target Mode |
| I3 |  |  | No. of Targets |
| I4 |  |  | Type of Incentive |
| D5 |  |  | Incentiv 2 |
| D6 |  |  | Incentive 3 |
| D8 | Price of Dual Unit |  |  |
| C2 | Compound Markup |  |  |
| C3 |  |  |  |
| C4 |  |  |  |
| Date | Date |  |  |
| MasterCode3 | Branch Code |  |  |
| B1 |  |  |  |
| B2 |  |  |  |
| B3 |  |  |  |

## Tran11

| col0 | col1 | col2 | col3 |
|---|---|---|---|
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
| Fields | CALL ALLOCATION | CALL REPORT | CALL RECEIPT |
|  |  |  |  |
| RecType | Rectype |  |  |
| TranType | Trantype Constant |  |  |
| VchCode | Vchcode |  |  |
| MasterCode1 | Executive Code |  | Contact Code |
| MasterCode2 | Next Action Code | Next Action Code | Next Action Code |
| SrNo | Sr No | Sr No | Sr No |
| VchType | Vchtype | Vchtype | Vchtype |
| Date | Date | Date | Date |
| VchNo | VchNo | VchNo | VchNo |
| VchSeriesCode | VchSeriesCode | VchSeriesCode | VchSeriesCode |
| ShortNar | Additional Field | Additional Field | Additional Field |
| I1 | Call Status | Call Status | Call Status |
| B1 |  |  |  |
| CM1 |  | Close Status code | Close Status code |
| CM2 |  |  | Source Code |
| CM3 | Executive Code |  | Executive Code |
| CM4 | Open Sub Status Code | Open Sub Status Code | Open Sub Status Code |
| CM5 |  |  | Call Category Code |
| CM6 |  |  |  |
| CM7 |  |  |  |
| CM8 |  |  |  |
| Date | Vch Date | Vch Date | Vch Date |
| Date1 | Vch Time | Vch Time | Vch Time |
| Date2 | Next Action Date | Next Action Date | Next Action Date |
| Date3 | Next Action Time | Next Action Time | Next Action Time |
| Date4 |  | Reaching Time |  |
| Date5 |  | Leaving Time |  |
| C1 | Call No | Call No | Call No |
| M1 | Call Remarks | Call Remarks | Call Remarks |
| M2 | Suggested Action Remarks | Suggested Action Remarks | Suggested Action Remarks |
| C2 | Call Closing Remarks | Call Closing Remarks | Call Closing Remarks |

## VATInfo

| col0 | col1 |
|---|---|
|  |  |
|  | VATInfo Entity Mapping |
|  |  |
|  Fields | VAT Journal |
|  |  |
| Date | Date |
| Amount | Amount |
| RecType | RecType |
| Type | Type |
| SrNo. | Sr.No. |
| Description | Description |
| VchCode | Code of the Journal, Payment/Receipt voucher |
| ChallanNo | challan number |
| ChallanDate | challan date |
| ChequeNo | cheque number |
| ChequeDate | cheque date |
| Bank | Bank name |
| Interest | Rate of interest |
| Penalty | Penalty amount |
| BankName | Bank Name |
| BankCode | Bank Code |
| BankAcType | Bank account type |
| BankAcNo | Bank account number |
| SurchargeAmt | Surcharge Amt |
| STPTCode | Sale/Purc Type |
| SaleAMT | Sale Amt |
| TaxPercent | Tax Percent |
| SurchargePercent | Schg Percent |
| TaxType | Taxtype |
| SPNature |  |

## VchOtherInfo

| col0 | col1 | col2 | col3 | col4 | col5 | col6 | col7 | col8 | col9 | col10 | col11 | col12 | col13 | col14 | col15 | col16 | col17 | col18 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | VchOtherInfo Entity Mapping |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  Fields | Sales Order | Purchase Order | Sales | Purchase | Sales Return | Purchase Return | Payment | Receipt | Journal | Contra | Debit Note | Credit Note | Stock Journal | Stock Transfer | Production | Unassemble | Mat. Iss. | Mat. Rec. |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode | VchCode |
| OF1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 | optional field1 |
| OF2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 | optional field2 |
| OF3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 | optional field3 |
| OF4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 | optional field4 |
| OF5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 | optional field5 |
| OF6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 | optional field6 |
| OF7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 | optional field7 |
| OF8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 | optional field8 |
| OF9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 | optional field9 |
| OF10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 | optional field10 |
| Transport |  |  | Transport | Transport | Transport | Transport |  |  |  |  |  |  |  | Transport |  |  | Transport | Transport |
| Station |  |  | Station | Station | Station | Station |  |  |  |  |  |  |  | Station |  |  | Station | Station |
| GrNo |  |  | GrNo | GrNo | GrNo | GrNo |  |  |  |  |  |  |  | GrNo |  |  | GrNo | GrNo |
| VehicleNo |  |  | VehicleNo | VehicleNo | VehicleNo | VehicleNo |  |  |  |  |  |  |  | VehicleNo |  |  | VehicleNo | VehicleNo |
| ItemDesc |  |  | ItemDesc | ItemDesc | ItemDesc  | ItemDesc  |  |  |  |  |  |  |  |  |  |  |  |  |
| Form31No |  |  | O.C. Stamp No. | Form31No | Form31No |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Form31IssuedOn |  |  |  | Form31IssuedOn |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| TotalQty |  | TotalQty | TotalQty | TotalQty | TotalQty | TotalQty |  |  |  |  |  |  |  | TotalQty |  |  | TotalQty | TotalQty |
| PurchaseBillNo |  |  |  | PurchaseBillNo |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| PurchaseBillDate |  |  |  | PurchaseBillDate |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 | Narration1 |
| Narration2 |  |  |  |  |  |  | Narration2 | Narration2 | Narration2 | Narration2 | Narration2 | Narration2 |  |  |  |  |  |  |
| InvoicePrepTime |  |  | InvoicePrepTime | InvoicePrepTime | InvoicePrepTime | InvoicePrepTime |  |  |  |  |  |  |  |  |  |  |  |  |
| GoodsRemovalTime |  |  | GoodsRemovalTime | GoodsRemovalTime | GoodsRemovalTime | GoodsRemovalTime |  |  |  |  |  |  |  |  |  |  |  |  |
| GrDate | GrDate | GrDate | GrDate | GrDate | GrDate | GrDate |  |  |  |  |  |  |  |  |  |  | GrDate | GrDate |
| VchNotes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes | Voucher Notes |
| I1 |  |  |  | Purpose |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| OF11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 | Value Optional Field 11 |
| OF12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 | Value Optional Field 12 |
| OF13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 | Value Optional Field 13 |
| OF14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 | Value Optional Field 14 |
| OF15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 | Value Optional Field 15 |
| OF16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 | Value Optional Field 16 |
| OF17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 | Value Optional Field 17 |
| OF18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 | Value Optional Field 18 |
| OF19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 | Value Optional Field 19 |
| OF20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 | Value Optional Field 20 |

## VchVATSum

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  |  |  |  |  |
|  | VchVATSum Entity Mapping |  |  |  |
|  |  |  |  |  |
|  Fields | Sales | Purchase | Sale Return | Purchase Return |
| VchCode | Voucher code | Voucher code | Voucher code | Voucher code |
| SaleAmt | Taxable amount | Taxable amount | Taxable amount | Taxable amount |
| TaxRate | Rate of VAT | Rate of VAT | Rate of VAT | Rate of VAT |
| TaxAmt | VAT amount | VAT amount | VAT amount | VAT amount |
| SurchargeRate | Rate of Surcharge | Rate of Surcharge | Rate of Surcharge | Rate of Surcharge |
| SurchargeAmt | Surcharge amount | Surcharge amount | Surcharge amount | Surcharge amount |
| TaxType | Type of Tax | Type of Tax | Type of Tax | Type of Tax |
| ActualSaleAmt | Vch Amt excluding BS amount | Vch Amt excluding BS amount | Vch Amt excluding BS amount | Vch Amt excluding BS amount |
| TaxOnMRP | Tax on MRP - Y/N | Tax on MRP - Y/N | Tax on MRP - Y/N | Tax on MRP - Y/N |

## VchVATSumItemwise

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  |  |  |  |  |
|  | VchVATSumItemwise Entity Mapping |  |  |  |
|  |  |  |  |  |
|  Fields | Sales | Purchase | Sale Return | Purchase Return |
| ItemSrNo | Item Serial number | Item Serial number | Item Serial number | Item Serial number |
| ItemCode | Item Code | Item Code | Item Code | Item Code |
| VchCode | Voucher Code | Voucher Code | Voucher Code | Voucher Code |
| SaleAmt | Sale amount | Sale amount | Sale amount | Sale amount |
| TaxRate | Rate of tax | Rate of tax | Rate of tax | Rate of tax |
| TaxAmt | Tax amount | Tax amount | Tax amount | Tax amount |
| SurchargeAmt | Amount of Surcharge | Amount of Surcharge | Amount of Surcharge | Amount of Surcharge |
| SurchargeRate | Rate of Surcharge | Rate of Surcharge | Rate of Surcharge | Rate of Surcharge |
| TaxType | Type of Tax | Type of Tax | Type of Tax | Type of Tax |
| ActualSaleAmt | Actual Sale amount  | Actual Sale amount  | Actual Sale amount  | Actual Sale amount  |
| TaxOnMRP | Tax on MRP | Tax on MRP | Tax on MRP | Tax on MRP |

## VchTemplate

| col0 | col1 |
|---|---|
|  |  |
|  | VchTemplate Entity Mapping |
|  |  |
|  Fields | Set Voucher As Template Utility |
| VchCode | Voucher Code |
| VchType | Voucher Type |
| TemplateName | Name of the Template |

## VchTempTagging

| col0 | col1 |
|---|---|
|  |  |
|  | VchTempTagging Entity Mapping |
|  |  |
|  Fields | Value |
| MasterCode | MasterCode |
| VchType | VchType |
| TemplateVchCode | VchCode of the template |
| B1 | Whether Header Entries to be updated |
| B2 | Whether Item Entries to be updated |
| B3 | Whether BS Entries to be updated |
| B4 |  |
| B5 |  |
| I1 |  |
| I2 |  |
| MasterType | Master Type |

## VchGSTSumItemWise

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  | VchGSTSumItemwise Entity Mapping |  |  |  |
|  |  |  |  |  |
|  Fields | Sales | Purchase | Sale Return | Purchase Return |
|  |  |  |  |  |
| VchCode | Voucher Code | Voucher Code | Voucher Code | Voucher Code |
| ItemCode | Item Code | Item Code | Item Code | Item Code |
| ItemSrNo | Item Serial number | Item Serial number | Item Serial number | Item Serial number |
| PartyCode | PartyCode | PartyCode | PartyCode | PartyCode |
| TaxCatCode | TaxCategory Code | TaxCategory Code | TaxCategory Code | TaxCategory Code |
| STPTCode | Sale Type Code | Purchase Type Code | Sale Type Code | Purchase Type Code |
| HSNCode | Item HSN Code | Item HSN Code | Item HSN Code | Item HSN Code |
| SENo | Item SENo | Item SENo | Item SENo | Item SENo |
| PartyStateTinDigit | Party State TINCode | Party State TINCode | Party State TINCode | Party State TINCode |
| PartyStateCode | Party State Code | Party State Code | Party State Code | Party State Code |
| BDStateTinDigit | Billing State Tin Digit | Billing State Tin Digit | Billing State Tin Digit | Billing State Tin Digit |
| BDStateCode | Billing State Code | Billing State Code | Billing State Code | Billing State Code |
| TaxableAmt | Taxable Amt | Taxable Amt | Taxable Amt | Taxable Amt |
| TaxRate | CGST/IGST TaxRate | CGST/IGST TaxRate | CGST/IGST TaxRate | CGST/IGST TaxRate |
| TaxAmt | CGST/IGST TaxAmt | CGST/IGST TaxAmt | CGST/IGST TaxAmt | CGST/IGST TaxAmt |
| TaxRate1 | SGST Taxrate | SGST Taxrate | SGST Taxrate | SGST Taxrate |
| TaxAmt1 | SGST TaxAmt | SGST TaxAmt | SGST TaxAmt | SGST TaxAmt |
| SurchargeAmt | Amount of Surcharge | Amount of Surcharge | Amount of Surcharge | Amount of Surcharge |
| SurchargeRate | Rate of Surcharge | Rate of Surcharge | Rate of Surcharge | Rate of Surcharge |
| LocType | Local/ Central | Local/ Central | Local/ Central | Local/ Central |
| ZeroTaxType | Type of Tax Exempt=0 Taxfree=6  | Type of Tax Exempt=0 Taxfree=6  | Type of Tax Exempt=0 Taxfree=6  | Type of Tax Exempt=0 Taxfree=6  |
| ActualSaleAmt | Actual Sale amount  | Actual Sale amount  | Actual Sale amount  | Actual Sale amount  |
| TaxOnMRP | Tax on MRP | Tax on MRP | Tax on MRP | Tax on MRP |

## GSTInfo

| col0 | col1 |
|---|---|
|  | GSTInfo Entity Mapping |
|  |  |
|  Fields | Journal / Payment Voucher |
|  |  |
| Date | Date |
| Amount | Amount |
| RecType | RecType |
| Type | Type |
| SrNo | Sr.No. |
| Description | Description |
| VchCode | Code of the Journal, Payment voucher |
| ChallanNo | challan number |
| ChallanDate | challan date |
| ChequeNo | cheque number |
| ChequeDate | cheque date |
| BankName | Bank name |
| BankCode | Bank Code |
| Interest | Interest Amt |
| Penalty | Penalty amount |
| BankAcType | Bank Ac Type |
| BankAcNo | Bank Ac No |
| CGSTPercent |  |
| SGSTPercent |  |
| IGSTPercent |  |
| CessPercent |  |
| CGSTAmt | CGST Amt |
| SGSTAmt | SGST Amt |
| IGSTAmt | IGST Amt |
| CessAmt | Cess Amt |
