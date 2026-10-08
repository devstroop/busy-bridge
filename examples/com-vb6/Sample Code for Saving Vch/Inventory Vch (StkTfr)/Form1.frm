VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3720
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6495
   LinkTopic       =   "Form1"
   ScaleHeight     =   3720
   ScaleWidth      =   6495
   StartUpPosition =   3  'Windows Default
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
      Top             =   1680
      Width           =   2535
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save Voucher thru XML"
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
    Dim Price As Double
    Dim tmpVal As Double
    
    Screen.MousePointer = vbHourglass
    
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
    
    
    
    VchType = 5    'For STOCK TRANSFER vch., Vchtype=5
    
    'Use BUSY Predefined function to calculate Price of Specified Item and MC
    'Function Defination in BUSY -  GetItemMCPrice(ByVal p_ItemCode, ByVal p_MCCode, ByVal p_Date, ByVal p_SVM, ByVal p_SVP, ByVal p_MainQtyForLIFOFIFO) As Double
    Price = FI.GetItemMCPrice(FI.MasterName2Code("Item1", 6), FI.MasterName2Code("Main Store", 11), "01-04-2016", 7, 0, tmpVal)
    'SVM is 7 is integer const used for FIFO
    'SVP is special price that is not needed in FIFO and left 0
    'Change the XML string with this Price
    
    'Build XML String of STOCK TRANSFER Voucher to be saved in Busy
    XMLStr = "<StockTransfer><VchSeriesName>Main</VchSeriesName><Date>01-04-2016</Date><VchType>5</VchType><MasterName1>Main Store</MasterName1><MasterName2>MC-1</MasterName2>"
    XMLStr = XMLStr & "<ItemEntries><ItemDetail><SrNo>1</SrNo><ItemName>Item1</ItemName><UnitName>Pcs.</UnitName><AltUnitName>Kgs.</AltUnitName><ConFactor>17</ConFactor><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>17</QtyAltUnit><Price>" & Price & "</Price><Amt>100</Amt><MC>MC-1</MC></ItemDetail></ItemEntries>"
    XMLStr = XMLStr & "<ItemEntries1><ItemDetail><SrNo>1</SrNo><ItemName>Item1</ItemName><UnitName>Pcs.</UnitName><AltUnitName>Kgs.</AltUnitName><ConFactor>17</ConFactor><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>17</QtyAltUnit><Price>" & Price & "</Price><Amt>100</Amt><MC>Main Store</MC></ItemDetail></ItemEntries1>"
    XMLStr = XMLStr & "</StockTransfer>"
        
    
    
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
    VchDate = Format(CDate("10-04-2014"), "dd-mm-yyyy")  'Date shud be in 'dd-mm-yyyy' format only
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
