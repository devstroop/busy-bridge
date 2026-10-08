VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4620
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6495
   LinkTopic       =   "Form1"
   ScaleHeight     =   4620
   ScaleWidth      =   6495
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdPurc 
      Caption         =   "Save Purchase Voucher thru XML"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   1920
      TabIndex        =   3
      Top             =   1440
      Width           =   2535
   End
   Begin VB.CommandButton cmdPO 
      Caption         =   "Save PO Voucher thru XML"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1920
      TabIndex        =   2
      Top             =   2280
      Width           =   2535
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "Delete Voucher"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1920
      TabIndex        =   1
      Top             =   3000
      Width           =   2535
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save Sales Voucher thru XML"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1920
      TabIndex        =   0
      Top             =   840
      Width           =   2535
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdSave_Click()
    Dim FI As Object
    Dim XMLStr As String
    Dim VchSeries As String
    Dim VchDate As String
    Dim VchType As Integer
    Dim VchNo As String
    Dim Narration As String
    Dim Amt As Double
    Dim Amt1 As Double
    Dim ErrMsg As String
    Dim AutoVchNo As Long
    
    Screen.MousePointer = vbHourglass
    
    'If BUSY 16 is installed, then plz use the below code
'    Set FI = CreateObject("Busy2L16.CFixedInterface")
    
    
    'If BUSY 17 is installed, then plz. use below line
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
    
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
    
    
    'Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0006"
    'OpenDB function has following parameters
    '"C:\Busywin\" - BusyPath where Busy is installed
    '"D:\Busy Data" - DataPath where Busy Data is stored
    '"BusyComp0006" - Busy Company Code
    
    
    
    VchType = 9    'For SALE vch. Vchtype=9
        
        
    XMLStr = XMLStr & "<Sale>"
    XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2016</Date><VchType>9</VchType><VchNo>1</VchNo><STPTName>VAT/MultiTax(R)</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
    XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"
    
    XMLStr = XMLStr & "<ItemEntries>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>10</Qty><Price>105</Price><Amt>1060.5</Amt><STAmount>10.5</STAmount><STPercent>1</STPercent><TaxBeforeSurcharge>10.5</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>10</Qty><Price>100</Price><Amt>1010</Amt><STAmount>10</STAmount><STPercent>1</STPercent><TaxBeforeSurcharge>10</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Pcs.</UnitName><Qty>3</Qty><Price>100</Price><Amt>315</Amt><STAmount>15</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>15</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "</ItemEntries>"
    
    XMLStr = XMLStr & "<BillSundries>"
    XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>238.55</Amt></BSDetail>"
    XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>100</Amt></BSDetail>"
    XMLStr = XMLStr & "</BillSundries>"
    XMLStr = XMLStr & "</Sale>"
    
    
    
    'Save XML string in Busy
    'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
        Screen.MousePointer = vbDefault
        MsgBox "Saved."
    Else
        Screen.MousePointer = vbDefault
        MsgBox ErrMsg
    End If
    
    'Close Busy Company which is opened thru OpenCSDB function
    FI.CloseDB
    
    Set FI = Nothing
    
End Sub

Private Sub cmdDelete_Click()
    Dim FI As Object
    Dim VchSeries As String
    Dim VchDate As String
    Dim VchType As Integer
    Dim VchNo As String
    Dim ErrMsg As String
    
    Screen.MousePointer = vbHourglass
    
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
    'Opens the Busy database - SQL server
    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0003"
    'OpenCSDB function has following parameters
    '"C:\Busywin\" - BusyPath where Busy is installed
    '"Rachna" - SQL Server Name
    '"sa" - SQL Server UserName
    '"busy" - SQL Server Password
    '"BusyComp0003" - Busy Company Code
    
    
    
    VchSeries = "Main"
    VchDate = Format(CDate("10-04-2016"), "dd-mm-yyyy")  'Date shud be in 'dd-mm-yyyy' format only
    VchType = 9    'For SALE vch. Vchtype=9
    VchNo = "1"
    
    'Delete Voucher in Busy
    'Function Defination in Busy - DeleteVch(ByVal p_VchType As Variant, ByVal p_VchSeriesName As Variant, ByVal p_VchDate As Variant, ByVal p_VchNo As Variant, ByRef p_ErrStr As Variant) As Boolean
    If FI.DeleteVch(VchType, VchSeries, VchDate, VchNo, ErrMsg) Then
        Screen.MousePointer = vbDefault
        MsgBox "Deleted."
    Else
        Screen.MousePointer = vbDefault
        MsgBox ErrMsg
    End If
    
    'Close Busy Company which is opened thru OpenCSDB function
    FI.CloseDB
    
    Set FI = Nothing
    
End Sub

Private Sub cmdPurc_Click()
    Dim FI As Object
    Dim XMLStr As String
    Dim VchSeries As String
    Dim VchDate As String
    Dim VchType As Integer
    Dim VchNo As String
    Dim Narration As String
    Dim Amt As Double
    Dim Amt1 As Double
    Dim ErrMsg As String
    Dim AutoVchNo As Long
    
    Screen.MousePointer = vbHourglass
    
'    'If BUSY 16 is installed, then plz use the below code
'    Set FI = CreateObject("Busy2L16.CFixedInterface")
    
    
'    'If BUSY 17 is installed, then plz. uncomment below line
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
    
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
    
    
    'Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
    'OpenDB function has following parameters
    '"C:\Busywin\" - BusyPath where Busy is installed
    '"D:\Busy Data" - DataPath where Busy Data is stored
    '"BusyComp0006" - Busy Company Code
    
    
    
    VchType = 2    'For PURCHASE vch. Vchtype=2
    
        
    XMLStr = "<Purchase>"
    XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2016</Date><VchType>2</VchType><VchNo>1</VchNo><STPTName>VAT/Exempt</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
    XMLStr = XMLStr & "<VchOtherInfoDetails><PurchaseBillNo>Supp Purc Ref No.</PurchaseBillNo><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"
    
    XMLStr = XMLStr & "<ItemEntries>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>100</Qty><Price>90</Price><Amt>9000</Amt><STAmount>90</STAmount><STPercent>1</STPercent><TaxBeforeSurcharge>90</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>100</Qty><Price>90</Price><Amt>9000</Amt><STAmount>90</STAmount><STPercent>1</STPercent><TaxBeforeSurcharge>90</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Pcs.</UnitName><Qty>5</Qty><Price>101</Price><Amt>530.25</Amt><STAmount>25.25</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>25.25</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "</ItemEntries>"
    
    XMLStr = XMLStr & "<BillSundries>"
    XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>1800</Amt></BSDetail>"
    XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>100</Amt></BSDetail>"
    XMLStr = XMLStr & "</BillSundries>"
    
    XMLStr = XMLStr & "</Purchase>"
    
    
    
    'Save XML string in Busy
    'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
        Screen.MousePointer = vbDefault
        MsgBox "Saved."
    Else
        Screen.MousePointer = vbDefault
        MsgBox ErrMsg
    End If
    
    'Close Busy Company which is opened thru OpenCSDB function
    FI.CloseDB
    
    Set FI = Nothing
    
End Sub

Private Sub cmdPO_Click()
    Dim FI As Object
    Dim XMLStr As String
    Dim VchSeries As String
    Dim VchDate As String
    Dim VchType As Integer
    Dim VchNo As String
    Dim Narration As String
    Dim Amt As Double
    Dim Amt1 As Double
    Dim ErrMsg As String
    Dim AutoVchNo As Long
    
    Screen.MousePointer = vbHourglass
    
'    'If BUSY 16 is installed, then plz use the below code
'    Set FI = CreateObject("Busy2L16.CFixedInterface")
    
    
'    'If BUSY 17 is installed, then plz. uncomment below line
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
    
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
    
    
    'Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0006"
    'OpenDB function has following parameters
    '"C:\Busywin\" - BusyPath where Busy is installed
    '"D:\Busy Data" - DataPath where Busy Data is stored
    '"BusyComp0006" - Busy Company Code
    
    
    
    VchType = 13    'For PURCHASE ORDER vch. Vchtype=13
        
        
    XMLStr = "<PurchaseOrder>"
    XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2016</Date><VchType>13</VchType><VchNo>1</VchNo><STPTName>VAT/MultiTax(T)</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
    
    XMLStr = XMLStr & "<ItemEntries>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Pcs.</UnitName><Qty>10</Qty><QtyMainUnit>10</QtyMainUnit><QtyAltUnit>10</QtyAltUnit><Price>100</Price><Amt>1010</Amt><STAmount>10</STAmount><STPercent>1</STPercent><TaxBeforeSurcharge>10</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Pcs.</UnitName><Qty>20</Qty><QtyMainUnit>20</QtyMainUnit><QtyAltUnit>20</QtyAltUnit><Price>200</Price><Amt>4200</Amt><STAmount>200</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>200</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
    XMLStr = XMLStr & "</ItemEntries>"
    
    XMLStr = XMLStr & "<BillSundries>"
    XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>5</PercentVal><Amt>260.5</Amt></BSDetail>"
    XMLStr = XMLStr & "</BillSundries>"
    
    XMLStr = XMLStr & "<PendingOrders>"
    XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 1</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
    XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>1</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-10</Value1><Value2>-10</Value2><ItemSrNo>1</ItemSrNo><tmpMasterCode1>1228</tmpMasterCode1><tmpMasterCode2>1004</tmpMasterCode2></OrderRefs>"
    XMLStr = XMLStr & "</OrderDetail>"
    
    XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 2</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
    XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>1</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-20</Value1><Value2>-20</Value2><ItemSrNo>2</ItemSrNo><tmpMasterCode1>1229</tmpMasterCode1><tmpMasterCode2>1004</tmpMasterCode2></OrderRefs>"
    XMLStr = XMLStr & "</OrderDetail>"
    XMLStr = XMLStr & "</PendingOrders>"
    
    XMLStr = XMLStr & "</PurchaseOrder>"
    
           
    
    'Save XML string in Busy
    'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
        Screen.MousePointer = vbDefault
        MsgBox "Saved."
    Else
        Screen.MousePointer = vbDefault
        MsgBox ErrMsg
    End If
    
    'Close Busy Company which is opened thru OpenCSDB function
    FI.CloseDB
    
    Set FI = Nothing
    
End Sub


