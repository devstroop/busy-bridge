# BUSY function reference (generated)

<!-- GENERATED FILE â€” do not edit. Regenerate with:
     powershell -File scripts/docs/generate-function-reference.ps1 -->

Generated from the live type library of BUSY Rel 14 on 2026-10-08
via `busy-bridge surface`. This replaces the 2017-era *BUSY Functions.docx*:
every signature below is exactly what the installed BUSY exposes today.

## Index (16 classes, 4496 members)

| Class | Members |
|---|---|
| [Busy2L21.CFixedInterface](#busy2l21-cfixedinterface) | 277 |
| [Busy2L21.CFixedInterface1](#busy2l21-cfixedinterface1) | 622 |
| [Busy2L21.CMasterServices](#busy2l21-cmasterservices) | 541 |
| [Busy2L21.CTranServices](#busy2l21-ctranservices) | 414 |
| [Busy2L21.COtherServices](#busy2l21-cotherservices) | 1221 |
| [Busy2L21.COtherServices1](#busy2l21-cotherservices1) | 764 |
| [Busy2L21.CBCServices](#busy2l21-cbcservices) | 35 |
| [Busy2L21.CIBCServices](#busy2l21-cibcservices) | 11 |
| [Busy2L21.CUMSServices](#busy2l21-cumsservices) | 7 |
| [Busy2L21.CVATServices](#busy2l21-cvatservices) | 7 |
| [Busy2LA21.CServices_2LA](#busy2la21-cservices-2la) | 11 |
| [Busy2LB21.CServices_2LB](#busy2lb21-cservices-2lb) | 8 |
| [Busy2LZ21.CADOServices](#busy2lz21-cadoservices) | 44 |
| [BusyExt21.CMasterServices](#busyext21-cmasterservices) | 81 |
| [BusyExt21.CTranServices](#busyext21-ctranservices) | 78 |
| [BusyExt21.COtherServices](#busyext21-cotherservices) | 375 |

## Busy2L21.CFixedInterface

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `FlushCol` | method | p_Col | 1 | 0 |
| `GetTaxableAndTaxAmtForUnApprovedVchInGSTIndia` | method | p_udtVchData, p_STPTMast, p_TaxableAmt, p_TotalTaxAmt, p_TaxAmt, p_TaxAmt1, p_CessAmt, p_ACessAmt, p_StateCess | 9 | 0 |
| `GetTaxableAndTaxAmtForUnApprovedVchInGSTIndia1` | method | p_Vchcode, p_TaxableAmt, p_TotalTaxAmt, p_TaxAmt, p_TaxAmt1, p_CessAmt, p_ACessAmt, p_StateCess, p_STPTType | 9 | 0 |
| `RecordExist` | method | p_Qry | 1 | 0 |
| `GetRecordset` | method | p_StrQry | 1 | 0 |
| `GetRecordsetFromCompanyDB` | method | p_StrQry | 1 | 0 |
| `GetRecordsetValue` | method | p_StrQry, p_RecordExist | 2 | 0 |
| `GetRecordsetValuesConcatenated` | method | p_StrQry, p_RowNo, p_colNo, p_RowSeprator, p_ColSeprator | 5 | 0 |
| `GetRecordsetFromPrevFY` | method | p_StrQry | 1 | 0 |
| `GetRecordsetFromBusyScreenReport` | method | p_ProjName, p_CSRName, p_RepOptXMLStr | 3 | 0 |
| `GetRecordsetFromScreenReport` | method | p_CSRName, p_RepOptObj | 2 | 0 |
| `GetBoolQryStr` | method | p_Bool | 1 | 0 |
| `GetDateQryStr` | method | p_Date | 1 | 0 |
| `GetFldVal` | method | p_Fld | 1 | 0 |
| `BlankStr` | method | p_str | 1 | 0 |
| `GetTextQryStr` | method | p_str | 1 | 0 |
| `IfZero` | method | p_Num | 1 | 0 |
| `IfNotZero` | method | p_Num | 1 | 0 |
| `GetDateRangeStr` | method | p_StartDate, p_EndDate | 2 | 0 |
| `GetDateRangeQryStr` | method | p_StartDate, p_EndDate | 2 | 0 |
| `FormatNum` | method | p_Num, p_MaxChar, p_Decimals, p_ShowZeroAsBlank | 4 | 0 |
| `FormatNumWithDrCr` | method | p_Num, p_MaxChar, p_Decimals, p_ShowZeroAsBlank | 4 | 0 |
| `PadCentre` | method | p_str, p_MaxChar | 2 | 0 |
| `PadLeft` | method | p_str, p_MaxChar | 2 | 0 |
| `PadRight` | method | p_str, p_MaxChar | 2 | 0 |
| `FormatDate` | method | p_Date | 1 | 0 |
| `FormatDateIn8Char` | method | p_Date | 1 | 0 |
| `ConvertDateRoman2Nepali` | method | p_RomanDate | 1 | 0 |
| `ConvertDateNepali2Roman` | method | p_NepaliDate | 1 | 0 |
| `MakeAddressIn2Lines` | method | p_Add1, p_Add2, p_Add3, p_Add4, p_RetAdd1, p_RetAdd2 | 6 | 0 |
| `MasterCode2Name` | method | p_Code | 1 | 0 |
| `MasterName2Code` | method | p_MasterName, p_Mastertype | 2 | 0 |
| `MasterCode2Alias` | method | p_Code, p_Mastertype | 2 | 0 |
| `MasterAlias2Code` | method | p_MasterName, p_Mastertype | 2 | 0 |
| `GetAccOpBal` | method | p_MasterCode, p_Date | 2 | 0 |
| `GetAccClosingBal` | method | p_MasterCode, p_Date, p_IncludePDC | 3 | 0 |
| `GetAccClosingBalForBranch` | method | p_MasterCode, p_BranchCode, p_Date | 3 | 0 |
| `GetAccOpBalsForBranch` | method | p_MasterCode, p_BranchCode, p_Date | 3 | 0 |
| `CompareStr` | method | p_Str1, p_Str2, p_CaseSensitive | 3 | 0 |
| `BreakStr` | method | p_str, p_MaxChar, p_ConsiderLineFeed | 3 | 0 |
| `VchType2FullName` | method | p_VchType, p_VchSeriesCode, p_LastSavedCaption | 3 | 2 |
| `VchType2ShortName` | method | p_VchType, p_VchSeriesCode, p_LoadSavedCaptionFlag | 3 | 0 |
| `MastCode2NameQryStr` | method | p_MastCodeStr | 1 | 0 |
| `ReplaceItemInCol` | method | p_Col, p_Item, p_Position | 3 | 0 |
| `Negative` | method | p_Num | 1 | 0 |
| `Text2Dbl` | method | p_Text | 1 | 0 |
| `Text2Date` | method | p_Date, p_DateType | 2 | 0 |
| `Num2Words` | method | p_Num | 1 | 0 |
| `EqualNums` | method | p_Num1, p_Num2 | 2 | 0 |
| `IfChildDirect` | method | p_MastCode, p_ParentGrpCode | 2 | 0 |
| `IfChild` | method | p_MastCode, p_ParentGrpCode | 2 | 0 |
| `GetMastersCol` | method | p_Mastertype | 1 | 0 |
| `GetVSGrpColForCurUser` | method |  | 0 | 0 |
| `GetVoucherSeriesGrpQry` | method | p_VchSeriesGrpCode, p_VchStr | 2 | 0 |
| `Series2MasterName` | method | p_VchType, p_SeriesName | 2 | 0 |
| `GetItemMCOpBals` | method | p_ItemCode, p_MCCode, p_Date, p_BalAltUnit | 4 | 0 |
| `GenerateEInvoice4Vch_V2` | method | p_Vchcode, p_Provider, p_ErrMsg, p_DataPath, p_ServerName, p_UserName, p_Pwd, p_BLSDate | 8 | 0 |
| `PrintEInvoice4Vch_V2` | method | p_Vchcode, p_Provider, p_ErrMsg, p_DataPath, p_ServerName, p_UserName, p_Pwd, p_BLSDate | 8 | 0 |
| `GenerateEWayBill4Vch_V2` | method | p_Vchcode, p_Provider, p_ErrMsg, p_DataPath, p_ServerName, p_UserName, p_Pwd, p_BLSDate | 8 | 0 |
| `PrintEWayBill4Vch_V2` | method | p_Vchcode, p_Provider, p_ErrMsg, p_DataPath, p_ServerName, p_UserName, p_Pwd, p_BLSDate | 8 | 0 |
| `GenerateEInvQRCodeFile` | method | p_Vchcode, p_FilePath, p_ErrMsg | 3 | 1 |
| `CalculatePinToPinDistance_V2` | method | p_SourcePINCode, p_DestinationPinCode, p_Distance, p_Provider, p_ErrMsg, p_DataPath, p_ServerName, p_UserName, p_Pwd, p_BLSDate | 10 | 0 |
| `GetItemMCClosingBals` | method | p_ItemCode, p_MCCode, p_Date, p_BalAltUnit, p_Vchcode | 5 | 0 |
| `GetItemMainUnitName` | method | p_ItemName | 1 | 0 |
| `GetItemAltUnitName` | method | p_Item | 1 | 0 |
| `GetEMailIDofMasterFromCode` | method | p_Code | 1 | 0 |
| `GetMobileofMasterFromCode` | method | p_Code, p_AllMobNumbers | 2 | 0 |
| `GetItemOpBals` | method | p_ItemCode, p_Date, p_BalAlt | 3 | 0 |
| `GetItemClosingBals` | method | p_ItemCode, p_Date, p_BalAlt | 3 | 0 |
| `GetItemConBal` | method | p_ItemCode, p_MCCodes, p_Date, p_BalAlt, p_BalAmt, p_OpBal, p_ShowVal, p_SVM, p_SelfValPrice | 9 | 0 |
| `GetItemMCPrice` | method | p_ItemCode, p_MCCode, p_Date, p_SVM, p_SVP, p_MainQtyForLIFOFIFO | 6 | 0 |
| `GetItemMCPriceForQty` | method | p_ItemCode, p_MCCode, p_Date, p_SVM, p_BalQty, p_MainQtyForLIFOFIFO | 6 | 0 |
| `GetItemMCLIFOPriceForQty` | method | p_ItemCode, p_MCCode, p_Date, p_BalQty, p_QtyReq, p_Vchcode | 6 | 1 |
| `GetItemMCFIFOPriceForQty` | method | p_ItemCode, p_MCCode, p_Date, p_BalQty, p_QtyReq | 5 | 0 |
| `GetOpBalsFromMCOpStock` | method | p_ItemCode, p_MCCode, p_BalAlt, p_BalAmt | 4 | 0 |
| `GetFinMonthStartDateEndDate` | method | p_ActualMonth, p_CurFY, p_StartDate, p_EndDate | 4 | 0 |
| `Actual2FinMonth` | method | p_Month, p_BegFY, p_DateType | 3 | 0 |
| `GetCurrentUserName` | method |  | 0 | 0 |
| `GetCurrentUserBranchCode` | method |  | 0 | 0 |
| `GetCurrentUserVchSeriesGrpCode` | method |  | 0 | 0 |
| `GetCurrentUserMasterSeriesGrpCode` | method |  | 0 | 0 |
| `GetAllChildQryStr` | method | p_GrpCode, p_ChildMasterType, p_DirectChildOnly | 3 | 0 |
| `GetAccGrpClosingBalForDate` | method | p_GrpCode, p_Date | 2 | 0 |
| `GetAccGrpClosingBalForMonth` | method | p_GrpCode, p_FinMonth | 2 | 0 |
| `GetAccGrpTranAmtForVchType` | method | p_GrpCode, p_VchType, p_StartDate, p_EndDate, p_DirectChildOnly | 5 | 0 |
| `GetAccTranAmtForVchType` | method | p_AccCode, p_VchType, p_StartDate, p_EndDate | 4 | 0 |
| `VchCodeExist` | method | p_Vchcode | 1 | 0 |
| `GetPDCType2Str` | method | p_Type | 1 | 0 |
| `AskYesNo` | method | p_Msg, p_DefaultEscValue, p_DefaultValue, p_Title, p_PicID, p_SmallMsg, p_LargeMsg | 7 | 0 |
| `GetOption2` | method | p_Msg, p_Option1, p_Option2, p_Title, p_DefaultValue | 5 | 0 |
| `GetOption3` | method | p_Msg, p_Option1, p_Option2, p_Option3, p_Title, p_DefaultValue | 6 | 0 |
| `GetOptionsWithMasterControlCheck` | method | p_Msg, p_OptionsCol, p_Title | 3 | 0 |
| `GetOptions` | method | p_Msg, p_OptionsCol, p_Title | 3 | 0 |
| `GetOptionsGST` | method | p_RepID, p_Msg, p_OptionsCol, p_Title | 4 | 0 |
| `ShowMsg` | method | p_Msg, p_Title, p_BigMsg | 3 | 1 |
| `ShowSorryMsg` | method | p_Msg, p_Title | 2 | 0 |
| `ShowHappyMsg` | method | p_Msg, p_Title | 2 | 0 |
| `FieldInvalidMsg` | method | p_Msg, p_Title | 2 | 0 |
| `WarningMsg` | method | p_Msg, p_Title | 2 | 0 |
| `FieldInvalidMsgForCustomValidation` | method | p_Msg, p_Title | 2 | 0 |
| `GetCollectionObj` | method |  | 0 | 0 |
| `AddItemInCol` | method | p_Col, p_Item | 2 | 0 |
| `AddItemInColWithKey` | method | p_Col, p_Item, p_key | 3 | 0 |
| `FindItemKeyInLongCol` | method | p_ItemKey, p_Col | 2 | 0 |
| `GetItemFromCol` | method | p_Col, p_Pos | 2 | 0 |
| `GetItemFromColForObjectRetType` | method | p_Col, p_Pos | 2 | 0 |
| `ShowOnEnterChs` | method | p_Chs, p_Options | 2 | 0 |
| `GetAgeingSlabs` | method | p_AgeingType | 1 | 0 |
| `GetRefsBegDate` | method | p_RecType | 1 | 0 |
| `GetPendingSOPO` | method | p_ItemCode, p_MCCode, p_SOQty, p_POQty, p_SOAltQty, p_POAltQty, p_MCMastType, p_Date | 8 | 0 |
| `GetPIRPrice` | method | p_VchType, p_ItemCode, p_IgrpCode, p_PartyCode, p_PartyGrpCode, p_Price, p_DiscPercent, p_DiscAmt, p_MRP, p_CompoundDisc, p_Date | 11 | 0 |
| `GetSimpleDiscFromCompoundDisc` | method | p_CompoundDisc, p_DiscountBasis | 2 | 0 |
| `ExecuteQuery` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 1 |
| `ExecuteQueryInDB` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `ExecuteQueryInADOForSQL` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 1 |
| `GetProperItemUnitName` | method | p_ItemCode, p_IUT | 2 | 0 |
| `Bool2IntQry` | method | p_Bool | 1 | 0 |
| `GenQryInStrFromCol` | method | p_Col | 1 | 0 |
| `GetItemOpBalForTaggedMC` | method | p_ItemCode, p_MCCodes, p_Date, p_AltBal | 4 | 0 |
| `IfSuperUser` | method | p_Name | 1 | 0 |
| `GetAllMC` | method | p_GrpCode, p_BookStockOnly, p_MSGrpCode, p_BranchCode | 4 | 2 |
| `GetItemValue` | method | p_ItemCode, p_Date, p_MCCode, p_OpTrial, p_SVP, p_SVM, p_BookStockOnly, p_MainQty, p_AltQty, p_MCCodes | 10 | 1 |
| `DivideNum` | method | p_Num1, p_Num2, p_Decimal | 3 | 0 |
| `FindItemInCol` | method | p_Item, p_Col | 2 | 0 |
| `CallFunction` | method | p_ObjectName, p_FunctionName, p_ParamArr | 3 | 0 |
| `CallFunctionForObjectRetType` | method | p_ObjectName, p_FunctionName, p_ParamArr | 3 | 0 |
| `GetCompList` | method | p_DataPath | 1 | 0 |
| `GetCompListForCS` | method | p_ServerName, p_UserName, p_Pwd | 3 | 0 |
| `OpenDB` | method | p_BusyPath, p_DataPath, p_CompCode, p_FY | 4 | 0 |
| `OpenCSDB` | method | p_BusyPath, p_ServerName, p_UserName, p_Pwd, p_CompCode | 5 | 0 |
| `OpenDBForYear` | method | p_BusyPath, p_DataPath, p_CompCode, p_FY | 4 | 0 |
| `OpenCSDBForYear` | method | p_BusyPath, p_ServerName, p_UserName, p_Pwd, p_CompCode, p_FY | 6 | 0 |
| `CloseDB` | method |  | 0 | 0 |
| `GetCCClosingBals` | method | p_MasterCode, p_Date | 2 | 0 |
| `GetCCOpBals` | method | p_MasterCode, p_Date | 2 | 0 |
| `GetSubAccClosingBals` | method | p_MasterCode, p_Date, p_Vchcode | 3 | 1 |
| `GetSubAccOpBals` | method | p_MasterCode, p_Date | 2 | 0 |
| `GetAccSum` | method | p_AccCode, p_StartDate, p_EndDate, p_IfSubLedger, p_BranchCode | 5 | 1 |
| `GetAccSumFromTrans` | method | p_AccCode, p_StartDate, p_EndDate, p_Vchcode | 4 | 0 |
| `GetSubAccSumFromTrans` | method | p_AccCode, p_StartDate, p_EndDate, p_Vchcode | 4 | 1 |
| `GetAllMasterInMSGrp` | method | p_MSCode, p_Mastertype | 2 | 0 |
| `GetActualMasterName` | method | p_NameAlias, p_MastType | 2 | 0 |
| `GetAllChildArr` | method | p_Code, p_ChildType | 2 | 0 |
| `GetAllVchSeriesCodes` | method | p_VchType | 1 | 0 |
| `GetMasterTypeFromCode` | method | p_Code | 1 | 0 |
| `GetMonthClosingBal` | method | p_Code, p_Month, p_BalAlt | 3 | 0 |
| `GetMonthOpeningBal` | method | p_Code, p_Month, p_BalAlt | 3 | 0 |
| `GetOpBalsFromFolio` | method | p_MasterCode, p_BalAlt, p_BalValue | 3 | 0 |
| `GetOpClosingStock` | method | p_StartMonth, p_EndMonth, p_OpStock, p_ClosingStock | 4 | 0 |
| `GetParentGrp` | method | p_Code | 1 | 0 |
| `GetParentMasterType` | method | p_ChildType | 1 | 0 |
| `MasterAlias2CodeIfExist` | method | p_Alias, p_Mastertype | 2 | 0 |
| `MasterAlias2Name` | method | p_Alias, p_Mastertype | 2 | 0 |
| `MasterName2Alias` | method | p_Name, p_Mastertype | 2 | 0 |
| `MasterCodeExist` | method | p_MasterCode | 1 | 0 |
| `MasterNameExist` | method | p_MasterName, p_Mastertype, p_IgnoreAlias | 3 | 1 |
| `TranExistForMaster` | method | p_MasterCode, p_strError | 2 | 0 |
| `AccExistWithBalUnderThis` | method | p_GrpCode, p_Date, p_OpBal | 3 | 0 |
| `AccountingTranExistInTran2` | method | p_RecType, p_StartDate, p_EndDate, p_CheckForUserControl | 4 | 0 |
| `AutoVchNoExist` | method | p_AutoVchNo, p_SeriesCode, p_RenumType, p_Date | 4 | 0 |
| `CalculateTotalVchAmt` | method | p_itemCol, p_BSCol, p_AltCurCode | 3 | 0 |
| `CCTranExist` | method | p_MasterCode, p_StartDate, p_EndDate | 3 | 0 |
| `DualTranExist` | method |  | 0 | 0 |
| `ExciseApplicableInVch` | method | p_Vchcode | 1 | 0 |
| `GetBillRecPayAmt` | method | p_RepDate, p_AmtType, p_EntryStatus, p_PartyCode | 4 | 0 |
| `SaveMasterFromXML` | method | p_Mastertype, p_XMLStr, p_ErrStr, p_Modify, p_MasterCode, p_Source | 6 | 0 |
| `SaveVchFromXML` | method | p_VchType, p_XMLStr, p_ErrStr, p_Modify, p_ModifyKey, p_Vchcode, p_Source, p_CreateIfNotExist | 8 | 0 |
| `DeleteVch` | method | p_VchType, p_VchSeriesName, p_VchDate, p_VchNo, p_ErrStr | 5 | 0 |
| `DeleteVchByCode` | method | p_Vchcode, p_ErrStr | 2 | 0 |
| `DeleteMaster` | method | p_Mastertype, p_MasterName, p_ErrStr | 3 | 0 |
| `DeleteMasterByCode` | method | p_MasterCode, p_ErrStr | 2 | 0 |
| `GetAttachmentPathForEmailQuery` | method | p_RepID, p_Col, p_FilePath | 3 | 0 |
| `GeneratePDFForInvoice` | method | p_Vchcode, p_FilePath, p_FormatName, p_DigitalSignature, p_NoOfCopies | 5 | 0 |
| `GetVchNoFromVchCode` | method | p_Vchcode | 1 | 0 |
| `IfBillByBillApplicableInAccMast` | method | p_AccCode | 1 | 0 |
| `MasterCode2Choice` | method | p_MastCode, p_Choice | 2 | 0 |
| `GetSVMForItem` | method | p_SVM | 1 | 0 |
| `SaveCurrentDB` | method | db1, Con | 2 | 0 |
| `RestoreCurrentDB` | method | db1, Con | 2 | 0 |
| `ChangeDB` | method | p_Year | 1 | 0 |
| `GetPurcBillNoAndDate` | method | p_Vchcode, p_BillNo, p_BillDate | 3 | 0 |
| `ZeroQty` | method | p_MainQty, p_AltQty, p_IUT | 3 | 0 |
| `GenQryInStrForParentGrps` | method | p_GrpCode, p_GrpType | 2 | 0 |
| `GetAccClosingBalFormatted` | method | p_MasterCode, p_Date | 2 | 0 |
| `GetItemClosingBalsFormatted` | method | p_ItemCode, p_Date, p_BalAlt | 3 | 0 |
| `GetBillRecPayAmtFormatted` | method | p_RepDate, p_AmtType, p_EntryStatus, p_PartyCode | 4 | 0 |
| `GetProvider` | method |  | 0 | 0 |
| `GetVSGrpQryStr` | method | p_VchSeriesGrpCode, p_FieldName, p_SkipOperator | 3 | 0 |
| `GetMSGrpQryStr` | method | p_Mastertype, p_MastSeriesGrpCode, p_FieldName | 3 | 0 |
| `GetAccOpBalForCur` | method | p_MasterCode, p_CurCode, p_Date, p_BalBase, p_Vchcode | 5 | 1 |
| `GetItemGrpWiseExciseValueInVch` | method | p_Vchcode, p_MCCode, p_UnitType | 3 | 0 |
| `FindItemKeyInCol` | method | p_ItemKey, p_Col | 2 | 0 |
| `StuffItemInCol` | method | p_Col, p_Item, p_Pos | 3 | 0 |
| `GetBillWiseProfit` | method | p_Vchcode, p_ItemWiseProfitDet, p_TotalSaleAmt, p_TotalCostAmt, p_MCCode, p_VchDate, p_ItemCode, p_SVM, p_ItemSrNo | 9 | 0 |
| `FormatNumForOF` | method | Num, MaxChar, Decimals | 3 | 0 |
| `GetServerInfo` | method | p_ServerName, p_UserName, p_Password | 3 | 0 |
| `GetOptionalFieldQryStr` | method | p_OFMastCode, p_OFNo, p_FldName | 3 | 0 |
| `GetMasterFldName` | method | p_MasterInfoChs | 1 | 0 |
| `GetStr2DateForMastOptField` | method | p_Date | 1 | 0 |
| `GetDate2StrForMastOptField` | method | p_Date | 1 | 0 |
| `ShowScrRep` | method | p_ID | 1 | 0 |
| `ShowCustomRep` | method | p_FormatName | 1 | 0 |
| `PrintDocument` | method | p_Vchcode, p_SendWithoutAsking, p_FormatNo, p_FreezeFormat | 4 | 0 |
| `PrintDocumentWithFormatName` | method | p_Vchcode, p_SendWithoutAsking, p_FormatName, p_FreezeFormat | 4 | 0 |
| `PrintCheque` | method | p_Vchcode | 1 | 0 |
| `PrintVchBarCode` | method | p_Vchcode | 1 | 0 |
| `SendSMSForDoc` | method | p_Vchcode, p_SendWithoutAsking | 2 | 0 |
| `SendEmailForDoc` | method | p_Vchcode, p_SendWithoutAsking | 2 | 0 |
| `AddMaster` | method | p_Mastertype | 1 | 0 |
| `AddVoucher` | method | p_VchType | 1 | 0 |
| `AddVoucherFromPredefinedXML` | method | p_VchType, p_XMLStr, p_ErrStr, p_Source | 4 | 0 |
| `AddMasterFromPredefinedXML` | method | p_Mastertype, p_XMLStr, p_ErrStr | 3 | 0 |
| `ModifyMaster` | method | p_MastCode | 1 | 0 |
| `ModifyVoucher` | method | p_Vchcode | 1 | 0 |
| `ModifySTVoucher` | method | p_Vchcode | 1 | 0 |
| `ModifyVATJVVoucher` | method | p_Month | 1 | 0 |
| `ShowMainMenu` | method |  | 0 | 0 |
| `ShowCustomReportDirect` | method | p_FormatName, p_RepOptObj | 2 | 0 |
| `CallInternalAddOn` | method | p_DllName, p_Col | 2 | 1 |
| `CallInternalAddOnDotNetDll` | method | p_DllName, p_str | 2 | 1 |
| `GetBusyObjects` | method |  | 0 | 0 |
| `GetDongleSrNo` | method |  | 0 | 0 |
| `CheckSecurity` | method | p_Provider, p_ErrMsg, p_DataPath, p_ServerName, p_UserName, p_Pwd, p_BLSDate | 7 | 0 |
| `GetVchXML` | method | p_Vchcode, p_LoadPartial | 2 | 0 |
| `GetSTVchXML` | method | p_Vchcode, p_LoadPartial | 2 | 0 |
| `GetMasterXML` | method | p_MastCode, p_LoadPartial | 2 | 0 |
| `Convert2Date` | method | p_Day, p_Month, p_Year, p_DateType | 4 | 0 |
| `ChangeItemStockForDualUnit` | method | p_ItemCode, p_BalMain, p_BalAlt | 3 | 0 |
| `CheckSmallUnit` | method | p_ItemCode | 1 | 0 |
| `GetQuarterStartDateEndDate` | method | p_QuarterNo, p_CurFY, p_StartDate, p_EndDate | 4 | 0 |
| `UserNameExists` | method | p_Name | 1 | 0 |
| `ValidUserPassword` | method | p_Name, p_Password | 2 | 0 |
| `GetParamAlias` | method | p_ParamNo, p_ParamStr, p_ItemCode | 3 | 0 |
| `IfCashBank` | method | p_Code | 1 | 0 |
| `IfParty` | method | p_Code | 1 | 0 |
| `MasterName2Series` | method | p_SeriesName | 1 | 0 |
| `GetCompConfigXML` | method | p_SkipBranchMastLoading | 1 | 0 |
| `GetCurrentUserXML` | method |  | 0 | 0 |
| `GetMastConfigXML` | method | p_MastType | 1 | 0 |
| `GetVchConfigXML` | method | p_VchSeriesCode | 1 | 0 |
| `GetLastVchDateForVchType` | method | p_VchType | 1 | 0 |
| `GetLastVchDateForVchSriesCode` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `GetLastDateForVchType` | method | p_VchType | 1 | 0 |
| `GetLastDateForVchSries` | method | p_VchSeriesCode | 1 | 0 |
| `GetLastVchDate` | method |  | 0 | 0 |
| `GetAllFinYears` | method |  | 0 | 0 |
| `GetStrFromItemDetColumns` | method | p_Columns | 1 | 0 |
| `AddVchFromXML` | method | p_VchType, p_XMLStr, p_ErrStr, p_ModifyIfExist, p_ModifyKey | 5 | 2 |
| `ModifyVchFromXMLByNo` | method | p_VchType, p_XMLStr, p_ModifyKey, p_ErrStr, p_CreateIfNotExist, p_Vchcode | 6 | 0 |
| `ModifyVchFromXMLByCode` | method | p_VchType, p_Vchcode, p_XMLStr, p_ErrStr, p_CreateIfNotExist, p_Source | 6 | 0 |
| `AddMasterFromXML` | method | p_Mastertype, p_XMLStr, p_ErrStr | 3 | 0 |
| `ModifyMasterFromXMLByCode` | method | p_Mastertype, p_MasterCode, p_XMLStr, p_ErrStr | 4 | 0 |
| `ModifyMasterFromXMLByName` | method | p_Mastertype, p_MasterName, p_XMLStr, p_ErrStr, p_CreateIfNotExist | 5 | 1 |
| `ChangeTaxType` | method |  | 0 | 0 |
| `GetCompoundDiscStrWithoutNotation` | method | p_CompDiscStr | 1 | 0 |
| `GetMCCodesForBranch` | method | p_BranchCode, p_BookStockOnly | 2 | 0 |
| `GetBranchCodeForVSGrp` | method | p_VSGrpCode | 1 | 0 |
| `POSAsPerGSTReporting` | method | p_TinDigit, p_StateName | 2 | 0 |
| `Add2Help2Db` | method | p_SeriesCode, p_FieldType, p_Field | 3 | 0 |
| `SaveSettlementDetForVch` | method | p_Vchcode, p_SettleCol, p_ErrStr | 3 | 0 |
| `RestoreCustomReportFormat` | method | p_FilePath, p_ErrStr, p_OverwritePwd | 3 | 0 |
| `RestoreCustomValidationFormat` | method | p_FilePath, p_ErrStr, p_OverwritePwd | 3 | 0 |
| `CheckCustomReportFormatExists` | method | p_FormatName | 1 | 0 |
| `CheckCustomValidationFormatExists` | method | p_FormatName | 1 | 0 |
| `GetHDSerialNo` | method | p_HDNo | 1 | 0 |
| `GenerateGSTR1eReturnExcel` | method | p_StartDate, p_EndDate, p_SourceTemplateFilePath, p_TargetTemplateFilePath | 4 | 0 |
| `GenerateGSTR2eReturnExcel` | method | p_StartDate, p_EndDate, p_SourceTemplateFilePath, p_TargetTemplateFilePath | 4 | 0 |
| `GenerateGSTR9ReturnRecordset` | method | p_StartDate, p_EndDate | 2 | 0 |
| `CreateVchSeries` | method | p_SeriesName, p_VchType | 2 | 0 |
| `UploadFileInGoogleDrive` | method | p_FilePath, p_ErrMsg, p_Link | 3 | 2 |

## Busy2L21.CFixedInterface1

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `ModifyVoucherByCode` | method | p_Vchcode, p_EventID | 2 | 0 |
| `ShowBusyRepWithRepOptions` | method | p_Options, p_Repopt, p_RepID, p_CSR | 4 | 0 |
| `ShowBusyRepWithRepOptionsFromXML` | method | p_Options, p_RepOptXMLStr, p_RepID, p_CSR | 4 | 0 |
| `ShowOnEnterScrRep` | method | p_RepID, p_Repopt, p_CSR | 3 | 0 |
| `ShowOnEnterScrRepFromXML` | method | p_RepID, p_RepOptXML, p_CSR | 3 | 0 |
| `ShowOnEnterScrRepDirect` | method | p_ID, p_Repopt | 2 | 0 |
| `ShowOnEnterScrRepDirectFromXML` | method | p_ID, p_RepOptXML | 2 | 0 |
| `ShowScrRepWithRepOptions` | method | p_RepID, p_Col | 2 | 0 |
| `ShowPrnRepWithRepOptions` | method | p_RepID, p_Col | 2 | 0 |
| `ChkUserRightsForGSTConfiguration` | method |  | 0 | 0 |
| `ShowBusyPrnRep` | method | p_Options, p_Repopt, p_CPrnRep, p_RepID, p_Scr2Prn, p_PFG | 6 | 2 |
| `ShowBusyScr2PrnRep` | method | p_Options, p_Repopt, p_CPrnRep, p_RepID, p_Scr2Prn, p_PFG | 6 | 2 |
| `AskForLandscape` | method | p_LandScape, p_Title, p_ForcedVal | 3 | 2 |
| `AskForPrintingStyle` | method | p_LandScape, p_PageType, p_Title, p_ForcedVal | 4 | 0 |
| `PrintHeaderScript` | method | p_RepEvents, p_FormatName, p_RepID, p_RepSubId, p_WinFonts | 5 | 0 |
| `AskYesNo` | method | p_Msg, p_DefaultEscValue, p_DefaultValue, p_Title, p_PicID, p_SmallMsg, p_LargeMsg | 7 | 4 |
| `AskOkCancel` | method | p_Msg, p_DefaultEscValue, p_DefaultValue, p_Title, p_PicID | 5 | 2 |
| `WarningYesNo` | method | p_Msg, p_Title | 2 | 1 |
| `ToQuitRec` | method | p_Msg | 1 | 0 |
| `ToQuitMaster` | method |  | 0 | 0 |
| `GetFontsCol` | method |  | 0 | 0 |
| `GetMachineIDNew` | method |  | 0 | 0 |
| `GetMachineIDOld` | method |  | 0 | 0 |
| `GetIPInfoForSoftlock` | method |  | 0 | 0 |
| `GetSigDetCountry` | method |  | 0 | 0 |
| `GetSystemCurrencyInfo` | method | p_CurSym, p_CurStr | 2 | 0 |
| `ConfigSaleTaxRegister` | method | p_Country, p_State | 2 | 0 |
| `ShowHaryanaVATeReturn` | method |  | 0 | 0 |
| `GetOption3BigMsg` | method | p_Msg, p_Option1, p_Option2, p_Option3, p_Title, p_DefaultValue, p_PicID | 7 | 2 |
| `VRCStr2No` | method | p_str | 1 | 0 |
| `VRCNo2Str` | method | p_No | 1 | 0 |
| `FinYrExist` | method | p_Yr | 1 | 0 |
| `ToSaveMaster` | method | p_Msg | 1 | 0 |
| `ToSaveForm` | method | p_Msg | 1 | 0 |
| `GlobalKeyDownHandler` | method | KeyCode, Shift, p_Form, p_MastCol | 4 | 0 |
| `FormKeyDownHandler` | method | KeyCode, Shift, p_Form, p_InputMode | 4 | 0 |
| `FormKeyPressHandler` | method | KeyAscii, p_Form | 2 | 0 |
| `FormCommandClickHandler` | method | p_key, p_Form | 2 | 0 |
| `SKClickHandler` | method | p_Index | 1 | 0 |
| `SetInputForm` | method | p_Form, p_CSType | 2 | 1 |
| `ShowOnEnterChs` | method | p_RepID, p_Options, p_SRInfo, p_Repopt, p_Action, p_Chs, p_ControlCode, p_DeletionType | 8 | 0 |
| `ShowOnEnterChsFromXML` | method | p_RepID, p_Options, p_SrInfoXML, p_RepOptXML, p_Action, p_Chs, p_ControlCode, p_DeletionType | 8 | 0 |
| `GetSelectedMastCol` | method | p_AccType, p_EntryDone, p_RecType | 3 | 0 |
| `ShowSelectedMasters` | method | p_Mastertype, p_Col | 2 | 0 |
| `ShowTariffHeadingDesc` | method |  | 0 | 0 |
| `GetCallOpeningRefs` | method | p_Trantype | 1 | 0 |
| `ModifyItemSNInstallationByCode` | method | p_InstallCode | 1 | 0 |
| `SetDateTypeForNepaliDate` | method |  | 0 | 0 |
| `GetItemBatchesPendingRefs` | method | p_MasterCode1, p_MasterCode2, p_Vchcode, p_Type, p_status, p_IncludePendingOnly, p_Date, p_ShowZeroBatches, p_StartDate | 9 | 0 |
| `ShowSelectedVouchers` | method | p_VchType, p_Col, p_StartDate, p_EndDate | 4 | 0 |
| `ShowSelectedVchsForEWayBill` | method | p_ICol, p_Col, p_StartDate, p_EndDate, p_VchSeriesGrp, p_FilterMC, p_MCCode | 7 | 0 |
| `ShowSelectedVchsForEInvoice` | method | p_ICol, p_OCol | 2 | 0 |
| `CheckIfMainPricesFoundInItemMast` | method | p_CheckMainPrices, p_VchType, p_ItemMastXML | 3 | 0 |
| `PricingType2Str` | method | p_PricingType | 1 | 0 |
| `PricingStr2Type` | method | p_str | 1 | 0 |
| `DiscountMarkupInt2Str` | method | p_Int, p_Mastertype | 2 | 0 |
| `DiscountMarkupStr2Int` | method | p_str, p_Mastertype | 2 | 0 |
| `ModifyMasterByNameDuringDataEntry` | method | p_MastType, p_MasterName, p_Changed, p_NewName | 4 | 0 |
| `GetPricingMode` | method | p_VchType, p_Trantype | 2 | 0 |
| `StatePDCode2Name` | method | p_StateCode, p_CountryCode | 2 | 0 |
| `StateName2PDCode` | method | p_StateName, p_CountryCode | 2 | 0 |
| `ShowMsg` | method | p_Msg, p_Title, p_PicID, p_SmallMsg, p_LargeMsg | 5 | 4 |
| `GetProfitLoss` | method | p_Repopt, p_CallGenRep1 | 2 | 0 |
| `GetAccAgeingFIFOValues` | method | p_Repopt | 1 | 0 |
| `GetMaxElmtInGrid` | method | p_MaxItem, p_MaxAcc, p_MaxCC, p_MaxBS, p_MaxBill, p_MaxBatch, p_MaxOrder, p_MaxForm | 8 | 0 |
| `SaveMaxElmtInGrid` | method | p_MaxItem, p_MaxAcc, p_MaxCC, p_MaxBS, p_MaxBill, p_MaxBatch, p_MaxOrder, p_MaxForm | 8 | 0 |
| `GetTempTableNo` | method |  | 0 | 0 |
| `ReleaseTempTable` | method | p_TabelNo | 1 | 0 |
| `GetAgeingSlabs` | method | p_AgeingType, p_InputMode | 2 | 0 |
| `UpdateAgeingSlabs` | method | p_Ageing, p_NoOfFld, p_AgeingType | 3 | 0 |
| `LoadInterestSlabs` | method | p_Basis | 1 | 0 |
| `FullName2VchType` | method | p_Name | 1 | 0 |
| `GetNoOfRowsForTarget` | method | DeleteConst | 1 | 1 |
| `TaxBS` | method | p_BSNature, p_LocType | 2 | 0 |
| `UpdateClearingDate` | method | p_Date, p_Vchcode, p_AccCode, p_Srno, p_Type, p_BankCode, p_ClrFullVch, p_OldVchCode, p_VchNo | 9 | 0 |
| `GetBranchForVSCode` | method | p_Code | 1 | 0 |
| `SaveBankRecoEntriesInDataSync` | method | p_RecType, p_VMType, p_CheckType, p_vchSrCode, p_VchDate, p_VchNo, p_Srno, p_AccCode, p_BankCode, p_ClrFullVch, p_ClrDate, p_BranchCode | 12 | 1 |
| `SendBankRecoEntries2BO` | method | p_RecType, p_VMType, p_CheckType, p_vchSrCode, p_VchDate, p_VchNo, p_Srno, p_AccCode, p_BankCode, p_ClrFullVch, p_ClrDate, p_BranchCode | 12 | 0 |
| `ShowFullMsgForm` | method | p_udtFullMsg, p_ButtonType | 2 | 0 |
| `GetCSTypeForVch` | method | p_VchType | 1 | 0 |
| `GetIADPrintingData` | method |  | 0 | 0 |
| `SaveIADPrintingData` | method | p_XMLStr | 1 | 0 |
| `GetAccGrpOpeningClosingBalDateWiseForBranch` | method | p_GrpCode, p_BranchCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate | 6 | 0 |
| `SaveUtilitesUserLog` | method | p_MenuConst, p_AddInfo, p_OtherInfo, p_TypeConst, p_AddEventInfo, p_used4BulkUpdation | 6 | 0 |
| `SaveConfigUserLog` | method | p_MenuConst, p_AddInfo, p_TypeConst, p_EventLogConst, p_AddEventInfo | 5 | 0 |
| `CheckFromBOControlsForBankRecoInHOFlag` | method |  | 0 | 0 |
| `OperandType2Str` | method | p_Type | 1 | 0 |
| `OperandStr2Type` | method | p_str | 1 | 0 |
| `GetVchTypeAndVchSeriesFromVchCode` | method | p_Vchcode, p_VchSeriesCode, p_VchType | 3 | 0 |
| `LoadTariffHeadingDesc` | method |  | 0 | 0 |
| `PrintCompNameForRemLetter` | method | p_RepEvents, p_FormatName, p_RepID, p_WinFonts, p_ExtraInfo, p_AccCode, p_SetAndPrintAccImgIfExist, p_PartyImgPath | 8 | 0 |
| `UserHaveAccess2MasterAction` | method | p_Mastertype, p_Action, p_HOAction, p_MasterName | 4 | 2 |
| `UserHaveAccess2Master` | method | p_Mastertype | 1 | 0 |
| `ToIncludeMasterInBlockedList` | method | p_MasterName, p_RecType | 2 | 0 |
| `GetHelp1GroupTypeFromMasterType` | method | p_Mastertype, p_MasterRange | 2 | 0 |
| `GetAllChildsInGrpCol` | method | p_GrpCode, p_IncludeCurrent | 2 | 0 |
| `SaveMasterBlockDeactivateData` | method | p_RecType, p_Code, p_MastType, p_Blocked, p_Notes, p_Deactivate, p_BlockedVchtypeCol | 7 | 1 |
| `LoadDeactiveMasterData` | method | p_Code, p_status, p_ApprovalStatus | 3 | 0 |
| `STRegTypeStr2Num` | method | p_str | 1 | 0 |
| `ApplyPatchOnDatabase` | method | p_PatchStr | 1 | 0 |
| `AMCStatusNo2Str` | method | p_No | 1 | 0 |
| `AMCStatusStr2No` | method | p_str | 1 | 0 |
| `GetCashBankCols` | method |  | 0 | 0 |
| `Name2PRID` | method | p_Name, p_UsedForImport | 2 | 0 |
| `VchType2PRID` | method | p_VchType, p_FAVchFlag | 2 | 1 |
| `PRID2Name` | method | p_PRID | 1 | 0 |
| `AccVch` | method | p_VchType | 1 | 0 |
| `AccVchIndirect` | method | p_VchType | 1 | 0 |
| `InvVch` | method | p_VchType | 1 | 0 |
| `GetMnuListCol` | method | p_EventID, p_ICol | 2 | 0 |
| `GetAllPRFormats` | method | p_PRID, p_FormatType | 2 | 0 |
| `CRMTrantype2Str` | method | p_Trantype | 1 | 0 |
| `ValidDateInTran` | method | p_Date, p_VchType, p_VchSeriesCode, p_DateTypeStr, p_InputMode, p_ErrMsg | 6 | 0 |
| `DataFreezedTillDate` | method | p_VchType, p_VchSeriesCode, p_Date, p_ErrMsg, p_DeleteVch | 5 | 1 |
| `GetVchTypeCol` | method |  | 0 | 0 |
| `CanNotSaveMsg` | method | p_Msg | 1 | 0 |
| `SaveVoucherSeriesGrp` | method | p_Grp | 1 | 0 |
| `MobileUserNameExists` | method | p_UserName | 1 | 0 |
| `CloudUserNameExists` | method | p_UserName | 1 | 0 |
| `SaveVchSeriesGrpConfigForMultipleSeriesCreation` | method | p_CodeCol, p_SeriesName | 2 | 0 |
| `GetLastVchInSeries` | method | p_Code | 1 | 0 |
| `DeleteVchseries` | method | p_Code | 1 | 0 |
| `SaveVchSeriesForMultiSeriesCreation` | method | p_SeriesName, p_VchType, p_Source, p_Code, p_MandiType | 5 | 0 |
| `CopySeriesConfig` | method | p_VchType, p_CopyFrom, p_Code, p_SeriesStr | 4 | 0 |
| `GetVchSeriesCodeCol` | method | p_GrpCode | 1 | 0 |
| `CheckSearchTypeWithValues` | method | p_SearchType, p_SearchString, p_DBSearchString | 3 | 0 |
| `PrevYearExist` | method |  | 0 | 0 |
| `NextYearExist` | method |  | 0 | 0 |
| `SaveCurrentDB` | method | p_db, p_Con | 2 | 0 |
| `ChangeDB` | method | p_Year | 1 | 0 |
| `RestoreCurrentDB` | method | p_db, p_Con | 2 | 0 |
| `DisableMasterSeriesGrpOnReporting` | method |  | 0 | 0 |
| `StockValInt2Str` | method | p_Int | 1 | 0 |
| `StockValStr2Int` | method | p_str | 1 | 0 |
| `IfMultiCurrencyEnableInAccMast` | method | p_PartyCode | 1 | 0 |
| `UserHaveAccess2VoucherAction` | method | p_VchType, p_Action | 2 | 0 |
| `UserHaveAccess2Voucher` | method | p_VchType | 1 | 0 |
| `GetFreeQtyForLastSalesPurc` | method | p_Vchcode, p_Srno | 2 | 0 |
| `CombineQtyAndFreeQty` | method | p_QryStr, p_Qty, p_FreeQty, p_OperatorIncluded, p_IsReturnQty | 5 | 0 |
| `GetValidDiscBasisFromStr` | method | p_str, p_DiscPercentBasis | 2 | 0 |
| `GetAllFinYrs` | method |  | 0 | 0 |
| `GetDBConnection` | method | p_FinYr | 1 | 0 |
| `ValidMasterName` | method | p_Mastertype, p_Name, p_OldName, p_InputMode, p_Code, p_strError | 6 | 0 |
| `GetDiscountStructDetailsXML` | method | p_Code | 1 | 0 |
| `GetSearchtext` | method | p_str, p_SearchInStr, p_Col | 3 | 0 |
| `GetRestrictedKeyWordsCol` | method |  | 0 | 0 |
| `CheckCLNetSecurityFile` | method |  | 0 | 0 |
| `WildSearch` | method | p_str, p_Compareto, p_Method, p_SearchAll | 4 | 0 |
| `LoadCustomIndexConfig` | method |  | 0 | 0 |
| `CreateCustomIndexes` | method |  | 0 | 0 |
| `FolderExist` | method | p_FolderName | 1 | 0 |
| `CreateFolder` | method | p_FolderName | 1 | 0 |
| `GetServerInfoErrMsg` | method | p_ErrNo | 1 | 0 |
| `UserExistInCompany` | method | p_DataPath, p_Year | 2 | 0 |
| `SetExclusiveMode` | method | p_CompPath, p_ForDataSync | 2 | 1 |
| `ResetExclusiveMode` | method | p_ForDataSync | 1 | 1 |
| `FileExist` | method | p_FileName | 1 | 0 |
| `GetDataPathFileName` | method |  | 0 | 0 |
| `GetAllTablesForDB` | method | p_DbName | 1 | 0 |
| `CheckHDDBindingForCompany` | method | p_EnableHDDBinding, p_HDDStr | 2 | 0 |
| `SaveCurYearInReg` | method | p_CompName, p_Year | 2 | 0 |
| `GenCSDBName` | method | p_CompCode, p_FinYr | 2 | 0 |
| `RemoveFileAttribute` | method | p_PathStr | 1 | 0 |
| `GeneratePassword` | method |  | 0 | 0 |
| `GetP` | method | p_rst | 1 | 0 |
| `UserHaveAccess2VoucherSyncAction` | method | p_VchType, p_Action, p_VchSerCode, p_Vchcode, p_OldVchserCode, p_ErrMsg | 6 | 3 |
| `ShowBusyForms` | method | p_EventID, p_ICol | 2 | 0 |
| `WorkingOnServer` | method |  | 0 | 0 |
| `LoadItemSNPrintDetConfig` | method | p_rst, p_RecType | 2 | 0 |
| `GetOpInfoForSubDets` | method | p_ItemCode, p_PartyCode, p_VchType | 3 | 0 |
| `MasterLeftForApproval` | method | p_MastType | 1 | 0 |
| `VchLeftForApproval` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `GetVchTypeFromVchSeriesCode` | method | p_VchSeriesCode | 1 | 0 |
| `UpdateCompConfigOfBusyFromExt` | method |  | 0 | 0 |
| `UpdateItemSPFromPP` | method | p_ItemName, MarkUpConfig, p_UpdateSalePrice | 3 | 0 |
| `UpdateTagDiscountStruct` | method | p_Date, p_StructName, p_MastType, p_ItemCode, p_RecType, p_IfOptSale, p_IfOptPurc, p_ErrStr | 8 | 0 |
| `UpdateItemPricesAppliedonSalesPurc` | method | p_ItemCode, p_PricesAppliedonSales, p_PricesAppliedonPurc | 3 | 0 |
| `UpdateItemTaxCategory` | method | p_ItemName, p_TaxCategoryCode, p_ErrMsg, p_HSNCode, p_FilterOnDate, p_HSNDate | 6 | 0 |
| `UpdateOneItem` | method | p_Consumption, p_ItemCode, p_count, p_Pos, p_Reorder, p_Max, p_Min, p_LevelFromMaster, p_Proceed4OneMC, p_CLMCCode, p_StrErr | 11 | 0 |
| `UpdateItemPrice` | method | p_udtUpdateItemPriceXML, p_ErrMsg, p_ItemCode | 3 | 0 |
| `AddMaster` | method | p_Mastertype, p_InputMode, p_ToShowMaster, p_QuitAfterSaving | 4 | 0 |
| `SetFontInFrmTextWidth` | method | p_FontName, p_FontSize, p_FontBold, p_FontItalic, p_FontUnderline, p_FontStrikeThrough | 6 | 0 |
| `GetStringWidthInTwip` | method | p_str | 1 | 0 |
| `GetStringHeightInTwip` | method | p_str | 1 | 0 |
| `CouldNotSaveMsg` | method | p_Msg | 1 | 0 |
| `GetMasterTypeFromRecType` | method | p_RecType | 1 | 0 |
| `CreateDefaultMaster` | method | p_Mastertype, p_MasterName, p_GrpCode, p_DefaultMastCode, p_AddInfo, p_Source | 6 | 0 |
| `MasterType2Name` | method | p_Mastertype, p_LoadSavedCaptionFlag | 2 | 0 |
| `MasterName2Type` | method | txtMaster | 1 | 0 |
| `GetOrgName` | method | p_Code, p_MastType | 2 | 0 |
| `ShowCantChangeMsg` | method | p_Msg | 1 | 0 |
| `ValidDateInCurFY` | method | p_Date, p_DateTypeStr, p_ErrMsg | 3 | 0 |
| `GetAccClosingBals` | method | p_MasterCode, p_Date, p_AltBal, p_Vchcode, p_IncludePDC | 5 | 0 |
| `GetAccClosingBalsForVSGrpCode` | method | p_MasterCode, p_Date, p_BalAlt, p_VchSeriesGrpCode, p_Vchcode, p_IncludePDC, p_CCCode | 7 | 0 |
| `GetAccOpeningClosingBalDateWise` | method | p_AccCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate | 5 | 0 |
| `GetAccOpeningClosingBalDateWiseForVSGrpCode` | method | p_AccCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate, p_VchSeriesGrpCode | 6 | 0 |
| `ShowConfigTrigger` | method | p_udtDataXML, p_ForVchApproval, p_VchType, p_SeriesCode, p_ForMasterApproval | 5 | 0 |
| `GetItemDetInVch1` | method | p_Vchcode, p_UsePrintName | 2 | 0 |
| `ToDeleteMaster` | method | p_Msg, p_Title, p_DefaultValue | 3 | 0 |
| `GetPassword` | method | p_Edit, p_EntryDone | 2 | 0 |
| `GetTGCondition2Name` | method | p_Value | 1 | 0 |
| `SetFormCaptionsAndFonts` | method | p_Form, p_SkipControlsCol, p_RefreshDefaultDetails, p_DefaultValueCol | 4 | 0 |
| `GetAllAPIConfigNames` | method |  | 0 | 0 |
| `GetItemConsumedOrGeneratedCon` | method | p_str | 1 | 0 |
| `GetItemConsumedOrGeneratedStr` | method | p_Int | 1 | 0 |
| `GetOperatorType2Name` | method | p_Type | 1 | 0 |
| `UpdateTriggerColofBusyFromEXt` | method |  | 0 | 0 |
| `StateCode2TinDigit` | method | p_str | 1 | 0 |
| `TinDigit2StateCode` | method | p_str | 1 | 0 |
| `CreateMultiCurRevaluationVouchers` | method | p_AccCode, p_ForexAcc, p_VchSeriesName, p_StartDate, p_EndDate, p_CurCode, p_CurConRate, p_RetvalType, p_MsgStr, p_SVchNo, p_EVchNo | 11 | 0 |
| `UpdateVchSeriesListBox` | method | p_ListBox, p_VchType | 2 | 0 |
| `ShowBusyForms2002` | method | p_EventID, p_ICol | 2 | 0 |
| `GetMasterConfigOptions` | method | p_Mastertype, p_RecType, p_Value, p_CaptionStr, p_CantShowoption | 5 | 0 |
| `UpdateItemHSNCode` | method | p_ItemCode, p_HSNCode, p_SchEntry, p_MsgStr | 4 | 0 |
| `UpdateItemHSNCodeForGST` | method | p_ItemCode, p_HSNCode, p_MsgStr, p_FilterHSN, p_FilterHSNDate, p_SaveOnDate | 6 | 0 |
| `UpdateProductionVchwithSelectedBOM` | method | p_BOMName, p_StartDate, p_EndDate, p_ProductionVch, p_UnAssembledVch, p_Vchcode, p_VchType, p_ErrMsg | 8 | 0 |
| `UpdateVchModifiedFlag` | method |  | 0 | 0 |
| `UpdateVchModifiedFlagFromExt` | method |  | 0 | 0 |
| `VchLeftForAuditing` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `GetTargetRecTypesStr` | method |  | 0 | 0 |
| `BrowseFile` | method | p_WHandle, p_FileName, p_FileType, p_TypeStr | 4 | 0 |
| `UpdateMasterPrintName` | method | p_MastType, p_Code, p_Name, p_ErrMsg | 4 | 0 |
| `GetDataPath` | method |  | 0 | 0 |
| `GetCompCode` | method |  | 0 | 0 |
| `SetExclusiceMode` | method | p_CompPath | 1 | 0 |
| `ReSetExclusiceMode` | method |  | 0 | 0 |
| `LockTempTabel` | method |  | 0 | 0 |
| `GetAllFinYears` | method |  | 0 | 0 |
| `GetYearStartDateEndDate` | method | p_StDate, p_EndDate | 2 | 0 |
| `ShowPIRExportImportXML` | method | p_VchType, p_RecType, IfExport, p_Date, p_BranchCode, p_ForDataSync, p_ForPartyItemCodes | 7 | 0 |
| `ShowItemPriceDetailsDateWiseFromPIR` | method | p_Form, p_RecType, p_MasterCode, p_VchType, p_Date, p_BranchCode, p_Date1, p_ItemDateWise, p_PartyCode | 9 | 0 |
| `GetMastSeriesGrpCodeForBranch` | method | p_BranchCode | 1 | 0 |
| `GetExportFilePath` | method |  | 0 | 0 |
| `ShowExport` | method | p_ExportType, p_FileName, p_FileChs, p_FromScrRep, p_ExportPIR | 5 | 0 |
| `ValidateCompoundDiscount` | method | p_CompDisc, p_ErrMsg | 2 | 0 |
| `GetSelectmaster` | method |  | 0 | 0 |
| `IfPartyCashBank` | method | p_Code | 1 | 0 |
| `IfParty` | method | p_Code | 1 | 0 |
| `GetLastDateForIQDAndPIR` | method | p_RecType, p_MasterCode1, p_VchType, p_BranchCode | 4 | 0 |
| `GetVchNumInfoData` | method | p_SeriesCode | 1 | 0 |
| `GetAccDataXMLArr` | method | p_RecType, p_Vchcode | 2 | 0 |
| `GetVchRefDetWithColumns` | method | p_MastCode, p_Vchcode, p_RefType | 3 | 0 |
| `ShowInfoForm` | method | p_FormString, p_Caption, p_SetSize | 3 | 0 |
| `GetNetLibCompatibilityVerFromBUSY` | method |  | 0 | 0 |
| `ApplicableGSTIndia` | method |  | 0 | 0 |
| `CheckPIRCombinationExist` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_VchType, p_Date, p_BranchCode | 6 | 0 |
| `GetConfigCategory` | method | p_PRID | 1 | 0 |
| `IfSmallDoc` | method | p_PRID | 1 | 0 |
| `CheckProductionVchByRepID` | method | p_RID | 1 | 0 |
| `GetConfigTypeForSalesPurcAnalysis` | method | p_RID | 1 | 0 |
| `GetConfigTypeForCostCentreAnalysis` | method | p_RID | 1 | 0 |
| `PRID2Vchtype` | method | p_RID | 1 | 0 |
| `IfWideScreen` | method |  | 0 | 0 |
| `UpdateAccRegCols` | method | p_AccRegCols, p_ConfigType, p_VchType, p_ModifyRecords, p_FormatName, p_PRID | 6 | 2 |
| `SaveImportVchFromExcelFormatName` | method | p_FormatName, p_PRID | 2 | 0 |
| `SaveBulkVchFromGridFormatName` | method | p_FormatName, p_PRID | 2 | 0 |
| `PartywiseSalePurcReportFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `CostCentreReportFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `ConfigBalSheetFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `ImportVchFromExcelFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `BulkVchFromGridFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `PRFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `GetDBConnectionWithWorkSpace` | method | p_WkSpace, p_strDbName | 2 | 0 |
| `SavePRConfigUserLog` | method | p_PRID, p_ConfigType, p_str | 3 | 0 |
| `openDocument` | method | p_Form, p_Path | 2 | 0 |
| `GetDocCopyType` | method | p_PRID | 1 | 0 |
| `UpdateDocCopyType` | method | p_PRID, p_Vals | 2 | 0 |
| `GetFields4Explore` | method | p_MastType, p_BulkAccountInputConst | 2 | 1 |
| `GenPRFieldsArr` | method | p_PRID, p_PRSUBID | 2 | 0 |
| `ShortName2VchType` | method | p_Name | 1 | 0 |
| `GetDataForRegularizedPDCDataEntry` | method | p_Repopt | 1 | 0 |
| `UpdatePDCDetails` | method | p_VchcodeCol, p_VchTypeCol, p_ErrMsg, p_BankName, p_RetainPDCDate, p_RetainRcvdDate, p_MakePDCDateasVchDate | 7 | 0 |
| `GetPOSEnableDisableSeriesCol` | method | p_EnabledSeriesCol, p_DisabledSeriesCol, p_VchType | 3 | 0 |
| `GetSeriesForUserProfile` | method | p_VchType | 1 | 0 |
| `SaveImageInDatabase` | method | p_udtImageData | 1 | 0 |
| `GetMasterTypeFromCode` | method | p_Code | 1 | 0 |
| `GetVchSeriesFromVchCode` | method | p_Code | 1 | 0 |
| `GetMastersNameAndAliasCol` | method | p_Mastertype, p_MSGrpCode | 2 | 0 |
| `ImageExistsInDB` | method | p_Code, p_Type | 2 | 0 |
| `UserImageExistInDB` | method | p_Name, p_Type | 2 | 0 |
| `SaveUserAndSignImageInDatabase` | method | p_udtImageData | 1 | 0 |
| `ShowImage` | method | p_ImagePath, p_Form, p_MastType, p_MastName, p_VchDate, p_VchImage, p_ShowImagePath | 7 | 0 |
| `LoadUserImageFormDatabase` | method | p_Name, p_Type | 2 | 0 |
| `GetHDSerialNo` | method | p_HDNo | 1 | 0 |
| `GetHDSerialNoNew` | method |  | 0 | 0 |
| `DeleteFAQDatabase` | method | p_Calltype, p_FAQGrpCode, p_ProblemString, p_ErrMsg | 4 | 0 |
| `ListFAQGrpMast` | method | p_MastType | 1 | 0 |
| `FAQGrpName2Code` | method | p_Name, p_MastType | 2 | 0 |
| `FAQGrpCode2Name` | method | p_Code | 1 | 0 |
| `CheckIfDataExistInFAQDatabase` | method | p_Calltype, p_FAQGrpCode, p_ProblemTitle, p_udtData | 4 | 0 |
| `AddFAQDatabase` | method | p_udtData | 1 | 0 |
| `ModifyFAQDatabase` | method | p_OldCallType, p_OldFAQGrpCode, p_OldProblemTitle, p_udtData | 4 | 0 |
| `SaveItemMastForImportSingleVch` | method | p_UdtGen, p_ErrStr | 2 | 0 |
| `SaveItemMast4UpdateSPFromPP` | method | p_udtData, p_ErrStr | 2 | 0 |
| `CheckEmailID` | method | p_EMail | 1 | 0 |
| `CanNotDeleteMsg` | method | p_Msg | 1 | 0 |
| `RestrictionApplicableForReporting` | method |  | 0 | 0 |
| `RestrictionApplicableOnAccountForReporting` | method |  | 0 | 0 |
| `GetBrokerageModeCurSymbol` | method | p_Mode | 1 | 0 |
| `GetAllDBTablesWithRowCount` | method | p_TableCol, p_DbName, p_IndexCol | 3 | 0 |
| `CheckCLNetSecurity` | method |  | 0 | 0 |
| `SelectVchForTemplate` | method | p_VchType, p_ICol | 2 | 0 |
| `GetTemplateName` | method | p_SecInfo, p_Form | 2 | 0 |
| `ExclusiveOperationInCompany` | method | p_CompPath, p_ForSync | 2 | 0 |
| `CreateNewDir` | method |  | 0 | 0 |
| `GetCompanySize` | method | p_CompCode, p_FYList, p_SQLServerDataPath | 3 | 0 |
| `ChangeName` | method | p_Path, p_EmbeddedFYInsteadofDate, FinYear | 3 | 0 |
| `DeleteComp` | method | p_CompCode, p_Year, p_strError | 3 | 0 |
| `BackupCSDataBase` | method | p_CompCode, p_FYList, p_DestinationPath, p_BackupPath, p_DbSize | 5 | 0 |
| `RestoreCSDataBase` | method | p_ScrDBPath, p_DBNameCol, p_NewCompCode | 3 | 0 |
| `GetAllFinYearsOfSpecificCompCode` | method | CompCode | 1 | 0 |
| `GetCurrentStatVer` | method |  | 0 | 0 |
| `SetCurCSTypeForAlLProject` | method | p_CurCSType | 1 | 0 |
| `ShowUserSerialNo` | method | p_SecInfo, p_SetChildFormInBottom, p_ParentForm | 3 | 0 |
| `GetRevisionNo` | method |  | 0 | 0 |
| `GetValidDiscBasis` | method | p_StructureName, p_DiscPercentBasis | 2 | 0 |
| `GetValidMarkupBasis` | method | p_StructureName, p_MarkupPercentBasis | 2 | 0 |
| `GetMajorVer` | method |  | 0 | 0 |
| `GetMinorVer` | method |  | 0 | 0 |
| `DataBaseIsOpen` | method |  | 0 | 0 |
| `SaveCheckListForMiscellaneousDataEntry` | method | p_Code, p_VchType, p_Notes | 3 | 0 |
| `IfPOSEnableInSeries` | method | p_VchSeriesCode, p_VchType | 2 | 0 |
| `ModifyUser` | method | p_UserName, p_ShowMobileUser, p_EnableCloudSync | 3 | 0 |
| `GetAMCOpRefs` | method | p_PartyCode, p_Form, p_FormTop | 3 | 0 |
| `LoadBSTagging` | method | p_SRInfo | 1 | 0 |
| `GetOptionsWithMasterControlChk` | method | p_Msg, p_OptionsCol, p_Title, p_PicID | 4 | 0 |
| `GetBrokerBillAmt` | method | p_Repopt | 1 | 0 |
| `GetBillRecPayRecordCount` | method | p_Repopt | 1 | 0 |
| `ShowFAQDatabase4OnEnter` | method | p_InputMode, p_udtData | 2 | 0 |
| `GetRepOptValues` | method | p_Repopt, p_RepID, p_RepType, p_Options, p_FormatName | 5 | 0 |
| `AutoCreateContactFromLedger` | method | p_AccountCode, p_Raise | 2 | 0 |
| `DeleteSTVoucherByCode` | method | p_Vchcode, p_ErrMsg | 2 | 0 |
| `GetGSTNatureListCol` | method | p_VchType | 1 | 0 |
| `GetDealerStr` | method | p_Type | 1 | 0 |
| `GetDealerType` | method | p_DealerStr | 1 | 0 |
| `ShowHSNCodeDesc` | method |  | 0 | 0 |
| `ShowTransporterID` | method |  | 0 | 0 |
| `ShowPortDetails` | method |  | 0 | 0 |
| `LoadTaxCategories` | method |  | 0 | 0 |
| `GSTAdjustmentStr2Type` | method | p_str | 1 | 0 |
| `GSTAdjustmentType2Str` | method | p_Type | 1 | 0 |
| `OpenHelpVideo` | method | p_Const, p_EngHindi | 2 | 0 |
| `ShowYouTubeMsg` | method | p_Msg, p_DefaultEscValue, p_DefaultValue, p_Title, p_PicID, p_SmallMsg, p_LargeMsg, p_EngHindiBoth, p_FocusVal | 9 | 0 |
| `ShowYouTubeMsgWithMultipleOptions` | method | p_Msg, p_OptionsCol, p_DefaultEscValue, p_DefaultValue, p_Title, p_PicID, p_SmallMsg, p_LargeMsg, p_FocusVal | 9 | 0 |
| `GetSaleAndTaxAmt4GSTINDIA` | method | p_Vchcode, p_TaxableAmt, p_TaxAmt, p_TaxBeforeSchg, p_TaxBeforeSchg1, p_STPTType, p_CessAmt, p_AddCessAmt | 8 | 0 |
| `GetSaleAndTaxAmt4GSTIndiaRCMPybl` | method | p_Vchcode, p_TaxableAmt, p_TaxAmt, p_IGST, p_CGST, p_SGST, p_STPTType, p_CessAmt, p_AddCessAmt | 9 | 0 |
| `GetTaxCatPercentageOnSpecificDate` | method | p_VchDate, p_TaxCatCode, p_Cess, p_ACess | 4 | 0 |
| `UpdateCompHoliDaysConfig` | method |  | 0 | 0 |
| `GetStateListForUAE` | method |  | 0 | 0 |
| `SaveDictionarySL` | method | p_Col, p_LangName, p_ImportFromXML | 3 | 0 |
| `LoadDictionarySL` | method | p_LangName | 1 | 0 |
| `ShowSelectedAcc` | method | p_Col | 1 | 0 |
| `ShowSelectedItem` | method | p_Col | 1 | 0 |
| `IsInternetAvailable` | method |  | 0 | 0 |
| `GetSigDetModel` | method |  | 0 | 0 |
| `GetAMCExpiry` | method |  | 0 | 0 |
| `GetSigDetSrNo` | method |  | 0 | 0 |
| `SaveMasterSLData` | method | p_udt, p_Code | 2 | 0 |
| `SaveDefaultDictionarySL` | method | p_Col, p_LangName | 2 | 0 |
| `LoadDefaultDictionarySL` | method | p_LangName | 1 | 0 |
| `DoBlankItemAlias` | method | p_strAlias | 1 | 0 |
| `IfBank` | method | p_Code | 1 | 0 |
| `InterChangeDiscountAndMarkupVariable` | method | p_Discount, p_DiscAmt, p_CompoundDisc | 3 | 0 |
| `GetRoundedOffBSAmt` | method | p_Amt, p_RoundOffType, p_RoundOffNearestTo | 3 | 0 |
| `GetAllDosPrinters` | method |  | 0 | 0 |
| `ModifyMasterFromXMLByNameForPatanjali` | method | p_Mastertype, p_MasterName, p_Alias, p_XMLStr, p_ErrStr | 5 | 0 |
| `GetRateFromTaxCatCode` | method | p_TaxCatCode, p_Type | 2 | 0 |
| `GetTaxCatNameFromMatchingTaxRate` | method | p_CentralTaxRate, p_TaxType | 2 | 0 |
| `GetBSNameFromSpecificBSNature` | method | p_BSN, p_Code | 2 | 0 |
| `GetAnyBSNameFromSpecificBSNature` | method | p_BSN, p_Code | 2 | 0 |
| `GetBSEntriesForApplyTaxForMultiRate` | method | p_ItemDataCol, p_BSEntries, p_STPTName, p_VchType | 4 | 0 |
| `SearchFromBSCol` | method | p_Rate, p_BSEntries, p_BSType | 3 | 0 |
| `SaveVchFromXMLForPatanjali` | method | p_VchType, p_XMLStr, p_ErrStr, p_Modify, p_ModifyKey, p_Vchcode | 6 | 0 |
| `GetSecondLangStrFromDictionarySL` | method | p_str | 1 | 0 |
| `SearchGSTIN` | method |  | 0 | 0 |
| `GetAllChildQryStrForParentGrps` | method | p_GrpCodes, p_ChildMasterType, p_DirectChildOnly | 3 | 0 |
| `LoadImageFormDatabase` | method | p_Code, p_Type | 2 | 0 |
| `PrintBarCode` | method | p_Repopt, p_udtConfig, p_ExcelInfoCol | 3 | 0 |
| `GetBCStockStatusRst` | method | p_Repopt | 1 | 0 |
| `PrintBarcodeWithReqDataCol` | method | p_Repopt, p_udtConfig, p_ReqDataCol | 3 | 0 |
| `PrintCheque` | method | p_Repopt, p_VchType, p_udtConfig, p_ReqDataCol, p_udtGenCol | 5 | 0 |
| `UpdateItemAlias` | method | p_Alias, p_ItemCode | 2 | 0 |
| `EditChequePrintNameAndAmount` | method | p_ParentForm, p_ChequePrintNameExist, p_AmountExist, p_IfEntryDone, p_Amount | 5 | 0 |
| `GetOnAccEntriesOfBroker` | method | p_Repopt | 1 | 0 |
| `PrintTransportVch` | method | p_VchType, p_VchcodeCol | 2 | 0 |
| `ConvertNumberingToManualForTally2Busy` | method |  | 0 | 0 |
| `GetSubscriptionMsgStr` | method |  | 0 | 0 |
| `ShowEwayBillDetBeforeUpload` | method | p_ICol, p_OCol | 2 | 0 |
| `ShowEInvoiceBeforeUpload` | method | p_ICol, p_OCol | 2 | 0 |
| `ShowSaveGSTR2AFile` | method | p_RecType | 1 | 0 |
| `GetShortMaster` | method |  | 0 | 0 |
| `ShowForMapping` | method | p_Mastertype, p_MastCol, p_ParentForm | 3 | 0 |
| `ShowForMappingFromXML` | method | p_Mastertype, p_MastCol, p_ParentForm | 3 | 0 |
| `ShowCompConfigVAT` | method | p_IsGSTRtnDashboard | 1 | 0 |
| `GetSigDetEdition` | method |  | 0 | 0 |
| `SaveVchInBDEP` | method | p_VchType, p_Vchcode, p_InputMode, p_IdentityChanged, p_OldVchType, p_OldVchNo, p_OldVchDate, p_VchAmt, p_ShowMsg, p_ErrMsg, p_AskForSkip, p_Trantype | 12 | 0 |
| `OpenEWayBillPortal` | method |  | 0 | 0 |
| `GetGUID` | method |  | 0 | 0 |
| `GetCurrentIPAddress` | method |  | 0 | 0 |
| `CheckOlderData` | method | p_BDEPID | 1 | 0 |
| `FieldExistInTable` | method | p_TableName, p_FieldName | 2 | 0 |
| `CreateFieldInTable` | method | p_TableName, p_FieldName, p_FldType, p_FldSize, p_SetDefault | 5 | 0 |
| `UpdateVchGSTSum` | method |  | 0 | 0 |
| `OpenThruAddon` | method |  | 0 | 0 |
| `GetStatesList` | method | p_CountryCode, p_IncludeVirtualStatesAlso | 2 | 0 |
| `GetSessionID` | method |  | 0 | 0 |
| `InstrumentType2Str` | method | p_Type, p_UsedForReporting | 2 | 0 |
| `GenerateAutoVchNo` | method | p_VchSeriesCode, p_VchNo, p_AutoVchNo, p_VchDate | 4 | 0 |
| `GetSalesTaxType` | method |  | 0 | 0 |
| `TaxOnAdvance` | method |  | 0 | 0 |
| `CheckBackDateEntry` | method | p_Date, p_VSCode, p_InputMode, p_OldDate, p_ErrStr | 5 | 0 |
| `CanDeleteVch` | method | p_Vchcode, p_Date, p_strError, p_VchSeriesCode | 4 | 0 |
| `AutoVchNoExist` | method | p_AutoVchNo, p_SeriesCode, p_RenumType, p_VchNo, p_Date | 5 | 0 |
| `GetWarningAlarmsInfoBackDateEntry` | method |  | 0 | 0 |
| `GetWarningAlarmsInfo` | method |  | 0 | 0 |
| `Add2Help2Db` | method | p_SeriesCode, p_FieldType, p_Field | 3 | 0 |
| `ToMaintainUserLog` | method |  | 0 | 0 |
| `MaxElemtInMastList` | method |  | 0 | 0 |
| `GeneralConfigLabelsCol` | method |  | 0 | 0 |
| `ShowVchAuditDetailInCheckList` | method | p_VchType, p_VSCode | 2 | 0 |
| `GetCloseCallSubStatusType` | method | p_Code | 1 | 0 |
| `CreateAccountFromContactMast` | method | p_ContactMast, p_ConnectWithLedger | 2 | 0 |
| `ShowCompConfigAccounts` | method |  | 0 | 0 |
| `ShowCompConfigInventory` | method | p_str | 1 | 0 |
| `ShowCompConfigCRM` | method | p_ICol | 1 | 0 |
| `ISVchSeriesUsedInSync` | method | p_VchType, p_vchSrCode | 2 | 0 |
| `GetGSTR2AOTP` | method | p_OTP, p_EntryDone, p_RecType, p_IsEVCOTP | 4 | 0 |
| `ShowPartyDashBoardFromCRM` | method | p_MastType, p_VchType, p_VSCode, p_AccCode, p_Date, p_InputMode, p_Vchcode, p_ConnectWithLedger, p_LedgerCode, p_Form, p_itemCol, p_OutputCol, p_MaintainItem, p_ForceShow | 14 | 0 |
| `ShowObjectHistory` | method | p_Type, p_VchType, p_VSName, p_VchNo, p_Date, p_OnLblClick, p_Vchcode | 7 | 0 |
| `ShowVchNumParentInVch` | method | p_VchType, p_VSName | 2 | 0 |
| `CheckForUnapprovedMaster` | method | p_MastName, p_MastType, p_ErrMsg | 3 | 0 |
| `SaveHOCallVchXMLInDataSync` | method | p_InputMode, p_ModifyEntry, p_XMLStr, p_CallVchDataXML, p_OldCallVchType, p_OldCallVchSeriesName, p_OldCallVchNo, p_OldCallVchDate, p_BranchCode, p_VchType | 10 | 0 |
| `SaveHODeletedCallVchInDataSync` | method | p_InputMode, p_CallvchXML, p_BranchCode, p_VchType | 4 | 0 |
| `SaveBODeletedCallVchInDataSync` | method | p_InputMode, p_CallvchXML, p_VchType | 3 | 0 |
| `GetVchSeriesGrpCodeForBranch` | method | p_BranchCode | 1 | 0 |
| `OpenDocAndWait` | method | p_hwnd, p_Path, p_DefaultDir, p_nShow | 4 | 0 |
| `CheckIfEWayBillPrintSetUpInstalled` | method | p_Path | 1 | 0 |
| `GetGSTR2BStatusInt2Str` | method | p_status | 1 | 0 |
| `GetGSTR2BStatusStr2Int` | method | p_status | 1 | 0 |
| `PrintEWayBill` | method | p_EWayBillNo, p_GSTIN, p_BillDate, p_VchNo, p_Path, p_ErrMsg, p_Form | 7 | 0 |
| `PrintEWayBill4API` | method | p_ICol, p_ResponseStr, p_GSPName, p_Source, p_ErrorCode, p_DoNotShowGWSErr | 6 | 0 |
| `PrintEWayBill4API2SavePDF` | method | p_EWBNo, p_EWBDate, p_EWBPrintFormat, p_ResponseStr, p_VchNo, p_VchSeries | 6 | 0 |
| `PrintEInvoice4Vch` | method | p_ICol, p_ResponseStr, p_DoNotShowGWSErr | 3 | 0 |
| `GetServerSystemDate` | method | p_ErrStr | 1 | 0 |
| `CheckSystemDateFormatForEWayBillPrinting` | method |  | 0 | 0 |
| `MatchVchNoWithJsonVchno` | method | p_JSonVchNo, p_VchNo | 2 | 0 |
| `ShowBUSYAdministratorModeMsg` | method |  | 0 | 0 |
| `SaveAdminTaskUserLog` | method | p_MenuConst, p_AddInfo, p_OtherInfo, p_TypeConst, p_AddEventInfo | 5 | 0 |
| `CheckIfLoginDetRequiredFromDatabase` | method | p_CompCode, p_UserName, p_Password, p_Provider, p_DataPath, p_ServerName, p_UID, p_Pwd | 8 | 0 |
| `GetOFRecTypeMastType` | method | p_MastVchType, p_OFNo, p_RecType, p_MastType, p_H2RecType, p_IsVch | 6 | 0 |
| `ValidateBDEPIDForDeletion` | method | p_BDEPID, p_Pwd | 2 | 0 |
| `ShowBDEPIDDeleteSummary` | method | p_BDEPID, p_XMLStr | 2 | 0 |
| `GetPincode` | method | p_PinCode | 1 | 0 |
| `GetSourceStr` | method | p_Source | 1 | 0 |
| `GetNepalRestriction` | method |  | 0 | 0 |
| `GetBDEPMode` | method |  | 0 | 0 |
| `GetUserXML` | method | p_UserName | 1 | 0 |
| `ITCType2StringForHeader` | method | p_Type | 1 | 0 |
| `ITCString2TypeForHeader` | method | p_str | 1 | 0 |
| `ITCType2String` | method | p_Type | 1 | 0 |
| `ITCString2Type` | method | p_str | 1 | 0 |
| `GetMasterJSON` | method | p_Mastertype, p_MasterCode, p_ErrMsg | 3 | 0 |
| `GetAccClosingBalsForBranch` | method | p_MasterCode, p_BranchCode, p_Date, p_Vchcode | 4 | 0 |
| `GetGrpList` | method | p_GrpType | 1 | 0 |
| `IfPartyInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `InputBDEPPwdForCloudSync` | method | p_BDEPID, p_BDEPPwd | 2 | 0 |
| `GetVchDataJSON` | method | p_Vchcode | 1 | 0 |
| `GenTCSVouchers` | method | p_UdtGen, p_VchSeriesName, p_Date, p_Narration, p_TCSAcc, p_ErrStr, p_ForTDS | 7 | 0 |
| `SaveVchPostingThruF4Config` | method | p_UdtGen, p_RepID | 2 | 0 |
| `LoadVchPostingThruF4Config` | method | p_UdtGen, p_RepID | 2 | 0 |
| `GetDropDownFilterText` | method | p_Text, p_EntryDone | 2 | 0 |
| `CheckForCustomisationMenu` | method |  | 0 | 0 |
| `GetTDSRateFor194QAccordingToPAN` | method | p_PAN, p_ReturnNotFiled, p_PartyCode, p_VchDate | 4 | 0 |
| `GetTCSRateAccordingToPANAndVchDate` | method | p_PAN, p_VchDate, p_ReturnNotFiled | 3 | 0 |
| `GSPSelectionService` | method | p_Report, p_GSTNo, p_IsDownload | 3 | 0 |
| `GetGSPSelectionFromCmdLine` | method |  | 0 | 0 |
| `GetXMLFromRecordset` | method | p_StrQry, p_ErrMsg | 2 | 0 |
| `BLSExpired` | method |  | 0 | 0 |
| `GetSTPTMastDataByCode` | method | p_STPTCode, p_MastType, p_LoadPartial, p_CheckST | 4 | 0 |
| `GetVchGSTSumRst` | method | p_Vchcode, p_STPTMast | 2 | 0 |
| `GetSalesTaxInfo` | method | p_Vchcode, p_VchType, p_STPTMast, p_ItemCode, p_SplitMRPEntries, p_SeparateRetailPurchaseEntry | 6 | 0 |
| `GetItemLastTransactionsForSalePurc` | method | p_PartyName, p_ItemName, p_VchType, p_NoOfTran, p_Date, p_VoucherCode, p_InputMode | 7 | 0 |
| `GetSalePurchaseListForReturnValidate` | method | p_VchSeriesName, p_VchDate, p_PartyName, p_VchType | 4 | 0 |
| `CanChangeOpBal` | method | p_Mastertype, p_strError | 2 | 0 |
| `GetBOMMastData` | method | p_BOMName, p_LoadPartial, p_CheckBOM | 3 | 0 |
| `ValidItemMainUnit` | method | p_ItemName, p_UnitName, p_CheckItemName, p_ItemMast | 4 | 0 |
| `ChangeTaxTypeIfReqdAndGetSurchargeDet` | method | p_SurchargeDet, p_STSurcharge | 2 | 0 |
| `VATStr2Type` | method | p_str | 1 | 0 |
| `VATType2Str` | method | p_Type | 1 | 0 |
| `GetInputTaxNatureList` | method | p_ITC | 1 | 0 |
| `GetOutputTaxNatureList` | method | p_ITC | 1 | 0 |
| `GetToolTipText` | method | p_ID | 1 | 0 |
| `GetCurrentUserProfile` | method | p_udtUserProfile1 | 1 | 0 |
| `GetCompConfigAndCompInfo` | method | p_udtCompConfig | 1 | 0 |
| `GetDiscountStructDetails` | method | p_StructureName | 1 | 0 |
| `GetMarkupStructDetails` | method | p_StructureName | 1 | 0 |
| `StatePDCode2TinNoDigit` | method | p_StateCode, p_ExtraTinNoDigit | 2 | 0 |
| `GetFilingStatusColFromStr` | method | p_Col, p_GSTIN, p_ResponseStr, p_GSTR3BCol, p_MonthNo, p_FY, p_RFSAPIVersion | 7 | 0 |
| `ShowAltUnitDets` | method | p_AltUnitData | 1 | 0 |
| `GetBDEPConfig` | method | p_BDEPConfig | 1 | 0 |
| `GetCompGUID` | method |  | 0 | 0 |
| `GetGSPCode4EWBAndEInv` | method | p_ReportID | 1 | 0 |
| `GetGSTReturnCaptchaImageFilePath` | method | p_B64Str | 1 | 0 |
| `CountryName2Code` | method | p_CountryName | 1 | 0 |
| `StateName2TinDigit` | method | p_StateName | 1 | 0 |
| `ForceNegative` | method | p_Num | 1 | 0 |
| `FilterJunkCharInStr` | method | p_str, p_FilterCrLf, p_InMemFilter | 3 | 0 |
| `TaxTypeStr2No` | method | p_TaxTypeStr | 1 | 0 |
| `TaxTypeNo2Str` | method | p_TaxTypeNo | 1 | 0 |
| `BSNatureStr2No` | method | p_BSNatureStr | 1 | 0 |
| `BSNatureNo2Str` | method | p_BSNatureNo | 1 | 0 |
| `CheckDate` | method | sStr, p_DefaultDate, p_DateType | 3 | 0 |
| `CheckTime` | method | sStr, TimeVal | 2 | 0 |
| `FormatTime` | method | DateVal, p_IncludeSeconds, p_ForBusyText, p_TimeFormat, p_CheckDate, p_ConnectingDate | 6 | 0 |
| `ConvertMonthYear2Date` | method | p_MonYr, p_MonthDateType | 2 | 0 |
| `FormatDate` | method | p_Date, p_PutLeadingZeros, p_DateType | 3 | 0 |
| `ShowSalePurcTransactionsForReturnValidate` | method | p_PartyName, p_VchType, p_RetVchDate, p_VchSeriesName, p_ParentForm | 5 | 0 |
| `RefreshSQLConnection` | method |  | 0 | 0 |
| `LoadMastConfig` | method | p_MastType | 1 | 0 |
| `LoadHolidaysConfig` | method |  | 0 | 0 |
| `LoadBranchMastersForDataSync` | method | p_BranchMastCol | 1 | 0 |
| `LoadItemSNPrintDetConfigUDT` | method | p_RecType | 1 | 0 |
| `LoadStockParamConfig` | method |  | 0 | 0 |
| `LoadFreezeConfig` | method |  | 0 | 0 |
| `LoadAuthorisationData` | method |  | 0 | 0 |
| `LoadTriggerConfig` | method |  | 0 | 0 |
| `LoadTaxCategoriesFromConfig` | method |  | 0 | 0 |
| `LoadVchAuditData` | method |  | 0 | 0 |
| `LoadSalCompMastCol` | method |  | 0 | 0 |
| `LoadPayrollConfig` | method |  | 0 | 0 |
| `SaveVchMastDataForCloudSync` | method | p_Type, p_VchMastType, p_VchMastCode, p_InputMode, p_DeleteVch, p_XMLStr, p_ErrMsg, p_FormatType, p_Desc, p_RequiredLock | 10 | 0 |
| `GetFormatNames` | method | p_RepID, p_SubRepID, p_CustomRepFormatName | 3 | 0 |
| `FormatVisibleToCurrentUser` | method | p_FormatName, p_RepID, p_RepSubId, p_CustomRepFormatName | 4 | 0 |
| `GetSuperUserName` | method |  | 0 | 0 |
| `GetAccForBRSRefsInNextYear` | method | p_NxtYrCon, p_NxtYrDB, p_udtData, p_AccDepositedWithdrawalCol | 4 | 0 |
| `CarryAccBRSRefsInNextYear` | method | p_Arr, p_AccDepositedWithdrawalCol, p_errorInAnyAcc | 3 | 0 |
| `GetDataPathInfo` | method |  | 0 | 0 |
| `GetBranchMastDataByCode` | method | p_BranchCode | 1 | 0 |
| `ShowCalculator` | method | p_Form | 1 | 0 |
| `DontCreateLog` | method |  | 0 | 0 |
| `CreateNotificationToSend1` | method | p_MobNo, p_MsgStr | 2 | 0 |
| `GetMastConfig` | method | p_MastType, p_LoadFromDB | 2 | 0 |
| `GetAccMastData` | method | p_AccName, p_LoadPartial, p_CheckAcc, p_Date | 4 | 0 |
| `CheckBusyStatObject` | method | p_BusyStatType, p_ShowErrMsg | 2 | 0 |
| `ShowCompConfig` | method |  | 0 | 0 |
| `LoadMasterImageFromDb` | method | p_MasterCode, p_Mastertype, p_ImageType, p_ImageBox | 4 | 0 |
| `GetOFFldInQuery` | method | p_OFInfo, p_Form, p_GlobalQuery, p_udtFilter, p_UsedForColReg, p_ShowItemAccBal, p_IfSameVOFForAllSer, p_ShowVchOFInCRM | 8 | 0 |
| `GetOFInfo` | method | p_VSCode, p_udtVchOtherInfo, p_Form | 3 | 0 |
| `AddStdNarFromVch` | method | p_Nar1, p_Nar2, p_QuitAfterSaving | 3 | 0 |
| `GetLastDateForVchSeries` | method | p_VchSeriesCode | 1 | 0 |
| `GetTagMasterSeriesDet` | method | p_Col, p_Form, p_Mastertype | 3 | 0 |
| `SelectUser` | method | p_Title, p_StartUser, p_MobileUser | 3 | 0 |
| `SelectMaster` | method | p_MastType, p_Title, P_StartMaster, p_ShowAddnInfo, p_Vchcode, p_BalDate, p_MCCode, p_RecType, p_IfMultiAlias | 9 | 0 |
| `SaveAccVoucherInSalary` | method | p_udtAccVchData, p_ErrMsg | 2 | 0 |
| `DeleteAccVoucherInSalary` | method | p_Vchcode, p_ErrMsg | 2 | 0 |
| `Load2AccVoucherInSalary` | method | p_Vchcode, p_ErrMsg | 2 | 0 |
| `UpdateMasterBalances` | method | p_Raise | 1 | 0 |
| `PostXMLInDataSync` | method | p_VchType, p_Vchcode | 2 | 0 |
| `GetAccMastDataByCode` | method | p_MastCode, p_LoadPartial, p_CheckAcc | 3 | 0 |
| `GetVchConfig` | method | p_VchSeriesCode | 1 | 0 |
| `InitRepOptFields1` | method | p_Repopt, p_PrnRep | 2 | 0 |
| `GetGSTServicesURLForGSPFromGWS` | method | p_ReportType, p_ServiceType, p_GSPCode, p_ForSandBox, p_GetHttpsUrl, p_URL, p_NoStr, p_Date1, p_Date2, p_TmpStr1, p_TmpStr2 | 11 | 0 |
| `GetMasterUDT` | method | p_MastCode, p_Mastertype, p_LoadPartial | 3 | 0 |
| `ShowCompConfigPayroll` | method |  | 0 | 0 |
| `GetDateFromUnivFormatDateStr` | method | p_DateStr | 1 | 0 |
| `SaveVchFromJson` | method | p_VchType, p_JSONStr, p_ErrStr, p_Vchcode, p_ChkIfMobileUser, p_UserName, p_CSUserCol, p_SavedAsCancelled, p_ErrCode | 9 | 0 |
| `GetCompConfigJSON` | method | p_SkipBranchMastLoading, p_FY, p_MultiFY | 3 | 0 |
| `RefineQueryForPGSql` | method | p_Qry | 1 | 0 |
| `RefineQueryForMySql` | method | p_Qry | 1 | 0 |
| `CreateTextFileFromRecordset` | method | p_StrQry, p_TableName, p_Path, p_ErrMsg, p_FY | 5 | 0 |
| `GetTrackingNoListForPrevAndCurrentYear` | method | p_TrackingStatus, p_Vchcode | 2 | 0 |
| `GetBBDetAccWiseForMultiPymtRcpt` | method | p_PendingRefs, p_AccData, p_VchType, p_InputMode, p_VchDate, p_Form, p_Found, p_ForcedToShowWindow | 8 | 0 |
| `GetAppPathForExport` | method |  | 0 | 0 |
| `GetAppPathforImage` | method |  | 0 | 0 |
| `GetVchJSON` | method | p_Vchcode | 1 | 0 |
| `GetMastJSON` | method | p_MasterCode | 1 | 0 |
| `GetVchSeriesConfigJSON` | method | p_Code | 1 | 0 |
| `GetVchSeriesNumberingJSON` | method | p_Code | 1 | 0 |
| `GetPrintingConfigJSON` | method | p_RID | 1 | 0 |
| `GetMastConfigJSON` | method | p_Mastertype | 1 | 0 |
| `GetSNMastJSON` | method | p_VchType, p_Nar1, p_Nar2 | 3 | 0 |
| `GetActualFileNameBONL` | method | p_FileName | 1 | 0 |
| `EnableTriggerForNepal` | method | p_db, p_Con | 2 | 0 |
| `DisableTriggerForNepal` | method | p_db, p_Con | 2 | 0 |
| `GetActualImageFileNameBONL` | method | p_FileName | 1 | 0 |
| `RevertActualImageFileNameBONL` | method | p_FileName | 1 | 0 |
| `ConvertDateNepali2RomanInYYMMDD` | method | p_str | 1 | 0 |
| `GetSoftlockLicenseDet4GWS` | method | p_OCol | 1 | 0 |
| `SaveAccVoucherForBankFeed` | method | p_udtAccVchData, p_ErrMsg, p_ChkAutoBillRefAdj, p_BankCode | 4 | 0 |
| `AddWatermark4DemoOrBLSExp` | method | p_PrnRepEvents, p_LandScape | 2 | 0 |
| `CancelAccVoucherInSalary` | method | p_Vchcode, p_ErrMsg | 2 | 0 |
| `CreateAuditDetEntries` | method | p_Date1, p_Date2, p_lblStatus, p_ErrMsg | 4 | 0 |
| `UpdateMasterApprovalDetails` | method | p_MasterCodeCol, p_MasterTypeCol, p_ApprovalReason, p_ApprovalDetails | 4 | 1 |
| `UpdateMasterRejectionDetails` | method | p_MasterCodeCol, p_MasterTypeCol, p_RejectionStatus, p_RejectionReason, p_RejectionDetails | 5 | 1 |
| `UpdateVoucherRejectionDetails` | method | p_VchcodeCol, p_VchTypeCol, p_RejectionStatus, p_RejectionReason, p_RejectionDetails | 5 | 1 |
| `UpdateVoucherApprovalDetails` | method | p_VchcodeCol, p_VchTypeCol, p_Proceed, ApprovalStatus, p_ApprovalReason, p_ApprovalDetails | 6 | 1 |
| `ModifyStdNar` | method | p_VchType, p_Nar1, p_Nar2 | 3 | 0 |
| `GetPendingRefsUptoDate` | method | p_RecType, p_Date, p_MasterCode1, p_MasterCode2, p_status, p_BranchCode, p_ShowForOtherBranches | 7 | 0 |
| `SaveMobileAppConfig` | method | p_CompConfig, p_ErrMsg | 2 | 0 |
| `ConfigMobileAppSeries` | method | p_SeriesCode | 1 | 0 |
| `GetUserJSONForCloudSync` | method | p_udtUser, p_ErrStr | 2 | 0 |
| `ReIndexingDB` | method | p_YY, p_RestoreCurFY | 2 | 0 |
| `SaveMastFromJson` | method | p_MastType, p_JSONStr, p_ErrStr, p_MAMastCode, p_MastCode, p_ChkIfMobileUser, p_UserName, p_CSUserCol, p_ErrCode | 9 | 0 |
| `SaveCloudSyncUID` | method | p_UID, p_ServiceURL, p_ErrMsg | 3 | 0 |
| `SaveAccMast4BulkCreationByGSTIN` | method | p_AccMast, p_ErrorMsg | 2 | 0 |
| `GetCompList` | method |  | 0 | 0 |
| `ModifyMobileUser` | method |  | 0 | 0 |
| `GetFYStrWithoutCaption` | method | p_Date | 1 | 0 |
| `SaveBDEPConfig` | method | p_BDEPConfig, p_ErrMsg | 2 | 0 |
| `SaveMandiGenConfig` | method | p_CompConfig, p_ErrMsg | 2 | 0 |
| `SaveDataImportExportUserLog` | method | p_MenuConst, p_AddInfo, p_TypeConst, p_AddEventInfo | 4 | 0 |
| `UpdateBONLMode` | method | p_Mode, p_ErrMsg | 2 | 0 |
| `GenerateFPACGrp` | method | p_AcGrp, p_RemainFP | 2 | 0 |
| `SaveCompanyFromXML` | method | p_XML, p_MsgStr, p_Config, p_CopyMast, p_MastConfigUser | 5 | 0 |
| `GetSoftlockLicenseDet4GWSXML` | method |  | 0 | 0 |

## Busy2L21.CMasterServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetMasterLastCode` | method |  | 0 | 0 |
| `MasterNameExist` | method | p_MasterName, p_Mastertype, p_IgnoreAlias, p_ActualMasterName | 4 | 0 |
| `CheckIfUdyamNoExist` | method | p_UdyamNo, p_PartyCode, p_PartyName | 3 | 0 |
| `MasterCodeExist` | method | p_MasterCode | 1 | 0 |
| `MasterName2CodeIfExist` | method | p_MasterName, p_Mastertype, p_IfMultiAlias | 3 | 0 |
| `SeemsToBeServices` | method | p_HSNCode | 1 | 0 |
| `MasterCode2NameIfExist` | method | p_MasterCode | 1 | 0 |
| `MasterCode2Choice` | method | p_MastCode, p_Choice | 2 | 0 |
| `GetParentGrp` | method | p_Code | 1 | 0 |
| `GetParentGrpInGrpCol` | method | p_Code, p_GrpCol | 2 | 0 |
| `IfChild` | method | p_Code, p_Parent | 2 | 0 |
| `IfChildDirect` | method | p_Code, p_Parent | 2 | 0 |
| `IfChildInGrpCol` | method | p_ChildGrpCode, p_ReqParent, p_GrpCol | 3 | 0 |
| `CheckLongArr` | method | p_Val, p_Arr | 2 | 0 |
| `IfChildInArr` | method | p_Code, p_ParentGrps | 2 | 0 |
| `IfChildInArrInGrpCol` | method | p_ChildGrpCode, p_ParentGrps, p_GrpCol | 3 | 0 |
| `IfCash` | method | p_Code | 1 | 0 |
| `IfSaleIncome` | method | p_Code | 1 | 0 |
| `IfPurchaseExpense` | method | p_Code | 1 | 0 |
| `IfStock` | method | p_Code | 1 | 0 |
| `IfFixedAsset` | method | p_Code | 1 | 0 |
| `IfLoansAdvances` | method | p_Code | 1 | 0 |
| `IfCapital` | method | p_Code | 1 | 0 |
| `IfDutiesTaxes` | method | p_Code | 1 | 0 |
| `IfBank` | method | p_Code | 1 | 0 |
| `IfBankOD` | method | p_Code | 1 | 0 |
| `IfExpense` | method | p_Code | 1 | 0 |
| `IfCashBank` | method | p_Code | 1 | 0 |
| `IfParty` | method | p_Code | 1 | 0 |
| `GetPartyCashBankGrpCol` | method |  | 0 | 0 |
| `IfPartyCashBank` | method | p_Code | 1 | 0 |
| `IfLoan` | method | p_Code | 1 | 0 |
| `IfLoanLiability` | method | p_Code | 1 | 0 |
| `IfLoanLiab4TagSch` | method | p_Code | 1 | 0 |
| `IfPartyLoan` | method | p_Code | 1 | 0 |
| `IfPartyLoanWithoutBankOD` | method | p_Code | 1 | 0 |
| `IfPANApplicable` | method | p_Code | 1 | 0 |
| `IfBudgetsApplicable` | method | p_Code | 1 | 0 |
| `IfTargetsApplicable` | method | p_Code | 1 | 0 |
| `IfBillByBillApplicable` | method | p_Code | 1 | 0 |
| `IfCashInGrpCol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfStockInGrpCol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfFixedAssetInGrpCol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfDutiesTaxesInGrpCol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfBankInGrpCol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfExpenseInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfCashBankInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfPartyInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfPartyCashBankInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfLoanInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfPartyLoanInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfBudgetsApplicableInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfTargetsApplicableInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfBillByBillApplicableInGrpcol` | method | p_ChildGrpCode, p_GrpCol | 2 | 0 |
| `IfRevenueAccount` | method | p_GrpCode | 1 | 0 |
| `GetCodesListForFolioUpdation` | method | p_ChildCode, p_GrpCode, p_GrpCol | 3 | 0 |
| `Add2Help2Db` | method | p_MastType, p_FieldType, p_Field | 3 | 0 |
| `MasterCode2Name` | method | p_Code | 1 | 0 |
| `MasterName2Code` | method | p_Name, p_Mastertype | 2 | 0 |
| `MasterName2Alias` | method | p_Name, p_Mastertype | 2 | 0 |
| `GetPrevMaster` | method | p_Name, p_Mastertype | 2 | 0 |
| `GetNextMaster` | method | p_Name, p_Mastertype | 2 | 0 |
| `GetPrevMasterForMSGrp` | method | p_Name, p_RecType, p_MSGrpCode | 3 | 0 |
| `GetNextMasterForMSGrp` | method | p_Name, p_RecType, p_MSGrpCode | 3 | 0 |
| `UnitConExist` | method | p_MainUnitCode, p_SubUnitCode | 2 | 0 |
| `GetUcUnitsFromCode` | method | p_Code, p_MainUnitCode, p_SubUnitCode | 3 | 0 |
| `ControlMaster` | method | p_Code, p_strError | 2 | 0 |
| `GetItemMainUnitName` | method | p_ItemName, p_CheckItemName | 2 | 0 |
| `GetItemAltUnitName` | method | p_Item, CheckItemName | 2 | 0 |
| `ValidItemMainUnit` | method | p_ItemName, p_UnitName, p_CheckItemName, p_ItemMast | 4 | 0 |
| `GetUCFactorForUnit` | method | p_ItemName, p_UnitName, p_ItemMast, p_CheckItemName, p_NoCFFound | 5 | 0 |
| `ValidMasterName` | method | p_Mastertype, p_Name, p_OldName, p_InputMode, p_Code, p_strError | 6 | 0 |
| `TranExistForAccGrp` | method | p_GrpCode, p_Date | 2 | 0 |
| `ValidMasterAlias` | method | p_Mastertype, p_Alias, p_Name, p_OldAlias, p_InputMode, p_strError | 6 | 0 |
| `TranExistForMaster` | method | p_MasterCode, p_strError | 2 | 0 |
| `InvTranExistForMonth` | method | p_MonthNo | 1 | 0 |
| `CanDeleteMaster` | method | p_Mastertype, p_Code, p_ErrMsg | 3 | 0 |
| `IsMasterTaggedWithMobileUser` | method | p_Code, p_Mastertype, p_StrErr | 3 | 0 |
| `IsTranExistForVOFMaster` | method | p_Code, p_Mastertype, p_StrErr | 3 | 0 |
| `IsMasterExistForMOFMaster` | method | p_Code, p_Mastertype, p_StrErr | 3 | 0 |
| `IsMasterTaggedInPayrollConfig` | method | p_Code, p_strError | 2 | 0 |
| `CanAllowDeletionByDataSync` | method | p_Mastertype, p_Code | 2 | 0 |
| `IsMasterTaggedInTriggerOrSelectiveApproval` | method | p_Code, p_strError | 2 | 0 |
| `CanDeleteMasterIfFrozen` | method | p_Mastertype, p_OpBal, p_ErrMsg | 3 | 0 |
| `IfSeemsToBeAsset` | method | p_Code, p_IncludeExpense | 2 | 0 |
| `IfSeemsToBeLiability` | method | p_Code | 1 | 0 |
| `GetCCClosingBals` | method | p_MasterCode, p_Date | 2 | 0 |
| `GetCCOpBals` | method | p_MasterCode, p_Date | 2 | 0 |
| `GetCurrentBalofVch` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_Vchcode, p_BalAlt | 5 | 0 |
| `GetAccClosingBals` | method | p_MasterCode, p_Date, p_BalAlt, p_Vchcode, p_IncludePDC, p_CheckAcc | 6 | 0 |
| `GetAccClosingBalsForVSGrpCode` | method | p_MasterCode, p_Date, p_BalAlt, p_VchSeriesGrpCode, p_Vchcode, p_IncludePDC, p_CCCode | 7 | 0 |
| `GetSubAccClosingBalsForVSGrpCode` | method | p_MasterCode, p_Date, p_BalAlt, p_VchSeriesGrpCode, p_Vchcode, p_IncludePDC | 6 | 0 |
| `GetSubAccClosingBals` | method | p_MasterCode, p_Date, p_BalAlt, p_Vchcode, p_IncludePDC | 5 | 0 |
| `GetAccOpBals` | method | p_MasterCode, p_Date, p_BalAlt, p_IncludePDC | 4 | 0 |
| `GetAccOpBalsForBranch` | method | p_MasterCode, p_BranchCode, p_Date, p_IncludePDC, p_CCCode | 5 | 0 |
| `GetAccOpBalsForVSGrpCode` | method | p_MasterCode, p_Date, p_BalAlt, p_VchSeriesGrpCode, p_IncludePDC | 5 | 0 |
| `GetSubAccOpBals` | method | p_MasterCode, p_Date, p_IncludePDC | 3 | 0 |
| `GetOpBalsFromFolio` | method | p_MasterCode, p_BalAlt, p_BalValue, p_CheckMaster | 4 | 0 |
| `GetItemMCClosingBals` | method | p_ItemCode, p_MCCode, p_Date, p_BalAlt, p_Vchcode | 5 | 0 |
| `GetItemMCOpBals` | method | p_ItemCode, p_MCCode, p_Date, p_BalAlt | 4 | 0 |
| `UpdateItemMCDailyPriceAmt` | method | p_ItemCode, p_MCCode, p_Date | 3 | 0 |
| `GetItemMasterPurcPrice` | method | p_ItemCode | 1 | 0 |
| `GetItemClosingBals` | method | p_ItemCode, p_Date, p_BalAlt | 3 | 0 |
| `GetItemOpBals` | method | p_ItemCode, p_Date, p_BalAlt | 3 | 0 |
| `GetFolioSum` | method | p_MasterCode, p_SaveDb | 2 | 0 |
| `GetAccTranSum` | method | p_AccCode, p_StartDate, p_EndDate, p_VchSeriesGrpCode | 4 | 0 |
| `GetSubAccTranSum` | method | p_AccCode, p_StartDate, p_EndDate, p_VchSeriesGrpCode | 4 | 0 |
| `GetItemTranSum` | method | p_ItemCode, p_MCCode, p_StartDate, p_EndDate, p_AltUnit | 5 | 0 |
| `GetItemTranSumAmt` | method | p_ItemCode, p_MCCode, p_StartDate, p_EndDate | 4 | 0 |
| `GetCcSumFromTrans` | method | p_CCCode, p_StartDate, p_EndDate | 3 | 0 |
| `GetMasterMonthlySumFromDailySum` | method | p_Mastertype, p_MasterCode1, p_MasterCode2, D1, D2, D3, C1, C2, C3 | 9 | 0 |
| `GetMasterSumFromDailySum` | method | p_Mastertype, p_MasterCode1, p_MasterCode2, p_StartDate, p_EndDate | 5 | 0 |
| `GetAccSumFromTrans_1` | method | p_AccCode, p_StartDate, p_EndDate, p_Vchcode, p_VSGrpCode, p_SubAcc | 6 | 0 |
| `GetAccSumFromTrans` | method | p_AccCode, p_StartDate, p_EndDate, p_Vchcode, p_VSGrpCode | 5 | 0 |
| `GetSubAccSumFromTrans` | method | p_AccCode, p_StartDate, p_EndDate, p_Vchcode, p_VSGrpCode | 5 | 0 |
| `GetAccSum` | method | p_AccCode, p_StartDate, p_EndDate, p_IfSubLedger, p_BranchCode | 5 | 0 |
| `GetItemMCSum` | method | p_ItemCode, p_MCCode, p_StartDate, p_EndDate, p_IncludeSPAgainstChallan | 5 | 0 |
| `GetItemSumFromTrans_1` | method | p_ItemCode, p_StartDate, p_EndDate, p_ExcludeStkTfr | 4 | 0 |
| `GetItemSumFromTrans` | method | p_ItemCode, p_StartDate, p_EndDate, p_ExcludeStkTfr | 4 | 0 |
| `GetItemSum` | method | p_ItemCode, p_StartDate, p_EndDate, p_ExcludeStkTfr | 4 | 0 |
| `MasterExistUnderThis` | method | p_Code, p_ChildType | 2 | 0 |
| `AltCurApplicable` | method | p_Code | 1 | 0 |
| `CanChangeOpBal` | method | p_Mastertype, p_strError | 2 | 0 |
| `GetItemOpStockDetailsOnMC` | method | p_ItemCode | 1 | 0 |
| `LoadAllVchSeries` | method | p_CheckOrderProcessOption, p_VchType | 2 | 0 |
| `LoadVchSeries` | method | p_VchType | 1 | 0 |
| `GetAllVchSeriesCodes` | method | p_VchType | 1 | 0 |
| `GetAccAltCurCode` | method | p_AccName | 1 | 0 |
| `GetAccAltCurName` | method | p_AccName, p_CheckAccName | 2 | 0 |
| `FindMastInMastCodes` | method | p_MastCode, p_MastType | 2 | 0 |
| `GetAccMastData` | method | p_AccName, p_LoadPartial, p_CheckAcc, p_Date | 4 | 0 |
| `GetItemMastData` | method | p_ItemName, p_LoadPartial, p_CheckItem, p_Date | 4 | 0 |
| `GetItemMastDataByCode` | method | p_ItemCode, p_LoadPartial, p_CheckItem, p_Date | 4 | 0 |
| `GetItemMastUnitDetailsByCode` | method | p_ItemCode | 1 | 0 |
| `GetItemMastUnitDetailsByItemMast` | method | p_ItemMast | 1 | 0 |
| `GetMCMastDataByCode` | method | p_MCCode, p_CheckMC | 2 | 0 |
| `GetFormMastDataByCode` | method | p_FormCode, p_CheckForm | 2 | 0 |
| `GetMCMastData` | method | p_MCName, p_LoadPartial, p_CheckMC | 3 | 0 |
| `GetGrpMastData` | method | p_GrpName, p_GrpType, p_LoadPartial, p_CheckMC | 4 | 0 |
| `GetContactMastData` | method | p_ContactName, p_LoadPartial, p_CheckContact | 3 | 0 |
| `GetContactMastDataByCode` | method | p_ContactCode, p_CheckCurData | 2 | 0 |
| `GetExecutiveMastData` | method | p_ExecutiveName, p_CheckContact | 2 | 0 |
| `GetExecutiveMastDataByCode` | method | p_ExecutiveCode, p_CheckCurData | 2 | 0 |
| `GetSchemeMastDataByCode` | method | p_SchemeCode, p_CheckCurData | 2 | 0 |
| `GetAuthorMastData` | method | p_AuthorName, p_LoadPartial, p_CheckAuthor | 3 | 0 |
| `GetBrokerMastData` | method | p_BrokerName, p_LoadPartial, p_CheckBroker | 3 | 0 |
| `GetSTPTMastData` | method | p_STPTName, p_MastType, p_LoadPartial, p_CheckST | 4 | 0 |
| `GetSTPTMastDataByCode` | method | p_STPTCode, p_MastType, p_LoadPartial, p_CheckST | 4 | 0 |
| `GetSTPTMastDataFromCol` | method | p_STPTCode, p_CheckST | 2 | 0 |
| `RefreshSTPTMastCol` | method |  | 0 | 0 |
| `GetBSMastData` | method | p_BSName, p_LoadPartial, p_CheckBS | 3 | 0 |
| `GetBSMastDataByCode` | method | p_BSCode, p_LoadPartial, p_CheckBS | 3 | 0 |
| `GetAccMastDataByCode` | method | p_AccCode, p_LoadPartial, p_CheckAcc | 3 | 0 |
| `GetCCMastDataByCode` | method | p_CCCode, p_CheckCC | 2 | 0 |
| `GetBrokerMastDataByCode` | method | p_BrokerCode, p_CheckBroker | 2 | 0 |
| `GetBOMMastData` | method | p_BOMName, p_LoadPartial, p_CheckBOM | 3 | 0 |
| `GetCCMastData` | method | p_CCName, p_LoadPartial, p_CheckCC | 3 | 0 |
| `GetUnitMastData` | method | p_UnitName, p_LoadPartial, p_CheckUnit | 3 | 0 |
| `GetUCMastData` | method | p_Code, p_CheckUC | 2 | 0 |
| `GetFormMastData` | method | p_FormName, p_LoadPartial, p_CheckForm | 3 | 0 |
| `GetCurMastData` | method | p_CurName, p_LoadPartial, p_CheckCur | 3 | 0 |
| `GetVchSeriesDataByCode` | method | p_VSCode, p_CheckVS, p_DontCheckStamp | 3 | 0 |
| `BOMExistForItem` | method | p_ItemCode, p_BOMName | 2 | 0 |
| `UpdateBillingDet` | method | p_AccName, p_STPTMast, p_BillingDet | 3 | 0 |
| `GetGrpBalTotals` | method | p_ParentGrpCode, p_MastType, p_Month, p_GetOpBal | 4 | 0 |
| `GetItemConBalWithDetForVSGrp` | method | p_ItemCode, p_MCCodes, p_VSGrpCode, p_Date, p_BalAlt, p_BalAmt, p_ShowVal, p_SVP, p_SVM | 9 | 0 |
| `GetItemConBalWithDet` | method | p_ItemCode, p_MCCodes, p_Date, p_BalAlt, p_BalAmt, p_OpBal, p_ShowVal, p_SVM, p_SelfValPrice, p_Det | 10 | 0 |
| `GetItemConBal` | method | p_ItemCode, p_MCCodes, p_Date, p_BalAlt, p_BalAmt, p_OpBal, p_ShowVal, p_SVM, p_SelfValPrice | 9 | 0 |
| `GetAllMCForItemTran` | method | p_ItemCode | 1 | 0 |
| `GetAllMC` | method | p_GrpCode, p_BookStockOnly, p_MSGrpCode, p_BranchCode | 4 | 0 |
| `GetMonthClosingBal` | method | p_Code, p_Month, p_BalAlt | 3 | 0 |
| `GetMonthOpeningBal` | method | p_Code, p_Month, p_BalAlt | 3 | 0 |
| `GetOpClosingStockAccWiseFromFolio` | method | p_FinMonth, p_StockAccs, p_StockAmts, p_OpStock | 4 | 0 |
| `GetOpClosingStockForCodeFromFolio` | method | p_Code, p_StartMonth, p_EndMonth, p_OpStock, p_ClosingStock | 5 | 0 |
| `GetStockSummary` | method |  | 0 | 0 |
| `GetOpClosingStockWithDet` | method | p_StartMonth, p_EndMonth, p_OpStock, p_ClosingStock, p_Det, p_PYBals | 6 | 0 |
| `GetOpClosingStockWithDetForBranch` | method | p_BranchCode, p_EndMonth, p_OpStock, p_ClosingStock, p_Det | 5 | 0 |
| `GetClosingStockDateWiseForPLOpBal` | method | p_ClosingStock, p_Det | 2 | 0 |
| `GetClosingStockDateWiseForPLOpBalForCode` | method | p_Code, p_ClosingStock, p_Det | 3 | 0 |
| `GetOpClosingStockWithDetDateWise` | method | p_OpStock, p_ClosingStock, p_Det, p_PYBal | 4 | 0 |
| `GetOpClosingStockWithDetDateWiseForCode` | method | p_Code, p_OpStock, p_ClosingStock, p_Det | 4 | 0 |
| `GetOpClosingStockWithDetType` | method | p_DateWiseMode, p_StartMonth, p_EndMonth, p_OpStock, p_ClosingStock, p_Det | 6 | 0 |
| `GetOpClosingStock` | method | p_StartMonth, p_EndMonth, p_OpStock, p_ClosingStock, p_PYBals | 5 | 0 |
| `GetOpClosingStockForBranch` | method | p_BranchCode, p_EndMonth, p_OpStock, p_ClosingStock | 4 | 0 |
| `CheckForFrozenStockAcc` | method | p_Month, p_ErrStr, p_BranchCode | 3 | 0 |
| `IfClosingStockFreezed` | method | p_Code, p_Month | 2 | 0 |
| `IfClosingStockFreezedForBranch` | method | p_Code, p_Month, p_BranchCode | 3 | 0 |
| `UpdateClosingStock` | method | p_Code, p_StockVals, p_CheckForStockVals | 3 | 0 |
| `UpdateBranchWiseClosingStock` | method | p_BranchStockDetCol, p_BranchCode | 2 | 0 |
| `UpdateBranchWisePLAmount` | method | p_PLAmount, p_Month, p_BranchCode | 3 | 0 |
| `GetBranchClosingStockVal` | method | p_BranchCode, p_MasterCode, p_Month | 3 | 0 |
| `GetBranchPLAmount` | method | p_BranchCode, p_Month | 2 | 0 |
| `GetBranchStockDetCol` | method | p_BranchCode, p_Month | 2 | 0 |
| `GetClosingStockBalWithBranchDet` | method | p_MasterCode | 1 | 0 |
| `GetPLAmountWithBranchDet` | method |  | 0 | 0 |
| `GetBranchMonthWiseClosingStockCol` | method | p_BranchCode | 1 | 0 |
| `GetBranchClosingStockCol2Str` | method | p_BranchStockDetCol | 1 | 0 |
| `GetClosingStockAccDetCol2Str` | method | p_StockAccDetCol | 1 | 0 |
| `GetBranchClosingStockStr2Col` | method | p_str | 1 | 0 |
| `GetClosingStockAccDetStr2Col` | method | p_str | 1 | 0 |
| `UpdateClosingStockFreezeVals` | method | p_Code, p_FreezeStockVals | 2 | 0 |
| `GetMasterTypeFromCode` | method | p_Code | 1 | 0 |
| `GetProperItemUnitName` | method | p_ItemCode, p_IUT | 2 | 0 |
| `GetDirectChildArr` | method | p_Code, p_ChildType, p_FilterOnMSGrp, p_LedgerType, p_MSGrpCode | 5 | 0 |
| `GetAllChildArr` | method | p_Code, p_ChildType, p_ChildSubType, p_ExcludeDeactivate | 4 | 0 |
| `GetGrpDetForBS` | method | p_Code, p_FinMonth | 2 | 0 |
| `GetGrpDetForBSDateWise` | method | p_Code, p_EndDate, p_StartDate, p_ShowBalForPeriod | 4 | 0 |
| `GetGrpDetForBSDateWiseForVSGrpCode` | method | p_Code, p_EndDate, p_StartDate, p_ShowBalForPeriod, p_VchSeriesGrpCode | 5 | 0 |
| `GetGrpDetForPL` | method | p_Code, p_StartMonth, p_EndMonth | 3 | 0 |
| `GetGrpDetForBSForType` | method | p_DateWiseMode, p_Code, p_EndMonth, p_EndDate, p_StartDate, p_ShowBalForPeriod, p_StartMonth | 7 | 0 |
| `GetGrpDetForBSForBranch` | method | p_Code, p_BranchCode, p_EndDate, p_StartDate, p_ShowBalForPeriod | 5 | 0 |
| `GetGrpDetForBSDateWiseForBranch` | method | p_Code, p_EndDate, p_StartDate, p_ShowBalForPeriod, p_BranchCode | 5 | 0 |
| `GetOpClosingCashBankBals` | method | p_StartMonth, p_EndMonth, p_OpBal, p_ClosingBal | 4 | 0 |
| `GetMastConfig` | method | p_MastType, p_LoadFromDB | 2 | 0 |
| `GetMastConfigJSON` | method | p_MastType | 1 | 0 |
| `GetSTPTMastType` | method | p_VchType, p_Trantype | 2 | 0 |
| `GetAllBOMForItem` | method | p_ItemCode, p_BOMNames, p_BOMCodes | 3 | 0 |
| `SeriesExistForVch` | method | p_SeriesCode, p_VchType | 2 | 0 |
| `DeleteMasterRecord` | method | p_Code | 1 | 0 |
| `DeleteFolioRec` | method | p_Code | 1 | 0 |
| `DeleteDailySumRec` | method | p_Code | 1 | 0 |
| `DeleteFromTran10` | method | p_Code | 1 | 0 |
| `GetActualMasterName` | method | p_NameAlias, p_MastType, p_IfFoundInMultipleAlias | 3 | 0 |
| `UpdateAllGrpList` | method |  | 0 | 0 |
| `UpdateGrpList` | method | p_Col, p_GrpType | 2 | 0 |
| `RefreshGrpList` | method | p_GrpType | 1 | 0 |
| `GetGrpList` | method | p_GrpType | 1 | 0 |
| `GetAllParentsInGrpCol` | method | p_GrpCode, p_IncludeCurrent, p_GrpCol | 3 | 0 |
| `GetAllBankGrpsCol` | method | p_GrpCol | 1 | 0 |
| `GetAllChildsInGrpCol` | method | p_GrpCode, p_IncludeCurrent, p_GrpCol | 3 | 0 |
| `GetAllChildsFromDataBase` | method | p_GrpCode, p_IncludeCurrent, p_ChildType | 3 | 0 |
| `GetParentMasterType` | method | p_ChildType | 1 | 0 |
| `GetAllChildQryStrForParentGrps` | method | p_GrpCodes, p_ChildMasterType, p_DirectChildOnly | 3 | 0 |
| `GetAllChildQryStr` | method | p_GrpCode, p_ChildMasterType, p_DirectChildOnly, p_LedgerType | 4 | 0 |
| `GetAllChildQryStr4TariffHead` | method | p_TariffHead, p_GrpCode, p_DirectChildOnly | 3 | 0 |
| `GetAllChildQryStrForSubLedger` | method | p_GrpCode, p_ChildMasterType, p_DirectChildOnly | 3 | 0 |
| `GetItemGrpValue` | method | p_GrpCode, p_Date, p_MCCode, p_OpTrial, p_BookStockOnly, p_DirectChildOnly, p_BalMain, p_BalAlt, p_MCCodes, p_DoNotMaintainStkBal, p_ShowVal | 11 | 0 |
| `GetItemGrpValueForVSGrp` | method | p_GrpCode, p_Date, p_MCCode, p_OpTrial, p_BookStockOnly, p_DirectChildOnly, p_BalMain, p_BalAlt, p_VSGrpCode, p_MCCodes, p_DoNotMaintainStkBal, p_ShowVal | 12 | 0 |
| `GetItemValue` | method | p_ItemCode, p_Date, p_MCCode, p_OpTrial, p_SVP, p_SVM, p_BookStockOnly, p_MainQty, p_AltQty, p_MCCodes, p_MSGrpCode, p_ShowVal | 12 | 0 |
| `GetPIRPrice1` | method | p_VchType, p_ItemCode, p_IgrpCode, p_PartyCode, p_PartyGrpCode, p_PricingInfo, p_Date, p_CheckBranch | 8 | 0 |
| `GetIQDPrice` | method | p_VchType, p_ItemCode, p_IgrpCode, p_Qty, p_Date, p_PricingInfo | 6 | 0 |
| `GetItemMCFolioSum` | method | p_MasterCode, p_MCCode, p_Mastertype, p_BranchCode | 4 | 0 |
| `GetItemMCFolioSumForNepaliDate` | method | p_MasterCode, p_MCCode, p_Mastertype, p_BranchCode | 4 | 0 |
| `GetTDSMastDataByCode` | method | p_TDSCode, p_CheckAcc | 2 | 0 |
| `GetVchSeriesStampFromCode` | method | p_VSCode | 1 | 0 |
| `GetMastStampNameFromCode` | method | p_Code, p_MastName | 2 | 0 |
| `GetMastStampCodeFromName` | method | p_MastType, p_MastName, p_Code, p_Stamp | 4 | 0 |
| `CheckFBT` | method | p_Code | 1 | 0 |
| `ConversionExistForThisDate` | method | p_Date | 1 | 0 |
| `IfBillByBillApplicableInAccMast` | method | p_AccCode | 1 | 0 |
| `GetAccNameMailMobileStr` | method | p_Code, p_Name, p_IncludeWhatsAppNo | 3 | 0 |
| `GetAccNameMailMobileStr1` | method | p_Name, p_EMail, p_Mobile | 3 | 0 |
| `GetEmpNameMailMobileStr` | method | p_Code, p_Name | 2 | 0 |
| `GetEmpNameMailMobileStr1` | method | p_Name, p_EMail, p_Mobile | 3 | 0 |
| `GetEMailIDofMasterFromCode` | method | p_Code | 1 | 0 |
| `GetMobileofMasterFromCode` | method | p_Code, p_AllMobNumbers, p_GetWhatsAppNos | 3 | 0 |
| `GetFirstMobileNoFromMobileStr` | method | p_MobileStr | 1 | 0 |
| `UpdateEMailIDofMaster` | method | p_Name, p_ForEMail, p_EMailID, p_Mobile, p_ErrMsg, p_MastType, p_UpdateWhatsAppAlso | 7 | 0 |
| `UpdateEmailIDofExecutiveMaster` | method | p_Name, p_ForEMail, p_EMailID, p_Mobile, p_ErrMsg | 5 | 0 |
| `UpdateEmailIDofContactMaster` | method | p_Name, p_ForEMail, p_EMailID, p_Mobile, p_ErrMsg | 5 | 0 |
| `UpdateEMailIDofAccMaster` | method | p_Name, p_ForEMail, p_EMailID, p_Mobile, p_ErrMsg, p_UpdateWhatsAppNoAlso | 6 | 0 |
| `UpdateEMailIDofBrokerMaster` | method | p_Name, p_ForEMail, p_EMailID, p_Mobile, p_ErrMsg | 5 | 0 |
| `GetNearestCurConRate` | method | p_CurDet, p_Date, p_Code | 3 | 0 |
| `GetMastersCol` | method | p_Mastertype, p_MSGrpCode | 2 | 0 |
| `GetCurMastDataByCode` | method | p_CurCode, p_CheckCurData | 2 | 0 |
| `GetCurConMastDataByCode` | method | p_CurCode, p_CheckCurData | 2 | 0 |
| `GetCurConMastDataByDate` | method | p_CurName, p_CheckCur | 2 | 0 |
| `MasterAlias2Name` | method | p_Alias, p_Mastertype | 2 | 0 |
| `MasterAlias2Code` | method | p_Alias, p_Mastertype | 2 | 0 |
| `MasterCode2Alias` | method | p_Code, p_Mastertype | 2 | 0 |
| `GetMasterAddressInfo` | method | p_MastCode | 1 | 0 |
| `GetFormTypeFromFormName` | method | p_FormName | 1 | 0 |
| `GetAllCurrencyList` | method | p_IncludeBaseCur | 1 | 0 |
| `GetAccClosingBalForBranchAndCur` | method | p_MasterCode, p_BranchCode, p_CurCode, p_Date, p_BaseCurBal, p_Vchcode, p_CheckBranchWiseFlagInAccMast, p_CCCode | 8 | 0 |
| `GetAccClosingBalForBranch` | method | p_MasterCode, p_BranchCode, p_Date, p_Vchcode, p_CheckBranchWiseFlagInAccMast, p_IncludePDC, p_CCCode | 7 | 0 |
| `GetAccClosingBalForCur` | method | p_MasterCode, p_CurCode, p_Date, p_BaseCurBal, p_Vchcode, p_VchSeriesGrpCode, p_CCCode | 7 | 0 |
| `GetAccClosingBalWithBranchAndCurDet` | method | p_MasterCode, p_Date, p_BranchAndCurDet, p_Vchcode | 4 | 0 |
| `GetAccClosingBalWithCurDetForBranch` | method | p_MasterCode, p_Date, p_BranchAndCurDet, p_BranchCode, p_Vchcode, p_CCCode | 6 | 0 |
| `GetAccClosingBalWithCurDet` | method | p_MasterCode, p_Date, p_CurDet, p_Vchcode, p_VchSeriesGrpCode, p_CCCode | 6 | 0 |
| `GetAccClosingBalWithBranchDet` | method | p_MasterCode, p_Date, p_BranchDet, p_Vchcode | 4 | 0 |
| `GetSubAccClosingBalWithBranchAndCurDet` | method | p_MasterCode, p_Date, p_BranchAndCurDet, p_Vchcode | 4 | 0 |
| `GetSubAccClosingBalWithCurDet` | method | p_MasterCode, p_Date, p_CurDet, p_Vchcode, p_VchSeriesGrpCode | 5 | 0 |
| `GetSubAccClosingBalWithBranchDet` | method | p_MasterCode, p_Date, p_BranchDet, p_Vchcode | 4 | 0 |
| `CheckMultiCurrency` | method | p_MasterCode | 1 | 0 |
| `CheckMultiBranchOpBals` | method | p_MasterCode | 1 | 0 |
| `GetAccOpBalForBranchAndCur` | method | p_MasterCode, p_BranchCode, p_CurCode, p_Date, p_BaseCurBal, p_Vchcode | 6 | 0 |
| `GetAccOpBalForCur` | method | p_MasterCode, p_CurCode, p_Date, p_BalBase, p_Vchcode | 5 | 0 |
| `GetCurOpBalFromTran4` | method | p_MasterCode, p_CurCode, p_BalBase | 3 | 0 |
| `GetBranchOpBalFromTran4` | method | p_MasterCode, p_BranchCode, p_CheckBranchWiseFlagInAccMast | 3 | 0 |
| `GetBranchAndCurOpBalFromTran4` | method | p_MasterCode, p_CurCode, p_BranchCode, p_BalBase, p_CheckBranchWiseFlagInAccMast | 5 | 0 |
| `GetAccSumForCur` | method | p_MasterCode, p_CurCode | 2 | 0 |
| `GetAccSumCurWiseForNepaliDate` | method | p_MasterCode, p_CurCode | 2 | 0 |
| `GetAccGrpClosingBalDateWise` | method | p_GrpCode, p_EndDate, p_PYBal | 3 | 0 |
| `GetAccGrpClosingBalDateWiseForBranch` | method | p_GrpCode, p_BranchCode, p_EndDate, p_DirectChildOnly | 4 | 0 |
| `CheckIfStockAccTaggedInBranch` | method | p_Code, p_BranchCode | 2 | 0 |
| `GetAccGrpClosingBalDateWiseForVSGrpCode` | method | p_GrpCode, p_EndDate, p_VchSeriesGrpCode | 3 | 0 |
| `GetAccClosingBalDateWise` | method | p_AccCode, p_EndDate | 2 | 0 |
| `GetAccClosingBalDateWiseForBranch` | method | p_AccCode, p_BranchCode, p_EndDate | 3 | 0 |
| `GetAccClosingBalDateWiseForVSGrpCode` | method | p_AccCode, p_EndDate, p_VchSeriesGrpCode | 3 | 0 |
| `GetAccClosingBalType` | method | p_DateWise, p_AccCode, p_Month, p_RepDate | 4 | 0 |
| `GetAccOpeningBalType` | method | p_DateWise, p_AccCode, p_Month, p_RepDate, p_StartDate | 5 | 0 |
| `GetAccOpeningClosingBalType` | method | p_DateWise, p_AccCode, p_EndMonth, p_EndDate, p_OpBal, p_ClBal, p_StartDate, p_StartMonth | 8 | 0 |
| `GetAccOpeningBalDateWise` | method | p_AccCode, p_StartDate | 2 | 0 |
| `GetAccOpeningClosingBalDateWise` | method | p_AccCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate | 5 | 0 |
| `GetAccOpeningClosingBalDateWiseForBranch` | method | p_AccCode, p_BranchCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate | 6 | 0 |
| `GetAccOpeningClosingBalDateWiseForVSGrpCode` | method | p_AccCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate, p_VchSeriesGrpCode | 6 | 0 |
| `GetAccGrpClosingBalType` | method | p_DateWiseMode, p_Code, p_Month, p_RepDate, p_PYBal | 5 | 0 |
| `GetAccGrpPYBalType` | method | p_Code | 1 | 0 |
| `GetAccGrpOpeningClosingBalType` | method | p_DateWiseMode, p_Code, p_EndMonth, p_EndDate, p_OpBal, p_ClBal, p_StartDate, p_StartMonth, p_PYBal | 9 | 0 |
| `GetAccGrpOpeningClosingBalDateWise` | method | p_GrpCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate, p_PYBal | 6 | 0 |
| `GetAccGrpOpeningClosingBalDateWiseForBranch` | method | p_GrpCode, p_BranchCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate | 6 | 0 |
| `GetAccGrpOpeningClosingBalDateWiseForVSGrpCode` | method | p_GrpCode, p_EndDate, p_OpBal, p_ClBal, p_StartDate, p_VchSeriesGrpCode | 6 | 0 |
| `GetAccGrpBalances` | method | p_GrpCode, p_StartDate, p_EndDate, p_OpBal, p_DebitBal, p_CreditBal, p_DirectChild, p_VSGrpCode | 8 | 0 |
| `GetAccGrpBalancesForBranch` | method | p_GrpCode, p_BranchCode, p_StartDate, p_EndDate, p_OpBal, p_DebitBal, p_CreditBal, p_DirectChild | 8 | 0 |
| `GetAccBalancesForBranchAndCur` | method | p_AccCode, p_BranchCode, p_CurCode, p_StartDate, p_EndDate | 5 | 0 |
| `GetAccGrpOpeningBalDateWise` | method | p_GrpCode, p_Date, p_PYBal | 3 | 0 |
| `GetAccGrpOpeningBalDateWiseForBranch` | method | p_GrpCode, p_BranchCode, p_Date | 3 | 0 |
| `GetAccGrpOpeningBalDateWiseForVSGrpCode` | method | p_GrpCode, p_Date, p_VchSeriesGrpCode | 3 | 0 |
| `GetOpeningClosingStockDateWise` | method | p_OpStock, p_ClosingStock, p_UsedForPLOpBal, p_PYBals | 4 | 0 |
| `GetOpeningClosingStockType` | method | p_DateWiseMode, p_EMonth, p_OpeningStock, p_ClosingStock, p_SMonth, p_UsedForPLOpBal, p_PYBals | 7 | 0 |
| `UpdateClosingStockDateWiseForPLOpBal` | method | p_Code, p_StockVal | 2 | 0 |
| `UpdateClosingStockDateWise` | method | p_Code, p_StockVal | 2 | 0 |
| `UpdateOpeningStockDateWise` | method | p_Code, p_StockVal | 2 | 0 |
| `ResetTmpOpClosingStockValue` | method | p_ToResetOpeningValue | 1 | 0 |
| `TaggedUnderSeriesGroup` | method | p_MasterCode, p_strError | 2 | 0 |
| `MSGrpTaggedUnderUser` | method | p_MasterCode, p_strError | 2 | 0 |
| `LoadRefGroupNameCol` | method | p_Mastertype | 1 | 0 |
| `GetQueryOnTranTableForMasterControlInReporting` | method | p_TableAliasWithDot, p_QueryOnMaster1 | 2 | 0 |
| `AutoGenPrintName` | method | p_Name, p_Alias, p_GrpName, p_GrpMastType, p_udtOF, p_udtMastConfig | 6 | 0 |
| `IfMasterImageFolderChanged` | method | p_Mastertype, p_ImagePath | 2 | 0 |
| `IfMasterAddnInfoEnabled` | method | p_MastType | 1 | 0 |
| `GetAllUserNameCol` | method | p_LoggedInUser | 1 | 0 |
| `GetMasterAdditionalInfoStr` | method | p_AddnInfo, p_MastConfig | 2 | 0 |
| `MasterAlias2CodeIfExist` | method | p_Alias, p_Mastertype | 2 | 0 |
| `CreateDefaultNotesCategory` | method | p_User | 1 | 0 |
| `GetAllMasterInMSGrpQryStr` | method | p_MSCode, p_Mastertype | 2 | 0 |
| `GetAllMasterInMSGrp` | method | p_MSCode, p_Mastertype | 2 | 0 |
| `GetMasterSeriesGrpCodeForCurUser` | method |  | 0 | 0 |
| `TagMasterSeriesGrpCodeForCurUser` | method |  | 0 | 0 |
| `GetVchSeriesGrpCodeForCurUser` | method |  | 0 | 0 |
| `GetVSGrpColForCurUser` | method |  | 0 | 0 |
| `GetAllVSGrpTaggedWithBranch` | method | p_BranchCode | 1 | 0 |
| `GetAllVSGrpTaggedWithBranchCodeCol` | method | p_BranchCode | 1 | 0 |
| `GetMSGrpColForCurUser` | method |  | 0 | 0 |
| `GetAllMSGrpTaggedWithBranch` | method | p_BranchCode | 1 | 0 |
| `GetAllMSGrpTaggedWithBranchCodeCol` | method | p_BranchCode | 1 | 0 |
| `IfVSGrpBelongs2RestrictedUser` | method | p_VSGrpCode | 1 | 0 |
| `IfVchSeriesBelongs2RestrictedUser` | method | p_VSGrpCode | 1 | 0 |
| `GetAllVchSeriesCodeColForVSGrp` | method | p_VSGrpCode | 1 | 0 |
| `DisableMasterSeriesGrpOnReporting` | method |  | 0 | 0 |
| `DisableVchSeriesGrpOnReporting` | method |  | 0 | 0 |
| `GetAllMasterSeriesGrpColByMasterCode` | method | p_MasterCode, p_Mastertype | 2 | 0 |
| `MasterCode2NameFromMaster1IfExist` | method | p_Code | 1 | 0 |
| `CreateDefaultMaster` | method | p_Mastertype, p_MasterName, p_GrpCode, p_DefaultMastCode, p_AddInfo, p_Source | 6 | 0 |
| `CheckSourceNameTargetAliasConflict` | method | p_MastType, p_SourceName | 2 | 0 |
| `UpdateItemTaxInfoFromTaxCatInfo` | method | p_ItemMast, p_TaxInfo, p_GSType | 3 | 0 |
| `UpdateHSNOnSpecificDate` | method | p_ItemMast, p_Date | 2 | 0 |
| `UpdateAccHSNOnSpecificDate` | method | p_AccMast, p_Date | 2 | 0 |
| `GetHSNOnSpecificDate` | method | p_ItemMast, p_Date | 2 | 0 |
| `GetAccHSNOnSpecificDate` | method | p_AccMast, p_Date | 2 | 0 |
| `GetUpdatedItemMastTaxRatesDateWise` | method | p_ItemMast, p_Date | 2 | 0 |
| `GetTaxRatesOnSpecificDate` | method | p_TaxInfoCol, p_Date, p_RecentEntry | 3 | 0 |
| `LoadAllTaxCategories` | method |  | 0 | 0 |
| `MakeBranchMCInfoStr` | method | p_Col, p_NewMCStr | 2 | 0 |
| `GetAllMCListForBranch` | method | p_str | 1 | 0 |
| `MakeBranchInfoStr` | method | p_BranchDet | 1 | 0 |
| `GetOfflineDetailsStr` | method | p_BranchDet | 1 | 0 |
| `ReadBranchDetStr` | method | p_str, p_udtBranchInfo | 2 | 0 |
| `GetBranchMastFldVal` | method | p_Col, p_FldID | 2 | 0 |
| `CheckIfTaxCategoryHeadOfficeEntryExist` | method | p_TaxCatName | 1 | 0 |
| `UpdateMastDailySum` | method | p_DailySum | 1 | 0 |
| `UpdateMastDailySumForYear` | method | p_MasterCode1, p_MasterCode2, p_Mastertype | 3 | 0 |
| `UpdateFolioFromTran` | method | p_MasterCode1, p_Mastertype, p_GLType | 3 | 0 |
| `GetItemOpBalForTaggedMC` | method | p_ItemCode, p_MCCodes, p_Date, p_AltBal | 4 | 0 |
| `FilterMastersForMSGrp` | method | p_Col, p_MSGrpCode, p_Mastertype, p_IfUsedForCC | 4 | 0 |
| `FilterBranchMCCodesCol` | method | p_Col, p_BranchCode | 2 | 0 |
| `CheckForGeneralLedgerByCode` | method | p_LedgerCode | 1 | 0 |
| `CheckForGeneralLedgerByName` | method | p_LedgerName | 1 | 0 |
| `IfAnySLExist` | method |  | 0 | 0 |
| `CanChangeLedgerType` | method | p_AccCode, p_NameStr | 2 | 0 |
| `IfTranExistForSL` | method | p_AccCode, p_NameStr | 2 | 0 |
| `LoadBrachMastersForDataSync` | method | p_AllBranchCol | 1 | 0 |
| `GetGLCodeForSubLedger` | method | p_LedgerName | 1 | 0 |
| `GetSLMastListForGL` | method | p_GLCode | 1 | 0 |
| `GetMasterBlockedStatusAndNotesByName` | method | p_MastType, p_Name, p_Notes | 3 | 0 |
| `GetMasterBlockedStatusAndNotesByCode` | method | p_Code, p_Notes, p_BlockedVchtypeCol | 3 | 0 |
| `GetMasterNotesByCode` | method | p_Code | 1 | 0 |
| `FilterMasterCodesColForMSGrp` | method | p_Col, p_MSGrpCode, p_Mastertype | 3 | 0 |
| `CreateDefaultItemGroupMaster` | method |  | 0 | 0 |
| `CreateDefaultUnitMaster` | method |  | 0 | 0 |
| `GetVchSeriesGrpCodeForBranch` | method | p_BranchCode | 1 | 0 |
| `GetVchSeriesCodesForBranch` | method | p_BranchCode | 1 | 0 |
| `GetMCCodesForBranch` | method | p_BranchCode, p_BookStockOnly | 2 | 0 |
| `GetMastSeriesGrpCodeForBranch` | method | p_BranchCode | 1 | 0 |
| `GetMCCodesForBranchWithMastSerGrp` | method | p_BranchCode, p_MastSerGrpCode, p_BookStockOnly | 3 | 0 |
| `GetBranchCodeForCurUser` | method |  | 0 | 0 |
| `IfBranchTaggedInAnyUser` | method | p_BranchCode, p_UserName | 2 | 0 |
| `LoadDataFromMemoFldForEmpMaster` | method | p_Code | 1 | 0 |
| `BreakMemoStrIntoCol` | method | p_str, p_ValCol | 2 | 0 |
| `GetFldValFromMemoCol` | method | p_Col, p_FId | 2 | 0 |
| `AddFieldForMemoField` | method | p_FldID, p_Val | 2 | 0 |
| `GetOFRecTypeMastType` | method | p_MastVchType, p_OFNo, p_RecType, p_MastType, p_H2RecType, p_IsVch | 6 | 0 |
| `UpdateMasterOptionalFieldsVals` | method | p_MastConfig, p_MastAddInfo | 2 | 0 |
| `UpdateVchOptionalFieldsVals` | method | p_VchConfig, p_VchOtherInfo | 2 | 0 |
| `GetMasterOptionalFieldsVals` | method | p_MastConfig, p_MastAddInfo | 2 | 0 |
| `GetVchOptionalFieldsVals` | method | p_VchConfig, p_VchOtherInfo | 2 | 0 |
| `CheckMasterOFForQueryOnOperators` | method | p_QOF, p_MastCode | 2 | 0 |
| `GetMAIStrForMOF` | method | p_udtMastConfig, p_udtQOF | 2 | 0 |
| `GetMasterOFNamesForRepOptions` | method | p_MastConfig | 1 | 0 |
| `IfPureMastersExists` | method | p_MastType | 1 | 0 |
| `MastersExistsForMOF` | method | p_MastType, p_OFNo | 2 | 0 |
| `GetOFNoFromOFName` | method | p_OFName, p_MastConfig | 2 | 0 |
| `GetOptionalFieldQryStr` | method | p_OFMastCode, p_OFNo, p_FldName | 3 | 0 |
| `CheckIfMastConfigExistsForMOF` | method | p_MastType | 1 | 0 |
| `CheckIfRecordExistsForVOI` | method | p_VchType, p_VSCode | 2 | 0 |
| `CheckIfVchConfigExistsForVOF` | method | p_VSCode | 1 | 0 |
| `GetAccTaxType` | method | p_AccCode | 1 | 0 |
| `IfDashBoardConfigured` | method | p_UserName | 1 | 0 |
| `GetTaxCategoryByCode` | method | p_Code, p_Check | 2 | 0 |
| `GetItemValueForVSGrp` | method | p_ItemCode, p_Date, p_OpTrial, p_SVP, p_SVM, p_MainQty, p_AltQty, p_VSGrpCode, p_MCCodes, p_ShowVal | 10 | 0 |
| `InitFolio` | method |  | 0 | 0 |
| `GetMastersNameAndAliasCol` | method | p_Mastertype, p_MSGrpCode | 2 | 0 |
| `FilterSelectedMCCodesForBranchMCs` | method | p_McCol, p_BranchCode | 2 | 0 |
| `GetDiscStructFromItemMaster` | method | p_Col, p_Date | 2 | 0 |
| `GetLastDateDiscStrucForNextFinYr` | method | p_Col | 1 | 0 |
| `CheckIfMCTaggedInBranch` | method | p_BranchCode, p_BookStockOnly | 2 | 0 |
| `GetAccReconcileBal` | method | p_MasterCode, p_Date, p_EndDate, p_BalAlt, p_ReconStatusFlag, p_db, p_Con, p_Vchcode, p_CCCode | 9 | 0 |
| `UpdateDiscStructInItemMast` | method | p_Col, p_udtData | 2 | 0 |
| `LoadDiscStructures` | method | p_Mastertype | 1 | 0 |
| `GetEmpSalaryMode` | method | p_Code | 1 | 0 |
| `GetMultiPricesForSpecificDate` | method | p_Col, p_Date | 2 | 0 |
| `GetMultiPricesForDate` | method | p_Col, p_Date | 2 | 0 |
| `GetUpdatedItemMastMultiPricesDateWise` | method | p_ItemMast, p_Date | 2 | 0 |
| `GetBranchPricesForSpecificDate` | method | p_Col, p_Date | 2 | 0 |
| `UpdateMultiPricesInItemMast` | method | p_Col, p_udtData | 2 | 0 |
| `UpdateBranchWisePricesInItemMast` | method | p_ColCurYr, p_ColPrevYr | 2 | 0 |
| `GetSubAccClosingBalForBranchAndCur` | method | p_MasterCode, p_BranchCode, p_CurCode, p_Date, p_BaseCurBal, p_Vchcode, p_CheckBranchWiseFlagInAccMast | 7 | 0 |
| `GetSubAccClosingBalForBranch` | method | p_MasterCode, p_BranchCode, p_Date, p_Vchcode, p_CheckBranchWiseFlagInAccMast, p_IncludePDC | 6 | 0 |
| `GetSubAccClosingBalForCur` | method | p_MasterCode, p_CurCode, p_Date, p_BaseCurBal, p_Vchcode, p_VchSeriesGrpCode | 6 | 0 |
| `DateWiseEntryExistInCol` | method | p_Col | 1 | 0 |
| `GetDateWisePricesForSpecificDate` | method | p_Col | 1 | 0 |
| `FilterDataBranchWise` | method | p_Col | 1 | 0 |
| `GetUpdatedItemMastDateWisePricing` | method | p_ItemMast, p_Date | 2 | 0 |
| `InitudtBranchWisePricingInfo` | method | p_udt | 1 | 0 |
| `GetCCClosingBalAccWise` | method | p_MasterCode, p_Date, p_CurDet | 3 | 0 |
| `GetUCFactorBetweenUnitsWRTBOM` | method | p_ItemName, p_TranUnitName, p_BOMUnitName, p_ItemMast, p_CheckItemName | 5 | 0 |
| `GetBillRefGrpInItemGrp` | method | p_ItemGrpCode, p_CreditdaysPurc, p_creditdaysSale | 3 | 0 |
| `GetBillRefGrpInMC` | method | p_MCCode, p_CreditDaySale, p_CreditdayPurc | 3 | 0 |
| `GetCCBalNonRev` | method | p_CCCode, p_ExportDateStr | 2 | 0 |
| `GetCCBalRev` | method | p_CCCode, p_ExportDateStr | 2 | 0 |
| `GetAllVchSeriesConfigCol` | method | p_VchSeriesCodeCol | 1 | 0 |
| `CheckForPOSConfigWithStdConfig` | method | p_HOStdConfigCol | 1 | 0 |
| `MasterName2PrintName` | method | p_Name, p_Mastertype | 2 | 0 |
| `GetSchemeMastData` | method | p_SchemeName, p_LoadPartial, p_CheckScheme | 3 | 0 |
| `CheckCountryBelongsToSouthAsiaBeforeLogin` | method | p_CompCode, p_ErrMsg, p_CompName | 3 | 0 |
| `ChangeCountryBeforeLogin` | method | p_CountryCode, p_ErrMsg | 2 | 0 |
| `InitUdtMastConfig` | method | p_MastConfig | 1 | 0 |
| `GetMastAddnInfoBtStr` | method | p_MastType, p_MastConfig, p_MastData, p_MultiAliasName | 4 | 0 |
| `GetAllMCTaggedWithStkAcc` | method | p_StkAccCode | 1 | 0 |
| `GetCallsToBeHandleForExecutive` | method | p_Code | 1 | 0 |
| `GetItemMCCriticalLevelVal` | method | p_ItemCode, p_MCCode, p_Value, p_MinMaxReorder | 4 | 0 |
| `SchemeCode2Type` | method | p_SchemeCode | 1 | 0 |
| `GetMasterXML` | method | p_MastCode, p_LoadPartial | 2 | 0 |
| `GetMasterJSON` | method | p_MastCode | 1 | 0 |
| `GetLastDatePricesFromItemMastForAllBranches` | method | p_ItemCode | 1 | 0 |
| `GetUniqueMCCodesForItemBals` | method | p_ItemCode | 1 | 0 |
| `GetBrokerMobNoFromAccCode` | method | p_AccCode, p_WhatsAppNo, p_BrokerCode, p_BrokerEmail | 4 | 0 |
| `GetBrokerMobNoFromVchCode` | method | p_Vchcode, p_WhatsAppNo, p_BrokerCode, p_BrokerEmail | 4 | 0 |
| `GetBrokerEmailIDFromAccCode` | method | p_AccCode | 1 | 0 |
| `GetBrokerEmailIDFromVchCode` | method | p_Vchcode | 1 | 0 |
| `GetBrokerEmailIDFromVch` | method | p_VchType, p_Vchcode, p_PartyCode | 3 | 0 |
| `GetBrokerMobNoFromVch` | method | p_VchType, p_Vchcode, p_PartyCode, p_WhatsAppNo, p_BrokerCode, p_BrokerEmail | 6 | 0 |
| `ExpiryDateSpecifiedInItemMast` | method | p_ItemCode | 1 | 0 |
| `PIRMode2FullName` | method | p_PIR_Mode | 1 | 0 |
| `PIRFullName2Mode` | method | p_PIR | 1 | 0 |
| `GetDetailsFromMultipleAliasofItem` | method | p_ItemCode, p_Alias | 2 | 0 |
| `GetDetailsFromMultipleAliasofAccount` | method | p_AccCode, p_Alias | 2 | 0 |
| `GetOpeningBalFromCostCentre` | method | p_MasterCode, p_CCCode | 2 | 0 |
| `CheckIfStockAccTaggedInIGRP` | method | p_StockAccCode | 1 | 0 |
| `CheckIfStockAccTaggedInTaxCat` | method | p_StockAccCode | 1 | 0 |
| `CheckIfStockAccTaggedInMC` | method | p_StockAccCode | 1 | 0 |
| `ReplaceSLEntryWithGL` | method | p_AccCol, p_SubLedgerCol | 2 | 0 |
| `StateCode2TinDigit` | method | p_StateCode | 1 | 0 |
| `TinDigit2StateCode` | method | p_TinDigit | 1 | 0 |
| `StateName2TinDigit` | method | p_StateName | 1 | 0 |
| `GetStateLocType` | method | p_StateCode | 1 | 0 |
| `GetStateLocTypeForOutsideIndia` | method | p_CountryCode | 1 | 0 |
| `UpdateAccBals` | method | p_AccCode, p_Date | 2 | 0 |
| `GetAllTaxRatesCol` | method |  | 0 | 0 |
| `GetSTPTVATGSTType` | method | p_MastCode | 1 | 0 |
| `CheckIfTaxratesSwapped` | method | p_ItemMast | 1 | 0 |
| `GetAllPTMastCodeCol` | method |  | 0 | 0 |
| `GetTaxRateFromTaxCategoryCode` | method | p_TaxCatCode, p_IGSTRate, p_CGSTRate, p_SGSTRate, p_CessRateLoc, p_CenCessRate, p_AddCessRate, p_CessBasis, p_AddCessBasis | 9 | 0 |
| `GetAccTaxCatCodeAndHSNCode` | method | p_AccCode, p_HSNCode, p_TaxCatCode, p_DateForHSN, p_InputType | 5 | 0 |
| `GetItemHSNCodeOnSpecificDateFromCode` | method | p_Code, p_Date | 2 | 0 |
| `GetDateWiseHSNCol` | method | p_Code, p_Mastertype, p_RecType | 3 | 0 |
| `GetSLDataOfMaster` | method | p_Code | 1 | 0 |
| `GetTDSBSOthers` | method |  | 0 | 0 |
| `GetTDSNonSalaryAccounts` | method |  | 0 | 0 |
| `GetBillRefStatusFromVchCode` | method | p_Vchcode, p_NewRefAmt, p_AdjAmt | 3 | 0 |
| `ValidMobileUserPassword` | method | p_Name, p_Password | 2 | 0 |
| `GetMobileUserRightsJSONstr` | method | udtMobileUser | 1 | 0 |
| `ChkIfMobileUser` | method | p_UserName | 1 | 0 |
| `IfMultipleGSTBSExist` | method | p_BSCol | 1 | 0 |
| `IfMultipleStateCessBSExist` | method | p_BSCol | 1 | 0 |
| `GetFirstItemAccCategoryFromCode` | method | p_MastCode, p_RecType | 2 | 0 |
| `GetItemAccCategoryStrFromCode` | method | p_MastCode, p_RecType | 2 | 0 |
| `GetItemCatQryStr` | method | p_MastCode, p_FldName | 2 | 0 |
| `GetAccCatQryStr` | method | p_MastCode, p_FldName | 2 | 0 |
| `GetTaxCatPercentageOnSpecificDate` | method | p_VchDate, p_TaxCatCode, p_CGSTRate, p_SGSTRate, p_Cess, p_ACess | 6 | 0 |
| `CountryCode2TinDigit` | method | p_Code | 1 | 0 |
| `CountryName2TinDigit` | method | p_CountryName | 1 | 0 |
| `CurrencyName2CurCode` | method | p_Name | 1 | 0 |
| `MultipleDateExistInTDSCatDet` | method | p_TDSMastCode | 1 | 0 |
| `RemoveTDSCatDetForDate` | method | p_MasterCode, p_Date | 2 | 0 |
| `CheckIfMasterIsDeactivated` | method | p_MasterName, p_Mastertype | 2 | 0 |
| `GetITPANForMastercode` | method | p_PartyCode | 1 | 0 |
| `GetTDSAccountOfTDSNature194Q` | method | p_Code | 1 | 0 |
| `CheckIfTDSCatBelongsTo194Q` | method | p_TDSCatCode | 1 | 0 |
| `CheckIfAccountBelongsTo194Q` | method | p_AccCode | 1 | 0 |
| `GetTDSBSFromAccountNaturefORSection194Q` | method | p_Code | 1 | 0 |
| `GetAccForBRSRefsInNextYear` | method | p_NxtYrCon, p_NxtYrDB, p_udtData, p_AccDepositedWithdrawalCol | 4 | 0 |
| `CarryAccBRSRefsInNextYear` | method | p_Arr, p_AccDepositedWithdrawalCol, p_errorInAnyAcc | 3 | 0 |
| `CheckIfCanChangeItemMastUnit` | method | p_ItemCode, p_MainUnitName, p_AltUnitName, p_PackingUnitName, p_OldMainUnitName, p_ErrMsg | 6 | 0 |
| `CheckIfITReturnNotFiled` | method | p_PartyCode | 1 | 0 |
| `GetTDSCatBelongsTo194QIfExist` | method | p_TDSCatCode | 1 | 0 |
| `GetMasterUDT` | method | p_MastCode, p_Mastertype, p_LoadPartial | 3 | 0 |
| `GetVchSeriesDataJSON` | method | p_VSCode | 1 | 0 |
| `GetVchSeriesNumberingJSON` | method | p_VSCode | 1 | 0 |
| `GetSNMastJSON` | method | p_VchType, p_Nar1, p_Nar2 | 3 | 0 |
| `GetMasterApprovalDetailJson` | method | JSON, p_ApprovalDetails, p_InputMode, p_ModifyMaster, p_OldApprovalDetails | 5 | 0 |
| `GetStartDateofDBFYfromDBCon` | method |  | 0 | 0 |
| `SaveAccMast4BulkCreationByGSTIN` | method | p_AccMast, p_ErrorMsg | 2 | 0 |
| `GetItemSum4Branch` | method | p_MasterCode, p_Mastertype, p_BranchCode, p_StartMonth | 4 | 0 |

## Busy2L21.CTranServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetVchLastCode` | method |  | 0 | 0 |
| `GetLastRefCode` | method |  | 0 | 0 |
| `NewRefExist` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_RefNo, p_Vchcode, p_VchType, p_Date, p_VchNo | 8 | 0 |
| `IfEComm_9_5_TransExists` | method |  | 0 | 0 |
| `GetNewRefDueDate` | method | p_NewRefCode | 1 | 0 |
| `GetNewRefNoDate` | method | p_NewRefCode, p_RefNo, p_RefDate | 3 | 0 |
| `GetNewRefPrice` | method | p_NewRefCode, p_RefPrice | 2 | 0 |
| `GetNewRefExecutiveForIndent` | method | p_NewRefCode | 1 | 0 |
| `ChkIfVchTypeNotApplicableForEWB` | method | p_VchType | 1 | 0 |
| `GetNewRefVchNo` | method | p_NewRefCode, p_NewRefNo, p_VchNo | 3 | 0 |
| `GetOrderRefNoDateVchNoForSPAgainstChallan` | method | p_ChallanRefCode, p_AdjRefNo, p_RefNo, p_RefDate, p_DueDate, p_VchNo, p_MasterCode1, p_MasterCode2 | 8 | 0 |
| `GetLastAutoVchNo` | method | p_SeriesCode, p_RenumType, p_Date | 3 | 0 |
| `GenerateAutoVchNumber` | method | p_VchNumData, p_VchNo, p_Date | 3 | 0 |
| `ChangeVchNoInVchGSTSum` | method | p_VchData, p_VchGSTSum | 2 | 0 |
| `ChangeVchNoInVchData` | method | p_udtVchData, p_VchNumData | 2 | 0 |
| `GetPrevVch` | method | p_Vchcode, p_VchSeriesCode, p_VchDate, p_VchNo | 4 | 0 |
| `GetNextVch` | method | p_Vchcode, p_VchSeriesCode, p_VchDate, p_VchNo | 4 | 0 |
| `GetLastVch` | method | p_VchType, p_VchData, p_LoadPartial, p_LastDateOnly | 4 | 0 |
| `GetLastVchInSeriesCol` | method | p_Col, p_VchData, p_LoadPartial | 3 | 0 |
| `GetLastVchInSeries` | method | p_VSC, p_VchData, p_LoadPartial, p_LastDateVchNoOnly | 4 | 0 |
| `GetVchNearestToDate` | method | p_VSC, p_Date | 2 | 0 |
| `VchExist` | method | p_VSC, p_Date, p_VchNo, p_Vchcode | 4 | 0 |
| `VchNoExist2ValidateSalePurcRet` | method | p_VchNo, p_VSC, p_Date, p_Vchcode, p_ValidateVchNo, p_OrgPartyCode, p_OrgVchCode, p_PartyCode, p_Trantype, p_VchType | 10 | 0 |
| `VchNoExistInSeries` | method | p_VSC, p_VchNo, p_Date, p_Vchcode, p_OrgPartyCode, p_OrgVchCode, p_PartyCode, p_Trantype, p_VchType | 9 | 0 |
| `PurcBillNoExistInSeries` | method | p_VSC, p_BillNo, p_Date, p_Vchcode, p_PartyCode, p_OrgVchCode, p_OrgPartyCode | 7 | 0 |
| `VchCodeExist` | method | p_Vchcode | 1 | 0 |
| `AutoVchNoExist` | method | p_AutoVchNo, p_SeriesCode, p_RenumType, p_VchNo, p_Date | 5 | 0 |
| `CanDeleteVch` | method | p_Vchcode, p_Date, p_strError, p_VchSeriesCode | 4 | 0 |
| `Add2Help2Db` | method | p_SeriesCode, p_FieldType, p_Field | 3 | 0 |
| `Tran3RS2RefData` | method | p_rstTran3, p_RefNode, p_ReadSource, p_RefData | 4 | 0 |
| `GetRefGrpCodeNameForNewRef` | method | p_RefCode, p_RefGrpCode, p_RefGrpName | 3 | 0 |
| `GetPendingSOPO` | method | p_ItemCode, p_MCCode, p_SOQty, p_POQty, p_SOAltQty, p_POAltQty, p_MCMastType, p_Date, p_VchSeriesGrpCode, p_MSGrpCode, p_IncludeOpeningWithVchs | 11 | 0 |
| `GetPendingSOPOSelMC` | method | p_ItemCode, p_MCCodeCol, p_SOQty, p_POQty, p_SOAltQty, p_POAltQty, p_MCMastType, p_Date, p_VchSeriesGrpCode, p_MSGrpCode, p_IncludeOpeningWithVchs | 11 | 0 |
| `GetPendingRefs` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_FirstType, p_SecondType, p_IncludeClearedAlso, p_ItemWiseBatches, p_IncludeUnapprovedRefs, p_Vchcode, p_Date, p_BranchCode, p_ShowForOtherBranches | 12 | 0 |
| `GetPendingRefsUptoDate` | method | p_RecType, p_Date, p_MasterCode1, p_MasterCode2, p_status, p_BranchCode, p_ShowForOtherBranches | 7 | 0 |
| `GetRefBalances` | method | p_RefCode, p_Bal2, p_Bal3, p_Date, p_IncludePDC, p_tmpVchCode, p_IncludeUnapproved | 7 | 0 |
| `GetAccRefBalancesForParty` | method | p_MasterCode, p_BillType, p_BranchCode | 3 | 0 |
| `GetRefLastDate` | method | p_RefCode | 1 | 0 |
| `GetStatusOfRef` | method | p_Balance | 1 | 0 |
| `NewRefCodeExist` | method | p_RefCode, p_RecType, p_ItemCode, p_PartyCode | 4 | 0 |
| `GetListOfMastersHavingRefsInVch` | method | p_RecType, p_Vchcode, p_MasterCodes1, p_MasterCodes2, p_UsedInRM | 5 | 0 |
| `GetVchTypeFromVchCode` | method | p_Vchcode | 1 | 0 |
| `GetVchSeriesFromVchCode` | method | p_Vchcode | 1 | 0 |
| `GetVchTypeAndVchSeriesFromVchCode` | method | p_Vchcode, p_VchType, p_VchSeriesCode | 3 | 0 |
| `GetProperAcc` | method | p_Vchcode, p_AmtType, p_Amt, p_AccNameChoice, p_RecType | 5 | 0 |
| `GetLastSeriesDate` | method | p_VSCode | 1 | 0 |
| `GetLastVchDate` | method |  | 0 | 0 |
| `GetFirstVchDate` | method |  | 0 | 0 |
| `UpdateItemTaxAmtsInVch` | method | p_VchData, p_STPTMast | 2 | 0 |
| `UpdateItemTaxAmtsInVch4GSTINDIA` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetSubAccDataFromAccData` | method | p_AccData, p_SubAccData | 2 | 0 |
| `GenerateAccInfoFromItems` | method | p_Items, p_BS, p_PartyName, p_VchType, p_TotalAmt, p_STPTMast, p_SettlementEnabled, p_SettlementData, p_PostSettlementWithParty, p_SalePurcAccCode, p_MCCode, p_BrokerName, p_BrokerageAmt, p_PostBrokerage, p_SubAccEntries, p_SourceMCForStkTfrAcc | 16 | 0 |
| `GetSalePurcAccTaggedInMC` | method | p_MCCode, p_AccType | 2 | 0 |
| `GetSalePurcAccTaggedInItemGrp` | method | p_IgrpCode, p_AccType | 2 | 0 |
| `MergeCommonAccsWithNarrAndSettlementAcc` | method | p_Accs, p_Amts, p_OverNAboveCol, p_ShortNarCol | 4 | 0 |
| `MergeCommonAccs` | method | p_Accs, p_Amts | 2 | 0 |
| `TranExistForVchTypes` | method | p_VchTypes | 1 | 0 |
| `DualTranExist` | method |  | 0 | 0 |
| `PaymentReceiptExist` | method |  | 0 | 0 |
| `GetItemMCFIFOPrice` | method | p_ItemCode, p_MCCode, p_Date, p_MainQty | 4 | 0 |
| `GetItemMCFIFOPriceForQty` | method | p_ItemCode, p_MCCode, p_Date, p_BalQty, p_QtyReq | 5 | 0 |
| `GetItemMCLIFOPriceForQty` | method | p_ItemCode, p_MCCode, p_Date, p_BalQty, p_QtyReq, p_Vchcode, p_IncludeQtyForDataEntry | 7 | 0 |
| `GetItemMCWtAvgPrice` | method | p_ItemCode, p_MCCode, p_Date, p_ForceMCWise | 4 | 0 |
| `GetItemMCAvgPrice` | method | p_ItemCode, p_MCCode, p_Date | 3 | 0 |
| `GetItemMCAvgForInvoice` | method | p_ItemCode, p_MCCode, p_Date | 3 | 0 |
| `GetItemMCPrice` | method | p_ItemCode, p_MCCode, p_Date, p_SVM, p_SVP, p_MainQtyForLIFOFIFO, p_BranchCode | 7 | 0 |
| `GetVchNoFromVchCode` | method | p_Vchcode | 1 | 0 |
| `GetVchTypeNoDateFromVchCode` | method | p_Vchcode, p_VchType, p_VchNo, p_VchDate | 4 | 0 |
| `GetVchData` | method | p_Vchcode, p_VchData, p_LoadPartial | 3 | 0 |
| `GetVchJSON` | method | p_Vchcode | 1 | 0 |
| `GetCallVchData` | method | p_Vchcode, p_VchData, p_LoadPartial | 3 | 0 |
| `CreateBusyExtObj` | method |  | 0 | 0 |
| `DestroyBusyExtObject` | method |  | 0 | 0 |
| `GetVchDataFromXML` | method | p_Vchcode, p_VchData, p_LoadPartial | 3 | 0 |
| `GetSalesTaxInfoString` | method | p_Vchcode, p_VchType, p_Trantype, p_STPTMast | 4 | 0 |
| `GetSalesTaxInfoStringForUnapprovedVch` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetVchSalePurcAmt` | method | p_Vchcode, p_VchType, p_STPTMast | 3 | 0 |
| `GetVchSalePurcAmtFromVchData` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GenVchVATSumFromVchData` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetSalesTaxInfo` | method | p_Vchcode, p_VchType, p_STPTMast, p_ItemCode, p_SplitMRPEntries, p_SeparateRetailPurchaseEntry | 6 | 0 |
| `GetSaleAndTaxAmt` | method | p_Vchcode, p_SaleAmt, p_TaxAmt, p_SurchargeAmt, p_OnlyTaxAmt | 5 | 0 |
| `GetSaleAndTaxAmt4GSTINDIA` | method | p_Vchcode, p_TaxableAmt, p_TaxAmt, p_TaxBeforeSchg, p_TaxBeforeSchg1, p_STPTType, p_CessAmt, p_AddCessAmt, p_StateCessAmt | 9 | 0 |
| `GetSaleAndTaxAmt4GSTIndiaRCMPybl` | method | p_Vchcode, p_TaxableAmt, p_TaxAmt, p_IGST, p_CGST, p_SGST, p_STPTType, p_CessAmt, p_AddCessAmt, p_StateCessAmt | 10 | 0 |
| `GetSaleAndTaxAmtForUnApprovedVch` | method | p_VchData, p_STPTMast, p_SaleAmt, p_TaxAmt, p_SurchargeAmt, p_OnlyTaxAmt | 6 | 0 |
| `UpdateClearingDate` | method | p_Date, p_Vchcode, p_AccCode, p_Srno, p_Type, p_BankCode, p_ClrFullVch, p_OldVchCode, p_VchNo | 9 | 0 |
| `MasterTranExistInTran2` | method | p_RecType, p_MasterCode, p_StartDate, p_EndDate, p_VchSeriesGrpCode | 5 | 0 |
| `IsTranExistforMasterInVchType` | method | p_MasterCode, p_VchType, p_StartDate, p_EndDate | 4 | 0 |
| `ItemMCTranExistInTran2` | method | p_ItemCode, p_MCCode, p_StartDate, p_EndDate | 4 | 0 |
| `AccountingTranExistInTran2ForVSGrp` | method | p_RecType, p_StartDate, p_EndDate, p_CheckForUserControl, p_VchSeriesGrpCode | 5 | 0 |
| `AccountingTranExistInTran2` | method | p_RecType, p_StartDate, p_EndDate, p_CheckForUserControl | 4 | 0 |
| `AccExistWithBalUnderThis` | method | p_GrpCode, p_Date, p_OpBal | 3 | 0 |
| `ItemExistWithBalUnderThis` | method | p_GrpCode, p_MCCodes, p_Date, p_IUT, p_OpBal | 5 | 0 |
| `GetVchAmount` | method | p_Vchcode, p_AmtType | 2 | 0 |
| `GetItemAmtsFromNonPlainBS` | method | p_itemCol, p_BSData, p_UseForBillRefGrp, p_ItemSrNo, p_DoNotIncludeSkipInGSTItem | 5 | 0 |
| `AllocateBSAmtToItems` | method | p_itemCol, p_BSData, p_UseForBillRefGrp, p_AltCur | 4 | 0 |
| `PlainBS` | method | p_BSMast | 1 | 0 |
| `GetBSAmtToAdjustAndNonPlainBS` | method | p_VchType, p_BSArr, p_NPBSArr, p_CheckForBSPostingInSPAmt, p_IncludeExcise, p_ForceIncludeAllBS, p_LocType, p_MultiTaxThroughBS | 8 | 0 |
| `UpdateItemParamNettAmts` | method | p_VchType, p_ItemData, p_ItemParamCol | 3 | 0 |
| `UpdateItemNettAmts` | method | p_VchType, p_ItemEntries, p_BSEntries, p_STPTMast, p_ExtraExpenseAmt | 5 | 0 |
| `UpdateItemSPAmts` | method | p_VchType, p_ItemEntries, p_BSEntries, p_STPTMast, p_IncludeExcise | 5 | 0 |
| `CCTranExist` | method | p_MasterCode, p_StartDate, p_EndDate | 3 | 0 |
| `GetPartyItemLastDateForVchType` | method | p_VchType, p_RecTypeStr, p_PartyCode, p_ItemCode, p_UnitQryStr, p_PickNonZeroPrice, p_VchDate | 7 | 0 |
| `GetLastPartyItemPrice` | method | p_RecType, p_AccCode, p_ItemCode, p_VchType, p_PickNonZeroPrice, p_PricingInfo, p_UnitCode, p_BasePricingInfo, p_Trantype, p_VchDate | 10 | 0 |
| `GetFormNo` | method | p_BillCode, p_VchType | 2 | 0 |
| `CalculateTotalVchAmt` | method | p_itemCol, p_BSCol, p_AltCurCode | 3 | 0 |
| `CalculateTotalAccVchAmt` | method | p_AccCol, p_AltCurCode | 2 | 0 |
| `CalDepreciationITAct` | method | p_AccCode, p_DepAcc, p_RoundOffChoice, p_RoundOffUptoAmt | 4 | 0 |
| `GetItemPartyOpBals` | method | p_ItemCode, p_PartyCode, p_AltBal, p_Amt | 4 | 0 |
| `GetItemPartyNetBals` | method | p_Date, p_PartyCode, p_ItemCode, p_AltBal, p_Amt, p_Trantype | 6 | 0 |
| `GetItemsListForMatIssRec` | method | p_PartyCode | 1 | 0 |
| `GetPartyListForOrders` | method | p_ItemCode | 1 | 0 |
| `GetPartyListForOPOrders` | method | p_ItemCode, p_Vchcode | 2 | 0 |
| `GetRefsBegDate` | method | p_RecType | 1 | 0 |
| `GetLastTDSRefCode` | method |  | 0 | 0 |
| `GetVchOtherInfo` | method | p_Vchcode | 1 | 0 |
| `GetTDSRefNo2Code` | method | p_RefNo, p_AccCode | 2 | 0 |
| `GetVATSummary` | method | p_VatSum, p_VATRetSum, p_VatSumOptions, p_VATJVITCol, p_VATJVOTCol, p_VATJVPaymentCol, p_udtRefund, p_RaiseEvent, p_Events, p_VATJVCrNoteCol, p_VATJVDrNoteCol | 11 | 0 |
| `GetVATInfoInAccVch` | method | p_StartDate, p_EndDate, p_VATJVITCol, p_VATJVOTCol, p_VATJVPaymentCol, p_RefundJV, p_IncludeCSTPymt, p_VchSeriesGrpCode, p_VATJVCrNoteCol, p_VATJVDrNoteCol | 10 | 0 |
| `GetVATJVSummary` | method | p_StartDate, p_EndDate, p_VATJVITCol, p_VATJVOTCol, p_RefundUdt, p_VATJVPaymentCol, p_IncludeCSTPymt, p_VchSeriesGrpCode, p_VATJVCrNoteCol, p_VATJVDrNoteCol | 10 | 0 |
| `GetVATInfo` | method | p_Vchcode, p_VchType, p_StPtData, p_ItemCode, p_ShowRetailPurcDet, p_SplitMRPEntries | 6 | 0 |
| `GetCombinedVATDetailsWithSurcharge` | method | p_AMT1, p_TaxAmt1, p_FormCodes1, p_TaxRate1, p_SurchargeAmt1, p_SurchargeRate1, p_AMT2, p_TaxAmt2, p_FormCodes2, p_TaxRate2, p_SurchargeAmt2, p_SurchargeRate2, p_UsedInVATReturn, p_TaxOnMRPs, p_TaxOnMRPs1, p_SplitMRPEnteries | 16 | 0 |
| `GetVATTranTypes` | method | p_VchType, p_SalePurcRet, p_LocalCentral | 3 | 0 |
| `GetLastVJVDate` | method |  | 0 | 0 |
| `GetLastDateForVchType` | method | p_VchType | 1 | 0 |
| `GetLastDateForVchSeries` | method | p_VchSeriesCode | 1 | 0 |
| `GetLastVchTypeDet` | method | p_AccCode, p_Date, p_VchType, p_LastAmt, p_LastDate, p_ShortNar, p_Vchcode, p_VchSeriesGrpCode | 8 | 0 |
| `GetLastVchTypeDetExcludingPDC` | method | p_AccCode, p_Date, p_VchType, p_LastAmt, p_LastDate, p_ShortNar, p_Vchcode, p_VchSeriesGrpCode | 8 | 0 |
| `GetLastVchtypeAmt` | method | p_AccCode, p_Date, p_VchType, p_LastDate, p_Vchcode, p_VchSeriesGrpCode | 6 | 0 |
| `GetAccTotalVchAmt` | method | p_AccCode, p_StartDate, p_EndDate, p_VchType, p_VchSeriesGrpCode | 5 | 0 |
| `ItemExistInCol` | method | p_Col, p_key | 2 | 0 |
| `CanPrintDocument` | method | p_RepID, p_Vchcode, p_StrErr | 3 | 0 |
| `CanPrintVoucher` | method | p_StrErr | 1 | 0 |
| `CanPrintUtilities` | method | p_RepID, p_FAVchFlag, p_StrErr | 3 | 0 |
| `UpdateDocPrintFlag` | method | p_Vchcode | 1 | 0 |
| `GetFinQuarterStartDateEndDate` | method | p_FinQuarter, p_StartDate, p_EndDate | 3 | 0 |
| `GetFinHalfYearStartDateEndDate` | method | p_FinHalfYear, p_StartDate, p_EndDate | 3 | 0 |
| `GetBillingDet` | method | p_Vchcode | 1 | 0 |
| `GetBillWiseProfit` | method | p_Vchcode, p_ItemWiseProfitDet, p_TotalSaleAmt, p_TotalCostAmt, p_MCCode, p_VchDate, p_ItemCode, p_SVM, p_ItemSrNo | 9 | 0 |
| `IsVchExist` | method | p_ModifyOptions, p_VchNo, p_VchDate, p_VchSeriesCode, p_Vchcode, p_VchType, p_PartyCode | 7 | 0 |
| `IsVchExistForBDEP` | method | p_ModifyOptions, p_SrcVchType, p_VchNo, p_VchcodeCol, p_VchDetCol | 5 | 0 |
| `IfAnyItemwiseJobWorkCreationAdjExist` | method |  | 0 | 0 |
| `IdentifyVch` | method | p_VchType, p_VchSeriesCode, p_VchDate, p_VchNo, p_Vchcode, p_ErrMsg | 6 | 0 |
| `IsVchNoUniqueInAllSeries` | method | p_VchNo, p_VchType, p_Vchcode | 3 | 0 |
| `GSTIndiaBS` | method | p_BSNature | 1 | 0 |
| `TaxBS` | method | p_BSNature, p_LocType | 2 | 0 |
| `GetItemsTaxableAmt` | method | p_udtItemdata, p_udtBSData, p_StPtData, p_BSName, p_TaxPercent, p_AltCur | 6 | 0 |
| `SurchargeBS` | method | p_BSNature | 1 | 0 |
| `GetItemsTaxableAmtForSurcharge` | method | p_udtItemdata, p_udtBSData, p_StPtData, p_BSName, p_SurchargePercent, p_AltCur | 6 | 0 |
| `GetItemsTaxableAmtForStateLevelCess` | method | p_udtItemdata, p_udtBSData, p_StPtData, p_BSName, p_StateCessPercent, p_AltCur | 6 | 0 |
| `DeletedTemplateEntry` | method | p_Vchcode | 1 | 0 |
| `GetTemplateDetailsFromVchType` | method | p_VchType | 1 | 0 |
| `DeleteVchVATSum` | method | p_Vchcode | 1 | 0 |
| `SaveVchVATSum` | method | p_Vchcode, p_VchVATSum | 2 | 0 |
| `TranExistForCur` | method | p_MasterCode, p_CurCode, p_StartDate, p_EndDate | 4 | 0 |
| `GetVchVATSumRst` | method | p_Vchcode, p_STPTMast | 2 | 0 |
| `GetVchGSTSumRst` | method | p_Vchcode, p_STPTMast | 2 | 0 |
| `CheckForMultiMCExist` | method |  | 0 | 0 |
| `GetBookNoForVchNo` | method | p_VchNo, p_udtVchNum | 2 | 0 |
| `GetPOSCashToBeReturnedAmt` | method | p_udtSettlementData, p_SettlementAllowed, p_VchTotalAmt | 3 | 0 |
| `GetLastVchForFixSeriesCol` | method | p_VSCCol, p_VchData, p_LoadPartial, p_LastDateVchNoOnly | 4 | 0 |
| `IsBatchRefExist` | method |  | 0 | 0 |
| `CheckIfOrderAdjustmentExist` | method | p_Vchcode | 1 | 0 |
| `CheckIfOrderAdjustmentExistInNextFY` | method | p_RefNoCol | 1 | 0 |
| `CheckForOrderChallanRefsForItem` | method | p_RefType, p_ItemCode | 2 | 0 |
| `CheckIfVchIsAdjustedAgnstOrder` | method | p_RefType, p_Vchcode | 2 | 0 |
| `GetMRPPendingStock` | method | p_ItemCode, p_MCCode, p_VchDate, p_MRPData, p_Vchcode, p_ShowMRPAmount, p_ShowZeroMRP | 7 | 0 |
| `GetAllAdjustmentForRefference` | method | p_RefCode, p_Date, p_IncludePDC, p_IncludeUnAprrovedEntries | 4 | 0 |
| `GetBatchRefdetails` | method | p_ItemCode, p_MCCode, p_BatchNo, p_ItemSrNo, p_Method | 5 | 0 |
| `GetFreeQtyQryStr` | method | p_AliasName, p_Repopt | 2 | 0 |
| `TranExistForPDC` | method |  | 0 | 0 |
| `GetLastPDCVchDate` | method | p_forCurYr | 1 | 0 |
| `IfPDCExistAgainstReference` | method | p_RefCode, p_Date | 2 | 0 |
| `GetPendingItemSerialNumbers` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchDate, p_AllRefs | 5 | 0 |
| `GetPendingItemSerialNumbers4MultiGD` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchDate | 4 | 0 |
| `GetPartyListForChallans` | method | p_ItemCode, p_Vchcode | 2 | 0 |
| `ValidChallanRefData` | method | p_VchType, p_RefData | 2 | 0 |
| `IfChallanAdjustmentExist` | method |  | 0 | 0 |
| `CheckIfChallanAdjustmentExist` | method | p_Vchcode | 1 | 0 |
| `CheckIfChallanAdjustmentExistInNextFY` | method | p_RefNoCol, p_PartyCode | 2 | 0 |
| `CheckIfOpRefAdjustmentExist` | method | p_ItemCode, p_PartyCode, p_RefNo, p_RecType | 4 | 0 |
| `TranExistForSaleReturnQty` | method |  | 0 | 0 |
| `TranExistForPurchaseReturnQty` | method |  | 0 | 0 |
| `GetItemSerialNoDet` | method | p_ItemCode, p_MCCode, p_SerialNo | 3 | 0 |
| `GetPendingItemParamBCNStock` | method | p_ItemCode, p_MCCode, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_Vchcode, p_VchDate, p_NoOfStockParam, p_MRP | 11 | 0 |
| `UpdateBCNStockValue` | method | p_BCNStr, p_ItemCode, p_MCCode, p_ParamData | 4 | 0 |
| `GetPendingItemParamStock` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchDate, p_NoOfStockParam, p_IfBCNEnabled | 6 | 0 |
| `GetPendingItemParamStockForVch` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchDate, p_NoOfStockParam, p_VchType, p_Trantype, p_IncludeBCN, p_ShowZeroParam | 9 | 0 |
| `GetPendingItemParamStockForJobWorkVch` | method | p_ItemCode, p_JobID, p_Vchcode, p_VchDate, p_NoOfStockParam, p_VchType, p_Trantype, p_PartyCode, p_ShowZeroParam, p_DoNotFilterOnJobID | 10 | 0 |
| `GetItemBatchesPendingRefs` | method | p_MasterCode1, p_MasterCode2, p_Vchcode, p_Type, p_status, p_IncludePendingOnly, p_Date, p_ShowZeroBatches, p_StartDate, p_VchDate, p_ExcludeExpiredBatches | 11 | 0 |
| `GetItemBatchesPendingRefsForSQL` | method | p_MasterCode1, p_MasterCode2, p_Vchcode, p_Type, p_status, p_IncludePendingOnly, p_Date, p_ShowZeroBatches, p_VchDate, p_ExcludeExpiredBatches | 10 | 0 |
| `GetBatchRefDetailsIfExist` | method | p_BatchNo, p_ItemCode, p_MCCode, p_RefData, p_IncludeBalance, p_Vchcode | 6 | 0 |
| `GetBatchLastSalesPrice` | method | p_BatchNo, p_ItemCode, p_MCCode, p_Vchcode | 4 | 0 |
| `GetItemMCPriceForQty` | method | p_ItemCode, p_MCCode, p_Date, p_SVM, p_BalQty, p_MainQtyForLIFOFIFO, p_Vchcode | 7 | 0 |
| `SaveMessageCentreFolder` | method | p_Folder, p_InputMode, p_OldName | 3 | 0 |
| `LoadMessageCentreFolder` | method |  | 0 | 0 |
| `CanDeleteMsgCentreFolder` | method | p_FolderName | 1 | 0 |
| `DeleteMsgCentreFolder` | method | p_FolderName | 1 | 0 |
| `MoveMsgToFolder` | method | p_Vchcode, p_FolderName, p_MessageType | 3 | 0 |
| `GetLastMsgID` | method |  | 0 | 0 |
| `SaveSendMessage` | method | p_udtMsgData | 1 | 0 |
| `CheckForNewMails` | method | p_FolderName | 1 | 0 |
| `LoadMsgSummary` | method |  | 0 | 0 |
| `UpdateOrDeleteMessageStatus` | method | p_Vchcode, p_MsgAction | 2 | 0 |
| `TranExistsForOtherVchTypes` | method | p_VchType, p_StartDate, p_EndDate | 3 | 0 |
| `GetNewOfflineCode` | method |  | 0 | 0 |
| `UpdateBSPercentOperatedOn` | method | p_VchData, p_STPTMast | 2 | 0 |
| `UpdateVchVATSum` | method | p_VchData, p_STPTMast | 2 | 0 |
| `DeleteVchVATSumItemWise` | method | p_Vchcode | 1 | 0 |
| `SaveVchVATSumItemWise` | method | p_Vchcode, p_VchVATSumItemWise | 2 | 0 |
| `GenVchVATSumItemWiseFromVchData` | method | p_VchData, p_STPTMast | 2 | 0 |
| `CopyVchData` | method | p_VchData | 1 | 0 |
| `GetNewRefCodeFromRefNo` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_RefNo | 4 | 0 |
| `GetTDSNewRefCodeFromRefNo` | method | p_MasterCode1, p_MasterCode2, p_RefNo | 3 | 0 |
| `GetTCSNewRefCodeFromRefNo` | method | p_MasterCode1, p_MasterCode2, p_RefNo | 3 | 0 |
| `UpdateUnadjustedReferences` | method |  | 0 | 0 |
| `GetVchTypeFromRefCode` | method | p_RefCode | 1 | 0 |
| `GetDefaultCategoryCodeForUser` | method | p_User | 1 | 0 |
| `GetItemRG23DPageNo` | method |  | 0 | 0 |
| `GetNextRG23DSrNo` | method | p_LastRG23DSrNo | 1 | 0 |
| `GetPendingOrdersItemPartyWise` | method | p_PartyCode, p_ItemCode, p_MCCode, p_Date, p_QtyAlt, p_VchType | 6 | 0 |
| `GetPendingChallanItemPartyWise` | method | p_PartyCode, p_ItemCode, p_MCCode, p_Date, p_QtyAlt, p_VchType, p_Trantype | 7 | 0 |
| `GetLastPymtRcptNarr` | method | p_Vchcode, p_Nar1, p_Nar2 | 3 | 0 |
| `LoadItemSrNoDetails` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchItemSrNo, p_ItemSrNoDet, p_OldSerialCol | 6 | 0 |
| `LoadItemBatchesDet` | method | p_ItemCode, p_MCCode, p_Vchcode, p_ItemSrNo, p_RefCol, p_OldCol | 6 | 0 |
| `LoadParamStockDet` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchItemSrNo, p_ParamStockDet, p_OldParamStockCol, p_RecType | 7 | 0 |
| `LoadParamStockDetForJobWork` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchJobSrNo, p_MainItemSrno, p_ParamStockDet, p_OldParamStockCol, p_RecType, p_PartyCode | 9 | 0 |
| `GetPurcBillNoAndDate` | method | p_Vchcode, p_BillNo, p_BillDate, p_VSC | 4 | 0 |
| `GetVchSeriesCodeCol` | method | p_VchSeriesGrpCode | 1 | 0 |
| `GetBillRecPayAmt` | method | p_RepDate, p_AmtType, p_EntryStatus, p_PartyCode | 4 | 0 |
| `GetPendingChallanAmtForBalSheet` | method | p_BalSheetForPeriod, p_BalSheetDateMode, p_StartDate, p_EndDate, p_SMonth, p_EMonth, p_VchType, p_VchSeriesGrpCode, p_PendingChallanQty | 9 | 0 |
| `GenItemSTInfo` | method | p_itemCol, p_STPTMast, p_SchgAppl4Pakistan | 3 | 0 |
| `GetGLPendingChallanNettQtyAndAmtWithAllSL` | method | p_GLCode, p_Date, p_VchType, p_MainQty, p_AltQty, p_Vchcode | 6 | 0 |
| `GetGLPendingOrderNettQtyAndAmtWIthAllSL` | method | p_GLCode, p_Date, p_VchType, p_MainQty, p_AltQty, p_Vchcode | 6 | 0 |
| `GetPartyPendingChallanNettQtyAndAmt` | method | p_PartyCode, p_Date, p_VchType, p_MainQty, p_AltQty, p_Vchcode | 6 | 0 |
| `GetPartyPendingOrderNettQtyAndAmt` | method | p_PartyCode, p_Date, p_VchType, p_MainQty, p_AltQty, p_Vchcode | 6 | 0 |
| `GetPartyCreditBalanceAvailable` | method | p_PartyCode, p_Date | 2 | 0 |
| `GetPartyListForQuotations` | method | p_ItemCode | 1 | 0 |
| `GetPartyListForOPQuotations` | method | p_ItemCode, p_Vchcode | 2 | 0 |
| `CheckIfUnNumVchInSeries` | method | p_VchType, p_SeriesCode | 2 | 0 |
| `GetBatchRefBalance` | method | p_ItemCode, p_MCCode, p_RefNo, p_Vchcode | 4 | 0 |
| `GetBranchColForVS` | method |  | 0 | 0 |
| `GetBranchForVS` | method | p_VSCode | 1 | 0 |
| `GetBranchCodeForVSGrp` | method | p_VSGrpCode | 1 | 0 |
| `GetTaxRateCountInSalePurVch` | method | p_Repopt | 1 | 0 |
| `IfNonImpactBS` | method | p_BSMast, p_VchType, p_Trantype | 3 | 0 |
| `TranExistForBSForVchType` | method | p_VchType, p_BSCode | 2 | 0 |
| `SavePackingDetails` | method | p_Vchcode, p_PackingCol | 2 | 0 |
| `DeleteVchPackingDetails` | method | p_Vchcode | 1 | 0 |
| `GetVchPackingDetails` | method | p_Vchcode | 1 | 0 |
| `CheckIfMasterIsBlocked` | method | p_Name, p_Mastertype, p_ReasonStr | 3 | 0 |
| `GetVchTotalBilledMRP` | method | p_VchData, p_PickListPriceForZeroMRP | 2 | 0 |
| `GetVSGrpForBranch` | method | p_BranchCode | 1 | 0 |
| `GetAccCodeUsedForAccInStkTfrFromMC` | method | p_MCCode | 1 | 0 |
| `GetAccCodeUsedForAccInStkTfrFromMCName` | method | p_MCName | 1 | 0 |
| `GetItemSVPForBranch` | method | p_ItemCode, p_BranchCode, p_DefaultSVP, p_Date | 4 | 0 |
| `GetItemMCSelfPrice` | method | p_ItemCode, p_Date | 2 | 0 |
| `LoadJobOpeningrefs` | method | p_PartyCode, p_RecType | 2 | 0 |
| `SaveJobopeningRefs` | method | p_PartyCode, p_RecType, p_JobEntries | 3 | 0 |
| `SaveJobopeningRefsForItem` | method | p_ItemCode, p_RecType, p_JobEntries | 3 | 0 |
| `UpdateDefSalePurTypeInTran1Tran2` | method | p_SaleType, p_PurcType, p_VATGSTtype | 3 | 0 |
| `GetBSColfromVchCode` | method | p_Vchcode | 1 | 0 |
| `GetSTPTMastTypeByVchCode` | method | p_Vchcode | 1 | 0 |
| `CalculateTotalDebitTotalCreditInCaseOFMultiCurrency` | method | p_TotalDebit, p_TotalCredit, p_AccDataArr | 3 | 0 |
| `GetPendingQtyToAllPartiesOutHouse` | method | p_BalSheetForPeriod, p_BalSheetDateMode, p_StartDate, p_EndDate, p_SMonth, p_EMonth, p_PendingJobOutQty | 7 | 0 |
| `GetItemOpBalForTrackingSystem` | method | p_ItemName, p_McCol, p_Date, p_TrackingNo, p_MainQty, p_AltQty | 6 | 0 |
| `CheckForDuplicateTrackingNo` | method | p_TrackingNo, p_Vchcode | 2 | 0 |
| `GetAccOpBalForTrackingSystem` | method | p_AccName, p_TrackingNo, p_Date | 3 | 0 |
| `GetLastVchForPhyStk` | method | p_VchType, p_VchData, p_LastDateOnly | 3 | 0 |
| `GetNextPhyStkVch` | method | p_Vchcode, p_VchDate | 2 | 0 |
| `GetPrevPhyStkVch` | method | p_Vchcode, p_VchDate | 2 | 0 |
| `GetSalesTaxInfoFromVchVatSum` | method | p_VchVATSum | 1 | 0 |
| `IfSameVOFDataType` | method | p_Series1, p_series2 | 2 | 0 |
| `GetVchXML` | method | p_Vchcode, p_LoadPartial | 2 | 0 |
| `GetSTVchXML` | method | p_Vchcode, p_LoadPartial | 2 | 0 |
| `CheckIfPrevYrVchExistInCurFY` | method | p_PrevYrVchCode | 1 | 0 |
| `GetMCListForIndents` | method | p_ItemCode | 1 | 0 |
| `GetMCListForOPIndents` | method | p_ItemCode, p_Vchcode | 2 | 0 |
| `LoadCallOpeningrefs` | method | p_Trantype | 1 | 0 |
| `CheckIfAnyCallRcptVchExistForSeries` | method | p_SeriesCode | 1 | 0 |
| `GetRefGrpNarrationFromRefcode` | method | p_RefCode, p_RefGrpCode, p_Narration | 3 | 0 |
| `GetNewRefValuesFromRefcode` | method | p_RefCode, p_Value1, p_Value2 | 3 | 0 |
| `GetNewRefAmtFromRefCode` | method | p_RefCode | 1 | 0 |
| `GetPendingJobIDListWRTPartyItem` | method | p_PartyCode, p_ItemCode, p_RecType, p_VchDate, p_QtyCol, p_Vchcode | 6 | 0 |
| `GetPendingRefsAmtForParty` | method | p_AccCode, p_status, p_StartDate, p_AsOnDate | 4 | 0 |
| `LoadAMCRefs` | method | p_RecType, p_Vchcode, p_PartyCode, SrNo | 4 | 0 |
| `SaveAMCRefs` | method | p_AMCEntries, p_Vchcode, p_RecType, p_PartyCode | 4 | 0 |
| `CheckForUniqueAMCReference` | method | p_AMCRef, p_PartyCode, p_Vchcode | 3 | 0 |
| `GetTrgtVch` | method | p_SrcVchData, p_TrgtVchData | 2 | 0 |
| `GetPartyPendingOrdersCol` | method | p_PartyCode, p_Date, p_VchType, p_VchSeriesGrpCode, p_BranchCode | 5 | 0 |
| `SplitVch` | method | p_SrcVchCode, p_SplitConfig, p_InvalidMsg, p_TrgtVchData, p_VchSplitted, p_UsedForUtility, p_ChoiceToSkip, p_VchDeleted, p_FromBulkUtility | 9 | 0 |
| `IsSchemeTranExistBetweenDateRange` | method | p_Code, p_StartDate, p_EndDate, p_ErrMsg | 4 | 0 |
| `ChkVchConfigForSplit` | method | p_SrcVchSerCode, p_TrgtVchSerCode, p_InvalidMsg | 3 | 0 |
| `DeleteSplitVchDetFromDeletedInfo` | method | p_Type, p_VchMastType, p_Identity | 3 | 0 |
| `CheckPurchaseBillExist` | method | p_VchNo, p_Vchcode, p_PurcBillDate, p_ValidateOnlyVchNo, p_DefaultDate, p_VSC | 6 | 0 |
| `SaveHOCallVchXMLInDataSync` | method | p_InputMode, p_ModifyEntry, p_XMLStr, p_CallVchData, p_OldCallVchData, p_BranchCode | 6 | 0 |
| `SaveHODeletedCallVchInDataSync` | method | p_InputMode, p_CallVchData, p_BranchCode | 3 | 0 |
| `SaveBODeletedCallVchInDataSync` | method | p_InputMode, p_CallVchData | 2 | 0 |
| `GetImportedVchData` | method | p_SrcVchData, p_TrgtVchData, p_STPTMastCol, p_itemCol, p_BSCol, p_Unitcol, p_BrokerCol, p_PartyMastCol, p_UseForBDEP, p_VchUID, p_MCMastCol, p_AccMastCol, p_GSTNoForAccMast | 13 | 0 |
| `ChkIfMappedWithAnyMaster` | method | p_Name, p_Mastertype, p_udtMappedData | 3 | 0 |
| `GetAllMappedMasterDet` | method |  | 0 | 0 |
| `GetAllDeletedMastersDet` | method |  | 0 | 0 |
| `SaveAllMappedMasterDet` | method | p_MastCol | 1 | 0 |
| `MasterTranExistForCostCentre` | method | p_CCCode, p_MasterCode, p_StartDate, p_EndDate, p_VchSeriesGrpCode | 5 | 0 |
| `UpdateVchGSTSumItemWise` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GenVchGSTSumItemWiseFromVchData` | method | p_VchData, p_STPTMast, p_ShowDeemedTaxForcefully | 3 | 0 |
| `SummariseGSTItemDet` | method | p_VchGSTSum, p_SumBasis | 2 | 0 |
| `DeleteVchGSTSumItemWise` | method | p_Vchcode | 1 | 0 |
| `DeleteVchGSTSum` | method | p_Vchcode | 1 | 0 |
| `DeleteAdvanceReceiptRefs` | method | p_ItemGSTDetCol, p_PartyCode | 2 | 0 |
| `DeleteAdvancePaymentRefs` | method | p_ItemGSTDetCol, p_PartyCode | 2 | 0 |
| `SaveVchGSTSum` | method | p_Vchcode, p_VchGSTSum | 2 | 0 |
| `LoadVchGSTSumAcc` | method | p_Vchcode, p_RecType | 2 | 0 |
| `SaveVchGSTSumAcc` | method | p_Vchcode, p_VchGSTDet, p_UsedForCFY | 3 | 0 |
| `SaveVchGSTSumItemWise` | method | p_Vchcode, p_VchGSTDet | 2 | 0 |
| `ModifyVchGSTSumItemwiseForHSNCode` | method | p_ItemCode, p_TaxCatCode, p_HSNCode, p_SENo | 4 | 0 |
| `ModifyVchGSTSumItemwiseForHSNCodeDateWise` | method | p_ItemCode, p_HSNCol | 2 | 0 |
| `UpdateStateTinDigitInVchGSTSumItemWise` | method | p_StateCode | 1 | 0 |
| `UpdateStateInVchGSTSumItemWise` | method | p_PartyCode, p_StateCode | 2 | 0 |
| `CalcPriceToUpdateSPFromPP` | method | p_ItemData, p_VchData | 2 | 0 |
| `GetGSTInfoString` | method | p_Vchcode, p_VchType, p_Trantype, p_STPTMast | 4 | 0 |
| `GetGSTInfoString4UnapprovedVoucher` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetGSTPaymentInfo` | method | p_StartDate, p_EndDate, p_GSTJVPaymentCol, p_VchSeriesGrpCode, p_IfSepecificPayment, p_PaymentSubRectype | 6 | 0 |
| `CalSalesPrice4Grouping` | method | p_ItemCode, p_ParamCol, p_MRP | 3 | 0 |
| `GetStateTinDigitfromPartyCode` | method | p_PartyCode, p_StateCode | 2 | 0 |
| `GetAccCodeFromAccVch` | method | p_Vchcode, p_VchType | 2 | 0 |
| `GetJobWorkClosingStock` | method | p_Repopt, p_StartDate, p_EndDate, p_OpStock | 4 | 0 |
| `SwapTaxRatesinItem` | method | p_LocType, p_ItemData, p_ItemMast, p_ItemListPrice, p_ItemNettPrice, p_MRP, p_LoadingDataFromDB, p_InclusiveTaxApplicable | 8 | 0 |
| `CalculateTaxAmtsFromTotalAmt` | method | p_TotalAmt, p_Type, p_TaxRate, p_TaxRate1, p_CessRate, p_ACessRate, p_StateCessRate | 7 | 0 |
| `GetPendingGSTAdvanceCol` | method | p_PartyCode, p_Vchcode, p_VchDate, p_RegionType, p_NewRefVchType | 5 | 0 |
| `CheckIfPartyPendingGSTAdvanceAdjExists` | method | p_PartyCode, p_Vchcode, p_VchDate, p_RegionType, p_NewRefVchType | 5 | 0 |
| `IfGSTRefBelongToParty` | method | p_RefNo, p_PartyCode, p_NewRefVchType | 3 | 0 |
| `CheckIfRefNoExistForPartyInAdvance` | method | p_RefNo, p_PartyCode, p_Vchcode, p_RecType | 4 | 0 |
| `AdvanceTaxAccVchExist` | method | p_Vchcode, p_UdtGen, p_AGT, p_VchSerGrpCode | 4 | 0 |
| `GetBrokerBillAmt` | method | p_Repopt | 1 | 0 |
| `GetBillRecPayRecordCount` | method | p_Repopt | 1 | 0 |
| `IfDeemedTax` | method | p_STPTMast, p_VchType, p_Trantype | 3 | 0 |
| `UpdateItemTaxAmtsInVchForRCM` | method | p_VchData, p_STPTMast | 2 | 0 |
| `PurcBillNoExist2ValidateSalePurcRet` | method | p_VchNo, p_VSC, p_Date, p_Vchcode, p_ValidateVchNo, p_OrgPartyCode, p_OrgVchCode, p_PartyCode, p_Trantype, p_VchType | 10 | 0 |
| `IsPurcBillExist` | method | p_ModifyOptions, p_VchNo, p_VchDate, p_VchSeriesCode, p_Vchcode, p_VchType | 6 | 0 |
| `GetUQCForUnitCode` | method | p_UnitCode | 1 | 0 |
| `GetPendingVATAdvanceCol` | method | p_PartyCode, p_Vchcode, p_VchDate, p_RegionType, p_NewRefVchType | 5 | 0 |
| `CheckIfRefNoExistForPartyInAdvanceVAT` | method | p_RefNo, p_PartyCode, p_Vchcode, p_RecType | 4 | 0 |
| `LoadVchVATSumAccInfo` | method | p_Vchcode, p_RecType | 2 | 0 |
| `SaveVchVATSumAccInfo` | method | p_Vchcode, p_VchGSTDet, p_UsedForCFY | 3 | 0 |
| `DeleteVchVATSumAccInfo` | method | p_Vchcode | 1 | 0 |
| `DeleteVATAdvanceReceiptRefs` | method | p_ItemGSTDetCol, p_PartyCode | 2 | 0 |
| `DeleteVATAdvancePaymentRefs` | method | p_ItemGSTDetCol, p_PartyCode | 2 | 0 |
| `CheckIfPartyPendingVATAdvanceAdjExists` | method | p_PartyCode, p_Vchcode, p_VchDate, p_RegionType, p_NewRefVchType | 5 | 0 |
| `IfVATAdvRefBelongToParty` | method | p_RefNo, p_PartyCode, p_NewRefVchType | 3 | 0 |
| `GetSaleInvoiceJSONForIRDUpload` | method | p_VchData, p_VchVATSum, p_IsRealTime | 3 | 0 |
| `GetSaleReturnInvoiceJSONForIRDUpload` | method | p_VchData, p_VchVATSum, p_IsRealTime | 3 | 0 |
| `UploadDataOnIRD` | method | p_VchType, p_JSONStr, p_ErrStr | 3 | 0 |
| `UpdateTran1ForNepalIRDDataSyn` | method | p_Vchcode, p_InputMode | 2 | 0 |
| `AutoNepalDataUploadOnIRD` | method |  | 0 | 0 |
| `CheckTranTableToResetFYBegDate` | method | p_StartDate, p_EndDate | 2 | 0 |
| `IfAnyEntryExistInTran1` | method |  | 0 | 0 |
| `GetVchFirstItemcode` | method | p_Vchcode, p_UnitName | 2 | 0 |
| `ShowDemmedTaxInVch` | method | p_VchType, p_Trantype | 2 | 0 |
| `GetAllPrevPaymentVchToCalTDS` | method | p_MasterCode1, p_TDSCatCode, p_TotalAmt, p_Date, p_CurrentVchCode, p_IfTDSAlreadyDeducted, p_ITPAN | 7 | 0 |
| `CheckforTDSTaxType` | method | p_AccCode | 1 | 0 |
| `GetTDSCatCode` | method | p_AccCode | 1 | 0 |
| `GetTDSAccountFromTDSCatCode` | method | p_TDSCatCode | 1 | 0 |
| `GetPendingConsignmentForPurchaser` | method | p_VchType, p_SellerParty, p_PurchaserParty, p_IfStockOnSeller, p_Vchcode, p_Trantype, p_IfAgainstChallan, p_ExcludeGrpBy, p_IfDiscount, p_ShowDescription, p_GetSalePrice | 11 | 0 |
| `UploadFileWithSMS` | method | p_FileNameWithPath, p_FileName | 2 | 0 |
| `GetFile` | method | strFileName | 1 | 0 |
| `GetFinalStockOfConsignment` | method | p_CustCode, p_VendorCode, p_Vchcode, p_VchType, p_IncludeWithoutCustomer, p_Trantype, p_ExcludeGrpBy, p_ShowItemDesc | 8 | 0 |
| `GetPendParametersForConsignmentThruOrder` | method | p_CSPArtyCode, p_CPPartyCode, p_ItemCode, p_ConId, p_VchType, p_Trantype, p_FromReturn | 7 | 0 |
| `FindParamInCol` | method | p_Col, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_BCN | 7 | 0 |
| `GetSalePurcPriceDiscFromConSaleOrder` | method | p_OrderID, p_Price, p_VchType, p_Trantype | 4 | 0 |
| `FormNoExist` | method | p_VchType, p_formNo, p_Date, p_Vchcode | 4 | 0 |
| `GetFormsVchData` | method | p_Vchcode | 1 | 0 |
| `UpdatePortCodeDetInHelp2` | method |  | 0 | 0 |
| `CheckIfConsignmentOrderIsAdjusted` | method | p_ConId, p_ErrStr | 2 | 0 |
| `UpdateItemTaxAmtsInMultiRateVch4GSTINDIA` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetPendParametersForConsignmentWithoutOrder` | method | p_CSPArtyCode, p_CPPartyCode, p_ItemCode, p_VchType, p_Vchcode, p_SalePrice, p_ConId | 7 | 0 |
| `GetPendingConsignmentForReturn` | method | p_VchType, p_SellerParty, p_PurchaserParty, p_IfStockOnSeller, p_Vchcode, p_Trantype, p_IfAgainstChallan, p_ExcludeGrpBy, p_ShowDescription | 9 | 0 |
| `CheckForConsignmentIDAdjustment` | method | p_ItemEntries, p_ErrStr | 2 | 0 |
| `GetTaxableAndTaxAmtForUnApprovedVchInGSTIndia` | method | p_udtVchData, p_STPTMast, p_TaxableAmt, p_TotalTaxAmt, p_TaxAmt, p_TaxAmt1, p_CessAmt, p_ACessAmt, p_StateCess | 9 | 0 |
| `CheckIfStateCessToBeApplied` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetTranAmtAndDateOfItemAccInGivenVch` | method | p_Vchcode, p_AccCode, p_TranDate | 3 | 0 |
| `GetGSTR2AStatus` | method | p_Vchcode, p_RefNo, p_AccCode, p_GSTR2B | 4 | 0 |
| `ModifyPartyGSTINInVchGSTSumItemWise` | method | p_GSTIN, p_PartyCode | 2 | 0 |
| `GetPartyGSTINfromPartyCode` | method | p_PartyCode | 1 | 0 |
| `GetPartyPANfromPartyCode` | method | p_PartyCode | 1 | 0 |
| `ModifyPartyPANInVchGSTSumItemWise` | method | p_PAN, p_PartyCode | 2 | 0 |
| `UpdateItemTaxAmtsInVch4ExcludeStateCess` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetFormatListForVSCode` | method | p_VSCode, p_Format_Type, p_FormatNo, p_FormatName | 4 | 0 |
| `GetTotalSaleAndRcptDependingUponPAN` | method | p_MastCode, p_ITPAN, p_Vchcode, p_VchDate, p_TotSaleAmt, p_FoundInLastYear, p_DontCheckPrevYr | 7 | 0 |
| `GetEInvQRCodeFilePath` | method | p_Vchcode, p_FilePath, p_ErrMsg | 3 | 0 |
| `CheckIfEInvoiceApplicable` | method | p_Vchcode | 1 | 0 |
| `CheckVch4EInvoiceQRCode` | method | p_VchData, p_EInvQRCodeApplicable, p_B2CQRCodeApplicable, p_EInvQRCodeApp4SaudiArabia | 4 | 0 |
| `GetTotalPurcAndPymtDependingUponPAN` | method | p_MastCode, p_ITPAN, p_Vchcode, p_VchDate, p_TotPurcAmt, p_FoundInLastYear, p_DontCheckPrevYr | 7 | 0 |
| `CheckAndUpdateCompBusinessType` | method | p_GSTIN, p_PAN, p_ForceUpdateBusinessType | 3 | 0 |
| `UpdateBusinessTypeInCompany` | method | p_Value | 1 | 0 |
| `GetCompBusinessType` | method |  | 0 | 0 |
| `GetEInvQRCodeImgPathForSaudiArabia` | method | p_Vchcode | 1 | 0 |
| `GetGSTReturnCaptchaImageFilePath` | method | p_B64Str | 1 | 0 |
| `CheckCSUserTagging` | method | p_MasterCode, p_UserName, p_DontCheckCheckVchNum, p_Mastertype | 4 | 0 |
| `GetLastVchInSeries4AutomaticNum` | method | p_VSC, p_VchRenumFreq, p_VchDate, p_Vchcode | 4 | 0 |
| `DeleteAnyRecoEntryToBeSyncIfVchIsDeleted` | method | p_VchNo | 1 | 0 |
| `DeleteAnyDeletedInfoEntryIfVchIsAddedOrModified` | method | p_VchNo | 1 | 0 |
| `IfVchCodeBasedReportNotes` | method | p_RepID | 1 | 0 |
| `IsBankRecoEntriesChanged` | method | p_OldVchData, p_NewVchData, p_NewVchAmt | 3 | 0 |
| `GetVoucherApprovalDetailJson` | method | JSON, p_ApprovalDetails, p_InputMode, p_ModifyVch, p_OldApprovalDetails, p_VchType, p_tmpVchSeriesCode | 7 | 0 |
| `CheckIfSaleReturnAgainstSaleExist` | method | p_SaleVchNo | 1 | 0 |
| `IsItemInSingleVch4Consignment` | method | p_VchType, p_ItemData, p_StartDate, p_EndDate, p_IsUsedForUtility | 5 | 0 |
| `CreateStandardLog` | method | p_str | 1 | 0 |

## Busy2L21.COtherServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `UserNameExists` | method | p_Name, p_CK | 2 | 0 |
| `ValidUserPassword` | method | p_Name, p_Password, p_CK | 3 | 0 |
| `GetPrevUser` | method | p_Name, p_IfSuperUser | 2 | 0 |
| `GetNextUser` | method | p_Name, p_IfSuperUser | 2 | 0 |
| `GetUserProfile` | method | p_Name, p_UserProfile1 | 2 | 0 |
| `IfSuperUserAndPassword` | method | p_Name, p_Pass | 2 | 0 |
| `CheckIfSuperUserAndPassword` | method | p_Name, p_Pwd | 2 | 0 |
| `IfVaildUserAndPasswordForMultiCompResult` | method | p_Name, p_Pass, p_ErrMsg | 3 | 0 |
| `IfSuperUser` | method | p_Name | 1 | 0 |
| `IfUserExists` | method |  | 0 | 0 |
| `GetVchNumInfoData` | method | p_SeriesCode | 1 | 0 |
| `GetVchConfigInfoData` | method | p_SeriesCode, p_DontCheckStamp | 2 | 0 |
| `GetWarningAlarmsInfo` | method | p_DonotChangeValuesForSuperUser | 1 | 0 |
| `GetDosPrinterDrv` | method | p_Name | 1 | 0 |
| `GetAllPRFormats` | method | p_PRID, p_FormatType | 2 | 0 |
| `CreateNewPRFormat` | method | p_PRID, p_FormatName, p_PageSetting | 3 | 0 |
| `PRFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `PRFormatNameExistInRepository` | method | p_PRID, p_FormatName | 2 | 0 |
| `UpdatePRFormat` | method | p_PRID, p_PRSUBID, p_FormatName, p_Lines, p_Col | 5 | 0 |
| `ReadPRFormat` | method | p_PRID, p_PRSUBID, p_FormatName, p_Col | 4 | 0 |
| `ReadPRPageSetting` | method | p_PRID, p_FormatName | 2 | 0 |
| `UpdatePRPageSetting` | method | p_PRID, p_FormatName, p_PageSetting | 3 | 0 |
| `DeletePRFormat` | method | p_PRID, p_FormatName | 2 | 0 |
| `LoadStateSpecificFormats` | method | p_State | 1 | 0 |
| `LoadOtherFormats` | method |  | 0 | 0 |
| `CreateGSTSlipFormat` | method |  | 0 | 0 |
| `CreateStandardInvoiceFormat` | method | p_RepID | 1 | 0 |
| `GetDefaultFormatUdt` | method | p_RepID | 1 | 0 |
| `GetP` | method | p_rstP | 1 | 0 |
| `SetP` | method | p_QG, p_P | 2 | 0 |
| `Num2Fig` | method | p_Num, p_CurSubString, p_CurDecimal, p_CurString | 4 | 0 |
| `UpdateBillsInfoAccWise` | method | p_AccsArr | 1 | 0 |
| `UpdateBillsInfoOfAccs` | method | p_AccsArr, p_BillsArr | 2 | 0 |
| `UpdateBatchNoInfoOfItems` | method | p_ItemsArr, p_BatchesArr | 2 | 0 |
| `InitSRRepData` | method | p_SRRepData | 1 | 0 |
| `InitSROnEnterInfo` | method | p_OnEnterInfo | 1 | 0 |
| `GetOnAccAmtWithAccBal` | method | p_StartDate, p_EndDate, p_MasterCode, p_LedgerBal, p_CurType, p_BranchCode, p_VSGrpCode | 7 | 0 |
| `GetAgeingSlabs` | method | p_AgeingType, p_InputMode | 2 | 0 |
| `GetMaxElmtInGrid` | method |  | 0 | 0 |
| `SaveMaxElmtInGrid` | method | p_MaxElmtInGrid | 1 | 0 |
| `GetTotalMaxCharForItemFreeQty` | method | p_Repopt | 1 | 0 |
| `GenItemTranQtyFilterQryStr` | method | p_Repopt, p_IncludeRerurn, p_TblAliasStr, p_ConcateAndOprator | 4 | 0 |
| `GetItemTranQty` | method | p_Repopt, p_ItemCode, p_Amt | 3 | 0 |
| `GetIgrpTranQty` | method | p_Repopt, p_IgrpCode, p_Amt | 3 | 0 |
| `UpdateAgeingSlabs` | method | p_Ageing, p_NoOfFld, p_AgeingType | 3 | 0 |
| `GetCashBankCols` | method | p_masterSeriesGrpCode | 1 | 0 |
| `GetAccRegCols` | method | p_ConfigType, p_VchType, p_FormatName | 3 | 0 |
| `UpdateAccRegCols` | method | p_AccRegCols, p_ConfigType, p_VchType, p_ModifyRecords, p_FormatName, p_PRID | 6 | 0 |
| `LockTempTabel` | method |  | 0 | 0 |
| `ReleaseTempTabel` | method | p_TabelNo | 1 | 0 |
| `InitVATInfoUDT` | method | p_VATInfo | 1 | 0 |
| `InitVATTranTypesUDT` | method | p_VATTranTypes | 1 | 0 |
| `InitVchVATSumUDT` | method | p_VchVATSum | 1 | 0 |
| `InitItemGSTDet` | method | p_ItemGSTDet | 1 | 0 |
| `InitVchGSTSumItemWiseUDT` | method | p_VchGSTSumItemWise | 1 | 0 |
| `InitUdtSTPTMast` | method | p_udtSTPTMast | 1 | 0 |
| `MakeComponents` | method | p_SrcFile, p_TrgFile, p_CompSize | 3 | 0 |
| `CopyFile` | method | p_SrcFile, p_TrgFile, p_OverWrite | 3 | 0 |
| `Append2File` | method | p_SrcFile, p_TrgFile | 2 | 0 |
| `ChangeName` | method | p_Path, p_EmbeddedFYInsteadofDate, FinYear | 3 | 0 |
| `CreateLocksSysFile` | method | p_CompPath | 1 | 0 |
| `CreateLocks1SysFile` | method | p_CompPath | 1 | 0 |
| `UserExistInCompany` | method | p_CompPath, p_Year | 2 | 0 |
| `ExclusiveOperationInCompany` | method | p_CompPath, p_ForSync | 2 | 0 |
| `SetExclusiveMode` | method | p_CompPath, p_ForSync | 2 | 0 |
| `ResetExclusiveMode` | method | p_ForSync | 1 | 0 |
| `ChangeMasterNameinDB` | method | p_db, p_Con, p_MastType, p_OldName, p_NewName | 5 | 0 |
| `ChangeNameInOtherYears` | method | p_MastType, p_OldName, p_NewName | 3 | 0 |
| `OtherFinYearsExist` | method |  | 0 | 0 |
| `GetDefaultDocName` | method | p_VSCode, p_FormatNo | 2 | 0 |
| `GetDefaultFAVchName` | method | p_VSCode | 1 | 0 |
| `PrintCentreLine` | method | p_RepEvents, p_PaperType, p_str, p_AddFont, p_WinFonts | 5 | 0 |
| `PrintLineInMultipleLines` | method | p_RepEvents, p_str, p_PaperType | 3 | 0 |
| `PrintCompNameAndAddInfo` | method | p_RepEvents, p_Width, p_BlankLine, p_WinFonts, p_PropotionalFont | 5 | 0 |
| `PrintCompNameAndAddInfoSlipFormat` | method | p_RepEvents, p_Width | 2 | 0 |
| `GetPaperType` | method | p_Width | 1 | 0 |
| `PrintCompSTInfo` | method | p_RepEvents, p_Width, p_WinFonts | 3 | 0 |
| `PrintRepTitle` | method | p_Repopt, p_RepEvents, p_Width, p_WinFonts | 4 | 0 |
| `PrintRepTitleSlipFormat` | method | p_Repopt, p_RepEvents, p_Width, p_TitleStyle | 4 | 0 |
| `GetLine` | method | p_Len, p_LineChar | 2 | 0 |
| `GetDateRangeStr` | method | p_StartDate, p_EndDate | 2 | 0 |
| `GetDateRangeStrWithMCName` | method | p_StartDate, p_EndDate, p_MCCode | 3 | 0 |
| `GetDateRangeStrWithSeriesName` | method | p_StartDate, p_EndDate, p_SeriesName | 3 | 0 |
| `GetAsOnDateStr` | method | p_Date | 1 | 0 |
| `GetItemDetInVchWithColumns` | method | p_Vchcode, p_UsePrintName, p_ItemDetailsGrid | 3 | 0 |
| `PrintColumns` | method | p_RE, p_Columns, p_OffSet, p_PrnStyle, p_MaxSize, p_OffSetPrintStyle | 6 | 0 |
| `PrintColumnsWithLF` | method | p_RE, p_Columns, p_OffSet, p_PrnStyle, p_MaxSize, p_OffSetPrintStyle | 6 | 0 |
| `GetStrFromItemDetColumns` | method | p_Columns | 1 | 0 |
| `PrintFormatNumDCStr` | method | p_DCStr, p_RE, p_PrnStyle, p_MaxChar, p_PadLeft, p_ShowZeroAsBlank | 6 | 0 |
| `GetFormatNumDCStrCol` | method | p_DCStr, p_ShowZeroAsBlank | 2 | 0 |
| `BreakStr` | method | p_str, p_MaxChar, p_ConsiderLineFeed | 3 | 0 |
| `GetNarLines` | method | p_Vchcode, p_MaxChar | 2 | 0 |
| `GetNarLinesFromNarration` | method | p_Narration1, p_Narration2, p_MaxChar | 3 | 0 |
| `GetOFInVch` | method | p_Vchcode, p_VchSeriesCode | 2 | 0 |
| `GetOFInVchWithColumn` | method | p_Vchcode, p_VchSeriesCode | 2 | 0 |
| `GetExtraDetPrnStyle` | method | p_ExtraDetType | 1 | 0 |
| `GetUDTPrintCol` | method | p_Fld, p_Alignment, p_Size, p_PrintHorLine, p_PrnStyle, p_ULStr, p_PrnStyle1, p_LinkType, p_IconType | 9 | 0 |
| `GetTotalStrWithLineChar` | method | p_RepOver, p_TotalStr, p_LineChar, p_Continuos, p_PrnStyle | 5 | 0 |
| `GetItemAliasDescLines` | method | p_ItemMast | 1 | 0 |
| `GetMastAddLines` | method | p_AddInfo | 1 | 0 |
| `GetBillingDetAddSTNoLines` | method | p_BillingDet, p_IncludeAddress, p_IncludeSTNo | 3 | 0 |
| `GetMastAddSTNoLines` | method | p_AddInfo, p_IncludeAddress, p_IncludeLST | 3 | 0 |
| `GetMastAddLinesIn2Lines` | method | p_AddInfo | 1 | 0 |
| `PrintMasterAddress` | method | p_AddInfo, p_RE, p_PaperType | 3 | 0 |
| `PrintPageSkipInfo` | method | p_Repopt, p_RE, p_PaperType, p_WinFonts, p_Width | 5 | 0 |
| `ReadFullPRFormat` | method | p_RepID, p_FormatName, p_strError | 3 | 0 |
| `WriteFullPRFormat` | method | p_FormatName, p_RepID, p_Lines | 3 | 0 |
| `WriteFullDOSPRFormat` | method | p_FormatName, p_RepID, p_Lines | 3 | 0 |
| `SortNums` | method | p_Col | 1 | 0 |
| `GetMasterNameLen` | method | p_Mastertype | 1 | 0 |
| `CanDeleteComp` | method | p_CompCode, p_UserName, p_Password | 3 | 0 |
| `ValidUser` | method | p_CompCode, p_UserName, p_Password, p_BackupConfig, p_CanTakeBackup | 5 | 0 |
| `DeleteComp` | method | p_CompCode, p_Year, p_strError | 3 | 0 |
| `CheckIntegrityOfYear` | method | p_CompPath, p_Year, p_CompCode, p_CreationTime | 4 | 0 |
| `UpdateOEDInfo` | method | p_Vchcode, p_OEDRate, p_OEDAmount, p_CessRate, p_CessAmount, p_HECessRate, p_HECessAmount | 7 | 0 |
| `GetUserPassInfo` | method | p_Names, p_Passwords | 2 | 0 |
| `GetUserPass` | method | p_Name | 1 | 0 |
| `GetTotalUnitNames` | method | p_ItemDataArr, p_TotalMainUnit, p_TotalAltUnit | 3 | 0 |
| `ItemDataRST2UDT` | method | p_rst | 1 | 0 |
| `CheckItemDataTaxType` | method | p_ItemData | 1 | 0 |
| `GetMasterNameAddCol` | method | p_Name, p_AddInfo | 2 | 0 |
| `GetItemAFName` | method | p_VSCode | 1 | 0 |
| `GetProperSTNo` | method | p_STRegType, p_AccMast | 2 | 0 |
| `UpdateAccAddStNoArr` | method | p_Col, p_AccMast, p_STRegType, p_IncludeAddress | 4 | 0 |
| `GetFinYrStr` | method |  | 0 | 0 |
| `InitUDTQOF` | method | p_udtQOF | 1 | 0 |
| `InitUDTQuery` | method | p_udtQuery | 1 | 0 |
| `InitUdtQueryBal` | method | p_udtQueryBal | 1 | 0 |
| `CheckMasterOFForQuery` | method | p_QOF, p_MastCode | 2 | 0 |
| `CheckVchForQuery` | method | p_QueryData, p_Vchcode | 2 | 0 |
| `UpdateOFInfoStr` | method | p_OFInfo, p_str, p_MastType | 3 | 0 |
| `GetMaxCharsFromInvQuery` | method | p_QueryData, p_Repopt | 2 | 0 |
| `GetMaxCharsFromProdQuery` | method | p_QueryData, p_Repopt | 2 | 0 |
| `GetSTRegTypeFromSTPTCode` | method | p_STPTCode, p_VchType | 2 | 0 |
| `GetItemTotalDiscount` | method | p_ItemData, p_STPTMast, p_DiscountPercentBasis | 3 | 0 |
| `UpdateBatchesInItemDataFromPendingBatches` | method | p_ItemEntries, p_PendingBatches | 2 | 0 |
| `UpdatePendingBatchesFromBatchesInItemData` | method | p_ItemEntries, p_VchType, p_MCCode, p_Date, p_PendingBatches | 5 | 0 |
| `CopyingBatchReferencesInVchData` | method | p_udtVchData, p_MCCode, p_InputMode | 3 | 0 |
| `GetARFArr` | method | p_Flds, p_Sizes | 2 | 0 |
| `GetARFTitle` | method | p_No | 1 | 0 |
| `GetARFldValue` | method | p_FldNo, p_Size, p_VchData, p_ExtraInfo | 4 | 0 |
| `GetAccRegColsAndSize` | method | p_ConfigType, p_VchType, p_cols, p_Size, p_FormatName, p_MSGrpCode, p_Mastertype | 7 | 0 |
| `GetCostCentreColsAndSize` | method | PRID, p_cols, p_Size, p_FormatName, p_MSGrpCode, p_Mastertype | 6 | 0 |
| `AddEntryInLongColIfNotExist` | method | p_Col, p_LongVal, p_UseKey | 3 | 0 |
| `AddEntryInTextColIfNotExist` | method | p_Col, p_TextVal, p_IfFound, p_UseKey | 4 | 0 |
| `GetBarCodeConfigData` | method | p_PRID | 1 | 0 |
| `UpdateBarCodeConfigData` | method | p_PRID, p_BarCodeConfig | 2 | 0 |
| `CheckNegativeCash` | method | p_Date, p_Bal | 2 | 0 |
| `CheckOpTrialBal` | method | p_DrOp, p_CrOp, p_DrCl, p_CrCl | 4 | 0 |
| `GetVchTypeFromVchSeriesCode` | method | p_VchSeriesCode | 1 | 0 |
| `Series2MasterName` | method | p_VchType, p_SeriesName | 2 | 0 |
| `MasterName2Series` | method | p_MasterName | 1 | 0 |
| `ValidDateInCurFY` | method | p_Date, p_DateTypeStr, p_ErrMsg | 3 | 0 |
| `ValidDateInTran` | method | p_Date, p_VchType, p_VchSeriesCode, p_DateTypeStr, p_InputMode, p_ErrMsg, p_Code | 7 | 0 |
| `EvaluationExpired` | method | p_Date, p_ErrMsg | 2 | 0 |
| `GetTotalVchCount` | method | p_VchType | 1 | 0 |
| `GetAuditorEditionMsg` | method |  | 0 | 0 |
| `Actual2FinMonth` | method | p_Month, p_BegFY, p_DateType | 3 | 0 |
| `Fin2ActualMonth` | method | p_Month, p_BegFY, p_DateType | 3 | 0 |
| `GetFullMonthStr` | method | nMonth, p_DateType | 2 | 0 |
| `FullMonthStr2No` | method | strMonth | 1 | 0 |
| `VchType2ShortName` | method | p_VchType, p_VchSeriesCode, p_LoadSavedCaptionFlag | 3 | 0 |
| `ShortName2VchType` | method | p_Name | 1 | 0 |
| `VchType2FullName` | method | p_VchType, p_VchSeriesCode, p_LoadSavedCaptionFlag | 3 | 0 |
| `FullName2VchType` | method | p_Name | 1 | 0 |
| `Actual2Index` | method | p_str, p_Len | 2 | 0 |
| `Index2Actual` | method | p_str, p_Len | 2 | 0 |
| `MasterName2Type` | method | txtMaster | 1 | 0 |
| `MasterType2Name` | method | p_Mastertype, p_LoadSavedCaptionFlag | 2 | 0 |
| `DecideAmtType` | method | p_Amt | 1 | 0 |
| `InvVch` | method | p_VchType | 1 | 0 |
| `PureInvVch` | method | p_VchType | 1 | 0 |
| `SalaryVch` | method | p_VchType | 1 | 0 |
| `AccVch` | method | p_VchType | 1 | 0 |
| `GetClosingStockWithGPRatio` | method | p_GPRatio, p_FinMonth | 2 | 0 |
| `GetPartyPendingOrderVch` | method | p_AccCode, p_RefType, p_OpRefs, p_OnlyCheckIfOrderExist, p_VchTillDate, p_BrokerCode | 6 | 0 |
| `GetPartyPendingQuotationVch` | method | p_AccCode, p_RefType, p_OpRefs, p_OnlyCheckIfQuotationExist, p_VchTillDate, p_BrokerCode | 6 | 0 |
| `GetPartyPendingChallanVch` | method | p_AccCode, p_VchType, p_RefType, p_OpRefs, p_VchTillDate, p_BrokerCode | 6 | 0 |
| `GetMCPendingIndentVch` | method | p_MCCode, p_RefType, p_OpRefs, p_VchTillDate | 4 | 0 |
| `GetData` | method | p_str, p_rst | 2 | 0 |
| `UpdateUDFData` | method | p_TabelName, p_FldName, p_FldVal, p_WhereClause | 4 | 0 |
| `UpdateItemSrNoInPendingChallanOrderRefs` | method | p_ItemCode, p_RecType, p_ItemEntries, p_Refs, p_AltCurUnitReq, p_UpdateInDb | 6 | 0 |
| `GetParamQryStrFromConfig` | method |  | 0 | 0 |
| `GetParamColFromRst` | method | p_rst, p_RetParamCol, p_DontUseKey | 3 | 0 |
| `GetPendingParamInOrderAdjItemWise` | method | p_ItemCode, p_RecType, p_VchType, p_StartDate, p_EndDate, p_RepDate, p_IncludeUnapprovedVch, p_AccCol | 8 | 0 |
| `UpdateBalSheetScheduleInTran1` | method | p_BalSheetInt, p_Vchcode | 2 | 0 |
| `DeleteEWayBillDet` | method | p_Vchcode | 1 | 0 |
| `LoadBalSheetScheduleFromTran1` | method | p_Vchcode | 1 | 0 |
| `GetPendingParamInOrderAdjRefCodeWise` | method | p_RefCode, p_ItemCode, p_RecType, p_ItemSrNo, p_NewRefParamCol, p_Vchcode | 6 | 0 |
| `GetTotalPendingParamsQty` | method | p_ParamCol, p_TotalQtyAlt | 2 | 0 |
| `PickPendingParamsOfReqdQty` | method | p_ParamCol, p_ReqdQty | 2 | 0 |
| `GetDemoDays` | method | p_DemoSrNo | 1 | 0 |
| `DeleteFromHelp2` | method | p_RecType1, p_RecType2, p_RecType3, p_Val | 4 | 0 |
| `CompareNum` | method | p_BaseNum, p_NumToCheck, p_Op, p_SecondNum | 4 | 0 |
| `GetMCCodesForItemBalQuery` | method | p_QueryData, p_BookStockOnly, p_MCCodes | 3 | 0 |
| `GetMastListFromCodeRST` | method | p_FldName, p_rst, p_MastNames, p_MastCols, p_FlushCol, p_Sort | 6 | 0 |
| `InitRepOptFields` | method | p_Repopt, p_PrnRep | 2 | 0 |
| `InitUDTAccMast` | method | p_AccMast | 1 | 0 |
| `InitUDTItemMast` | method | p_ItemMast | 1 | 0 |
| `InitudtMultiPriceDateWise` | method | p_udt | 1 | 0 |
| `InitUDTMCMast` | method | p_MCMast | 1 | 0 |
| `InitUDTCCMast` | method | p_CCMast | 1 | 0 |
| `InItUdtRefData` | method | p_udtRef | 1 | 0 |
| `InitUDTBrokerMast` | method | p_BrokerMast | 1 | 0 |
| `InitUDTAuthorMast` | method | p_AuthorMast | 1 | 0 |
| `InitUDTContactMast` | method | p_ContactMast | 1 | 0 |
| `InitUdtVchData` | method | p_udt | 1 | 0 |
| `InitUdtCallVchData` | method | p_udt | 1 | 0 |
| `InitUdtVChOtherInfo` | method | udtVchOtherInfo | 1 | 0 |
| `InitUdtVchOF` | method | p_udtVchOtherInfo | 1 | 0 |
| `GetVchOrgAndModAmount` | method | p_Vchcode, p_VchModAmt | 2 | 0 |
| `AddToDeletedInfo` | method | p_Type, p_VchMastType, p_Identity, p_VchOrgAmt, p_VchModAmt, p_Source, p_DeletedBy, p_DeletionTime | 8 | 0 |
| `AddToDeletedMasters` | method | p_Type, p_Name | 2 | 0 |
| `DeleteVATInfo` | method | p_Vchcode | 1 | 0 |
| `DeleteGSTInfo` | method | p_Vchcode | 1 | 0 |
| `SaveVATInfo` | method | p_Vchcode, p_VATJV | 2 | 0 |
| `SaveGSTInfo` | method | p_Vchcode, p_GSTJVCol | 2 | 0 |
| `CheckAndReturnValidRefNo` | method | p_RefNo, p_RefType, p_MastCode1, p_MastCode2, p_VchType, p_VchDate, p_Vchcode | 7 | 0 |
| `TaxType2Str` | method | p_Type | 1 | 0 |
| `TaxStr2Type` | method | p_str | 1 | 0 |
| `ITCType2String` | method | p_Type | 1 | 0 |
| `ITCString2Type` | method | p_str | 1 | 0 |
| `ITCType2StringForHeader` | method | p_Type | 1 | 0 |
| `ITCString2TypeForHeader` | method | p_str | 1 | 0 |
| `SurchargeApplicable` | method | p_STPTMast, p_SurchargeConfig, p_IncludeMT, p_SchgAppl4Pakistan | 4 | 0 |
| `GetItemSTDef` | method | p_STPTMast, p_ItemMast | 2 | 0 |
| `ConvertTextArr2Col` | method | p_Textarr, p_Col | 2 | 0 |
| `GetFldVal` | method | p_Fld | 1 | 0 |
| `PakSTRegType2Name` | method | p_RegType | 1 | 0 |
| `HaryanaVATRegType2Name` | method | p_RegType, p_SubRegType | 2 | 0 |
| `PakSTRegName2Type` | method | p_RegName | 1 | 0 |
| `HaryanaVATRegName2Type` | method | p_RegName, p_SubRegType | 2 | 0 |
| `Mp` | method | p_Name, p_Pass | 2 | 0 |
| `EK` | method |  | 0 | 0 |
| `CheckIfSTPTType2RegExist` | method | p_STPTType, p_STPTNames, p_RegType, p_SubRegType | 4 | 0 |
| `ReqSTPTData` | method | p_STPTType | 1 | 0 |
| `MasterTypeExist` | method | p_MastType | 1 | 0 |
| `BeginTran` | method |  | 0 | 0 |
| `CommitTran` | method |  | 0 | 0 |
| `RollBackTran` | method |  | 0 | 0 |
| `SaveIADPrintingData` | method | p_udtIADPrinting | 1 | 0 |
| `GetIADPrintingData` | method |  | 0 | 0 |
| `GetUserLog` | method | p_CompCode, p_CompNames, p_UserNames, p_Dates | 4 | 0 |
| `GetSTBsNo` | method | p_BSArr, p_VchType, p_STType, p_Default | 4 | 0 |
| `ReadExcelImportConfig` | method | p_Mastertype, p_RecType | 2 | 0 |
| `WriteExcelImportConfig` | method | p_udtImportFromExcel, p_RecType | 2 | 0 |
| `GetVchFldFromARFld` | method | AccRegCols | 1 | 0 |
| `GetFields4Explore` | method | p_MastType, p_BulkAccountInputConst | 2 | 0 |
| `CreateDefaultFileds4ExploreForModify` | method | p_MastType, p_BulkAccountInputConst, p_UsedForExpenseAcc | 3 | 0 |
| `WriteFields4Explore` | method | p_MastType, p_Fields | 2 | 0 |
| `GetAllMasterCode` | method | p_Mastertype, p_ParentGrp, p_MSCode, p_ExcludeDeactivate | 4 | 0 |
| `GetDueBills` | method | p_PartyCode, p_BillDate, p_ExcludePDC | 3 | 0 |
| `GetSTNosStr` | method | p_AddInfo | 1 | 0 |
| `GetChildMasterType` | method | p_ParentMasterType | 1 | 0 |
| `RaiseError` | method |  | 0 | 0 |
| `RecordExist` | method | p_Qry | 1 | 0 |
| `RecordExistinDB` | method | p_Qry | 1 | 0 |
| `GetRecordsetValue` | method | p_StrQry, RecordExist | 2 | 0 |
| `GetRecordsetValuesConcatenated` | method | p_StrQry, p_RowNo, p_colNo, p_RowSeprator, p_ColSeprator | 5 | 0 |
| `GetXMLFromRecordset` | method | p_StrQry, p_ErrMsg | 2 | 0 |
| `GetXMLFromRecordsetDB` | method | p_StrQry, p_ErrMsg | 2 | 0 |
| `GetRecordsetFromDatabase` | method | p_StrQry, p_db, p_Con, p_RaiseError, p_ErrMsg, p_LocalCaching | 6 | 0 |
| `GetRecordsetFromDB` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `GetRecordset` | method | p_StrQry, p_RaiseError, p_ErrMsg, p_LocalCaching | 4 | 0 |
| `IsEwayEinvInfoInVchCodeCol` | method | p_VchcodeCol | 1 | 0 |
| `QryUsedForNepal` | method | p_StrQry | 1 | 0 |
| `ExecuteQuery` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `ExecuteQueryInDB` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `ExecuteQueryInADOForSQL` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `MastCode2NameQry` | method | p_MastCodeStr | 1 | 0 |
| `GetItemInfoNameQryStr` | method | p_MasterCodeStr, p_ItemChs | 2 | 0 |
| `GetPartyDetailsForVATReports` | method | p_AccCode, p_Vchcode, p_PrintBillingDet, p_VchPartyName, p_STRegType | 5 | 0 |
| `MoveAccRegCol` | method |  | 0 | 0 |
| `GetTempRST` | method | p_TabelName | 1 | 0 |
| `GenQryInStrForParentGrps` | method | p_GrpCode, p_GrpType | 2 | 0 |
| `GenQryInStrFromCol` | method | p_Col, p_ForStringDataType | 2 | 0 |
| `GetUserList` | method | p_IncludeSuperUser | 1 | 0 |
| `GetSuperUserName` | method |  | 0 | 0 |
| `GetBillNo` | method | p_VchNo, p_PurchaseBillNo, p_VchType | 3 | 0 |
| `GetBillDate` | method | p_VchDate, p_PurchaseBillDate, p_VchType | 3 | 0 |
| `GetTableRST` | method | p_TableName, p_rst | 2 | 0 |
| `GetTableRSTForDB` | method | p_TableName, p_rst | 2 | 0 |
| `GetTaxVATStr` | method | p_STPTType, p_TaxType | 2 | 0 |
| `InitItemDataSTInfo` | method | p_ItemData | 1 | 0 |
| `BlankItemDataSTInfo` | method | p_ItemData | 1 | 0 |
| `PurgeCheckList` | method |  | 0 | 0 |
| `StateName2PDCode` | method | p_StateName, p_CountryCode | 2 | 0 |
| `StatePDCode2Name` | method | p_StateCode, p_CountryCode | 2 | 0 |
| `GetStatesList` | method | p_CountryCode, p_IncludeVirtualStatesAlso | 2 | 0 |
| `CountryCode2Name` | method | p_Code | 1 | 0 |
| `CountryName2Code` | method | p_Name, p_DoNotTreatOtherAsIndia | 2 | 0 |
| `GetVATOpBals` | method | p_Date | 1 | 0 |
| `GetPartyAddTinCST` | method | p_AccMastAddr, p_IncludeAdd | 2 | 0 |
| `UpdateVATJV` | method | p_udtVATJVITCol, p_udtVATJVOTCol, p_RefundJV, p_VchDate | 4 | 0 |
| `ExtractItemTarrifHeading` | method | p_str | 1 | 0 |
| `GetDocCopyType` | method | p_PRID | 1 | 0 |
| `UpdateDocCopyType` | method | p_PRID, p_Vals | 2 | 0 |
| `SortCollection` | method | p_Col | 1 | 0 |
| `FindItemInCol` | method | p_Item, p_Col | 2 | 0 |
| `FindItemInDoubleCol` | method | p_Num, p_Col | 2 | 0 |
| `STCatName2No` | method | p_STCatName | 1 | 0 |
| `STCatNo2Name` | method | p_STCatNo | 1 | 0 |
| `GetSTTypesForLS9` | method | p_TableType, p_STTypes, p_ShowTaxFree | 3 | 0 |
| `GetPTTypesForLP7` | method | p_TableType, p_PTTypes, p_IncludeMutiTaxForZeroTax, p_Include4NewAnnex | 4 | 0 |
| `GetMutiTaxPTTypes` | method | p_MTPTTypes | 1 | 0 |
| `Check4LP7LS9` | method | STPTName, p_STPTType | 2 | 0 |
| `GetMultiTaxSTTypes` | method | p_STPTType, p_InputTaxCredit | 2 | 0 |
| `GraphicsUsed` | method | p_PRID, p_FormatName | 2 | 0 |
| `CheckSLFontInReportHeaderFormat` | method | p_FormatName | 1 | 0 |
| `DataFontUsed` | method | p_PRID, p_FormatName, p_IfUniCodeFont | 3 | 0 |
| `CheckIfEInvoiceQRCodeUsed` | method | p_PRID, p_FormatName | 2 | 0 |
| `LoadInterestSlabs` | method | p_Basis | 1 | 0 |
| `SaveDataExportImportConfig` | method | p_RecType, p_udtData | 2 | 0 |
| `LoadDataExportImportConfig` | method | p_RecType, p_udtData | 2 | 0 |
| `SaveRepOptionValues` | method | p_RepID, p_Repopt, p_Options, p_RepType, p_FormatName | 5 | 0 |
| `GetRepOptValues` | method | p_Repopt, p_RepID, p_RepType, p_Options, p_FormatName | 5 | 0 |
| `SaveIQD` | method | p_Col, p_MasterCode, p_VchType, p_RecType, p_Date | 5 | 0 |
| `LoadIQD` | method | p_RecType, p_MasterCode, p_VchType, p_Date | 4 | 0 |
| `GetTDSDeducteeCategoryList` | method |  | 0 | 0 |
| `TDSDeducteeCatName2No` | method | p_TDSDeducteeCatName | 1 | 0 |
| `TDSDeducteeCatNo2Name` | method | p_TDSDeducteeCatNo | 1 | 0 |
| `TDSStatetName2Code` | method | p_TDSStateName | 1 | 0 |
| `TDSStateCode2Name` | method | p_TDSStateCode | 1 | 0 |
| `GetTDSPendingRef` | method | p_TDSCatCode, p_AccCode, p_VchDate | 3 | 0 |
| `GetTCSPendingRef` | method | p_PartyCode, p_SubCatCode, p_VchDate | 3 | 0 |
| `IfNewTDSRefAdjudted` | method | p_RefCode | 1 | 0 |
| `IfNewTCSRefAdjudted` | method | p_RefCode | 1 | 0 |
| `GetTDSRefBalanceAmount` | method | p_RefCode, p_VchAmt, p_TdsAmt, p_SurchargeAmt, p_CessAmt, p_SheCessAmt, p_IncludePayment | 7 | 0 |
| `GetTCSRefBalanceAmount` | method | p_RefCode, p_VchAmt, p_TCsAmt, p_SurchargeAmt, p_IncludePayment | 5 | 0 |
| `IfNewTDSRefHasZeroBalance` | method | p_RefCode, p_CheckTDSAmtOnly | 2 | 0 |
| `IfNewTCSRefHasZeroBalance` | method | p_RefCode, p_CheckTCSAmtOnly | 2 | 0 |
| `CheckPayeeTansactions` | method | p_PartyCode, p_ExpAcCode, p_AsOnDate, p_PayeeThresholdLimit, p_PayeeTranAmt, p_Vchcode, p_ExpTaxCatCode | 7 | 0 |
| `GetExpTDSCategoryCode` | method | p_ExpAccCode | 1 | 0 |
| `SaveExternalData` | method | p_KeyType, p_KeyCode, p_ExternalData | 3 | 0 |
| `DeleteExternalData` | method | p_KeyType, p_KeyCode | 2 | 0 |
| `SaveOrgSalePurcData` | method | p_Vchcode, p_OrgSalePurcDet | 2 | 0 |
| `DeleteOrgSalePurcData` | method | p_Vchcode | 1 | 0 |
| `LoadOrgSalePurcData` | method | p_Vchcode | 1 | 0 |
| `LoadOrgSalePurcDataFromRst` | method | p_rst, p_OSNode, p_ReadSource, p_TableAlias | 4 | 0 |
| `GetUnclearedEntries` | method | p_Repopt, p_DepositedCol, p_IssuedCol, p_UpdateDefaultShortNar | 4 | 0 |
| `GetUnclearedEntriesForDBJET` | method | p_Repopt, p_DepositedCol, p_IssuedCol, p_SettlementCol, p_Totals, p_UpdateDefaultShortNar | 6 | 0 |
| `GetSettlementEnabledVchCodeCol` | method | p_BankCode, p_DateRangeStr | 2 | 0 |
| `SeemsToBeUsingBRS` | method |  | 0 | 0 |
| `GetBRSBegDate` | method | p_ForUnCleared | 1 | 0 |
| `InitUserUDT` | method | p_udtUserProfile, p_udtUserProfile1 | 2 | 0 |
| `GetDefaultPOSPriorityCol` | method |  | 0 | 0 |
| `SavePOSConfig` | method | p_udtPOSVchConfig | 1 | 0 |
| `LoadPOSConfig` | method | p_SeriesCode, p_VchInModifyMode | 2 | 0 |
| `SavePOSGridConfig` | method | p_SeriesCode, p_udtGridConfig | 2 | 0 |
| `LoadPOSGridConfig` | method | p_SeriesCode, p_GridConfiguredByUser | 2 | 0 |
| `GetDefaultPOSGridConfig` | method |  | 0 | 0 |
| `DeletePOSConfig` | method | p_SeriesCode | 1 | 0 |
| `SaveSettlementDet` | method | p_udtSettlementData | 1 | 0 |
| `LoadSettlementDet` | method | p_Vchcode | 1 | 0 |
| `DeleteSettlementDet` | method | p_Vchcode | 1 | 0 |
| `IfBlankSettlementDet` | method | p_SettlementData | 1 | 0 |
| `GetNoofColumnsInGenricVatRegister` | method | p_Repopt | 1 | 0 |
| `GetTaxRateInfoInTran` | method | p_VchType, p_LocType, p_IncludeSalePurRet, p_IncludeCapitalPur, p_StartDate, p_EndDate, p_ItemsLocalRateOnly | 7 | 0 |
| `GetBSVchTypeCol` | method | p_MasterCode1, p_StartDate, p_EndDate, p_IncludePoSo | 4 | 0 |
| `AddItemInCol` | method | p_Col, p_Item, p_key | 3 | 0 |
| `GetItemFromCol` | method | p_Col, p_Item, p_key | 3 | 0 |
| `GetItemFromColWithPOS` | method | p_Col, p_Item, p_key, p_Pos | 4 | 0 |
| `GetValFromCol` | method | p_Col, p_Pos | 2 | 0 |
| `RemoveItemFromCol` | method | p_Col, p_key | 2 | 0 |
| `UpdateOrderRefNoInfoOfItems` | method | p_ItemsArr, p_OrderRefArr | 2 | 0 |
| `UpdateChallanRefNoInfoOfItems` | method | p_ItemsArr, p_ChallanRefArr | 2 | 0 |
| `RemoveSplCharFromFileName` | method | p_str | 1 | 0 |
| `CheckItemDescForQuery` | method | p_ItemData, p_SearchType, p_ItemDesc, p_NoOfLines | 4 | 0 |
| `GetAmtRoundedOff` | method | p_Amt, p_RoundOffType | 2 | 0 |
| `GetRightsMsg` | method |  | 0 | 0 |
| `GetVchRefDetails` | method | p_MastCode, p_Vchcode, p_RefType | 3 | 0 |
| `GetVchRefDetWithColumns` | method | p_MastCode, p_Vchcode, p_RefType | 3 | 0 |
| `GetBasePerAltCurConRate` | method | p_CurConRate, p_CurConType | 2 | 0 |
| `AddEntryToTran7` | method | p_MastCode | 1 | 0 |
| `CreateStdFaVchFormat` | method | p_RepID | 1 | 0 |
| `ReadStdFAVchFormat` | method | p_RepID | 1 | 0 |
| `GetMasterAddInfoFromRST` | method | p_rst, p_PickBillingDet | 2 | 0 |
| `GenMAI_BD_VOIQry` | method | p_MasterCodeFld, p_VchCodeFld | 2 | 0 |
| `GetFinYrsDB` | method | p_db, p_Con | 2 | 0 |
| `ChangeDB` | method | p_Year | 1 | 0 |
| `SaveCurrentDB` | method | p_Db1, p_con1 | 2 | 0 |
| `RestoreCurrentDB` | method | p_Db1, p_con1 | 2 | 0 |
| `GetDBNameFromConnectString` | method | p_str | 1 | 0 |
| `GetCSDataBaseSize` | method | p_CompCode, p_FYList, p_Con | 3 | 0 |
| `BackupCSDataBase` | method | p_CompCode, p_FYList, p_DestinationPath, p_BackupPath, p_DbSize, p_backupOnBusyOnline, p_dbPassword | 7 | 0 |
| `WorkingOnServer` | method |  | 0 | 0 |
| `GetServerMachineName` | method |  | 0 | 0 |
| `CheckAccessOnServerPath` | method | p_Path | 1 | 0 |
| `RestoreCSDataBase` | method | p_ScrDBPath, p_DBNameCol, p_NewCompCode | 3 | 0 |
| `GetSalePurReturnDet` | method | p_StartDate, p_EndDate, p_VchType, p_LocType, p_ItemWiseDetails | 5 | 0 |
| `GetArrayfromRst` | method | p_rst | 1 | 0 |
| `RemoveCurYearFromReg` | method | p_CompName | 1 | 0 |
| `SaveCurYearInReg` | method | p_CompName, p_Year | 2 | 0 |
| `GetCurYearFromReg` | method | p_CompName | 1 | 0 |
| `RemoveCurFYDateFromReg` | method | p_CompCode | 1 | 0 |
| `SaveCurFYDateInReg` | method | p_Date, p_DateType | 2 | 0 |
| `GetSaleVchDetForSR` | method | p_PartyCode, p_ItemCode, p_SRDate, p_SaleVchNo, p_SaleDate, p_TaxableAmt, p_TaxAmt | 7 | 0 |
| `CompoundDiscountEnable` | method | p_VchType | 1 | 0 |
| `GetValidDiscBasis` | method | p_StructureName, p_DiscPercentBasis | 2 | 0 |
| `GetValidMarkupBasis` | method | p_StructureName, p_MarkupPercentBasis | 2 | 0 |
| `GetSimpleDiscFromCompoundDisc` | method | p_CompoundDisc, p_DiscountBasis | 2 | 0 |
| `UpdateDiscMarkupStructureInItemData` | method | p_RecType, p_ItemData, p_VchConfig, p_ItemMast, p_VchType, p_Trantype | 6 | 0 |
| `GetCompoundDiscStrWithNotation` | method | p_CompDiscStr, p_udtStructure | 2 | 0 |
| `GetCompoundDiscStrWithoutNotation` | method | p_CompDiscStr | 1 | 0 |
| `GetCompoundDiscStrWithoutZero` | method | p_CompDiscStr | 1 | 0 |
| `GetValidDiscBasisFromStr` | method | p_str, p_DiscPercentBasis | 2 | 0 |
| `GetSimpleDiscFromCompoundDiscount` | method | p_RecType, p_ItemData, p_AltCurCode, p_TotalDiscPerUnit | 4 | 0 |
| `GetSimpleDiscFromCompoundDiscWithSameNature` | method | p_RecType, p_CompoundDisc, p_DiscountBasis, p_DiscountPercentBasis | 4 | 0 |
| `GetSimpleDiscFromCompoundDiscWithDiffNature` | method | p_RecType, p_ItemData, p_DiscStructure, p_AltCurCode, p_TotalDiscPerUnit | 5 | 0 |
| `UpdateDiscAmtColForDiscountMarkup` | method | p_RecType, p_ItemData, p_DiscStructure, p_AltCurCode, p_DiscountedAmt | 5 | 0 |
| `UpdateDiscAmtForDiscountInConsignment` | method | p_ItemData, p_AltCurCode, p_DiscountedAmt | 3 | 0 |
| `GetCompoundDiscFromSimpleDisc` | method | p_DiscStructure, p_DiscPercent, p_DiscAmt | 3 | 0 |
| `MasterType2XMLTagName` | method | p_MastType | 1 | 0 |
| `XMLTagName2MastType` | method | p_XmlTagName | 1 | 0 |
| `DisableBRSInCompConfig` | method |  | 0 | 0 |
| `ItemInfoNameToNumber` | method | p_Name | 1 | 0 |
| `ItemInfoNumberToName` | method | p_Number | 1 | 0 |
| `ContactInfoNameToNumber` | method | p_Name | 1 | 0 |
| `ContactInfoNumberToName` | method | p_Number | 1 | 0 |
| `AnalysisTypeStrToNum` | method | p_Name, p_VchType | 2 | 0 |
| `AnalysisTypeNumToStr` | method | p_AnalysisType, p_VchType | 2 | 0 |
| `GetItemInfoNameFromRst` | method | p_rst, p_Repopt, p_TableAlias | 3 | 0 |
| `GetAccInfoNameFromRst` | method | p_rst, p_Repopt, p_TableAlias | 3 | 0 |
| `VRCNum2Str` | method | p_VRCNum | 1 | 0 |
| `VRCStr2Num` | method | p_VRCName | 1 | 0 |
| `GetStateVRCCol` | method | p_State, p_STPTMastType | 2 | 0 |
| `VRCApplicableForState` | method | p_VRC, p_State, p_STPTMastType | 3 | 0 |
| `AltCurReq` | method | p_AccName | 1 | 0 |
| `GetStaticInfoMaxChar` | method | p_MaxChar, p_WinFonts | 2 | 0 |
| `GetStaticInfoCol` | method | p_StaticInfoCol, p_MaxChar | 2 | 0 |
| `PrintStaticInfoLine` | method | p_udtStaticInfo, p_Line, p_MaxChar, p_RE | 4 | 0 |
| `GetPOSEnableDisableSeriesCol` | method | p_EnabledSeriesCol, p_DisabledSeriesCol, p_VchType | 3 | 0 |
| `IfPOSEnableInSeries` | method | p_VchSeriesCode, p_VchType | 2 | 0 |
| `SettlementEnableInSeries` | method | p_VchSeriesCode, p_VchType, p_SettInVch, p_SettInPOS | 4 | 0 |
| `DeleteVchDirect` | method | p_Vchcode | 1 | 0 |
| `DeleteIncompleteSubDetails` | method | p_Vchcode, p_MastCode, p_Srno, p_TableName, p_RecType, p_VchType | 6 | 0 |
| `RefreshDBConnection` | method | p_WkSpace, p_ConnStr, p_ErrMsg | 3 | 0 |
| `GetDBConnection` | method | p_WkSpace, p_strDbName, p_RaiseError, p_ErrMsg | 4 | 0 |
| `CreateErrorLog` | method | p_ErrStr | 1 | 0 |
| `GetCSUsers` | method |  | 0 | 0 |
| `GetVchNoList` | method | p_VchType, p_VchSeries, p_StartDate, p_EndDate | 4 | 0 |
| `GetVouchersfromDateRange` | method | p_VchType, p_VchSeries, p_SDate, p_EDate | 4 | 0 |
| `CheckCSUserPwd` | method | p_ServerInfo, p_ErrNum | 2 | 0 |
| `GetUserCompList` | method | p_UserName, p_HDDFilter, p_ForceCompCode, p_ForceCompCodeCol | 4 | 0 |
| `IsSysAdminUser` | method | p_UserName | 1 | 0 |
| `GetUserCompanyInfo` | method | p_UserName, p_CompStr, p_HDDFilter, p_ForceCompCodeCol | 4 | 0 |
| `IsUserHasAccessOnDB` | method | p_WkSpace, p_Condb, p_DbName | 3 | 0 |
| `IsCSUserExist` | method | p_UserName, p_Condb | 2 | 0 |
| `GetCompanyDatabases` | method | p_CompCode | 1 | 0 |
| `IsCSLoginExists` | method | p_LoginName | 1 | 0 |
| `GetVchAccsName` | method | p_Vchcode, p_VchType | 2 | 0 |
| `GetMasterFldName` | method | p_MasterInfoChs | 1 | 0 |
| `TranExistForSettlementMode` | method | p_VchSeriesCode, p_SettlementMode, p_POSEnabled | 3 | 0 |
| `TranExistForBS` | method | p_VchSeriesCode, p_BSCode | 2 | 0 |
| `GetSignatureDet` | method | p_Signature | 1 | 0 |
| `GetSignatureDetStr` | method | udtSignature | 1 | 0 |
| `GetAMCExpiryDate2Str` | method | p_Date | 1 | 0 |
| `GetAMCExpiryStr2Date` | method | p_DateStr | 1 | 0 |
| `AddOnsByte2Array` | method | p_Byte, p_Arr | 2 | 0 |
| `AddOnArray2Byte` | method | p_Arr | 1 | 0 |
| `GetClientUserDetails` | method |  | 0 | 0 |
| `GetUserCountOnServer` | method | p_Con, p_DbName | 2 | 0 |
| `GetBusyDHSUserDetFromAlias` | method | p_UserAlias, p_Pass, p_WrongUser, p_WrongPass, p_DHSCompanies | 5 | 0 |
| `UpdateDHSUserReqInfo` | method | p_DHSUsers | 1 | 0 |
| `UserProfileUDT` | method |  | 0 | 0 |
| `GetMastCodeWhereClauseStr` | method | p_Mastertype, p_MasterCode, p_TableAlias, p_AndReq, p_MastFldName, p_ChildMasterType | 6 | 0 |
| `GetFldValFromObject` | method | p_rst, p_Node, p_FldName, p_ReadSource, p_FldType | 5 | 0 |
| `GetToolTipText` | method | p_ID | 1 | 0 |
| `AskForMC` | method | p_MasterTypeNo, p_Repopt | 2 | 0 |
| `IfSingleMC` | method |  | 0 | 0 |
| `LoadAdditionalPrintingOptions` | method |  | 0 | 0 |
| `SaveAdditionalPrintingOptions` | method | p_AddPrnOpt | 1 | 0 |
| `GetAdditionalPrintInfoStr` | method | p_udtPrnIfo | 1 | 0 |
| `PrintAdditionalInfo` | method | p_Repopt, p_RE, p_RepOver | 3 | 0 |
| `GetDefaultPrinterCommands` | method | p_PrinterName | 1 | 0 |
| `SaveDefaultPrinterConfig` | method |  | 0 | 0 |
| `SaveDosPrinterDrv` | method | p_udtPrinterCommand | 1 | 0 |
| `ISVchSeriesUsedInSync` | method | p_VchType, p_vchSrCode | 2 | 0 |
| `CheckForBlankDuplicateVchNo` | method | p_udtVchNum, p_VchSeriesCode, p_Vchcode, p_VchNo, p_VchDate, p_InputMode, p_ErrStr, p_PartyCode, p_Trantype, p_VchType | 10 | 0 |
| `CheckForBlankDuplicatePurcBillNo` | method | p_udtVchNum, p_VchSeriesCode, p_Vchcode, p_BillNo, p_BillDate, p_InputMode, p_ErrStr, p_PartyCode | 8 | 0 |
| `GetVchTypeCol` | method |  | 0 | 0 |
| `GetDefaultMCWiseColsAndSize` | method | p_Size, p_MSGrpCode | 2 | 0 |
| `GetLikeQueryStrWithAnd` | method | p_Field, p_Prefix, p_Sufix, p_SearchString | 4 | 0 |
| `GetLikeQueryStrWithOR` | method | p_Field, p_Prefix, p_Sufix, p_SearchString, p_WithOR | 5 | 0 |
| `TemplateName2VchCode` | method | p_TemplateName, p_VchType | 2 | 0 |
| `VchCode2TemplateName` | method | p_Vchcode | 1 | 0 |
| `LoadMasterTemplateTaggingIfExists` | method | p_Code, p_VchType, p_AllowHeader, p_AllowItemDet, p_AllowBSDet | 5 | 0 |
| `CheckTemplateOnMasterTypeInVoucher` | method | p_VchType, p_TagOnAcc, p_TagOnAgrp, p_TagOnSeries, p_TagOnSTPT | 5 | 0 |
| `GetVRCAmt` | method | p_VRC, p_VchType, p_TaxInvoice, p_StartDate, p_EndDate, p_VATNonVATType | 6 | 0 |
| `GetStPtMastNameNotSkipInVat` | method | p_MastType | 1 | 0 |
| `LoadFreezeConfig` | method |  | 0 | 0 |
| `BalancesUpdationFreezedInYear` | method | p_Year, p_Msg | 2 | 0 |
| `DataFreezedTillDate` | method | p_VchType, p_VchSeriesCode, p_Date, p_ErrMsg, p_DeleteVch, p_Code | 6 | 0 |
| `CheckUserMasterControlValidation` | method | p_VchType, p_VchSeriesCode, p_MasterName, p_ActualMasterType, p_FrameType, p_RowNo, p_ErrMsg | 7 | 0 |
| `IfValidMCForLoggedInBranch` | method | p_MCCode, p_strError | 2 | 0 |
| `CheckMasterControlValidation` | method | p_ControlMasters, p_MasterName, p_ActualMasterType, p_FrameType, p_RowNo, p_ErrMsg, p_CheckForUser | 7 | 0 |
| `CheckMasterControlValidationReport` | method | p_MasterCode, p_MasterName, p_Mastertype, p_ErrMsg | 4 | 0 |
| `UpdateItemHSNString` | method |  | 0 | 0 |
| `DeleteVchTemplateTagging` | method | p_Vchcode | 1 | 0 |
| `SaveVchSeriesGrpConfig` | method | p_VchSeriesConfig | 1 | 0 |
| `IfSeriesUnderAnyGroup` | method | p_Code, p_GrpCode | 2 | 0 |
| `GetVoucherSeriesGroupCount` | method |  | 0 | 0 |
| `GetItemType` | method | p_ItemTypeStr | 1 | 0 |
| `GetItemTypeStr` | method | p_ItemType | 1 | 0 |
| `GetTaxCatTypeStr` | method | p_TaxType | 1 | 0 |
| `GetTaxCatType` | method | p_TaxTypeStr | 1 | 0 |
| `GetTaxCatPriceWiseBasis` | method | p_BasisStr | 1 | 0 |
| `GetTaxCatPriceWiseBasisStr` | method | p_BasisVal | 1 | 0 |
| `CheckMasterControlAppliedOnSeries` | method | p_SeriesName, p_VchType | 2 | 0 |
| `CheckUserMasterControlAppliedOnSeries` | method | p_SeriesName, p_VchType, p_UserName | 3 | 0 |
| `DeletePartyItemAnalysisFormat` | method | p_FormatName, p_PRID, p_ConfigType | 3 | 0 |
| `ReadPartyItemAnalysisFormat` | method | p_VchType, p_FormatName, p_ConfigType | 3 | 0 |
| `CopyImportVchFromExcelFormatFromDisk` | method | p_FormatName, p_RepID, p_Lines | 3 | 0 |
| `WritePartyItemAnalysisFormat` | method | p_FormatName, p_RepID, p_Lines, p_ConfigType | 4 | 0 |
| `GetPartyItemVatSumDetMaxChar` | method | p_Repopt, p_cols | 2 | 0 |
| `GetReportsMaxChar` | method | p_Repopt, p_OffSet, p_Totalcols, p_MinColWidth, p_ReqColForSingleTaxRate, p_AddFirstZero | 6 | 0 |
| `SaveCompositePOSStructureTaggingInfo` | method | p_Col | 1 | 0 |
| `LoadCompositePOSStructureTaggingInfo` | method |  | 0 | 0 |
| `CheckPOSLinkedStructure` | method | p_Structure, p_IgrpCode | 2 | 0 |
| `POSStructureExist` | method | p_RecType, p_StructureName | 2 | 0 |
| `CheckStructureExistAsDefault` | method | p_StructureName | 1 | 0 |
| `UpgradeUserControlData` | method | p_ExistingFinYr, p_SwitchingfinYrs | 2 | 0 |
| `GetAllPartwiseSalePurcReportFormats` | method | p_PRID | 1 | 0 |
| `GetAllCostCentreReportFormats` | method | p_PRID | 1 | 0 |
| `PartywiseSalePurcReportFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `CostCentreReportFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `GetLastCurrencyConversionDate` | method |  | 0 | 0 |
| `GetPOSBCStructure` | method | p_IgrpCode | 1 | 0 |
| `GetPOSSettlementDetMaxChar` | method | p_Repopt, p_cols | 2 | 0 |
| `GetVatAccList` | method |  | 0 | 0 |
| `GetGSTINDIAAccList` | method |  | 0 | 0 |
| `IfBillSundryWithNarration` | method | p_VchData | 1 | 0 |
| `GetVATAccOpBalQryForVchSeriesGrp` | method | p_VchSerGrpCode | 1 | 0 |
| `ToShowSurCharge` | method | p_VchType, p_STPTType | 2 | 0 |
| `ToshowSurchargeInCombined` | method | p_VchType, p_Local, p_Central | 3 | 0 |
| `GetCalculatedBrokerageAmt` | method | p_BrokerageMode, p_Brokerage, p_SalePurAmt, p_MainQty, p_AltQty, p_PkgQty | 6 | 0 |
| `GetAllSeriesDataInCol` | method |  | 0 | 0 |
| `GetSeriesNameFromCol` | method | p_SeriesCode, p_VchType, p_SeriesCol | 3 | 0 |
| `GetSeriesCodeColFromDBColForVchtype` | method | p_VchType, p_SeriesDBCol | 2 | 0 |
| `GetSalesTaxTypeNo2Str` | method | p_Type | 1 | 0 |
| `GetSalesTaxTypeStr2No` | method | p_TypeStr | 1 | 0 |
| `GetDefaultVATRatesForOtherCountry` | method | p_CountryCode, p_Rate1, p_Rate2 | 3 | 0 |
| `GetAllUserStr` | method |  | 0 | 0 |
| `GetImportVchFromExcelFormatNamesList` | method | p_RepID | 1 | 0 |
| `ImportVchFromExcelFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `GetAllImportVchFromExcelFormats` | method | p_PRID | 1 | 0 |
| `DeleteImportVchFromExcelFormat` | method | p_FormatName, p_PRID | 2 | 0 |
| `BrokerSMNameString` | method | p_Prulal | 1 | 0 |
| `BrokerageCommissionString` | method | p_Mode | 1 | 0 |
| `CheckLimitationForAutomaticVchNo` | method | p_udtVchData, p_udtVchNum, p_StrMsg, p_Warning, p_Date | 5 | 0 |
| `CheckLimitationForAutomaticCallNo` | method | p_udtVchData, p_udtVchNum, p_StrMsg, p_Warning, p_Date | 5 | 0 |
| `MessageForAutomaticVchNo` | method | p_udtVchNum, p_Warning, p_Date | 3 | 0 |
| `GetPDCEntryTypeStr2No` | method | p_EntryTypeStr | 1 | 0 |
| `GetPDCEntryTypeNo2Str` | method | p_EntryTypeNo | 1 | 0 |
| `SaveMRPOpDetails` | method | p_MRPOpStockDet, p_ItemCode, p_InputMode | 3 | 0 |
| `DeleteMRPOpDetails` | method | p_ItemCode, p_MCCode, p_Srno | 3 | 0 |
| `LoadMRPOpDetails` | method | p_ItemCode, p_MCOPStockArr, p_MRPStockOpDet | 3 | 0 |
| `GetBrokerageConfigForBrokerMast` | method | p_MastCode | 1 | 0 |
| `PDCType2Str` | method | p_Type | 1 | 0 |
| `PDCStr2Type` | method | p_str | 1 | 0 |
| `GetConvertedStringForGlobalQuery` | method | p_String | 1 | 0 |
| `CheckStringForSpecialChar` | method | p_String, p_Char | 2 | 0 |
| `SaveImportVchFromExcelFormatName` | method | p_FormatName, p_PRID | 2 | 0 |
| `SaveImportVchFromExcelKeyField` | method | p_FormatName, p_PRID, p_UdtGen | 3 | 0 |
| `SaveImportVchFromExcelFormatConfig` | method | p_FormatName, p_PRID, p_Col | 3 | 0 |
| `LoadImportVchFromExcelKeyField` | method | p_FormatName, p_RepID | 2 | 0 |
| `FilterColForStkPrinting` | method | p_Col | 1 | 0 |
| `IfStkPrintingEnableInItem` | method | p_Code | 1 | 0 |
| `GetCompDateType` | method | p_CompCode | 1 | 0 |
| `GetMCCodePriceForNewRefs` | method | p_RefCode, p_PriceMain, p_PriceAlt | 3 | 0 |
| `GetCommCodeDesc` | method | p_ItemCommCode, p_ItemSENo, p_BranchCode | 3 | 0 |
| `GetQtyAndFreeQtyFromStr` | method | p_strQty, p_Qty, p_FreeQty, p_PlusIsIncluded, p_IsReturnQty | 5 | 0 |
| `CombineQtyAndFreeQty` | method | p_QtyStr, p_Qty, p_FreeQty, p_OperatorIncluded, p_IsReturnQty | 5 | 0 |
| `GetBilledQty` | method | p_TotalQty, p_FreeQty | 2 | 0 |
| `CheckToUseFreeQtyOrNot` | method | p_VchType | 1 | 0 |
| `SaveContactDetConfig` | method | p_ContactDet, p_RepID | 2 | 0 |
| `LoadContactDetConfig` | method | p_RepID | 1 | 0 |
| `GetGUID` | method |  | 0 | 0 |
| `IfPDCVoucherExistTillDate` | method | p_Date | 1 | 0 |
| `UpdateCompSerialNumber` | method | p_ProductSerialNo, p_strError | 2 | 0 |
| `GetContactDetConfigOptionStrCol` | method | p_RepID | 1 | 0 |
| `SetValuesColForContactDetConfig` | method | p_RepID, p_ContactData | 2 | 0 |
| `GetValuesColFromContactDetConfig` | method | p_RepID, p_ConfigValueCol | 2 | 0 |
| `PrintLargeStrInMultipleLines` | method | p_String, p_RE, p_PaperType, p_PrnStyle | 4 | 0 |
| `PrintBillsRecPayTitleStr` | method | p_Repopt, p_RE, p_PaperType | 3 | 0 |
| `GetAllNMCategoryCol` | method | p_ParentCategoryCode, ToIncludeMsgCat | 2 | 0 |
| `GetNotesColForCategory` | method | p_NotesStatus, p_CategoryCode, p_NotesCode | 3 | 0 |
| `GetLastCategoryCode` | method |  | 0 | 0 |
| `GetLastNotesID` | method | p_UserName | 1 | 0 |
| `SaveNMCategoryName` | method | p_InputMode, p_CategoryUdt, p_OldCategoryName | 3 | 0 |
| `SaveNotesToDB` | method | p_UdtNMNotes, p_InputMode | 2 | 0 |
| `DeleteNotesFromDB` | method | p_NotesCode | 1 | 0 |
| `DeleteNMCategoryFromDB` | method | p_CategoryCode | 1 | 0 |
| `ReminderOccurenceNum2Text` | method | p_ReminderOccurence | 1 | 0 |
| `ReminderOccurenceText2Num` | method | p_ReminderOssurence | 1 | 0 |
| `GetStatusText2Num` | method | p_StatusText | 1 | 0 |
| `GetStatusNum2Text` | method | p_status | 1 | 0 |
| `SaveLastNMCodes` | method | p_CategoryCode, p_NotesCode | 2 | 0 |
| `ChangeCategoryAfterDragDrop` | method | p_NotesCode, p_CategoryCode | 2 | 0 |
| `IfNoteCrossingDeadLine` | method |  | 0 | 0 |
| `GetAllItemSrAutoNumFormats` | method |  | 0 | 0 |
| `SaveItemSrAutoNumConfig` | method | p_ItemSrNumConfig | 1 | 0 |
| `LoadItemSrAutoNumConfig` | method | p_StructName | 1 | 0 |
| `IsItemSrAutoNumStructureExists` | method | p_StructName | 1 | 0 |
| `UpdateItemSrAutoNumStructure` | method | p_OldName, p_NewName | 2 | 0 |
| `DeleteItemSrAutoNumStructure` | method | p_StructName | 1 | 0 |
| `SaveItemSrNoDetails` | method | p_ItemCode, p_Vchcode, p_VchItemSN, p_ItemSrNoCol, p_InputMode, p_OldCol | 6 | 0 |
| `DeleteItemSrNoDetails` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchItemSN, p_GridSN | 5 | 0 |
| `ItemSerialNumberUdt2Rst` | method | p_rst, p_Node, p_ReadSource | 3 | 0 |
| `GetLastItemSerialNumberDet` | method | p_ItemCode, p_ForQtyIn | 2 | 0 |
| `IsSerialNoExistInTranForItem` | method | p_ItemCode, p_AutoSrNoReq | 2 | 0 |
| `IsStructureExistInItemMaster` | method | p_Structure | 1 | 0 |
| `ValidateSerialNo` | method | p_Col, p_strError | 2 | 0 |
| `CheckItemSerialNumberExistInCol` | method | p_Col1, p_Col2, p_strError | 3 | 0 |
| `IsItemSerialNumberExists` | method | p_ItemCode, p_MCCode, p_Col, p_Vchcode, p_Checked, p_SerialNo, p_QtyIn, p_WarnOnly | 8 | 0 |
| `GetLastItemAutoSerialNumber` | method | p_ItemCode, p_VchDate, p_AutoNum, p_ItemSrNoFreq | 4 | 0 |
| `RenumberAllItemSerialNumbers` | method | p_Structure, p_ItemCode | 2 | 0 |
| `RenumberAutomatic2Manual` | method | p_ItemCode | 1 | 0 |
| `RenumberManual2Automatic` | method | p_ItemCode, p_AutoNo, p_StructName, p_SrNoFrequency, p_UpdateAutoSrNo, p_UpdateFP | 6 | 0 |
| `RegenerateMastersFootprint` | method | p_Code, p_Mastertype, p_UpdateStamp | 3 | 0 |
| `UpdateItemSerialNumberDet` | method | p_itemCol, p_VchDate, p_VchNo, p_MCName, p_Absolute | 5 | 0 |
| `LoadSTAdvanceConfig` | method | p_AdvConfig, p_StateCode | 2 | 0 |
| `LoadStdDocPageSettings` | method | p_RID, p_Std | 2 | 0 |
| `LoadStdDocConfig` | method | p_RID, p_SkipPageSettingRecord | 2 | 0 |
| `SaveStdDocConfig` | method | p_PRID, p_FormatName, p_udtStdDoc | 3 | 0 |
| `SaveSTAdvanceConfig` | method | p_udtAdvConfig | 1 | 0 |
| `SaveStdDocPageSetting` | method | p_PRID, p_FormatName, p_udtStdDoc | 3 | 0 |
| `GetDefaultRDCFormatUdt` | method | p_RepID | 1 | 0 |
| `GetDefaultPaySlipFormatUdt` | method | p_RepID | 1 | 0 |
| `GetDefaultFullnFinalSlipFormatUdt` | method | p_RepID | 1 | 0 |
| `CreateStandardRDCFormat` | method | p_RepID | 1 | 0 |
| `CreateStandardPaySlipFormat` | method | p_RepID | 1 | 0 |
| `CheckIfStdPRFormatExist` | method | p_PRID | 1 | 0 |
| `CheckIfAnyStdFormatExist` | method |  | 0 | 0 |
| `GetSalesAutomaticInvNo` | method | p_StartingNo, p_ForRetail, p_StartDate, p_EndDate | 4 | 0 |
| `GetSalesAutomaticInvNoForSeriesGrp` | method | p_SeriesGrpCode, p_StartingNo, p_ForRetail, p_StartDate, p_EndDate | 5 | 0 |
| `GetSalesAutomaticInvNoForSeries` | method | p_SeriesCode, p_StartingNo, p_ForRetail, p_StartDate, p_EndDate | 5 | 0 |
| `GetSalesAutomaticInvNoStrForALLSeries` | method | p_StartingNo, p_ForRetail, p_StartDate, p_EndDate | 4 | 0 |
| `GetVchConfigForConfigItemBody` | method | p_RID, P_ItemWiseAF, p_ItemwiseDisc, p_ItemwiseMarkup | 4 | 0 |
| `AllowItemReturnInVch` | method | p_VchType | 1 | 0 |
| `ReInitItemSerialNoCol` | method | p_itemCol | 1 | 0 |
| `ReInitItemParamCol` | method | p_itemCol | 1 | 0 |
| `GetAccPDCAmount` | method | p_StartDate, p_EndDate, p_MasterCode, p_CurType, p_VSGrpCode | 5 | 0 |
| `LoadItemSNPrintDetConfig` | method | p_rst, p_RecType | 2 | 0 |
| `SaveSQLQueryName` | method | p_NewName, p_OldName, p_InputMode, p_Password | 4 | 0 |
| `SQLQueryNameExist` | method | p_Name | 1 | 0 |
| `GetSQLQueryData` | method | p_Name | 1 | 0 |
| `RestrictionApplicableForReporting` | method |  | 0 | 0 |
| `RestrictionApplicableOnAccountForReporting` | method |  | 0 | 0 |
| `RestrictionApplicableOnGroupForReporting` | method |  | 0 | 0 |
| `GetConcatenatedBillRefNoDet` | method | p_AccsArr, p_BillsArr, p_SNPrnDet | 3 | 0 |
| `GetConcatenatedRefNoDet` | method | p_ItemsArr, p_RefArr, p_SNPrnDet, p_ConfigType | 4 | 0 |
| `GetConcatenatedJobEntriesDet` | method | p_RefArr, p_SNPrnDet | 2 | 0 |
| `IfItemQuantityFullyAdjustedWithRef` | method | p_ItemsArr, p_RefsArr, p_RecType, p_StrErr | 4 | 0 |
| `GetVchTypeFromTranType` | method | p_Trantype | 1 | 0 |
| `GetVchImageFolderPath` | method | p_VchSeriesCode | 1 | 0 |
| `SaveSMSAPI` | method | p_udtSMSConfig, p_InputMode | 2 | 0 |
| `CheckAndGetIfAPIExist` | method | p_APIName | 1 | 0 |
| `LoadSMSAPI` | method | p_APIName | 1 | 0 |
| `CheckIfSMSAPIWithFileExist` | method |  | 0 | 0 |
| `CheckIfOnlySMSAPIWithFileExist` | method |  | 0 | 0 |
| `DeleteAPIConfigName` | method | p_Name | 1 | 0 |
| `GetAllAPIConfigNames` | method |  | 0 | 0 |
| `LoadDailyMessage` | method | p_VchType, p_Date, p_SereisCode, p_Stick2Date | 4 | 0 |
| `CheckIfAnyParamCombinationExists` | method |  | 0 | 0 |
| `CheckIfParamDetExistsForAnItem` | method | p_Code, BCN, p_ExceptOpening | 3 | 0 |
| `CheckIfAnyBCNExists` | method |  | 0 | 0 |
| `DeleteParamStockDetails` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchItemSN, p_Srno, p_RecType, p_DeleteAdjustments | 7 | 0 |
| `IfVchPrimarySourceOfBCN` | method | p_BCN, p_Vchcode, p_MRP | 3 | 0 |
| `IfBCNAdjustmentsExist` | method | p_BCN, p_MRP | 2 | 0 |
| `CanDeleteBCN` | method | p_BCN, p_Vchcode, p_MRP | 3 | 0 |
| `DeleteItemBatchesDet` | method | p_ItemCode, p_MCCode, p_Vchcode, p_ItemSrNo, p_Srno | 5 | 0 |
| `SaveParamStockDetails` | method | p_ItemCode, p_Vchcode, p_VchItemSN, p_ParamStockCol, p_InputMode, p_OldCol, p_RecType | 7 | 0 |
| `SaveParamStockDetailsForJobWork` | method | p_ItemCode, p_Vchcode, p_VchItemSN, p_ParamStockCol, p_InputMode, p_OldCol, p_RecType, p_MainItemSrnoForJobWorkParam | 8 | 0 |
| `SaveItemBatchDetails` | method | p_ItemCode, p_Vchcode, p_VchItemSN, p_ItemBatchCol, p_InputMode, p_OldCol | 6 | 0 |
| `GetBatchAvgPrice` | method | p_RefNo, p_ItemCode, p_MCCode, p_QtyInExist | 4 | 0 |
| `UpdateQtyOutBatchNewRefAmount` | method | p_RefNo, p_ItemCode, p_MCCode | 3 | 0 |
| `ItemParamStockUdt2Rst` | method | p_rst, p_Node, p_ReadSource | 3 | 0 |
| `UpdateItemBatchesDet` | method | p_itemCol, p_VchDate, p_VchNo, p_MCName | 4 | 0 |
| `UpdateMultiParamStockDet` | method | p_itemCol, p_VchDate, p_VchNo, p_MCName, p_Absolute | 5 | 0 |
| `GetParamClosingStock` | method | p_ItemCode, p_MCCode, p_VchDate, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_MRP, p_SalesPrice, p_Vchcode, p_Checked, p_AltQty, p_ConFactor, p_StockParamCount | 15 | 0 |
| `IsParamLenExceeds` | method | p_StockParamCol, p_ErrMsg | 2 | 0 |
| `SaveStockParamConfig` | method | p_StockParamCol, p_GrpCode, p_ErrMsg | 3 | 0 |
| `GetTextFromStockParamCol` | method | p_ParamCol | 1 | 0 |
| `GetStockParamColFromText` | method | p_Text | 1 | 0 |
| `GetTextFromStockParamColUsedInXML` | method | p_ParamCol | 1 | 0 |
| `GetStockParamColFromXML` | method | p_Text | 1 | 0 |
| `LoadStockParamConfig` | method | p_NoOfStockParam, p_GrpCode | 2 | 0 |
| `GetStockParamConfigXMLStr` | method | p_Doc, p_Node, p_StockParamCol | 3 | 0 |
| `SetStockParamConfigXML` | method | p_Node | 1 | 0 |
| `GetAccCodeFromMultiTaxConfig` | method | p_StPtData, p_ItemData | 2 | 0 |
| `GetTaxAccCodeFromMultiTaxConfig` | method | p_StPtData, p_ItemData, p_SchgAccCode, p_TaxAccCode1, p_AddSchgAccCode, p_StateCessAccCode | 6 | 0 |
| `GetPendingBatchesDetFromChallanRefs` | method | p_ItemEntries, p_ChallanRefs | 2 | 0 |
| `GetPendingBatchesDetFromPrevYrChallanRefs` | method | p_ItemData, p_RefNoStr, p_NewRefSrNo | 3 | 0 |
| `IfTempFileExist` | method |  | 0 | 0 |
| `TempFileDeleted` | method |  | 0 | 0 |
| `GetMovedItemsCol` | method | p_RepID, p_Repopt, p_MastSeriesGrpCode, p_MOFCode, p_MOFNo | 5 | 0 |
| `IsMastSeriesApplicableOnGrp` | method | p_MasterCode, p_MastSeriesGrpCode, p_MastType | 3 | 0 |
| `GetItemQtyInVch` | method | p_ItemCode, p_ItemEntries, p_ReturnAbsoluteQty | 3 | 0 |
| `GetRefNoContinuous` | method | p_Refs, p_VchType, p_Trantype, p_RefType, p_ShowVchNoOnly | 5 | 0 |
| `GetSettlementConfigDet` | method | p_VchConfig, p_PosConfig | 2 | 0 |
| `FormatMobileNo` | method | p_MobNo, p_udtSMSAPI | 2 | 0 |
| `ValidRegKeyNew` | method | p_Srno, p_RegKey | 2 | 0 |
| `ValidSrNo` | method | p_Srno | 1 | 0 |
| `SaveItemSNInstallDet` | method | p_udtInstall | 1 | 0 |
| `LoadItemSNInstallDet` | method | p_ItemCode, p_SerialNo, p_InstallCode, p_LoadByCode | 4 | 0 |
| `ItemSNInstallationVchDetIfExist` | method | p_SerialNo, p_ItemCode, p_Scroll | 3 | 0 |
| `DeleteItemSNInstallDet` | method | p_InstallCode | 1 | 0 |
| `IsSerialNoAdjustmentExist` | method | p_ItemCode, p_SerialNo | 2 | 0 |
| `GetItemSNInstallationDet` | method | p_InstallCode, p_SerialNo | 2 | 0 |
| `SaveMasterFootPrint` | method | p_MasterCode, p_Mastertype, p_Name, p_Stamp, p_PartialFP, p_RemainFP | 6 | 0 |
| `LoadMasterFootPrint` | method | p_Code, p_Mastertype, p_Name, p_ByName, p_Stamp, p_LoadPartial, p_RemainFP | 7 | 0 |
| `DeleteMastFootPrint` | method | p_Code | 1 | 0 |
| `SaveRepColSize` | method | p_RID, p_SubID, p_FormatName, p_Col, p_CustomRepFormatName, p_WideScreen | 6 | 0 |
| `LoadRepColSize` | method | p_RID, p_SubID, p_FormatName, p_CustomRepFormatName, p_WideScreen | 5 | 0 |
| `FinYrExist` | method | p_Year | 1 | 0 |
| `SetData2ScrRep2009` | method | p_Obj | 1 | 0 |
| `GetParamterizedStockStatusFormats` | method | p_PRID | 1 | 0 |
| `DeleteParamStockStatusFormat` | method | p_FormatName, p_PRID | 2 | 0 |
| `DeleteCostCentreFormat` | method | p_FormatName, p_PRID | 2 | 0 |
| `ModifyParamStockStatusFormatName` | method | p_OldFormatName, p_NewFormatName, p_PRID | 3 | 0 |
| `ModifyCostCentreFormatName` | method | p_OldFormatName, p_NewFormatName, p_PRID | 3 | 0 |
| `SaveParamStockStatusColumnFormatConfig` | method | p_FormatName, p_PRID, p_ParamNo, p_Col | 4 | 0 |
| `SaveCostCentreColumnFormatConfig` | method | p_FormatName, p_PRID, p_Col | 3 | 0 |
| `LoadParamStockStatusColumnFormatConfig` | method | p_FormatName, p_RepID | 2 | 0 |
| `LoadCostCentreColumnFormatConfig` | method | p_FormatName, p_RepID | 2 | 0 |
| `GetDemoCaption` | method | p_DemoType | 1 | 0 |
| `GetReturnVchType` | method | p_VchType | 1 | 0 |
| `GetUniqueParamValues` | method | p_Repopt | 1 | 0 |
| `GetAddnInfoLength` | method | p_MastConfig, p_AddnInfoNum, p_StartPt | 3 | 0 |
| `GetItemDataTaxType` | method | p_ItemData, p_SkipDefault | 2 | 0 |
| `CheckItemSTDef` | method | p_ItemData, p_STPTMast, p_UsedForFinalValidation, p_ErrMsg, p_Disallow, p_SkipDefault, p_SchgAppl4Pakistan, p_StateCessToBeApplied | 8 | 0 |
| `CopyParameterStockStatusColumnFormat` | method | p_FormatName, p_RepID, p_Lines | 3 | 0 |
| `CopyCostCentreColumnFormat` | method | p_FormatName, p_RepID, p_Lines | 3 | 0 |
| `ReadParameterStockStatusColumnFormat` | method | p_RID, p_FormatName | 2 | 0 |
| `ReadCostCentreColumnFormat` | method | p_RID, p_FormatName | 2 | 0 |
| `RemoveSpecialCharFromString` | method | p_str, p_RemChar | 2 | 0 |
| `GetRoundedOffBSAmt` | method | p_Amt, p_RoundOffType, p_RoundOffNearestTo | 3 | 0 |
| `GetDefaultCaptionStrForStdDoc` | method | p_InvCompInfo | 1 | 0 |
| `GetPurchaseBillDateForeReturn` | method | p_PurchaseBillDate, p_VchDate | 2 | 0 |
| `LoadAuthorisationData` | method | p_Type | 1 | 0 |
| `SaveAuthorisationData` | method | p_Col, p_Type | 2 | 0 |
| `LoadMultiplecompDet` | method | p_State | 1 | 0 |
| `SaveMultipleCompDet` | method | p_udtData | 1 | 0 |
| `IfAuthorisationReqdForMaster` | method | p_udtData, p_MastType, p_IsUserAuthorised, p_Restrictions, p_udtMast, p_UserName | 6 | 0 |
| `IfAuthorisationReqdForVoucher` | method | p_udtData, p_VchType, p_VchSeriesCode, p_IsUserAuthorised, p_Restrictions, p_VchData, p_UserName | 7 | 0 |
| `IfConditionSatisfyForMasterSelectiveApproval` | method | p_SAData, p_MastType, p_udtMast | 3 | 0 |
| `IfConditionsSatisfyForSelectiveApproval` | method | p_SAData, p_VchData | 2 | 0 |
| `IfAuthorisationReqd` | method | p_Type, p_Mastertype, p_IsUserAuthorised, p_Restriction, p_VchData, p_udtMast, p_VchSeriesCode, p_UserName | 8 | 0 |
| `CheckAuthorisationForMaster` | method | p_InputMode, p_Mastertype, p_AuthReqd, p_CanUserAuthorise, p_ErrMsg, p_udtMast | 6 | 0 |
| `CanDeleteMasterForAuthorisation` | method | p_MastType, p_AuthorisedBy, p_ErrMsg, p_udtMast | 4 | 0 |
| `CanModifyMasterForAuthorisation` | method | p_MastType, p_InputMode, p_AuthReqd, p_CanUserAuthorise, p_AuthorisedBy, p_ErrMsg, p_udtMast, p_ModifyAppDetails | 8 | 0 |
| `CanModifyVchForAuthorisation` | method | p_VchType, p_VchSeriesCode, p_InputMode, p_AuthReqd, p_CanUserAuthorise, p_AuthorisedBy, p_ErrMsg, p_VchData, p_ModifyAppDetails | 9 | 0 |
| `CanDeleteVchForAuthorisation` | method | p_VchType, p_VchSeriesCode, p_AuthReqd, p_CanUserAuthorise, p_AuthorisedBy, p_ErrMsg, p_VchData | 7 | 0 |
| `CheckAuthorisationForVch` | method | p_InputMode, p_VchType, p_VchSeriesCode, p_AuthReqd, p_CanUserAuthorise, p_ErrMsg, p_VchData | 7 | 0 |
| `GetRestrictionForVoucher` | method | p_RestrictionType, p_VchType, p_VchSeriesCode, p_AuthReqd | 4 | 0 |
| `GetRestrictionForMaster` | method | p_RestrictionType, p_Mastertype | 2 | 0 |
| `GetMasterTypeColForAuthorisedUser` | method | p_UserName | 1 | 0 |
| `GetVchSeriesCodeColForAuthorisedUser` | method | p_UserName, p_VchType, p_VchWise | 3 | 0 |
| `DeleteItemAliasIfAlreadyExist` | method | p_Alias | 1 | 0 |
| `UpdateServerInfoForBDNS` | method | p_ServerInfo | 1 | 0 |
| `MultipleItemAliasExist` | method |  | 0 | 0 |
| `DeleteAllMasterMultipleItemAlias` | method |  | 0 | 0 |
| `MasterMultipleAlias2CodeIfExist` | method | p_ItemAlias, p_Mastertype, p_ActualMasterName | 3 | 0 |
| `GetAllItemCodesforMultipleAliases` | method |  | 0 | 0 |
| `MultipleAccAliasExist` | method |  | 0 | 0 |
| `DeleteAllMasterMultipleAccAlias` | method |  | 0 | 0 |
| `GetAllAccCodesforMultipleAliases` | method |  | 0 | 0 |
| `DeleteMastFootPrintForMastType` | method | p_MastType | 1 | 0 |
| `DeleteAllItemMastDescWithFootPrint` | method |  | 0 | 0 |
| `MonthlyQuarterlyStrToNum` | method | p_Name | 1 | 0 |
| `MonthlyQuarterlyNumToStr` | method | p_MonthQuarter | 1 | 0 |
| `GetVchTotalQty` | method | p_Vchcode, AltQty | 2 | 0 |
| `UpdateCreatedByName` | method | p_UserName | 1 | 0 |
| `UpdateVoucherApprovalDetails` | method | p_VchcodeCol, p_VchTypeCol, p_Proceed, ApprovalStatus, p_ApprovalReason | 5 | 0 |
| `DeleteVoucherApprovalDetails` | method | p_VchcodeCol | 1 | 0 |
| `UpdateMasterApprovalDetails` | method | p_MasterCodeCol, p_MasterTypeCol, p_ApprovalReason, p_ApprovalDetails | 4 | 1 |
| `DeleteMasterApprovalDetails` | method | p_MasterCodeCol | 1 | 0 |
| `MasterLeftForApproval` | method | p_Mastertype | 1 | 0 |
| `VchLeftForApproval` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `CanUserChangeFYForApproval` | method |  | 0 | 0 |
| `SaveTVMenuShortCutKey` | method | p_KeyCode, p_Shift, p_Ctrl, p_Alt, p_NodeKey, p_ReplaceKey, p_NodeName, p_SKCaption | 8 | 0 |
| `LoadTVMenuShortCutKey` | method |  | 0 | 0 |
| `NodeExistInFavourite` | method | p_NodeKey | 1 | 0 |
| `AddToFavourite` | method | p_NodeKey, p_NodeCaption | 2 | 0 |
| `UpdateFavouriteCaption` | method | p_NodeKey, p_NodeCaption | 2 | 0 |
| `GetFavouriteMenuCol` | method |  | 0 | 0 |
| `DeleteShortcutKey` | method | p_udtTV | 1 | 0 |
| `DeleteItemFromFavourite` | method | p_key | 1 | 0 |
| `GetSignatureFromServer` | method | p_SvrDate | 1 | 0 |
| `GetConnectionsConsumed` | method | p_ComputerName | 1 | 0 |
| `GetOthersMasterString` | method |  | 0 | 0 |
| `ConnectClient2CompInfoDB` | method |  | 0 | 0 |
| `DisConnectClientFromCompInfoDB` | method |  | 0 | 0 |
| `SaveOfflineMessage` | method | p_MessageStr, p_Type, p_WorkinBG, p_SMSMode, p_UseForLoginNotification | 5 | 0 |
| `ModifyOfflineMessageForNotification` | method | p_MessageStr, p_Type, p_WorkinBG, p_Code, p_SMSMode, p_UseForLoginNotification | 6 | 0 |
| `GetOfflineMessageCount` | method | p_MessageType, p_OnlyBG, p_OnlyCurrentUser, p_SMSMode, p_CheckUser, p_UserName | 6 | 0 |
| `IfOfflineMessageExist` | method | p_Code | 1 | 0 |
| `LoadOfflineMessage` | method | p_MessageType, p_OnlyBG, p_OnlyCurrentUser, p_SMSMode, p_CheckUser, p_UserName | 6 | 0 |
| `DeleteOfflineMessage` | method | p_Code | 1 | 0 |
| `PendingDocChoiceStrToNum` | method | p_Name | 1 | 0 |
| `PendingDocChoiceNumToStr` | method | p_PenBills | 1 | 0 |
| `SaveMenuPreferences` | method | p_Value | 1 | 0 |
| `GetNoOfParamForItemGrp` | method | p_GrpCode | 1 | 0 |
| `LoadOfflineEMailMsg` | method | p_OfflineStr | 1 | 0 |
| `LoadOfflineSMS` | method | p_MessageStr | 1 | 0 |
| `LoadNotificationExtraDets` | method | p_str | 1 | 0 |
| `LoadOfflineNotification` | method | p_UdtGen | 1 | 0 |
| `ValidWinDrvName` | method | p_WinDrvName, p_ErrMsg | 2 | 0 |
| `ValidDOSDrvName` | method | p_DOSDrvName, p_ErrMsg | 2 | 0 |
| `NodeExistsInXML` | method | Node, p_NodeName, p_RetNodeValue | 3 | 0 |
| `GenQryInStrFromColForSync` | method | p_Col, p_DataType | 2 | 0 |
| `DeleteCentralServerConfig` | method |  | 0 | 0 |
| `SaveCentralServerConfig` | method | p_udtSvrConf | 1 | 0 |
| `LoadCentralServerConfig` | method |  | 0 | 0 |
| `GetDongleSrNo` | method |  | 0 | 0 |
| `DeleteOfflineInBG` | method | p_str | 1 | 0 |
| `IsTime` | method | p_DateTime | 1 | 0 |
| `Num2RelativeFig` | method | p_Num | 1 | 0 |
| `Name2MasterRange` | method | p_strName | 1 | 0 |
| `MasterRange2Name` | method | p_MRange | 1 | 0 |
| `DataType2Name` | method | p_DT | 1 | 0 |
| `Name2DataType` | method | p_DTName | 1 | 0 |
| `IfOfflineMsgExist` | method |  | 0 | 0 |
| `PendingOfflineMsg` | method | p_WorkinBG | 1 | 0 |
| `GetCustomRepFldVal` | method | p_Col, p_FldID | 2 | 0 |
| `IfCustomRepFormatExist` | method | p_RecType, p_FormatName | 2 | 0 |
| `GetAllVchSeriesStr` | method |  | 0 | 0 |
| `InitUDTCombinedVATDet` | method | p_CombinedVATDet | 1 | 0 |
| `CreateLockObject` | method |  | 0 | 0 |
| `GetLocks` | method | p_Locks | 1 | 0 |
| `ReleaseLock` | method | p_Lock | 1 | 0 |
| `GetServerDate` | method |  | 0 | 0 |
| `ToMaintainUserLog` | method |  | 0 | 0 |
| `SaveLog` | method | p_Type, p_udtLog, p_udteventlog | 3 | 0 |
| `SaveUserLOG` | method | p_udtLog | 1 | 0 |
| `SaveEventLOG` | method | p_udtLog | 1 | 0 |
| `CanModifyUserlogVoucher` | method | p_Vchcode, p_VchType, p_VchNo, p_VchSeriesCode | 4 | 0 |
| `SaveConfigUserLog` | method | p_MenuConst, p_AddInfo, p_TypeConst, p_EventLogConst, p_AddEventInfo | 5 | 0 |
| `SaveLogInLogOutUserLog` | method | p_LogIN | 1 | 0 |
| `SaveUtilitesUserLog` | method | p_MenuConst, p_AddInfo, p_OtherInfo, p_TypeConst, p_AddEventInfo, p_used4BulkUpdation | 6 | 0 |
| `SaveAdminTaskUserLog` | method | p_MenuConst, p_AddInfo, p_OtherInfo, p_TypeConst, p_AddEventInfo | 5 | 0 |
| `SaveDataImportExportUserLog` | method | p_MenuConst, p_AddInfo, p_TypeConst, p_AddEventInfo | 4 | 0 |
| `SaveReportUserLOG` | method | p_LogFor, p_Repopt | 2 | 0 |
| `UpdateCustomReportLablesInfo` | method | p_Repopt | 1 | 0 |
| `DontCreateLog` | method | p_Val | 1 | 0 |
| `GetStatusDontCreateLog` | method |  | 0 | 0 |
| `DeleteUserLogTillDate` | method | p_Date, p_UserName | 2 | 0 |
| `GetMasterSeriesGroupStrFormCol` | method | p_Col | 1 | 0 |
| `GetMasterSeriesGroupColFromStr` | method | p_str | 1 | 0 |
| `GetFirstMasterCode` | method | p_MastType, p_GrpCode | 2 | 0 |
| `IfMasterSeriesTaggingEnableInMasterType` | method | p_Mastertype | 1 | 0 |
| `GetMasterTypeFromRecType` | method | p_RecType | 1 | 0 |
| `GetPercentOperatedOn` | method | p_BSNo, p_BSEntries, p_ItemEntries, p_STPTMast, p_VchType, p_AltCur, p_StateCessApplied | 7 | 0 |
| `GetPercentOperatedOn4GSTINDIA` | method | p_BSNo, p_BSEntries, p_ItemEntries, p_STPTMast, p_VchType, p_AltCur, p_StateCessApplied | 7 | 0 |
| `GetItemDescAmt` | method | p_ItemEntries, p_BSData | 2 | 0 |
| `ConvertFormulaInToValue` | method | p_Exprstr, p_DecimalPlaces, p_ChexkExpr, p_InvalidMsg, p_DescStr | 5 | 0 |
| `GetNettAmt` | method | p_BSNo, p_BSEntries, p_TotalItemAmt, p_AltCur | 4 | 0 |
| `InitUdtPOSSetllementDetailsData` | method | p_udt | 1 | 0 |
| `InitUdtAccData` | method | p_udt | 1 | 0 |
| `InitUdtItemData` | method | p_udt | 1 | 0 |
| `InitUdtBSData` | method | p_udt | 1 | 0 |
| `EnableNotesManagerForUser` | method | p_User | 1 | 0 |
| `GetLastParamAutoBCN` | method |  | 0 | 0 |
| `IfBCNExists` | method | p_BCNStr, p_Vchcode, p_ItemCode, p_BCNItemCode, p_AutoBCN | 5 | 0 |
| `IfBCNExistsInQtyOut` | method | p_BCNStr, p_Vchcode, p_ItemCode, p_BCNItemCode, p_AutoBCN | 5 | 0 |
| `GetBCNClosingStock` | method | p_BCN, p_MCCode, p_VchDate, p_MRP, p_SalesPrice, p_Vchcode, p_Checked, p_AltQty | 8 | 0 |
| `GetParamNewRefPrice` | method | p_ItemCode, p_MCCode, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_MRP, p_SP, p_MainUnitPrice, p_AltUnitPrice | 11 | 0 |
| `GetLastPurcDateOfBCN` | method | p_BCNStr, p_ItemCode, p_VchDate, p_SalePrice, p_MRP | 5 | 0 |
| `GetLastPurcDateOfParam` | method | p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_ItemCode, p_NoOfParam, p_VchDate, p_MRP, p_SalePrice | 10 | 0 |
| `GetLastUtilityDateOfBCN` | method | p_BCNStr, p_ItemCode, p_VchDate | 3 | 0 |
| `GetParamDetailsFromBCN` | method | p_BCNStr, p_ItemCode, p_MCCode, p_ParamData, p_MRP, p_VchDateForLatestSP | 6 | 0 |
| `CheckBCNStockOnMC` | method | p_BCN, p_ItemCode, p_VchDate | 3 | 0 |
| `GetBCNLastQtyOutDet` | method | p_BCN, p_ItemCode, p_VchDate, p_ParamData, p_MRP | 5 | 0 |
| `CompareBCNDetails` | method | p_Param1, p_Param2, p_StrErr, p_RecType | 4 | 0 |
| `CheckForBlankBCN` | method | p_itemCol, p_StrErr | 2 | 0 |
| `GetBCNColFromParamDetails` | method | p_ItemCode, p_MCCode, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_MRP, p_SalesPrice, p_ConFactor, p_Date, p_ReqdQty | 12 | 0 |
| `GetAllItemsForSrNo` | method | p_Srno, p_MCCode | 2 | 0 |
| `GetAllItemsForBatchNo` | method | p_BatchNo, p_MCCode | 2 | 0 |
| `GetAllMRPForBCN` | method | p_BCNStr, p_MCCode, p_VchDate, p_Vchcode, p_Checked | 5 | 0 |
| `GetItemBatchNoClosingStk` | method | p_BatchNo, p_ItemCode, p_MCCode, p_AltBal | 4 | 0 |
| `IfBranchOrStateTaggedInUser` | method |  | 0 | 0 |
| `InitVchVATSumItemWiseUDT` | method | p_VchVATSumItemWise | 1 | 0 |
| `GetHeadOfficeStr` | method | p_HOString | 1 | 0 |
| `CompareUdtMasterSeriesGrpCol` | method | p_Col1, p_Col2 | 2 | 0 |
| `GetBranchAliasCol` | method |  | 0 | 0 |
| `SaveCheckListDet` | method | p_Type, p_InputMode, p_ModifyEntry, p_Code, p_udtApprovalDet, p_OldApprovalStatus, p_Action, p_Source | 8 | 0 |
| `DeleteCheckListDet` | method | p_Type, p_Code | 2 | 0 |
| `DeleteAuditCheckListDet` | method | p_Type, p_Code | 2 | 0 |
| `SaveNewCheckListEntry` | method | p_Type, p_Code, p_Action, p_udtApproval, p_Source | 5 | 0 |
| `SaveCheckListDetailedNew` | method | p_Type, p_InputMode, p_ModifyEntry, p_Code, p_XMLStr, p_D1, p_D2, p_udtApprovalDet, p_Action, p_Source, p_Remarks, p_OldApprovalStatus | 12 | 0 |
| `SaveNewCheckListEntryDetailed` | method | p_Type, p_Code, p_Action, p_Source, p_XMLStr, p_D1, p_D2, p_udtApprovalDet, p_Remarks, p_getXMLFromApprovalDet | 10 | 0 |
| `LoadCheckListDet` | method | p_Type, p_Code, p_VchMastType, p_LoadOtherInfo | 4 | 0 |
| `IfUserIsLowerInHierarchy` | method | p_UserName, p_CheckDept, p_ErrMsg | 3 | 0 |
| `DeleteTriggerData` | method | p_TGName | 1 | 0 |
| `UpdateDefaultCategoryInUser` | method | p_CategoryCode | 1 | 0 |
| `GetDefaultCatergoryForUser` | method | p_Name | 1 | 0 |
| `GetFldSize` | method | p_AutoConfig, p_CharForAutoConfig, p_ConfigType, p_VchType, p_FormatName | 5 | 0 |
| `DateType2Name` | method | p_DateType | 1 | 0 |
| `BrokerageLevel2Name` | method | p_BrokLevel | 1 | 0 |
| `GetMasterSeriesGroupCount` | method |  | 0 | 0 |
| `LoadMasterSeriesGrpTagged` | method | p_MasterCode | 1 | 0 |
| `GetValuesForItemPricingMode` | method | p_AccCode, p_ItemCode, p_VchType, p_Discount, p_MRP, p_CompoundDisc, p_DiscBasis, p_DiscAmt, p_DiscType, p_ItemwiseDisc, p_MarkUp, p_CompoundMarkup, p_MarkupBasis, p_MarkupAmt, p_MarkupType, p_ItemwiseMarkup | 16 | 0 |
| `IsCompountDiscountEnable` | method | p_ItemCode, p_VchType, p_DiscType, p_DiscBasis, p_DiscPerBasis | 5 | 0 |
| `IsCompoundMarkupEnable` | method | p_ItemCode, p_VchType, p_MarkupType, p_MarkupBasis, p_MarkupPerBasis | 5 | 0 |
| `IfBranchTagged` | method | p_BranchCode, p_strError | 2 | 0 |
| `GetMSGrpQryStr` | method | p_Mastertype, p_MastSeriesGrpCode, p_FieldName, p_SkipOperator | 4 | 0 |
| `GetMSGrpQryStrfor2Fields` | method | p_Mastertype1, p_MasterType2, p_MastSeriesGrpCode, p_FieldName1, p_FieldName2 | 5 | 0 |
| `GetVSGrpQryStr` | method | p_VchSeriesGrpCode, p_FieldName, p_SkipOperator | 3 | 0 |
| `GetVoucherSeriesGrpQry` | method | p_VchSeriesGrpCode, p_VchStr | 2 | 0 |
| `InitUdtVSGrpConfig` | method | p_VSGrpConfig | 1 | 0 |
| `MasterTaggedWithMSGrp` | method | p_MasterCode, p_MSGrpCode | 2 | 0 |
| `ExecuteQuerytmp` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `ValidSolutionPartner` | method | p_ServerInfo, p_PartnerUID, p_PartnerPass, p_ErrMsg | 4 | 0 |
| `WriteTEORefImportConfig` | method | p_FldsCol | 1 | 0 |
| `ReadTEORefImportConfig` | method |  | 0 | 0 |
| `RaiseTriggerFromVchFromFormat` | method | p_udtVchData, p_udtOldVchData, p_InputMode, p_DeleteVch | 4 | 0 |
| `RaiseTriggerFromVch` | method | p_udtVchData, p_udtOldVchData, p_InputMode, p_DeleteVch | 4 | 0 |
| `RaiseTGForMaster` | method | p_InputMode, p_MastType, p_udtMast, p_OldMast, p_Delete | 5 | 0 |
| `RaiseTriggerForMasterBalances` | method | p_MastCode, p_Vchcode, p_MCCode | 3 | 0 |
| `CheckItemDependency` | method | p_Condition | 1 | 0 |
| `CheckBSDependency` | method | p_Condition | 1 | 0 |
| `CheckAccountDependency` | method | p_Condition | 1 | 0 |
| `VchConditionSatisfy1` | method | p_TGudt, p_ConBlock, p_Condition, p_udtVchData, p_AddInfo, p_MsgStr, p_MainCon | 7 | 0 |
| `CreditLimitSpecified` | method | p_Code, p_CreditLimit | 2 | 0 |
| `CriticalLevelApplied` | method | p_Code | 1 | 0 |
| `GetItemMaxLevel` | method | p_Code | 1 | 0 |
| `GetItemMinLevel` | method | p_Code | 1 | 0 |
| `GetItemReorderLevel` | method | p_Code | 1 | 0 |
| `CheckOperatorValue` | method | p_Operator, p_TriggerValue, p_VchValue | 3 | 0 |
| `ISMasterSynced` | method | p_MasterName, p_MastertType | 2 | 0 |
| `ISVoucherSynced` | method | p_Vchcode | 1 | 0 |
| `GetEmailOfflineStr` | method | p_Repopt | 1 | 0 |
| `LoadBOControlsFromHO` | method | p_RecType | 1 | 0 |
| `InitUdtBranchMaster` | method | p_BranchMast | 1 | 0 |
| `IfUserIsLowerOrEqualInHierarchy` | method | p_UserName, p_CheckDept, p_ErrMsg | 3 | 0 |
| `GetEMailFormatName` | method | p_VSCode, p_FormatNo | 2 | 0 |
| `GetSMSFormatName` | method | p_VSCode, p_FormatNo | 2 | 0 |
| `GetNotificationFormatName` | method | p_VSCode, p_FormatNo | 2 | 0 |
| `LoadSMSFormats` | method |  | 0 | 0 |
| `GetCaptionForDisabledTVNodes` | method | p_MenuID | 1 | 0 |
| `ResetOfflineConfigurationIfFoundInAnyBranch` | method |  | 0 | 0 |
| `GetSortedItemCol` | method | p_itemCol, p_SortingChoice | 2 | 0 |
| `GetSortedCol` | method | p_itemCol, p_SortingChoice | 2 | 0 |
| `SortItemArr` | method | p_itemCol | 1 | 0 |
| `SortItemsInCol` | method | p_Col | 1 | 0 |
| `SendBankRecoEntries2BO` | method | p_RecType, p_VMType, p_CheckType, p_vchSrCode, p_VchDate, p_VchNo, p_Srno, p_AccCode, p_BankCode, p_ClrFullVch, p_ClrDate, p_BranchCode | 12 | 0 |
| `SaveHOVchXMLInDataSync` | method | p_InputMode, p_ModifyEntry, p_XMLStr, p_VchData, p_OldVchData, p_BranchCode | 6 | 0 |
| `InputMode2TypeAction` | method | p_InputMode | 1 | 0 |
| `SaveBODeletedVchInDataSync` | method | p_InputMode, p_VchData | 2 | 0 |
| `SaveHODeletedVchInDataSync` | method | p_InputMode, p_VchData, p_BranchCode | 3 | 0 |
| `IsVchOfRightMCToPostItInThisBO` | method | p_VchData, p_BranchMast, p_ErrMsg | 3 | 0 |
| `SaveHOMastXMLInDataSync` | method | p_Mastertype, p_MasterName, p_InputMode, p_ModifyEntry, p_XMLStr, p_MastData, p_OldName | 7 | 0 |
| `ISRightOnMasterToAddAndModSentItInBO` | method | p_Mastertype, p_BranchMast, p_Modify | 3 | 0 |
| `SaveHOXML` | method | p_DataSync, p_ErrMsg | 2 | 0 |
| `GetUdtDataSyncForHO2BO` | method | p_Type, p_VMType, p_InputMode, p_ModifyEntry, p_udtData | 5 | 0 |
| `ISRightOnVoucherToAddAndModSentItInBO` | method | p_VchData, p_BranchMast, p_Modify | 3 | 0 |
| `LoadDeactiveMasterData` | method | p_Code, p_status, p_ApprovalStatus | 3 | 0 |
| `SaveMasterBlockDeactivateData` | method | p_RecType, p_Code, p_MastType, p_Blocked, p_Notes, p_Deactivate, p_BlockedVchtypeCol | 7 | 0 |
| `RemoveExtraEntersFromMasterNotes` | method | p_Notes | 1 | 0 |
| `UpdateSyncStatusIfSourceIsDataSync` | method | p_Type, p_VMCode, p_OldVchCode | 3 | 0 |
| `GetMastSyncStatus` | method | p_Source, p_InputMode, p_ForceSyncAfterSaving | 3 | 0 |
| `GetVchSyncStatus` | method | p_Source, p_InputMode | 2 | 0 |
| `IfSeriesBelongsToCurUser` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `GetBranchMasterCol` | method |  | 0 | 0 |
| `GetMasterTypeFromIndex` | method | p_Index | 1 | 0 |
| `UpdateMasterSeriesGroupInMaster` | method | p_BranchCode, p_MastData | 2 | 0 |
| `GetBranchMastDataByCodeFromCompConfig` | method | p_BranchCode | 1 | 0 |
| `GetBranchMastDataByCode` | method | p_BranchCode | 1 | 0 |
| `UpdateSyncStatusOfExistingMasterAndTransaction` | method |  | 0 | 0 |
| `CheckIfFormatIsGrpWise` | method | p_FormatName, p_ConfigType, p_VchType | 3 | 0 |
| `CheckIfFormatIsGrpWiseForCostCentre` | method | p_FormatName, p_RepID | 2 | 0 |
| `GetDayBookAccTypeStr` | method | p_Type | 1 | 0 |
| `GetDayBoakAccTypeNo` | method | p_TypeStr | 1 | 0 |
| `GetLedgerTypeStr` | method | p_LedgerType | 1 | 0 |
| `GetLedgerTypeNo` | method | p_LedgerTypeStr | 1 | 0 |
| `ISHOBOVchExistInBOHO` | method | p_VchType, p_vchSrCode, p_Date, p_VchNo, p_Vchcode | 5 | 0 |
| `GetOldMastIdentity` | method | p_udtMast, p_OldName | 2 | 0 |
| `CompareUDTVchDataHeaderIdentity` | method | p_NewVchData, p_OldVchData | 2 | 0 |
| `GetOldVchIdentity` | method | p_NewVchData, p_OldVchData | 2 | 0 |
| `SortFieldArr` | method | p_itemCol | 1 | 0 |
| `UpdatePDCDetails` | method | p_VchcodeCol, p_VchTypeCol, p_ErrMsg, p_BankName, p_RetainPDCDate, p_RetainChqRcvdDate, p_MakePDCDateasVchDate | 7 | 0 |
| `PRCategoryCaption` | method | p_category | 1 | 0 |
| `GetTaggedMCNamesForBranch` | method | p_OfflineMCConfigCol | 1 | 0 |
| `GetVchCodeIfVchExistFromIdentityInHO` | method | p_OldIdentity, p_Vchcode | 2 | 0 |
| `GetPartyVchAccBal` | method | p_PartyCode, p_Col | 2 | 0 |
| `GetPartyVchAccBalRowWise` | method | p_RowNo, p_PartyCode, p_Col | 3 | 0 |
| `GenRandomAmountInParticularRange` | method | p_RangeL, p_RangeU | 2 | 0 |
| `GenRandomDateInRange` | method | p_SDate, p_EDate | 2 | 0 |
| `UpdateCheckListDetails` | method | p_InputMode, p_ModifyObj, p_SyncApprovalDetails, p_ApprovalDetails, p_Type | 5 | 0 |
| `UpdateSyncStatusOfAllObjectsInBO` | method | p_SyncStatus | 1 | 0 |
| `IsTransactionExistInsideDemoRange` | method | p_ErrMsg | 1 | 0 |
| `GetCommCodeTradeName` | method | p_ItemCommCode, p_ItemSENo, p_BranchCode | 3 | 0 |
| `GetTotalRejectedCountByBO` | method | p_RecType, p_BranchCode | 2 | 0 |
| `UpdateRecTypeInHOOfRejectedEntries` | method | p_RecType, p_BranchCode | 2 | 0 |
| `GetBranchCodeColFromServer` | method |  | 0 | 0 |
| `GetBOSeriesColFormServer` | method | p_BranchCode | 1 | 0 |
| `ISVchSeriesUsedInBOSync` | method | p_VchType, p_SeriesCode, p_Add, p_Modify, p_AllowRenumbering, p_AddInHO, p_ModInHO | 7 | 0 |
| `ISVchSeriesUsedInHOSync` | method | p_VchType, p_SeriesCode, p_Add, p_Modify, p_AllowRenumbering, p_BranchCode, p_AddInBO, p_ModInBO | 8 | 0 |
| `IsVchIdentityCanBeChange` | method | p_InputMode, p_VchType, p_vchSrCode, p_VchNum, p_ErrMsg | 5 | 0 |
| `GetSeriesSource` | method | p_VchType, p_VSCode | 2 | 0 |
| `GetUserAndBranchName` | method | p_User, p_Branch | 2 | 0 |
| `PostXMLInDataSync` | method | p_VchType, p_Vchcode | 2 | 0 |
| `SaveBankRecoEntriesInDataSync` | method | p_RecType, p_VMType, p_CheckType, p_vchSrCode, p_VchDate, p_VchNo, p_Srno, p_AccCode, p_BankCode, p_ClrFullVch, p_ClrDate, p_BranchCode | 12 | 0 |
| `GetFormLabelsCaption` | method | p_FormID, p_FormSubID, p_VchSeriesCode, p_Flag | 4 | 0 |
| `DeleteCaptionDetailsOfSeriesFromConfig` | method | p_Code | 1 | 0 |
| `ReadMastVchCaptionInfoStr` | method | p_CaptionStr | 1 | 0 |
| `MakeMastVchCaptionInfoStr` | method | p_CaptionInfo | 1 | 0 |
| `SyncBulkVchDeletion` | method | p_Vchcode | 1 | 0 |
| `GetSyncServerDBConnection` | method | p_SyncServerInfo, p_WkSpace, p_strDbName, p_RaiseError, p_ErrMsg | 5 | 0 |
| `GetRecordsetFromSyncServerDatabase` | method | p_StrQry, p_Con, p_RaiseError, p_ErrMsg | 4 | 0 |
| `CheckSyncCSUserPwd` | method | p_SyncServerInfo, p_ErrNum | 2 | 0 |
| `GetDataSyncRecords` | method | p_BranchCode | 1 | 0 |
| `DeleteSyncRecordFromDataSync` | method | p_UID | 1 | 0 |
| `DeleteSyncObjectsByRecType` | method | p_SRInfo | 1 | 0 |
| `DeleteImproperSyncObjectsByRecType` | method | p_SRInfo | 1 | 0 |
| `DeleteImproperSyncObjectsAll` | method |  | 0 | 0 |
| `GetMastTypeCol` | method |  | 0 | 0 |
| `GetRecTypeFromMasterType` | method | p_MastType | 1 | 0 |
| `SavePrintFromGridValues` | method | p_udtPFG, p_RepID, p_SubRepID, p_FormatName | 4 | 0 |
| `MakePrintFromGridStr` | method | p_udtPFG | 1 | 0 |
| `MakeFieldInfoStr` | method | p_FieldInfo | 1 | 0 |
| `InfoSavedOrNot` | method | p_RepID, p_SubRepID, p_FormatName | 3 | 0 |
| `SavedInfoForPrintFromGrid` | method | p_RepID, p_SubRepID, p_FormatName | 3 | 0 |
| `ReadPrintFromGridStr` | method | p_PrintFromGridStr | 1 | 0 |
| `IsVchSeriesGrpTaggedWithAnyBranch` | method | p_VchSeriesGrpCode, p_BranchCode | 2 | 0 |
| `IsDataExchangedUsingSync` | method |  | 0 | 0 |
| `IsMCTaggedInAnyBranch` | method | p_MCCode, p_BranchCode | 2 | 0 |
| `IsSeriesUsedInSync` | method | p_Code, p_BranchCode | 2 | 0 |
| `GetMasterNameFromXMLStr` | method | p_Mastertype, p_XMLStr, p_OldIdentity | 3 | 0 |
| `GetVchHeaderFromXMLStr` | method | p_VchType, p_XMLStr | 2 | 0 |
| `IsSeriesActAsSourceForSync` | method | p_BranchCode, p_VSCode, p_VchType | 3 | 0 |
| `ISEraseVchNoForThisSeries` | method | p_VSCode, p_VchType | 2 | 0 |
| `IsRenumberingAllowed` | method | p_UsedInSync, p_VchType, p_VSCode | 3 | 0 |
| `SaveDetailsOfVchNumConfigChanged` | method | p_BranchCode, p_RenumDone, p_OldUdtVch, p_udtVch | 4 | 0 |
| `IsVchNumConfigCanBeModified` | method | p_VchType, p_VSCode, p_CantChangeMsg | 3 | 0 |
| `SaveNewColumnValues` | method | p_udtFormat, p_RepID, p_SubRepID, p_NewFormatName, p_OldFormatName, p_CustomRepFormatName | 6 | 0 |
| `MakeNewFormatStr` | method | p_UDFFormat | 1 | 0 |
| `MakeNewColumnUserCol` | method | p_UserCol | 1 | 0 |
| `MakeNewColumnsNotVisibleStr` | method | p_ColumnsNotVisible | 1 | 0 |
| `MakeNewColumnStr` | method | p_FieldInfo | 1 | 0 |
| `InfoSavedOrNotOfNewColumn` | method | p_RepID, p_SubRepID, p_FormatName, p_CustomRepFormatName | 4 | 0 |
| `SavedInfoForNewColumn` | method | p_RepID, p_SubRepID, p_FormatName, p_CustomRepFormatName | 4 | 0 |
| `GetFormatNames` | method | p_RepID, p_SubRepID, p_CustomRepFormatName | 3 | 0 |
| `ConvertFormatStr2UDt` | method | p_FormatStr | 1 | 0 |
| `ReadNewFormatStr` | method | p_FormatStr, p_FlagDontSaveUsersCol | 2 | 0 |
| `ReadNewColumnUserCol` | method | p_UserCol | 1 | 0 |
| `ReadNewColumnNotVisibleStr` | method | p_ColumnNotVisible | 1 | 0 |
| `ReadNewColumnStr` | method | p_FieldInfoStr | 1 | 0 |
| `ConvertUdtFormat2Str` | method | p_udt | 1 | 0 |
| `DaysInMonth` | method | p_Month | 1 | 0 |
| `IsDataSyncConfigSetOff` | method |  | 0 | 0 |
| `CreateDefaultVchSeries` | method | p_VchType, p_SeriesCode, p_UsedInUpgrade | 3 | 0 |
| `DefaultVchSeriesExistForVchType` | method | p_VchType | 1 | 0 |
| `CheckPartyPendingOrderVch` | method | p_AccCode, p_VchType, p_VchTillDate, p_BrokerCode | 4 | 0 |
| `CheckPartyPendingQuotationVch` | method | p_AccCode, p_VchType, p_BrokerCode | 3 | 0 |
| `UpdateAuditStatusInTran1` | method | p_VchcodeCol | 1 | 0 |
| `GetVchAuditStatus` | method | p_Vchcode | 1 | 0 |
| `GetAMCStatusNarration` | method | p_Vchcode, p_Srno, p_Narration, p_PartyCode | 4 | 0 |
| `GetVchApprovalStatus` | method | p_Vchcode | 1 | 0 |
| `GetVchRejectionStatus` | method | p_Vchcode | 1 | 0 |
| `GetMastApprovalStatus` | method | p_Code | 1 | 0 |
| `GetMastRejectionStatus` | method | p_Code | 1 | 0 |
| `CheckQuotationFlag` | method | m_VchType | 1 | 0 |
| `InitAllTablesContainingOFMast` | method | p_OFNo, p_MastOrVchType, p_IsMaster, p_VSCode | 4 | 0 |
| `GetMasterTypeForOF` | method | p_OFMastType | 1 | 0 |
| `GetVchTypeForOF` | method | p_OFMastType | 1 | 0 |
| `GetOFName` | method | p_OFMastType | 1 | 0 |
| `GetVchOFName` | method | p_OFMastType | 1 | 0 |
| `IfConfigurationExistsForMaster` | method | p_MastType | 1 | 0 |
| `DeleteFormat` | method | p_RepID, p_SubRepID, p_FormatName, p_CustomRepFormatName | 4 | 0 |
| `SaveCustomColUserLog` | method | p_Repopt | 1 | 0 |
| `CheckFormatNameRedundancy` | method | p_FormatName, p_RepID, p_RepSubId, p_CustomRepFormatName | 4 | 0 |
| `IsVchSeriesTaggedInBranchForSyncInHO` | method | p_VchType, p_SeriesCode, p_BranchMast | 3 | 0 |
| `LoadConfigDashBoard` | method | p_UserName | 1 | 0 |
| `UpdateVchExtraInfoForRDC` | method | p_VchData, p_ExtraInfo | 2 | 0 |
| `GetItemDetToGenerateOrders` | method | p_ItemName | 1 | 0 |
| `GetVchSeriesCodeToGenerateOrders` | method | p_ErrMsg | 1 | 0 |
| `GetVchSeriesCodeToGenerateJournalVch` | method | p_ErrMsg | 1 | 0 |
| `GetItemPriceListDataFromItemMCStock` | method | p_ItemCode | 1 | 0 |
| `SaveCancelOrderEntriesInDataSync` | method | p_RecType, p_VMType, p_VchDate, p_RefNo, p_ItemCode, p_PartyCode, p_ClrDate, p_MainQty, p_AltQty, p_vchSrCode, p_BranchCode | 11 | 0 |
| `SendCancelOrderEntries2BO` | method | p_RecType, p_VMType, p_VchDate, p_RefNo, p_ItemCode, p_PartyCode, p_ClrDate, p_Qty, p_AltQty, p_vchSrCode | 10 | 0 |
| `CheckVchNo4SalePurcRetValidation` | method | p_VSCode, p_VchNo, p_VchType, p_PartyCode, p_Vchcode, p_TaxAmt, p_TaxableAmt, p_VchDate, p_ValidateVchNo, p_TaxBeforeSchg, p_TaxBeforeSchg1, p_STPTType, p_SchgAmt, p_AddSchgAmt, p_ItemCode, p_UnitName, p_HSNCode | 17 | 0 |
| `GetVchDataToValidateSalePurcRet` | method | p_VSCode, p_VchNo, p_VchDate, p_VchData, p_LoadPartial | 5 | 0 |
| `GetSalePurchaseListForReturnValidate` | method | p_VchSeriesName, p_VchDate, p_PartyName, p_VchType | 4 | 0 |
| `GetLastPurposeEntry` | method |  | 0 | 0 |
| `SaveItemParamPrice` | method | p_ItemParamPriceCol, p_ItemCode, p_Date, p_RecType | 4 | 0 |
| `ReadItemParamPrice` | method | p_ItemCode, p_RecType, p_Type, p_Date | 4 | 0 |
| `InfoSavedOrNotForItemParamPrice` | method | p_ItemCode, p_Date | 2 | 0 |
| `InfoExistsForItemBCNPriceUtility` | method | p_ItemCode | 1 | 0 |
| `InfoExistsForItemParamPriceUtility` | method | p_ItemCode | 1 | 0 |
| `GetItemParamPrice` | method | p_ItemCode, p_Date, p_P1, p_P2, p_P3, p_P4, p_P5 | 7 | 0 |
| `GetItemBCNPriceFromUtility` | method | p_ItemCode, p_BCN, p_Date | 3 | 0 |
| `InfoSavedOrNotForParticularParams` | method | p_ItemCode, p_RecType, p_Date, p_P1, p_P2, p_P3, p_P4, p_P5, p_BCN | 9 | 0 |
| `CheckDateFromPrevYearExistInTran10` | method | p_RecType | 1 | 0 |
| `GetLastDateOfEntryOfParameterPrice` | method | p_ItemCode, p_RecType | 2 | 0 |
| `CheckPIRCombinationExist` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_VchType, p_Date, p_BranchCode | 6 | 0 |
| `SavePIRForItem` | method | p_RecType, p_MasterCode1, p_PIRDAta, p_VchType, p_Date, p_BranchCode | 6 | 0 |
| `GetSQLVersion` | method |  | 0 | 0 |
| `SavedInfoForRepFilter` | method | p_RepID, p_SubRepID, p_FormatName | 3 | 0 |
| `ReadRepMultipleFilterStr` | method | p_FilterStr | 1 | 0 |
| `ReadRepFilterStr` | method | p_FilterStr | 1 | 0 |
| `SavedInfoForRepSearch` | method | p_RepID, p_SubRepID, p_FormatName | 3 | 0 |
| `ReadRepSearchStr` | method | p_SearchStr | 1 | 0 |
| `SavedInfoForRepGroup` | method | p_RepID, p_SubRepID, p_FormatName | 3 | 0 |
| `ReadRepGroupStr` | method | p_GroupStr | 1 | 0 |
| `ApplyPatchOnDatabase` | method | p_PatchStr | 1 | 0 |
| `ApplyPatchOnParams` | method |  | 0 | 0 |
| `ApplyPatchOnBatch` | method | p_IfRepairVch | 1 | 0 |
| `GetBrokerInfofromPrevFY` | method | p_VchData, p_RefNo, p_RecType | 3 | 0 |
| `GetFldValIfExist` | method | p_rst, p_Fld | 2 | 0 |
| `UserDefinedFormatExistForAnyReport` | method |  | 0 | 0 |
| `SavePartyItemCodes` | method | p_ItemPartyCodesCol, p_PartyCode | 2 | 0 |
| `ReadPartyItemCodes` | method | p_PartyCode | 1 | 0 |
| `GetItemCodeOfItemForParticularParty` | method | p_Party, p_Item | 2 | 0 |
| `SavePartyItemCodesIfNotExist` | method | p_udtData | 1 | 0 |
| `IfItemCodesExist` | method | p_PartyCode | 1 | 0 |
| `CalSurchargeAmt` | method | p_SurchargePercent, p_ItemTaxAmt, p_STPTMast, p_ItemTaxonMRP, p_ItemMRPAmt, p_TaxableAmt, p_ItemPercentOfAmt, p_ItemMRPOverNAbove, p_TaxPercent, p_TaxPercent1, p_AddCessRate, p_CessBasis, p_AddCessBasis | 13 | 0 |
| `CalStateCessAmt` | method | p_StateCessPercent, p_TaxableAmt, p_STPTMast | 3 | 0 |
| `CalAddSurchargeAmt` | method | p_AddSurPerOrAmt, p_ItemTaxAmt, p_STPTMast, p_ItemTaxonMRP, p_ItemMRPAmt, p_TaxableAmt, p_ItemPercentOfAmt, p_ItemMRPOverNAbove, p_TaxPercent, p_TaxPercent1, p_SurPerOrAmt, p_CessBasis, p_AddCessBasis | 13 | 0 |
| `CalTaxAmt` | method | p_ItemPercent, p_STPTMast, p_ItemTaxonMRP, p_ItemMRPAmt, p_TaxableAmt, p_ItemPercentOfAmt, p_ItemMRPOverNAbove, p_ItemPercent1, p_SchgPercent, p_AddSchgPercent, p_CessBasis, p_AddCessBasis | 12 | 0 |
| `GetQtnRefNoContinuous` | method | p_Refs, p_VchType, p_Trantype, p_RefType, p_ShowVchNoOnly | 5 | 0 |
| `UpdateQuotationRefNoInfoOfItems` | method | p_ItemsArr, p_QuotationRefArr | 2 | 0 |
| `LoadHolidaysConfig` | method |  | 0 | 0 |
| `WriteExcelImportConfigForItemOPStock` | method | p_udtImportFromExcel, p_RecType | 2 | 0 |
| `ReadExcelImportConfigForItemOPStock` | method | p_RecType | 1 | 0 |
| `PrintCurChar` | method | p_RepEvents, p_RepStyle, p_PutClBracket | 3 | 0 |
| `GetItemTaxCategoryforSaletype` | method | p_ItemCode, p_VchDate, p_surcharge, p_TaxRate1, p_AddCess, p_StateCess, p_PickTotalTaxAmt | 7 | 0 |
| `CheckForNonImpactBSAfterImpactBS` | method | p_BSCol, p_VchType, p_Trantype | 3 | 0 |
| `CheckBillSundryTaggingWithVoucher` | method | p_VchType, p_BSTagOnSeries, p_BSTagOnSTPT | 3 | 0 |
| `ImageExistsInDB` | method | p_Code, p_Type | 2 | 0 |
| `SaveImageInDatabase` | method | p_udtImageData | 1 | 0 |
| `LoadImageFormDatabase` | method | p_Code, p_Type | 2 | 0 |
| `UserImageExistsInDB` | method | p_Name, p_Type | 2 | 0 |
| `SaveUserAndSignImageInDatabase` | method | p_udtImageData | 1 | 0 |
| `LoadUserImageFormDatabase` | method | p_Name, p_Type | 2 | 0 |
| `GetAllVchCodesFormVchTypeAndSeries` | method | p_VchType, p_SeriesCode | 2 | 0 |
| `PrintHeaderScript` | method | p_RepEvents, p_HeaderLines, p_TotalHeaderLines, p_RepID | 4 | 0 |
| `GetVchSeriesImageFolderPath` | method | p_SeriesCode | 1 | 0 |
| `GetMSGrpStrForGroupedReports` | method | p_MastType, p_MastType1, p_FieldName, p_FieldName1, p_MSGrpCode | 5 | 0 |
| `GetBSDefValTaggedWithParty` | method | p_BSCode, p_PartyCode, p_PgrpCode, p_Val, p_FreezeDefVal, p_VchType, p_Trantype | 7 | 0 |
| `CheckBillSundryTaggingForParty` | method | p_PartyCode, p_PgrpCode, p_VchType, p_Trantype | 4 | 0 |
| `GetDefaultReportFormatName` | method |  | 0 | 0 |
| `DeleteImageFormDatabase` | method | p_Code, p_Type | 2 | 0 |
| `DeleteUserImageFormDatabase` | method | p_Name, p_Type | 2 | 0 |
| `TinNoValidation` | method | p_TinNo, p_StateCode, Msg | 3 | 0 |
| `DeleteCustomColumns` | method |  | 0 | 0 |
| `GetImagePathFormDb` | method | p_Name, p_Type | 2 | 0 |
| `GetPartyDetInVchWithColumns` | method | p_PartyCode, p_StartDate, p_EndDate, p_VchType, IsRetail, p_VchcodeCol | 6 | 0 |
| `GetChallanVchNoList` | method | p_VchType, p_VchSeries, p_StartDate, p_EndDate, p_PartyCode, p_Trantype, p_Mastertype | 7 | 0 |
| `GetChallanOpVchList` | method | p_VchType, p_VchSeries, p_StartDate, p_EndDate, p_PartyCode, p_Trantype, p_Mastertype | 7 | 0 |
| `GetRefVchCodefromPrevYr` | method | p_NewRefNo, p_Vchcode, p_VchType, p_PartyCode, p_ItemCode, p_Trantype, p_ItemSrNo | 7 | 0 |
| `GetValidNewRef` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_RefNo, p_Vchcode | 5 | 0 |
| `LoadVchAuditData` | method |  | 0 | 0 |
| `SaveVchAuditData` | method | p_Col, p_Date | 2 | 0 |
| `VchLeftForAuditing` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `GetPDCVchCodeFromPrevYr` | method |  | 0 | 0 |
| `GetVchDataColFromPrevYr` | method | p_VchcodeCol, p_VchDataCol, p_LoadPartial | 3 | 0 |
| `DeletePDCVchFromPrevYr` | method | p_Vchcode | 1 | 0 |
| `UpdateReconStatusInLedger` | method | p_Val, p_SRInfo, p_RepID | 3 | 0 |
| `InitUDTDSMast` | method | p_DSMast | 1 | 0 |
| `GetDiscountStructDetails` | method | p_StructureName | 1 | 0 |
| `GetMarkupStructDetails` | method | p_StructureName | 1 | 0 |
| `CheckForCustomColRepOpt` | method | p_RepID, p_RepSubId, p_OptionsCol, p_CustomRepFormatName | 4 | 0 |
| `FormatVisibleToCurrentUser` | method | p_FormatName, p_RepID, p_RepSubId, p_CustomRepFormatName | 4 | 0 |
| `ReadRepGraphStr` | method | p_GraphStr | 1 | 0 |
| `SavedInfoForRepGraph` | method | p_RepID, p_SubRepID, p_FormatName | 3 | 0 |
| `IsDSMastTaggingExistsInVchSeries` | method | p_Code, p_Mastertype, p_strError | 3 | 0 |
| `GetAdjustedRefNoStrFromRefCode` | method | p_RefCodeCol, p_VchDateStr, p_VchNoStr | 3 | 0 |
| `GetRefAdjustedAmt` | method | p_RefCode | 1 | 0 |
| `SaveCancelQuotationEntriesInDataSync` | method | p_RecType, p_VMType, p_VchDate, p_RefNo, p_ItemCode, p_PartyCode, p_ClrDate, p_MainQty, p_AltQty, p_vchSrCode, p_BranchCode | 11 | 0 |
| `SendCancelQuotationEntries2BO` | method | p_RecType, p_VMType, p_VchDate, p_RefNo, p_ItemCode, p_PartyCode, p_ClrDate, p_Qty, p_AltQty, p_vchSrCode | 10 | 0 |
| `InitudtPricingInfo` | method | p_udt | 1 | 0 |
| `DisconnectUserSession` | method | p_Spid | 1 | 0 |
| `GetLastDateForIQDAndPIR` | method | p_RecType, p_MasterCode1, p_VchType, p_BranchCode | 4 | 0 |
| `GetLastUIDForEventLog` | method |  | 0 | 0 |
| `GetUserDescInfo` | method | p_UID, p_descInfo | 2 | 0 |
| `MakeBusyLicenseFileStr` | method | p_udtBusyReg | 1 | 0 |
| `ReadBusyLicenseFile` | method | p_str | 1 | 0 |
| `CheckForUpdateMasterBalancesMsg` | method | p_UpgrdOver | 1 | 0 |
| `GetDefaultFAVchFormatUdt` | method | p_RepID | 1 | 0 |
| `GetContactCodeFromCallNo` | method | p_CallNo | 1 | 0 |
| `RepairLocksTable` | method |  | 0 | 0 |
| `UpdateParamAlias` | method | p_ItemCode, p_ParamNoToUpdate, p_ParamValue | 3 | 0 |
| `CheckItemSTDef4GSTINDIA` | method | p_ItemData, p_STPTMast, p_UsedForFinalValidation, p_ErrMsg, p_Disallow, p_SkipDefault, p_SchgAppl4Pakistan, p_StateCessToBeApplied | 8 | 0 |
| `GetTDSAmtRoundedOff` | method | p_Amt, p_AmtType | 2 | 0 |
| `GSTINValidation` | method | p_GSTIN, p_StateCode, Msg, p_CheckCompGSTIN | 4 | 0 |
| `GSTINValidation4CheckSum` | method | p_GSTIN, p_ErrMsg | 2 | 0 |
| `CheckSumforGSTIN` | method | gstin14DIgit | 1 | 0 |
| `GetAccCodeFromTaxType` | method | p_TaxType, p_AccName, p_MasterSeriesCode, p_VchSeriesGrpCode, p_AmountType | 5 | 0 |
| `GetParamDetailsFromBCNUtility` | method | p_BCN, p_ItemCode, p_Date, p_VchType, p_ParamData, p_OnlyCredentials | 6 | 0 |
| `GetItemCodeOfItemForParticularPartyFromPrevYR` | method | p_Vchcode, p_ItemSrNo, p_ItemCode | 3 | 0 |
| `GetLastYearDBCon` | method | p_db, p_Con | 2 | 0 |
| `IsAlphabetic` | method | p_str | 1 | 0 |
| `ChangeTaxType` | method |  | 0 | 0 |
| `CheckIfSLUsedInScript` | method | p_Col | 1 | 0 |
| `SortItemAliasWise` | method | p_itemCol | 1 | 0 |
| `CheckSLUsedInBarcodeCol` | method | p_udtConfig | 1 | 0 |
| `DisableBBDEPInCompConfig` | method |  | 0 | 0 |
| `DisableCloudSyncInCompConfig` | method |  | 0 | 0 |
| `UpdateCloudSyncUID` | method | p_UID, p_ServiceURL | 2 | 0 |
| `PerformOperation` | method | p_ExpStr, p_DecimalPlaces | 2 | 0 |
| `MakeNewVchDataFromOldVchData` | method | p_Oldudt, p_Newudt | 2 | 0 |
| `GetBillRefVchCodefromPrevYr` | method | p_NewRefNo, p_Vchcode, p_PartyCode | 3 | 0 |
| `CompareUdtGeneralForItemMultiAlias` | method | p_Col1, p_Col2 | 2 | 0 |
| `CompareAccMultiAliasCol` | method | p_Col1, p_Col2 | 2 | 0 |
| `FindAccMultiAliasInCol` | method | p_AccMultiAliasName, p_AccMultiAliasCol, p_udtAddressInfo | 3 | 0 |
| `SplitAccMultiAliasDataString` | method | p_str | 1 | 0 |
| `GetNepalRestriction` | method |  | 0 | 0 |
| `SetNepalRestriction` | method | p_NepalRestriction | 1 | 0 |
| `IfNotesAvailableReportWiseInGivenReport` | method | p_Repopt | 1 | 0 |
| `GetVchDetFromOrgSalePurchase` | method | p_Vchcode, p_VchYear, p_VchData, p_VchType | 4 | 0 |
| `PostXMLDetailedAuditTrail` | method | p_VchType, p_Vchcode, p_ModifyRemarks | 3 | 0 |
| `GetXMLFromRecordsetPrevFY` | method | p_StrQry, p_ErrMsg | 2 | 0 |

## Busy2L21.COtherServices1

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetMasterSeriesGroupNameStrFormCol` | method | p_Col | 1 | 0 |
| `GetMasterSeriesGroupColFromNameStr` | method | p_str, p_Mastertype | 2 | 0 |
| `SaveConfigBalSheetFormatName` | method | p_FormatName, p_PRID | 2 | 0 |
| `ConfigBalSheetFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `SaveBalanceSheetConfig` | method | p_DataCol, p_FormatName, p_PRID | 3 | 0 |
| `ChkUserRightsForGSTConfiguration` | method |  | 0 | 0 |
| `GetBalanceSheetConfigCol2Str` | method | p_DataCol, p_ReportCaption | 2 | 0 |
| `GetBalanceSheetConfigStr2Col` | method | p_str, p_ReportCaption, p_NPRowNo, p_GPRowNo | 4 | 0 |
| `GetBalanceSheetConfigFldVal` | method | p_Col, p_FldID | 2 | 0 |
| `LoadBalanceSheetConfig` | method | p_FormatName, p_PRID | 2 | 0 |
| `CheckForUpdateMasterBalancesMsg` | method | p_UpgrdOver | 1 | 0 |
| `GetConfigBalSheetFormats` | method | p_PRID | 1 | 0 |
| `ReadConfigBalSheetFormat` | method | p_RID, p_FormatName | 2 | 0 |
| `CopyConfigBalSheetFormat` | method | p_FormatName, p_RepID, p_Lines | 3 | 0 |
| `GetBSDefaultFormat` | method | p_FormatType, p_DefaultFormatSubType | 2 | 0 |
| `InitUdtBalanceSheetConfig` | method | p_udt | 1 | 0 |
| `GetItemComponenetAmt` | method | p_ItemEntries, p_BSData, p_AltCur | 3 | 0 |
| `GetVchCodeColForRegeneration` | method | p_str, p_VchDate, p_VchType, p_VchSeries, p_VchNo | 5 | 0 |
| `AddItemComponentsForBSEffect` | method | p_TotalAmt, p_AltCur, p_ItemData, p_BSData, p_IfNegQty | 5 | 0 |
| `SubItemCompFromTotalItemAmtForBSEffect` | method | p_TotalAmt, p_AltCur, p_ItemData, p_BSData, p_IfNegQty | 5 | 0 |
| `IfAccountingApplicableInMIMR` | method | p_VchType, p_Trantype | 2 | 0 |
| `GetPendingQtyIssuedForJobWork` | method | p_ItemCode, p_PartyCode, p_AltPendQty, p_JobID, p_RecType, p_VchDate, p_Vchcode | 7 | 0 |
| `GetAvgPriceForJobWork` | method | p_ItemCode, p_PartyCode, p_RecType, p_JobID, p_Vchcode, p_VchDate | 6 | 0 |
| `GetAccRegColsSize1` | method | p_RepID, p_FormatName, p_cols, p_Size, p_ChkSalReg | 5 | 0 |
| `GetItemDetInVch1` | method | p_Vchcode, p_UsePrintName | 2 | 0 |
| `UpdateVchExtraInfo1` | method | p_VchData, p_ExtraInfo | 2 | 0 |
| `UpdateCallExtraInfo` | method | p_VchData, p_ExtraInfo | 2 | 0 |
| `GetAreaFromContact` | method | p_Code | 1 | 0 |
| `CheckIfDBHasBeenChanged` | method |  | 0 | 0 |
| `UpdateItemParamPriceWiseDetails` | method | p_ParamCol, p_ItemData, p_VchConfig | 3 | 0 |
| `GetVchListForParty` | method | p_PartyCode, p_VchSeriesCode, p_VchType, p_StartDate, p_EndDate, p_MasterRange, p_VchNo, p_SecondVchNo, p_allVchSeriesIncluded | 9 | 0 |
| `CheckForAnyPendingRMWithParty` | method | p_PartyCode, p_RecType | 2 | 0 |
| `GetEmailSMSDet` | method | p_VchCol, p_PartyCode, p_EmailSMSFlag, p_GetWhatsAppNo | 4 | 0 |
| `MakeBusySystemInfoFileStr` | method | p_udtData | 1 | 0 |
| `ReadBusySystemInfoFile` | method | p_str | 1 | 0 |
| `MakeBusyLicenseRegistryInfoStr` | method | p_udtData | 1 | 0 |
| `ReadBusyLicenseRegistryInfo` | method | p_str, p_ErrInReading | 2 | 0 |
| `GetVchListForSMSEmailUtility` | method | p_VchType, p_VchSeries, p_StartDate, p_EndDate | 4 | 0 |
| `GetCCAccTranOpBal` | method | p_CCCode, p_AccCode, p_Date | 3 | 0 |
| `SaveOfflineAutoSendValue` | method | p_Value | 1 | 0 |
| `LoadOfflineAutoSendValue` | method |  | 0 | 0 |
| `CheckIfItemPendUnderGivenJobID` | method | p_JobID, p_ItemCode, p_RecType, p_VchDate | 4 | 0 |
| `GetAllRMItemPendUnderGivenJobID` | method | p_JobID, p_RecType, p_PartyCode, p_Vchcode, p_VchDate | 5 | 0 |
| `GetFormDetails` | method | p_FormStr | 1 | 0 |
| `GetUserDefinedColumnsFormats` | method | p_RepID, p_RepSubId, p_FormatNameCol, p_ReportName, p_CustomRepName | 5 | 0 |
| `GetAllUserDefinedFormats` | method | p_Flag | 1 | 0 |
| `ApplyPatchForPDCRefs` | method |  | 0 | 0 |
| `DeleteEventLogTillDate` | method | p_Date, p_UserName | 2 | 0 |
| `TrimMemoFieldforAccess` | method | p_str | 1 | 0 |
| `UpdateSubLedgerInfoForAccs` | method | p_AccsCol, p_SubLedgerCol | 2 | 0 |
| `GetSubLedgerDet` | method | p_SplitFlag, p_ItemPrintdet, p_UdtSubAccData, p_RefStr, p_Flag | 5 | 0 |
| `UpdateCostCentreInfoForAccs` | method | p_AccsCol, p_CostCentreCol | 2 | 0 |
| `GetCostCentreDet` | method | p_SplitFlag, p_ItemPrintdet, p_UdtCostCentreData, p_RefStr, p_Flag | 5 | 0 |
| `SplitQuantity` | method | p_MainQty, p_AltQty, p_ItemCode | 3 | 0 |
| `CheckIfItemExistInList` | method | p_List, p_Item | 2 | 0 |
| `SaveCheckListForMiscellaneousDataEntry` | method | p_Code, p_VchType, p_Notes | 3 | 0 |
| `UpdateSyncStatusFromUtility` | method | p_Vchcode, p_SyncStatus | 2 | 0 |
| `FindAllUnApprovedUnauditedVch` | method | p_Col, p_VchType, p_VchSeriesCode, p_PartyCode | 4 | 0 |
| `GetExtraExpenseFromBOM` | method | p_BOMCode | 1 | 0 |
| `LoadItemSerialNoInstallationDetails` | method | p_ItemCode, p_SerialNo, p_ItemSerialNoDet | 3 | 0 |
| `LoadMasterAddressInfoForSerialNoInstallationDetails` | method | p_Vchcode, p_AddInfo | 2 | 0 |
| `TrackingSystemNo2StrforCPRScripts` | method | p_No | 1 | 0 |
| `TrackingSystemNo2Str` | method | p_No, p_TreatClosedAsOpen | 2 | 0 |
| `TrackingSystemStr2No` | method | p_str, p_IfClosed, p_TreatClosedAsOpen | 3 | 0 |
| `YesNoStrToBooleanValue` | method | p_str | 1 | 0 |
| `BooleanValueToYesNoStr` | method | p_BoolVal | 1 | 0 |
| `GetTrackingSystemConfigLevel` | method | p_VchType | 1 | 0 |
| `GetFilingFrequencyfromPartyCode` | method | p_PartyCode | 1 | 0 |
| `GetFinalTrackingStatus` | method | p_TrackingNo, p_Vchcode | 2 | 0 |
| `GetAllTrackingNoList` | method | p_TrackingStatus, p_Vchcode | 2 | 0 |
| `GetAllTrackingNoListForParty` | method | p_TrackingStatus, p_PartyCode | 2 | 0 |
| `LoadVchOtherInfo` | method | p_Vchcode | 1 | 0 |
| `SaveVchOtherInfo` | method | p_Vchcode, p_udtVchOtherInfo | 2 | 0 |
| `GetPendingJobItemsForGivenParty` | method | p_PartyCode, p_RecType, p_Date | 3 | 0 |
| `GetPendingFGJobRefsForParty` | method | p_PartyCode, p_RecType | 2 | 0 |
| `GetJobFGRefDueDateForGivenJobID` | method | p_JobID, p_RecType | 2 | 0 |
| `GetJobFGRefDueDate` | method | p_JobID, p_ItemCode, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_PartyCode, p_VchDate | 9 | 0 |
| `GetJobFGRefDueDateFromJobID` | method | p_JobID, p_ItemCode, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_PartyCode, p_VchDate | 9 | 0 |
| `GetPendingJobRefsForGivenItem` | method | p_ItemCode, p_RecType | 2 | 0 |
| `GetJobDueDate` | method | p_JobID, p_RecType | 2 | 0 |
| `GetJobVchDate` | method | p_PartyCode, p_ItemCode, p_JobID, p_RecType | 4 | 0 |
| `GetPendingJobIDList` | method | p_PartyCode, p_RecType, p_VchDate, p_PendQty, p_Vchcode | 5 | 0 |
| `GetVchCodeFromJobID` | method | p_JobID, p_PartyCode, p_RecType, p_Date | 4 | 0 |
| `CheckForDupStatusOfJobID` | method | p_JobID, p_PartyItemCode, p_CheckPartyItem, p_RecType, p_Vchcode | 5 | 0 |
| `GetTrackingNoListForPrevAndCurrentYearByFilter` | method | p_Filter | 1 | 0 |
| `GetTrackingNoListForPrevAndCurrentYearByFilterForParty` | method | p_Filter, p_PartyCode | 2 | 0 |
| `CheckIfPhyStkVchExists` | method | p_Vchcode, p_VchNo, p_VchDate | 3 | 0 |
| `CheckIfPhyStkItemExists` | method | p_VchDate, p_MCCode, p_ItemCode | 3 | 0 |
| `GetDoNotMaintainItemStockFlag` | method | p_ItemCode | 1 | 0 |
| `GetTrackingNoListForPrevAndCurrentYear` | method | p_TrackingStatus, p_Vchcode | 2 | 0 |
| `UpdateTrackingIDStatus` | method | p_TrackingNo | 1 | 0 |
| `GetColSizeOfSalePurcAnalysis` | method | p_Repopt, p_Size | 2 | 0 |
| `GetColSizeOfItemTranList` | method | p_Repopt, p_Size | 2 | 0 |
| `GetDrCrAmtTrackingSystem` | method | p_AccName, p_TrackingNo, p_StartDate, p_EndDate, p_Dr, p_Cr, p_IncludePrevYear | 7 | 0 |
| `FindtrackingStatus` | method | p_TrackingNo, p_TrackingNoExist | 2 | 0 |
| `GetTrackingNoStatusForPrevAndCurrentYear` | method | p_TrackingNo | 1 | 0 |
| `ChkVchSerExistInVchSerGrp` | method | p_VchSerCode, p_VchSerGrpCode | 2 | 0 |
| `SetCustomScriptVchData` | method | p_ID, p_Value, p_udtVchData, p_VchExtraInfo | 4 | 0 |
| `GetVchDataOnCustomScript` | method | p_ID, p_udtVchData, p_VchExtraInfo | 3 | 0 |
| `SetCustomScriptItemData` | method | p_ID, p_Value, p_udtItemdata | 3 | 0 |
| `GetItemDataOnCustomScript` | method | p_ID, p_udtItemdata, p_ExtraInfo | 3 | 0 |
| `SetCustomScriptAccData` | method | p_ID, p_Value, p_udtAccData | 3 | 0 |
| `GetAccDataOnCustomScript` | method | p_ID, p_udtAccData | 2 | 0 |
| `SetCustomScriptBSData` | method | p_ID, p_Value, p_udtBSData | 3 | 0 |
| `GetBSDataOnCustomScript` | method | p_ID, p_udtBSData | 2 | 0 |
| `SetCustomScriptBillRefData` | method | p_ID, p_Value, p_udtBillRefData | 3 | 0 |
| `GetBillRefDataOnCustomScript` | method | p_ID, p_udtBillRefData | 2 | 0 |
| `SetCustomScriptBatchData` | method | p_ID, p_Value, p_udtBatchData | 3 | 0 |
| `GetBatchDataOnCustomScript` | method | p_ID, p_udtBatchData | 2 | 0 |
| `SetCustomScriptSNData` | method | p_ID, p_Value, p_udtSNData | 3 | 0 |
| `GetSNDataOnCustomScript` | method | p_ID, p_udtSNData | 2 | 0 |
| `SetCustomScriptParamData` | method | p_ID, p_Value, p_udtParamData | 3 | 0 |
| `GetParamDataOnCustomScript` | method | p_ID, p_udtParamData | 2 | 0 |
| `SetCustomScriptJobData` | method | p_ID, p_Value, p_udtJobData | 3 | 0 |
| `SetCustomScriptBillRefAccData` | method | p_ID, p_Value, p_udtBillRefData | 3 | 0 |
| `GetBillRefAccDataOnCustomScript` | method | p_ID, p_udtBillRefData | 2 | 0 |
| `CheckIfCSOrderRefCodeConst` | method | p_ID | 1 | 0 |
| `CheckIfCSChallanRefCodeConst` | method | p_ID | 1 | 0 |
| `CheckIfCSIndentRefCodeConst` | method | p_ID | 1 | 0 |
| `CheckIfCSQuotationRefCodeConst` | method | p_ID | 1 | 0 |
| `GetJobDataOnCustomScript` | method | p_ID, p_udtJobData | 2 | 0 |
| `SetCustomScriptCCData` | method | p_ID, p_Value, p_udtCCData | 3 | 0 |
| `GetCCDataOnCustomScript` | method | p_ID, p_udtCCData | 2 | 0 |
| `SetCustomScriptCallData` | method | p_ID, p_Value, p_udtCallData | 3 | 0 |
| `GetCallDataOnCustomScript` | method | p_ID, p_udtCallData | 2 | 0 |
| `SetCustomScriptCallVchData` | method | p_ID, p_Value, p_udtCallVchData | 3 | 0 |
| `GetCallVchDataOnCustomScript` | method | p_ID, p_udtCallVchData | 2 | 0 |
| `SetCustomScriptRepOptData` | method | p_ID, p_Value, p_udtRepOpt | 3 | 0 |
| `GetRepOptDataOnCustomScript` | method | p_ID, p_udtRepOptData | 2 | 0 |
| `LoadRetainPDCDateForVch` | method |  | 0 | 0 |
| `UpdateNarrationInStkJrnlVch` | method | p_Value | 1 | 0 |
| `LoadNarrationInStkJrnlVch` | method |  | 0 | 0 |
| `GetBillSundryTaggedWithVoucherSeries` | method | p_VchType, p_VchSeriesCode, p_FreezeBS, p_FreezeBSGrid, p_Trantype | 5 | 0 |
| `GetBillSundryTaggedWithSTPT` | method | p_VchType, p_VchSeriesCode, p_STPTCode, p_Trantype, p_FreezeBS, p_FreezeBSGrid | 6 | 0 |
| `GetBillSundryValTaggedParty` | method | p_BSCol, p_PartyCode, p_PgrpCode, p_TranCurSymbol, p_VchType, p_Trantype | 6 | 0 |
| `GetDefaultInvoiceFormatUdt` | method | p_RepID | 1 | 0 |
| `MakeAddressIn2Lines` | method | p_Add1, p_Add2, p_Add3, p_Add4, p_RetAdd1, p_RetAdd2 | 6 | 0 |
| `MakeAddressIn1Line` | method | p_Add1, p_Add2, p_Add3, p_Add4 | 4 | 0 |
| `GenStandardInvVchFormat` | method | p_VchType, p_VchData | 2 | 0 |
| `ConvertInvoiceFormatLines2UDT` | method | p_ScrLines, p_VchType | 2 | 0 |
| `GetCompanySize` | method | p_CompCode, p_FYList, p_SQLServerDataPath | 3 | 0 |
| `GetTrackingNoPartyItemJobOpBal` | method | p_TrackingNo, p_Date, p_RecType, p_PartyCode, p_ItemCode, p_CheckOnJobId, p_JobID, p_AltQty | 8 | 0 |
| `CheckJobRefExistForParty` | method | p_PartyCode, p_VchType, p_Trantype | 3 | 0 |
| `CheckJobRefFinishedGoodsExistForParty` | method | p_PartyCode, p_VchType, p_Trantype | 3 | 0 |
| `CheckJobWorkEntries` | method | p_PartyCode, p_VchType, p_Trantype, p_CheckOnlyTranTpye | 4 | 0 |
| `GetItemCategoryPrice` | method | p_PriceCategory, p_ItemMast, p_VchType, p_Trantype, p_PricingInfo, p_SetBasePriceInfo | 6 | 0 |
| `GetBasePricingInfoFromItemMast` | method | p_ItemMast, p_VchType, p_Trantype, p_BaseVchType | 4 | 0 |
| `SetBasePrice2PricingInfo` | method | p_BasePriceInfo, p_PricingInfo | 2 | 0 |
| `GetUniqueBillRefGrp` | method | p_udtVchData, p_MCCode | 2 | 0 |
| `GetUniqueBillRefGrpDet` | method | p_udtVchData, p_MCCode, p_CreditDaySale, p_CreditdayPurc | 4 | 0 |
| `CheckJobRefExist` | method | p_VchType, p_RecType, p_Trantype | 3 | 0 |
| `LoadTariffHeadingDesc` | method |  | 0 | 0 |
| `PickDescriptionOfTariffHeading` | method | p_TariffHeading | 1 | 0 |
| `SetDueDateIfZeroDueDate` | method | p_PendingBills, p_AccEntries, p_Date | 3 | 0 |
| `CreateDefaultReferences` | method | p_BillRefGrpCol, p_VchNo, p_CreditDays, p_VchDate, p_Value1, p_RefDataCol, p_CreditDayCol | 7 | 0 |
| `UpdtateDoNotMaintainStkBalDefaultValue` | method | p_Value | 1 | 0 |
| `GetGLCodeforAcc` | method | p_AccCode | 1 | 0 |
| `GetAccFirstReference` | method | p_PendingBills, p_AccCode | 2 | 0 |
| `GetAccFirstReferenceForAccWise` | method | p_AccData | 1 | 0 |
| `IfSameVOFDataTypeOFWise` | method | p_udtvchconfig1, p_udtVchConfig2, p_OFNo | 3 | 0 |
| `CheckHDDBinding` | method | p_CompCode, p_ErrMsg | 2 | 0 |
| `GetHDDBindingStr` | method | p_MemoStr | 1 | 0 |
| `CheckHDDBindingForCompany` | method | p_EnableHDDBinding, p_HDDStr | 2 | 0 |
| `CheckUserOverwriteRights` | method | p_CompCode, p_UserName, p_Password | 3 | 0 |
| `CheckHDDBindingForUser` | method | p_CompCode, p_UserName, p_ErrMsg | 3 | 0 |
| `LoadListOfVch` | method | p_Col, p_VchType, p_VchSeriesCode, p_PartyCode, p_MCInCode, p_StartDate, p_EndDate, p_STPTCode, p_Trantype, p_StartVchNo, p_EndVchNo | 11 | 0 |
| `UpdateVoucherRejectionDetails` | method | p_VchcodeCol, p_VchTypeCol, p_RejectionStatus, p_RejectionReason, p_RejectionDetails | 5 | 1 |
| `UpdateMasterRejectionDetails` | method | p_MasterCodeCol, p_MasterTypeCol, p_RejectionStatus, p_RejectionReason, p_RejectionDetails | 5 | 1 |
| `GetLastRejectionReason` | method | p_Code, p_Repopt, p_ApprovalType | 3 | 0 |
| `DeleteLastRejectedVchDet` | method | p_Vchcode | 1 | 0 |
| `GetPendingOrderRefCol` | method | p_Date1, p_VchType, p_RefType, p_AccCode, p_ItemCode, p_AccRange, p_ItemRange, p_MCCode, p_MCRange, p_Trantype | 10 | 0 |
| `IfCancelRefExist` | method | p_RefCode, p_Qty, p_AltQty | 3 | 0 |
| `IfHideValOfItems` | method | p_IsSuperUser, p_VchType | 2 | 0 |
| `IfDataSyncImproperEntryExist` | method |  | 0 | 0 |
| `DeleteExtraEventLogEntries` | method |  | 0 | 0 |
| `GetBillRefDate` | method | p_RefData | 1 | 0 |
| `InitUdtSchemeMast` | method | p_udt | 1 | 0 |
| `InitUdtSchemeInfo` | method | p_udt | 1 | 0 |
| `GetSchemeMastVchDetCol2Str` | method | p_Col | 1 | 0 |
| `GetSchemeMastVchDetStr2Col` | method | p_str | 1 | 0 |
| `GetOpeningClosingBalForCommCode` | method | p_CompCode, p_StartDate, p_EndDate, p_McCol, p_VchSeriesGrpCode | 5 | 0 |
| `DeleteCustomRepCustomColFormat` | method | p_RepID, p_SubRepID, p_CustomRepFormatName | 3 | 0 |
| `GetTaxCategoryCodeCol` | method | p_TaxRate, p_VchSeriesGrpCode | 2 | 0 |
| `CheckLimitationForAutomaticCallNo` | method | p_udtVchData, p_udtVchNum, p_StrMsg, p_Warning, p_Date | 5 | 0 |
| `WriteExcelImportSalaryVchConfig` | method | p_udtImportFromExcel | 1 | 0 |
| `ReadExcelImportSalaryVchConfig` | method | p_Mastertype, p_EmpSalaryMode | 2 | 0 |
| `InitUserUdt1` | method | p_udtUserProfile1 | 1 | 0 |
| `GetVchTypesForUserRights` | method |  | 0 | 0 |
| `GetDocPrintFlag` | method | p_Vchcode | 1 | 0 |
| `GetOrgName` | method | p_Code, p_MastType | 2 | 0 |
| `GetOrgCode` | method | p_Name, p_MastType | 2 | 0 |
| `InitUserUDT` | method | p_udtUserProfile, p_udtUserProfile1 | 2 | 0 |
| `GetCurSymbol` | method | p_CurSymbol | 1 | 0 |
| `SaveVoucherUserLog` | method | p_Vchcode, p_VoucherType, p_LogFor, p_udtVchData, p_OldVchData, p_BranchCode, p_DontSaveJustGetMsg, p_Msg | 8 | 0 |
| `SaveMasterUserLog` | method | p_Code, p_Mastertype, p_LogFor, p_NewMastUdt, p_OldMastUdt, p_BranchCode, DontSaveJustGetMsgStr, p_Msg | 8 | 0 |
| `GetVchAmt` | method | p_udtVchData, p_AmtRM | 2 | 0 |
| `GetMappedChallanOrderRefsForItem` | method | p_RecType, p_ItemCode, p_ItemEntries, p_VchType, p_Trantype, p_VchNo, p_VchDate, p_AltCurUnitReq, p_PartyCode | 9 | 0 |
| `UpdateMastSerGrpFromItemGrpAccGrpToAllChilds` | method | p_Choice, p_GrpMastCode, p_ChildMasterType, p_MasterSeriesGrpCol | 4 | 0 |
| `ChangeGrpNameInOtherYears` | method | p_MastType, p_GrpMasterType, p_MastName, p_OldGrpName, p_NewGrpName | 5 | 0 |
| `ChangeGrpMasterNameinDB` | method | p_db, p_Con, p_MastType, p_GrpMasterType, p_MastName, p_OldGrpName, p_NewGrpName | 7 | 0 |
| `GetRegionStrFromAssignCode` | method | p_AssignCode | 1 | 0 |
| `CheckIfTranTypeIsPDC` | method | p_Vchcode | 1 | 0 |
| `GetMasterApprovalStatus` | method | p_MastName, p_Mastertype | 2 | 0 |
| `GetIssueOfficeCol` | method |  | 0 | 0 |
| `GetPenOrderItemsInVch` | method | p_Vchcode, p_AccCode, p_RefType, p_ItemsCol, p_RefDatas, p_OpRef, p_VchOtherInfo, p_VchConfig, p_STPTName, p_CurDate, p_MCName | 11 | 0 |
| `GetPenQtnItemsInVch` | method | p_Vchcode, p_AccCode, p_RefType, p_ItemsCol, p_RefDatas, p_OpRef, p_VchOtherInfo, p_VchConfig, p_STPTName, p_CurDate, p_MCName | 11 | 0 |
| `GetPenChallanItemsInVch` | method | p_Vchcode, p_VchType, p_AccCode, p_RefType, p_ItemsCol, p_RefDatas, p_OpRef, p_VchOtherInfo, p_VchConfig, p_STPTName, p_CurDate, p_MCName | 12 | 0 |
| `GetPendingBatchesDetFromPrevYrChallanReversal` | method | p_ItemData, p_RefNoStr, p_NewRefSrNo | 3 | 0 |
| `GetPenIndentItemsInVch` | method | p_Vchcode, p_MCCode, p_RefType, p_ItemsCol, p_RefDatas, p_OpRef, p_VchOtherInfo, p_VchConfig, p_CurDate | 9 | 0 |
| `GetItemParamDetFromPrevYrIndentRefs` | method | p_ItemData, p_RefNo, p_ItemSrNo, p_RefType | 4 | 0 |
| `GetBSfromPrevFY` | method | p_BSCol, p_RefNo, p_VchType, p_AccName | 4 | 0 |
| `GetBillingDetInfofromPrevFY` | method | p_VchData, p_RefNo, p_AccName, p_VchType | 4 | 0 |
| `GetPackingDetInfofromPrevFY` | method | p_VchData, p_RefNo, p_AccName, p_VchType | 4 | 0 |
| `GetItemDescFromPrevFY` | method | p_ItemData, p_RefNo, p_VchOtherInfo, p_PickAltCurPrice, p_RefType, p_VchConfig, p_ItemSrNo, p_AccName | 8 | 0 |
| `GetItemParamDetFromPrevYrQuotationRefs` | method | p_ItemData, p_RefNo, p_ItemSrNo, p_AccName | 4 | 0 |
| `GetVchDataForOpeningVch` | method | p_Vchcode, p_VchType, p_AccCode, p_RefType, p_OpRef, p_VchSeriesCode, p_STPTName, p_CurDate, p_Ref | 9 | 0 |
| `UpdateFreeQtyStr` | method | p_ItemData, p_AccCode, p_RefCode, p_RefNo, p_RecType | 5 | 0 |
| `CheckForBlankDuplicateVchNoForCallRcptVch` | method | p_VchNo, p_ErrStr, p_Vchcode, p_Trantype | 4 | 0 |
| `CheckForVchAdjustmentForSaleType` | method | p_RefType, p_ItemData, p_RefNo, p_Vchcode, p_ItemSrNo, p_STPTName, p_AccName | 7 | 0 |
| `CheckIfVchRefsAdjustmentExist` | method | p_RecType, p_Vchcode, p_OpRefNo, p_PartyCode | 4 | 0 |
| `WildSearch` | method | p_str, p_Compareto, p_Method, p_SearchAll | 4 | 0 |
| `SaveMastImageInCurrentDB` | method | p_MastName, p_MastType, p_ImageType, p_SourceFY | 4 | 0 |
| `GetCConfXMLStringFromFile` | method | p_FilePath, p_TagStr | 2 | 0 |
| `GetBranchStr` | method | p_BranchCode | 1 | 0 |
| `GetCallHistory1` | method | p_CallNo, p_CheckAllocation, p_AreaCode, p_Date, p_Vchcode | 5 | 0 |
| `GetCallHistory` | method | p_CallNo, p_RcptDate, p_Contact, p_Executive, p_AllocationDate, p_NextAction, p_NextActionDate, p_CallRcptTime, p_AllocationTime, p_NextActionTime, p_Trantype, p_CheckAllocation, p_AreaCode, p_SubStatus, p_callCatCode, p_SourceCode, p_Remarks, p_ActionRemarks | 18 | 0 |
| `GetItemLastTransactionsForSalePurc` | method | p_PartyName, p_ItemName, p_VchType, p_NoOfTran, p_Date, p_VoucherCode, p_InputMode | 7 | 0 |
| `GetBSConsolidatedValforChallan` | method | p_RecType, p_VchCodes, p_OpRefs, p_AccName, p_VchType, p_BSCol | 6 | 0 |
| `GetCurrencyInfoAsPerCountry` | method | p_CountryCode, p_CurSym, p_CurStr, p_CurSubStr, p_FontName, p_CharUsed | 6 | 0 |
| `CheckCountryBelongsToSouthAsia` | method | p_CountryCode | 1 | 0 |
| `CheckCountryBelongsToSouthAsiaByName` | method | p_Country | 1 | 0 |
| `ChangeCountry` | method | p_CountryCode, p_ErrMsg | 2 | 0 |
| `GetSouthAsiaCountryList` | method |  | 0 | 0 |
| `GetSouthAsiaCountryNamesList` | method |  | 0 | 0 |
| `GetSTPTMasterTypeByVRC` | method | p_VRC | 1 | 0 |
| `GetAllPendCallsForOpening` | method |  | 0 | 0 |
| `SaveOpeningCallRefsFromLastFY` | method | p_CallEntries, p_PrevCol | 2 | 0 |
| `GetDefaultCallReportFormatUdt` | method | p_RepID | 1 | 0 |
| `FilterSchemeOnBasisofVchDets` | method | p_VchDate, p_CurTime, p_PartyCode, p_udtVchConfig, p_VchType, p_VchSeriesCode | 6 | 0 |
| `FindSchemeApplicableOnItemFromGivenSchemeCol` | method | p_ItemData, p_ApplySchemeIn, p_SchemeCol, p_PartyCode | 4 | 0 |
| `FindSchemeApplicableOnItem` | method | p_PartyCode, p_VchType, p_VchSeriesCode, p_VchDate, p_CurTime, p_ItemData, p_udtVchConfig, p_ApplySchemeIn | 8 | 0 |
| `FindSchemeApplicableOnClubbedItemsFromGrivenSchemes` | method | p_PartyCode, p_VchType, p_VchSeriesCode, p_VchDate, p_CurTime, p_ItemData, p_STPTMast, p_ItemDataCol, p_udtVchConfig, p_ApplySchemeIn, p_SchemeCol | 11 | 0 |
| `FindSchemeApplicableOnClubbedItems` | method | p_PartyCode, p_VchType, p_VchSeriesCode, p_VchDate, p_CurTime, p_ItemData, p_STPTMast, p_ItemDataCol, p_udtVchConfig, p_ApplySchemeIn | 10 | 0 |
| `FindSchemeApplicableOnVch` | method | p_PartyCode, p_VchType, p_VchSeriesCode, p_VchDate, p_CurTime, p_TotalItemAmt, p_TotalVchAmt, p_udtVchConfig, p_ApplySchemeIn | 9 | 0 |
| `CheckDateTimeForScheme` | method | p_VchDate, p_CurTime, p_SMDateRangeCol | 3 | 0 |
| `GetClubbedQtyAmtForScheme` | method | p_ItemDataCol, p_STPTMast, p_SchemeMast, p_GrpName, p_OFVal, p_Col, p_No | 7 | 0 |
| `CheckOFExistInItemForSM` | method | p_ItemData, p_OFNo, p_SchemeDet | 3 | 0 |
| `IsTranExistForSchemeMast` | method | p_Code, p_ErrMsg | 2 | 0 |
| `GetItemBestSMPrice` | method | p_ItemCode, p_UdtSchemMast, p_TotalQtyInVch | 3 | 0 |
| `GetItemBestSMDiscount` | method | p_ItemCode, p_ItemData, p_UdtSchemMast, p_TotalQtyInVch, p_CompoundDisc, p_Pos | 6 | 0 |
| `GetItemBestSMFreeQty` | method | p_ItemCode, p_ItemData, p_UdtSchemMast, p_TotalQtyInVch, p_Pos, p_UnitName | 6 | 0 |
| `GetModifiedItemColForFreeLeastValue` | method | p_ItemData, p_itemCol, p_SMMast, p_IfItemWiseDisc | 4 | 0 |
| `FindLeastValueItemInCol` | method | p_itemCol, p_OFNo, p_ClubbedOn, p_SMDet, p_IfItemWiseDisc | 5 | 0 |
| `CalculateSMFreeQty` | method | p_ItemQty, p_SMQty, p_SMFreeQty | 3 | 0 |
| `SortNumsWithKeyCol` | method | p_Col | 1 | 0 |
| `GetModifiedItemColForFreeItem` | method | p_ItemData, p_itemCol, p_SMMast, p_IfItemWiseDisc | 4 | 0 |
| `CalculateBillAmtWithBSForSM` | method | p_BSCol, p_TotalItemAmt, p_BSPos | 3 | 0 |
| `AppendSMDiscInCompDisc` | method | p_CompDisc, p_SMDCompDisc | 2 | 0 |
| `GetVchSMBestMatchPos` | method | p_VchAmt, p_SchemDetCol | 2 | 0 |
| `GetVchClearingStatus` | method | p_udtVchData | 1 | 0 |
| `UpdateIndentRefNoInfoOfItems` | method | p_ItemsArr, p_IndentRefArr | 2 | 0 |
| `GetNumberOfDecimalPlaces` | method | p_tmpStr | 1 | 0 |
| `GetExecutiveNameFromRefNo` | method | p_RefNo | 1 | 0 |
| `GetExecutiveNameFromVchCode` | method | p_Vchcode | 1 | 0 |
| `GetTranTypeFromSeriesCode` | method | p_SeriesCode | 1 | 0 |
| `GetItemLastSPFromPurc` | method | p_ItemCode, p_MCCode, p_Date, p_MRP | 4 | 0 |
| `GetAccItemVouchersCount` | method | p_ItemCode, p_AccCode, p_VchType, p_MCCode, p_StartDate, p_EndDate, p_VchSeriesGrpCode | 7 | 0 |
| `GetSubAccVchCount` | method | p_AccCode, p_VchType, p_MCCode, p_StartDate, p_EndDate, p_VchSeriesGrpCode | 6 | 0 |
| `GetItemAccPenOrderQty` | method | p_ItemCode, p_AccCode, p_MCCode, p_VchType, p_EndDate, p_AltQty, p_Amt, p_VchSeriesGrpCode | 8 | 0 |
| `GetItemPenChallanQtywithAmt` | method | p_ItemCode, p_AccCode, p_MCCode, p_Date, p_VchType, p_QtyAlt, p_Amt, p_VchSeriesGrpCode | 8 | 0 |
| `GetAvgOutstandingPeriod` | method | p_AccCode, p_VchSeriesGrpCode, p_Type, p_StartDate, p_EndDate | 5 | 0 |
| `GetAvgOutstandingAmount` | method | p_AccCode, p_VchSeriesGrpCode, p_Type, p_StartDate, p_EndDate | 5 | 0 |
| `GetAccSalePurcAmt` | method | p_AccCode, p_VchType, p_VchSeriesGrpCode, p_StartDate, p_EndDate | 5 | 0 |
| `GetSubAccSalePurcAmt` | method | p_SLCode, p_GLCode, p_VchType, p_VchSeriesGrpCode, p_StartDate, p_EndDate | 6 | 0 |
| `GetVATAccOpBal` | method | p_Date, p_VchSerGrpCode, p_SurAmt | 3 | 0 |
| `VchConditionSatisfy` | method | p_TGudt, p_ConBlock, p_Condition, p_udtVchData, p_AddInfo, p_MsgStr, p_MainCon | 7 | 0 |
| `CopyOptionalFields` | method | p_SourceVchdata, p_TargetVchConfig, p_TargetVchOtherInfo | 3 | 0 |
| `SaveOptionalFields` | method | p_MasterName, p_Mastertype | 2 | 0 |
| `ItemDataRST2UDTNew` | method | p_rst, p_ItemNode, p_ReadSource | 3 | 0 |
| `AllocateSTAmtForGST` | method | p_ItemData, p_SurchargeApplicable | 2 | 0 |
| `CheckIfBranchWiseIsEnabledInAccEntries` | method |  | 0 | 0 |
| `UpdateRepOptForMultiFY` | method | p_Repopt, p_IfInCurFY | 2 | 0 |
| `DeleteFAQDatabase` | method | p_Calltype, p_FAQGrpCode, p_ProblemTitle, p_ErrMsg | 4 | 0 |
| `AddFAQDatabase` | method | p_udtData | 1 | 0 |
| `ModifyFAQDatabase` | method | p_OldCallType, p_OldFAQGrpCode, p_OldProblemTitle, p_udtNewData | 4 | 0 |
| `CheckIfDataExistInFAQDatabase` | method | p_Calltype, p_FAQGrpCode, p_ProblemTitle, p_udtData | 4 | 0 |
| `GetCallLastExecutive` | method | p_CallNo, p_Date, p_ForOpening | 3 | 0 |
| `GetCallLastExecutiveOnGivenDateAndVchCode` | method | p_CallNo, p_Date, p_Vchcode, p_IncludeOpening | 4 | 0 |
| `NATypeName2Code` | method | p_NAStr | 1 | 0 |
| `NATypeCode2Name` | method | p_NACode | 1 | 0 |
| `GetAccNameIfAccIsTaggedInAuthor` | method | p_AuthorCode | 1 | 0 |
| `GetAccNameIfAccIsTaggedInBroker` | method | p_BrokerCode | 1 | 0 |
| `GetMastDashBoardConfigSavingStr` | method | p_ConfigMastCol | 1 | 0 |
| `ReadMastDashBoardConfigSavedStr` | method | p_ConfigStr | 1 | 0 |
| `GetPackagingUnitStr` | method | p_ItemCode, p_BalMain, p_MainUnit, p_PackingUnit | 4 | 0 |
| `ChangeItemStockForPackingUnit` | method | p_ItemCode, p_BalMain, p_BalPacking | 3 | 0 |
| `ChangeItemStockForDualUnit` | method | p_ItemCode, p_BalMain, p_BalAlt | 3 | 0 |
| `CheckSmallUnit` | method | p_ItemCode | 1 | 0 |
| `LoadListOfVchForSplitting` | method | p_Col, p_VchType, p_VchSeriesCode, p_STPTCode, p_PartyIncode, p_MCInCode, p_StartDate, p_EndDate, p_StartVchNo, p_EndVchNo, p_OptAmount | 11 | 0 |
| `LoadItemPrintDet` | method |  | 0 | 0 |
| `GetItemDetInVchWithColumns1` | method | p_VchData, p_ItemDet, p_UsePrintName, p_UseItemEntries1 | 4 | 0 |
| `GetItemSerialNoDetInVchWithColumns` | method | p_ItemCode, p_MCCode, p_VchItemSN, p_Vchcode, p_Width, p_SerialCol | 6 | 0 |
| `GetBatchNoDetInVchWithColumns` | method | p_ItemCode, p_MCCode, p_VchItemSN, p_Vchcode, p_Width, p_BatchRefArr | 6 | 0 |
| `GetParamStockDetInVchWithColumns` | method | p_ItemCode, p_MCCode, p_VchItemSN, p_Vchcode, p_Width, p_ParamCol, p_IgrpName, p_QtyIn | 8 | 0 |
| `GetUDTPrintCol` | method | p_Fld, p_Alignment, p_Size, p_PrintHorLine, p_PrnStyle, p_ULStr, p_PrnStyle1 | 7 | 0 |
| `GetConcatenatedItemSrNoDet` | method | p_SerialCol, p_SNPrnDet | 2 | 0 |
| `GetConcatenatedBatchNoDet` | method | p_RefArr, p_BatchPrnDet, p_ItemMastData | 3 | 0 |
| `GetConcatenatedParamStockDet` | method | p_ParamCol, p_ParamPrnDet, p_QtyIn, p_ParamConfCol | 4 | 0 |
| `SaveCancelIndentEntriesInDataSync` | method | p_RecType, p_VMType, p_VchDate, p_RefNo, p_ItemCode, p_PartyCode, p_ClrDate, p_MainQty, p_AltQty, p_vchSrCode, p_BranchCode | 11 | 0 |
| `SendCancelIndentEntries2BO` | method | p_RecType, p_VMType, p_VchDate, p_RefNo, p_ItemCode, p_PartyCode, p_ClrDate, p_Qty, p_AltQty, p_vchSrCode | 10 | 0 |
| `GetPendingParamInIndentAdjItemWise` | method | p_ItemCode, p_RecType, p_VchType, p_StartDate, p_EndDate, p_RepDate, p_IncludeUnapprovedVch, p_AccCol | 8 | 0 |
| `PrintRepTitleMultiLines` | method | p_str, p_Repopt, p_RepEvents, p_Width, p_WinFonts | 5 | 0 |
| `ShowPartyDashBoardInVch` | method | ConfigCol, p_VchType, p_VchSeriesCode, p_ShowDuringDataEntry | 4 | 0 |
| `GetItemSum` | method | p_ItemDataArr, p_ItemCodes, p_ItemQtys, p_ItemAltQtys, p_ItemUDTs, p_MCCodes, p_Type, p_IsMCAtItemLevel, p_VchType | 9 | 0 |
| `LoadFAQGrpMast` | method | p_FAQGrpMast, p_strError | 2 | 0 |
| `GetLastFAQGrpCode` | method |  | 0 | 0 |
| `SaveFAQGrpMast` | method | p_InputMode, p_FAQGrpMast, p_OldFAQGrpCode, p_strError | 4 | 0 |
| `SaveDefaultFAQGrpMast` | method | p_FAQGrpMast, p_strError | 2 | 0 |
| `ListFAQGrpMast` | method | p_Mastertype | 1 | 0 |
| `FAQGrpCode2Name` | method | p_Code | 1 | 0 |
| `FAQGrpName2Code` | method | p_Name, p_Mastertype | 2 | 0 |
| `ValidateFAQGrpMast` | method | p_FAQGrpMast, p_InputMode, p_m_OldGrpName, p_ErrMsg | 4 | 0 |
| `DeleteFAQGrpMast` | method | p_Code, p_ErrMsg | 2 | 0 |
| `CanDeleteFAQGrp` | method | p_MasterCode, p_StrErr | 2 | 0 |
| `GetNextFAQGrpMaster` | method | p_Name, p_Mastertype | 2 | 0 |
| `GetPrevFAQGrpMaster` | method | p_Name, p_Mastertype | 2 | 0 |
| `GetItemCodeFromPartyItemCodeAndParty` | method | p_PartyName, p_PartyItemCode | 2 | 0 |
| `GetCallTypeFromCallNo` | method | p_CallNo, p_VchType, p_ConPartyCode | 3 | 0 |
| `GetCallSourceFromCallNo` | method | p_CallNo, p_VchType | 2 | 0 |
| `CheckIfItemEntriesExistForCRM` | method | p_Trantype | 1 | 0 |
| `GetContactColfromAccMast` | method | p_AccCode | 1 | 0 |
| `TotalCallfromContact` | method | p_ContactCode, p_BranchCode, p_StartDate, p_EndDate | 4 | 0 |
| `TotalClosedCallfromContact` | method | p_ContactCode, p_BranchCode, p_StartDate, p_EndDate, p_OnlySuccesfulCalls, p_OnlyUnsuccessfulCalls | 6 | 0 |
| `TotalAllocatedCallfromContact` | method | p_ContactCode, p_BranchCode, p_StartDate, p_EndDate, p_UnAllocated | 5 | 0 |
| `SaveVchPrintingDet` | method | p_Vchcode, p_NoOfCopies | 2 | 0 |
| `DeleteVchPrintingDet` | method | p_Vchcode | 1 | 0 |
| `DeleteAMCEntries` | method | p_Vchcode | 1 | 0 |
| `DeleteJobFinishedEntries` | method | p_Vchcode | 1 | 0 |
| `GetCountOfPrinting` | method | p_Vchcode | 1 | 0 |
| `GetVchFirstPrintDateTime` | method | p_Vchcode | 1 | 0 |
| `GetVchLastPrintDateTime` | method | p_Vchcode | 1 | 0 |
| `GetVchPrintedByUserFirst` | method | p_Vchcode | 1 | 0 |
| `GetNoOfTimesVchPrinted` | method | p_Vchcode | 1 | 0 |
| `GetVchPrintedByUserLast` | method | p_Vchcode | 1 | 0 |
| `GetAnyExecutiveForCallTypeAndArea` | method | p_Calltype, p_Area | 2 | 0 |
| `LoadWebQueryCol` | method |  | 0 | 0 |
| `SaveWebQueryName` | method | p_NewName, p_OldName, p_InputMode, p_Password | 4 | 0 |
| `WebQueryNameExist` | method | p_Name | 1 | 0 |
| `GetLastItemDescfromVch` | method | p_VchSeriesCode, p_STPTCode | 2 | 0 |
| `GetCommDesc` | method | p_MasterCode | 1 | 0 |
| `IsSpecExecutiveFoundInCall` | method | p_CallNo | 1 | 0 |
| `GetAllVchByCallNo` | method | p_CallNo | 1 | 0 |
| `GetAllPendingAMCsForOpening` | method |  | 0 | 0 |
| `UpdateAMCStatus` | method | p_AMCCol, p_status | 2 | 0 |
| `SearchFormTypeScriptFromCol` | method | p_FormType, p_ScriptCol | 2 | 0 |
| `SaveItemParamCriticalLevel` | method | p_ItemParamCriticalLevelCol, p_ItemCode, p_MCCode | 3 | 0 |
| `GetOrgFromContact` | method | p_ConCode | 1 | 0 |
| `GetOpeningCallDetails` | method | p_CallNo | 1 | 0 |
| `ReadItemParamCriticalLevel` | method | p_ItemCode, p_MCCode | 2 | 0 |
| `IfPendingAMCRefsExistForParty` | method | p_PartyCode, p_Vchcode | 2 | 0 |
| `GetAllPendingAMCRefsForParty` | method | p_PartyCode, p_Vchcode | 2 | 0 |
| `GetLikeQueryStrWithORforMemoField` | method | p_Field, p_Prefix, p_Sufix, p_SearchString, p_WithOR | 5 | 0 |
| `ConsolidateBCN` | method | p_ItemData1, p_ItemData2 | 2 | 0 |
| `ConsolidateParams` | method | p_ItemData1, p_ItemData2 | 2 | 0 |
| `ConsolidateBatch` | method | p_ItemData1, p_ItemData2 | 2 | 0 |
| `ConsolidateItemSrNo` | method | p_ItemData1, p_ItemData2 | 2 | 0 |
| `UpdateItemWiseDiscount` | method | p_ItemData, p_Discount, p_CompDisc | 3 | 0 |
| `UpdateItemWiseMarkUp` | method | p_ItemData, p_MarkUp, p_CompMarkUp | 3 | 0 |
| `InitudtVchExtraInfo` | method | p_VchExtraInfo | 1 | 0 |
| `CheckIfAnyRejectedVchExistForUser` | method | p_UserName | 1 | 0 |
| `GetConnectedContactWithParty` | method | p_PartyCode | 1 | 0 |
| `GetPartyCodeByVchCode` | method | p_Vchcode | 1 | 0 |
| `GetNotTaggedVchSeriesCol` | method |  | 0 | 0 |
| `SaveConfigDataForVchPosting` | method | p_udtData, p_RepOptions | 2 | 0 |
| `LoadConfigDataForVchPosting` | method | p_udtData, p_RepOptions | 2 | 0 |
| `GetPendingParamInIndentAdjRefCodeWise` | method | p_ItemCode, p_RecType, p_RefCode, p_VchType, p_StartDate, p_EndDate, p_RepDate, p_AccCol | 8 | 0 |
| `GetPendingParamInOrderAdjRefCodeWise` | method | p_ItemCode, p_RecType, p_RefCode, p_VchType, p_StartDate, p_EndDate, p_RepDate, p_AccCol | 8 | 0 |
| `CheckMultiStockParamEnableInItemMast` | method | p_ItemCode | 1 | 0 |
| `GetTriggerCol1` | method | p_ForApproval, p_Type, p_MasterVchtype, p_Srno | 4 | 0 |
| `SaveTriggerData1` | method | p_udttg, m_TriggerName, p_InputMode, p_ForApproval | 4 | 0 |
| `SaveMsgToMsgCentre` | method | p_udttg, p_MsgStr | 2 | 0 |
| `GetCurrentDateTime` | method | p_CurTime | 1 | 0 |
| `CreateMobNoStr` | method | p_MobNoCol, p_udtSMSInfo, p_MobNoStr | 3 | 0 |
| `IsTranExistForParamValue` | method | p_ParamVal, p_IgrpCode, p_CheckGrp, p_ParamNo | 4 | 0 |
| `IfMultiCurrencyEnableInAccMast` | method | p_AccCode | 1 | 0 |
| `InitSalesTaxInfoUDT` | method | p_SalesTaxInfo | 1 | 0 |
| `InitMultiTaxInfoUDT` | method | p_MultiTaxInfo | 1 | 0 |
| `InitSaleTypeTaxInfoUDT` | method | p_SaleTypeTaxInfo | 1 | 0 |
| `SavePIR` | method | p_RecType, p_MasterCode1, p_ParentCode, p_Col, p_VchType, p_Date, p_BranchCode | 7 | 0 |
| `LoadPIR` | method | p_RecType, p_MasterCode, p_VchType, p_Date, p_BranchCode, p_Date1, p_ItemDateWise, p_PartyCode, p_changeFinYr | 9 | 0 |
| `GetPercentOperatedOnForOtherBS` | method | p_BSData, p_udtBSData, p_No, p_OtherBSPointOfCal, p_AltCur | 5 | 0 |
| `CreateContactOptionNo2Str` | method | p_No | 1 | 0 |
| `CreateContactStr2No` | method | p_str | 1 | 0 |
| `CheckPickFromBarcodeEnableInVch` | method |  | 0 | 0 |
| `GetItemSerialDetFromChallanReversal` | method | p_NewRefCode, p_RefNoStr, p_ItemCode, p_MCCode, p_ItemSrNoCol, p_AccCode | 6 | 0 |
| `GetPenItemBatchDetFromChallanReversal` | method | p_NewRefCode, p_RefNoStr, p_ItemCode, p_MCCode, p_ItemBatchNoCol, p_AccCode | 6 | 0 |
| `GetItemSerialDetFromChallanRefs` | method | p_ItemEntries, p_ChallanRefs | 2 | 0 |
| `GetItemParamDetFromChallanReversal` | method | p_NewRefCode, p_RefNoStr, p_ItemCode, p_MCCode, p_ItemParamCol, p_AccCode | 6 | 0 |
| `GetPendingItemParamDetFromChallanReversal` | method | p_NewRefCode, p_RefNoStr, p_ItemCode, p_MCCode, p_ItemParamCol, p_AccCode | 6 | 0 |
| `GetItemParamDetFromChallanRefs` | method | p_ItemEntries, p_ChallanRefs | 2 | 0 |
| `IfUserHasRightsToCompCreation` | method | p_ServerInfo, p_DataInfo, p_IfCommandLineIsNCC, p_AskForSQLPass | 4 | 0 |
| `GetCallCategoryFromCallNo` | method | p_CallNo, p_VchType | 2 | 0 |
| `GetColSizeOfParamStkStatus` | method | p_Repopt, p_StockParamCol, p_Size | 3 | 0 |
| `GetCloseSubStatusMasterListWithType` | method | p_Type | 1 | 0 |
| `UpdateBooksStockInBalSheet` | method | p_Events, p_FinMonthNo, p_VchSeriesGrpCode, p_BranchCode, p_DontUseStockAlpha, p_StockVal | 6 | 0 |
| `GetSBCValues` | method | p_udtData, p_Percent, p_Amt | 3 | 0 |
| `ActionUDT2Str` | method | p_ActionUdt | 1 | 0 |
| `Str2ActionUDT` | method | p_str | 1 | 0 |
| `ReadCustomIndexStr` | method | p_FilterStr | 1 | 0 |
| `LoadCustomIndexesConfig` | method |  | 0 | 0 |
| `CheckForUnApprovedRecType` | method | p_Vchcode | 1 | 0 |
| `GetItemFilterVal4TaggedParty` | method | p_PartyCode | 1 | 0 |
| `GetAllDosPrinters` | method |  | 0 | 0 |
| `MatchDataPth` | method | p_DataPath | 1 | 0 |
| `InterChangeDiscountAndMarkupVariable` | method | p_Discount, p_DiscAmt, p_CompoundDisc | 3 | 0 |
| `StatePDCode2TinNoDigit` | method | p_StateCode, p_ExtraTinNoDigit | 2 | 0 |
| `GetBillRefDet` | method | p_SplitFlag, p_ItemPrintdet, p_UdtReference, p_RefStr, p_Flag | 5 | 0 |
| `GetBillRefNarLines` | method | p_Col, p_BillRefCol, p_MaxChar, p_OffSet, p_Flag | 5 | 0 |
| `CheckIfMainPricesFoundInItemMast` | method | p_CheckMainPrices, p_VchType, p_ItemMast | 3 | 0 |
| `GetSilentConfig` | method | p_VchType | 1 | 0 |
| `UpdateSilentConfig` | method | p_SilentConfig | 1 | 0 |
| `GetCaptionForCommCode` | method | p_CommCodeStr, p_SubCommCodeStr | 2 | 0 |
| `GetPendingJobRefsFromChallanRefs` | method | p_ItemEntries, p_ChallanRefs | 2 | 0 |
| `SaveJobFinishedRefsForVchCode` | method | p_Vchcode, p_RecIssuableJobRefs, p_PartyCodeForOpening, p_RecType | 4 | 0 |
| `LoadJobFinishedRefs` | method | p_Vchcode, p_PartyCodeForOpening, p_RecType | 3 | 0 |
| `GetAllBatchNoForItem` | method | p_ItemCode | 1 | 0 |
| `ExportXMLData` | method | p_Vchcode, p_FileName, p_Appending | 3 | 0 |
| `GetNodeAsPerVchType` | method | p_VchType, p_Doc | 2 | 0 |
| `UpdateBranchMastForConfigChanged` | method | p_CompConfigUpdated | 1 | 0 |
| `UpdateBranchMastForConfigChangedFromVchConfig` | method | p_VchConfigChanged, p_VchSeriesCode, p_VchType | 3 | 0 |
| `DeleteParamStockDetailsForJobWork` | method | p_ItemCode, p_MCCode, p_Vchcode, p_VchItemSN, p_ItemSNInJobWork, p_Srno, p_RecType, p_DeleteAdjustments | 8 | 0 |
| `GetTCSPendingRef` | method | p_TCSCatCode, p_TCSSubCatCode, p_VchDate | 3 | 0 |
| `SaveParamStockDetailsForOpeningJobWork` | method | p_ItemCode, p_PartyCode, p_JobID, p_ParamStockCol, p_RecType | 5 | 0 |
| `UpdatePIRValues` | method | p_VchType, p_Date, p_udtItemdata, p_udtVchConfig, p_AccCode, p_UpdatePrice, p_Price, p_TranCurSymbol, p_CheckBranch, p_DiscountChanged, p_MarkUpChanged, p_MRPChanged | 12 | 0 |
| `SavePIRValuesUserLog` | method | p_VoucherType, p_BranchCode, p_UpdatePrice, p_DiscountChanged, p_MarkUpChanged, p_OldPrice, p_NewPrice, p_OldDiscountPerc, p_NewDiscountPerc, p_OldMarkupPerc, p_NewMarkupPerc, p_AccCode, p_ItemCode | 13 | 0 |
| `GetPIRConfigValues` | method | p_VchType, p_Date, p_ItemData, p_Trantype, p_AccCode, p_udtVchConfig, p_CheckBranch | 7 | 0 |
| `CheckAnyFinishedItemToBePendingToParty` | method | p_PartyCode, p_Date, p_RecType | 3 | 0 |
| `GetAnyFinishedJobIDPendToParty` | method | p_PartyCode, p_Date, p_RecType, p_DateCol | 4 | 0 |
| `GetAnyFinishedItemsPendToPartyWithJobID` | method | p_PartyCode, p_Date, p_RecType, p_JobID | 4 | 0 |
| `IfNewTCSRefAdjudted` | method | p_RefCode | 1 | 0 |
| `CheckIfPartyCreditLimitCrossed` | method | p_udtVchData | 1 | 0 |
| `GetItemDateWiseDet` | method | p_ItemCode, p_StartDate, p_EndDate | 3 | 0 |
| `GetParamClStkForStkLedger` | method | p_ItemCode, p_MCCode, p_VchDate, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_MRP, p_SalesPrice, p_Vchcode, p_Checked, p_AltQty, p_ConFactor | 14 | 0 |
| `LoadPaymentGatewayConfig` | method | p_RecType, p_PaymentType, p_Col, p_RequestType, p_VchSeriesCode, p_VchType | 6 | 0 |
| `RefreshBusyAdditionalObjects` | method |  | 0 | 0 |
| `PrintCompNameForRemLetter` | method | p_RepEvents, p_FormatName, p_RepID, p_WinFonts, p_ExtraInfo, p_AccCode, p_SetAndPrintAccImgIfExist, p_PartyImgPath | 8 | 0 |
| `GetCompoundDiscStrWithBasis` | method | p_CompDiscStr, p_udtStructure, p_AltUnit, p_MainUnit | 4 | 0 |
| `SPFromPPBasis2Name` | method | p_Basis | 1 | 0 |
| `SPFromPPName2Basis` | method | p_Name | 1 | 0 |
| `SaveVoucherSeriesGrp` | method | p_Grp | 1 | 0 |
| `CopySeriesConfig` | method | p_VchType, p_CopyFrom, p_Code, p_SeriesStr | 4 | 0 |
| `SaveVchSeriesIfNotExistDuringImport` | method | p_VchSeriesName, p_VchType, p_InvalidMsg | 3 | 0 |
| `SaveVchConfigurationDuringImport` | method | p_VchConfig, p_InvalidMsg | 2 | 0 |
| `UpdateVchGSTSum` | method | p_VchData, p_STPTMast | 2 | 0 |
| `GetGSTTaxAccOpBals` | method | p_Date, p_VchSerGrpCode, p_CGSTAmt, p_SGSTAmt, p_IGSTAmt, p_CessAmt | 6 | 0 |
| `GetBSNaturefromName` | method | p_BSName | 1 | 0 |
| `SaveItemMastForImportSingleVch` | method | p_UdtGen, p_ErrStr | 2 | 0 |
| `SaveItemMast4UpdateSPFromPP` | method | p_udtData, p_ErrStr | 2 | 0 |
| `GetLastPaymentAccCode4GSTPayment` | method | p_AccName, p_VchSeriesCode | 2 | 0 |
| `IsTin_GSTAlreadyExist` | method | p_Tin, p_PartyName, p_GSTIN, p_Code | 4 | 0 |
| `IsAadhaarNoAlreadyExist` | method | p_AadhaarNo, p_PartyName, p_Code | 3 | 0 |
| `GetConcatinatedItemGroupWiseSumDet` | method | p_itemCol | 1 | 0 |
| `StockParamValExistsInConfig` | method | p_ItemGrpCode, p_Index, p_ParamVal, p_ParamAlias, p_ParamCol | 5 | 0 |
| `DrCrAmtIn1DayWithCash` | method | p_PartyCode, p_Date, p_AmtType, p_Vchcode, p_PartyAmt | 5 | 0 |
| `LoadBCNAutoStructConfig` | method | p_StructName | 1 | 0 |
| `GetAllBCNAutoStructureFormats` | method |  | 0 | 0 |
| `GetTaxRatesInfo4VATGSTIndia` | method | p_TaxCatCode, p_VATGSTtype, p_udtTaxInfo, p_BranchCode | 4 | 0 |
| `GetConfigDetforTaxCategoryINDIA` | method | p_BranchCode, p_VATGSTtype, p_LocalSchgApplicable, p_CentralSchgApplicable, p_EntryTaxApplicable, p_StateCode | 6 | 0 |
| `RemoveUnitsFromPackingQty` | method | p_PackingQty, p_Value1, p_Value2, p_PackingUnit, p_MainUnit | 5 | 0 |
| `UpdateReturnFiledStatusTillDate` | method | p_EndDate | 1 | 0 |
| `UpdateVchReturnStatus` | method | p_Vchcode, p_status | 2 | 0 |
| `UpdateVchReturnAnnualStatus` | method | p_Vchcode, p_status | 2 | 0 |
| `GetVchReturnStatus` | method | p_Vchcode | 1 | 0 |
| `ConsiderInvoiceAsAmended` | method | p_VchData, p_NewVchData | 2 | 0 |
| `CheckVoucherTaxType` | method | p_Vchcode | 1 | 0 |
| `GetItemTaxRates` | method | p_ItemCode, p_VchDate, p_LocType, p_surcharge, p_TaxRate, p_TaxRate1, p_VATGSTtype, p_CessBasis, p_ACessBasis, p_ACess | 10 | 0 |
| `InitUdtGSTDet` | method | p_GSTJV | 1 | 0 |
| `UpdateDiscAmtColForDiscountMarkupForParam` | method | p_RecType, p_ParamData, p_DiscStructure, p_Row, p_ApplyPriceOnAlt, p_ItemData, p_DiscountedAmt | 7 | 0 |
| `GetSimpleDiscFromCompoundDiscountForParam` | method | p_RecType, p_ParamData, p_Row, p_DiscStructure, p_ApplyPriceOnAlt, p_ItemData, p_TotalDiscPerUnit | 7 | 0 |
| `UpdateFlagToShowStepsToGST` | method | p_Val | 1 | 0 |
| `GetItemTaxDetails` | method | p_GrpCode, p_HSNCode | 2 | 0 |
| `GetBSNameFromSpecificBSNature` | method | p_BSNature, p_BSCode | 2 | 0 |
| `GetAnyBSNameFromSpecificBSNature` | method | p_BSNature, p_BSCode | 2 | 0 |
| `IntelligenceForTaxBS` | method | p_BSData | 1 | 0 |
| `CheckIfCessValueExists` | method | p_VchGSTSum | 1 | 0 |
| `CheckIfAddCessValueExists` | method | p_VchGSTSum | 1 | 0 |
| `CheckIfStateCessValueExists` | method | p_VchGSTSum | 1 | 0 |
| `FilterTaxSummaryColForSlipFormat` | method | p_ColTaxSummary, p_FldWidth, p_MaxFldSize | 3 | 0 |
| `GetTaxSummaryDetColForAccVch` | method | p_VchGSTSum, p_VchType, p_IncludeHSNCode, p_IncludeUnit | 4 | 0 |
| `CheckIfSurchargeEnableInVAT` | method |  | 0 | 0 |
| `CreateGSTTaxCategory` | method | p_VATRate, p_VATSurChrg, p_GSTRate, p_GSTCess | 4 | 0 |
| `CheckIfTaxCategoryAlreadyExist` | method | p_GSTRate, p_VATRate | 2 | 0 |
| `GetVchState4POS` | method | p_PartyCode, p_Vchcode, p_StateName, p_StateCode, p_GSTIN, p_BillingGSTRepBasis | 6 | 0 |
| `GetVatGstRectypeQryStr` | method | p_SkipOperator, p_AliasStr | 2 | 0 |
| `GetGSTINForPartyCode` | method | p_PartyCode, p_Vchcode, p_RepBasis | 3 | 0 |
| `GetTypeOfDealerGSTforPartyCode` | method | p_PartyCode | 1 | 0 |
| `GetPurcAcc4Vch` | method | p_ItemSrNo, p_Vchcode, p_Value | 3 | 0 |
| `GetDrAccDet` | method | p_DrAccCode, p_TaxCatCode, p_InputType | 3 | 0 |
| `GetCrAccParty` | method | p_Vchcode | 1 | 0 |
| `GetTaxRate` | method | p_TaxCatCode, p_TaxRate1, p_TaxRate2, p_CessRate, p_LocalRate, p_TaxType | 6 | 0 |
| `SaveConfigDataForAdvanceVchPosting` | method | p_udtData, p_RepOptions, p_RecType | 3 | 0 |
| `LoadConfigDataForAdvanceVchPosting` | method | p_udtData, p_RepOptions, p_RecType | 3 | 0 |
| `GetGSTNatureListCol` | method | p_VchType | 1 | 0 |
| `GetGSTNatureListColForUAE` | method | p_VchType | 1 | 0 |
| `UpdateVATGSTSTPTIfTaxTypeInterChanged` | method | p_UpdatedSuccessfully | 1 | 0 |
| `CheckVaTGSTTypeMisMatchForF11` | method | p_CurVatGSTType, p_VchCodes | 2 | 0 |
| `UpdateTypeOfDealerInVchGST` | method | p_PartyCode, p_TypeofDealer | 2 | 0 |
| `GetLastBilledPartyNameOfPartyMaster` | method | p_PartyCode | 1 | 0 |
| `GetCriticalLevelItemCol` | method | p_Repopt, p_Col1, p_Col2 | 3 | 0 |
| `GetBulkVchFromGridFormatNamesList` | method | p_RepID | 1 | 0 |
| `BulkVchFromGridFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `GetAllBulkVchFromGridFormats` | method | p_PRID | 1 | 0 |
| `DeleteBulkVchFromGridFormat` | method | p_FormatName, p_PRID | 2 | 0 |
| `LoadBulkVchFromGridFormatConfig` | method | p_FormatName, p_RepID | 2 | 0 |
| `CopyBulkVchFromGridFormat2Disk` | method | p_RepID, p_FormatName, p_strError | 3 | 0 |
| `CopyBulkVchFromGridFormatFromDisk` | method | p_FormatName, p_RepID, p_Lines | 3 | 0 |
| `SaveBulkVchFromGridFormatName` | method | p_FormatName, p_PRID | 2 | 0 |
| `SaveBulkVchFromGridKeyField` | method | p_FormatName, p_PRID, p_UdtGen | 3 | 0 |
| `SaveBulkVchFromGridFormatConfig` | method | p_FormatName, p_PRID, p_Col | 3 | 0 |
| `GetPartyCountryCode` | method | p_PartyCode | 1 | 0 |
| `LoadBulkVchFromGridKeyField` | method | p_FormatName, p_RepID | 2 | 0 |
| `DocumentSummaryDet` | method | p_StartDate, p_EndDate, p_VchSeriesGrpCode | 3 | 0 |
| `CheckIfAddCessApplicable` | method | p_VchData | 1 | 0 |
| `CheckIfStateCessApplicable` | method | p_VchData | 1 | 0 |
| `GetVchCodeColForBulkInvModification` | method | p_VchType, p_VchSeriesCode, p_StartDate, p_EndDate | 4 | 0 |
| `SaveQueryLOG` | method | p_Qry, p_RecType, p_ErrStr | 3 | 0 |
| `UpdateStatusOfGSTR2` | method | p_status, p_CheckSum, p_Vchcode | 3 | 0 |
| `UpdatePurcBillNoFromSupplierData` | method | p_Vchcode, p_VchNo | 2 | 0 |
| `UpdatePurcBillDateFromSupplierData` | method | p_Vchcode, p_VchDate | 2 | 0 |
| `GetGSTR2StatusFromVchCode` | method | p_Vchcode | 1 | 0 |
| `GetZeroTaxTypeforItem` | method | p_Fld, p_Exempted, p_TaxFree, p_Ureg, p_Lumpsum, p_NilRated, p_TaxPaid | 7 | 0 |
| `GetSecondLangNumericStrFromDicSL` | method | p_str | 1 | 0 |
| `GetSecondLangStrFromDictionarySL` | method | p_str | 1 | 0 |
| `UpdateSLFieldsForMaster` | method | p_Code, p_SLData | 2 | 0 |
| `UpdateSLFieldsForCompany` | method | p_SLData | 1 | 0 |
| `SaveDictionarySL` | method | p_GenCol, p_LangName, p_ImportDataXML | 3 | 0 |
| `GetSLDataOfParty` | method | p_PartyCode | 1 | 0 |
| `GetBSEntriesInLastVchFromSTPT` | method | p_VchType, p_STPT | 2 | 0 |
| `GetBSEntriesForApplyTaxForMultiRate` | method | p_ItemData, p_STPTMast, p_VchType, p_ErrMsg, p_StateCessToBeApplied | 5 | 0 |
| `SearchFromBSCol` | method | p_Rate, p_BSEntries, p_BSType | 3 | 0 |
| `GetTaxBSCol` | method | p_Type, p_IncludeCess, p_IncludeStateCess | 3 | 0 |
| `LoadDictionarySL` | method | p_LangName | 1 | 0 |
| `UpdateSLFieldsForBilingDet` | method | p_Code, p_SLData | 2 | 0 |
| `UpdateSLFieldsForItemDesc` | method | p_Code, p_Srno, p_SLData | 3 | 0 |
| `ConvertAmtInWordsInToSecondLang` | method | p_Val | 1 | 0 |
| `GetDefaultPrinterName` | method |  | 0 | 0 |
| `GetFromPlacePINFromMCMast` | method | p_MCCode, p_FromPlace, p_FromPIN | 3 | 0 |
| `GetAddrDetFromMCMast` | method | p_MCCode | 1 | 0 |
| `LoadDefaultDictionarySL` | method | p_LangName | 1 | 0 |
| `SaveDefaultDictionarySL` | method | p_GenCol, p_LangName | 2 | 0 |
| `DoBlankItemAlias` | method | p_strAlias | 1 | 0 |
| `GetGSTInValidatedDate` | method | p_GSTIN, p_StatusStr, p_status, p_Type | 4 | 0 |
| `GetLastTransportDetOfPartyMaster` | method | p_PartyCode, p_Vchcode, p_Date | 3 | 0 |
| `GetLastVchDet4GenEWBEInv` | method | p_Vchcode, p_Date | 2 | 0 |
| `CheckNumericInStr` | method | p_str, p_NumericRequired | 2 | 0 |
| `GetDrCrNoteSectionfromVoucher` | method | p_VchNo, p_VchDate, p_VchType | 3 | 0 |
| `GetTypeOfDealerforPartyCode` | method | p_PartyCode | 1 | 0 |
| `GetAccUnclearedEntries` | method | p_AccCode, p_EndDate | 2 | 0 |
| `GetFYStr` | method | p_Date | 1 | 0 |
| `GetFYStrForYYMMDD` | method | p_Date | 1 | 0 |
| `GetFYStrWithoutCaption` | method | p_Date | 1 | 0 |
| `GetFYStrInYYMMDDWithoutCaption` | method | p_Date | 1 | 0 |
| `GetParamColForGroup` | method | p_GrpCode, p_SeperateParamForGroup | 2 | 0 |
| `IntelligenceForTaxTypeAcc` | method | p_AccData | 1 | 0 |
| `CheckIfBatchExist` | method | p_ItemCode, p_RefCol, p_Vchcode | 3 | 0 |
| `GetDbConFromDate` | method | p_VchDate, p_db, p_Con | 3 | 0 |
| `GetPartialInvVchDataFromOtherFinYear` | method | p_Vchcode, p_db, p_Con | 3 | 0 |
| `CheckIfDiscMarkupEnableInOtherFY` | method | p_Date, p_Disc, p_Mkp | 3 | 0 |
| `GetPartialAccVchDataFromOtherFinYear` | method | p_Vchcode, p_db, p_Con | 3 | 0 |
| `UpdateBDEPDemoCtr` | method |  | 0 | 0 |
| `CheckForBDEPDemoMode` | method | p_ErrMsg | 1 | 0 |
| `GetBDEPIDForAccMast` | method | p_AccName | 1 | 0 |
| `PurchaseVchnoExistInB2b` | method | p_VSName, p_PartyCode, p_VchNo, p_HSNCode, p_UnitName, p_Date1 | 6 | 0 |
| `GenEWayBillJSON4API` | method | p_Vchcode, p_VchNo, p_EWayBillReq, p_EWayBillNo, p_VchSeries, p_VchDate, p_EWBInVchSeries, p_EWayBillGenDate, p_STPTMast, p_Form, p_AskForPrinting, p_ServerGenEWBDate | 12 | 0 |
| `ChangeSTPTTaxTypeForcefully` | method | p_STPTCode, p_Mastertype, p_TaxType | 3 | 0 |
| `GetJSONFromRecordset` | method | p_Qry, p_ErrStr | 2 | 0 |
| `LoadBDEPTranListFromXML` | method | p_XMLStr | 1 | 0 |
| `LoadBDEPPDFListFromXML` | method | p_XMLStr | 1 | 0 |
| `LoadBDEPListFromXML` | method | p_XMLStr | 1 | 0 |
| `LoadBDEPIDDeleteSummFromXML` | method | p_XMLStr | 1 | 0 |
| `BDEPID2MasterCode` | method | p_BDEPID | 1 | 0 |
| `UpdateBDEPIDInAccMast` | method | p_Code, p_BDEPID, p_udtBDEP, p_UpdateOnlyBdepID | 4 | 0 |
| `UserHasAccessToMobileApp` | method | p_UserName | 1 | 0 |
| `GetCustomerMargin` | method | p_Code | 1 | 0 |
| `UpdateBDEPInUserProfile` | method | p_UserName, p_BDEPVal | 2 | 0 |
| `GetItemStockStatusJSON` | method | p_ICol, p_Err, p_ChkUserRights | 3 | 0 |
| `GetRecordset2JSONStr` | method | p_rst, p_MaxEntries | 2 | 0 |
| `GetBillRecPayJSON` | method | p_ICol, p_Err, p_PartialData, p_PartialStartDate, p_ChkUserRights, p_ChkPartyMode | 6 | 0 |
| `GetVchDataJSON` | method | p_Vchcode, p_Err | 2 | 0 |
| `GetMasterRightsColForMobileUser` | method | p_udtMobileUser, p_Mastertype | 2 | 0 |
| `ChkMobileUserRightsForReports` | method | p_UserName, p_RepID, p_MasterRange, p_MastName, p_AmtType, p_OCol, p_ErrStr | 7 | 0 |
| `CheckUserRightsForReports` | method | p_UserName, p_RepID, p_BranchCode, p_VchSeriesGrpCode, p_masterSeriesGrpCode, p_MastName, p_ErrStr | 7 | 0 |
| `GetAccLedgerJSON` | method | p_ICol, p_Err, p_OpBal, p_PartialData, p_PartialStartDate, p_ChkUserRights, p_ChkPartyMode | 7 | 0 |
| `GetAccDayBookJSON` | method | p_ICol, p_Err, p_PartialData, p_PartialStartDate | 4 | 0 |
| `GetDetsFromMasterAddInfo` | method | p_ConCode | 1 | 0 |
| `ValidUserNamePasswrdForParty` | method | p_UserName, p_Password, p_OCol, p_ErrMsg, p_IfChangePasswrd | 5 | 0 |
| `UpdatePasswordForParty` | method | p_PartyCode, p_NewPwd, p_RecheckPwd, p_ErrMsg | 4 | 0 |
| `UpdateCompNameInLocks` | method |  | 0 | 0 |
| `GetAccSubLedgerJSON` | method | p_ICol, p_Err, p_OpBal, p_PartialData, p_PartialStartDate, p_ChkUserRights, p_ChkPartyMode | 7 | 0 |
| `ShowNoInternetCommandLineMsg` | method |  | 0 | 0 |
| `GetMasterSeriesGrpCodeOfUser` | method | p_UserName | 1 | 0 |
| `LoadDefaultTaxSummaryConfig` | method |  | 0 | 0 |
| `GetMaxFieldWidthForConfigurableTaxSummary` | method |  | 0 | 0 |
| `GetBusyDefaultLoginDet` | method | p_Password | 1 | 0 |
| `CheckIfLoginDetRequired` | method | p_UserName | 1 | 0 |
| `GetCompBegFYFromDatabase` | method | p_CompCode, p_DateType, p_UserName, p_Password, p_Provider, p_DataPath, p_ServerName, p_UID, p_Pwd | 9 | 0 |
| `CheckIfLoginDetRequiredFromDatabase` | method | p_CompCode, p_UserName, p_Password, p_Provider, p_DataPath, p_ServerName, p_UID, p_Pwd | 8 | 0 |
| `UpgradeMobileUserPref` | method | p_ExistingFinYr, p_SwitchingfinYrs, p_NewFinYr | 3 | 0 |
| `GetMasterCountForUserJSON` | method | p_UserID, p_UserName, p_Mastertype, p_Err, p_TotalPageToShow, p_MasterCountCol, p_SlotCount | 7 | 0 |
| `GetImportMasterForUserJSONChunkWise` | method | p_UserID, p_UserName, p_CurPageNo, p_TotalPages, p_MasterCount, p_Mastertype, p_Err, p_ForOneMaster, p_MasterCode, p_SlotCount | 10 | 0 |
| `CheckForUpdateMasterBalForStockVal` | method |  | 0 | 0 |
| `SaveParamStockDetailsForConsignmentOpening` | method | p_ItemCode, p_Vchcode, p_VchItemSN, p_ParamStockCol, p_InputMode, p_OldCol, p_RecType, p_ConId | 8 | 0 |
| `SaveConsignmentOpening` | method | p_ConRecIssuableCol, p_PartyCodeForOpening, p_RecType | 3 | 0 |
| `GetMastersColUsedInVchForBDEP` | method | p_Vchcode | 1 | 0 |
| `CheckConnectedMastersInVchForBDEP` | method | p_Vchcode, p_MastersCount | 2 | 0 |
| `CheckConnectedMastersInDrCrNoteForBDEP` | method | p_Vchcode, p_MastersCount | 2 | 0 |
| `SaveVchFromJson` | method | p_VchType, p_JSONStr, p_ErrStr, p_Vchcode, p_ChkIfMobileUser, p_UserName, p_CSUserCol, p_SavedAsCancelled, p_ErrCode | 9 | 0 |
| `SaveVchFromJsonForOldMobileApp` | method | p_VchType, p_JSONStr, p_ErrStr, p_Vchcode, p_ChkIfMobileUser, p_UserName, p_CSUserCol, p_SavedAsCancelled | 8 | 0 |
| `GetJSON2BillRefs` | method | p_JSON | 1 | 0 |
| `GetJSON2ItemEntries` | method | p_JSON, p_VchType, p_IsCSUser | 3 | 0 |
| `GetDateFromUnivFormatDateStr` | method | p_DateStr | 1 | 0 |
| `GetJSON2VchData` | method | p_JSONStr, p_ErrStr, p_IsCSUser | 3 | 0 |
| `GetMasterClosingBals` | method | p_Mastertype, p_MasterCode, p_Date, p_AltBal, p_MCCode, p_Vchcode | 6 | 0 |
| `GetAllChildArrForUserJSON` | method | p_UserName, p_IsMobileUser, p_ParentGrpCode, p_ChildMasterType, p_Err | 5 | 0 |
| `GetPartyOtherDetJSON` | method | p_PartyCode, p_ErrStr | 2 | 0 |
| `GetSourceStr` | method | p_Source | 1 | 0 |
| `UpdateTaxSummaryFlagInVchConfig` | method | p_TaxSummVal, p_VSCode | 2 | 0 |
| `CheckIfStateCessToBeApplied4Kerala` | method | p_AccTypeofDealer, p_BillingDet, p_LocType, p_VchType, p_Trantype | 5 | 0 |
| `SaveCanceledParamRef` | method | p_ParamRefData | 1 | 0 |
| `GetCanceledParamRefDetails` | method | p_Vchcode, p_VchItemSrNo, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_MRP | 8 | 0 |
| `GetParamRefDets` | method | p_Vchcode, p_VchItemSrNo, p_Param1, p_Param2, p_Param3, p_Param4, p_Param5, p_RecType, p_MRP | 9 | 0 |
| `GetITCPendingVchDet4PrevYear` | method | p_RefNo, p_AccCode | 2 | 0 |
| `GetITCPendingVchDet` | method | p_VCodeApp4GSTR2A | 1 | 0 |
| `GetWebServiceURLForBWS` | method |  | 0 | 0 |
| `SaveReportUsageDet` | method | p_ProductName, p_ReportName, p_EndDate, p_ReportFormat, p_EntryDate, p_GSP | 6 | 0 |
| `GetReportUsageDetKeyStr` | method | p_Product, p_GSTIN, p_ReportFormat, p_EndDate, p_ReportName | 5 | 0 |
| `ChkHSNCodethroughWebPortal` | method | p_HSNCode, p_ResponseStr | 2 | 0 |
| `GetLastApprovalReason` | method | p_Code, p_Repopt, p_ApprovalType | 3 | 0 |
| `UpdateAmtInItemEntriesForMobileApp` | method | p_ItemEntries, p_STPTMast, p_ChkIfStateCessApplicableInVch | 3 | 0 |
| `LoadDigitalSignConfig` | method | p_VendorID, p_DSCName, p_DSCSrNo, p_Password, p_SearchStr | 5 | 0 |
| `GenerateTextForInvoice` | method | p_Repopt, p_RepID, p_AccVch, p_AccVchSrNo | 4 | 0 |
| `PrintQRCode` | method | p_Repopt, p_QRCodeType, p_QRCodeVal, p_Vchcode, p_FileName, p_RepID, p_AccVch | 7 | 0 |
| `GenerateQRCode` | method | p_FileName, p_TextStr | 2 | 0 |
| `GSTINValidation4GovtParty` | method | p_GSTIN, p_StateCode, Msg | 3 | 0 |
| `RestoreCustomFormat` | method | p_RecType, p_FilePath, p_ErrStr, p_OverwritePwd | 4 | 0 |
| `GetReportNotesForCurFY` | method | p_AccCode | 1 | 0 |
| `UpdateReportNotesForLastFY` | method | p_AccCode, p_PrevYrRepNotesCol | 2 | 0 |
| `GetNewReportNoteID` | method |  | 0 | 0 |
| `IfBlankBillingDet` | method | p_BillingDet | 1 | 0 |
| `GetWhatsAppNoFromMobileNo` | method | p_MobileNo, p_CountryCode | 2 | 0 |
| `GetBillSummaryJSON` | method | p_ICol, p_Err, p_ChkUserRights | 3 | 0 |
| `GetFinYrStrForYear` | method | p_Year | 1 | 0 |
| `UpdateEInvoiceSignedInvoiceField` | method | p_SignedInv, p_Vchcode | 2 | 0 |
| `NotifyEventForMaster` | method | p_InputMode, p_MastType, p_udtMast, p_OldMast, p_Delete, p_EventMastOrVch, p_ModifyMastVch | 7 | 0 |
| `UpdateVoucherApprovalDetails1` | method | p_VchcodeCol, p_VchTypeCol, p_Proceed, ApprovalStatus, p_ApprovalReason, p_ApprovalDetails | 6 | 1 |
| `GetTaxableAmt1` | method | p_BSNo, p_BSEntries, p_VchType, p_STPTMast, p_ItemEntries, p_TotalItemAmt, p_AltCur | 7 | 0 |
| `MobileUserNameExists` | method | p_UserName | 1 | 0 |
| `CloudUserNameExists` | method | p_UserName | 1 | 0 |
| `CancelSaudiEInvVch` | method | p_udt, p_Proceed | 2 | 0 |
| `UpdateSkipEventNotificationFlag` | method | p_Skip | 1 | 0 |
| `ChkIfVchCanBeModifyDeleteIfEInvEWBGen` | method | p_udtVchData, p_Modify, p_VchDetail | 3 | 0 |
| `GetStateXMLForPOSConfig` | method | p_SeriesCode, p_VchType | 2 | 0 |
| `GetTransportDetPlacePincodeForVchCode` | method | p_Vchcode, p_Place, p_PinCode | 3 | 0 |
| `RefreshSQLConnection` | method |  | 0 | 0 |
| `SaveVchMastDataForCloudSync` | method | p_Type, p_VchMastType, p_VchMastCode, p_InputMode, p_DeleteVch, p_XMLStr, p_ErrMsg, p_FormatType, p_Desc, p_RequiredLock | 10 | 0 |
| `SaveActionData` | method | p_ActionDoneType, p_ActionDone | 2 | 0 |
| `GetActionDoneData` | method | p_ActionType | 1 | 0 |
| `CheckIfBulkUploadCompleted` | method |  | 0 | 0 |
| `GetBranchGSTDet` | method | p_TotGSTIN | 1 | 0 |
| `UpdateMasterReference` | method | Doc, Node, p_ParentNodeStr, p_RefNodeStr, p_Code, p_RecType, p_Acc | 7 | 0 |
| `AddMastCode2CSXml` | method | p_XMLStr, p_Mastertype, p_Code | 3 | 0 |
| `UpdateVchReference` | method | p_udtVchData, p_RecType | 2 | 0 |
| `UpdateVchReference4AccEntry` | method | p_udtVchData | 1 | 0 |
| `CancelEWayEInvoice` | method | p_udtVchData, Proceed | 2 | 0 |
| `CopyImportVchFromExcelFormat2Disk` | method | p_RepID, p_FormatName, p_strError | 3 | 0 |
| `LoadVATInfo` | method | p_Vchcode | 1 | 0 |
| `LoadVATInfoFromRst` | method | p_rst, p_VatNode, p_ReadSource, p_TableAlias | 4 | 0 |
| `LoadVATJV` | method | p_VchDate, p_VATJVITCol, p_VATJVOTCol, p_RefundJV, p_VATJVCrNoteCol, p_VATJVDrNoteCol | 6 | 0 |
| `LoadVATJVRefundDet` | method | p_StartDate, p_EndDate | 2 | 0 |
| `LoadVchSeriesGrpConfig` | method | p_VchSerGrpConfig | 1 | 0 |
| `LoadGSTInfo` | method | p_Vchcode | 1 | 0 |
| `LoadGSTInfoFromRst` | method | p_rst, p_VatNode, p_ReadSource, p_TableAlias | 4 | 0 |
| `InitUdtGSTJV` | method | p_GSTJV | 1 | 0 |
| `LoadExternalData` | method | p_KeyType, p_KeyCode | 2 | 0 |
| `LoadExternalDataFromRst` | method | p_rst, p_ExtNode, p_ReadSource, p_TableAlias | 4 | 0 |
| `RefineQueryForPGSql` | method | p_Qry | 1 | 0 |
| `CreateTextFileFromRecordset` | method | p_StrQry, p_TableName, p_Path, p_ErrMsg, p_FY | 5 | 0 |
| `RefineQueryForMySql` | method | p_Qry | 1 | 0 |
| `GetServerDateTime` | method |  | 0 | 0 |
| `GetJSON2FilterList` | method | p_JSONStr, p_ErrStr, p_str | 3 | 0 |
| `GetJsonStrFromUDTStdConfig` | method | p_RepID, p_FormatName, p_StdDoc | 3 | 0 |
| `GetFreeQtyForLastSalesPurc` | method | p_Vchcode, p_Srno | 2 | 0 |
| `GetJSONPinCodeDetails` | method | p_JSONStr, p_ErrStr | 2 | 0 |
| `IfAuditTrailDetailedEntryExists` | method |  | 0 | 0 |
| `ChkIfItemStkBalIsMaintained` | method | p_ItemCode | 1 | 0 |
| `IfRepFilePathBelongsToERetInBONL` | method | p_Repopt, p_OptionsCol | 2 | 0 |
| `GetAccessTokenForGoogleDrive` | method |  | 0 | 0 |
| `GetAllItemBatchAutoNumFormats` | method |  | 0 | 0 |
| `IsItemBatchAutoNumStructureExists` | method | p_StructName | 1 | 0 |
| `UpdateItemBatchAutoNumStructure` | method | p_OldName, p_NewName | 2 | 0 |
| `DeleteItemBatchAutoNumStructure` | method | p_StructName | 1 | 0 |
| `SaveItemBatchAutoNumConfig` | method | p_ItemBatchNumConfig | 1 | 0 |
| `LoadItemBatchAutoNumConfig` | method | p_StructName | 1 | 0 |
| `IsStructureExistInItemMasterForBatch` | method | p_Structure | 1 | 0 |
| `ApplyBrokerInVoucher` | method | p_udtVchData, p_VchType | 2 | 0 |
| `CheckCompoundDiscInBasicEdition` | method | p_StructName, p_DSMast | 2 | 0 |
| `GetSoftlockLicenseDet4GWS` | method | p_OCol | 1 | 0 |
| `GetDrCrBalFromTrialBalCSR` | method | p_Date, p_OpTrial, p_BranchCode, p_VSGrpCode, p_DrBal, p_CrBal | 6 | 0 |
| `GetYearFromVchDate` | method | p_VchDate, p_Year | 2 | 0 |
| `DeleteAccountMappingForFeedBankStatement` | method | p_SRInfo | 1 | 0 |
| `CreateDefaultBankStatementFormats` | method |  | 0 | 0 |
| `CreateDefaultBankStatementFormats1` | method |  | 0 | 0 |
| `CreateBankFormat` | method | BankName | 1 | 0 |
| `GetFieldColForFormatBankWise` | method | p_BankName | 1 | 0 |
| `SaveFormatComponentsForFeedBankComponents` | method | p_Col, p_BankName, p_StartRow | 3 | 0 |
| `GetVchDataFromPrevFinYr` | method | p_Vchcode, p_VchYear, p_VchData | 3 | 0 |
| `RefreshDB1ObjInDLL` | method |  | 0 | 0 |
| `RefreshDBObjInDLL` | method |  | 0 | 0 |
| `Chk4TdsGstBSFound` | method | p_udtVchData, p_AccMast, p_STPTMast, p_TotalTaxableAmt | 4 | 0 |
| `ChkIfAppForECommSuppliesUnderSec9_5` | method | p_STPTMast, p_VchType | 2 | 0 |
| `ChkIfFinYrApplicableForSupplies_9_5` | method |  | 0 | 0 |
| `ReIndexingDB` | method | p_YY, p_RestoreCurFY | 2 | 0 |
| `SaveMastFromJson` | method | p_MastType, p_JSONStr, p_ErrStr, p_MAMastercode, p_MastCode, p_ChkIfMobileUser, p_UserName, p_CSUserCol, p_ErrCode | 9 | 0 |
| `GetJSON2AccMast` | method | p_JSONStr, p_ErrStr, p_IsCSUser | 3 | 0 |
| `GetJSON2ItemMast` | method | p_JSONStr, p_ErrStr, p_IsCSUser | 3 | 0 |
| `GetReleaseNoStr` | method |  | 0 | 0 |
| `GetJSONRDPUserList` | method | p_JSONStr, p_ErrStr | 2 | 0 |
| `GetFreezeAccountType` | method |  | 0 | 0 |
| `GetDate4AgrpFreezing` | method | p_AccGrpCode | 1 | 0 |
| `GetFreezedAccount` | method | p_AccCode, p_Date | 2 | 0 |
| `DataFreezed4Account` | method | p_VchType, p_udtRetval, p_AccCode, p_Date, p_ErrMsg, ForAccMast | 6 | 0 |
| `ExtractTmpPartyCode` | method | XmlStr | 1 | 0 |
| `GetAgrpFreezed` | method | p_AccGrpCode | 1 | 0 |
| `CheckIfDataFreezed4Account` | method | p_VchType, p_udtVchData, p_OldVchData, p_StrErr | 4 | 0 |
| `CheckIfMultipleAliasExistsForGivenAcc` | method | p_AccCode, p_Alias | 2 | 0 |
| `GetJSON2VchOtherInfo` | method | p_JSON, p_VchType | 2 | 0 |
| `GetJSON2BillingDet` | method | p_JSON, p_VchType | 2 | 0 |
| `GetJSONPinCodeDetailsHiBusy` | method | p_JSONStr, p_ErrStr | 2 | 0 |
| `CheckIfEInvGenerated4Vch` | method | p_Vchcode | 1 | 0 |
| `CheckIfEWayGenerated4Vch` | method | p_Vchcode | 1 | 0 |
| `ModifyVchWithEWayEInvDet` | method | p_Vchcode, p_VchType, p_udtMobileVchData, p_Action, p_ErrStr, p_Remarks | 6 | 0 |
| `ValidateDataForEWayEinv` | method | p_udtVchData, p_InputMode, p_Remarks | 3 | 0 |
| `SaveCSAuditLogDetailed` | method | p_Type, p_InputMode, p_ModifyEntry, p_Code, p_VchNo, p_VchSeriesCode, p_VchDate, p_XMLStr, p_D1, p_D2, p_User, p_ActionTime, p_Action, p_Source, p_Remarks | 15 | 0 |
| `SaveCSAuditLogEntryDetailed` | method | p_Type, p_Code, p_VchNo, p_VchSeriesCode, p_VchDate, p_Action, p_Source, p_XMLStr, p_D1, p_D2, p_User, p_ActionTime, p_Remarks | 13 | 0 |
| `IsAlphaNumeric` | method | p_str | 1 | 0 |
| `GetMandiVchCount` | method |  | 0 | 0 |
| `CheckForEnableMandi` | method |  | 0 | 0 |
| `SaveFreeWhatsAppAPIConfig` | method |  | 0 | 0 |
| `saveApprovalDetHistoryCol` | method | p_XMLStr, p_Type, p_Code, p_Source, p_D1, p_D2, p_skipAdd | 7 | 0 |
| `initUdtApprovalDet` | method | p_approvalDet | 1 | 0 |
| `ListForIIndFormat` | method | p_PRID, p_FormatName | 2 | 0 |
| `CheckWarningLevelsForItemsParamWise` | method | p_ItemName, p_MCCode, p_ParamDet, p_ShowWarningMsg, p_UnitName, p_TransactionQty, p_VchType, p_MinQty, p_MaxQty, p_ReOrderQty, p_conMCCOde, p_Vchcode | 12 | 0 |
| `GetGSTNoForAccMast` | method | p_XMLStr | 1 | 0 |
| `CheckForDuplicateEntriesInFolio1Table` | method |  | 0 | 0 |
| `filterWhatsAppMsgForSpecialChar` | method | p_Msg | 1 | 0 |
| `getAccListFromTags` | method | p_tag | 1 | 0 |
| `GetAccListOfSundryCreditorsDebtors` | method | p_isDebtor | 1 | 0 |

## Busy2L21.CBCServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetBCFormatNamesList` | method | p_RecType | 1 | 0 |
| `GetBCItemCol` | method | p_Repopt, p_BCItem, p_BCItemAlias | 3 | 0 |
| `GetBCStockStatusItemCol1` | method | p_Repopt | 1 | 0 |
| `GetDataColForLabelPrinting` | method | p_Repopt, p_LabelType | 2 | 0 |
| `InItUdtBCPrintData` | method | p_udt | 1 | 0 |
| `GetBarCodeTypeFromFormatConfig` | method | p_BCConfig, p_BatchFound, p_SrNoFound, p_ParamFound, p_BCParamValue, p_BCParamAlias | 6 | 0 |
| `BCRefComponentExistInStructure` | method | p_BCConfig, p_BatchFound, p_SrNoFound, p_ParamFound, p_BCParamValue, p_BCParamAlias | 6 | 0 |
| `GetLabelFldNo2Str` | method | p_FldNo, p_FldsCol | 2 | 0 |
| `GetLabelStr2FldNo` | method | p_Name, p_LabelType, FldInfo | 3 | 0 |
| `GetBCFormatPrintSettings` | method | p_FormatName, p_RecType | 2 | 0 |
| `GetItemHSNCode` | method | p_ItemCode | 1 | 0 |
| `GetCompositeBCStructureCol` | method | p_RecType, p_IBCPrinting, p_FormatType | 3 | 0 |
| `DeleteCompositeBCStructure` | method | p_RecType, p_StructName | 2 | 0 |
| `SaveCompositeBCStructureConfig` | method | p_RecType, p_udtCompositeBCData, p_OldStructreName | 3 | 0 |
| `CheckItemBarCodeLinkedStructure` | method | p_Structure, p_FormatName, p_FormatType | 3 | 0 |
| `LoadCompositeBCStructureConfig` | method | p_RecType, p_StructName | 2 | 0 |
| `MasterCode2PrintName` | method | p_MasterCode | 1 | 0 |
| `GetNotes` | method | p_Notes, p_LineNo | 2 | 0 |
| `GetItemMultipleAlias` | method | p_ItemCode | 1 | 0 |
| `GetChequeFldStr2FldNo` | method | p_Name, FldInfo | 2 | 0 |
| `GetChequeFldNo2Str` | method | p_FldNo, p_FldsCol | 2 | 0 |
| `IfAskForChequePrinting` | method | p_Vchcode, p_VchType, p_BankName, p_DefaultFormat | 4 | 0 |
| `IfChequePrintingEnableInBank` | method | p_BankCode | 1 | 0 |
| `UpdateTran2ForChequePrinting` | method | p_Vchcode, p_AccCode, p_Srno | 3 | 0 |
| `IfChequeAlreadyPrinted` | method | p_Vchcode | 1 | 0 |
| `GetItemCategoryPrice` | method | p_PriceCategory, p_ItemMast, p_VchType, p_Trantype, p_IfSetBasePriceInfo | 5 | 0 |
| `GetBCNLatestSalesPrice` | method | p_ItemCode, p_BCN | 2 | 0 |
| `UpdateItemAlias` | method | p_Alias, p_ItemCode | 2 | 0 |

## Busy2L21.CIBCServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetFormatNamesList` | method |  | 0 | 0 |
| `SaveIBCConfigData` | method | p_FormatName, p_udtConfig | 2 | 0 |
| `LoadIBCConfigData` | method | p_FormatName | 1 | 0 |
| `DeleteItemBarCodeConfigData` | method | p_FormatName | 1 | 0 |

## Busy2L21.CUMSServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |

## Busy2L21.CVATServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |

## Busy2LA21.CServices_2LA

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `UpdateBooksStockInBalSheet` | method | p_events, p_FinMonthNo, p_VchSeriesGrpCode, p_BranchCode, p_DontUseStockAlpha, p_StockVal, p_prevYrFinDate, p_prevYrJobWorkAccCode | 8 | 0 |
| `UpdateBooksStockInBalSheetDateWise` | method | p_events, p_RepDate, p_IfStartDate, p_ForBalSheet, p_UsedForPLOpBal, p_prevYrFinDate, p_prevYrJobWorkStockAccCode | 7 | 0 |
| `GetJobWorkClosingStock` | method | p_StartDate, p_EndDate, p_Opstock | 3 | 0 |
| `GetDLLVersion` | method |  | 0 | 0 |

## Busy2LB21.CServices_2LB

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetDLLVersion` | method |  | 0 | 0 |

## Busy2LZ21.CADOServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `SetWAN` | method | p_WAN | 1 | 0 |
| `SetProvider` | method | p_Provider | 1 | 0 |
| `GetMSSQLADOConnectString` | method | p_ServerName, p_UID, p_Password, p_DBName | 4 | 0 |
| `OpenADOConnection` | method | p_ServerName, p_UID, p_Password, p_DBName | 4 | 0 |
| `OpenADOConnectionDB` | method | p_ServerName, p_UID, p_Password, p_DBName, p_Con | 5 | 0 |
| `CloseADOConnection` | method |  | 0 | 0 |
| `ExecuteQuery` | method | p_strQuery | 1 | 0 |
| `ExecuteQueryInDB` | method | p_strQuery, p_ServerInfoCol | 2 | 0 |
| `RefineXMLForNonPrintableChars` | method | p_Str | 1 | 0 |
| `GetADOFldType` | method | p_FldType | 1 | 0 |
| `ActivateDatabase` | method | p_Col | 1 | 0 |
| `GDR` | method | p_Col | 1 | 0 |
| `Connect2Server` | method | p_ServerName, p_UserID, p_Password, p_CompCode, p_FY, p_ErrStr | 6 | 0 |
| `ChangeServer` | method |  | 0 | 0 |
| `RollBackServer` | method |  | 0 | 0 |
| `DisconnectFromServer` | method |  | 0 | 0 |
| `SaveCurrentServer` | method |  | 0 | 0 |
| `SwitchServer` | method | p_ServerName, p_UserID, p_Password, p_CompCode, p_FY, p_ErrStr | 6 | 0 |
| `RestoreCurrentServer` | method |  | 0 | 0 |
| `UpdateServerInfoForBDNS` | method | p_ServerName | 1 | 0 |
| `GetSimpleDecryptedStr` | method | p_EncryptedStr | 1 | 0 |
| `IsArrayEmpty` | method | p_Arr | 1 | 0 |
| `SaveImageInDatabase` | method | p_udtImageData | 1 | 0 |
| `LoadImageFormDatabase` | method | p_Code, p_Type, p_TempdbName | 3 | 0 |
| `LoadUserImageFormDatabase` | method | p_Name, p_Type, p_ServerInfoCol | 3 | 0 |
| `MakeQueryStr` | method | p_Str | 1 | 0 |
| `SaveUserAndSignImageInDatabase` | method | p_udtImageData, p_ServerInfo | 2 | 0 |
| `OpenJetADOConnection` | method | p_DBName | 1 | 0 |
| `CloseJetADOConnection` | method |  | 0 | 0 |
| `CreateTextFileFromQry` | method | p_Qry, p_TableName, p_Path, p_ErrStr | 4 | 0 |
| `GetXMLFromQryStr` | method | p_Qry, p_ErrStr, p_ExportedFilePath | 3 | 0 |
| `OpenJetADOConnectionDB` | method | p_DBName, p_Con | 2 | 0 |
| `GetXMLFromQryStrDB` | method | p_Qry, p_Provider, p_DBName, p_ServerInfoCol, p_ErrStr, p_ExportedFilePath | 6 | 0 |
| `GetDLLVersion` | method |  | 0 | 0 |
| `GetRecordsetFromADO` | method | p_Qry, p_DBName, p_Con, p_ReadOnly | 4 | 0 |
| `CreateTextFileFromQryMultiFYSQL` | method | p_Qry, p_TableName, p_Path, p_ServerInfoCol, p_ErrStr | 5 | 0 |
| `OpenADOConnectionMultiFY` | method | p_ServerName, p_UID, p_Password, p_DBName, p_Con | 5 | 0 |

## BusyExt21.CMasterServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `MasterPrintName2Name` | method | p_PrintName, p_MasterType | 2 | 0 |
| `MasterCode2Name` | method | p_Code | 1 | 0 |
| `MasterName2Code` | method | p_Name, p_MasterType | 2 | 0 |
| `LoadAllVchSeries` | method | p_CheckOrderProcessOption, p_VchType | 2 | 0 |
| `GetMasterXML` | method | p_MastCode | 1 | 0 |
| `GetCurConType` | method | p_Code | 1 | 0 |
| `GetMastersCol` | method | p_MasterType | 1 | 0 |
| `GetVSGrpColForCurUser` | method |  | 0 | 0 |
| `GetMasterSeriesGrpCodeForCurUser` | method |  | 0 | 0 |
| `GetItemMainUnitName` | method | p_ItemName | 1 | 0 |
| `MasterCode2Alias` | method | p_Code, p_MasterType | 2 | 0 |
| `GetAccClosingBals` | method | p_MasterCode, p_Date, p_AltBal, p_VchCode | 4 | 0 |
| `GetItemMCClosingBals` | method | p_ItemCode, p_MCCode, p_Date, p_BalAltUnit, p_VchCode | 5 | 0 |
| `GetItemClosingBals` | method | p_ItemCode, p_Date, p_BalAlt | 3 | 0 |
| `MasterName2CodeIfExist` | method | p_MasterName, p_MasterType, p_IfMultiAlias | 3 | 0 |
| `MasterCode2NameIfExist` | method | p_MasterCode | 1 | 0 |
| `BOMExistForItem` | method | p_ItemCode, p_BOMName | 2 | 0 |
| `GetAllBOMForItem` | method | p_ItemCode, p_BOMNames, p_BOMCodes | 3 | 0 |
| `IfChild` | method | p_MastCode, p_ParentGrpCode | 2 | 0 |
| `GetAllChildQryStr` | method | p_GrpCode, p_ChildMasterType, p_DirectChildOnly | 3 | 0 |
| `GetVchSeriesCodesForBranch` | method | p_BranchCode | 1 | 0 |
| `GetParentGrp` | method | p_Code | 1 | 0 |
| `MasterNameExist` | method | p_MasterName, p_MasterType, p_IgnoreAlias | 3 | 0 |
| `GetUCFactorForUnit` | method | p_ItemName, p_UnitName, p_ItemMast, p_CheckItemName | 4 | 0 |
| `GetAllChildArr` | method | p_Code, p_ChildType, p_ChildSubType, p_ExcludeDeactivate | 4 | 0 |
| `GetParentMasterType` | method | p_ChildType | 1 | 0 |
| `GetAccMastDataByCode` | method | p_AccCode, p_LoadPartial, p_CheckAcc | 3 | 0 |
| `GetContactMastDataByCode` | method | p_ContactMastCode, p_LoadPartial, p_CheckAcc | 3 | 0 |
| `GetItemMastData` | method | p_ItemName, p_LoadPartial, p_CheckItem, p_Date | 4 | 0 |
| `GetItemMastDataByCode` | method | p_ItemCode, p_LoadPartial, p_CheckItem, p_Date | 4 | 0 |
| `GetFormMastDataByCode` | method | p_FormCode, p_LoadPartial | 2 | 0 |
| `GetMastConfig` | method | p_MastType, p_LoadFromDB | 2 | 0 |
| `GetBSMastData` | method | p_BSName, p_LoadPartial, p_CheckBS | 3 | 0 |
| `GetBSMastDataByCode` | method | p_BSCode, p_LoadPartial, p_CheckBS | 3 | 0 |
| `MasterCodeExist` | method | p_MasterCode | 1 | 0 |
| `GetSTPTMastData` | method | p_Code, p_MasterType | 2 | 0 |
| `GetBranchMastData` | method | p_Code | 1 | 0 |
| `GetAllChildsInGrpCol` | method | p_GrpCode, p_IncludeCurrent | 2 | 0 |
| `GetCurMastDataByCode` | method | p_Code | 1 | 0 |
| `GetItemAltUnitName` | method | p_Item, CheckItemName | 2 | 0 |
| `MastCode2NameQry` | method | p_MastCodeStr | 1 | 0 |
| `GetItemsDefaultPriceDisc` | method | p_VchType, p_GrpCode, p_MasterCode, p_Col | 4 | 0 |
| `GetItemsDefaultPriceDiscForBranch` | method | p_BranchCode, p_VchType, p_GrpCode, p_Date, p_Col | 5 | 0 |
| `GetItemMastUnitDetailsByCode` | method | p_ItemCode | 1 | 0 |
| `GetMasterTypeFromCode` | method | p_Code | 1 | 0 |
| `GetVchSeriesGrpCodeForCurUser` | method |  | 0 | 0 |
| `DisableVchSeriesGrpOnReporting` | method |  | 0 | 0 |
| `GetMCCodesForBranch` | method | p_BranchCode, p_BookStockOnly | 2 | 0 |
| `GetBranchCodeForVSGrp` | method | p_VSGrpCode | 1 | 0 |
| `GetAllMC` | method | p_GrpCode, p_BookStockOnly, p_MSGrpCode, p_BranchCode | 4 | 0 |
| `GetAllChildQryStrForParentGrps` | method | p_GrpCodes, p_ChildMasterType, p_DirectChildOnly | 3 | 0 |
| `MasterCode2Choice` | method | p_MastCode, p_Choice | 2 | 0 |
| `GetSubAccClosingBalForCur` | method | p_MasterCode, p_CurCode, p_Date, p_BaseCurBal, p_VchCode, p_VchSeriesGrpCode | 6 | 0 |
| `CheckMultiCurrency` | method | p_MasterCode | 1 | 0 |
| `GetCurOpBalFromTran4` | method | p_MasterCode, p_CurCode, p_BalBase | 3 | 0 |
| `GetCurrentBalofVch` | method | p_RecType, p_MasterCode1, p_MasterCode2, p_VchCode, p_BalAlt | 5 | 0 |
| `GetSubAccClosingBalsForVSGrpCode` | method | p_MasterCode, p_Date, p_BalAlt, p_VchSeriesGrpCode, p_VchCode, p_IncludePDC | 6 | 0 |
| `GetSubAccClosingBals` | method | p_MasterCode, p_Date, p_BalAlt, p_VchCode, p_IncludePDC | 5 | 0 |
| `GetOpBalsFromFolio` | method | p_MasterCode, p_BalAlt, p_BalValue | 3 | 0 |
| `MasterName2Alias` | method | p_Name, p_MasterType | 2 | 0 |
| `LoadBrachMastersForDataSync` | method | p_AllBranchCol | 1 | 0 |
| `GetContactMastData` | method | p_ContactMast, p_LoadPartial, p_CheckAcc | 3 | 0 |
| `GetAccMastData` | method | p_Accname, p_LoadPartial, p_CheckAcc | 3 | 0 |
| `SeriesExistForVch` | method | p_SeriesCode, p_VchType | 2 | 0 |
| `GetBranchMastFldVal` | method | p_Col, p_FldID | 2 | 0 |
| `UpdateVchOptionalFieldsVals` | method | p_VchConfig, p_VchOtherInfo | 2 | 0 |
| `GetVchOptionalFieldsVals` | method | p_VchConfig, p_VchOtherInfo | 2 | 0 |
| `GetItemCategoryStrFromCode` | method | p_ItemCode | 1 | 0 |
| `ModifyMasterFromBDEP` | method | p_MastName, p_MastType | 2 | 0 |
| `StateCode2TinDigit` | method | p_StateCode | 1 | 0 |
| `GetAccClosingBalForBranch` | method | p_MasterCode, p_BranchCode, p_Date, p_VchCode | 4 | 0 |
| `CheckForGeneralLedgerByCode` | method | p_LedgerCode | 1 | 0 |
| `GetItemHSNCodeOnSpecificDateFromCode` | method | p_Code, p_Date | 2 | 0 |
| `GetSTPTMastType` | method | p_VchType, p_Trantype | 2 | 0 |

## BusyExt21.CTranServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetAutoVchNoFromVchNo` | method | p_VSCode, p_VchNo, p_Date | 3 | 0 |
| `GetSoftlockLicenseDet` | method | p_OCol | 1 | 0 |
| `GetPendingItemParamStock` | method | p_ItemCode, p_MCCode, p_VchCode, p_VchDate, p_NoOfStockParam | 5 | 0 |
| `Tran3RS2RefData` | method | p_rstTran3, p_RefData | 2 | 0 |
| `GetNewRefDueDate` | method | p_NewRefCode | 1 | 0 |
| `GetRefGrpCodeNameForNewRef` | method | p_RefCode, p_RefGrpCode, p_RefGrpName | 3 | 0 |
| `GetPendingItemSerialNumbers` | method | p_ItemCode, p_MCCode, p_VchCode, p_VchDate, p_AllRefs | 5 | 0 |
| `GetVchTypeFromVchCode` | method | p_VchCode | 1 | 0 |
| `GetLastVchInCallReceiptSeries` | method | p_VSC, p_VchData, p_LoadPartial, p_LastDateVchNoOnly | 4 | 0 |
| `GenerateAutoVchNumber` | method | p_VchNumData, p_VchNo, p_Date | 3 | 0 |
| `GetLastAutoVchNo` | method | p_SeriesCode, p_RenumType, p_Date | 3 | 0 |
| `VchNoExistInSeries` | method | p_VSC, p_VchNo, p_Date, p_VchCode, p_OrgPartyCode, p_OrgVchCode, p_PartyCode, p_Trantype, p_VchType | 9 | 0 |
| `GetCallVchDataFromCallNo` | method | p_CallNo | 1 | 0 |
| `GetDistinctOpenCallList` | method | p_Date | 1 | 0 |
| `GetCallHistory1ForCallRptList` | method | p_CallNo, p_CheckAllocation, p_AreaCode, p_Date, p_VchCode | 5 | 0 |
| `CheckIfValidCall` | method | p_CallNo, p_Date | 2 | 0 |
| `GetCallVchData` | method | p_VchCode, p_VchData, p_LoadPartial | 3 | 0 |
| `GetAllocationDateOfCall` | method | p_CallNo, p_CallDate | 2 | 0 |
| `CheckIfCallRcptCanBeDeleted` | method | p_CallNo | 1 | 0 |
| `GetLastCallReceiptVch` | method | p_VchType, p_VchData, p_LoadPartial, p_LastDateOnly | 4 | 0 |
| `GetLastCallReceiptVchForFixSeriesCol` | method | p_VSCCol, p_VchData, p_LoadPartial, p_LastDateVchNoOnly | 4 | 0 |
| `MakeVchSeriesCodeQryString` | method | p_Col | 1 | 0 |
| `GetLastDateForVchSeries` | method | p_VchSeriesCode | 1 | 0 |
| `GetLastVchInSeries` | method | p_VSC, p_VchData, p_LoadPartial, p_LastDateVchNoOnly | 4 | 0 |
| `GetVchTypeNoDateFromVchCode` | method | p_VchCode, p_VchType, p_VchNo, p_VchDate, p_Date | 5 | 0 |
| `GetNextVch` | method | p_VchCode, p_VchSeriesCode, p_VchDate, p_VchNo | 4 | 0 |
| `GetPrevVch` | method | p_VchCode, p_VchSeriesCode, p_VchDate, p_VchNo | 4 | 0 |
| `GetLastVchSeriesForCallVchTypes` | method | p_VchType | 1 | 0 |
| `GetVchLastCode` | method |  | 0 | 0 |
| `GetCallTranType` | method | p_Call | 1 | 0 |
| `GetLastCallReceiptDetCallStatusWise` | method | p_VchType, p_VchSeriesCode, p_CallStatus, p_SubStatus, p_NextAction, p_ActionTaken | 6 | 0 |
| `GetLastCallReceiptHeaderDetTranTypeWise` | method | p_VchType, p_VchSeriesCode, p_Trantype, p_Source, p_callCat | 5 | 0 |
| `IsVchNoUniqueInAllSeries` | method | p_VchNo, p_VchType, p_VchCode | 3 | 0 |
| `GetLastMsgID` | method |  | 0 | 0 |
| `SaveSendMessage` | method | p_udtMsgData | 1 | 0 |
| `GetNewOfflineCode` | method |  | 0 | 0 |
| `GetCallHistoryVchWise` | method | p_CallNo, p_Date | 2 | 0 |
| `CheckIfConsignmentVchAlreadyFeeded` | method |  | 0 | 0 |
| `CheckIfCallIsClosed` | method | p_CallNo | 1 | 0 |
| `CheckForCompanyGSTIN` | method | p_TitleMsg, p_ShowMsg | 2 | 0 |
| `GetVSGrpForBranch` | method | p_BranchCode | 1 | 0 |
| `SaveCanceledRef` | method | p_RefData | 1 | 0 |
| `GetBranchForVS` | method | p_VSCode | 1 | 0 |
| `GetMRPClosingStock` | method | p_MRP, p_ItemCode, p_MCCode, p_VchDate, p_VchCode, p_SalesPrice, p_GroupSalesPriceAndMRP, p_AltStock | 8 | 0 |
| `GetCurrStockForUnit` | method | p_UnitName, p_ItemMast, p_MainQty, p_AltQty | 4 | 0 |
| `PurcBillNoExist2ValidateSalePurcRet` | method | p_VchNo, p_VSC, p_Date, p_VchCode, p_ValidateVchNo, p_OrgPartyCode, p_OrgVchCode, p_PartyCode, p_Trantype, p_VchType | 10 | 0 |
| `IsPurcBillExist` | method | p_ModifyOptions, p_VchNo, p_VchDate, p_VchSeriesCode, p_VchCode, p_VchType | 6 | 0 |
| `VchNoExist2ValidateSalePurcRet` | method | p_VchNo, p_VSC, p_Date, p_VchCode, p_ValidateVchNo, p_OrgPartyCode, p_OrgVchCode, p_PartyCode, p_Trantype, p_VchType | 10 | 0 |
| `GetSaleAndTaxAmt4GSTINDIA` | method | p_VchCode, p_TaxableAmt, p_TaxAmt, p_TaxBeforeSchg, p_TaxBeforeSchg1, p_STPTType, p_CessAmt, p_AddCessAmt, p_StateCessAmt | 9 | 0 |
| `GetSaleAndTaxAmt` | method | p_VchCode, p_SaleAmt, p_TaxAmt, p_SurchargeAmt, p_OnlyTaxAmt | 5 | 0 |
| `GetVchFirstItemcode` | method | p_VchCode, p_UnitName | 2 | 0 |
| `GetVchSalePurcAmt` | method | p_VchCode, p_VchType, p_STPTMast | 3 | 0 |
| `PlainBS` | method | p_BSMast | 1 | 0 |
| `GetReportAPIVersionFromGWS` | method | p_ReportID, p_UseForDownload, p_ReportSubType | 3 | 0 |
| `GetWebServiceURLForGWS` | method | p_GSTFunction | 1 | 0 |
| `GetDateTime2StrUniversal` | method | p_Date | 1 | 0 |
| `GetFullBusyVersion` | method |  | 0 | 0 |
| `GetLastInvVchDate` | method |  | 0 | 0 |
| `GetDate2StrUniversal` | method | p_Date | 1 | 0 |
| `ShowPopUpMsg` | method | p_msg, p_URL, p_Title, p_IfEscPressed, p_URLCaption, p_DownloadBusyAgent4GWS | 6 | 0 |
| `GetClodSyncVchJSON` | method | p_UID, p_ServiceURL, p_JSONStr, p_Errstr, p_SC, p_ErrOrigin, p_ErrCode | 7 | 0 |
| `GetClodSyncMasterJSON` | method | p_UID, p_ServiceURL, p_JSONStr, p_Errstr, p_SC, p_ErrOrigin, p_ErrCode | 7 | 0 |
| `GetEWayBillJSON` | method | p_VchCode, p_Form31No, p_EWayBillDate | 3 | 0 |
| `GetEInvJSON` | method | p_VchCode, p_EInvIRN, p_EInvAckNo, p_EInvAckDate, p_EInvSignedQRCode, p_EInvSignedInvoice, p_Form31No, p_EWayBillDate, p_CombinedEwbEInv | 9 | 0 |
| `GetChangeNameGrpJson` | method | p_MastType, p_OldName, p_NewName, p_ChangeType, p_MastName, p_GrpMastertype | 6 | 0 |
| `SaveVchMastDataForCloudSyncInOtherFY` | method | p_db, p_Con, p_Type, p_VchMastType, p_VchMastCode, p_InputMode, p_DeleteVch, p_XMLStr, p_ErrMsg, p_FormatType, p_Desc, p_RequiredLock | 12 | 0 |
| `SaveEntryInCloudSyncIncrInOtherFY` | method | p_db, p_Con, p_Type, p_SubType, p_Action, p_VchMastCode, p_XMLStr, p_FormatType, p_Desc, p_RequireLock | 10 | 0 |
| `SaveXMLForCloudSyncIncrInOtherFY` | method | p_db, p_Con, p_Code, p_XMLStr | 4 | 0 |
| `CheckIfBulkUploadCompletedInOtherFY` | method | p_db, p_Con | 2 | 0 |
| `GetLastCodeFromCloudSyncIncrInOtherFy` | method | p_db, p_Con | 2 | 0 |
| `GetUpdateFolioSummJson` | method | p_parentGrpName, p_ParentMasterType, p_MastName, p_ChildMasterType, p_UseParentGrpCodeSpecified, p_AddSubtractType | 6 | 0 |

## BusyExt21.COtherServices

| Member | Kind | Params | N | Opt |
|---|---|---|---|---|
| `QueryInterface` | method | riid, ppvObj | 2 | 0 |
| `AddRef` | method |  | 0 | 0 |
| `Release` | method |  | 0 | 0 |
| `GetTypeInfoCount` | method | pctinfo | 1 | 0 |
| `GetTypeInfo` | method | itinfo, lcid, pptinfo | 3 | 0 |
| `GetIDsOfNames` | method | riid, rgszNames, cNames, lcid, rgdispid | 5 | 0 |
| `Invoke` | method | dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr | 8 | 0 |
| `GetDefaultTranTypeTaggedInSeries` | method | p_VSCode | 1 | 0 |
| `SortItemColByQtyType` | method | p_ItemCol | 1 | 0 |
| `CountryCode2Name` | method | p_Code | 1 | 0 |
| `CountryName2Code` | method | p_Name, p_DoNotTreatOtherAsIndia | 2 | 0 |
| `StateName2PDCode` | method | p_StateName, p_CountryCode | 2 | 0 |
| `StatePDCode2Name` | method | p_StateCode, p_CountryCode | 2 | 0 |
| `ValidDateInCurFY` | method | p_Date, p_DateTypeStr, p_ErrMsg | 3 | 0 |
| `LoadFreezeConfig` | method |  | 0 | 0 |
| `GetRecordset` | method | p_StrQry, p_RaiseError, p_ErrMsg, p_LocalCaching | 4 | 0 |
| `GetRecordsetFromDB` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `GetRecordsetValue` | method | p_StrQry, RecordExist | 2 | 0 |
| `RaiseError` | method |  | 0 | 0 |
| `CreateErrorLog` | method | p_Errstr | 1 | 0 |
| `GetFldVal` | method | p_Fld | 1 | 0 |
| `MasterName2Series` | method | p_SeriesName | 1 | 0 |
| `GetLastVchDateForVchtype` | method | p_VchType | 1 | 0 |
| `VchType2FullName` | method | p_VchType, p_VchSeriesCode, p_lastSavedCaptions | 3 | 0 |
| `VchType2ShortName` | method | p_VchType, p_VchSeriesCode, p_lastSavedCaptions | 3 | 0 |
| `Series2MasterName` | method | p_VchType, p_SeriesName | 2 | 0 |
| `GetLastVchDateForVchSeriesCode` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `SaveFreezeConfig` | method | p_udtfreezeConfig | 1 | 0 |
| `SavePartialFreezeData` | method | p_udtData | 1 | 0 |
| `BeginTran` | method |  | 0 | 0 |
| `CommitTran` | method |  | 0 | 0 |
| `RollBackTran` | method |  | 0 | 0 |
| `ExecuteQuery` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `LoadStockParamConfig` | method | p_NoOfStockParam, p_GrpCode | 2 | 0 |
| `GetStockParamColFromText` | method | p_Text | 1 | 0 |
| `FindItemInCol` | method | p_Item, p_Col | 2 | 0 |
| `GetTDSDeducteeCategoryList` | method |  | 0 | 0 |
| `TDSDeducteeCatName2No` | method | p_TDSDeducteeCatName | 1 | 0 |
| `TDSDeducteeCatNo2Name` | method | p_TDSDeducteeCatNo | 1 | 0 |
| `TDSStatetName2Code` | method | p_TDSStateName | 1 | 0 |
| `TDSStateCode2Name` | method | p_TDSStateCode | 1 | 0 |
| `InitUserUdt1` | method | p_udtUserProfile1 | 1 | 0 |
| `InitUserUDT` | method | p_udtUserProfile, p_udtUserProfile1 | 2 | 0 |
| `ActionUDT2Str` | method | p_ActionUdt | 1 | 0 |
| `Str2ActionUDT` | method | p_str | 1 | 0 |
| `GetCustomRepFldVal` | method | p_Col, p_FldID | 2 | 0 |
| `GetUserProfile` | method | p_UserProfile1 | 1 | 0 |
| `SetFontInFrmTextWidth` | method | p_Font | 1 | 0 |
| `GetStringWidthInTwip` | method | p_str | 1 | 0 |
| `GetStringHeightInTwip` | method | p_str | 1 | 0 |
| `UpdateFreezingDate` | method | p_Date, p_DataFreeze, p_AccountFreezeLevel | 3 | 0 |
| `GetMasterTypeFromRectype` | method | p_RecType | 1 | 0 |
| `IfMasterSeriesTaggingEnableInMasterType` | method | p_MasterType | 1 | 0 |
| `RecordExist` | method | p_Qry | 1 | 0 |
| `GetAddnInfoLength` | method | p_MastConfig, p_AddnInfoNum, p_StartPt | 3 | 0 |
| `GetTableRST` | method | p_TableName, p_rst | 2 | 0 |
| `GetLastVchDate` | method |  | 0 | 0 |
| `InitUdtVchData` | method | p_udt | 1 | 0 |
| `InitUdtVChOtherInfo` | method | udtVchOtherInfo | 1 | 0 |
| `InitUdtVchOF` | method | p_udtVchOtherInfo | 1 | 0 |
| `MasterMultipleAlias2CodeIfExist` | method | p_ItemAlias, p_MasterType, p_ActualMasterName | 3 | 0 |
| `InitUdtPOSSetllementDetailsData` | method | p_udt | 1 | 0 |
| `InitUdtItemData` | method | p_udt | 1 | 0 |
| `Actual2Index` | method | p_str, p_Len | 2 | 0 |
| `Index2Actual` | method | p_str, p_Len | 2 | 0 |
| `GetData` | method | p_str, p_rst | 2 | 0 |
| `InitUDTAccMast` | method | p_AccMast | 1 | 0 |
| `InitUDTItemMast` | method | p_ItemMast | 1 | 0 |
| `IsItemSrAutoNumStructureExists` | method | p_StructName | 1 | 0 |
| `SaveItemSrAutoNumConfig` | method | p_ItemSrNumConfig | 1 | 0 |
| `DeleteItemSrAutoNumStructure` | method | p_StructName | 1 | 0 |
| `InitudtMultiPriceDateWise` | method | p_udt | 1 | 0 |
| `VRCNum2Str` | method | p_VRCNum | 1 | 0 |
| `VRCStr2Num` | method | p_VRCName | 1 | 0 |
| `InitRepOptFields` | method | p_RepOpt, p_PrnRep | 2 | 0 |
| `InitPrintFromGridDet` | method | p_PrintFromGridDet | 1 | 0 |
| `InitSRRepData` | method | p_SRRepData | 1 | 0 |
| `GetAllMasterCode` | method | p_MasterType, p_ParentGrp, p_MSCode | 3 | 0 |
| `GetMSGrpQryStr` | method | p_MasterType, p_MastSeriesGrpCode, p_FieldName | 3 | 0 |
| `GetOrgName` | method | p_Code, p_MastType | 2 | 0 |
| `GenQryInStrFromCol` | method | p_Col, p_ForStringDataType | 2 | 0 |
| `GetVSGrpQryStr` | method | p_VchSeriesGrpCode, p_FieldName, p_SkipOperator | 3 | 0 |
| `SaveTransportDetInOtherInfo` | method | p_VchCode, p_OtherInfo | 2 | 0 |
| `SavePurcBillNoAndDateInOtherInfo` | method | p_VchCode, p_OtherInfo | 2 | 0 |
| `Add2Help2Db` | method | p_SeriesCode, p_FieldType, p_Field | 3 | 0 |
| `GetVchTypeAndVchSeriesFromVchCode` | method | p_VchCode, p_VchType, p_VchSeriesCode | 3 | 0 |
| `Actual2FinMonth` | method | p_Month, p_BegFY, p_DateType | 3 | 0 |
| `InitSROnEnterInfo` | method | p_OnEnterInfo | 1 | 0 |
| `LoadItemSrAutoNumConfig` | method | p_StructName | 1 | 0 |
| `ToSaveMaster` | method | p_msg | 1 | 0 |
| `ToSaveForm` | method | p_msg | 1 | 0 |
| `GetPricingMode` | method | p_VchType, p_Trantype | 2 | 0 |
| `IfSingleMC` | method |  | 0 | 0 |
| `GetMaxElmtInGrid` | method |  | 0 | 0 |
| `ToQuitMaster` | method |  | 0 | 0 |
| `FullName2Vchtype` | method | p_Name | 1 | 0 |
| `SurchargeApplicable` | method | p_STPTMast, p_SurchargeConfig, p_IncludeMT, p_SchgAppl4Pakistan | 4 | 0 |
| `TaxBS` | method | p_BSnature, p_LocType | 2 | 0 |
| `GetMappingOptions2Str` | method | p_Opt | 1 | 0 |
| `GetMappingStr2Options` | method | p_str | 1 | 0 |
| `SaveMappingDet` | method | p_MasterType, p_MastCol, p_UsedForUtility | 3 | 0 |
| `LoadMappingDet` | method | p_MasterType, p_Col | 2 | 0 |
| `SaveUtilitesUserLog` | method | p_MenuConst, p_AddInfo, p_OtherInfo, p_TypeConst, p_AddEventInfo, p_used4BulkUpdation | 6 | 0 |
| `ExecuteQueryInDB` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `GetTableRSTForDB` | method | p_TableName, p_rst | 2 | 0 |
| `GetDongleSrNo` | method |  | 0 | 0 |
| `GetRecordsetFromDatabase` | method | p_StrQry, p_db, p_Con, p_RaiseError, p_ErrMsg, p_LocalCaching | 6 | 0 |
| `ExecuteQuerytmp` | method | p_StrQry, p_RaiseError, p_ErrMsg | 3 | 0 |
| `CheckCSUserPwd` | method | p_ServerInfo, p_ErrNum | 2 | 0 |
| `UpdateServerInfoForBDNS` | method | p_ServerInfo | 1 | 0 |
| `GetFldValIfExist` | method | p_rst, p_Fld | 2 | 0 |
| `SaveItemSNPrintDetConfig` | method | p_SNPrintDet, p_RecType | 2 | 0 |
| `LoadItemSNPrintDetConfig` | method | p_rst, p_RecType | 2 | 0 |
| `SaveAuthorisationData` | method | p_Col, p_Type | 2 | 0 |
| `IfConditionsForItemGenOrCon` | method | p_Con | 1 | 0 |
| `GetOperatorName2Type` | method | p_OPType | 1 | 0 |
| `GetUserList` | method | p_IncludeSuperUser | 1 | 0 |
| `SortCollection` | method | p_Col | 1 | 0 |
| `UpdateItemHSNString` | method |  | 0 | 0 |
| `GetArrayfromRst` | method | p_rst | 1 | 0 |
| `LoadVchAuditData` | method |  | 0 | 0 |
| `SaveVchAuditData` | method | p_Col, p_Date | 2 | 0 |
| `VchLeftForAuditing` | method | p_VchType, p_VchSeriesCode | 2 | 0 |
| `CreateDefaultMaster` | method | p_MasterType, p_MasterName, p_GrpCode, p_DefaultMastCode, p_AddInfo, p_Source | 6 | 0 |
| `GetHeadOfficeStr` | method | p_HOString | 1 | 0 |
| `GetTempRST` | method | p_TabelName | 1 | 0 |
| `SavePIRForItem` | method | p_RecType, p_MasterCode1, p_PIRDAta, p_VchType, p_Date, p_BranchCode | 6 | 0 |
| `InitUDTContactMast` | method | p_ContactMast | 1 | 0 |
| `ModifyPartyItemAnalysisFormatName` | method | p_OldFormatName, p_NewFormatName, p_PRID, p_ConfigType | 4 | 0 |
| `ModifyParamStockStatusFormatName` | method | p_OldFormatName, p_NewFormatName, p_PRID | 3 | 0 |
| `ModifyCostCentreFormatName` | method | p_OldFormatName, p_NewFormatName, p_PRID | 3 | 0 |
| `ModifyImportVchFromExcelFormatName` | method | p_PRID, p_FormatOldName, p_FormatNewName | 3 | 0 |
| `ModifyBulkVchFromGridFormatName` | method | p_PRID, p_FormatOldName, p_FormatNewName | 3 | 0 |
| `ModifyConfigBalSheetFormatName` | method | p_OldFormatName, p_NewFormatName, p_PRID | 3 | 0 |
| `ModifyPRFormatName` | method | p_PRID, p_FormatOldName, p_FormatNewName | 3 | 0 |
| `SaveCostCentreFormatName` | method | p_FormatName, p_PRID, p_ConfigType | 3 | 0 |
| `SaveParamterizedStockFormatName` | method | p_FormatName, p_PRID, p_ConfigType | 3 | 0 |
| `SaveConfigBalSheetFormatName` | method | p_FormatName, p_PRID | 2 | 0 |
| `CreateNewPRFormat` | method | p_PRID, p_FormatName, p_PageSetting | 3 | 0 |
| `SaveFYPreferences` | method | p_udtFYPref | 1 | 0 |
| `GetFYPreferences` | method |  | 0 | 0 |
| `SavePartyItemCodes` | method | p_ItemPartyCodesCol, p_PartyCode | 2 | 0 |
| `ReadPartyItemCodes` | method | p_PartyCode | 1 | 0 |
| `GetFields4Explore` | method | p_MastType, p_BulkAccountInputConst | 2 | 0 |
| `GenPRFieldsArr` | method | p_PRID, p_PRSUBID | 2 | 0 |
| `MastCode2NameQry` | method | p_MastCodeStr | 1 | 0 |
| `SaveFormLabelsCaption` | method | p_FormUdt | 1 | 0 |
| `MakeLabelsInfoStr` | method | p_LabelInfo | 1 | 0 |
| `GetFormLabelsCaption` | method | p_FormID, p_FormSubID, p_VchSeriesCode, p_Flag | 4 | 0 |
| `SaveImageInDataBase` | method | p_udt | 1 | 0 |
| `SaveUserAndSignImageInDatabase` | method | p_udt | 1 | 0 |
| `GetVchSeriesImageFolderPath` | method | p_SeriesCode | 1 | 0 |
| `GetAllVchCodesFormVchTypeAndSeries` | method | p_VchType, p_SeriesCode | 2 | 0 |
| `DeleteUserImageFormDatabase` | method | p_Name, p_Type | 2 | 0 |
| `LoadUserImageFormDatabase` | method | p_Name, p_Type | 2 | 0 |
| `SaveDosPrinterDrv` | method | p_udtPrinterCommand | 1 | 0 |
| `GetDefaultPrinterCommands` | method | p_PrinterName | 1 | 0 |
| `GetDosPrinterDrv` | method | p_Name | 1 | 0 |
| `BreakStr` | method | p_str, p_MaxChar, p_ConsiderLineFeed | 3 | 0 |
| `UpdateCategoryCodeInNMNotes` | method | p_CategoryCode | 1 | 0 |
| `UpdateDefaultCategoryInUser` | method | p_CategoryCode | 1 | 0 |
| `GetAllNMCategoryCol` | method | p_ParentCategoryCode, ToIncludeMsgCat | 2 | 0 |
| `DeleteNMCategoryFromDB` | method | p_CategoryCode | 1 | 0 |
| `GetDefaultCategoryCodeForUser` | method | p_User | 1 | 0 |
| `SaveNMCategoryName` | method | p_InputMode, p_CategoryUdt, p_OldCategoryName | 3 | 0 |
| `GetLastCategoryCode` | method |  | 0 | 0 |
| `GetStatusText2Num` | method | p_StatusText | 1 | 0 |
| `GetStatusNum2Text` | method | p_Status | 1 | 0 |
| `ReminderOccurenceNum2Text` | method | p_ReminderOccurence | 1 | 0 |
| `ReminderOccurenceText2Num` | method | p_ReminderOssurence | 1 | 0 |
| `DeleteNotesFromDB` | method | p_NotesCode | 1 | 0 |
| `SaveNotesToDB` | method | p_UdtNMNotes, p_InputMode | 2 | 0 |
| `GetNotesColForCategory` | method | p_NotesStatus, p_CategoryCode, p_NotesCode | 3 | 0 |
| `GetLastNotesID` | method | p_UserName | 1 | 0 |
| `WriteFields4Explore` | method | p_MastType, p_Fields | 2 | 0 |
| `SaveIQD` | method | p_Col, p_MasterCode, p_VchType, p_RecType, p_Date | 5 | 0 |
| `LoadIQD` | method | p_RecType, p_MasterCode, p_VchType, p_Date | 4 | 0 |
| `ValidSQLQuery` | method | p_Query, p_ErrMsg | 2 | 0 |
| `SaveSQLQuery` | method | p_QueryName, p_Query, p_QueryType | 3 | 0 |
| `LoadSQLQueryCol` | method |  | 0 | 0 |
| `GetSQLQueryData` | method | p_Name | 1 | 0 |
| `DeleteSqlQuery` | method | p_QueryName | 1 | 0 |
| `LoadSQLQueryPassword` | method | p_Name | 1 | 0 |
| `Fin2ActualMonth` | method | p_Month, p_BegFY, p_DateType | 3 | 0 |
| `GetFullMonthStr` | method | nMonth, p_DateType | 2 | 0 |
| `SaveLastNMCodes` | method | p_CategoryCode, p_NotesCode | 2 | 0 |
| `IfNoteCrossingDeadLine` | method |  | 0 | 0 |
| `ChangeCategoryAfterDragDrop` | method | p_NotesCode, p_CategoryCode | 2 | 0 |
| `GetNoteCrossingDeadLineCol` | method | p_ShowAllPendingNotes, p_DisableCounter | 2 | 0 |
| `DeactivateNoteInDB` | method | p_NotesCode | 1 | 0 |
| `ActivateNoteInDB` | method | p_NotesCode | 1 | 0 |
| `GetLastNMCodes` | method | p_NotesCode | 1 | 0 |
| `GetNotesfromMsgCentreCount` | method |  | 0 | 0 |
| `GetTemplateDetailsFromVchType` | method | p_VchType | 1 | 0 |
| `CheckTemplateNameExist` | method | p_udtTemplate | 1 | 0 |
| `VchCodeExist` | method | p_VchCode | 1 | 0 |
| `CheckTemplateVchCodeExist` | method | p_VchCode | 1 | 0 |
| `AddInTemplateTable` | method | p_udtTemplate | 1 | 0 |
| `DeletedTemplateEntry` | method | p_VchCode | 1 | 0 |
| `DeleteVchTemplateTagging` | method | p_VchCode | 1 | 0 |
| `GetRevisionNo` | method |  | 0 | 0 |
| `SortItemsInCol` | method | p_Col | 1 | 0 |
| `TemplateName2VchCode` | method | p_TemplateName, p_VchType | 2 | 0 |
| `VchCode2TemplateName` | method | p_VchCode | 1 | 0 |
| `GetAmountTypeNo2Str` | method | p_Type | 1 | 0 |
| `GetAmountTypeStr2No` | method | p_TypeStr | 1 | 0 |
| `GetSalesTaxTypeNo2Str` | method | p_Type | 1 | 0 |
| `GetSalesTaxTypeStr2No` | method | p_TypeStr | 1 | 0 |
| `LoadAllTaggedVchForMaster` | method | p_MasterCode | 1 | 0 |
| `SaveMasterTemplateTagging` | method | p_ColTagging, p_MasterCode | 2 | 0 |
| `GetUserLog` | method | p_CompCode, p_CompNames, p_UserNames, p_Dates | 4 | 0 |
| `DeleteMastFootPrint` | method | p_Code | 1 | 0 |
| `LoadTransporterID` | method | p_RecType | 1 | 0 |
| `LoadAllTransporterIDFromLst` | method | p_RecType, p_Col | 2 | 0 |
| `GetVoucherSeriesGrpQry` | method | p_VchSeriesGrpCode, p_VchStr | 2 | 0 |
| `GetVoucherSeriesGroupCount` | method |  | 0 | 0 |
| `LoadMultiplecompDet` | method | p_State | 1 | 0 |
| `Num2Fig` | method | p_Num, p_CurSubString, p_CurDecimal | 3 | 0 |
| `LoadImageFormDatabase` | method | p_Code, p_Type | 2 | 0 |
| `GetAmtRoundedOff` | method | p_Amt, p_RoundOffType | 2 | 0 |
| `GetRoundedOffBSAmt` | method | p_Amt, p_RoundOffType, p_RoundOffNearestTo | 3 | 0 |
| `GetVchConfigInfoData` | method | p_SeriesCode, p_DontCheckStamp | 2 | 0 |
| `GetLastYearDBCon` | method | p_db, p_Con | 2 | 0 |
| `GetDBNameFromConnectString` | method | p_str | 1 | 0 |
| `GetBasePerAltCurConRate` | method | p_CurConRate, p_CurConType | 2 | 0 |
| `BrokerSMNameString` | method | p_Prulal | 1 | 0 |
| `BrokerageCommissionString` | method | p_Mode | 1 | 0 |
| `GetSeconLangFldsCol` | method |  | 0 | 0 |
| `GetParamDetailsFromBCN` | method | p_BCNStr, p_ItemCode, p_MCCode, p_ParamData | 4 | 0 |
| `ItemParamStockUdt2Rst` | method | p_rst | 1 | 0 |
| `GetAllItemsForSrNo` | method | p_SrNo, p_MCCode | 2 | 0 |
| `GetAllItemsForBatchNo` | method | p_BatchNo, p_MCCode | 2 | 0 |
| `GetItemBatchNoClosingStk` | method | p_BatchNo, p_ItemCode, p_MCCode, p_AltBal | 4 | 0 |
| `ItemSerialNumberUdt2Rst` | method | p_rst | 1 | 0 |
| `GetTransporterID` | method | p_Trans | 1 | 0 |
| `LoadBDEPBlockDataFromXML` | method | p_XMLStr | 1 | 0 |
| `ChkPartyMobileUserIDExist` | method | p_AccCode, p_UserID | 2 | 0 |
| `GetLastUIDForEventLog` | method |  | 0 | 0 |
| `SaveEventLOG` | method | p_udtLog | 1 | 0 |
| `GetServerDate` | method |  | 0 | 0 |
| `TrimMemoFieldforAccess` | method | p_str | 1 | 0 |
| `GetPenForms` | method | p_PartyCode, p_FormCode, p_FormType | 3 | 0 |
| `GetVchHeaderFromXMLStr` | method | p_VchType, p_XMLStr | 2 | 0 |
| `IsVchExist` | method | p_ModifyOptions, p_VchNo, p_VchDate, p_VchSeriesCode, p_VchCode, p_VchType, p_PartyCode | 7 | 0 |
| `FullMonthStr2No` | method | strMonth | 1 | 0 |
| `InitUdtCallVchData` | method | p_udt | 1 | 0 |
| `GetFldValFromObject` | method | p_rst, p_Node, p_FldName, p_ReadSource, p_FldType | 5 | 0 |
| `GetVchOrgAndModAmount` | method | p_VchCode, p_VchModAmt | 2 | 0 |
| `GetContactCodeFromCallNo` | method | p_CallNo | 1 | 0 |
| `CheckLimitationForAutomaticVchNo` | method | p_udtVchData, p_udtVchNum, p_StrMsg, p_Warning, p_Date | 5 | 0 |
| `CheckLimitationForAutomaticCallNo` | method | p_udtVchData, p_udtVchNum, p_StrMsg, p_Warning, p_Date | 5 | 0 |
| `MessageForAutomaticVchNo` | method | p_udtVchNum, p_Warning, p_Date | 3 | 0 |
| `UpdateCheckListDetails` | method | p_InputMode, p_ModifyObj, p_SyncApprovalDetails, p_ApprovalDetails, p_Type | 5 | 0 |
| `GetVchSyncStatus` | method | p_Source, p_InputMode | 2 | 0 |
| `SaveCheckListDet` | method | p_Type, p_InputMode, p_ModifyEntry, p_Code, p_udtApprovalDet, p_OldApprovalStatus, p_Action, p_Source | 8 | 0 |
| `DeleteAuditCheckListDet` | method | p_Type, p_Code | 2 | 0 |
| `SaveNewCheckListEntry` | method | p_Type, p_Code, p_Action, p_udtApproval, p_Source | 5 | 0 |
| `SaveUserLOG` | method | p_udtLog | 1 | 0 |
| `AddToDeletedInfo` | method | p_Type, p_VchMastType, p_Identity, p_VchOrgAmt, p_VchModAmt, p_Source, p_DeletedBy, p_DeletionTime | 8 | 0 |
| `GetVchImageFolderPath` | method | p_VchSeriesCode | 1 | 0 |
| `GetVchNumInfoData` | method | p_SeriesCode | 1 | 0 |
| `CheckForBlankDuplicateVchNo` | method | p_udtVchNum, p_VchSeriesCode, p_VchCode, p_VchNo, p_VchDate, p_InputMode, p_Errstr, p_PartyCode, p_Trantype, p_VchType | 10 | 0 |
| `DeleteImageFormDatabase` | method | p_Code, p_Type | 2 | 0 |
| `RemoveSpecialCharFromString` | method | p_str, p_RemChar | 2 | 0 |
| `GetRightsMsg` | method |  | 0 | 0 |
| `ItemDataRST2UDTNew` | method | p_rst, p_ItemNode, p_ReadSource | 3 | 0 |
| `RaiseTriggerFromCallVch` | method | p_udtCallVchData, p_udtOldVchData, p_InputMode, p_DeleteVch | 4 | 0 |
| `LoadSMSAPI` | method | p_APIName | 1 | 0 |
| `SaveOfflineMessage` | method | p_MessageStr, p_Type, p_WorkinBG, p_SMSMode | 4 | 0 |
| `GetEmailOfflineStr` | method | p_RepOpt | 1 | 0 |
| `CreateNotificationToSend1` | method | p_MobNo, p_Message, p_ErrMsg, p_AttachmentLink | 4 | 0 |
| `FormatMobileNo` | method | p_MobNo, p_udtSMSAPI | 2 | 0 |
| `CheckAccountDependency` | method | p_Condition | 1 | 0 |
| `RaiseTriggerFromCallVchFromFormat` | method | p_udtCallVchData, p_udtOldVchData, p_InputMode, p_DeleteVch | 4 | 0 |
| `Name2MasterRange` | method | p_strName | 1 | 0 |
| `MasterRange2Name` | method | p_MRange | 1 | 0 |
| `ChkMobileUserExist` | method | p_UserName, p_Errstr | 2 | 0 |
| `MasterType2Name` | method | p_MasterType, p_LoadSavedCaptionFlag | 2 | 0 |
| `GetFinYrStr` | method |  | 0 | 0 |
| `SaveBDEPDataExportImportConfig` | method | p_RecType, p_MastData, p_BdepData | 3 | 0 |
| `LoadBDEPDataExportImportConfig` | method | p_RecType, p_MastData, p_BdepData | 3 | 0 |
| `CheckSpecialForImageName` | method | p_str | 1 | 0 |
| `CheckSpecialCharForBDEPName` | method | p_str, p_SplChar | 2 | 0 |
| `GetBranchMasterCol` | method |  | 0 | 0 |
| `GetMCCodePriceForNewRefs` | method | p_RefCode, p_PriceMain, p_PriceAlt | 3 | 0 |
| `IfCancelRefExist` | method | p_RefCode, p_Qty, p_AltQty | 3 | 0 |
| `GetPendingOrderRefCol` | method | p_Date1, p_VchType, p_RefType, p_AccCode, p_ItemCode, p_AccRange, p_ItemRange, p_MCCode, p_MCRange, p_Trantype | 10 | 0 |
| `GetPayeeTDSCategroyDetails` | method | p_PartyCode, p_TDSCatCode, p_Date | 3 | 0 |
| `GetTDSAmtRoundedOff` | method | p_Amt, p_AmtType | 2 | 0 |
| `SaveReportNotes` | method | p_udt | 1 | 0 |
| `LoadReportNotes` | method | p_NoteRepID, p_Code, p_Date | 3 | 0 |
| `GetNewReportNoteID` | method |  | 0 | 0 |
| `UpdateReportNotes` | method | p_NoteID, p_Description, p_NoteDate | 3 | 0 |
| `LoadReportNotes4NoteID` | method | p_NoteID | 1 | 0 |
| `DeleteReportNote4NoteID` | method | p_NoteID, p_AccCode | 2 | 0 |
| `AddEntryToTran7` | method | p_MastCode | 1 | 0 |
| `GenQryInStrForParentGrps` | method | p_GrpCode, p_GrpType | 2 | 0 |
| `GSPSelectionService` | method | p_Report, p_GSTNo, p_IsDownload | 3 | 0 |
| `EventNotiNo2Str` | method | p_No | 1 | 0 |
| `EventNotiStr2No` | method | p_str | 1 | 0 |
| `GetMastTypeCol` | method |  | 0 | 0 |
| `GetMasterMsgForEventNotification` | method | p_udtEvent | 1 | 0 |
| `CheckVchNo4SalePurcRetValidation` | method | p_VSCode, p_VchNo, p_VchType, p_PartyCode, p_VchCode, p_TaxAmt, p_TaxableAmt, p_VchDate, p_ValidateVchNo, p_TaxBeforeSchg, p_TaxBeforeSchg1, p_STPTType, p_SchgAmt, p_AddSchgAmt, p_ItemCode, p_UnitName, p_HSNCode, p_VchYear, p_ValidateDate | 19 | 0 |
| `IfMultiCurrencyEnableInAccMast` | method | p_AccCode | 1 | 0 |
| `GetMastCountColForCompanyUsage` | method | p_ItemsCount, p_AccountsCount | 2 | 0 |
| `GetBOMDetails` | method | p_BOMName, p_UnitName, p_ItemName | 3 | 0 |
| `GetLastBankName` | method | p_RecType, p_BankCode | 2 | 0 |
| `GetForcedCheckListYear` | method |  | 0 | 0 |
| `InitUDTDSMast` | method | p_DSMast | 1 | 0 |
| `GetCompoundDiscStrWithBasis` | method | p_CompDiscStr, p_udtStructure, p_MainUnit, p_AltUnit, p_PackUnit | 5 | 0 |
| `GetCompoundDiscStrWithNotation` | method | p_CompDiscStr, p_udtStructure | 2 | 0 |
| `UpdateItemWiseDiscount` | method | p_ItemData, p_Discount, p_CompDisc | 3 | 0 |
| `UpdateItemWiseMarkUp` | method | p_ItemData, p_MarkUp, p_CompMarkUp | 3 | 0 |
| `GetSimpleDiscFromCompoundDisc` | method | p_CompoundDisc, p_DiscountBasis | 2 | 0 |
| `GetCompoundDiscFromSimpleDisc` | method | p_DiscStructure, p_DiscPercent, p_DiscAmt | 3 | 0 |
| `GetCompoundDiscStrWithoutNotation` | method | p_CompDiscStr, p_udtStructure | 2 | 1 |
| `GetAllBankAccStr` | method |  | 0 | 0 |
| `CheckIfParameterExistForReference` | method | p_RefCode | 1 | 0 |
| `GetExpCodeFromRefCodeofTDS` | method | p_RefCode | 1 | 0 |
| `GetExpCodeFromRefCodeofTCS` | method | p_RefCode | 1 | 0 |
| `GetFirstValidMobNofromMobileStr` | method | p_MobileNoStr | 1 | 0 |
| `GetRecordCountForParameterizedStockAutoConfigured` | method | p_ParamNo, p_Mastertype1, p_MasterCode1, p_MasterType2, p_MasterCode2, p_RepDate | 6 | 0 |
| `GetWhereClauseStr` | method | p_MasterType, p_MasterCode, p_Alias | 3 | 0 |
| `GetItemGroupHSN` | method | p_GrpCode | 1 | 0 |
| `GetTCSBSFromAccountNature` | method | p_Code | 1 | 0 |
| `GetTCSAccountOfTCSNature` | method | p_Code | 1 | 0 |
| `CheckForBillByBillNewRef` | method | p_AccEntries | 1 | 0 |
| `FlushBillByBillNewRefForPDC` | method | p_AccEntries, p_PendingBills | 2 | 0 |
| `UpdateT2ApprovalStatusOfApprovedVchs` | method | p_VchCode | 1 | 0 |
| `SaveTransportIDDet` | method | p_TransporterName, p_TransporterID | 2 | 0 |
| `GetStateTransportJSON` | method | p_RecType, p_TransporterName, p_TransporterID | 3 | 0 |
| `GetTransporterFlD` | method | p_Trans, p_Fld | 2 | 0 |
| `GetTaxTypeFromAccCode` | method | p_AccCode | 1 | 0 |
| `TranExistForPartyStateCode` | method | p_PartyCode, p_StateCode | 2 | 0 |
| `ReverseChargeType2String` | method | p_Type, p_Flag | 2 | 0 |
| `ReverseChargeString2Type` | method | p_str | 1 | 0 |
| `GetCreditedAccNameFromTaxType` | method | p_TaxType | 1 | 0 |
| `ParameterizedStockFormatNameExist` | method | p_PRID, p_FormatName | 2 | 0 |
| `GetMultiAliasData` | method | p_Fld, p_MastCode, p_MultiAliasName | 3 | 0 |
| `CheckIfConIDExistInSaleOrder` | method | p_ConId, p_VchType, p_Trantype | 3 | 0 |
| `GetBranchCodeFromRefcode` | method | p_RefCode, p_RecType | 2 | 0 |
| `SelectTDSBS` | method |  | 0 | 0 |
| `LoadVchSeriesGrpConfig` | method | p_VchSerGrpConfig | 1 | 0 |
| `ValidateVchSeries4CSUser` | method | p_VchSeriesStr, p_VchType, p_InputMode, p_OldVchSeriesCode, p_ErrMsg | 5 | 0 |
| `LoadSTPTMast4CSUser` | method | p_LocType | 1 | 0 |
| `CheckIfVchExist4CSData` | method | p_VchType, p_VchNo, p_VSCode, p_VchCode | 4 | 0 |
| `GetAuthToken` | method |  | 0 | 0 |
| `QryUsedForNepal` | method | p_StrQry | 1 | 0 |
| `ArrayToJSON` | method | Arr | 1 | 0 |
| `GetJsonStrForClearOrAutoAdjRef` | method | p_RefData | 1 | 0 |
| `GetGoogleSpreadSheetIdFromLink` | method | p_URL | 1 | 0 |
| `GetSheetIDFromLink` | method | p_URL | 1 | 0 |
| `SaveInBulk4BillingShippingDet` | method | p_VchCode, p_BillingDet | 2 | 0 |
| `RaiseCloudSyncError` | method | p_ErrToBeTracked, p_ErrToBeShown, p_EventID | 3 | 0 |
| `UpdateDownloadStatusInBusy` | method | p_AutoCode, p_Status, p_RecType, p_Errstr, p_ErrCode | 5 | 0 |
| `DownloadDataFromMobileApp` | method | p_UID, p_ServiceURL, p_Errstr, p_SC, p_ErrOrigin, p_ErrCode | 6 | 0 |
| `SaveMobileAppVchEntriesInBusy` | method | p_AutoCode, p_JSONStr, p_RecType, p_Errstr, p_ErrOrigin, p_ErrCode | 6 | 0 |
| `DeleteMobileAppVchFromBusy` | method | p_AutoCode, p_RecType, p_Errstr, p_ErrOrigin, p_ErrCode | 5 | 0 |
| `UpdateVchStatusInCloudDB` | method | p_Status, p_AutoCode, p_ServiceURL, p_UID, p_ComputerName, p_CompCode, p_Errstr, p_SC, p_ErrOrigin, p_ErrCode | 10 | 0 |
| `CheckIfDataExistForDownload` | method |  | 0 | 0 |
| `DeleteSyncedDataFromBusy` | method | p_ServiceURL, p_UID, p_Errstr, p_SC, p_ErrOrigin, p_ErrCode | 6 | 0 |
| `LoadMobileAppVchEntries` | method | p_JsonStrCol, p_RecType, p_Errstr | 3 | 0 |
| `GetApprovalStatusFromBusy` | method | p_Code, p_Type, p_MastVch | 3 | 0 |
| `InvVch` | method | p_VchType | 1 | 0 |
| `GetJsonStrForTransportDet` | method | p_VchCode, p_OtherInfo | 2 | 0 |
| `GetJsonStrForBillingShippingDet` | method | p_VchCode, p_BillingDet | 2 | 0 |
| `SaveInBulk4VchOptField` | method | p_VchCode, p_VchOtherInfo | 2 | 0 |
| `GetFinYearInDateExist` | method | p_Date | 1 | 0 |
| `DeleteData4AccountFreezing` | method |  | 0 | 0 |
| `SaveFreezeConfig4Account` | method | p_MasterType, p_Accol, p_Date | 3 | 0 |
| `Config4AccFreeze` | method | p_udtfreezeConfig | 1 | 0 |
| `GetFreezeAccount` | method |  | 0 | 0 |
| `GetFreezeAccountType` | method | p_AccRange, p_AccGrpCode | 2 | 0 |
| `SaveDataImportExportUserLog` | method | p_MenuConst, p_AddInfo, p_TypeConst, p_AddEventInfo | 4 | 0 |
| `RemoveNotationFromCompoundDiscStr` | method | p_CompDiscStr | 1 | 0 |

