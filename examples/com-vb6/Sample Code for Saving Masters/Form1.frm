VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5415
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7320
   LinkTopic       =   "Form1"
   ScaleHeight     =   5415
   ScaleWidth      =   7320
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdBillSundry 
      Caption         =   "Save Bill Sundry Master thru XML"
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
      Left            =   2400
      TabIndex        =   3
      Top             =   3240
      Width           =   2535
   End
   Begin VB.CommandButton cmdSaveUnit 
      Caption         =   "Save Unit Master thru XML"
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
      Left            =   2400
      TabIndex        =   2
      Top             =   2520
      Width           =   2535
   End
   Begin VB.CommandButton cmdSaveItem 
      Caption         =   "Save Item Master thru XML"
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
      Left            =   2400
      TabIndex        =   1
      Top             =   1680
      Width           =   2535
   End
   Begin VB.CommandButton cmdSaveAcc 
      Caption         =   "Save Acc Master thru XML"
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
      Left            =   2400
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

Private Sub cmdSaveAcc_Click()
    Dim FI As Object
    Dim XMLStr As String
    Dim ErrMsg As String
    
    Screen.MousePointer = vbHourglass
    
    'If BUSY17 is installed then use below line of code
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
    'If BUSY16 is installed then plz uncomment below line
    'Set FI = CreateObject("Busy2L16.CFixedInterface")
    
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0004"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
'    Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
'    OpenDB function has following parameters
'    "C:\Busywin\" - BusyPath where Busy is installed
'    "D:\Busy Data" - DataPath where Busy Data is stored
'    "BusyComp0006" - Busy Company Code
    
    
    XMLStr = "<Account><Name>Acc1</Name><ParentGroup>Sundry Creditors</ParentGroup></Account>"
    
    'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    'MasterType for Account Master is 2
    If FI.SaveMasterFromXML(2, XMLStr, ErrMsg) Then
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

Private Sub cmdSaveItem_Click()
    Dim FI As Object
    Dim XMLStr As String
    Dim ErrMsg As String
    
    Screen.MousePointer = vbHourglass
    
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
    'Opens the Busy database - SQL server
    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0012"
    'OpenCSDB function has following parameters
    '"C:\Busywin\" - BusyPath where Busy is installed
    '"Rachna" - SQL Server Name
    '"sa" - SQL Server UserName
    '"busy" - SQL Server Password
    '"BusyComp0003" - Busy Company Code
    
''    Opens the BUSY Database - MS_Access
'    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0006"
''    OpenDB function has following parameters
''    "C:\Busywin\" - BusyPath where Busy is installed
''    "D:\Busy Data" - DataPath where Busy Data is stored
''    "BusyComp0006" - Busy Company Code
    
    
    'Plain Item master
    XMLStr = "<Item><Name>Item1</Name><ParentGroup>General</ParentGroup><MainUnit>Pcs.</MainUnit></Item>"
    
        
    'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    'MasterType for Item Master is 6
    If FI.SaveMasterFromXML(6, XMLStr, ErrMsg) Then
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

Private Sub cmdSaveUnit_Click()
    Dim FI As Object
    Dim XMLStr As String
    Dim ErrMsg As String
    
    Screen.MousePointer = vbHourglass
    
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0004"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
    
'    Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
'    OpenDB function has following parameters
'    "C:\Busywin\" - BusyPath where Busy is installed
'    "D:\Busy Data" - DataPath where Busy Data is stored
'    "BusyComp0006" - Busy Company Code
    
    
    XMLStr = "<Unit><Name>ABC</Name></Unit>"
    
    'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    'MasterType for Unit Master is 8
    If FI.SaveMasterFromXML(8, XMLStr, ErrMsg) Then
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

Private Sub cmdBillSundry_Click()
    Dim FI As Object
    Dim XMLStr As String
    Dim ErrMsg As String
    
    Screen.MousePointer = vbHourglass
    
    'If BUSY17 is installed then use below line of code
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
    'If BUSY16 is installed then plz uncomment below line
    'Set FI = CreateObject("Busy2L16.CFixedInterface")
    
    
'    'Opens the Busy database - SQL server
'    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0004"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0003" - Busy Company Code
    
'    Opens the BUSY Database - MS_Access
    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
'    OpenDB function has following parameters
'    "C:\Busywin\" - BusyPath where Busy is installed
'    "D:\Busy Data" - DataPath where Busy Data is stored
'    "BusyComp0006" - Busy Company Code
    
    
    XMLStr = "<BillSundry><Name>Discount1</Name><PrintName>Discount</PrintName><SubTotalDesc>Total</SubTotalDesc><BSNature>Discount</BSNature>"
    XMLStr = XMLStr & "<AffectAccountingInSale>True</AffectAccountingInSale><AffectAccountingInPurc>True</AffectAccountingInPurc><AffactSale>True</AffactSale><AffactPurc>True</AffactPurc><AdjustInSaleAmt>True</AdjustInSaleAmt><AdjustInPurcAmt>True</AdjustInPurcAmt><AdjustSaleInPartyAmt>True</AdjustSaleInPartyAmt><AdjustPurcInPartyAmt>True</AdjustPurcInPartyAmt>"
    XMLStr = XMLStr & "<AmountBasis>1</AmountBasis><PointOfCalculation>2</PointOfCalculation><PercentOfAmount>100</PercentOfAmount><NoOfPBS>1</NoOfPBS>"
    XMLStr = XMLStr & "<Type>0</Type></BillSundry>"
        
    'Type = 0 ; For Subtractive
    'Type = 1 ; For Additive
    
    'Amount Basis ABSOLUTE = 0
    'Amount Basis PERCENTAGE = 1
    'Amount Basis MAINQTY = 2
    'Amount Basis BS_ALTQTY = 3
    
    'POINT OF CALCULATION BASIC_AMT = 0
    'POINT OF CALCULATION MRP_AMT = 1
    'POINT OF CALCULATION NETT_AMT = 2
    'POINT OF CALCULATION PREVBS_AMT = 4
    'POINT OF CALCULATION TOTAL_AMT = 5
    'POINT OF CALCULATION TAXABLE_AMT = 6
    'POINT OF CALCULATION LIST_PRICE = 7
    'POINT OF CALCULATION OTHER_BSMAST_AMT = 8
    'POINT OF CALCULATION OTHER_BSMAST_APPLIED_ON = 9
    
    
    'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
    'MasterType for Bill Sundry Master is 9
    If FI.SaveMasterFromXML(9, XMLStr, ErrMsg) Then
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


