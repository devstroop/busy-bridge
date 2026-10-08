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
    
    Screen.MousePointer = vbHourglass
    
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0012"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
    
    'Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0006"
'    OpenDB function has following parameters
'    "C:\Busywin\" - BusyPath where Busy is installed
'    "D:\Busy Data" - DataPath where Busy Data is stored
'    "BusyComp0006" - Busy Company Code
    
    
   
    'Build XML String of Journal Voucher to be saved in Busy
    
    XMLStr = "<Journal><VchSeriesName>Main</VchSeriesName><Date>01-04-2016</Date><VchType>16</VchType>"
    XMLStr = XMLStr & "<AccEntries>"
    XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>2</AmountType><AmtMainCur>5000</AmtMainCur></AccDetail>"
    XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>Travelling Expenses</AccountName><AmountType>1</AmountType><AmtMainCur>2000</AmtMainCur></AccDetail>"
    XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>Advertisement &amp; Publicity</AccountName><AmountType>1</AmountType><AmtMainCur>2000</AmtMainCur></AccDetail>"
    XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>Books &amp; Periodicals</AccountName><AmountType>1</AmountType><AmtMainCur>1000</AmtMainCur></AccDetail>"
    XMLStr = XMLStr & "</AccEntries>"
    XMLStr = XMLStr & "</Journal>"
    
    
    'Save XML string in Busy
    'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    If FI.SaveVchFromXML(16, XMLStr, ErrMsg) Then
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
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0012"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
    
    'Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
'    OpenDB function has following parameters
'    "C:\Busywin\" - BusyPath where Busy is installed
'    "D:\Busy Data" - DataPath where Busy Data is stored
'    "BusyComp0006" - Busy Company Code
    
    
    VchSeries = "Main"
    VchDate = Format(CDate("4-10-2016"), "dd-mm-yyyy")  'Date shud be in 'dd-mm-yyyy' format only
    VchType = 16    'For Journal vch. Vchtype=16
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
