<!-- generated from DBDesign.xls by scripts/docs/xls_to_md.py -->
# DBDesign.xls

## DB

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  |  |  |  |  |
| Structure of DB.mdb |  |  |  |  |
|  |  |  |  |  |
|  | Table Name : |  |  | Company |
|  |  |  |  |  |
|  | Description: This table stores information about one Company created using BusyWin |  |  |  |
|  | Application. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | Name | Text | 40 | Stores Name of the company |
|  | PrintName | Text | 40 | Stores the Print Name of the company |
|  | Address1 | Text | 40 | Stores 1st Address line of Company |
|  | Address2 | Text | 40 | Stores 2nd Address line of Company |
|  | Address3 | Text | 40 | Stores 3rd Address line of Company |
|  | Address4 | Text | 40 | Stores 4th Address line of Company |
|  | TelNo | Text | 40 | Stores Tel. No. of Company |
|  | Fax | Text | 30 | Stores Fax No of Company |
|  | Email | Text | 40 | Stores e-mail ID for company |
|  | ITPAN | Text | 20 | Stores IT PAN No for Company |
|  | ITWARD | Text | 20 | Stores IT WARD name for company |
|  | LST | Text | 30 | Stores LST No of company |
|  | CST | Text | 30 | Stores CST No of company |
|  | ST_37 | Text | 30 | Stores ST-37 No of company |
|  | ExciseRegNo | Text | 30 | Stores Excise Reg. No. of company |
|  | ECCCode | Text | 20 |  |
|  | PLANo | Text | 20 |  |
|  | Range | Text | 80 |  |
|  | Division | Text | 80 |  |
|  | Collectorate | Text | 40 |  |
|  | CreatedOn | Date/Time |  |  |
|  | Serial No | Text | 20 |  |
|  | BegFY | Date/Time |  |  |
|  | CurFY | Date/Time |  |  |
|  | BooksStart | Date/Time |  |  |
|  | FreezDate | Date/Time |  |  |
|  | ProductName | Text | 10 | Stores Name of Busy Application using which this Databbase was created |
|  | Major | Integer |  | Stores Major Version of Busy Application |
|  | Minor | Integer |  | Stores Minor Version of Busy Application |
|  | Revision | Text | 1 | Stores Revision No. of Busy Application |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name : |  |  | UserPreferences |
|  |  |  |  |  |
|  | Description: This table stores information about the users of a company in BusyWin. |  |  |  |
|  | This table also stores the information about UserName, Password and the various permissions to  |  |  |  |
|  | the user. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | Name | Text | 20 | Stores Name of the User |
|  | SuperUser | Boolean |  | Specifies whether user is SuperUser or not |
|  | CanModifyMaster | Boolean |  |  |
|  | CanModifyVoucher | Boolean |  |  |
|  | CanEditComp | Boolean |  |  |
|  | CanBackupComp | Boolean |  |  |
|  | CanChangePrice | Boolean |  |  |
|  | DosDrvName | Text | 20 | Stores DOS Name for Default Printer  |
|  | WinDrvName | Text | 255 | Stores Windows Name for Default Printer |
|  | PageLen | Integer | 20 |  |
|  | LinesPerPage | Integer | 20 |  |
|  | PrintType | Integer | 30 |  |
|  | UserPassword | Text | 100 | Stores Password for User |
|  | B1-B200 | Boolean |  | Store Boolean values for permissions to the User |
|  | PI1-PI20 | Integer |  | Stores the ASCII values for Password Chars |
|  | L1-L20 | Long Integer |  |  |
|  | PI | Integer |  | Stores Number of Characters in User Password |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name : |  |  | PrinterReps |
|  |  |  |  |  |
|  | Description: This table stores information about the standard scripts for Printing Documents. |  |  |  |
|  | This table also stores custom Scripts for Document Printing saved by the users of BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RepID | Integer |  |  |
|  | Name | Text | 20 |  |
|  | RepSubID | Integer |  |  |
|  | ScriptLine | Text | 255 |  |
|  | SrNo | Integer |  |  |
|  | I1-I10 | Integer |  |  |
|  | B1-B10 | Boolean |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name : |  |  | ScreenReps |
|  |  |  |  |  |
|  | Description: This table stores information about the standard scripts for Screen Documents. |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RepID | Integer |  |  |
|  | Name | Text | 20 |  |
|  | RepSubID | Integer |  |  |
|  | ScriptLine | Text | 255 |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name : |  |  | StdNar |
|  |  |  |  |  |
|  | Description: This table stores standard Narrations for various transactions in BusyWin. |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchType | Integer |  |  |
|  | Narration1 | Text | 94 |  |
|  | Narration2 | Text | 94 |  |

## DB1

| col0 | col1 | col2 | col3 | col4 |
|---|---|---|---|---|
|  |  |  |  |  |
| Structure of DB1.mdb |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Config |
|  |  |  |  |  |
|  | Description: This table stores information about Configuaration Settings for a Company in  |  |  |  |
|  | BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RecType | Integer |  |  |
|  | Type | Integer |  |  |
|  | C1-C12 | Text | 20 |  |
|  | DocName | Text | 20 |  |
|  | InvVchName | Text | 20 |  |
|  | FaVchName | Text | 20 |  |
|  | I1-I20 | Integer |  |  |
|  | NoOfFld | Integer |  |  |
|  | B1-B60 | Boolean |  |  |
|  | L1-L10 | Long Integer |  |  |
|  | CM1 | Long Integer |  |  |
|  | D1-D5 | Double |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | MasterSupport |
|  |  |  |  |  |
|  | Description: This table stores the information about Raw Material and By-Products as  |  |  |  |
|  | applicable to a Bill of Material in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | MasterCode | Long Integer |  |  |
|  | CM1 | Long Integer |  |  |
|  | CM2 | Long Integer |  |  |
|  | D1-D3 | Double |  |  |
|  | I1-I3 | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | MasterType | Integer |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Master1 |
|  |  |  |  |  |
|  | Description: This table stores information about all the masters of a Company in BusyWin. |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | Code | Long Integer |  |  |
|  | MasterType | Integer |  |  |
|  | Name | Text | 40 |  |
|  | Alias | Text | 40 |  |
|  | PrintName | Text | 40 |  |
|  | ParentGrp | Long Integer |  |  |
|  | Stamp | Long Integer |  |  |
|  | CM1-CM5 | Long Integer |  |  |
|  | D1-D10 | Double |  |  |
|  | I1-I10 | Integer |  |  |
|  | Level | Integer |  |  |
|  | SrNo | Integer |  |  |
|  | B1-B10 | Boolean |  |  |
|  | C1 | Text | 80 |  |
|  | CreatedBy | Text | 255 |  |
|  | CreationTime | Date/Time |  |  |
|  | ModifiedBy | Text | 255 |  |
|  | ModificationTime | Date/Time |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Folio1 |
|  |  |  |  |  |
|  | Description: This table stores the information pertaining to Budgets and Targets for Accounts |  |  |  |
|  | and Account Groups of a Company in BusyWin, |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | MasterCode | Long Integer |  |  |
|  | MasterType | Integer |  |  |
|  | D1-D150 | Double |  | Stores Amount Value for Budgets & Targets. |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | MasterAddressInfo |
|  |  |  |  |  |
|  | Description: This table stores the address information for masters of a Company in BusyWin, |  |  |  |
|  | Wherever Applicable. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | MasterCode | Long Integer |  |  |
|  | Address1 | Text | 40 |  |
|  | Address2 | Text | 40 |  |
|  | Address3 | Text | 40 |  |
|  | Address4 | Text | 40 |  |
|  | TelNo | Text | 40 |  |
|  | Fax | Text | 30 |  |
|  | Email | Text | 40 |  |
|  | LST | Text | 30 |  |
|  | CST | Text | 30 |  |
|  | ST37 | Text | 30 |  |
|  | ITPAN | Text | 20 |  |
|  | ITWARD | Text | 20 |  |
|  | Contact | Text | 40 |  |
|  | ExciseRegNo | Text | 30 |  |
|  | ECCCode | Text | 20 |  |
|  | PLANo | Text | 20 |  |
|  | Division | Text | 80 |  |
|  | Range | Text | 80 |  |
|  | Collectorate | Text | 40 |  |
|  | OF1-OF10 | Text | 20 | These store data for Optional Fields of Acc. |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Help1 |
|  |  |  |  |  |
|  | Description: This table stores the Names and Alias of the Masters of a Company in BusyWin, |  |  |  |
|  | so that they can easily be browsed through, during various operations. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RecType | Integer |  | Stores RecType to identify master type |
|  | NameAlias | Text | 40 | Stores Name or Alias of Master |
|  | Code | Long Integer |  | Stores MasterCode of the Master |
|  | MasterType | Integer |  | Stores MasterType of the master |
|  | NameOrAlias | Integer |  | Identifies value of NameAlias as Name or Alias. |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran1 |
|  |  |  |  |  |
|  | Description: This table stores the information pertaining to Header Enteries of a transaction   |  |  |  |
|  | in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Long Integer |  |  |
|  | VchType | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | StockUpdationDate | Date/Time |  |  |
|  | Status | Integer |  |  |
|  | VchNo | Text | 25 |  |
|  | VchSeriesCode | Long Integer |  |  |
|  | MasterCode1 | Long Integer |  |  |
|  | MasterCode2 | Long Integer |  |  |
|  | Stamp | Long Integer |  |  |
|  | AutoVchNo | Long Integer |  |  |
|  | CM1-CM5 | Long Integer |  |  |
|  | FormRecAmt | Double |  |  |
|  | FormIssAmt | Double |  |  |
|  | CurConRate | Double |  |  |
|  | ExciseApplicable | Boolean |  |  |
|  | ExciseDocName | Text | 15 |  |
|  | ExciseValue | Double |  |  |
|  | ExciseType | Integer |  |  |
|  | ExcisableAmount | Double |  |  |
|  | ExciseRate | Double |  |  |
|  | FormRecStatus | Integer |  |  |
|  | FormIssStatus | Integer |  |  |
|  | ChallanStatus | Integer |  |  |
|  | CreatedBy | Text | 255 |  |
|  | CreationTime | Date/Time |  |  |
|  | AthourisedBy | Text | 255 |  |
|  | AthourisationTime | Date/Time |  |  |
|  | ModifiedBy | Text | 255 |  |
|  | ModificationTime | Date/Time |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran2 |
|  |  |  |  |  |
|  | Description: This table stores the information pertaining to Footer Entries of a ttransaction   |  |  |  |
|  | in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RecType | Integer |  |  |
|  | VchCode | Long Integer |  |  |
|  | MasterCode1 | Long Integer |  |  |
|  | MasterCode2 | Long Integer |  |  |
|  | SrNo | Integer |  |  |
|  | VchType | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | VchNo | Text | 25 |  |
|  | VchSeriesCode | Long Integer |  |  |
|  | Value1 | Double |  |  |
|  | Value2 | Double |  |  |
|  | Value3 | Double |  |  |
|  | Balance1 | Double |  |  |
|  | Balance2 | Double |  |  |
|  | Balance3 | Double |  |  |
|  | ItemBal1 | Double |  |  |
|  | ItemBal2 | Double |  |  |
|  | ItemBal3 | Double |  |  |
|  | CashFlow | Double |  |  |
|  | ShortNar | Text | 40 |  |
|  | D1-D13 | Double |  |  |
|  | CM1-CM6 | Long Integer |  |  |
|  | B1-B3 | Boolean |  |  |
|  | ClrDate | Date/Time |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran3 |
|  |  |  |  |  |
|  | Description: This table stores the information pertaining to various Bill-By-Bill, Batch or Order  |  |  |  |
|  | References of a transaction in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RefCode | Long Integer |  |  |
|  | RecType | Integer |  |  |
|  | Method | Integer | 15 |  |
|  | VchCode | Long Integer |  |  |
|  | VchType | Integer |  |  |
|  | MasterCode1 | Long Integer |  |  |
|  | MasterCode2 | Long Integer |  |  |
|  | SrNo | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | DueDate | Date/Time |  |  |
|  | No | Text | 25 |  |
|  | Status | Integer |  |  |
|  | Type | Integer |  |  |
|  | BrokerCode | Long Integer |  |  |
|  | Value1 | Double |  |  |
|  | Value2 | Double |  |  |
|  | Value3 | Double |  |  |
|  | Balance1 | Double |  |  |
|  | Balance2 | Double |  |  |
|  | Balance3 | Double |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | BillingDet |
|  |  |  |  |  |
|  | Description: This table stores the Name and Address of a party to be reflected in Bills of a   |  |  |  |
|  | transaction in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Integer |  |  |
|  | PartyName | Text | 40 |  |
|  | Address1 | Text | 40 |  |
|  | Address2 | Text | 40 |  |
|  | Address3 | Text | 40 |  |
|  | Address4 | Text | 40 |  |
|  | Table Name: |  |  | Excise |
|  |  |  |  |  |
|  | Description: This table stores the information pertaining to Excise Details of a transaction   |  |  |  |
|  | with an Account in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RecType | Integer |  |  |
|  | VchCode | Long Integer |  |  |
|  | DocName | Text | 15 |  |
|  | VchNo | Text | 25 |  |
|  | SrNo | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | Value | Double |  |  |
|  | Balance | Double |  |  |
|  | Value1 | Double |  |  |
|  | Balance1 | Double |  |  |
|  | ValueType | Integer |  |  |
|  | Dummy | Integer |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | OEDDet |
|  |  |  |  |  |
|  | Description: This table stores the information pertaining to Additional Excise Duty on Basic    |  |  |  |
|  | Excise as applied on a transaction in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Long Integer |  |  |
|  | OEDRate | Double |  |  |
|  | OEDAmount | Double |  |  |
|  | D1 | Double |  |  |
|  | I1 | Integer |  |  |
|  | L1 | Long Integer |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | ItemDesc |
|  |  |  |  |  |
|  | Description: This table stores the descriptions of Items pertaining toa transaction  in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Long Integer |  |  |
|  | SrNo | Integer |  |  |
|  | Desc1-Desc4 | Text | 40 |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran4 |
|  |  |  |  |  |
|  | Description:  |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | SrNo | Long Integer |  |  |
|  | MasterCode1 | Long Integer |  |  |
|  | MasterCode2 | Long Integer |  |  |
|  | D1-D3 | Double |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran5 |
|  |  |  |  |  |
|  | Description: This table stores details of Cost Center Entries applicabe for a given transaction in |  |  |  |
|  | BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Long Integer |  |  |
|  | MasterCode1 | Long Integer |  |  |
|  | SrNo | Integer |  |  |
|  | VchType | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | VchNo | Text | 25 |  |
|  | VchSeriesCode | Long Integer |  |  |
|  | Value1 | Double |  |  |
|  | Value2 | Double |  |  |
|  | Balance1 | Double |  |  |
|  | Balance2 | Double |  |  |
|  | TranType | Integer |  |  |
|  | ShortNar | Text | 40 |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran6 |
|  |  |  |  |  |
|  | Description: |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | SrNo | Long Integer |  |  |
|  | MasterCode1 | Long Integer |  |  |
|  | MasterCode2 | Long Integer |  |  |
|  | StockType | Integer |  |  |
|  | D1-D3 | Double |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran8 |
|  |  |  |  |  |
|  | Description: This table stores information about the forms received from a party as per a  |  |  |  |
|  | transaction in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Long Integer |  |  |
|  | VchType | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | FormRecDate | Date/Time |  |  |
|  | FormNo | Text | 25 |  |
|  | PartyCode | Long Integer |  |  |
|  | FormCode | Long Integer |  |  |
|  | Stamp | Long Integer |  |  |
|  | Nar1 | Text | 94 |  |
|  | AutoVchNo | Long Integer |  |  |
|  | CreatedBy | Text | 255 |  |
|  | CreationTime | Date/Time |  |  |
|  | AthourisedBy | Text | 255 |  |
|  | AthourisationTime | Date/Time |  |  |
|  | ModifiedBy | Text | 255 |  |
|  | ModificationTime | Date/Time |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Tran9 |
|  |  |  |  |  |
|  | Description: This table stores information about the forms issued to a party as per a  |  |  |  |
|  | transaction in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Long Integer |  |  |
|  | PartyCode | Long Integer |  |  |
|  | FormCode | Long Integer |  |  |
|  | SrNo | Integer |  |  |
|  | VchType | Integer |  |  |
|  | Date | Date/Time |  |  |
|  | FormNo | Text | 25 |  |
|  | BillCode | Long Integer |  |  |
|  | Amount | Double |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | VchOtherInfo |
|  |  |  |  |  |
|  | Description: This table stores information about the Optional Fierlds, Transportation Details & |  |  |  |
|  | other information related to a transaction in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | VchCode | Long Integer |  |  |
|  | OF1-OF10 | Text | 20 |  |
|  | Transport | Text | 20 |  |
|  | Station | Text | 20 |  |
|  | GRNo | Text | 20 |  |
|  | VehicleNo | Text | 20 |  |
|  | ItemDesc | Text | 20 |  |
|  | Form31No | Text | 20 |  |
|  | Form31IssuedOn | Text | 20 |  |
|  | TotalQty | Text | 20 |  |
|  | PurchaseBillNo | Text | 20 |  |
|  | PurchaseBillDate | Text | 20 |  |
|  | Narration1 | Text | 94 |  |
|  | Narration2 | Text | 94 |  |
|  | InvoicePrepTime | Text | 25 |  |
|  | GoodsRemovalTime | Text | 25 |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Help2 |
|  |  |  |  |  |
|  | Description: This table stores the information of the vouchers of a Company in BusyWin, |  |  |  |
|  | so that this information can easily be browsed through, during various operations. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | RecType1 | Integer |  |  |
|  | RecType2 | Integer |  |  |
|  | RecType3 | Long Integer |  |  |
|  | Name | Text  | 40 |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | DeletedInfo |
|  |  |  |  |  |
|  | Description: This table stores the information about the delected vouchers and masters of a  |  |  |  |
|  | Company in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | Type | Integer |  |  |
|  | VchMastType | Integer |  |  |
|  | Identity | Text | 50 |  |
|  | DeletedBy | Text | 20 |  |
|  | DeletionTime | Date/Time |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  | Table Name: |  |  | Locks |
|  |  |  |  |  |
|  | Description: This table stores the information about the locks applied to a table or database,   |  |  |  |
|  | in BusyWin. |  |  |  |
|  |  |  |  |  |
|  | Field Name | Type | Size | Description |
|  | Type | Date/Time |  |  |
|  | IBR | Boolean |  |  |
