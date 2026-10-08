Attribute VB_Name = "GlobalConstants"
Option Explicit

Public Const DEBUG_MODE = True ' False 'False
Public Const BETA_VER = False

Public Const ZERO_VAL = 0.000000001
Public Const MAX_NUM = 1000000000000#
Public Const MAX_TEMP_TABELS = 15

Public Const PRODUCT_LITE_NAME = "BUSYLITE"


Public Const PRODUCT_NAME = "BUSY"
Public Const MAJOR_VER = 3
Public Const MINOR_VER = 9
Public Const REVISION_NO = "g"
Public Const SUB_REVISION_NO = ""

Public Const SOURCE_NONE = 0
Public Const SOURCE_BO = 1
Public Const SOURCE_HO = 2

Public Const FORM_TOP = 450 '650
Public Const FORM_LEFT = 0
Public Const FORM_WIDTH = 1
Public Const FORM_HEIGHT = 9125

Public Const FORM_POS_TOP = 720
Public Const FORM_POS_LEFT = 150

Public Const DD_MM_YYYY = 1
Public Const MM_DD_YYYY = 2

Public Const TEMP_DEL_NEVER = 0
Public Const TEMP_DEL_ASK = 1
Public Const TEMP_DEL_AUTOMATICALLY = 2

Public Const STARTING_MASTER_CODE = 1000

Public Const SUBTRACT = 0
Public Const Add = 1
Public Const Modify = 2
Public Const ADD_ONE = 3
Public Const MULTIPLY = 4
Public Const DIVIDE = 5
Public Const EQUALS = 6

Public Const DISCOUNT_SIMPLE = 0
Public Const DISCOUNT_COMPOUND = 1

Public Const BS_ABSOLUTE = 0
Public Const BS_PERCENTAGE = 1
Public Const BS_MAINQTY = 2
Public Const BS_ALTQTY = 3

Public Const BS_BASIC_AMT = 0
Public Const BS_MRP_AMT = 1
Public Const BS_NETT_AMT = 2
Public Const BS_PREVBS_AMT = 4
Public Const BS_TOTAL_AMT = 5       ' To be used in Item-wise discounting
Public Const BS_TAXABLE_AMT = 6

Public Const REFS_NOTPENDING = 0
Public Const REFS_PAYABLE = 1
Public Const REFS_RECEIVABLE = 2

Public Const SBT_VOUCHER = 1
Public Const SBT_MASTER = 2
Public Const SBT_DONE = 3
Public Const SBT_DONE_HELP = 4
Public Const SBT_DONE_ADDNEW = 5
Public Const SBT_MASTER_WO_ADDNEW = 6
Public Const SBT_VOUCHER_WITHF4 = 7
Public Const SBT_VOUCHER_STFORMS = 8
Public Const SBT_VOUCHER_WITHOUT_F6 = 9

Public Const STREG_LOCAL = 1
Public Const STREG_CENTRAL = 2
Public Const STREG_ST37 = 3

Public Const READ_PASS = "24101995"     'J(07-11-07)
Public Const WRITE_PASS = "27121999"    'J

Public Const SENTRY_DONGLE = 1          'J
Public Const COPYLOCK_DONGLE = 2        'J

Public Const EDITION_ENTERPRISE = 99
Public Const EDITION_PREMIUM = 72
Public Const EDITION_STANDARD = 63
Public Const EDITION_BASIC = 45
Public Const EDITION_LITE = 36
Public Const EDITION_ULTRALITE = 27

Public Const BUSY_ADDON_ONE = "Item Bar Code Printing"      'J
Public Const BUSY_ADDON_TWO = ""
Public Const BUSY_ADDON_THREE = ""
Public Const BUSY_ADDON_FOUR = ""
Public Const BUSY_ADDON_FIVE = ""

Public Const FORMTAG_MASTER = "MASTER"
Public Const FORMTAG_VOUCHER = "VOUCHER"
Public Const FORMTAG_REPORT = "REPORT"
Public Const FORMTAG_REPOPTION = "REPOPTION"
Public Const FORMTAG_FULLFORM = "FULLFORM"

Public Const FORMSTATE_DATAENTRY = 0
Public Const FORMSTATE_GETTINGLOCKS = 1
Public Const FORMSTATE_SAVINGDATA = 2

Public Const NEUTRAL = 0
Public Const DEBIT = 1
Public Const CREDIT = 2

Public Const TARGET = 0
Public Const BUDGET = 1

Public Const MAX_LABEL_IN_ROW = 9


Public Const OP_EQUAL_TO = 1
Public Const OP_LESS_THEN = 2
Public Const OP_LESS_THEN_EQUAL_TO = 3
Public Const OP_GREATER_THEN = 4
Public Const OP_GREATER_THEN_EQUAL_TO = 5
Public Const OP_NOT_EQUAL_TO = 6
Public Const OP_IN_BETWEEN = 7
Public Const OP_HAVING = 8

Public Const FREEZE_FULL = 0
Public Const FREEZE_PARTIAL = 1

Public Const DEMO_REGULAR = 0
Public Const DEMO_EDUCATION = 1
Public Const DEMO_AUDITOR = 2

Public Const OP_APPLY_TO_ALL = 1            'Constants type for partial freezing
Public Const OP_APPLY_ON_SERIES = 2

Public Const SELECT_COMP_OPENDB = 1
Public Const SELECT_COMP_BACKUP = 2
Public Const SELECT_COMP_FM = 3
Public Const SELECT_COMP_DELETE = 4
Public Const SELECT_COMP_GETNAME = 5
Public Const SELECT_COMP_MULTICOMP = 6

Public Const SELECT_MASTER_MODIFY = 1
Public Const SELECT_MASTER_GETCODE = 2
Public Const SELECT_MASTER_PENDING_MI = 3
Public Const SELECT_MASTER_PENDING_MR = 4
Public Const SELECT_MASTER_PENDING_SO = 5
Public Const SELECT_MASTER_PENDING_PO = 6
Public Const SELECT_MASTER_TRADING_MODVAT_OB = 7
Public Const SELECT_STANDARD_DOCMENT = 8

Public Const VCHNUMBERING_AUTO = 1
Public Const VCHNUMBERING_MANUAL = 2
Public Const VCHNUMBERING_NA = 3

Public Const MANUALNUM_NOACTION = 1
Public Const MANUALNUM_WARNING = 0
Public Const MANUALNUM_NOTALLOWED = 2


Public Const RENUMBER_DAILY = 1
Public Const RENUMBER_MONTHLY = 2
Public Const RENUMBER_YEARLY = 3
Public Const RENUMBER_CARRYOVER = 4

Public Const SORT_NONE = 0
Public Const SORT_BY_ITEM = 1
Public Const SORT_BY_ITEM_GRP = 2
Public Const SORT_BY_MC = 3
Public Const SORT_BY_ITEM_AF = 4
Public Const SORT_BY_ITEM_OF1 = 5
Public Const SORT_BY_ITEM_OF2 = 6

' To be used for sales tax reports
Public Const AT_BILLAMT = 1         ' Bill Amount
Public Const AT_COSTOFGOODS = 2     ' Amount of items before bill sundries
Public Const AT_FORMAMT = 3         ' Amount of sales tax form receivale/issuuable
Public Const AT_TAXABLEAMT = 4      ' Amount on which the tax is charged


Public Const VCH_AMT_BILL_AMT = 1
Public Const VCH_AMT_ITEMS_BASIC_AMT = 2    ' Items amount w/o the effect of BS
Public Const VCH_AMT_ITEMS_NETT_AMT = 3     ' Items amount with the effect of BS

Public Const EXCISE_MFR = 0
Public Const EXCISE_TRADING = 1
Public Const EXCISE_BOTH = 2

Public Const SUPP_DUTY_PROPORTIONAL = 0
Public Const SUPP_DUTY_ACTUAL = 1

Public Const MAX_SK_HELP_LABELS = 25       ' Short Cut Keys Help Labels

' Constants for basis of ST Surcharge calculation
'Public Const SCTYPE_TAX = 0
'Public Const SCTYPE_BASICAMT = 1
Public Const SCTYPE_BASICAMT = 0
Public Const SCTYPE_TAX = 1
Public Const SCTYPE_MAINQTY = 2
Public Const SCTYPE_ALTQTY = 3
'Public Const SCTYPE_ITEMMRP = 5

Public Const EXPORT_EXCEL = 1
Public Const EXPORT_ACCESS = 2
Public Const EXPORT_TEXT_D1 = 3     ' D1 - Delimited Comma
Public Const EXPORT_HTML = 4
Public Const EXPORT_TEXT_F1 = 5     ' F1 - Fixed Length
Public Const EXPORT_PDF = 6

Public Const IMPORT_EXCEL = 1

Public Const FILE_CREATE = 1
Public Const FILE_APPEND = 2

Public Const PERIOD_MONTH = 1
Public Const PERIOD_QUARTER = 2
Public Const PERIOD_HALFYEAR = 3
Public Const PERIOD_FULL = 4


            ' Config Category
  
Public Const CC_DOCUMENTS = 1
Public Const CC_LETTERS = 2
Public Const CC_VOUCHERS = 3
Public Const CC_LABELS = 4
Public Const CC_REGISTERS = 5
Public Const CC_PARTYWISE_ANALYSIS = 6   'for party-wise sales/purc analysis
Public Const CC_IMPORT_VCH_FROM_EXCEL = 7 'used during Importing vouchers from Excel
Public Const CC_VAT_REGISTERS = 8   'For configurable VAT sale, VAT purchase register
Public Const CC_INV_REGISTERS = 9   'Used for Inventory vouchers in Configuration form
Public Const CC_PARAM_STOCK_STATUS_COLUMNAR = 10 ' for Parameterized stock status columnar

Public Const PR_BALONLY = 1   '   To be used in payment reminders
Public Const PR_ALLBILLS = 2
Public Const PR_DUEBILLS = 3

'       Following are the RecTypes for Tran10 table

Public Const PIR_PG_IG = 1
Public Const PIR_PG_I = 2
Public Const PIR_P_IG = 3
Public Const PIR_P_I = 4
Public Const PIR_IQD = 5
Public Const POS_COMPOSITE_BARCODE_STRUCTURE_TAGGING = 6 'This Constant is used for Tagged Bar-Code structure in BusyDB.
Public Const VCH_SERIES_GRP_CONFIG = 7      'for saving vch series group config
Public Const VCH_SERIES_GRP_VAT_ACC_CONFIG = 8     'for saving vat accounts tagged in a voucher series grp

Public Const MASTERS_NONVAT = 0
Public Const MASTERS_VAT = 1

Public Const PREVIEW_HEADER = 1
Public Const PREVIEW_BODY = 2
Public Const PREVIEW_FOOTER = 3
Public Const PREVIEW_COMPLETE = 4

Public Const DB_JET = 1
Public Const DB_MSSQL = 2
Public Const DB_ORACLE = 3
Public Const DB_MYSQL = 4

Public Const TV_IMAGE_COLLAPSED = 1
Public Const TV_IMAGE_EXPANDED = 2
Public Const TV_IMAGE_LEAF = 3
 
Public Const SPACE_INT = 6
Public Const SPACE_LONG = 12
Public Const SPACE_CHAR_SHORT = 20
Public Const SPACE_CHAR_LONG = 40
Public Const SPACE_DATE = 10
Public Const SPACE_DOUBLE = 16

Public Const RETAIL_ONLY = 1
Public Const TAX_ONLY = 2
 
Public Const FLD_ALIGN_LEFT = 1
Public Const FLD_ALIGN_RIGHT = 2
Public Const FLD_ALIGN_CENTRE = 3

Public Const QUERY_TYPE_ITEM = 1
Public Const QUERY_TYPE_VCH = 2

Public Const SQL_MODE_NOT_ALLOWED = 0
Public Const SQL_MODE_ACCESS_EXECUTE_ONLY = 1
Public Const SQL_MODE_ACCESS_CREATE_EXECUTE = 2

Public Const ST_ISSUABLE = 1
Public Const ST_RECEIVABLE = 2

Public Const DE_RECORD_DELETED = 3167

Public Const MAX_TOTAL_COLS = 150


Public Const OLD_VCHCODE_EXCISEADJ = -1000
Public Const VCHCODE_EXCISEADJ = -1002
Public Const VCHCODE_OEDADJ = -1001
Public Const VCHCODE_CESSADJ = -999
Public Const VCHCODE_HECESSADJ = -998


Public Const VCHCODE_OP_PO = -1100
Public Const VCHCODE_OP_SO = -1200

Public Const VCHCODE_CANCEL_REF = -1300

'Constants added by Jitendra on 03-01-08 for Opening Information of Pending Challans
Public Const VCHCODE_OP_CHALLAN_SALE = -1400
Public Const VCHCODE_OP_CHALLAN_PURC = -1500
Public Const VCHCODE_OP_CHALLAN_SR = -1600
Public Const VCHCODE_OP_CHALLAN_PR = -1700

Public Const VCHCODE_OTHER_FINYR = -9999 ''By Abhay

Public Const ES_ALL_PENDING = 1
Public Const ES_ONLY_DUE = 2
Public Const ES_ALL_REFS = 3 ' added by Deepti for
                            ' Bill adjustment wizard


Public Const RG_ALL_UNSORTED = 0
Public Const RG_ALL_SORTED = 1

' For use in Forms Issuable/Receivable Reports
Public Const FA_ITEM_BASIC_AMT = 1
Public Const FA_BILL_AMT = 2
Public Const FA_TAXABLE_AMT = 3
Public Const FA_AS_FEEDED = 4

' Used to Select Currency Type on Reports
Public Const CUR_ALT = 1
Public Const CUR_BASE = 2
Public Const CUR_BOTH = 3

'Used to select Currency Conversion factor type

Public Const ALT_PER_BASE = 0
Public Const BASE_PER_ALT = 1

Public Const SUBREG_TYPE_A = 0      ' Used to identify the Type of Sales Tax Register (LS-A or LS-B)
Public Const SUBREG_TYPE_B = 1
Public Const SUBREG_TYPE_C = 2
Public Const SUBREG_TYPE_D = 3


Public Const ONE_MASTER = 1
Public Const GRP_MASTER = 2
Public Const ALL_MASTER = 3
Public Const SELECTED_MASTER = 4

Public Const IGNORE_ONE_MASTER = 1
Public Const IGNORE_GRP_MASTER = 2
Public Const IGNORE_ALL_MASTER = 3
Public Const IGNORE_SELECTED_MASTER = 4


Public Const IUT_MAIN = 0
Public Const IUT_ALT = 1
Public Const IUT_BOTH = 2
Public Const IUT_TRAN = 3

Public Const PAGE_TYPE_ALL = 0
Public Const PAGE_TYPE_EVEN = 1
Public Const PAGE_TYPE_ODD = 2


Public Const PO_ITEMWISE = 1
Public Const PO_PARTYWISE = 2

Public Const BATCH_DATEWISE = 1
Public Const BATCH_NOWISE = 2
Public Const BATCH_VCHCODE_WISE = 3

Public Const PRINT_SINGLE = 1
Public Const PRINT_BATCH = 2

'''Constant used in singnatory Details form

Public Const CONFIG_SIGNATORY_TDS = 1
Public Const CONFIG_SIGNATORY_VAT = 2
Public Const CONFIG_SIGNATORY_OTHER_DET = 3


' Given below are the constants for the Tax Nature of Accounts

Public Const TAX_TYPE_OTHERS = 0
Public Const TAX_TYPE_TDS = 1   ' TDS
Public Const TAX_TYPE_VAT = 2   ' VAT/LST
Public Const TAX_TYPE_BED = 3   ' BED
Public Const TAX_TYPE_CST = 4   ' CST
Public Const TAX_TYPE_SERVICETAX = 5    ' Service Tax

Public Const TAX_TYPE_SCHG_VAT = 11 ' Surcharge on VAT/LST
    
Public Const TAX_TYPE_OED = 21      ' OED/SED
Public Const TAX_TYPE_EC_EXCISE = 22    ' Edu. Cess on Excise
Public Const TAX_TYPE_HEC_EXCISE = 23   ' HE Cess on Excise

Public Const TAX_TYPE_EC_ST = 31
Public Const TAX_TYPE_HEC_ST = 32

Public Const TAX_TYPE_SCHG_TDS = 41
Public Const TAX_TYPE_EC_TDS = 42
Public Const TAX_TYPE_HEC_TDS = 43

Public Const TAX_TYPE_ENTRYTAX = 51

'Constants for Tax Category Type in Tax Category
Public Const TAX_CAT_TYPE_GOODS = 0
Public Const TAX_CAT_TYPE_SERVICES = 1

'Const used for extra details (like OF info, Vch. Det,Narration etc.) while printing
Public Const PRN_OF_INFO = 1
Public Const PRN_FULL_VCH_DET = 2
Public Const PRN_NARRATION = 3
Public Const PRN_ITEM_DET = 4
Public Const PRN_REF_DET = 5



' Given below are the constants for the Nature of Bill Sundry

Public Const BSN_OTHERS = 0    ' Others

Public Const BSN_VAT = 1    ' VAT/LST
Public Const BSN_CST = 2    ' CST
Public Const BSN_SCHG_VAT = 3    ' Surcharge on VAT/LST

Public Const BSN_BED = 11    ' BED
Public Const BSN_OED = 12    ' OED/SED
Public Const BSN_EC_EXCISE = 13    ' Edu. Cess on Excise
Public Const BSN_HEC_EXCISE = 14    ' HE Cess on Excise

Public Const BSN_ST = 21    ' Service Tax
Public Const BSN_EC_ST = 22    ' Edu. Cess on Service Tax
Public Const BSN_HEC_ST = 23    ' He Cess on Service Tax

Public Const BSN_DISCOUNT = 31

Public Const BSN_ENTRYTAX = 41

'following are the constants used for RecType in Tran2 file
    
Public Const T2_ACC_DATA = 1
Public Const T2_ITEM_DATA = 2
Public Const T2_BS_DATA = 3
Public Const T2_ITEM_ORDER = 4
Public Const T2_ACC_DATA_PDC = 5
Public Const T2_MRP_OP_STOCK = 6 'For MRP Wise Stock
Public Const T2_ITEM_DATA_INVOICE = 7   'For Sale/Purchase against challan (Added by Jitendra on 18-12-2008)
Public Const T2_ACC_DATA_UNAPPROVED = 8
Public Const T2_ITEM_DATA_UNAPPROVED = 9
Public Const T2_BS_DATA_UNAPPROVED = 10

Public Const T2_ACC_DATA_CANCELLED = 11 'Added By Abhay For Voucher Cancellation on 27/02/2008
Public Const T2_ITEM_DATA_CANCELLED = 12
Public Const T2_BS_DATA_CANCELLED = 13
Public Const T2_ITEM_ORDER_CANCELLED = 14

Public Const T2_ITEM_ORDER_UNAPPROVED = 15
Public Const T2_ITEM_DATA_INVOICE_UNAPPROVED = 16

Public Const T2_SUB_ACC_DATA = 17
Public Const T2_SUB_ACC_DATA_UNAPPROVED = 18
Public Const T2_SUB_ACC_DATA_PDC = 19
Public Const T2_QUOTATION_DATA = 20    '*surbhi
'Reference RecTypes
Public Const ACC_REF = 1
Public Const ITEM_REF = 2
Public Const CHALLAN_REF = 3
Public Const ORDER_REF = 4
Public Const QUOTATION_REF = 5   '*surbhi

Public Const METHOD_NEWREF = 1
Public Const METHOD_ADJUSTMENT = 2
Public Const METHOD_ADDREF = 3
Public Const METHOD_ON_ACC = 4  ' added by deepti for
Public Const METHOD_BOTH = 5    ' adjustment wiazrd
Public Const METHOD_ORPHAN = 6  ' For unaccounted refrences

Public Const TYPE_NEW = 1
Public Const TYPE_ADJ = 2

'Parameter Wise Stock RecType for Order & Inventory
Public Const PARAM_STOCK_DATA = 1
Public Const PARAM_ORDER_DATA = 2

'***
Public Const WARNING_KEEPMUM = 1
Public Const WARNING_WARNONLY = 2
Public Const WARNING_STOP = 3

' To be used to get the Physical X & Y offset of printer
Public Const PHYSICALOFFSETX = 112 '  Physical Printable Area x margin
Public Const PHYSICALOFFSETY = 113 '  Physical Printable Area y margin
'-------------------------------------


Public Const CCTRAN_ALL = 0
Public Const CCTRAN_SALE = 1
Public Const CCTRAN_PURCHASE = 2
Public Const CCTRAN_INCOME = 3
Public Const CCTRAN_EXPENSE = 4


Public Const STOCK_TRANSFER_OFFSET = 1000   '  Used to generate the S.No. of the items which are replicated in stock transfer voucher
Public Const CONFIG_SECONDREC_OFFSET = 500  ' Used to store the data of Col Acc Reg configuraion in two records instead of one

Public Const ONE_ITEM_ONE_MC = 1
Public Const ONE_ITEM_GRP_MC = 2
Public Const ONE_ITEM_ALL_MC = 3
Public Const ONE_MC_GRP_ITEM = 4
Public Const ONE_MC_ALL_ITEM = 5


Public Const RT_ALLOW = 1
Public Const RT_DISALLOW = 2

Public Const REGION_INTERNATIONAL = "00"        ' For dongle signature
Public Const REGION_SOUTHASIA = "01"

Public Const COUNTRY_INDIA = 1
Public Const COUNTRY_PAKISTAN = 2
Public Const COUNTRY_NEPAL = 3
Public Const COUNTRY_SINGAPORE = 4
Public Const COUNTRY_SRILANKA = 5
Public Const COUNTRY_NIGERIA = 6        'Added by Jitendra on 07-09-07
Public Const COUNTRY_UK = 7             'J
Public Const COUNTRY_USA = 8            'J
Public Const COUNTRY_GHANA = 9        'Added by Jitendra on 07-09-07
Public Const COUNTRY_BANGLADESH = 10        'Added by Jitendra on 07-09-07
Public Const COUNTRY_BHUTAN = 11        'Added by Jitendra on 07-09-07
Public Const COUNTRY_MALDIVES = 12        'Added by Jitendra on 07-09-07
Public Const COUNTRY_DUBAI = 13        'Added by Jitendra on 07-09-07
Public Const COUNTRY_OMAN = 14        'Added by Jitendra on 07-09-07
Public Const COUNTRY_ABUDHABI = 15        'Added by Jitendra on 07-09-07
Public Const COUNTRY_SAUDIARABIA = 16        'Added by Jitendra on 07-09-07
Public Const COUNTRY_KENYA = 17
Public Const COUNTRY_TANZANIA = 18
Public Const COUNTRY_BOTSWANA = 19

Public Const COUNTRY_OTHERS = -1

'Public Const STATE_OTHERS = 0
Public Const STATE_ANDAMAN_NICOBAR = 1
Public Const STATE_ANDHRA_PRADESH = 2
Public Const STATE_ARUNCHAL_PRADESH = 3
Public Const STATE_ASSAM = 4
Public Const STATE_BIHAR = 5
Public Const STATE_CHANDIGARH = 6
Public Const STATE_CHATTISGARH = 7
Public Const STATE_DADAR_NAGAR = 8
Public Const STATE_DAMAN_DIU = 9
Public Const STATE_DELHI = 10
Public Const STATE_GOA = 11
Public Const STATE_GUJRAT = 12
Public Const STATE_HARYANA = 13
Public Const STATE_HIMACHAL_PRADESH = 14
Public Const STATE_JAMMU_KASHMIR = 15
Public Const STATE_JHARKHAND = 16
Public Const STATE_KARNATAKA = 17
Public Const STATE_KERALA = 18
Public Const STATE_LAKSHDWEEP = 19
Public Const STATE_MADHYA_PRADESH = 20
Public Const STATE_MAHARASHTRA = 21
Public Const STATE_MANIPUR = 22
Public Const STATE_MEGHALYA = 23
Public Const STATE_MIZORAM = 24
Public Const STATE_NAGALAND = 25
Public Const STATE_ORISSA = 26
Public Const STATE_PONDICHERRY = 27
Public Const STATE_PUNJAB = 28
Public Const STATE_RAJASTHAN = 29
Public Const STATE_SIKKIM = 30
Public Const STATE_TAMILNADU = 31
Public Const STATE_TRIPURA = 32
Public Const STATE_UTTRANCHAL = 33
Public Const STATE_UTTAR_PRADESH = 34
Public Const STATE_WEST_BENGAL = 35



'' Virtual States of INDIA
Public Const STATE_BHUTAN = 61
Public Const STATE_BANGLADESH = 62
Public Const STATE_NEPAL = 63

'Public Const STATE_LAHORE = 101

Public Const PRODUCT_IBC = "1"
Public Const PRODUCT_BUSYCSM = "3"
Public Const PRODUCT_BUSYPAY = "6"
Public Const PRODUCT_BUSYWIN = "9"
Public Const PRODUCT_GENERIC = "Z"
Public Const PRODUCT_DEALER = "90"


Public Const MODEL_SK = "0"     ' Service Key
Public Const MODEL_BS = "1"
Public Const MODEL_SS = "2"
Public Const MODEL_PS = "3"
Public Const MODEL_SM = "4"
Public Const MODEL_PM = "5"
Public Const MODEL_SC = "6"
Public Const MODEL_PC = "7"
Public Const MODEL_ES = "8"
Public Const MODEL_EM = "9"
Public Const MODEL_EC = "A"

' Following variable are used to distinguish between Sale Tax Summary or Sale Type Summary
'
Public Const ST_TAX_SUM = 1
Public Const ST_TYPE_SUM = 2

'Following constatnts are to be used in Table DeletedInfo to indicate
'if Master or Voucher has been deleted.
'
Public Const TYPE_MASTER = 1
Public Const TYPE_VOUCHER = 2
Public Const TYPE_ITEM_DESC = 3     ' To be used in Batch deletion of Item Descreption

Public Const H2_VOUCHER = 1
Public Const H2_MASTER = 2

'  Make sure to have OF1 to OF10 in a line, withour any gap
'

Public Const H2_OF1 = 1
Public Const H2_OF2 = 2
Public Const H2_OF3 = 3
Public Const H2_OF4 = 4
Public Const H2_OF5 = 5
Public Const H2_OF6 = 6
Public Const H2_OF7 = 7
Public Const H2_OF8 = 8
Public Const H2_OF9 = 9
Public Const H2_OF10 = 10
Public Const H2_TRANSPORT = 11
Public Const H2_GR_NO = 12
Public Const H2_STATION = 13
Public Const H2_VEHICLE_NO = 14
Public Const H2_ITEM_AF = 15
Public Const H2_ACC_SHORTNAR = 16
Public Const H2_ITEM_DESC = 17
Public Const H2_ITEMWISE_DESC = 18
Public Const H2_CC_SHORTNAR = 19
Public Const H2_BS_SHORTNAR = 20

Public Const H2_ITEM_DESC1 = 31 'Added By Abhay
Public Const H2_ITEM_DESC2 = 32 'To be used for ItemDescription Semi-Master
Public Const H2_ITEM_DESC3 = 33
Public Const H2_ITEM_DESC4 = 34
Public Const H2_ITEM_DESC5 = 35
Public Const H2_ITEM_DESC6 = 36
Public Const H2_ITEM_DESC7 = 37
Public Const H2_ITEM_DESC8 = 38
Public Const H2_ITEM_DESC9 = 39
Public Const H2_ITEM_DESC10 = 40

' Following are the constants used in "RecType" in
' Help1 Table.

Public Const H1_ACC = 1
Public Const H1_AGRP = 2
Public Const H1_ITEM = 3
Public Const H1_IGRP = 4
Public Const H1_CC = 5
Public Const H1_CCGRP = 6
Public Const H1_UNIT = 7
Public Const H1_CUR = 8
Public Const H1_BS = 9
Public Const H1_MC = 10
Public Const H1_FORM = 11
Public Const H1_ST = 12
Public Const H1_PT = 13
Public Const H1_MCGRP = 14
Public Const H1_BROKER = 15
Public Const H1_BOM = 16
Public Const H1_AUTHOR = 17
Public Const H1_SERIES = 18
Public Const H1_TDS = 19
Public Const H1_PARTYMAST = 20
Public Const H1_EMP_GRP = 21
Public Const H1_EMPLOYEE = 22
Public Const H1_SAL_COMP = 23

Public Const H1_VCH_SERIES_GRP = 51
Public Const H1_BILL_REFGRP = 52
Public Const H1_BATCH_REFGRP = 53
Public Const H1_ORDER_REFGRP = 54
Public Const H1_COUNTRY_MAST = 55
Public Const H1_STATE_MAST = 56
Public Const H1_CITY_MAST = 57
Public Const H1_MAST_SERIES_GRP = 58
Public Const H1_BRANCH_MAST = 59
Public Const H1_TAX_CATEGORY_MAST = 60

Public Const H1_CASHBANK = 101
Public Const H1_NOCASHBANK = 102
Public Const H1_PARTY = 103
Public Const H1_PARTYCASHBANK = 104
Public Const H1_SALE = 105      ' Includes Sales, Fixed Assets and Income acconts
Public Const H1_PURC = 106      ' Includes Prchase, Fixed Assets and Expense Acconts
Public Const H1_JRNL = 107
Public Const H1_BANK = 108
Public Const H1_DUTIES_TAXES = 109
Public Const H1_STOCK = 110
Public Const H1_PARTYLOAN = 111

Public Const H1_AG_NOPLRS = 201
Public Const H1_AG_NOPLR = 202
Public Const H1_AG_PARTY = 203
Public Const H1_AG_PARTYLOAN = 204
Public Const H1_AG_PARTYCASHBANK = 205

Public Const H1_ITEM_STOCK = 251
Public Const H1_ITEM_NOSTOCK = 252

Public Const H1_OF1_ITEMMAST = 301   ' Master Optional Fields
Public Const H1_OF2_ITEMMAST = 302
Public Const H1_OF3_ITEMMAST = 303
Public Const H1_OF4_ITEMMAST = 304
Public Const H1_OF5_ITEMMAST = 305
Public Const H1_OF6_ITEMMAST = 306
Public Const H1_OF7_ITEMMAST = 307
Public Const H1_OF8_ITEMMAST = 308
Public Const H1_OF9_ITEMMAST = 309
Public Const H1_OF10_ITEMMAST = 310

Public Const H1_OF1_ACCMAST = 351
Public Const H1_OF2_ACCMAST = 352
Public Const H1_OF3_ACCMAST = 353
Public Const H1_OF4_ACCMAST = 354
Public Const H1_OF5_ACCMAST = 355
Public Const H1_OF6_ACCMAST = 356
Public Const H1_OF7_ACCMAST = 357
Public Const H1_OF8_ACCMAST = 358
Public Const H1_OF9_ACCMAST = 359
Public Const H1_OF10_ACCMAST = 360

Public Const H1_OF1_MCMAST = 401
Public Const H1_OF2_MCMAST = 402
Public Const H1_OF3_MCMAST = 403
Public Const H1_OF4_MCMAST = 404
Public Const H1_OF5_MCMAST = 405
Public Const H1_OF6_MCMAST = 406
Public Const H1_OF7_MCMAST = 407
Public Const H1_OF8_MCMAST = 408
Public Const H1_OF9_MCMAST = 409
Public Const H1_OF10_MCMAST = 410

Public Const H1_OF1_EMPMAST = 451
Public Const H1_OF2_EMPMAST = 452
Public Const H1_OF3_EMPMAST = 453
Public Const H1_OF4_EMPMAST = 454
Public Const H1_OF5_EMPMAST = 455
Public Const H1_OF6_EMPMAST = 456
Public Const H1_OF7_EMPMAST = 457
Public Const H1_OF8_EMPMAST = 458
Public Const H1_OF9_EMPMAST = 459
Public Const H1_OF10_EMPMAST = 460


' Following are the constants used in "Status" in Help1 Table.
Public Const H1_STATUS_SHOW_ALL = 0
Public Const H1_STATUS_UNAPPROVED = 1
Public Const H1_STATUS_DISABLED = 2

'Following are the constants used for UserControl By Uday
'

Public Const UC_BACK_DATE = 1
Public Const UC_FIX_SERIES = 2
Public Const UC_CONTROL_MASTER = 3
Public Const UC_CONTROL_MASTER_REPORTS = 4
Public Const UC_MESSAGE_CENTRE_FOLDER = 5   'By URS
Public Const UC_AUTHORISATION = 6
Public Const UC_BRANCH_INFO = 7
Public Const UC_TV_FAVOURITE = 8
Public Const UC_TV_SHORTCUT = 9

' Following are the constants used for TN VAT Reports
'
Public Const TNVAT_PURC_CAT_C = 1
Public Const TNVAT_PURC_CAT_E = 2
Public Const TNVAT_PURC_CAT_I = 3
Public Const TNVAT_PURC_CAT_O = 4
Public Const TNVAT_PURC_CAT_R = 5
Public Const TNVAT_PURC_CAT_S = 6
Public Const TNVAT_PURC_CAT_A = 7
Public Const TNVAT_PURC_CAT_B = 8

Public Const TNVAT_SALE_CAT_E = 21
Public Const TNVAT_SALE_CAT_F = 22
Public Const TNVAT_SALE_CAT_R = 23
Public Const TNVAT_SALE_CAT_S = 24
Public Const TNVAT_SALE_CAT_Z = 25
Public Const TNVAT_SALE_CAT_A = 26

'Following are the constants used for Puducherry Vat Reports
'
Public Const PCVAT_PURC_CAT_E = 1
Public Const PCVAT_PURC_CAT_I = 2
Public Const PCVAT_PURC_CAT_O = 3
Public Const PCVAT_PURC_CAT_R = 4
Public Const PCVAT_PURC_CAT_S = 5

Public Const PCVAT_SALE_CAT_E = 11
Public Const PCVAT_SALE_CAT_O = 12
Public Const PCVAT_SALE_CAT_S = 13
Public Const PCVAT_SALE_CAT_X = 14
Public Const PCVAT_SALE_CAT_Z = 15
Public Const PCVAT_SALE_CAT_R = 16

'Following are the constants used for Punjab Vat Reports
'
Public Const PVAT_PURC_CAT_H = 1
Public Const PVAT_PURC_CAT_E = 2
Public Const PVAT_PURC_CAT_F = 3
Public Const PVAT_PURC_CAT_Z = 4
Public Const PVAT_PURC_CAT_R = 5
Public Const PVAT_PURC_CAT_I = 6

Public Const PVAT_SALE_CAT_H = 11
Public Const PVAT_SALE_CAT_E = 12
Public Const PVAT_SALE_CAT_F = 13
Public Const PVAT_SALE_CAT_Z = 14
Public Const PVAT_SALE_CAT_R = 15
Public Const PVAT_SALE_CAT_I = 16

' Following are the constants defining the codes of prdefined masters
'

Public Const ACC_CASH = 1
Public Const ACC_PL = 2
Public Const ACC_STOCK = 3
Public Const ACC_SALE = 4
Public Const ACC_PURC = 5

'Virtual Accounts (51 to 100)
Public Const ACC_ESI_CONTRIBUTION = 51
Public Const ACC_ESI_DEDUCTION = 52
Public Const ACC_PF_DEDUCTION = 53
Public Const ACC_PF_ACC_1 = 54
Public Const ACC_PF_ACC_2 = 55
Public Const ACC_PF_ACC_10 = 56
Public Const ACC_PF_ACC_21 = 57
Public Const ACC_PF_ACC_22 = 58
Public Const ACC_PT = 59     'Professional Tax

Public Const AG_CAPITAL = 101
Public Const AG_CURRENT_ASSET = 102
Public Const AG_CURRENT_LIABILITY = 103
Public Const AG_FIXED_ASSET = 104
Public Const AG_INVESTMENTS = 105
Public Const AG_LOAN_LIABILITY = 106
Public Const AG_PRE_OPERATIVE_EXPENSES = 107
Public Const AG_PROFIT_LOSS = 108
Public Const AG_REVENUE = 109
Public Const AG_SUSPENSE = 110
Public Const AG_CASH_IN_HAND = 111
Public Const AG_BANK = 112
Public Const AG_SECURITIES_DEPOSITS = 113
Public Const AG_LOAN_ADVANCES = 114
Public Const AG_STOCK_IN_HAND = 115
Public Const AG_SUNDRY_DEBTORS = 116
Public Const AG_SUNDRY_CREDITORS = 117
Public Const AG_DUTIES_TAXES = 118
Public Const AG_PROVISIONS = 119
Public Const AG_SECURED_LOANS = 120
Public Const AG_UNSECURED_LOANS = 121
Public Const AG_PURCHASE = 122
Public Const AG_SALE = 123
Public Const AG_EXPENSE_DIRECT = 124
Public Const AG_EXPENSE_INDIRECT = 125
Public Const AG_INCOME_DIRECT = 126
Public Const AG_INCOME_INDIRECT = 127
Public Const AG_BANK_OD = 128
Public Const AG_RESERVE_SURPLUS = 129

Public Const MC_MAIN_STORE = 201

Public Const VCH_SERIES_BEG = 251

Public Const COUNTRY_MAST_OTHERS = 301
Public Const STATE_MAST_OTHERS = 302
Public Const CITY_MAST_OTHERS = 303

Public Const IG_GENERAL = 401
Public Const CCG_GENERAL = 402
Public Const TAXCAT_NONE = 403

Public Const UNT_UNITS = 451

Public Const NM_RECEIEVED_THROUGH_MSG_CENTRE = 0     'default category for Notes manager

' Following are the constants used for "MasterType" in
' Master1 table

Public Const AGRP_MAST = 1
Public Const ACC_MAST = 2
Public Const CCGRP_MAST = 3
Public Const CC_MAST = 4
Public Const IGRP_MAST = 5
Public Const ITEM_MAST = 6
Public Const CUR_MAST = 7
Public Const UNIT_MAST = 8
Public Const BS_MAST = 9
Public Const MCGRP_MAST = 10
Public Const MC_MAST = 11
Public Const FORM_MAST = 12
Public Const ST_MAST = 13
Public Const PT_MAST = 14
Public Const BOM_MAST = 15
Public Const UNITCON_MAST = 16
Public Const CURCON_MAST = 17
Public Const SN_MAST = 18
Public Const BROKER_MAST = 19
Public Const AUTHOR_MAST = 20
Public Const SERIES_MAST = 21
Public Const TDS_MAST = 22
Public Const PARTY_MAST = 23 'For POS Party Mast
Public Const BRANCH_MAST = 24
Public Const TAX_CATEGORY_MAST = 25
Public Const MAST_SERIES_GRP_MAST = 26
Public Const EMPLOYEE_MAST = 27
Public Const EMP_GRP_MAST = 28
Public Const SALARY_COMPONENT_MAST = 29

Public Const VCH_SERIES_GRP_MAST = 51
Public Const BILL_REFGRP_MAST = 52
Public Const BATCH_REFGRP_MAST = 53
Public Const ORDER_REFGRP_MAST = 54
Public Const COUNTRY_MAST = 55
Public Const STATE_MAST = 56
Public Const CITY_MAST = 57


Public Const NMCATEGORY_MAST = 101      'Notes Manager Category

Public Const OF1_ITEM_MAST = 201   ' Master Optional Fields
Public Const OF2_ITEM_MAST = 202
Public Const OF3_ITEM_MAST = 203
Public Const OF4_ITEM_MAST = 204
Public Const OF5_ITEM_MAST = 205
Public Const OF6_ITEM_MAST = 206
Public Const OF7_ITEM_MAST = 207
Public Const OF8_ITEM_MAST = 208
Public Const OF9_ITEM_MAST = 209
Public Const OF10_ITEM_MAST = 210

Public Const OF1_ACC_MAST = 251
Public Const OF2_ACC_MAST = 252
Public Const OF3_ACC_MAST = 253
Public Const OF4_ACC_MAST = 254
Public Const OF5_ACC_MAST = 255
Public Const OF6_ACC_MAST = 256
Public Const OF7_ACC_MAST = 257
Public Const OF8_ACC_MAST = 258
Public Const OF9_ACC_MAST = 259
Public Const OF10_ACC_MAST = 260

Public Const OF1_MC_MAST = 301
Public Const OF2_MC_MAST = 302
Public Const OF3_MC_MAST = 303
Public Const OF4_MC_MAST = 304
Public Const OF5_MC_MAST = 305
Public Const OF6_MC_MAST = 306
Public Const OF7_MC_MAST = 307
Public Const OF8_MC_MAST = 308
Public Const OF9_MC_MAST = 309
Public Const OF10_MC_MAST = 310

Public Const OF1_EMP_MAST = 351
Public Const OF2_EMP_MAST = 352
Public Const OF3_EMP_MAST = 353
Public Const OF4_EMP_MAST = 354
Public Const OF5_EMP_MAST = 355
Public Const OF6_EMP_MAST = 356
Public Const OF7_EMP_MAST = 357
Public Const OF8_EMP_MAST = 358
Public Const OF9_EMP_MAST = 359
Public Const OF10_EMP_MAST = 360

' ******




' ****** Master Optional Fields

Public Const TYPE_SEMI_MASTER = 1
Public Const TYPE_PURE_MASTER = 2
 
' ******
 
 
 
Public Const ACC_DEBIT = 2
Public Const ACC_CREDIT = 6

Public Const ITEM_CONSUMED = 2
Public Const ITEM_GENERATED = 6

Public Const MATERIAL_CENTRE_FROM = 2

Public Const USER_MAST = 51  ' Added For Copy of masters

Public Const NA_NAME = 1
Public Const NA_ALIAS = 2

Public Const TYPE_LOCAL = 0
Public Const TYPE_CENTRAL = 1

Public Const ST_VATREGISTER = -1 ' This constant will show special case
Public Const ST_EXEMPT = 1
Public Const ST_TAXPAID = 2
Public Const ST_TAXABLE = 3
Public Const ST_RD = 4
Public Const ST_URD = 5
Public Const ST_TAXFREE = 6
Public Const ST_LUMPSUM = 7
Public Const ST_EXPORTIMPORT = 8
Public Const ST_STOCKTRANSFER = 9
Public Const ST_LOCAL_STKTRANSFER = 10
Public Const ST_EXPORTIMPORT_HIGHSEA = 11
Public Const ST_RETAIL_PURCHASE = 12

' Lenghth of the variables

Public Const PERCENT_MAX_CHAR = 7
Public Const PERCENT_MAX_DECIMAL = 3

Public Const UCFACTOR_MAX_CHAR = 10


Public Const QTY_MAX_CHAR = 16
Public Const PRICE_MAX_CHAR = 16
Public Const AMT_MAX_CHAR = 16
Public Const NUM_MAX_CHAR = 16


Public Const PRODUCT_LEN = 10
Public Const PACKAGE_SRNO_LEN = 20

Public Const COMP_NAME_LEN = 40
Public Const COMP_SHORT_NAME_LEN = 10
Public Const ADD_LEN = 40
Public Const PINCODE_LEN = 10
Public Const STDCODE_LEN = 10
Public Const DRUG_LICENCE_LEN = 20

Public Const EXCISE_DOC_LEN = 15
Public Const EXCISE_CHALLAN_NO_LEN = 15

Public Const EXCISE_SRNO_LEN = 25

Public Const TELNO_LEN = 40
Public Const FAX_LEN = 30
Public Const EMAIL_LEN = 40
Public Const MOBILE_LEN = 40
Public Const LST_LEN = 30
Public Const CST_LEN = 30
Public Const ST37_LEN = 30
Public Const ITPAN_LEN = 20
Public Const ITWARD_LEN = 20
Public Const EXCISE_REGNO_LEN = 30
Public Const ECCCODE_LEN = 20
Public Const PLANO_LEN = 20
Public Const RANGE_LEN = 80
Public Const DIVISION_LEN = 80
Public Const COLLECTORATE_LEN = 40
Public Const CONTACT_LEN = 40
Public Const DESIGNATION_LEN = 20


Public Const TIN_NO_LEN = 30
Public Const SERVICE_TAX_NO_LEN = 30
Public Const PREMISES_CODE_LEN = 20
Public Const TAXABLE_SERVICE_LEN = 40

Public Const TAN_NO_LEN = 15
Public Const TDS_SEC_LEN = 10
Public Const TDS_CIRCLE_LEN = 10
Public Const TDS_CHALLAN_NO_LEN = 10
Public Const TDS_PAYEE_CAT_LEN = 80
Public Const TDS_ADD_LEN = 25
Public Const PERSON_NAME_LEN = 40

Public Const GUID_NO_LEN = 40

Public Const VAT_CHALLAN_NO_LEN = 10
Public Const BANK_NAME_LEN = 40
Public Const BANK_CODE_LEN = 20
Public Const BANK_AC_LEN = 15
Public Const BANK_MAST_ACC_NO_LEN = 40 'isha
Public Const BANK_AC_TYPE_LEN = 10

Public Const SUPPLIER_TYPE_LEN = 25

Public Const CHEQUE_LEN = 10

Public Const DONGLE_SR_NO_LEN = 10

Public Const FIRST_QTR = 1
Public Const SECOND_QTR = 2
Public Const THIRD_QTR = 3
Public Const FOURTH_QTR = 4

Public Const ACC_NAME_LEN = 40
Public Const GRP_NAME_LEN = 40
Public Const CC_NAME_LEN = 40
Public Const CUR_NAME_LEN = 10
Public Const ITEM_NAME_LEN = 40
Public Const MC_NAME_LEN = 40
Public Const UNIT_NAME_LEN = 10
Public Const BS_NAME_LEN = 40
Public Const BS_SUBTOTAL_DESC_LEN = 40
Public Const FORM_NAME_LEN = 10
Public Const ST_NAME_LEN = 15
Public Const PT_NAME_LEN = 15
Public Const BROKER_NAME_LEN = 40
Public Const BOM_NAME_LEN = 40
Public Const AUTHOR_NAME_LEN = 40
Public Const TDS_NAME_LEN = 40
Public Const PARTY_NAME_LEN = 40
Public Const BILL_REFGRP_NAME_LEN = 10
Public Const EMP_NAME_LEN = 40
Public Const SAL_COMPONENT_NAME_LEN = 40

Public Const NARRATION_LEN = 94
Public Const SHORT_NAR_LEN = 40

Public Const MASTER_NAME_LEN = 40
Public Const MASTER_NOTES_LEN = 80

Public Const USER_NAME_LEN = 20
Public Const USER_PASSWORD_LEN = 20
Public Const USER_C1_LEN = 80

Public Const COMPUTER_NAME_LEN = 25 'NetBIOS (Max-15) and DNS ( Max-24)

Public Const VCHNAME_LEN = 20


Public Const OPT_FLD_NAME_LEN = 20
Public Const OPT_FLD_LEN = 20
Public Const ADD_FLD_NAME_LEN = 20
Public Const ADD_FLD_LEN = 20
Public Const OF_NAME_LEN = 20
Public Const OF_LEN = 20
Public Const VCHNO_LEN = 25
Public Const VAT_DESC_LEN = 80
Public Const MAX_CHAR_FIELD_LEN = 255

Public Const ST_CAT_LEN = 30

Public Const VCHSERIES_LEN = 10
Public Const VCHPREFIX_LEN = 10
Public Const VCHSUFFIX_LEN = 10

Public Const DOC_HEAD_LEN = 30

Public Const DOC_DESC_LEN = 50

Public Const MASTER1_C1_LEN = 80

Public Const REP_TITLE_LEN = 70

Public Const DATE_LEN = 10

Public Const TEMP_FIELD_LEN = 200 ''vaishali

Public Const ITEM_TARRIF_LEN = 10

Public Const RG23D_NO_LEN = 5

Public Const DAILY_MSG_LEN = 96 ' Charu



Public Const ARFT_ACC = 1           ' ARFT => Acc Reg Fld Type
Public Const ARFT_FLD = 2
Public Const ARFT_ITEM = 3          ' ARFT => Prty Item Sales/Purchase Analysis Fld Type
Public Const ARFT_ITEM_MAST = 4          'ARFT=> Used to Add Item List in Cofiguration Form
Public Const ARFT_TAX_DETAIL = 5    'ARTF =>Used for configurable vat register

Public Const ARFT_ACC_HEADER = 6 'ARFT => Used for Columnar Configurable Pymt/Rcpt,Contra,Journal,Dr Note and Cr Note Registers of Header Field.
Public Const ARFT_ACC_BODY = 7 ''ARFT => Used for Columnar Configurable Pymt/Rcpt,Contra,Journal,Dr Note and Cr Note Registers of Body Field.


Public Const EXP_INFORMATION = 1
Public Const EXP_PLEASETELL = 2


Public Const MSG_SORRY = 1
Public Const MSG_HAPPY = 2
Public Const MSG_DELETE = 3
Public Const MSG_SAVE = 4
Public Const MSG_INFORMATION = 5

'
' RecType Config Table

Public Const CONFIG_VCH_OF = 1
Public Const CONFIG_MAST_OF = 2
Public Const CONFIG_FREEZE_DATA_VCH_WISE = 3         'For Partial Data Freezing
Public Const CONFIG_DATA_FREEZED = 4                 'for saving data is freezed
Public Const CONFIG_COMP_OPTIONS = 5
Public Const CONFIG_VCH_NUM = 6
Public Const CONFIG_WARNING_ALARMS = 7
Public Const CONFIG_CONTROL_MASTERS = 8
Public Const CONFIG_AGEING_TIMESLABS = 9
Public Const CONFIG_ITEM_DET = 10
Public Const CONFIG_CASH_BANK_COLS = 11
Public Const CONFIG_ACC_REG_COLS = 12
Public Const CONFIG_IMPORT_MAST_FILT = 13
Public Const CONFIG_BARCODE_DATA = 14
Public Const CONFIG_MAX_ELEMENT_INGRID = 15
Public Const CONFIG_ITEM_PRICE_LIST = 16
Public Const CONFIG_PARTY_ITEM_COLS = 17
Public Const CONFIG_ST_SURCHARGE = 18
Public Const CONFIG_IAD_PRINTING = 19
Public Const CONFIG_IMPORT_EXCEL_MAST = 20
Public Const CONFIG_EXPLORE_MAST = 21
Public Const CONFIG_DOC_COPY_TYPE = 22
Public Const CONFIG_FY_PREFERENCES = 23
Public Const CONFIG_INTCALSLAB_DAYBASIS = 24
Public Const CONFIG_INTCALSLAB_AMTBASIS = 25
'Public Const CONFIG_INTCALTYPE_FLAT = 26
Public Const CONFIG_POS_INVOICE = 27
Public Const CONFIG_POS_SETTLEMENT = 28
Public Const CONFIG_IMPORT_TEXTFILE_MAST = 29
Public Const CONFIG_XML_DATA_EXPORT = 30    'This is now not used anywhere instead CONFIG_XML_DATA_EXPORT_VCH is used
Public Const CONFIG_XML_DATA_EXPORT_VCH = 30    'For transactions
Public Const CONFIG_XML_DATA_IMPORT = 31
Public Const CONFIG_XML_DATA_EXPORT_MASTERS = 32    'For Masters
Public Const CONFIG_ITEM_BARCODE_ADDON = 33   'This is used to save the config settings of ItemBarCode AddOn in Busy db
Public Const CONFIG_STOCKSTATUS_MCWISE_COLS = 34
Public Const CONFIG_REPORT_DATE_OPTIONS = 35
Public Const CONFIG_PRINTER_COMMANDS = 36
'Public Const CONFIG_POS_BARCODE=37
Public Const CONFIG_POS_GRID_SIZE = 38
Public Const CONFIG_POS_BARCODE_STRUCTURE = 39 'This is used to save the POS Bar-Code Structure in Busy db
Public Const CONFIG_IBC_BARCODE_STRUCTURE = 40
Public Const CONFIG_IMPORT_VCH_FROM_EXCEL = 41 'This is used to save format used in Importing Vouchers from Excel
Public Const CONFIG_COMM_CODE_DESC = 42 'This is used to save Description of Diff. Commodity Code
Public Const CONFIG_CONTACT_DET = 43 'This is used to save the Contact detail configuration in Printing
Public Const CONFIG_STOCK_AGEING_TIMESLABS = 44
Public Const CONFIG_ITEM_SRNO_AUTO_STRUCT = 45 ' to be used to configure item - Sr No Automatic Numbering Structure
Public Const CONFIG_ITEM_SN_PRINT_DET_FOR_REPORT = 47
Public Const CONFIG_ITEM_SN_PRINT_DET_FOR_DOCUMENT = 48
Public Const CONFIG_BATCH_PRINT_DET_FOR_REPORT = 49
Public Const CONFIG_BATCH_PRINT_DET_FOR_DOCUMENT = 50
Public Const CONFIG_ORDER_PRINT_DET_FOR_REPORT = 51
Public Const CONFIG_ORDER_PRINT_DET_FOR_DOCUMENT = 52
Public Const CONFIG_CHALLAN_PRINT_DET_FOR_REPORT = 53
Public Const CONFIG_CHALLAN_PRINT_DET_FOR_DOCUMENT = 54
Public Const CONFIG_BILL_PRINT_DET_FOR_REPORT = 55
Public Const CONFIG_BILL_PRINT_DET_FOR_DOCUMENT = 56
Public Const CONFIG_SMS_API = 57
Public Const CONFIG_STOCK_PARAM_DET = 58
Public Const CONFIG_PARAM_STOCK_PRINT_DET_FOR_REPORT = 59
Public Const CONFIG_PARAM_STOCK_PRINT_DET_FOR_DOCUMENT = 60
Public Const CONFIG_PARAM_STOCK_STATUS_COLUMNAR = 61            ' Charu
Public Const CONFIG_ST_ADVANCE_OPTIONS = 62
Public Const CONFIG_COMP_OPTIONS1 = 63
Public Const CONFIG_BARCODE_NEW = 64
Public Const CONFIG_CENTRAL_SERVER = 65
'Public Const CONFIG_IMPORT_DB = 66
Public Const CONFIG_PARTYGROUP_ITEM_COLS = 67
Public Const CONFIG_ITEM_PARTY_COLS = 68
Public Const CONFIG_ITEMGROUP_PARTY_COLS = 69
Public Const CONFIG_COMP_OPTIONS_FOR_BRANCH = 70

Public Const CONFIG_TRIGGER_DATA = 71
Public Const CONFIG_TEOP_REF = 72
Public Const CONFIG_BO_CONTROLS_FROM_HO = 73
Public Const CONFIG_SELECTIVE_APPROVAL = 74
Public Const CONFIG_COMP_OPTIONS1_FOR_BRANCH = 75

Public Const CONFIG_SMS_QUERY = 76                                     'sumiti
Public Const CONFIG_PAYROLL = 77
Public Const CONFIG_EMAIL_QUERY = 78                                     'sumiti

Public Const CONFIG_MAST_OF1 = 79  ' Master Optional Fields
Public Const CONFIG_IMPORT_EXCEL_MAST_ITEM_MC_OPSTOCK = 80  'NEHA

' Self generated error constants

Public Const CONFIG_MAST_OF_REC_NOT_FOUND = 10001
Public Const MASTER_NOT_FOUND = 10002

Public Const MASTER_ADDRESS_REC_NOT_FOUND = 10005
Public Const USER_NOT_FOUND = 10006
Public Const COMP_CONFIG_REC_NOT_FOUND = 10007
Public Const GRPCLASS_MASTERTYPE_NOT_DEFINED = 10008    ' This error no. is used when the master type in generic group class is missing. The genric group class is being used for Accout, Cost Centre, Material Centre and Item groups
Public Const CONFIG_VCH_OF_REC_NOT_FOUND = 10009
Public Const CONFIG_VCH_NUM_REC_NOT_FOUND = 10010
Public Const VCH_NOT_FOUND = 10011
Public Const COULD_NOT_CREATE_MASTER = 10012
Public Const FOLIO_NOT_FOUND = 10013

Public Const COULD_NOT_CREATE_DATA_DIR = 10015
Public Const COULD_NOT_CREATE_TEMP_DB = 10016
Public Const CONFIG_CONTROL_MASTERS_REC_NOT_FOUND = 10017
Public Const COULD_NOT_CREATE_TEMP_TABEL = 10018
Public Const COULD_NOT_CREATE_SYNC_MASTERDB_DIR = 10019 'ADDED By Abhay For Local Caching of Masters on 28/02/2008

Public Const INVALID_EXCISE_DELETE_METHOD = 10020
Public Const INVALID_EXCISE_LOAD_METHOD = 10021

Public Const DONT_BE_OVERSMART = 420

Public Const INVALID_UDF_NAME = 11000

' Following are the constants used in the BOM master

Public Const PRODUCT = 1
Public Const RAW_MATERIAL = 2
Public Const BY_PRODUCT = 3


Public Const BC_LINEAR = 1
Public Const BC_2D = 2

Public Const SYM_PDF417 = 1


        '   IADPrinting
        
Public Const IAD_NONE = 0
Public Const IAD_ALIAS = 1
Public Const IAD_DESC1 = 2
Public Const IAD_DESC2 = 3
Public Const IAD_DESC3 = 4
Public Const IAD_DESC4 = 5


'''''''Config Code Const used in Configuration
Public Const CONFIG_MAX_DOC_FORMAT_NAMES = 4


' Following are the constants for diffrent Vch Types
'   if changing the order of constants below then go through the configuration record creation procudure
'

Public Const OP_BAL = 1
Public Const PURCHASE = 2
Public Const SALE_RETURN = 3
Public Const MATERIAL_RECEIPT = 4
Public Const STOCK_TRANSFER = 5
Public Const PRODUCTION = 6
Public Const UNASSEMBLE = 7
Public Const STOCK_JOURNAL = 8
Public Const SALE = 9
Public Const PURCHASE_RETURN = 10
Public Const MATERIAL_ISSUE = 11
Public Const SALE_ORDER = 12
Public Const PURCHASE_ORDER = 13
Public Const RECEIPT = 14
Public Const CONTRA = 15
Public Const JOURNAL = 16
Public Const DR_NOTE = 17
Public Const CR_NOTE = 18
Public Const PAYMENT = 19

Public Const CANCEL_REF = 51  'For cancel the reference

Public Const FORMS_RECEIVED_ATHOURITY = 20
Public Const FORMS_RECEIVED = 21
Public Const FORMS_ISSUED = 22
Public Const ADJUST_EXCISE_AMOUNTS = 23
Public Const VAT_JOURNAL = 24
Public Const SALARY_CALCULATION = 25
Public Const SALE_QUOTATION = 26      '*surbhi
Public Const PURCHASE_QUOTATION = 27  '*surbhi

Public Const VJV_OP_BAL = 1
Public Const VJV_CAPITAL = 2
Public Const VJV_STK_TFR = 3
Public Const VJV_EXEMPT = 4
Public Const VJV_OLD_STOCK = 5
Public Const VJV_PRICE_CHANGE = 6
Public Const VJV_REFUND = 7
Public Const VJV_PENALTY = 8
Public Const VJV_INTEREST = 9
Public Const VJV_OTHERS = 10
Public Const VJV_SALE_CANCEL = 11
Public Const VJV_BED_DEBTS = 12
Public Const VJV_DAMAGE_STOCK = 13
Public Const VJV_SALE_CHANGE = 14
Public Const VJV_DR_NOTE = 15
Public Const VJV_CR_NOTE = 16
Public Const VJV_TDS_ADJ = 17
Public Const VJV_PURCHASE_TAX = 18

' State specific VAt JV Constants
' Delhi will start from 101 and then leave 50 for each new state
Public Const VJV_DELHI_DEFERRED_VAT_ON_OPENING_STOCK = 101
Public Const VJV_DELHI_DEFERRED_VAT_ON_CLOSING_STOCK = 102

' State specific VAt JV Constants
' Chandigarh will start from 151 and then leave 50 for each new state


Public Const VJV_CHANDIGARH_NOTIONAL_ITC_NONCAPITAL = 151
Public Const VJV_CHANDIGARH_NOTIONAL_ITC_CAPITAL = 152
Public Const VJV_CHANDIGARH_NOTIONAL_ITC_TAXFREE = 153
Public Const VJV_CHANDIGARH_NOTIONAL_ITC_SALES = 154
Public Const VJV_CHANDIGARH_NOTIONAL_ITC_BRANCHTRANSFER = 155
Public Const VJV_CHANDIGARH_NOTIONAL_ITC_PURCHASE_RETURN = 156

' State specific VAt JV Constants
' Punjab will start from 201 and then leave 50 for each new state
Public Const VJV_PUNJAB_PURCHASE_TAX_ON_TURNOVER = 201
Public Const VJV_PUNJAB_ITC_DEBITED_EARLIER = 202
Public Const VJV_PUNJAB_APPORTIONMENT_ITC_UNDER_SEC_13_3 = 203
Public Const VJV_PUNJAB_NOTIONAL_ITC_PURCHASE_FROM_EXEMPTED_UNITS = 204

' State specific VAt JV Constants
' Jharkand will start from 251 and then leave 50 for each new state
Public Const VJV_JHARKAND_PURCHASE_ENTRY_TAX_PAID_SCHEDULE_III = 251
Public Const VJV_JHARKAND_TAX_DUE_ON_PURCHASE_OF_GOODS_UNDER_SECTION_10 = 252

' State specific VAt JV Constants
' Bihar will start from 301 and then leave 50 for each new state
Public Const VJV_BIHAR_TURNOVER_LIABLE_PURCHASE_TAX = 301
Public Const VJV_BIHAR_TRANSFER_RIGHTS_TO_USE_GOODS_GIFT = 302
Public Const VJV_BIHAR_ENTRY_TAX_SET_OFF = 303

' State specific VAt JV Constants
' Chattisgarh will start from 351 and then leave 50 for each state
Public Const VJV_CHATTISGARH_SALE_UNDER_SECTION_13_5 = 351 'By Tushar

' State specific VAt JV Constants
' Gujarat will start from 401 and then leave 50 for each state
Public Const VJV_GUJARAT_REDUCTION_IN_TAX_OF_GOODS_MANUFACTURED = 401 'By Tushar
Public Const VJV_GUJARAT_REDUCTION_DUE_TO_FUEL_MANUFACTURED_OF_GOODS = 402 'By Tushar

' State specific VAt JV Constants
' Goa will start from 451 and then leave 50 for each state
Public Const VJV_GOA_REVERSE_CREDIT_COVERED_UNDER_SUB_SECTION_2_3_5_6_OF_SECTION_9 = 451 'By Tushar

Public Const VJV_RT_INPUT_TAX = 1
Public Const VJV_RT_OUTPUT_TAX = 2
Public Const VJV_RT_REFUND = 3
Public Const VJV_RT_PAYMENT = 4
Public Const VJV_RT_CST_PAYMENT = 5
Public Const VJV_RT_ENTRYTAX_PAYMENT = 6

'State specific VAT JV Constants
'Orissa will start from 501 and then leave 50 for each state
Public Const VJV_ORISSA_GOODS_USED_FOR_MINING = 501
Public Const VJV_ORISSA_VAT_PAID_ON_NON_INPUT_GOODS = 502

'State specific VAT JV Constants
'Madhya Pradesh will start from 551 and then leave 50 for each state
Public Const VJV_MP_GOODS_USED_IN_MFR_OF_TF_GOODS = 551
Public Const VJV_MP_GOODS_USED_IN_PCK_OF_TF_GOODS = 552
Public Const VJV_MP_GOODS_USED_IN_PROD_OF_TXB_GOODS = 553
Public Const VJV_MP_GOODS_USED_IN_WORK_CONTRACT = 554

'State specific VAT JV Constants
'Uttar Pradesh will start from 601 and then leave 50 for each state
Public Const VJV_UP_ADJ_THRU_TRADE_TAX = 601
Public Const VJV_UP_REVERSAL_ITC = 602

'State specific VAT JV Constants
'Pondicherry will start from 651 and then leave 50 for each state
Public Const VJV_PONDICHERRY_ITC_ON_GOODS_PURCHASED_FOR_TRANSFER_OF_RIGHTS = 651
Public Const VJV_PONDICHERRY_PURCHASE_TAX_IF_ITC_AVAILABLE = 652
Public Const VJV_PONDICHERRY_TAX_CREDIT_ON_SECOND_HAND_GOODS = 653
Public Const VJV_PONDICHERRY_INPUT_TAX_ON_WITHDRAWAL_FROM_COMP_SCH = 654
Public Const VJV_PONDICHERRY_TAX_PAID_ON_GOODS_HELD_ON_DATE_OF_CANC_REG = 655
Public Const VJV_PONDICHERRY_OUTPUT_PURCHASE_TAX = 656


'State specific VAT JV Constants
'Tamil Nadu will start from 701 and then leave 50 for each state
Public Const VJV_TAMIL_NADU_ADVANCE_TAX = 701
Public Const VJV_TAMIL_NADU_ENTRY_TAX = 702
Public Const VJV_TAMIL_NADU_TAX_UNDER_SEC12 = 703


' Given below are the cosntants to be used n ST/PT for VAT Return specific tagging
Public Const VRC_OTHERS = 0

' Delhi will start from 1 and then leave 50 for each state
Public Const VRC_DELHI_WORKS_CONTRACT = 1
Public Const VRC_DELHI_SALES_DIPLOMATIC = 2
Public Const VRC_DELHI_SALES_COVERED_UNDER_SEC_9 = 3
Public Const VRC_DELHI_SALES_OUTSIDE_DELHI_SEC_4 = 4
Public Const VRC_DELHI_PURCHASE_WORKS_CONTRACT = 5

' Assam will start from 51 and then leave 50 for each state
Public Const VRC_ASSAM_PURCHASE_FOURTH_SCHEDULE = 51    ' By Tushar
Public Const VRC_ASSAM_SALE_FOURTH_SCHEDULE = 52    ' By Tushar

' Chandigarh will start from 101 and then leave 50 for each state
Public Const VRC_CHANDIGARH_WORK_CONTRACT = 101    ' By Tushar

' Punjab will start from 151 and then leave 50 for each state
Public Const VRC_PUNJAB_WORK_CONTRACT = 151    ' By Tushar
Public Const VRC_PUNJAB_PURCHASE_VALUE_OF_SALES_OF_GOODS = 152    ' By Tushar
Public Const VRC_PUNJAB_PURCHASE_LIABLE_TO_TAX_UNDER_19_1_AND_20 = 153    ' By Tushar
Public Const VRC_PUNJAB_SALE_FOR_KACHA_ARCHITYA = 154    ' By Tushar

' Bihar will start from 201 and then leave 50 for each state
Public Const VRC_BIHAR_SALE_OF_GOODS_TO_BE_ANNEXED = 201  'By Tushar
Public Const VRC_BIHAR_SALE_OF_GOODS_ON_WHICH_TAX_ON_MRP_PAID = 202  'By Tushar
Public Const VRC_BIHAR_SALE_OF_PETROL_COL_9_1 = 203 'By Tushar
Public Const VRC_BIHAR_RT_3_SALE_OF_DIESEL_BOX_B = 204
Public Const VRC_BIHAR_RT_3_SALE_OF_ATF_BOX_B = 205
Public Const VRC_BIHAR_RT_3_SALE_OF_NATURAL_GAS_BOX_B = 206


' West Bengal will start from 251 and then leave 50 for each state
Public Const VRC_WESTBENGAL_PURCHASE_OF_MRP_GOODS_UNDER_SECTION_16_4 = 251  'By Tushar
Public Const VRC_WESTBENGAL_PURCHASE_FROM_DEALERS_PAYING_TAX_AT_COMPOUNDED_RATE = 252  'By Tushar
Public Const VRC_WESTBENGAL_PURCHASE_OF_RAW_JUTE_SHIPPER_OF_JUTE_ONLY = 253  'By Tushar
Public Const VRC_WESTBENGAL_PURCHASE_OF_RAW_JUTE = 254  'By Tushar
Public Const VRC_WESTBENGAL_SALE_OF_GOODS_ON_WHICH_TAX_ON_MRP_PAID = 255  'By Tushar
Public Const VRC_WESTBENGAL_SALE_ZERO_RATED = 256 'By Tushar
Public Const VRC_WESTBENGAL_SALE_THROUGH_AUCTIONEER = 257 'By Tushar
Public Const VRC_WESTBENGAL_SALE_OUTSIDE_STATE_SEC_4 = 258
Public Const VRC_WESTBENGAL_SALE_IMPORT_INDIA_SEC_5_2 = 259
Public Const VRC_WESTBENGAL_SALE_SEC_5_1 = 260
Public Const VRC_WESTBENGAL_SALE_ATF_SEC_5_5 = 261
Public Const VRC_WESTBENGAL_SALE_INSIDE_STATE = 262
Public Const VRC_WESTBENGAL_SALE_SUBSECTION_5_OF_SEC_8 = 263


' Daman & Diu will start from 301 and then leave 50 for each state
Public Const VRC_DAMAN_AND_DIU_WORKS_CONTRACT = 301 'By Tushar

' Gujarat will start from 351 and then leave 50 for each state
Public Const VRC_GUJARAT_EXEMPTED_FROM_TAX_UNDER_SECTION_5_2 = 351 'By Tushar
Public Const VRC_GUJARAT_BRANCH_T_F_CONSIGMENT_GOODS_MANUFACTURED = 352 'By Tushar


' Goa will start from 401 and then leave 50 for each state
Public Const VRC_GOA_SALE_NOT_TAXABLE_UNDER_SECTION_8_2A = 401 'By Tushar
Public Const VRC_GOA_SALE_GOODS_NOTIFIED_UNDER_SUB_SECTION_5_OF_SECTION_8 = 402 'By Tushar

' Himachal Pradesh will start from 451 and then leave 50 for each state
Public Const VRC_HIMACHAL_SALE_IN_COURSE_OF_IMPORT_INTO_INDIA = 451 'By Tushar
Public Const VRC_HIMACHAL_SALE_OUTSIDE_STATE_OF_GOODS = 452 'By Tushar
Public Const VRC_HIMACHAL_PURCHASE_IN_COURSE_OF_EXPORT_OUT_OF_INDIA = 453 'By Tushar
Public Const VRC_HIMACHAL_PURCHASE_OUTSIDE_STATE_FOR_SALES_OUTSIDE = 454 'By Tushar

' Andra Pradesh will start from 501 and then leave 50 for each state
Public Const VRC_ANDRA_PURCHASE_FOURTH_SCHEDULE = 501 'By Tushar
Public Const VRC_ANDRA_SALE_FOURTH_SCHEDULE = 502 'By Tushar
Public Const VRC_ANDRA_SALE_OF_GOODS_OUTSIDE_THE_STATE_THROUGH_COMMISSION_AGENTS = 503 'By Tushar
Public Const VRC_ANDRA_SALE_OF_GOODS_OUTSIDE_THE_STATE_OTHERWISE_THAN_THROUGH_COMMISSION_AGENTS = 504 'By Tushar

' ARUNANCHAL Pradesh will start from 551 and then leave 50 for each state
Public Const VRC_ARUNANCHAL_WORK_CONTRACT = 551 'By Tushar

' Tamil Nadu will start from 601 and then leave 50 for each state
Public Const VRC_TAMILNADU_SALES_TAX_DUE_UNDER_SEC_12 = 601 'By Tushar
Public Const VRC_TAMILNADU_PURCHASE_TAX_DUE_UNDER_SEC_12 = 602 'By Tushar

' Uttar Pradesh will start from 651 and then leave 50 for each state
Public Const VRC_UP_ANY_OTHER_PURCHASE_VAT_COL_7_A_VI = 651
Public Const VRC_UP_ANY_OTHER_PURCHASE_NON_VAT_COL_7_B_VI = 652
Public Const VRC_UP_SALE_IN_COURSE_OF_IMPORT_COL_9_A_VIII = 653
Public Const VRC_UP_SALE_OUTSIDE_STATE_COL_9_A_IX = 654
Public Const VRC_UP_ANY_OTHER_SALE_9_A_XI = 655
Public Const VRC_UP_ANY_OTHER_SALE_AMOUNT_9_B_V = 656
'Public Const VRC_UP_SALE_COL_1_I = 657 ' Deepak Bhatia
Public Const VRC_UP_SALE_SECTION_6A = 658
Public Const VRC_UP_SALE_SECTION_8_6 = 659
Public Const VRC_UP_SALE_SECTION_5_3 = 660
Public Const VRC_UP_SALE_SECTION_6_2 = 661
Public Const VRC_UP_SALE_IN_COMMISION_ACCOUNT_VAT = 662
Public Const VRC_UP_PURCHASE_IN_COMMISION_ACCOUNT_VAT = 663
Public Const VRC_UP_SALE_IN_COMMISION_ACCOUNT_NON_VAT = 664
Public Const VRC_UP_PURCHASE_IN_COMMISION_ACCOUNT_NON_VAT = 665
Public Const VRC_UP_PURCHASE_EX_PRINCIPAL_ACCOUNT = 666
Public Const VRC_UP_SALE_EX_PRINCIPAL_ACCOUNT = 667


' Jharkhand will start from 701 and then leave 50 for each state
Public Const VRC_JH_TAX_PAYABLE_ON_MRP_UNDER_SEC_9_2_OF_THE_ACT = 701 'by archit
Public Const VRC_JH_GOODS_UNDER_SCHEDULE_2_PART_A_B_C_D = 702 'by archit

' Orissa will start from 751 and then leave 50 for each state
Public Const VRC_ORISSA_SCHEDULE_C_PURCHASES = 751
Public Const VRC_ORISSA_ANY_OTHER_PURCHASES = 752
Public Const VRC_ORISSA_PURCHASES_FROM_CONSIGNMENT_AGENT = 753
Public Const VRC_ORISSA_SCHEDULE_B_PURCHASES = 754
Public Const VRC_ORISSA_TAX_PAID_ON_MRP = 755

'Orissa will start from 801 and then leave 50 for each state
Public Const VRC_ORISSA_SALE_UNDER_SEZ_STP_EHTP = 801
Public Const VRC_ORISSA_SALE_TO_EOU = 802
'Public Const VRC_ORISSA_SALE_UNDER_SECTION_17_A = 803
Public Const VRC_ORISSA_SALE_UNDER_SECTION_12 = 804
Public Const VRC_ORISSA_SALE_OF_SCHEDULE_C_GOODS = 805
Public Const VRC_ORISSA_SALE_ON_MRP = 806

'Karnataka will start from 851 and then leave 50 for each state
Public Const VRC_KARNATAKA_SALE_AGAINST_URD_PURCHASES = 851

'Rajasthan will start from 901 and then leave 50 for each state
Public Const VRC_RAJASTHAN_OTHER_SALES = 901
Public Const VRC_RAJASTHAN_LIABLE_GOODS_UNDER_SECTION_6_1 = 902
Public Const VRC_RAJASTHAN_PRICE_LIABLE_UNDER_SECTION_4_2 = 903
Public Const VRC_RAJASTHAN_FULLY_EXPMPTED_UNDER_SECTION_8_3 = 904
Public Const VRC_RAJASTHAN_SEZ_EXPORT_UNDER_SECTION_8_4 = 905
Public Const VRC_RAJASTHAN_SALE_GOODS_PURCHASED_SOLD_OUTSIDE_STATE = 906
Public Const VRC_RAJASTHAN_COMPOSITION_SCHEME_UNDER_SECTION_5 = 907
Public Const VRC_RAJASTHAN_WORK_CONTRACT_EC_UNDER_SECTION_8_3 = 908
Public Const VRC_RAJASTHAN_SWITCH_OVER_UNDER_SECTION_3_2 = 909
Public Const VRC_RAJASTHAN_SALE_ON_MRP = 910

'Chhattisgarh will start from 951 and then leave 50 for each state
Public Const VRC_CG_SALE_GOODS_FOR_WORK_CONTRACT = 951
Public Const VRC_CG_SALE_TO_SEZ = 952
Public Const VRC_CG_OTHER_DEDUCTIONS = 953

'Uttarakhand will start from 1001 and then leave 50 for each State
Public Const VRC_UTTARAKHAND_TAX_PAID_ON_MRP = 1001
Public Const VRC_UTTARAKHAND_GOODS_PURCHASED_RECEIVED_FROM_OUTSIDE = 1002
Public Const VRC_UTTARAKHAND_GOODS_PURCHASED_WITHIN_STATE = 1003
Public Const VRC_UTTARAKHAND_SALE_PURC_UNDER_SEC_3_10 = 1004

'Pondicherry will start from 1051 and then leave 50 for each State
Public Const VRC_PONDICHERRY_SALES_TO_SEZ = 1051

'Jammu & kashmir will start from 1101 and then leave 50 for each State
Public Const VRC_JAMMU_KASHMIR_STATE_UNDER_SECTION_4 = 1101
Public Const VRC_JAMMU_KASHMIR_ZERO_RATED_GOODS = 1102
Public Const VRC_JAMMU_KASHMIR_PURCHASE_MANUFACTURER_CLAIM = 1103

'Auto Generation of Multi-Currency Revaluation Journal Vouchers (Singapore) Added by Jitendra
Public Const CLOSING_BALANCE = 1
Public Const NET_OF_TRANSACTION = 2
'

Public Const SVM_LAST_PURCHASE = 1
Public Const SVM_LAST_SALE = 2
Public Const SVM_LAST_QTY_IN = 3
Public Const SVM_QTY_OUT = 4
Public Const SVM_WEIGHTED_AVERAGE = 5
Public Const SVM_LIFO = 6
Public Const SVM_FIFO = 7
Public Const SVM_SELF = 8
Public Const SVM_AVERAGE_PRICE = 9


Public Const FORM_NOT_PENDING = 0
Public Const FORM_PENDING = 1
Public Const FORM_CLEARED = 2

Public Const INWARD = 1
Public Const OUTWARD = 2


Public Const EXCISE_PLA = 1
Public Const EXCISE_RG23A2 = 2
Public Const EXCISE_RG23C2 = 3
Public Const EXCISE_TOPAY = 4

Public Const EXCISE_ST_CHARGED = 11
Public Const EXCISE_ST_PAID = 12
Public Const EXCISE_ST_DEPOSITED = 13

Public Const ET_BED = 1
Public Const ET_OED = 2
Public Const ET_EC = 3
Public Const ET_HEC = 4




Public Const PRINTER_NAME_LEN = 40
Public Const PRN_STYLE_LEN = 40

Public Const PRATTR_NORMAL_TEXT = 1
Public Const PRATTR_FIELD = 2
Public Const PRATTR_PRN_STYLE = 3
Public Const PRATTR_COMMAND = 4
Public Const PRATTR_DRAWING_FIELD = 5
Public Const PRATTR_EXPRESSION = 6

Public Const HSTREG_ST17 = 1
Public Const HSTREG_ST17A = 2
Public Const HSTREG_ST33 = 3
Public Const HSTREG_ST12 = 5
Public Const HSTREG_ST12A = 6
Public Const HSTREG_ST23 = 7
Public Const HSTREG_ST23A = 8
Public Const HSTREG_ST38IN = 9
Public Const HSTREG_ST38OUT = 10
Public Const HSTREG_ST38REC = 11
Public Const HSTREG_ST33I = 12

Public Const UPSTREG_FORM31 = 51
Public Const UPSTREG_OCSTAMP = 52

Public Const RJSTREG_FORM18 = 53

Public Const DEP_INCOMETAX_ACT = 1
Public Const DEP_COMPANY_ACT = 2


Public Const WINFONT_MIXED = 0
Public Const WINFONT_COURIER = 1
Public Const WINFONT_OLORON = 2
Public Const WINFONT_LUCIDA_CONSOLE = 3
Public Const WINFONT_LETTER_GOTHIC_LINE = 4
Public Const WINFONT_TAHOMA = 5







    '   For Saving in Table RepOptValues

Public Const REP_TYPE_SCREEN = 1
Public Const REP_TYPE_PRINT = 2
Public Const REP_TYPE_SCR2PRN = 3
Public Const REP_TYPE_EMAIL_PRINT = 4         'by Rachna
Public Const REP_TYPE_EMAIL_SCREEN = 5
Public Const REP_TYPE_SMS_PRINT = 6
Public Const REP_TYPE_SMS_SCREEN = 7
Public Const REP_TYPE_PRINT_FROM_GRID = 8 'isha
Public Const REP_TYPE_NEW_COLUMN = 9 'isha
        
        ' For Interest Calculation report

Public Const INT_CALTYPE_SLAB_DAYBASIS = 1
Public Const INT_CALTYPE_SLAB_AMTBASIS = 2
Public Const INT_CALTYPE_FLAT = 3

        'For frmIntCalSlabs

Public Const CHOICE_UPTO = 1
Public Const CHOICE_ABOVE = 2

    'Required For Auto Rounding Off
Public Const UPPER_LIMIT = 1
Public Const LOWER_LIMIT = 2
Public Const AUTO_LIMIT = 3

' TDS Tax Amt Type
Public Const TDS_AMT = 1
Public Const TDS_SUR_AMT = 2
Public Const TDS_CESS_AMT = 3
Public Const TDS_SHECESS_AMT = 4        'Added by Jitendra on 12-06-07

    'For Pos Invoice Configuration

'FIELD TYPES

Public Const POS_FLD_VARIABLE = 0 '1
Public Const POS_FLD_SEMI_VARIABLE = 2
Public Const POS_FLD_FIXED = 3

'For POS Settlement Mode
Public Const POS_SETTLEMENT_CASH = 1
Public Const POS_SETTLEMENT_CC1 = 2
Public Const POS_SETTLEMENT_CC2 = 3
Public Const POS_SETTLEMENT_CC3 = 4
Public Const POS_SETTLEMENT_CHEQUE = 5
Public Const POS_SETTLEMENT_PARTY_AMT = 6

'For POS Company Configuration
Public Const POS_BC_SIMPLE = 0
Public Const POS_BC_COMPOSITE = 1

'For Trading Excise Invoice Choice
Public Const TE_IC_AUTOMATIC = 0
Public Const TE_IC_SINGLE_ITEM = 1
Public Const TE_IC_MULTIPLE_ITEM = 2
Public Const TE_IC_COMMERICAL = 3


'Added By Rachna
Public Const EMAIL_TYPE_DIRECT_MAILBEE = 1           'through MailBee
Public Const EMAIL_TYPE_OUTLOOK = 2                 'through MAPI Controls
Public Const EMAIL_TYPE_DIRECT_SEE4VB = 3          'through See4VB
Public Const EMAIL_TYPE_MS_OUTLOOK = 4                 'through Outlook DLL

Public Const EMAIL_BODY_INLINE = 1
Public Const EMAIL_BODY_ATTACHMENT = 2

'Const used in MailBee EMail Tool
Public Const MAILBEE_KEY_CODE = "MBC700-2931393B21-BA9611D74C1D62BFB10C9EB5B257F26A"

'Const Used in EMail SEE functions
Public Const SEE_KEY_CODE = 1624054561
Public Const SEE_QUOTED_PLAIN = 1
Public Const SEE_QUOTED_HTML = 2
Public Const SEE_QUOTED_PRINTABLE = 8
Public Const SEE_ENABLE_ESMTP = 29
Public Const SEE_SET_SECRET = 57
Public Const SEE_SET_USER = 58

'Const Used in SMS - mCore SMS Obj
Public Const SMS_LICENSE_COMPANY = "BUSY INFOTECH PVT. LTD."
Public Const SMS_LICENSE_TYPE = "LITE-DISTRIBUTION"
Public Const SMS_LICENSE_KEY = "DTYF-N3TL-G743-AE6M"




'JPG's USED ACCORDING TO COLOR SCHEMES DEFINED IN BUSY
Public Const BG_BUSY_STANDARD = "BG_STANDARD.JPG"

' These Constants use in Synchronization of Masters to Set the User Choice

Public Const SYNCH_MATCH_MAST = 1
Public Const SYNCH_NEW_MAST = 2
Public Const SYNCH_ALL_MAST = 3

Public Const MIN_SQL_USER = 0
Public Const MAX_SQL_USER = 32767


Public Const ITC_ALLOWED = 1
Public Const ITC_DISALLOWED = 2

Public Const AGT_CUR_REVALUATION = 1        'Added by Jitendra on 07-09-07

'By Rachna
Public Const OPTION_ASK_USER = 1
Public Const OPTION_YES_TO_ALL = 2
Public Const OPTION_NO_TO_ALL = 3


Public Const CHEQUES_ISSUED = 1
Public Const CHEQUES_DEPOSITED = 2

' To be used for Importing Data in XML Format.
Public Const VCHNO_ONLY = 1 ' Added By Abhay
Public Const VCHNO_DATE = 2
Public Const VCHNO_SERIES = 3
Public Const VCHNO_SERIES_DATE = 4

' Added by UDAY
' To be used for Saving the Suplier information for excise info

Public Const SUPPLIER_MANUFACTURER = 1
Public Const SUPPLIER_IST_STAGE = 2
Public Const SUPPLIER_IIND_STAGE = 3
Public Const SUPPLIER_IMPORTER = 4
Public Const SUPPLIER_CONSIGNMENT_AGENT = 5
'To be used for Identifying Conversion Factor Mode
Public Const ALT_PER_MAIN = 1   'Added By Abhay
Public Const MAIN_PER_ALT = 2


'''''''''next three are the constants for special effects
Public Const SPECIAL_EFFECTS_SUB_DETAILS = 1
Public Const SPECIAL_EFFECTS_TOTALS = 2
Public Const SPECIAL_EFFECTS_STATIC_DETAILS = 3
Public Const SPECIAL_EFFECTS_PROPOTIONAL_FONT = 4
Public Const SPECIAL_EFFECTS_PROPOTIONAL_FONT_ITALIC = 5
Public Const SPECIAL_EFFECTS_PROPOTIONAL_FONT_TOTALS = 6
Public Const SPECIAL_EFFECTS_HEADING = 7

''''''next three are constants for Inventory report Printing  Options'''''''''''''
Public Const ITEM_BY_NAME = 1
Public Const ITEM_BY_ALIAS = 2
Public Const ITEM_BY_PRINT_NAME = 3  'By Uday
'To be used for Item-Sizing Information Applicable unit
Public Const APPLY_ON_MAIN = 1 'Added By Abhay
Public Const APPLY_ON_ALT = 2

'To Specify the type of SQL Server Database File  : - Added By Abhay on 12/07/2007
Public Const CS_DATFILE = 1
Public Const CS_LOGFILE = 2

'To Be used in ShowFullMsg for Displaying the Message : - Added By Abhay on 18/07/2007
Public Const MSG_MODE_STRING = 0
Public Const MSG_MODE_FILE = 1

Public Const SIZE_MEDIUM = 1
Public Const SIZE_LARGE = 2

Public Const BUTTON_OK = 1
Public Const BUTTON_QUIT = 2
' For Checking Mode of Form
Public Const SEC_FILEPWD = 1
Public Const SEC_USERPWD = 2
Public Const SEC_DONGLENO = 3
Public Const SEC_READFILEPWD = 4

Public Const SEC_FILE_NO_PWD = 5  ' By Tushar used as generic form in Creation of template
Public Const SEC_AUTO_NUM_STRUCT_NAME = 6

'for Updating Server Information through Server Mode
Public Const FILE_SERVERINFO = 1
Public Const FILE_SECFILEINFO = 2


'SQL SERVER Error Message
Public Const ERROR_SERVER_ACCESS_DENIED = 17
Public Const ERROR_USER_PWD = 18456
Public Const ERROR_NETWORK_NOT_ACCESSIBLE = 6


' Security File Password
Public Const NO_PASSWORD = 0
Public Const REQ_PASSWORD = 1
Public Const CHEAT_PASSWORD = 2


'Backup Type
Public Const BACKUP_NORMAL = 1
Public Const BACKUP_FTP = 2

'for update item price
Public Const ITEM_SALES_PRICE = 1
Public Const ITEM_PURC_PRICE = 2
Public Const ITEM_MIN_SALES_PRICE = 3
Public Const ITEM_MRP = 4
Public Const ITEM_SELF_VAL_PRICE = 5
Public Const ITEM_SALE_DISC = 6
Public Const ITEM_PURC_DISC = 7
Public Const ITEM_SALE_MRP = 8
Public Const ITEM_PURC_MRP = 9

'For Dos2Win ----Added by Prasun
'*********************************

Public Const INT_LEN = 5
Public Const LONG_LEN = 8
Public Const DBL_LEN = 16

Public Const DOS_MISC1_NAME_LEN = 10
Public Const DOS_MISC1_C1_LEN = 80
Public Const DOS_MISC1_C2_LEN = 80
Public Const DOS_MISC1_C3_LEN = 80
Public Const DOS_MISC1_C4_LEN = 80
Public Const DOS_MISC1_C5_LEN = 80
Public Const DOS_MISC1_C6_LEN = 80
Public Const DOS_MISC1_C7_LEN = 80
Public Const DOS_MISC1_C8_LEN = 80
Public Const DOS_MISC1_C9_LEN = 80
Public Const DOS_MISC1_C10_LEN = 80
Public Const DOS_MISC1_C11_LEN = 33

Public Const DOS_MASTER_C1_LEN = 40
Public Const DOS_MASTER_C2_LEN = 40
Public Const DOS_MASTER_C3_LEN = 40
Public Const DOS_MASTER_C4_LEN = 40
Public Const DOS_MASTER_C5_LEN = 40
Public Const DOS_MASTER_C6_LEN = 40
Public Const DOS_MASTER_C7_LEN = 25
Public Const DOS_MASTER_C8_LEN = 17

Public Const DOS_VCHNO_LEN = 18
Public Const DOS_TRAN1_VCHNO_LEN = 18
Public Const DOS_TRAN1_NARR1_LEN = 76
Public Const DOS_TRAN1_NARR2_LEN = 76
Public Const DOS_TRAN1_C1_LEN = 79

Public Const DOS_HELP1_NAMEALIAS_LEN = 40
Public Const DOS_HELP1_C1_LEN = 7
Public Const DOS_ADD_FLD_LEN = 20

Public Const DOS_ITEM_AF_LEN = 15

Public Const DOS_COMPANY_C1_LEN = 40

Public Const DOS_MISC2_C1_LEN = 214
Public Const DOS_VCHNO_SUFFIX_LEN = 6
Public Const DOS_VCHNO_PREFIX_LEN = 6

Public Const DOS_TRAN2_C1_LEN = 41
Public Const DOS_ACC_AF_LEN = 15

Public Const DOS_TRAN3_C1_LEN = 40
Public Const DOS_TRAN3_C2_LEN = 40
Public Const DOS_TRAN3_C3_LEN = 2

Public Const DOS_ACC_DATA = 1
Public Const DOS_CC_DATA = 2
Public Const DOS_NEW_REF = 3
Public Const DOS_ADJ_REF = 4
Public Const DOS_FORM_DATA = 5
Public Const DOS_NEW_BATCH = 6
Public Const DOS_ADJ_BATCH = 7
Public Const DOS_ITEM_DATA = 6
Public Const DOS_BS_DATA = 7
Public Const DOS_WC_DATA = 8
Public Const DOS_WC_OB = 9


' These are codes of Predefined masters in Busy DOS

Public Const DOS_CAPITAL = 101
Public Const DOS_CUR_ASSETS = 102
Public Const DOS_CUR_LIABILITY = 103
Public Const DOS_FIXED_ASSET = 104
Public Const DOS_INVESTEMENT = 105
Public Const DOS_LOAN_LIABILITY = 106
Public Const DOS_PREPAID_EXPENSE = 107
Public Const DOS_PROFIT_LOSS = 108
Public Const DOS_REVENUE = 109
Public Const DOS_SUSPENSE = 110
Public Const DOS_RESERVE = 111
Public Const DOS_BANK = 112
Public Const DOS_CASH = 113
Public Const DOS_SECURITY_DEPOSIT = 114
Public Const DOS_LOANS_ADVANCES = 115
Public Const DOS_STOCK = 116
Public Const DOS_DEBTORS = 117
Public Const DOS_DUTIES_TAXES = 118
Public Const DOS_PROVISIONS = 119
Public Const DOS_CREDITORS = 120
Public Const DOS_BANK_OD = 121
Public Const DOS_SECURED_LOAN = 122
Public Const DOS_UNSECURED_LOANS = 123
Public Const DOS_PURCHASE_GRP = 124
Public Const DOS_SALE_GRP = 125
Public Const DOS_EXPENSE_DIRECT = 126
Public Const DOS_EXPENSE_INDIRECT = 127
Public Const DOS_INCOME_DIRECT = 128
Public Const DOS_INCOME_INDIRECT = 129

Public Const DOS_ACC_CASH = 1
Public Const DOS_ACC_PLA = 2
Public Const DOS_ACC_STOCK = 3


' These are the MasterType constants in BusyDOS

Public Const DOS_AGRP_MAST = 1
Public Const DOS_ACC_MAST = 2
Public Const DOS_CCGRP_MAST = 3
Public Const DOS_CC_MAST = 4
Public Const DOS_IGRP_MAST = 5
Public Const DOS_ITEM_MAST = 6
Public Const DOS_UNIT_MAST = 7
Public Const DOS_BS_MAST = 8
Public Const DOS_WC_MAST = 9
Public Const DOS_FORM_MAST = 10
Public Const DOS_ST_MAST = 11
Public Const DOS_PT_MAST = 12
Public Const DOS_UC_MAST = 13
Public Const DOS_BOM_MAST = 14
Public Const DOS_SN_MAST = 15

' These are Voucher Type constants in Busy DOS

Public Const DOS_OP_BAL = 1
Public Const DOS_PURCHASE = 2
Public Const DOS_MATERIAL_RECEIPT = 3
Public Const DOS_SALE_RETURN = 4
Public Const DOS_SALE = 5
Public Const DOS_MATERIAL_ISSUE = 6
Public Const DOS_PURCHASE_RETURN = 7
Public Const DOS_RECEIPT = 8
Public Const DOS_OLD_PAYMENT = 9
Public Const DOS_JOURNAL = 10
Public Const DOS_CONTRA = 11
Public Const DOS_DR_NOTE = 12
Public Const DOS_CR_NOTE = 13
Public Const DOS_FORM_RECEIVED = 14
Public Const DOS_FORM_ISSUED = 15
Public Const DOS_PAYMENT = 20

'These are Rectype constants in Busy DOS misc1 table
Public Const VCH_CONFIG = 2
Public Const STD_NAR = 5
Public Const OPTIONAL_FIELD_PRINTING_CONFIG = 20
Public Const OPTIONAL_FIELD_PRINTING_IN_DOCS = 21
Public Const ALARM_CONFIG = 18
Public Const AGEING_TIME_SLABS = 9

'These are Rectype constants in Busy DOS misc2 table

Public Const VCHNO_INFO = 1
Public Const ITEM_DESC = 2
Public Const ADD_FLD = 3
Public Const BILLING_DET = 4


'These are trantype constants in Busy DOS tran2 table
Public Const CCTRANTYP_SALES = 5
Public Const CCTRANTYP_PURCHASE = 2
Public Const CCTRANTYP_INCOME = 51
Public Const CCTRANTYP_EXPENSE = 52

'These are CONFIGtype constants in Busy DOS misc1 table
Public Const CONFIG_TYPE_PURCHASE = 2
Public Const CONFIG_TYPE_MATERIAL_RECEIPT = 3
Public Const CONFIG_TYPE_SALE_RETURN = 4
Public Const CONFIG_TYPE_SALE = 5
Public Const CONFIG_TYPE_MATERIAL_ISSUE = 6
Public Const CONFIG_TYPE_PURCHASE_RETURN = 7
Public Const CONFIG_TYPE_RECEIPT = 8
Public Const CONFIG_TYPE_JOURNAL = 10
Public Const CONFIG_TYPE_CONTRA = 11
Public Const CONFIG_TYPE_DEBIT_NOTE = 12
Public Const CONFIG_TYPE_CREDIT_NOTE = 13
Public Const CONFIG_TYPE_PAYMENT = 20





Public DOS_MATERIAL_ISSUE_UNASSEMBLE

Public DOS_MATERIAL_RECEIPT_UNASSEMBLE

Public Const TOTAL_MASTERS_COUNT = 300 'This constant is used for total masters count in DOS2WIN.


'Below are the constants used for Drawing Objects

Public Const HOR_LINE = 1
Public Const BLH = 2        ' Box Line Horizontal
Public Const BLV = 3        ' Box Line Vertical

'Below are the constants used for Printer Commands

Public Const PRCMD_MAINTAIN_OUTER_BOX = 1
Public Const PRCMD_PRINT_OUTER_BOX = 2



'Below Constants are used for Nepali Date
Public Const ROMAN_DATE = 1 'ADDED BY ABHAY ON 23/01/2008
Public Const NEPALI_DATE = 2

Public Const NEPALIIN_ROMANOUT = 1 'Added By Abhay on 12/02/2008
Public Const ROMANIN_ROMANOUT = 2 'For Inputting Date in Roman and Get Reports in Roman if Company Date Type is Napali

' Below are the const for tagging VAT & NON VAT Type Goods.... By Tushar

Public Const VAT_TYPE_GOODS = 1
Public Const NONVAT_TYPE_GOODS = 2

'Below are the constant used for POS Bar-Code structure

Public Const BARCODE_FIXED_LENGTH = 1
Public Const BARCODE_DELIMETER = 2

Public Const BARCODE_DELIMITER_TEXT = 0
Public Const BARCODE_DELIMITER_ENTER_KEY = 1

Public Const BARCODE_FIELD_MAIN_QTY = 1
Public Const BARCODE_FIELD_ALT_QTY = 2
Public Const BARCODE_FIELD_UNIT = 3
Public Const BARCODE_FIELD_CON_FACTOR = 4
Public Const BARCODE_FIELD_MRP = 5
Public Const BARCODE_FIELD_PRICE = 6
Public Const BARCODE_FIELD_PRICE_IN_ALT_UNIT = 7
Public Const BARCODE_FIELD_RATE_OF_TAX = 8
Public Const BARCODE_FIELD_ADD_FIELDS = 9
Public Const BARCODE_FIELD_EXCEL = 10 ' This constant is used in Item Bar-Code(Composite) for Excel Format.
Public Const BARCODE_FIELD_DISCOUNT = 11
Public Const BARCODE_FIELD_DISCOUNT_AMT = 12
Public Const BARCODE_FIELD_ITEM_NAME = 13
Public Const BARCODE_FIELD_ITEM_ALIAS = 14
Public Const BARCODE_FIELD_SALES_PRICE = 15
Public Const BARCODE_FIELD_BATCH_NO = 16
Public Const BARCODE_FIELD_SERIAL_NO = 17
Public Const BARCODE_FIELD_PARAM1_VALUE = 18
Public Const BARCODE_FIELD_PARAM1_ALIAS = 19
Public Const BARCODE_FIELD_PARAM2_VALUE = 20
Public Const BARCODE_FIELD_PARAM2_ALIAS = 21
Public Const BARCODE_FIELD_PARAM3_VALUE = 22
Public Const BARCODE_FIELD_PARAM3_ALIAS = 23
Public Const BARCODE_FIELD_PARAM_QTY = 24
Public Const BARCODE_FIELD_PARAM_MRP = 25
Public Const BARCODE_FIELD_PARAM_SALES_PRICE = 26
Public Const BARCODE_FIELD_PARAM_ALT_QTY = 27
'Public Const BARCODE_FIELD_PARAM_BCN = 27
Public Const BARCODE_FIELD_MAIN_UNIT = 28
Public Const BARCODE_FIELD_ALT_UNIT = 29
Public Const BARCODE_FIELD_ITEM_DESC1 = 30
Public Const BARCODE_FIELD_ITEM_DESC2 = 31
Public Const BARCODE_FIELD_ITEM_DESC3 = 32
Public Const BARCODE_FIELD_ITEM_DESC4 = 33
Public Const BARCODE_FIELD_ITEM_OPT_FIELD1 = 34
Public Const BARCODE_FIELD_ITEM_OPT_FIELD2 = 35
Public Const BARCODE_FIELD_PARAM_BCN = 36



Public Const STATE_AP_TYPE_OF_DEALER_VAT = 0
Public Const STATE_AP_TYPE_OF_DEALER_TOT = 1
Public Const STATE_AP_TYPE_OF_DEALER_UNREG = 2

''Constants for Type of Dealer for UP
Public Const STATE_UP_OTHER_AREA = 0
Public Const STATE_UP_MANUFACTURE_WITHIN_AREA = 1
Public Const STATE_UP_MANUFACTURE_OUTSIDE_AREA = 2
Public Const STATE_UP_OTHERS_WITHIN_AREA = 3
Public Const STATE_UP_OTHERS_OUTSIDE_AREA = 4

' Below are const for Back date All series

Public Const BACK_DATE_ALL_SERIES = 1

Public Const VAT_BILL_WISE = 1
Public Const VAT_ITEM_WISE = 2
Public Const VAT_HSN_COMMODITY_CODE_WISE = 3

Public Const COMP_TYPE_OF_DEALER_REGULAR = 0
Public Const COMP_TYPE_OF_DEALER_COMPOSITION = 1

Public Const TYPE_OF_ITEM_VAT = 0
Public Const TYPE_OF_ITEM_NONVAT = 1
Public Const TYPE_OF_ITEM_EXEMPT = 2

'These are the constants for BALANCING MODE used in Account Ledger Horizontal
Public Const BALANCING_MODE_DAILY = 1
Public Const BALANCING_MODE_MONTHLY = 2
Public Const BALANCING_MODE_FINAL = 3
Public Const BALANCING_MODE_ENTRY_WISE = 4

'These const are for the Query manager

Public Const SEARCH_DESIERED_STRING = 1
Public Const SEARCH_BLANK_STRING = 2
Public Const SEARCH_NON_BLANK_STRING = 3

Public Const BROKERAGE_PERCENTAGE_WISE = 0
Public Const BROKERAGE_BY_ABSOLUTE_AMOUNT = 1
Public Const BROKERAGE_PER_MAIN_QTY = 2
Public Const BROKERAGE_PER_ALT_QTY = 3

Public Const BROKER_TYPE_BROKER = 0
Public Const BROKER_TYPE_SALES_MAN = 1

Public Const BROKERAGE_AT_HEADER_LEVEL = 0
Public Const BROKERAGE_AT_ITEM_LEVEL = 1

Public Const DEFAULT_BROKERAGE_AT_BROKER = 0
Public Const DEFAULT_BROKERAGE_AT_PARTY_ITEM = 1
Public Const DEFAULT_BROKERAGE_AT_COMP_CONFIG = 2

Public Const POS_REPORT_USERWISE = 1
Public Const POS_REPORT_SERIESWISE = 2

'Batch Reference Constants
Public Const BATCH_AT_VCH_SAVING = 0
Public Const BATCH_AT_ITEM_ENTRY = 1


Public Const DATE_IN_FULL_FORMAT = 0
Public Const DATE_IN_MONTH_YEAR = 1
Public Const DATE_NOT_REQUIRED = 2



'Const for UP EReturn File Name

Public Const ERETURN_UP_FILE_1 = 1
Public Const ERETURN_UP_FILE_2 = 2
Public Const ERETURN_UP_FILE_3 = 3
Public Const ERETURN_UP_FILE_4 = 4
Public Const ERETURN_UP_FILE_5 = 5
Public Const ERETURN_UP_FILE_6 = 6
Public Const ERETURN_UP_FILE_7 = 7

'Const For Pricing Mode
Public Const DEFAULT_PRICE = 0
Public Const PARTY_LAST_PRICE = 1
Public Const PARTY_ITEM_PRICE = 2
Public Const ITEM_QTY_PRICE = 3
Public Const MULTIPLE_PRICE_LIST_PRICE = 4
Public Const ITEM_LAST_PRICE = 5

'These constants are used in Pricing Mode when Multiple Price List is to be selected
Public Const PRICE_CATEGORY_FOR_PARTY = 0
Public Const PRICE_CATEGORY_FOR_ITEM = 1
'constants for Category type in Multiple Price List
Public Const PARTY_WISE_PRICING_MODE = 0 'isha
Public Const USER_WISE_PRICING_MODE = 1 'isha

Public Const TYPE_VAT = 0
Public Const TYPE_GST = 1
Public Const TYPE_LST = 2

'Following are the constants used as TranType in Tran1,Tran2,Tran3
Public Const TRAN_TYPE_PDC = 1

'Following are the constants used as TranType in Tran1,Tran2,Tran3 for Challan in case of material issue and material receipt vouchers (Added by Jitendra on 18-12-2008)
Public Const TRAN_TYPE_MI_MR_DEFAULT = 0        ' To be received back or issued back
Public Const TRAN_TYPE_MI_MR_CONSUMED = 2     ' To be consumed
Public Const TRAN_TYPE_MI_MR_SALE_PURC = 3     ' To be billed for Sale or Purchase
Public Const TRAN_TYPE_MI_MR_SR_PR = 4            ' To be billed for Sale Return or Purchase Return
Public Const TRAN_TYPE_MI_MR_AGST_MIMR = 5    ' Against Material Receipt or Material Issued

'Following are the constants used as TranType in Tran1,Tran2,Tran3 for Challan in case of Sale/Purchase/Sale Return/Purchase Return vouchers (Added by Jitendra on 23-12-2008)
Public Const TRAN_TYPE_SP_DIRECT = 0
Public Const TRAN_TYPE_SP_AGST_CHALLAN = 6

'Following are the constants used as TranType in Tran5  (for CC Mast)
Public Const TRAN_TYPE_CC_UNAPPROVED = 1

'Following are the constants used for PDC Entry Type
Public Const REP_REGULAR_ENTRY = 0
Public Const REP_PDC_ENTRY = 1
Public Const REP_ALL_ENTRY = 2

'Following are the constants used for selecting the papertype to print the vouchers
Public Const PAPER_TYPE_CONTINOUS = 0
Public Const PAPER_TYPE_CUTSHEET = 1

'Following are the constants used for Summary Type in Rep Options
Public Const SUMM_TYPE_ALL = 0
Public Const SUMM_TYPE_MOVED_ONLY = 1
Public Const SUMM_TYPE_MOVED_OR_BAL = 2

'Date in Month Format Date Type
Public Const MONTH_START_DATE = 1
Public Const MONTH_END_DATE = 2

Public Const SECMODE_DONGLE = 0
Public Const SECMODE_BUSYSERVER = 1

'Following are the constants used as Status in Notes Manager
Public Const NM_STATUS_ACTIVE = 0
Public Const NM_STATUS_DEACTIVE = 1


'Following are the constants used for Reminder Interval in Notes Manager
Public Const NM_INTERVAL_ONLY_ONCE = 0
Public Const NM_INTERVAL_15_MIN = 1
Public Const NM_INTERVAL_30_MIN = 2
Public Const NM_INTERVAL_60_MIN = 3

'Following are the constants used in Transport Details
Public Const TRANSPORT_TYPE_ALL = 0
Public Const TRANSPORT_TYPE_ALL_BLANK = 1
Public Const TRANSPORT_TYPE_ANY_BLANK = 2


'Serial Numbering Type
Public Const ITEM_SRNO_TYPE_MANUAL_NUMBERING = 1
Public Const ITEM_SRNO_TYPE_AUTO_NUMBERING = 2


'FREQUENCY
Public Const ITEM_SRNO_AUTO_NUM_FREQ_DAILY = 1
Public Const ITEM_SRNO_AUTO_NUM_FREQ_MONTHLY = 2
Public Const ITEM_SRNO_AUTO_NUM_FREQ_YEARLY = 3

'AUTO NUMBERING STRUCTURE COMPONENTS
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_ITEM_ALIAS = 1
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_MC_ALIAS = 2
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_PARTY_ALIAS = 3
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_DAY = 4
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_MONTH = 5
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_YEAR = 6
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_AUTO_NO = 7
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_CUSTOM = 8
Public Const ITEM_SRNO_AUTO_NUM_COMPONENT_ITEM_GRP_ALIAS = 9

'Component Alignment
Public Const ITEM_SRNO_STRUCT_COMP_PAD_LEFT = 1
Public Const ITEM_SRNO_STRUCT_COMP_PAD_RIGHT = 2

'Configurable Item Body
Public Const ITEM_BODY_AUTOMATIC = 0
Public Const ITEM_BODY_CONFIGURED = 1

'Logo Positioning
Public Const TOP_LEFT = 1
Public Const TOP_RIGHT = 2
Public Const TOP_CENTRE = 3

'Logo Embedding
Public Const LOGO_SUPERIMPOSE = 0
Public Const LOGO_SPACE = 1


'Const used for Preview
Public Const MODE_PRINT_DIRECT = 0
Public Const MODE_PREVIEW = 1
Public Const MODE_PDF = 2
Public Const MODE_IMAGE = 3
Public Const MODE_PRINT_THRU_TOOL = 4

Public Const MIN_TOP_MARGIN = 0.1
Public Const MIN_LEFT_MARGIN = 0.1

Public Const MIN_ZOOMIN_PERCENT = 90
Public Const MAX_ZOOMIN_PERCENT = 100

''Printing Configuration type Constant for Serial No
Public Const PRINT_USE_SEP_LINE_FOR_SRNO = 1
Public Const PRINT_CONCATE_ALL_SRNO = 2


Public Const POS_MIN_COL_WIDTH = 0.15 '0.4  'in inches
Public Const POS_MAX_GRID_SIZE = 8.75      'in inches   '12645/1440 = 8.78 '9.5 '7.2
Public Const POS_TOTAL_GRID_WIDTH = 12600 '12645   'in twips



'Const used for ShortCut Key
Public Const SC_KEY_CONFIG = 1
Public Const SC_KEY_UTILITIES = 2
Public Const SC_KEY_EXPORTIMPORT = 3
Public Const SC_KEY_QUERY_SYSTEM = 4

'Const used for Configuration ShortCut
Public Const SC_CONFIG_FEATURES = 1
Public Const SC_CONFIG_HARDWARE = 2
Public Const SC_CONFIG_MASTERS = 3
Public Const SC_CONFIG_VOUCHERS = 4
Public Const SC_CONFIG_WARNING = 5
Public Const SC_CONFIG_DOC_STANDARD = 6
Public Const SC_CONFIG_DOC_ADVANCED = 7
Public Const SC_CONFIG_BACKUP = 8
Public Const SC_CONFIG_EMAIL = 9
Public Const SC_CONFIG_SMS = 10

'Const used for Utilities ShortCut
Public Const SC_UTILITIES_DATAFREEZING = 1
Public Const SC_UTILITIES_UPDATE_BAL_SHEET_STOCK = 2
Public Const SC_UTILITIES_MASTER_SYN = 3
Public Const SC_UTILITIES_UPDATE_MAST_BALANCE = 4
Public Const SC_UTILITIES_UPDATE_TRANSPORT_DET = 5
Public Const SC_UTILITIES_SEND_EMAIL = 6
Public Const SC_UTILITIES_SEND_SMS = 7
Public Const SC_UTILITIES_UPDATE_DAILY_MESSAGE = 8
Public Const SC_UTILITIES_UPDATE_MASTER_PN = 9
Public Const SC_UTILITIES_ITEM_SN_INSTALLATION_DET = 10
Public Const SC_UTILITIES_APPROVAL_DATA_ENTRY = 11
Public Const SC_UTILITIES_BLOCK_MASTER = 12
Public Const SC_UTILITIES_DEACTIVATE_MASTER = 13

'Const used for Export/Import ShortCut
Public Const SC_EXPORTIMPORT_MAST_BUSY_DOS = 1
Public Const SC_EXPORTIMPORT_MAST_EXCEL_ITEM = 2
Public Const SC_EXPORTIMPORT_MAST_EXCEL_ACC = 3
Public Const SC_EXPORTIMPORT_MAST_TXT_ITEM = 4
Public Const SC_EXPORTIMPORT_MAST_TXT_ACC = 5
Public Const SC_EXPORTIMPORT_BUSY_DOS = 6
Public Const SC_EXPORTIMPORT_SQL = 7
Public Const SC_EXPORTIMPORT_VCH_EXCEL = 8
Public Const SC_EXPORTIMPORT_IMPORT_XML = 9
Public Const SC_EXPORTIMPORT_EXPORT_MAST_XML = 10
Public Const SC_EXPORTIMPORT_EXPORT_TRAN_XML = 11


'Const used for Query Systems
Public Const SC_QUERY_SYSTEM_TRANSACTION = 1
Public Const SC_QUERY_SYSTEM_ITEM_BALANCES = 2
Public Const SC_QUERY_SYSTEM_ACC_BALANCES = 3
Public Const SC_QUERY_SYSTEM_ITEM_BATCHES = 4
Public Const SC_QUERY_SYSTEM_ITEM_SERIALNO = 5
Public Const SC_QUERY_SYSTEM_SQL_QUERY = 6
Public Const SC_QUERY_SYSTEM_BCN = 7
Public Const SC_QUERY_SYSTEM_ITEM_PRICE = 8

'Const to be used for Grid col calculation for Columnar reports

Public Const GRD_COL_SIZE_MULTIPLIER = 90

'Const used for ReflectIn Field used in Haryana LP-8/LS-10 Vouchers.

Public Const REG_TYPE_A = 0
Public Const REG_TYPE_B = 1
Public Const REG_TYPE_C = 2
Public Const REG_TYPE_D = 3

'Const used in Parameter wise stock
Public Const STOCK_PARAM_TYPE_OPEN = 1
Public Const STOCK_PARAM_TYPE_RESTRICTED = 2

Public Const STOCK_PARAM_CONF_MODE_DEFAULT = 0
Public Const STOCK_PARAM_CONF_MODE_SEPERATE = 1

Public Const STPT_SPECIFY_ACC_HERE = 0
Public Const STPT_SPECIFY_ACC_HERE_FOR_SEPARATE_TAX_RATE = 1
Public Const STPT_SPECIFY_ACC_IN_VOUCHER = 2
 
Public Const HTTPREQUEST_PROXY_SETTING_PROXY = 2

'Charu
Public Const PN_NAME = 1
Public Const PN_ALIAS = 2
Public Const PN_GRPNAME = 3
Public Const PN_GRPALIAS = 4
Public Const PN_OF1 = 5
Public Const PN_OF2 = 6
Public Const PN_OF3 = 7
Public Const PN_OF4 = 8
Public Const PN_OF5 = 9
Public Const PN_OF6 = 10
Public Const PN_OF7 = 11
Public Const PN_OF8 = 12
Public Const PN_OF9 = 13
Public Const PN_OF10 = 14


'Serial No Negative Stock Constant
Public Const SERIALNO_WARNING_STOP = 0
Public Const SERIALNO_WARNING_KEEPMUM = 1
Public Const SERIALNO_WARNING_WARNONLY = 2


' Constants for Location Browse Class
Public Const BROWSE_COUNTRY = 0
Public Const BROWSE_STATE = 1
Public Const BROWSE_CITY = 2


' SMS Truncation
Public Const MOBILE_LEAVE_AS_IT_IS = 0
Public Const MOBILE_TRUNCATION_ONLY = 1
Public Const MOBILE_TRUNCATION_PREFIX = 2

Public Const FILTER_TYPE_AMT = 1 'Neha

' Const for displaying additional info in Acc/Item master list
Public Const ADDN_INFO_ITEM_NAME_ALIAS = 1
Public Const ADDN_INFO_ITEM_PARENT_GRP_NAME = 2
Public Const ADDN_INFO_ITEM_PARENT_GRP_ALIAS = 3
Public Const ADDN_INFO_ITEM_MRP = 4
Public Const ADDN_INFO_ITEM_SALES_PRICE = 5
Public Const ADDN_INFO_ITEM_OP_FIELD1 = 6
Public Const ADDN_INFO_ITEM_OP_FIELD2 = 7
Public Const ADDN_INFO_ITEM_CURRENT_STOCK = 8
Public Const ADDN_INFO_ITEM_DESC_1 = 9
Public Const ADDN_INFO_ITEM_DESC_2 = 10
Public Const ADDN_INFO_ITEM_DESC_3 = 11
Public Const ADDN_INFO_ITEM_DESC_4 = 12

Public Const ADDN_INFO_ACC_NAME_ALIAS = 1
Public Const ADDN_INFO_ACC_PARENT_GRP_NAME = 2
Public Const ADDN_INFO_ACC_PARENT_GRP_ALIAS = 3
Public Const ADDN_INFO_ACC_OP_FIELD1 = 4
Public Const ADDN_INFO_ACC_OP_FIELD2 = 5
Public Const ADDN_INFO_ACC_CURRENT_BAL = 6
Public Const ADDN_INFO_ACC_ADD1 = 7
Public Const ADDN_INFO_ACC_ADD2 = 8
Public Const ADDN_INFO_ACC_ADD3 = 9
Public Const ADDN_INFO_ACC_ADD4 = 10
Public Const ADDN_INFO_ACC_TEL_NO = 11
Public Const ADDN_INFO_ACC_FAX = 12
Public Const ADDN_INFO_ACC_MOBILE_NO = 13
Public Const ADDN_INFO_ACC_EMAIL = 14
Public Const ADDN_INFO_ACC_CONT_PERSON = 15
Public Const ADDN_INFO_ACC_TIN = 16
Public Const ADDN_INFO_ACC_LST_NO = 17
Public Const ADDN_INFO_ACC_CST_NO = 18
Public Const ADDN_INFO_ACC_STATION = 19
Public Const ADDN_INFO_ACC_TRANSPORT = 20
Public Const ADDN_INFO_ACC_PAN_NO = 21

' Const for displaying additional info in Employee master list
Public Const ADDN_INFO_EMP_NAME_ALIAS = 1
Public Const ADDN_INFO_EMP_PARENT_GRP_NAME = 2
Public Const ADDN_INFO_EMP_PARENT_GRP_ALIAS = 3
Public Const ADDN_INFO_EMP_OP_FIELD1 = 4
Public Const ADDN_INFO_EMP_OP_FIELD2 = 5
Public Const ADDN_INFO_EMP_ADD1 = 6
Public Const ADDN_INFO_EMP_ADD2 = 7
Public Const ADDN_INFO_EMP_ADD3 = 8
Public Const ADDN_INFO_EMP_ADD4 = 9
Public Const ADDN_INFO_EMP_TEL_NO = 10
Public Const ADDN_INFO_EMP_MOBILE_NO = 11
Public Const ADDN_INFO_EMP_FAX = 12
Public Const ADDN_INFO_EMP_EMAIL = 13
Public Const ADDN_INFO_EMP_CURRENT_STATUS = 14
Public Const ADDN_INFO_EMP_DOJ = 15

' ********Message Status************      'By Uday

Public Const UNPICKED_MSG = 0
Public Const UNREAD_MESSAGE = 1           'Msg Status
Public Const READ_MESSAGE = 2              'Msg Status

'Folder Type
Public Const INBOX_MESSAGE = 0
Public Const SENT_MESSAGE = 1
Public Const DELETED_MESSAGE = 2
Public Const OTHER_MESSAGE = 3
Public Const ADD_TO_NOTES = 4

' Grid Action
Public Const READ = 0                           'Action on grid
Public Const FORWARD = 1                        'Action on grid
Public Const Delete = 2                         'Action on grid
Public Const ADD_NOTE = 3                       'Action on grid

' Action For Msg
Public Const UPDATE_MSG = 0
Public Const DELETE_MSG = 1


'****************************

'RecType for Update Master Balance Utility (frmUpdateMasterBalances)
Public Const UTILITY_MAST_BAL_UPDATION = 0
Public Const UTILITY_BATCH_PRICE_UPDATION = 1
Public Const UTILITY_ORDER_PRICE_UPDATION = 2
Public Const UTILITY_REGEN_HELP_FILE = 3
Public Const UTILITY_UPDATE_VOUCHER_VAT_SUM = 4
Public Const UTILITY_CHALLAN_AMOUNT_UPDATION = 5
Public Const UTILITY_MAP_CHALLAN_REFS = 6
Public Const UTILITY_MAP_ORDER_REFS = 7

'Below const are defined for format tagging with their type

Public Const FORMAT_TYPE_PRINT = 0
Public Const FORMAT_TYPE_SMS = 1
Public Const FORMAT_TYPE_EMAIL = 2

' Following const are used in Sales/Purchase Analysis Report.

Public Const SHOW_NETT_SP = 1
Public Const SHOW_SP_AND_SR_PR = 2
Public Const SHOW_SP = 3
Public Const SHOW_SR_PR = 4

Public Const VCH_AUTHORISATION_ALL_SERIES = 1

'Const for Unapproved Voucher Restrictions
Public Const RESTRICT_PRINT_EMAIL_SMS = 1
Public Const POST_IN_VCH = 2
'Public Const RESTRICT_VCH_ADJ = 2
'Public Const RESTRICT_ADJ_IN_OTHER_VCH = 3


' const for Unapproved Masters
Public Const RESTRICT_SHOW_MASTER = 1

Public Const APPROVAL_NOT_REQD = 0
Public Const APPROVED = 1
Public Const TO_BE_APPROVED = 2
Public Const APP_ALL_ENTRIES = 3

' const for Audit Voucher
Public Const UNAUDITED = 0
Public Const AUDITED = 1

'Const for used in MonthlyQuarterly sale/Purchase Analysis report
Public Const SHOW_MONTHLY = 1
Public Const SHOW_QUARTERLY = 2

'Serial No. Adjustment Mode
Public Const SRNO_ADJMODE_CONTINUOUS = 0
Public Const SRNO_ADJMODE_DISCRETE = 1


'Default Date Type
Public Const TYPE_LAST_VCH_DATE = 0
Public Const TYPE_SYSTEM_DATE = 1

'Default Date Type - POS
Public Const TYPE_POS_SYSTEM_DATE = 0
Public Const TYPE_POS_LAST_VCH_DATE = 1

'Serial No Image Name based on
Public Const IMAGE_NAME_ONLY_SERIALNO = 1
Public Const IMAGE_NAME_ITEMNAME_SERIALNO = 2
Public Const IMAGE_NAME_ITEMALIAS_SERIALNO = 3


'Below Const Are Defined for Offline Messageing

Public Const EMAIL_TO = "01"
Public Const EMAIL_CC = "02"
Public Const EMAIL_BCC = "03"
Public Const EMAIL_SUBJECT = "04"
Public Const EMAIL_EXT_ATT = "05"
Public Const EMAIL_ATT_FILE_NAME = "06"
Public Const EMAIL_HEADER = "07"
Public Const EMAIL_FOOTER = "08"
Public Const EMAIL_BODY_TYPE = "09"
Public Const EMAIL_BODY = "10"
Public Const EMAIL_STRCHAR = "11"
Public Const EMAIL_TYPE = "12"
Public Const EMAIL_SMTP_SERVER = "13"
Public Const EMAIL_SMTP_USER = "14"
Public Const EMAIL_SMTP_PWD = "15"
Public Const EMAIL_SMTP_FROM = "16"
Public Const EMAIL_SMTP_REPLYTO = "17"
Public Const EMAIL_SMTP_PORT = "18"


Public Const SMS_MOBILE_NO = "01"
Public Const SMS_MESSAGE = "02"
Public Const SMS_API_FORMAT = "03"

Public Const TYPE_OFFLINE_MAIL = 1
Public Const TYPE_OFFLINE_SMS = 2

'used for pending bills orders report    ----Neha
Public Const SHOW_ALL_DOC = 1
Public Const SHOW_PENDING_ALL_DOC = 2
Public Const SHOW_PENDING_UNCLEARED_DOC = 3

'Added by Jitendra for showing pictures in repListView (30-12-09)
Public Const PIC_GREEN_BULLET = "GREEN_BULLET"
Public Const PIC_RED_BULLET = "RED_BULLET"

'const for showing check box pictures in frmApproval
Public Const CHK_BOX_CHECKED = "IMG_CHK"
Public Const CHK_BOX_UNCHECKED = "IMG_UNCHK"

Public Const UDF_TEXT = 1
Public Const UDF_INTEGER = 2
Public Const UDF_INT = 2
Public Const UDF_LONG = 3
Public Const UDF_SINGLE = 4
Public Const UDF_DOUBLE = 5
Public Const UDF_DBL = 5
Public Const UDF_DATE = 6
Public Const UDF_BOOLEAN = 7
Public Const UDF_BOOL = 7
Public Const UDF_DATE_TIME = 8
Public Const UDF_UNKNOWN = 9
Public Const UDF_DOUBLE_WITH_DR_CR = 10
Public Const UDF_SQL_FUNCTION = 11

Public Const WORKED_ON_MASTER = 1
Public Const WORKED_ON_TRANSACTION = 2
Public Const WORKED_ON_REPORT = 3
Public Const WORKED_ON_CONFIG = 4
Public Const WORKED_ON_UTILITIES = 5
Public Const WORKED_ON_DATA_IE = 6
Public Const WORKED_ON_LOGIN_LOGOUT = 7

Public Const LOG_FOR_ADD = 1
Public Const LOG_FOR_MODIFY = 2
Public Const LOG_FOR_DELETE = 3
Public Const LOG_FOR_REP_SCR = 4
Public Const LOG_FOR_REP_PRINT = 5
Public Const LOG_FOR_REP_EMAIL = 6
Public Const LOG_FOR_REP_SMS = 7
Public Const LOG_FOR_REP_EXPORT = 8
Public Const LOG_FOR_REP_PREVIEW = 9
Public Const LOG_FOR_LOGIN = 10
Public Const LOG_FOR_LOGOUT = 11
Public Const LOG_FOR_APPROVAL = 12

'--- Constants for frmGetText ActionID
Public Const GETTEXT_CLEARUSERLOG = 1
Public Const GETTEXT_VCHAUDITUSERNAME = 2
'Database Import
'SECTION_VCH_HEADER/SECTION_MASTER_HEADER
Public Const SECTION_ID_HEADER = 1
Public Const SECTION_ID_VCH_BODY = 2
Public Const SECTION_ID_VCH_FOOTER = 3
Public Const SECTION_ID_BILL_REFERENCE = 4
Public Const SECTION_ID_BATCH_REFERENCE = 5
Public Const SECTION_ID_ORDER_REFERENCE = 6
Public Const SECTION_ID_CHALLAN_REFERENCE = 7

Public Const DB_IMPORT_ITEM_MAST = 1
Public Const DB_IMPORT_ACC_MAST = 2
Public Const DB_IMPORT_MC_MAST = 3
Public Const DB_IMPORT_CC_MAST = 4

Public Const DB_IMPORT_PURCHASE = 101
Public Const DB_IMPORT_SALE = 102
Public Const DB_IMPORT_PURCHASE_RETURN = 103
Public Const DB_IMPORT_SALE_RETURN = 104
Public Const DB_IMPORT_MATERIAL_ISSUE = 105
Public Const DB_IMPORT_MATERIAL_RECEIPT = 106
Public Const DB_IMPORT_STOCK_TRANSFER = 107
Public Const DB_IMPORT_PRODUCTION = 108
Public Const DB_IMPORT_UNASSEMBLE = 109
Public Const DB_IMPORT_STOCK_JOURNAL = 110
Public Const DB_IMPORT_PURCHASE_ORDER = 111
Public Const DB_IMPORT_SALE_ORDER = 112
Public Const DB_IMPORT_PAYMENT = 113
Public Const DB_IMPORT_RECEIPT = 114
Public Const DB_IMPORT_CONTRA = 116
Public Const DB_IMPORT_JOURNAL = 117
Public Const DB_IMPORT_DR_NOTE = 118
Public Const DB_IMPORT_CR_NOTE = 119

Public Const DB_OPEN_TABLE = 1
Public Const DB_OPEN_DYNASET = 2
Public Const DB_OPEN_SNAPSHOT = 4
Public Const DB_OPEN_FORWARDONLY = 8
Public Const DB_OPEN_DYNAMIC = 16

Public Const SOURCE_SELF_FEEDED = 0
Public Const SOURCE_DATA_SYNC = 1
Public Const SOURCE_EXCEL_SHEET = 2
Public Const SOURCE_BUSY_XML = 3
Public Const SOURCE_THIRD_PARTY = 4

'Const used for On Enter of Custom report
Public Const OE_MODIFY_VOUCHER = 1
Public Const OE_MODIFY_MASTER = 2
Public Const OE_ACC_LEDGER = 3
Public Const OE_ITEM_LEDGER = 4
Public Const OE_ACC_SUMMARY = 5
Public Const OE_ITEM_SUMMARY = 6
Public Const OE_TRIAL_BALANCE = 7
Public Const OE_STOCK_STATUS = 8
Public Const OE_LIST_OF_VCH = 9
Public Const OE_CUSTOM_REPORT = 10



'Const to be used for Field Separators
Public Const FIELD_SEPARATOR = 1
Public Const RECORD_SEPARATOR = 2
Public Const VALUE_SEPARATOR = 255

Public Const FIELD_SEPARATOR1 = 3
Public Const RECORD_SEPARATOR1 = 4
Public Const VALUE_SEPARATOR1 = 254

Public Const FIELD_SEPARATOR2 = 5
Public Const RECORD_SEPARATOR2 = 6
Public Const VALUE_SEPARATOR2 = 253

'Const to be used for Field Separators if String used in XML
Public Const FIELD_SEPARATOR_XML = 250
Public Const RECORD_SEPARATOR_XML = 251
Public Const VALUE_SEPARATOR_XML = 252



'Const to Be used for Form Effect
  
Public Const EFFECT_LEFT_TOP_TO_BUTTOM = 1
Public Const EFFECT_TOP_TO_BUTTOM = 2
Public Const EFFECT_BUTTOM_TO_TOP = 3
Public Const EFFECT_FADE_OUT = 4
Public Const EFFECT_FADE_IN = 5
Public Const EFFECT_RIGHT_TO_LEFT = 6


''const to be used in Param BCN Generation
'Public Const PARAM_FIELD_PARAM_NAME1 = 1
'Public Const PARAM_FIELD_PARAM_NAME2 = 2
'Public Const PARAM_FIELD_PARAM_NAME3 = 3
'Public Const PARAM_FIELD_PARAM_ALIAS1 = 4
'Public Const PARAM_FIELD_PARAM_ALIAS2 = 5
'Public Const PARAM_FIELD_PARAM_ALIAS3 = 6
'Public Const PARAM_FIELD_ITEM_GRP_NAME = 7
'Public Const PARAM_FIELD_ITEM_GRP_ALIAS = 8
'Public Const PARAM_FIELD_ITEM_NAME = 9
'Public Const PARAM_FIELD_ITEM_ALIAS = 10
'Public Const PARAM_FIELD_MRP = 11
'Public Const PARAM_FIELD_SALES_PRICE = 12
'

''''''''Constants to be used for common naming form ''frmVchseries

Public Const NAME_SMSAPI = 1
Public Const NAME_SQLQUERY = 2
Public Const NAME_CUSTOM_REPORT = 3
Public Const NAME_IMPORTDB = 4
'Public Const NAME_PARAM_BCN = 5
Public Const NAME_POS_MODE = 6
Public Const NAME_IBC_MODE = 7
Public Const NAME_VCH_SERIES_GRP = 8
'Public Const NAME_TAX_CATEGORY = 9
Public Const NAME_BRANCH = 10
Public Const NAME_TRIGGER = 11
Public Const NAME_CUSTOM_DATA_ENTRY = 12

''''Const to be used for Check List
Public Const ACTION_ADD = 1
Public Const ACTION_MODIFY = 2
Public Const ACTION_APPROVAL = 3
Public Const ACTION_LIST = 4
Public Const ACTION_DELETE = 5
Public Const ACTION_VIEW = 6
Public Const ACTION_CANCEL = 7
Public Const ACTION_READ = 8 ' Prasun
Public Const ACTION_AUDIT = 9       'sumiti

''''Const to be used for Restoring Custom Scripts
Public Const RESTORE_CUSTOM_REPORT = 1
Public Const DELETE_CUSTOM_REPORT = 2
Public Const BACKUP_CUSTOM_REPORT = 3

''Const to be used for Offline Msg Form
Public Const TYPE_OFFLINE_MSG = 1
Public Const TYPE_TRIGGER = 2


'' Constant for TRIGGERS


'**************************************************************
'**************************************************************
'**************************************************************
'      Below are const Declare for Trigger Please Dont
'            Specify const in Between this segment
'**************************************************************
'**************************************************************
'**************************************************************


'' Constant for TRIGGERS


Public Const TG_ADD_MASTER = 1
Public Const TG_MODIFY_MASTER = 2
Public Const TG_DELETE_MASTER = 3
Public Const TG_CHANGE_IN_MASTER_BALANCE = 4
Public Const TG_ADD_VCH = 5
Public Const TG_MODIFY_VCH = 6
Public Const TG_DELETE_VCH = 7

Public Const TG_RANGE_MAST_ONE = 1
Public Const TG_RANGE_MAST_GRP = 2
Public Const TG_RANGE_MAST_ALL = 3
Public Const TG_RANGE_SERIES_ONE = 4
Public Const TG_RANGE_SERIES_ALL = 5

Public Const TG_JOIN_TYPE_AND = 1
Public Const TG_JOIN_TYPE_OR = 2


Public Const TG_VALUE_GREATER_TO = 1
Public Const TG_VALUE_BELOW_TO = 2
Public Const TG_VALUE_GREATER_EQUAL_TO = 3
Public Const TG_VALUE_BELOW_EQUAL_TO = 4
Public Const TG_VALUE_EQUAL_TO = 5
Public Const TG_VALUE_NOT_EQUAL_TO = 6

Public Const TG_ACTION_SMS = 1
Public Const TG_ACTION_EMAIL = 2
Public Const TG_ACTION_MSGC = 3
Public Const TG_ACTION_SPECIFIC = 4
Public Const TG_ACTION_PARTY = 5

Public Const TG_NUMERIC_CONDITION = 1
Public Const TG_SHOW_LIST = 2
Public Const TG_BLANK_CONDITION = 3

Public Const TG_ONE_MASTER = 1
Public Const TG_MASTER_GROUP = 2
Public Const TG_ALL_MASTER = 3
Public Const TG_ONE_SERIES = 4
Public Const TG_ALL_SERIES = 5

' Condition Below are for Master only

Public Const TG_MAST_HAVING_OP_BAL = 1

'condition below is to identify vch master
Public Const TG_VCH_PARTY = 101
Public Const TG_VCH_PARTY_GRP = 102
Public Const TG_VCH_ITEM = 103
Public Const TG_VCH_ITEM_GRP = 104
Public Const TG_VCH_MC = 105
Public Const TG_VCH_MC_GRP = 106
Public Const TG_VCH_TARGET_MC = 107
Public Const TG_VCH_TARGET_MC_GRP = 108
Public Const TG_VCH_BILL_SUNDRY = 109
Public Const TG_VCH_SALE_TYPE = 110
Public Const TG_VCH_PURCHASE_TYPE = 111
Public Const TG_VCH_BOM = 112
Public Const TG_VCH_BROKER = 113
Public Const TG_VCH_ACCOUNT = 114
Public Const TG_VCH_ACCOUNT_GRP = 115

'condition below are for vch values
Public Const TG_VCH_TOTAL_VALUE = 201
Public Const TG_VCH_TOTAL_QTY = 202
Public Const TG_VCH_TOTAL_GEN_QTY = 203
Public Const TG_VCH_TOTAL_QTY_RM = 204
Public Const TG_VCH_ACCOUNT_VALUE = 205


'vch item related
Public Const TG_VCH_ITEM_DISCOUNT_PERCENT = 301
Public Const TG_VCH_ITEM_DISCOUNT_VALUE = 302
Public Const TG_VCH_ITEM_PRICE = 303
Public Const TG_VCH_ITEM_QTY_MAIN = 304
Public Const TG_VCH_ITEM_QTY_ALT = 305
Public Const TG_VCH_ITEM_AMT = 306
Public Const TG_ITEM_BELOW_MIN_SALE_PRICE = 307
Public Const TG_VCH_ITEM_DISCOUNT_AMT = 308

'vch Bill sundry
Public Const TG_VCH_BILL_SUNDRY_AMT = 401
Public Const TG_VCH_BILL_SUNDRY_PERCENT = 402

'Below condition are for master balances
Public Const TG_MASTBAL_MASTERBALANCE = 501
Public Const TG_MASTBAL_CREDIT_LIMIT_CROSSED = 502
Public Const TG_MASTBAL_MAX_LEVEL_CROSSED = 503
Public Const TG_MASTBAL_MIN_LEVEL_CROSSED = 504
Public Const TG_MASTBAL_REORDER_LEVEL_CROSSED = 505
Public Const TG_MASTBAL_ITEM_QTY = 506
Public Const TG_MASTBAL_NEGATIVE_QTY = 507

'Condition Type
Public Const TG_CON_TYPE_CON1 = 1
Public Const TG_CON_TYPE_CON2 = 2
Public Const TG_CON_TYPE_SUBCON1 = 3
Public Const TG_CON_TYPE_SUBCON2 = 4


'Condition on consumed or generated for Stock journal,Production,Unassemble
Public Const TG_CON_GENERATED = 1
Public Const TG_CON_CONSUMED = 2

'**************************************************************
'**************************************************************
'**************************************************************
'      Above are const Declare for Trigger Please Dont
'            Specify const in Between this segment
'**************************************************************
'**************************************************************
'**************************************************************






'const for sale/purc acc tagging
Public Const SALE_PURC_ACC_WITH_ST_PT_MAST = 0
Public Const SALE_PURC_ACC_WITH_ITEM = 1
Public Const SALE_PURC_ACC_WITH_MC = 2


'Const used for POS Priority while reading from Barcode
Public Const POS_PRIORITY_ITEM = 1
Public Const POS_PRIORITY_BCN = 2
Public Const POS_PRIORITY_SRNO = 3
Public Const POS_PRIORITY_BATCH = 4
Public Const POS_PRIORITY_COMPOSITE = 5


'Const Used For Picking Items from ListView in frmPickMRP form
Public Const PICK_ITEM_FROM_MRP = 0
Public Const PICK_ITEM_FROM_SRNO = 1
Public Const PICK_ITEM_FROM_BATCH = 2


'Const used for Custom Scripts
Public Const CUSTOM_SCRIPT_FOR_REPORTS = 1
Public Const CUSTOM_SCRIPT_FOR_DATA_ENTRY = 2

'Const used for brokerage debit account to be selected from
Public Const BROK_DR_ACC_SPECIFY_HERE = 0
Public Const BROK_DR_ACC_VCH_SALE_PURC_ACC = 1
Public Const BROK_DR_ACC_PARTY_ACC = 2

Public Const BO_DESYNCED_ALL_VCH = 0
Public Const BO_DESYNCED_PARTIAL_VCH = 1
Public Const BO_DESYNCED_NO_VCH = 2

'For HOBO
Public Const BO_TO_HO_DATASYNC = 1
Public Const HO_REJECTED_DATASYNC = 2
Public Const HO_TO_BO_DATASYNC = 3
Public Const BO_REJECTED_DATASYNC = 4
Public Const HO_DELETED_DATASYNC = 5
Public Const BO_DELETED_DATASYNC = 6
Public Const HO_TO_BO_BANK_RECO_DATASYNC = 7
Public Const BO_TO_HO_BANK_RECO_DATASYNC = 8

Public Const BO_VIEW_REJECTION_DATASYNC = 9
Public Const BO_DELETE_REJECTION_DATASYNC = 10
Public Const HO_VIEW_REJECTION_DATASYNC = 11
Public Const HO_DELETE_REJECTION_DATASYNC = 12
Public Const HO_SAVE_BO_DATASYNC = 13
Public Const BO_SAVE_HO_DATASYNC = 14
Public Const HO_DELETE_BO_DATASYNC = 15
Public Const BO_DELETE_HO_DATASYNC = 16
Public Const HO_READ_SUCCESS_BO_DATASYNC = 17
Public Const HO_READ_UNSUCCESS_BO_DATASYNC = 18
Public Const BO_READ_SUCCESS_HO_DATASYNC = 19
Public Const BO_READ_UNSUCCESS_HO_DATASYNC = 19
Public Const HOBO_CONFIG_CHANGED = 20


Public Const SOURCE_HO_SYNC_LOG = 1
Public Const SOURCE_BO_SYNC_LOG = 2


'''Constants to match company configurations thru Data Sync or Import
Public Const CONFIG_CHECK_FOR_IMPORT = 1
Public Const CONFIG_CHECK_FOR_DATA_SYNC = 2


''''''''''Constants For Maintaining Sub Ledger
Public Const LEDGER_TYPE_GENERAL = 0
Public Const LEDGER_TYPE_SUB = 1


'Const for ItemGrouping during Invoice Body printing
Public Const ITEMGROUPING_BASIS_ITEM = 1
Public Const ITEMGROUPING_BASIS_ITEM_GRP = 2
Public Const ITEMGROUPING_BASIS_MC = 3
Public Const ITEMGROUPING_BASIS_ITEM_AF = 4
Public Const ITEMGROUPING_BASIS_ITEM_OF1 = 5
Public Const ITEMGROUPING_BASIS_ITEM_OF2 = 6

Public Const ITEMGROUPING_ACTION_EJECT = 1
Public Const ITEMGROUPING_ACTION_BLANK_LINE = 2
Public Const ITEMGROUPING_ACTION_SEMI_CUT = 3
Public Const ITEMGROUPING_ACTION_PAPER_CUT = 4
Public Const ITEMGROUPING_ACTION_COMMAND1 = 5
Public Const ITEMGROUPING_ACTION_COMMAND2 = 6
Public Const ITEMGROUPING_ACTION_COMMAND3 = 7

''''''''Constants for RecType property of frmBlockMaster
Public Const BLOCK_MASTER = 1
Public Const DEACTIVATE_MASTER = 2



'''''Constants for how Ledger to bbe shown
Public Const SHOW_LEDGER_SINGLE = 0
Public Const SHOW_LEDGER_CORRESPONDING = 1
Public Const SHOW_LEDGER_ALL = 2


'Const for Pole Display
Public Const POLE_DISPLAY_THRU_COM_PORT = 1
Public Const POLE_DISPLAY_THRU_PRINTER = 2

''''''''Advanced printing for CPR Script'''''''''''''sumiti

Public Const PRCONFIG_CAT_COMPANY = "C01"
Public Const PRCONFIG_CAT_PARTY = "C02"
Public Const PRCONFIG_CAT_MATERIAL_CENTRE = "C03"
Public Const PRCONFIG_CAT_BILL_SUNDRY = "C04"
Public Const PRCONFIG_CAT_QUANTITY_AMOUNT = "C05"
Public Const PRCONFIG_CAT_VAT = "C06"
Public Const PRCONFIG_CAT_MANUFACTURING_EXCISE = "C07"
Public Const PRCONFIG_CAT_TRADING_EXCISE_MANUFACTURING = "C08"
Public Const PRCONFIG_CAT_SERVICE_TAX = "C09"
Public Const PRCONFIG_CAT_BROKER = "C10"
Public Const PRCONFIG_CAT_VCH_HEADER = "C11"
Public Const PRCONFIG_CAT_SETTLEMENT = "C12"
Public Const PRCONFIG_CAT_OTHERS = "C13"
Public Const PRCONFIG_CAT_CHALLAN_ORDER = "C14"
Public Const PRCONFIG_CAT_TRADING_EXCISE_SUPPLIER = "C15"
Public Const PRCONFIG_CAT_BILL_REF = "C16"
Public Const PRCONFIG_CAT_TRADING_EXCISE_CURRENT = "C17"
Public Const PRCONFIG_CAT_QUANTITY = "C18"
Public Const PRCONFIG_CAT_AMOUNT = "C19"
Public Const PRCONFIG_CAT_BATCH = "C20"
Public Const PRCONFIG_CAT_ITEM = "C21"
Public Const PRCONFIG_CAT_SERIAL_NO = "C22"
Public Const PRCONFIG_CAT_PARAMETER = "C23"
Public Const PRCONFIG_CAT_TEXT = "C24"
Public Const PRCONFIG_CAT_PAGE = "C25"
Public Const PRCONFIG_CAT_ITEM_FIRST = "C26"
Public Const PRCONFIG_CAT_DATE = "C27"
Public Const PRCONFIG_CAT_OPT_DESC = "C28"
Public Const PRCONFIG_CAT_ADV_INVENTORY = "C29"
Public Const PRCONFIG_CAT_TAX = "C30"
Public Const PRCONFIG_CAT_AUTHOR = "C31"
Public Const PRCONFIG_CAT_ACCOUNT_FIELDS = "C32"
Public Const PRCONFIG_CAT_TARGET = "C33"
Public Const PRCONFIG_CAT_BUDGET = "C34"
Public Const PRCONFIG_CAT_EXCISE = "C35"

Public Const SHOW_ALL_ACC = 0              'neha
Public Const SHOW_PARTY_ACC = 1
Public Const SHOW_PARTYCASHBANK_ACC = 2


'BCN Negative Stock Constant
Public Const BCN_WARNING_STOP = 0
Public Const BCN_WARNING_KEEPMUM = 1
Public Const BCN_WARNING_WARNONLY = 2


'-------------Constants for Payroll

Public Const SALARY_MODE_BOTH = 0
Public Const SALARY_MODE_DAILY = 1
Public Const SALARY_MODE_MONTHLY = 2

''' Configuration Leave Calculation
Public Const FIXED_DAYS = 1
Public Const NO_OF_WORKING_DAYS = 2
Public Const NO_OF_DAYS = 3

Public Const PF_NO_LEN = 20
Public Const ESI_NO_LEN = 15

Public Const COMPONENT_TYPE_EPF = 1
Public Const COMPONENT_TYPE_ADMIN_PF = 2
Public Const COMPONENT_TYPE_EPS = 3
Public Const COMPONENT_TYPE_EDLI = 4
Public Const COMPONENT_TYPE_ADMIN_EDLI = 5
Public Const COMPONENT_TYPE_ESI_DEDUC = 6
Public Const COMPONENT_TYPE_ESI_CONTRI = 7
Public Const COMPONENT_TYPE_PF_DEDUC = 8

'Constants used in Employee master
'''''For Status
Public Const EMP_STATUS_PROBATION = 1
Public Const EMP_STATUS_CONFIRMED = 2
Public Const EMP_STATUS_RESIGNED = 3

'''' For Payment Mode
Public Const PMT_MODE_CASH = 1
Public Const PMT_MODE_CHEQUE = 2
Public Const PMT_MODE_BANK = 3
Public Const PMT_MODE_SALARY = 4
Public Const PMT_MODE_ALL = 5

''''For Gender
Public Const GENDER_MALE = 1
Public Const GENDER_FEMALE = 2

'------'Column Type for User Defined column-------'isha
Public Const UDF_FORMULA_BASED = 1
Public Const UDF_DATA_FIELD = 2
Public Const UDF_SPECIFY_COLUMN_NO = 3
Public Const UDF_SPECIFY_VCH_DETAILS = 4

'------'ReplistView Column ID Offset--------------'isha
Public Const COlUMN_ID_OFFSET = 100


' Salary Component Master Type
Public Const SAL_COMP_EARNING = 1
Public Const SAL_COMP_ADJUSTMENT = 2
Public Const SAL_COMP_STATUTORY = 3

'const for formula and Rectype for salary calculation vch
Public Const SALARY_CALC = 1
Public Const OVERTIME_CALC = 2
Public Const LEAVE_ENCASHMENT_CALC = 3

' Const ForSaving Fields in Memo Flds of MasterAddressInfo table for Employee Mast
' MF - denotes Memo Fld
' EMP - denotes Master Type; Employee in this case
Public Const MF_EMP_ESI_NOMINEE = "001"
Public Const MF_EMP_ESI_DISPENSARY = "002"
Public Const MF_EMP_PAN_NO = "003"
Public Const MF_EMP_PASSPORT_NO = "004"
Public Const MF_EMP_COUNTRY_OF_ISSUE = "005"
Public Const MF_EMP_PASSPORT_EXPIRY_DATE = "006"
Public Const MF_EMP_VISA_NO = "007"
Public Const MF_EMP_VISA_EXPIRY_DATE = "008"
Public Const MF_EMP_WORK_PERMIT_NO = "009"
Public Const MF_EMP_CONTRACT_START_DATE = "010"
Public Const MF_EMP_CONTRACT_EXPIRY_DATE = "011"

'------------------- Constants for Quotation Voucher         *surbhi
'-----QuoteStatus
Public Const QUOTATION_OPEN = 0
Public Const QUOTATION_CLOSED = 1
Public Const QUOTATION_ALL = 2
'-----QuoteSubStatus
Public Const QUOTATION_OPEN_NOT_USED = 0
Public Const QUOTATION_OPEN_PARTIAL_USED = 1
Public Const QUOTATION_CLOSED_NOT_USED = 2
Public Const QUOTATION_CLOSED_PARTIAL_USED = 3
Public Const QUOTATION_CLOSED_FULL_USED = 4

'-----------------------------------------------------'caption Saving----- 'isha
'#Region "Caption Saving Mode"
    Public Const FORM_MODE As Integer = 1
    Public Const GENERAL_MODE As Integer = 2
'#End Region

'#Region "Language Ids"
    Public Const LID_US_ENG As Long = 1
    Public Const LID_HINDI As Long = 2
'#End Region

'#Region "Form Ids"
    Public Const FID_NONE As Long = 0
    
    'common Child Forms(1-99)
    Public Const FID_CREDIT_LIMITS As Long = 1  ' AccMast , GroupMaster
    Public Const FID_EXCISE_INFO As Long = 2  ' AccMast , MC
    Public Const FID_FBT As Long = 3  ' AccMast , GroupMaster
    Public Const FID_OPTIONAL_FIELDS As Long = 4  ' AccMast , InvVch , POS , Journal , PayRec , Prod
    Public Const FID_BUDGET_TARGET As Long = 5  ' AccMast , GroupMaster
    Public Const FID_BROKER_DETAILS As Long = 6  ' AccMast , InvVch , POS , Item , BBDetOfOpBal
    Public Const FID_TAG_MASTER_SERIES As Long = 7  ' AccMast , MC , StPtMast , BSMast , CostCentreMast , GroupMaster , Item
    Public Const FID_NOTES As Long = 8  'AccMast , GroupMast
    
    'Masters(100-5000)
    Public Const FID_MAST_ACC As Long = 100
    
        Public Const FID_DEPRECIATION As Long = 101
        Public Const FID_TDS_INFO As Long = 102
        Public Const FID_MULTI_BOOL_OPTIONS As Long = 103
        Public Const FID_BB_DET_OF_OP_BAL As Long = 104
        Public Const FID_BRS_OP_REF As Long = 105
        Public Const FID_ACC_MULTI_CUR_OP_BAL As Long = 106
        
    Public Const FID_MAST_GROUP As Long = 200
        Public Const FID_CONFIG_STOCK_PARAM As Long = 201
        
    Public Const FID_MAST_SN As Long = 300
    
    Public Const FID_MAST_CUR As Long = 400
    
    Public Const FID_MAST_CUR_CON As Long = 500
    
    Public Const FID_MAST_AUTHOR As Long = 600
    
    Public Const FID_MAST_BROKER As Long = 700
'#End Region

'#Region "Form Sub Ids"
    'common
    Public Const SUB_FID_NONE As Long = 0
    Public Const SUB_FID_ACC As Long = 1
    
    Public Const SUB_FID_CHEQUES_DEPOSITED As Long = 2
    Public Const SUB_FID_CHEQUES_ISSUED As Long = 3
    
    Public Const SUB_FID_MC As Long = 4
    Public Const SUB_FID_GROUP As Long = 5
    
    Public Const SUB_FID_BUDGET As Long = 6
    Public Const SUB_FID_TARGET As Long = 7
    
    Public Const SUB_FID_CONFIG_COMP_STOCK_PARAM As Long = 8
    Public Const SUB_FID_CONFIG_IGRP_STOCK_PARAM As Long = 9
    
    Public Const SUB_FID_IGRP_MAST As Long = 10
    Public Const SUB_FID_BILL_REFGRP_MAST As Long = 11
    
    Public Const SUB_FID_BLOCKED_NOTES As Long = 12
    Public Const SUB_FID_FOR_MASTERS As Long = 13
    
        
'#End Region

'#Region "Field Caption IDs for General Config 10001"
    Public Const CID_RUN_TIME As Long = 9999
    Public Const CID_GENERAL_CAPTIONS  As Long = 10000
    
    Public Const CID_CHECKLIST  As Long = 10001
    Public Const CID_CHECKLIST_CREATED_BY_STR As Long = 10002
    Public Const CID_CHECKLIST_MODIFIED_BY_STR As Long = 10003
    Public Const CID_CHECKLIST_APPROVED_BY_STR As Long = 10004
    Public Const CID_CHECKLIST_APP_NOT_REQ_STR As Long = 10005
    Public Const CID_CHECKLIST_TO_BE_APP_STR As Long = 10006

    Public Const CID_ADD_STR As Long = 10007
    Public Const CID_MODIFY_STR As Long = 10008
    Public Const CID_DELETE_STR As Long = 10009
    Public Const CID_VIEW_STR As Long = 10010
    Public Const CID_VOUCHER_STR As Long = 10011
    Public Const CID_MASTER_STR As Long = 10012
    
    Public Const CID_BLOCKED_STATUS_BOTH_STR As Long = 10013
    Public Const CID_BLOCKED_STATUS_BLOCKED_STR As Long = 10014
    Public Const CID_BLOCKED_STATUS_DEACTIVATED_STR As Long = 10015
    Public Const CID_ORG_STR As Long = 10016
    
    Public Const CID_COMPOSITE_STR As Long = 10017
    Public Const CID_ACCOUNT_STR As Long = 10018
    Public Const CID_ON_ACCOUNT_STR As Long = 10019
    Public Const CID_AMOUNT_STR As Long = 10020
    Public Const CID_DR_STR As Long = 10021
    Public Const CID_CR_STR As Long = 10022
    '----------------------------------------------
'    Public Const CID_CAPITAL_ACC_STR = 10018
'    Public Const CID_CURRENT_ASSETS_STR = 10019
'    Public Const CID_FIXED_ASSETS_STR = 10020
'    Public Const CID_INVESTMENTS_STR = 10021
'    Public Const CID_LOAN_LIABILITY_STR = 10022
'    Public Const CID_PRE_OPERATIVE_EXPENSES_STR = 10023
'    Public Const CID_PROFIT_LOSS_STR = 10024
'    Public Const CID_REVENUE_ACC_STR = 10025
'    Public Const CID_SUSPENSE_ACC_STR = 10026
'    Public Const CID_CASH_IN_HAND_STR = 10027
'    Public Const CID_BANK_ACC_STR = 10028
'    Public Const CID_SECURITIES_DEPOSITS_ASSET_STR = 10029
'    Public Const CID_LOANS_ADVANCES_ASSET_STR = 10030
'    Public Const CID_STOCK_IN_HAND_STR = 10031
'    Public Const CID_SUNDRY_DEBTORS_STR = 10032
'    Public Const CID_SUNDRY_CREDITORS_STR = 10033
'    Public Const CID_DUTIES_TAXES_STR = 10034
'    Public Const CID_PROVISIONS_EXPENSES_PAYABLE_STR = 10035
'    Public Const CID_SECURED_LOANS_STR = 10036
'    Public Const CID_UNSECURED_LOANS_STR = 10037
'    Public Const CID_PURCHASE_STR = 10038
'    Public Const CID_SALE_STR = 10039
'    Public Const CID_EXPENSES_DIRECT_MFG_STR = 10040
'    Public Const CID_EXPENSES_INDIRECT_ADMN_STR = 10041
'    Public Const CID_INCOME_DIRECT_OPR_STR = 10042
'    Public Const CID_INCOME_INDIRECT_STR = 10043
'    Public Const CID_BANK_OD_ACC_STR = 10044
'    Public Const CID_RESERVES_SURPLUS_STR = 10045
'    Public Const CID_CASH_STR = 10046
'    Public Const CID_STOCK_STR = 10047
'    Public Const CID_SALES_STR = 10048
'    Public Const CID_MAIN_STORE_STR = 10050
'    Public Const CID_GENERAL_STR = 10051
'    Public Const CID_UNITS_STR = 10052
'    Public Const CID_NONE_STR = 10053
    '----------------------------------------------




'    Public Const CID_MAST_TYPE_ACCOUNT = 10001
'    Public Const CID_MAST_TYPE_ITEM = 10002
'    Public Const CID_MAST_TYPE_MC = 10003
'    Public Const CID_MAST_TYPE_AUTHOR = 10004
'    Public Const CID_MAST_TYPE_BOM = 10005
'    Public Const CID_MAST_TYPE_BROKER = 10006
'    Public Const CID_MAST_TYPE_BS = 10007
'    Public Const CID_MAST_TYPE_COST_CENTRE = 10008
'    Public Const CID_MAST_TYPE_CUR = 10009
'    Public Const CID_MAST_TYPE_FORM = 10010
'    Public Const CID_MAST_TYPE_CUR_CON = 10011
'    Public Const CID_MAST_TYPE_SN = 10012
'    Public Const CID_MAST_TYPE_TDS = 10013
'    Public Const CID_MAST_TYPE_UC = 10014
'    Public Const CID_MAST_TYPE_UNIT = 10015
'    Public Const CID_MAST_TYPE_TAX_CAT = 10016
'    Public Const CID_MAST_TYPE_SALE_TYPE = 10017
'    Public Const CID_MAST_TYPE_PURC_TYPE = 10018
'
'    Public Const CID_VCH_TYPE_SALE = 10019
'    Public Const CID_VCH_TYPE_PURC = 10020
'    Public Const CID_VCH_TYPE_SALES_RETURN = 10021
'    Public Const CID_VCH_TYPE_PURC_RETURN = 10022
'    Public Const CID_VCH_TYPE_PAYMENT = 10023
'    Public Const CID_VCH_TYPE_RECEIPT = 10024
'    Public Const CID_VCH_TYPE_JOURNAL = 10025
'    Public Const CID_VCH_TYPE_CONTRA = 10026
'    Public Const CID_VCH_TYPE_DR_NOTE = 10027
'    Public Const CID_VCH_TYPE_CR_NOTE = 10028
'    Public Const CID_VCH_TYPE_STOCK_TRANSFER = 10029
'    Public Const CID_VCH_TYPE_PRODUCTION = 10030
'    Public Const CID_VCH_TYPE_UNASSEMBLE = 10031
'    Public Const CID_VCH_TYPE_STOCK_JOURNAL = 10032
'    Public Const CID_VCH_TYPE_MAT_ISS = 10033
'    Public Const CID_VCH_TYPE_MAT_RECEIPT = 10034
'    Public Const CID_VCH_TYPE_SALES_ORDER = 10035
'    Public Const CID_VCH_TYPE_PURC_ORDER = 10036
'    Public Const CID_VCH_TYPE_FORMS_RECEIVED = 10037
'    Public Const CID_VCH_TYPE_FORMS_ISS = 10038
'    Public Const CID_VCH_TYPE_ADJUST_EXCISE_AMOUNTS = 10039
'    Public Const CID_VCH_TYPE_VAT_JOURNAL = 10040
'
'    Public Const CID_CMD_SAVE = 10041
'    Public Const CID_CMD_QUIT = 10042
'    Public Const CID_CMD_OK = 10043
'    Public Const CID_CMD_CONFIGURE = 10044
'    Public Const CID_CMD_CONFIGURATION = 10045
'

'
'
'
'
'    Public Const CID_ONE_STR = 10055
'    Public Const CID_GROUP_STR = 10056
'    Public Const CID_ALL_STR = 10057
'    Public Const CID_SELECTED_STR = 10058
'

'
'    Public Const CID_SED_STR = 10064
'    Public Const CID_AED_STR = 10065
'    Public Const CID_CUR_BAL_STR = 10066
'    Public Const CID_MRP_STR = 10067
'    Public Const CID_CUR_STOCK_STR = 10068
'    Public Const CID_CURR_STR = 10069
'    Public Const CID_CON_RATE_STR = 10070
'    Public Const CID_ALT_QTY_STR = 10071
'    Public Const CID_BOOK_NO_STR = 10072
'
'    Public Const CID_VAT_STR = 10073
'    Public Const CID_GST_STR = 10074

'#End Region


'------------------------------------------------------------------




