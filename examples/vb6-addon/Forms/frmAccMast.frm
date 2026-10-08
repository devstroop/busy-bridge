VERSION 5.00
Begin VB.Form frmAccMast 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Account Master"
   ClientHeight    =   5490
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   6705
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   5490
   ScaleWidth      =   6705
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
      Left            =   3360
      TabIndex        =   14
      Top             =   4560
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
      Left            =   2040
      TabIndex        =   13
      Top             =   4560
      Width           =   1215
   End
   Begin VB.TextBox txtAdd4 
      Height          =   285
      Left            =   1320
      TabIndex        =   12
      Top             =   3600
      Width           =   4695
   End
   Begin VB.TextBox txtAdd3 
      Height          =   285
      Left            =   1320
      TabIndex        =   11
      Top             =   3240
      Width           =   4695
   End
   Begin VB.TextBox txtAdd2 
      Height          =   285
      Left            =   1320
      TabIndex        =   10
      Top             =   2880
      Width           =   4695
   End
   Begin VB.TextBox txtAdd1 
      Height          =   285
      Left            =   1320
      TabIndex        =   8
      Top             =   2520
      Width           =   4695
   End
   Begin VB.ComboBox cmbGroup 
      Height          =   315
      Left            =   1320
      TabIndex        =   6
      Top             =   2040
      Width           =   4215
   End
   Begin VB.TextBox txtPrintName 
      Height          =   285
      Left            =   1320
      TabIndex        =   4
      Top             =   1560
      Width           =   4215
   End
   Begin VB.TextBox txtAlias 
      Height          =   285
      Left            =   1320
      TabIndex        =   2
      Top             =   1080
      Width           =   4215
   End
   Begin VB.TextBox txtName 
      Height          =   285
      Left            =   1320
      TabIndex        =   0
      Top             =   600
      Width           =   4215
   End
   Begin VB.Label lblAdd 
      BackColor       =   &H8000000C&
      Caption         =   "Address"
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
      TabIndex        =   9
      Top             =   2520
      Width           =   855
   End
   Begin VB.Label lblGroup 
      BackColor       =   &H8000000C&
      Caption         =   "Group"
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
      TabIndex        =   7
      Top             =   2040
      Width           =   1095
   End
   Begin VB.Label lblPrintName 
      BackColor       =   &H8000000C&
      Caption         =   "Print Name"
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
      TabIndex        =   5
      Top             =   1560
      Width           =   1095
   End
   Begin VB.Label lblAlias 
      BackColor       =   &H8000000C&
      Caption         =   "Alias"
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
      Top             =   1080
      Width           =   855
   End
   Begin VB.Label lblName 
      BackColor       =   &H8000000C&
      Caption         =   "Name"
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
      TabIndex        =   1
      Top             =   600
      Width           =   855
   End
End
Attribute VB_Name = "frmAccMast"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Function WriteXMLStr() As String
    Dim Doc As MSXML2.DOMDocument
    Dim Node As MSXML2.IXMLDOMNode
    Dim NodeChild As MSXML2.IXMLDOMNode
    Dim tmpNode As MSXML2.IXMLDOMNode
    Dim i As Integer
    
    Set Doc = New MSXML2.DOMDocument
    
    Set Node = Doc.createElement("Account")
        
        Set tmpNode = MakeNodeValue(Doc, Node, "Name", txtName.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "Alias", txtAlias.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "PrintName", txtPrintName.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "ParentGroup", cmbGroup.Text, UDF_TEXT)
        
        Set NodeChild = Node.appendChild(Doc.createElement("Address"))
            Set tmpNode = MakeNodeValue(Doc, NodeChild, "Address1", txtAdd1.Text, UDF_TEXT)
            Set tmpNode = MakeNodeValue(Doc, NodeChild, "Address2", txtAdd2.Text, UDF_TEXT)
            Set tmpNode = MakeNodeValue(Doc, NodeChild, "Address3", txtAdd3.Text, UDF_TEXT)
            Set tmpNode = MakeNodeValue(Doc, NodeChild, "Address4", txtAdd4.Text, UDF_TEXT)
        
        
    WriteXMLStr = Doc.transformNode(Node)
    
End Function

Private Sub cmdSave_Click()
    Dim ErrMsg As String
    Dim XMLStr As String
    
    Screen.MousePointer = vbHourglass
    
    XMLStr = WriteXMLStr
    
    If g_FI.SaveMasterFromXML(ACC_MAST, XMLStr, ErrMsg, False) Then
        MsgBox "Master saved  successfully"
    Else
        MsgBox "Master cannot be saved - (" & ErrMsg & ")."
    End If
    Screen.MousePointer = vbDefault

End Sub

'For MODIFICATION of Masters
Private Sub ModifyMaster(p_MasterCode As Long)
    Dim XMLStr As String
    Dim ErrMsg As String
    
    
    'Load Masters data in XML format from Unique Master Code
    XMLStr = g_FI.GetMasterXML(p_MasterCode)
    
    'Make changes in this XML string for modification
        
    'Save Modified XML
    If g_FI.SaveMasterFromXML(ACC_MAST, XMLStr, ErrMsg, True) Then
        MsgBox "Master modified  successfully"
    Else
        MsgBox "Master cannot be modified - (" & ErrMsg & ")."
    End If

End Sub

'Private Function BlankItemEntry(p_Row As Integer) As Boolean
'    If grdItem.TextMatrix(p_Row, 1) = "" And grdItem.TextMatrix(p_Row, 2) = "" And grdItem.TextMatrix(p_Row, 3) = "" And grdItem.TextMatrix(p_Row, 4) = "" And grdItem.TextMatrix(p_Row, 5) = "" Then
'        BlankItemEntry = True
'    End If
'End Function
'
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

'Private Sub cmbItem_Click()
'    grdItem.TextMatrix(grdItem.row, 1) = cmbItem.Text
'    cmbItem.Text = ""
'    cmbItem.Visible = False
'End Sub

'Private Sub cmbUnit_Click()
'    grdItem.TextMatrix(grdItem.row, 3) = cmbUnit.Text
'    cmbUnit.Text = ""
'    cmbUnit.Visible = False
'End Sub

Private Sub cmdQuit_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim Col As New Collection
    Dim i As Integer
    
    Me.Caption = "Add Account Master"
    
    Set Col = GetMastList(AGRP_MAST)
    cmbGroup.Clear
    For i = 1 To Col.Count
        cmbGroup.AddItem Col(i)
    Next
'
'    Set Col = GetMastList(UNIT_MAST)
'    cmbUnit.Clear
'    For i = 1 To Col.Count
'        cmbUnit.AddItem Col(i)
'    Next
'
'    Set Col = LoadVchSeries(SALE)
'    cmbSeries.Clear
'    For i = 1 To Col.Count
'        cmbSeries.AddItem Col(i)
'    Next
'
'    Set Col = GetMastList(ST_MAST)
'    cmbSaleType.Clear
'    For i = 1 To Col.Count
'        cmbSaleType.AddItem Col(i)
'    Next
'
'    Set Col = GetAccList()
'    cmbParty.Clear
'    For i = 1 To Col.Count
'        cmbParty.AddItem Col(i)
'    Next
'
'    Set Col = GetMastList(MC_MAST)
'    cmbMC.Clear
'    For i = 1 To Col.Count
'        cmbMC.AddItem Col(i)
'    Next
'
'    Set Col = GetMastList(BS_MAST)
'    cmbBSName.Clear
'    For i = 1 To Col.Count
'        cmbBSName.AddItem Col(i)
'    Next
'
'    SetGrdItem
'
'    SetGrdBS
    
End Sub

'Private Sub SetGrdItem()
'    Dim i As Integer
'
'    grdItem.Rows = 10
'    grdItem.Cols = 6
'
'    grdItem.FixedRows = 1
'    grdItem.FixedCols = 1
'
'    For i = 0 To grdItem.Rows - 1
'        grdItem.RowHeight(i) = 315
'    Next
'
'    cmbItem.Visible = False
'    txtQty.Visible = False
'    cmbUnit.Visible = False
'    txtPrice.Visible = False
'    txtAmt.Visible = False
'
'    grdItem.TextMatrix(0, 0) = "S.No."
'    grdItem.TextMatrix(0, 1) = "Item"
'    grdItem.TextMatrix(0, 2) = "Qty."
'    grdItem.TextMatrix(0, 3) = "Unit"
'    grdItem.TextMatrix(0, 4) = "Price"
'    grdItem.TextMatrix(0, 5) = "Amount"
'
'    grdItem.ColWidth(0) = 600
'    grdItem.ColWidth(1) = cmbItem.Width
'    grdItem.ColWidth(2) = txtQty.Width
'    grdItem.ColWidth(3) = cmbUnit.Width
'    grdItem.ColWidth(4) = txtPrice.Width
'    grdItem.ColWidth(5) = txtAmt.Width
'
'    For i = 1 To grdItem.Rows - 1
'        grdItem.TextMatrix(i, 0) = CStr(i)
'    Next
'
'End Sub

'Private Sub SetGrdBS()
'    Dim i As Integer
'
'    grdBS.Rows = 10
'    grdBS.Cols = 4
'
'    grdBS.FixedRows = 1
'    grdBS.FixedCols = 1
'
'    For i = 0 To grdBS.Rows - 1
'        grdBS.RowHeight(i) = 315
'    Next
'
'    cmbBSName.Visible = False
'    txtBSPercent.Visible = False
'    txtBSAmt.Visible = False
'
'    grdBS.TextMatrix(0, 0) = "S.No."
'    grdBS.TextMatrix(0, 1) = "Bill Sundry Name"
'    grdBS.TextMatrix(0, 2) = "BS Percent"
'    grdBS.TextMatrix(0, 3) = "BS Amount"
'
'    grdBS.ColWidth(0) = 600
'    grdBS.ColWidth(1) = cmbBSName.Width
'    grdBS.ColWidth(2) = txtBSPercent.Width
'    grdBS.ColWidth(3) = txtBSAmt.Width
'
'    For i = 1 To grdBS.Rows - 1
'        grdBS.TextMatrix(i, 0) = CStr(i)
'    Next
'
'End Sub

'Private Sub grdBS_DblClick()
'    Dim i As Integer
'    Dim LeftPos As Long
'
'    LeftPos = grdBS.Left
'    For i = 0 To grdBS.Col - 1
'        LeftPos = LeftPos + grdBS.ColWidth(i)
'    Next
'
'    Select Case grdBS.Col
'
'        Case 1
'
'            cmbBSName.Visible = True
'            cmbBSName.Top = grdBS.Top + grdBS.CellTop
'            cmbBSName.Left = LeftPos
'            cmbBSName.Text = grdBS.TextMatrix(grdBS.row, 1)
'            cmbBSName.SetFocus
'
'        Case 2
'            txtBSPercent.Visible = True
'            txtBSPercent.Top = grdBS.Top + grdBS.CellTop
'            txtBSPercent.Left = LeftPos
'            txtBSPercent.Text = grdBS.TextMatrix(grdBS.row, 2)
'            txtBSPercent.SetFocus
'
'        Case 3
'            txtBSAmt.Visible = True
'            txtBSAmt.Top = grdBS.Top + grdBS.CellTop
'            txtBSAmt.Left = LeftPos
'            txtBSAmt.Text = grdBS.TextMatrix(grdBS.row, 3)
'            txtBSAmt.SetFocus
'
'    End Select
'
'End Sub

'Private Sub grdItem_DblClick()
'    Dim i As Integer
'    Dim LeftPos As Long
'
'    LeftPos = grdItem.Left
'    For i = 0 To grdItem.Col - 1
'        LeftPos = LeftPos + grdItem.ColWidth(i)
'    Next
'
'    Select Case grdItem.Col
'
'        Case 1
'
'            cmbItem.Visible = True
'            cmbItem.Top = grdItem.Top + grdItem.CellTop
'            cmbItem.Left = LeftPos
'            cmbItem.Text = grdItem.TextMatrix(grdItem.row, 1)
'            cmbItem.SetFocus
'
'        Case 2
'            txtQty.Visible = True
'            txtQty.Top = grdItem.Top + grdItem.CellTop
'            txtQty.Left = LeftPos
'            txtQty.Text = grdItem.TextMatrix(grdItem.row, 2)
'            txtQty.SetFocus
'
'        Case 3
'            cmbUnit.Visible = True
'            cmbUnit.Top = grdItem.Top + grdItem.CellTop
'            cmbUnit.Left = LeftPos
'            cmbUnit.Text = grdItem.TextMatrix(grdItem.row, 3)
'            cmbUnit.SetFocus
'
'        Case 4
'            txtPrice.Visible = True
'            txtPrice.Top = grdItem.Top + grdItem.CellTop
'            txtPrice.Left = LeftPos
'            txtPrice.Text = grdItem.TextMatrix(grdItem.row, 4)
'            txtPrice.SetFocus
'
'        Case 5
'            txtAmt.Visible = True
'            txtAmt.Top = grdItem.Top + grdItem.CellTop
'            txtAmt.Left = LeftPos
'            txtAmt.Text = grdItem.TextMatrix(grdItem.row, 5)
'            txtAmt.SetFocus
'
'
'    End Select
'
'End Sub

'Private Sub txtAmt_KeyDown(KeyCode As Integer, Shift As Integer)
'    If KeyCode = vbKeyReturn Then
'        If txtAmt <> "" Then
'            grdItem.TextMatrix(grdItem.row, 5) = txtAmt.Text
'            txtAmt.Text = ""
'        End If
'        txtAmt.Visible = False
'    End If
'End Sub

'Private Sub txtBSAmt_KeyDown(KeyCode As Integer, Shift As Integer)
'    If KeyCode = vbKeyReturn Then
'        If txtBSAmt <> "" Then
'            grdBS.TextMatrix(grdBS.row, 3) = txtBSAmt.Text
'            txtBSAmt.Text = ""
'        End If
'        txtBSAmt.Visible = False
'    End If
'End Sub
'
'Private Sub txtBSPercent_KeyDown(KeyCode As Integer, Shift As Integer)
'    If KeyCode = vbKeyReturn Then
'        If txtBSPercent.Text <> "" Then
'            grdBS.TextMatrix(grdBS.row, 2) = txtBSPercent.Text
'            txtBSPercent.Text = ""
'        End If
'        txtBSPercent.Visible = False
'    End If
'End Sub

'Private Sub txtDate_KeyDown(KeyCode As Integer, Shift As Integer)
''    Dim udtVchNum As udtVchNumbering
''    Dim VchNo As String
''
''    If KeyCode = vbKeyReturn Then
''        udtVchNum = g_OS.GetVchNumInfoData(g_MS.MasterName2CodeIfExist(g_OS.Series2MasterName(SALE, cmbSeries.Text), SERIES_MAST))
''        If udtVchNum.NumberingType = VCHNUMBERING_AUTO Then
''            If udtVchNum.ReNumFrequency = RENUMBER_YEARLY Then
''                m_udtVchData.AutoVchNo = g_TS.GenerateAutoVchNumber(udtVchNum, VchNo)
''            Else
''                m_udtVchData.AutoVchNo = g_TS.GenerateAutoVchNumber(udtVchNum, VchNo, Text2Date(txtDate.Text))
''            End If
''            txtVchNo.Text = VchNo
''            txtVchNo.SetFocus
''        End If
''    End If
'End Sub
'
'Private Sub txtPrice_KeyDown(KeyCode As Integer, Shift As Integer)
'    If KeyCode = vbKeyReturn Then
'        If txtPrice.Text <> "" Then
'            grdItem.TextMatrix(grdItem.row, 4) = txtPrice.Text
'            grdItem.TextMatrix(grdItem.row, 5) = CStr(grdItem.TextMatrix(grdItem.row, 2) * grdItem.TextMatrix(grdItem.row, 4))
'            txtPrice.Text = ""
'        End If
'        txtPrice.Visible = False
'    End If
'End Sub
'
'Private Sub txtQty_KeyDown(KeyCode As Integer, Shift As Integer)
'    If KeyCode = vbKeyReturn Then
'        If txtQty.Text <> "" Then
'            grdItem.TextMatrix(grdItem.row, 2) = txtQty.Text
'            txtQty.Text = ""
'        End If
'        txtQty.Visible = False
'    End If
'End Sub



