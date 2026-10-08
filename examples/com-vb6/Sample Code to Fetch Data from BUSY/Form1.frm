VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MShflxgd.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   8865
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   13440
   LinkTopic       =   "Form1"
   ScaleHeight     =   8865
   ScaleWidth      =   13440
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdVchList 
      Caption         =   "List of Vouchers with GST Tax Rate"
      Height          =   495
      Left            =   4800
      TabIndex        =   2
      Top             =   360
      Width           =   2775
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid fg1 
      Height          =   7335
      Left            =   240
      TabIndex        =   1
      Top             =   1200
      Width           =   12855
      _ExtentX        =   22675
      _ExtentY        =   12938
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
   Begin VB.CommandButton cmdMastList 
      Caption         =   "List of Item Masters"
      Height          =   495
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   2295
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdVchList_Click()
    Dim FI As Object
    Dim Qry As String
    Dim rst As Recordset
    Dim RowNo As Long
    Dim Q1 As String
    Dim Q2 As String
    Dim Q3 As String
    Dim Q4 As String
    Dim OldVchCode As Long
    
    Screen.MousePointer = vbHourglass
    
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
        
'    'Opens the BUSY database - SQL server
'    FI.OpenCSDB "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0002"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0002" - Busy Company Code
    
    'OR
    
    'For Access Mode - To Open BUSY Database
    FI.OpenDB "C:\Busywin\", "D:\Busy Data\", "Comp0016"
    'OpenDB function has following parameters
    '"C:\Busywin\" - BusyPath where Busy is installed
    '"D:\Busy Data\" - Data Path
    '"Comp0001" - Busy Company Code
    
    MsgBox "Database Connected"
    
    SetGrdVchList
        
    RowNo = 1
    
    
    'Fetch Values from Database through Queries
       
    Q1 = ",(Select M1.Name from Master1 as M1 where M1.code=PartyCode) as PartyName"
    Q2 = ",(Select M1.Name from Master1 as M1 where M1.code=StPtCode) as STPTName"
    Q3 = ",(Select M1.Name from Master1 as M1 where M1.code=TaxCatCode) as TaxCategory"
    Q4 = ",(Select M1.Name from Master1 as M1 where M1.code=ItemCode) as ItemName"
    
    Qry = "Select * " & Q1 & Q2 & Q3 & Q4 & " from VchGSTSumItemWise"
    
    Set rst = FI.GetRecordset(Qry)
    
    If rst.RecordCount > 0 Then
        rst.MoveLast
        rst.MoveFirst
        Do While Not rst.EOF
            'MsgBox Trim$(rst!Name.Value)
                        
            fg1.AddItem ""
            
            fg1.TextMatrix(RowNo, 0) = RowNo
            
            If OldVchCode <> rst!vchCode Then
                
                fg1.TextMatrix(RowNo, 1) = FI.formatdate(rst!Date)
                fg1.TextMatrix(RowNo, 2) = rst!VchNo
                fg1.TextMatrix(RowNo, 3) = rst!PartyName
                fg1.TextMatrix(RowNo, 4) = rst!STPTName
                fg1.TextMatrix(RowNo, 5) = rst!TaxCategory
                
                OldVchCode = rst!vchCode
            Else
                
                fg1.TextMatrix(RowNo, 1) = ""
                fg1.TextMatrix(RowNo, 2) = ""
                fg1.TextMatrix(RowNo, 3) = ""
                fg1.TextMatrix(RowNo, 4) = ""
                fg1.TextMatrix(RowNo, 5) = ""
            End If
            
            fg1.TextMatrix(RowNo, 6) = rst!ItemName
            
            If rst!LocType = 0 Then     'Local
                fg1.TextMatrix(RowNo, 7) = rst!TaxRate
                fg1.TextMatrix(RowNo, 8) = rst!TaxRate1
                fg1.TextMatrix(RowNo, 9) = rst!TaxAmt
                fg1.TextMatrix(RowNo, 10) = rst!TaxAmt1
                fg1.TextMatrix(RowNo, 11) = ""
                fg1.TextMatrix(RowNo, 12) = ""
            Else
                fg1.TextMatrix(RowNo, 7) = ""
                fg1.TextMatrix(RowNo, 8) = ""
                fg1.TextMatrix(RowNo, 9) = ""
                fg1.TextMatrix(RowNo, 10) = ""
                fg1.TextMatrix(RowNo, 11) = rst!TaxRate
                fg1.TextMatrix(RowNo, 12) = rst!TaxAmt
            End If
            
            RowNo = RowNo + 1
            
            rst.MoveNext
        Loop
    End If
    
    
    'Close Busy Company which is opened thru OpenCSDB/OpenDB function
    FI.CloseDB
    
    Screen.MousePointer = vbDefault
    
    Set FI = Nothing
        
End Sub

Private Function SetGrdVchList()
    fg1.Enabled = True
    
    fg1.FixedRows = 1
    fg1.FixedCols = 1
    
    fg1.Rows = 2
    fg1.Cols = 13
    
    fg1.TextArray(0) = "S.No."
    fg1.TextArray(1) = "Vch. Date"
    fg1.TextArray(2) = "Vch. No."
    fg1.TextArray(3) = "Party"
    fg1.TextArray(4) = "Sale Type"
    fg1.TextArray(5) = "Tax Category"
    fg1.TextArray(6) = "Item Name"
    fg1.TextArray(7) = "CGST Rate"
    fg1.TextArray(8) = "SGST Rate"
    fg1.TextArray(9) = "CGST Amt"
    fg1.TextArray(10) = "SGST Amt"
    fg1.TextArray(11) = "IGST Rate"
    fg1.TextArray(12) = "IGST Amt"
        
    
End Function

Private Sub cmdMastList_Click()
    Dim FI As Object
    Dim Qry As String
    Dim rst As Recordset
    Dim RowNo As Long
    Dim UnitQry As String
    Dim PGQry As String
    
    Screen.MousePointer = vbHourglass
    
    Set FI = CreateObject("Busy2L17.CFixedInterface")
    
        
'    'Opens the BUSY database - SQL server
'    FI.OpenCSDB "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0002"
'    'OpenCSDB function has following parameters
'    '"C:\Busywin\" - BusyPath where Busy is installed
'    '"Rachna" - SQL Server Name
'    '"sa" - SQL Server UserName
'    '"busy" - SQL Server Password
'    '"BusyComp0002" - Busy Company Code
    
    'OR
    
    'For Access Mode - To Open BUSY Database
    FI.OpenDB "C:\Busywin\", "D:\Busy Data\", "Comp0001"
    'OpenDB function has following parameters
    '"C:\Busywin\" - BusyPath where Busy is installed
    '"D:\Busy Data\" - Data Path
    '"Comp0001" - Busy Company Code
    
    MsgBox "Database Connected"
    
    SetGrdMastList
        
    RowNo = 1
    
    
    'Fetch Values from Database through Queries
    
    PGQry = ",(Select M1.Name from Master1 as M1 where M1.code=Master1.ParentGrp) as ParentGrpName"
    UnitQry = ",(Select M1.Name from Master1 as M1 where M1.code=Master1.CM1) as UnitName"
    
    Qry = "Select Name,Code,Alias" & PGQry & UnitQry & " from Master1 where Master1.MasterType=6 order by name"
    'This query will return list of all the Item Masters as MasterType=6 belongs to Item Master in Master1 table.
    
    Set rst = FI.GetRecordset(Qry)
    
    If rst.RecordCount > 0 Then
        rst.MoveLast
        rst.MoveFirst
        Do While Not rst.EOF
            'MsgBox Trim$(rst!Name.Value)
                        
            fg1.AddItem ""
            
            fg1.TextMatrix(RowNo, 0) = RowNo
            fg1.TextMatrix(RowNo, 1) = rst!Name
            fg1.TextMatrix(RowNo, 2) = rst!Alias
            fg1.TextMatrix(RowNo, 3) = rst!UnitName
            fg1.TextMatrix(RowNo, 4) = rst!ParentGrpName
                        
            RowNo = RowNo + 1
            
            rst.MoveNext
        Loop
    End If
    
    
    'Close Busy Company which is opened thru OpenCSDB/OpenDB function
    FI.CloseDB
    
    Screen.MousePointer = vbDefault
    
    Set FI = Nothing
        
End Sub

Private Function SetGrdMastList()
    fg1.Enabled = True
    
    fg1.FixedRows = 1
    fg1.FixedCols = 1
    
    fg1.Rows = 2
    fg1.Cols = 5
    
    fg1.TextArray(0) = "S.No."
    fg1.TextArray(1) = "Item Name"
    fg1.TextArray(2) = "Item Alias"
    fg1.TextArray(3) = "Main Unit"
    fg1.TextArray(4) = "Parent Group"
    
End Function

Private Sub Form_Load()
    fg1.Enabled = False
End Sub
