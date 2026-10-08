VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MShflxgd.ocx"
Begin VB.Form frmAccVch 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Payment Voucher"
   ClientHeight    =   6210
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   11055
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   6210
   ScaleWidth      =   11055
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdQuit 
      Caption         =   "Quit"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5280
      TabIndex        =   12
      Top             =   5160
      Width           =   1215
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3960
      TabIndex        =   11
      Top             =   5160
      Width           =   1215
   End
   Begin VB.TextBox txtShortNar 
      Height          =   315
      Left            =   7680
      TabIndex        =   10
      Top             =   2160
      Width           =   2535
   End
   Begin VB.ComboBox cmbAcc 
      Height          =   315
      ItemData        =   "frmAccVch.frx":0000
      Left            =   480
      List            =   "frmAccVch.frx":0013
      TabIndex        =   9
      Top             =   2160
      Width           =   4095
   End
   Begin VB.TextBox txtAmtType 
      Height          =   315
      Left            =   4680
      TabIndex        =   8
      Top             =   2160
      Width           =   975
   End
   Begin VB.TextBox txtAmt 
      Height          =   315
      Left            =   5760
      TabIndex        =   7
      Top             =   2160
      Width           =   1575
   End
   Begin VB.TextBox txtVchNo 
      Height          =   285
      Left            =   6360
      TabIndex        =   2
      Top             =   360
      Width           =   1455
   End
   Begin VB.TextBox txtDate 
      Height          =   285
      Left            =   3480
      TabIndex        =   1
      Top             =   360
      Width           =   1335
   End
   Begin VB.ComboBox cmbSeries 
      Height          =   315
      Left            =   960
      TabIndex        =   0
      Top             =   360
      Width           =   1215
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid grdAcc 
      Height          =   3375
      Left            =   240
      TabIndex        =   6
      Top             =   1080
      Width           =   10575
      _ExtentX        =   18653
      _ExtentY        =   5953
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
   Begin VB.Label lblVchNo 
      BackColor       =   &H8000000C&
      Caption         =   "Vch. No."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFC0&
      Height          =   255
      Left            =   5400
      TabIndex        =   5
      Top             =   360
      Width           =   975
   End
   Begin VB.Label lblDate 
      BackColor       =   &H8000000C&
      Caption         =   "Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFC0&
      Height          =   255
      Left            =   2880
      TabIndex        =   4
      Top             =   360
      Width           =   615
   End
   Begin VB.Label lblSeries 
      BackColor       =   &H8000000C&
      Caption         =   "Series"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFC0&
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   360
      Width           =   735
   End
End
Attribute VB_Name = "frmAccVch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_VchType As Integer

Private Function WriteXMLStr() As String
    Dim Doc As MSXML2.DOMDocument
    Dim Node As MSXML2.IXMLDOMNode
    Dim NodeChild As MSXML2.IXMLDOMNode
    Dim tmpNode As MSXML2.IXMLDOMNode
    Dim i As Integer
    
    Set Doc = New MSXML2.DOMDocument
    
    Set Node = Doc.createElement("Payment")
        
        Set tmpNode = MakeNodeValue(Doc, Node, "VchSeriesName", cmbSeries.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "Date", Format(txtDate.Text, "dd-mm-yyyy"), UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "VchType", m_VchType, UDF_INTEGER)
        Set tmpNode = MakeNodeValue(Doc, Node, "VchNo", txtVchNo.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "GSTRectype", 63, UDF_INTEGER)
        
        'GSTRectype=67 (for Gst nature "Advance payment to Unreg-Dealer")
        'GSTRectype=63 (for Gst nature "Registered Expense(B2B)")
        'GSTRectype=66 (for Gst nature "Tax Paid Expense(B2C)")
        'GSTRectype=65 (for Gst nature "ExemptExpense")
        'GSTRectype=70 (for Gst nature "Composition Expense")
        'GSTRectype=62 (for Gst nature "RCM/Unreg.Expense")
        'GSTRectype=1 (for Gst nature "GST Payment to Government")
        'GSTRectype=57 (for Gst nature "Refund against Advance Receipt")
                
        Set NodeChild = Node.appendChild(Doc.createElement("VchOtherInfoDetails"))
            Set tmpNode = MakeNodeValue(Doc, NodeChild, "Narration1", "Sample Narration", UDF_BOOLEAN)
        
        
        Set NodeChild = Node.appendChild(Doc.createElement("AccEntries"))
            For i = 1 To grdAcc.Rows - 1
                If Not BlankAccEntry(i) Then
                    
                    Set NodeChild = NodeChild.appendChild(Doc.createElement("AccDetail"))
                    
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "SrNo", i, UDF_INTEGER)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "AccountName", grdAcc.TextMatrix(i, 1), UDF_TEXT)
                        If grdAcc.TextMatrix(i, 2) = "D" Then
                            Set tmpNode = MakeNodeValue(Doc, NodeChild, "AmountType", DEBIT, UDF_INTEGER)
                        ElseIf grdAcc.TextMatrix(i, 2) = "C" Then
                            Set tmpNode = MakeNodeValue(Doc, NodeChild, "AmountType", CREDIT, UDF_INTEGER)
                        End If
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "AmtMainCur", grdAcc.TextMatrix(i, 3), UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "ShortNar", grdAcc.TextMatrix(i, 4), UDF_TEXT)
                        
                        
                    Set NodeChild = NodeChild.parentNode
                        
                End If
            Next
                        
                    
            Set NodeChild = Node.appendChild(Doc.createElement("VchGstSumAcc"))
                Set tmpNode = MakeNodeValue(Doc, NodeChild, "PartyName", "Busy Infotech Pvt. Ltd.", UDF_TEXT)
                
                Set NodeChild = NodeChild.appendChild(Doc.createElement("ItemGstDet"))
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "HSNCode", "HSN009", UDF_TEXT)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "ITCEligibility", 1, UDF_INTEGER)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "ItemName", "Office Maintenance Expenses", UDF_TEXT)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "ItemSrNo", 1, UDF_INTEGER)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "OrgVchDate", "01-04-2018", UDF_DATE)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "OrgVchNo", "001", UDF_TEXT)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxableAmt", 100, UDF_DOUBLE)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxAmt", 6, UDF_DOUBLE)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxAmt1", 6, UDF_DOUBLE)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxPercent", 6, UDF_DOUBLE)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxPercent1", 6, UDF_DOUBLE)
                    Set tmpNode = MakeNodeValue(Doc, NodeChild, "UnitName", "Pcs.", UDF_TEXT)
                                       
                                        
            Set NodeChild = NodeChild.parentNode
            Set NodeChild = NodeChild.parentNode
            
    WriteXMLStr = Doc.transformNode(Node)
    
End Function

Private Sub cmdSave_Click()
    Dim ErrMsg As String
    Dim XMLStr As String
    
    Screen.MousePointer = vbHourglass
    
    XMLStr = WriteXMLStr
    
    If g_FI.SaveVchFromXML(m_VchType, XMLStr, ErrMsg, False) Then
        MsgBox "Voucher saved  successfully"
    Else
        MsgBox "Voucher cannot be saved - (" & ErrMsg & ")."
    End If
    Screen.MousePointer = vbDefault

End Sub

'For MODIFICATION of Vouchers
Private Sub ModifyVch(p_VchCode As Long)
    Dim XMLStr As String
    Dim ErrMsg As String
    
    'Load voucher data in XML format from Unique Voucher Code
    XMLStr = g_FI.GetVchXML(p_VchCode)
    
    'Make changes in this XML string for modification
        
    'Save Modified XML
    If g_FI.ModifyVchFromXMLByCode(m_VchType, p_VchCode, XMLStr, ErrMsg) Then
        MsgBox "Voucher modified  successfully"
    Else
        MsgBox "Voucher cannot be modified - (" & ErrMsg & ")."
    End If

End Sub

Private Function BlankAccEntry(p_Row As Integer) As Boolean
    If grdAcc.TextMatrix(p_Row, 1) = "" And grdAcc.TextMatrix(p_Row, 2) = "" And grdAcc.TextMatrix(p_Row, 3) = "" And grdAcc.TextMatrix(p_Row, 4) = "" Then
        BlankAccEntry = True
    End If
End Function

'Private Function BlankBSEntry(p_Row As Integer) As Boolean
'    If grdBS.TextMatrix(p_Row, 1) = "" And grdBS.TextMatrix(p_Row, 2) = "" And grdBS.TextMatrix(p_Row, 3) = "" Then
'        BlankBSEntry = True
'    End If
'End Function

'Private Sub cmbBSName_Click()
'    grdBS.TextMatrix(grdBS.row, 1) = cmbBSName.Text
'    cmbBSName.Text = ""
'    cmbBSName.Visible = False
'End Sub

Private Sub cmbAcc_Click()
    grdAcc.TextMatrix(grdAcc.row, 1) = cmbAcc.Text
    cmbAcc.Text = ""
    cmbAcc.Visible = False
End Sub

'Private Sub cmbUnit_Click()
'    grdAcc.TextMatrix(grdAcc.row, 3) = cmbUnit.Text
'    cmbUnit.Text = ""
'    cmbUnit.Visible = False
'End Sub

Private Sub cmdQuit_Click()
    Unload Me
End Sub

Private Sub LoadDefaaultVals()
    cmbSeries.Text = "Main"
    txtDate.Text = "04-10-2018"
    txtVchNo.Text = "A"
    
    grdAcc.TextMatrix(1, 1) = "A1(expense)"
    grdAcc.TextMatrix(1, 2) = "D"
    grdAcc.TextMatrix(1, 3) = "1000"
    
    grdAcc.TextMatrix(2, 1) = "IGST input"
    grdAcc.TextMatrix(2, 2) = "D"
    grdAcc.TextMatrix(2, 3) = "120"
    
    grdAcc.TextMatrix(3, 1) = "Cash"
    grdAcc.TextMatrix(3, 2) = "C"
    grdAcc.TextMatrix(3, 3) = "1120"
    
End Sub

Private Sub Form_Load()
    Dim Col As New Collection
    Dim i As Integer
    
    Me.Caption = "Add Payment Vch."
    
    m_VchType = PAYMENT
    
    Set Col = GetMastList(ACC_MAST)
    cmbAcc.Clear
    For i = 1 To Col.Count
        cmbAcc.AddItem Col(i)
    Next
    
'    Set Col = GetMastList(UNIT_MAST)
'    cmbUnit.Clear
'    For i = 1 To Col.Count
'        cmbUnit.AddItem Col(i)
'    Next
    
    Set Col = LoadVchSeries(m_VchType)
    cmbSeries.Clear
    For i = 1 To Col.Count
        cmbSeries.AddItem Col(i)
    Next
    
'    Set Col = GetMastList(ST_MAST)
'    cmbSaleType.Clear
'    For i = 1 To Col.Count
'        cmbSaleType.AddItem Col(i)
'    Next
        
'    Set Col = GetAccList()
'    cmbParty.Clear
'    For i = 1 To Col.Count
'        cmbParty.AddItem Col(i)
'    Next
    
'    Set Col = GetMastList(MC_MAST)
'    cmbMC.Clear
'    For i = 1 To Col.Count
'        cmbMC.AddItem Col(i)
'    Next
    
'    Set Col = GetMastList(BS_MAST)
'    cmbBSName.Clear
'    For i = 1 To Col.Count
'        cmbBSName.AddItem Col(i)
'    Next
    
    SetgrdAcc
    
    LoadDefaaultVals
End Sub

Private Sub SetgrdAcc()
    Dim i As Integer
        
    grdAcc.Rows = 10
    grdAcc.Cols = 5
    
    grdAcc.FixedRows = 1
    grdAcc.FixedCols = 1
    
    For i = 0 To grdAcc.Rows - 1
        grdAcc.RowHeight(i) = 315
    Next
    
    cmbAcc.Visible = False
    txtAmtType.Visible = False
    txtAmt.Visible = False
    txtShortNar.Visible = False
        
    grdAcc.TextMatrix(0, 0) = "S.No."
    grdAcc.TextMatrix(0, 1) = "Account"
    grdAcc.TextMatrix(0, 2) = "D/C"
    grdAcc.TextMatrix(0, 3) = "Amount"
    grdAcc.TextMatrix(0, 4) = "Short Narration"
        
    grdAcc.ColWidth(0) = 600
    grdAcc.ColWidth(1) = cmbAcc.Width
    grdAcc.ColWidth(2) = txtAmtType.Width
    grdAcc.ColWidth(3) = txtAmt.Width
    grdAcc.ColWidth(4) = txtShortNar.Width
    
    For i = 1 To grdAcc.Rows - 1
        grdAcc.TextMatrix(i, 0) = CStr(i)
    Next
    
End Sub

Private Sub grdAcc_DblClick()
    Dim i As Integer
    Dim LeftPos As Long
    
    LeftPos = grdAcc.Left
    For i = 0 To grdAcc.Col - 1
        LeftPos = LeftPos + grdAcc.ColWidth(i)
    Next
    
    Select Case grdAcc.Col
    
        Case 1
            
            cmbAcc.Visible = True
            cmbAcc.Top = grdAcc.Top + grdAcc.CellTop
            cmbAcc.Left = LeftPos
            cmbAcc.Text = grdAcc.TextMatrix(grdAcc.row, 1)
            cmbAcc.SetFocus
            
        Case 2
            txtAmtType.Visible = True
            txtAmtType.Top = grdAcc.Top + grdAcc.CellTop
            txtAmtType.Left = LeftPos
            txtAmtType.Text = grdAcc.TextMatrix(grdAcc.row, 2)
            txtAmtType.SetFocus
                    
        Case 3
            txtAmt.Visible = True
            txtAmt.Top = grdAcc.Top + grdAcc.CellTop
            txtAmt.Left = LeftPos
            txtAmt.Text = grdAcc.TextMatrix(grdAcc.row, 3)
            txtAmt.SetFocus
            
        Case 4
            txtShortNar.Visible = True
            txtShortNar.Top = grdAcc.Top + grdAcc.CellTop
            txtShortNar.Left = LeftPos
            txtShortNar.Text = grdAcc.TextMatrix(grdAcc.row, 4)
            txtShortNar.SetFocus
                        
    End Select
    
End Sub

Private Sub txtDate_KeyDown(KeyCode As Integer, Shift As Integer)
'    Dim udtVchNum As udtVchNumbering
'    Dim VchNo As String
'
'    If KeyCode = vbKeyReturn Then
'        udtVchNum = g_OS.GetVchNumInfoData(g_MS.MasterName2CodeIfExist(g_OS.Series2MasterName(SALE, cmbSeries.Text), SERIES_MAST))
'        If udtVchNum.NumberingType = VCHNUMBERING_AUTO Then
'            If udtVchNum.ReNumFrequency = RENUMBER_YEARLY Then
'                m_udtVchData.AutoVchNo = g_TS.GenerateAutoVchNumber(udtVchNum, VchNo)
'            Else
'                m_udtVchData.AutoVchNo = g_TS.GenerateAutoVchNumber(udtVchNum, VchNo, Text2Date(txtDate.Text))
'            End If
'            txtVchNo.Text = VchNo
'            txtVchNo.SetFocus
'        End If
'    End If
End Sub

Private Sub txtShortNar_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtShortNar.Text <> "" Then
            grdAcc.TextMatrix(grdAcc.row, 4) = txtShortNar.Text
            txtShortNar.Text = ""
        End If
        txtShortNar.Visible = False
    End If
End Sub

Private Sub txtAmtType_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtAmtType.Text <> "" Then
            grdAcc.TextMatrix(grdAcc.row, 2) = txtAmtType.Text
            txtAmtType.Text = ""
        End If
        txtAmtType.Visible = False
    End If
End Sub

Private Sub txtAmt_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtAmt.Text <> "" Then
            grdAcc.TextMatrix(grdAcc.row, 3) = txtAmt.Text
            txtAmt.Text = ""
        End If
        txtAmt.Visible = False
    End If
End Sub

