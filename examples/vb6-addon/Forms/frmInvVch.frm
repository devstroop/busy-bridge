VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MShflxgd.ocx"
Begin VB.Form frmInvVch 
   BackColor       =   &H8000000C&
   Caption         =   "Form1"
   ClientHeight    =   8790
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   12465
   LinkTopic       =   "Form1"
   ScaleHeight     =   8790
   ScaleWidth      =   12465
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtNarration 
      Height          =   285
      Left            =   1080
      TabIndex        =   6
      Top             =   1320
      Width           =   10935
   End
   Begin VB.TextBox txtPrice 
      Height          =   315
      Left            =   8040
      TabIndex        =   10
      Top             =   2160
      Width           =   1575
   End
   Begin VB.ComboBox cmbUnit 
      Height          =   315
      ItemData        =   "frmInvVch.frx":0000
      Left            =   6120
      List            =   "frmInvVch.frx":0010
      TabIndex        =   9
      Top             =   2160
      Width           =   1815
   End
   Begin VB.TextBox txtQty 
      Height          =   315
      Left            =   4560
      TabIndex        =   8
      Top             =   2160
      Width           =   1455
   End
   Begin VB.ComboBox cmbItem 
      Height          =   315
      ItemData        =   "frmInvVch.frx":0030
      Left            =   360
      List            =   "frmInvVch.frx":0043
      TabIndex        =   7
      Top             =   2160
      Width           =   4095
   End
   Begin VB.TextBox txtAmt 
      Height          =   315
      Left            =   9840
      TabIndex        =   11
      Top             =   2160
      Width           =   1575
   End
   Begin VB.ComboBox cmbSeries 
      Height          =   315
      Left            =   960
      TabIndex        =   0
      Top             =   360
      Width           =   1215
   End
   Begin VB.TextBox txtDate 
      Height          =   285
      Left            =   3480
      TabIndex        =   1
      Top             =   360
      Width           =   1335
   End
   Begin VB.TextBox txtVchNo 
      Height          =   285
      Left            =   6360
      TabIndex        =   2
      Top             =   360
      Width           =   1455
   End
   Begin VB.ComboBox cmbSaleType 
      Height          =   315
      Left            =   9600
      TabIndex        =   3
      Top             =   360
      Width           =   2415
   End
   Begin VB.ComboBox cmbParty 
      Height          =   315
      Left            =   960
      TabIndex        =   4
      Top             =   840
      Width           =   5175
   End
   Begin VB.ComboBox cmbMC 
      Height          =   315
      Left            =   8280
      TabIndex        =   5
      Top             =   840
      Width           =   3735
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
      Left            =   4920
      TabIndex        =   15
      Top             =   8160
      Width           =   1215
   End
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
      Left            =   6240
      TabIndex        =   16
      Top             =   8160
      Width           =   1215
   End
   Begin VB.ComboBox cmbBSName 
      Height          =   315
      Left            =   3480
      TabIndex        =   12
      Top             =   6120
      Width           =   3975
   End
   Begin VB.TextBox txtBSPercent 
      Height          =   285
      Left            =   7680
      TabIndex        =   13
      Top             =   6120
      Width           =   1815
   End
   Begin VB.TextBox txtBSAmt 
      Height          =   285
      Left            =   9720
      TabIndex        =   14
      Top             =   6120
      Width           =   2295
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid grdBS 
      Height          =   2415
      Left            =   2640
      TabIndex        =   17
      Top             =   5400
      Width           =   9495
      _ExtentX        =   16748
      _ExtentY        =   4260
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid grdItem 
      Height          =   3375
      Left            =   240
      TabIndex        =   18
      Top             =   1800
      Width           =   11895
      _ExtentX        =   20981
      _ExtentY        =   5953
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
   Begin VB.Label lblNarr 
      BackColor       =   &H8000000C&
      Caption         =   "Narration"
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
      TabIndex        =   25
      Top             =   1320
      Width           =   855
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
      TabIndex        =   24
      Top             =   360
      Width           =   735
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
      TabIndex        =   23
      Top             =   360
      Width           =   615
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
      TabIndex        =   22
      Top             =   360
      Width           =   975
   End
   Begin VB.Label lblSaleType 
      BackColor       =   &H8000000C&
      Caption         =   "Sale Type"
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
      Left            =   8520
      TabIndex        =   21
      Top             =   360
      Width           =   975
   End
   Begin VB.Label lblParty 
      BackColor       =   &H8000000C&
      Caption         =   "Party"
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
      TabIndex        =   20
      Top             =   840
      Width           =   735
   End
   Begin VB.Label lblMC 
      BackColor       =   &H8000000C&
      Caption         =   "Material Center"
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
      Left            =   6840
      TabIndex        =   19
      Top             =   840
      Width           =   1335
   End
End
Attribute VB_Name = "frmInvVch"
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
    
    Set Node = Doc.createElement("Sale")
        
        Set tmpNode = MakeNodeValue(Doc, Node, "VchSeriesName", cmbSeries.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "Date", Format(txtDate.Text, "dd-mm-yyyy"), UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "VchType", SALE, UDF_INTEGER)
        Set tmpNode = MakeNodeValue(Doc, Node, "VchNo", txtVchNo.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "STPTName", cmbSaleType.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "MasterName1", cmbParty.Text, UDF_TEXT)
        Set tmpNode = MakeNodeValue(Doc, Node, "MasterName2", cmbMC.Text, UDF_TEXT)
        
        Set NodeChild = Node.appendChild(Doc.createElement("VchOtherInfoDetails"))
            Set tmpNode = MakeNodeValue(Doc, NodeChild, "Narration1", txtNarration.Text, UDF_BOOLEAN)
        
        
        Set NodeChild = Node.appendChild(Doc.createElement("ItemEntries"))
            For i = 1 To grdItem.Rows - 1
                If Not BlankItemEntry(i) Then
                    
                    Set NodeChild = NodeChild.appendChild(Doc.createElement("ItemDetail"))
                    
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "SrNo", i, UDF_INTEGER)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "ItemName", grdItem.TextMatrix(i, 1), UDF_TEXT)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "Qty", grdItem.TextMatrix(i, 2), UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "UnitName", grdItem.TextMatrix(i, 3), UDF_TEXT)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "Price", grdItem.TextMatrix(i, 4), UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "Amt", grdItem.TextMatrix(i, 5), UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "MC", cmbMC.Text, UDF_TEXT)
                        
                        'Tags Used for Local Tax Item-wise
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "STAmount", 240, UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "STPercent", 12, UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "STPercent1", 12, UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxBeforeSurcharge", 120, UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxBeforeSurcharge1", 120, UDF_DOUBLE)
                        
                        'Tags Used for Central Tax
                        'Set tmpNode = MakeNodeValue(Doc, NodeChild, "STAmount", m_STAmt, UDF_DOUBLE)
                        'Set tmpNode = MakeNodeValue(Doc, NodeChild, "STPercent", m_IGSTPercent, UDF_DOUBLE)
                        'Set tmpNode = MakeNodeValue(Doc, NodeChild, "TaxBeforeSurcharge", m_IGSTAmt, UDF_DOUBLE)
                        
                    Set NodeChild = NodeChild.parentNode
                        
                End If
            Next
            
            
        Set NodeChild = Node.appendChild(Doc.createElement("BillSundries"))
            For i = 1 To grdBS.Rows - 1
                If Not BlankBSEntry(i) Then
                    
                    Set NodeChild = NodeChild.appendChild(Doc.createElement("BSDetail"))
                    
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "SrNo", i, UDF_INTEGER)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "BSName", grdBS.TextMatrix(i, 1), UDF_TEXT)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "PercentVal", grdBS.TextMatrix(i, 2), UDF_DOUBLE)
                        Set tmpNode = MakeNodeValue(Doc, NodeChild, "Amt", grdBS.TextMatrix(i, 3), UDF_DOUBLE)
                                                
                    Set NodeChild = NodeChild.parentNode
                    
                End If
            Next
            
            
    WriteXMLStr = Doc.transformNode(Node)
    
End Function

Private Sub cmdSave_Click()
    Dim ErrMsg As String
    Dim XMLStr As String
    
    Screen.MousePointer = vbHourglass
    
    XMLStr = WriteXMLStr
    
    If g_FI.SaveVchFromXML(SALE, XMLStr, ErrMsg, False) Then
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
    If g_FI.ModifyVchFromXMLByCode(SALE, p_VchCode, XMLStr, ErrMsg) Then
        MsgBox "Voucher modified  successfully"
    Else
        MsgBox "Voucher cannot be modified - (" & ErrMsg & ")."
    End If

End Sub

Private Function BlankItemEntry(p_Row As Integer) As Boolean
    If grdItem.TextMatrix(p_Row, 1) = "" And grdItem.TextMatrix(p_Row, 2) = "" And grdItem.TextMatrix(p_Row, 3) = "" And grdItem.TextMatrix(p_Row, 4) = "" And grdItem.TextMatrix(p_Row, 5) = "" Then
        BlankItemEntry = True
    End If
End Function

Private Function BlankBSEntry(p_Row As Integer) As Boolean
    If grdBS.TextMatrix(p_Row, 1) = "" And grdBS.TextMatrix(p_Row, 2) = "" And grdBS.TextMatrix(p_Row, 3) = "" Then
        BlankBSEntry = True
    End If
End Function

Private Sub cmbBSName_Click()
    grdBS.TextMatrix(grdBS.row, 1) = cmbBSName.Text
    cmbBSName.Text = ""
    cmbBSName.Visible = False
End Sub

Private Sub cmbItem_Click()
    grdItem.TextMatrix(grdItem.row, 1) = cmbItem.Text
    cmbItem.Text = ""
    cmbItem.Visible = False
End Sub

Private Sub cmbUnit_Click()
    grdItem.TextMatrix(grdItem.row, 3) = cmbUnit.Text
    cmbUnit.Text = ""
    cmbUnit.Visible = False
End Sub

Private Sub cmdQuit_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim Col As New Collection
    Dim i As Integer
    
    Me.Caption = "Add Sales Vch."
    
    Set Col = GetMastList(ITEM_MAST)
    cmbItem.Clear
    For i = 1 To Col.Count
        cmbItem.AddItem Col(i)
    Next
    
    Set Col = GetMastList(UNIT_MAST)
    cmbUnit.Clear
    For i = 1 To Col.Count
        cmbUnit.AddItem Col(i)
    Next
    
    Set Col = LoadVchSeries(SALE)
    cmbSeries.Clear
    For i = 1 To Col.Count
        cmbSeries.AddItem Col(i)
    Next
    
    Set Col = GetMastList(ST_MAST)
    cmbSaleType.Clear
    For i = 1 To Col.Count
        cmbSaleType.AddItem Col(i)
    Next
        
    Set Col = GetAccList()
    cmbParty.Clear
    For i = 1 To Col.Count
        cmbParty.AddItem Col(i)
    Next
    
    Set Col = GetMastList(MC_MAST)
    cmbMC.Clear
    For i = 1 To Col.Count
        cmbMC.AddItem Col(i)
    Next
    
    Set Col = GetMastList(BS_MAST)
    cmbBSName.Clear
    For i = 1 To Col.Count
        cmbBSName.AddItem Col(i)
    Next
    
    SetGrdItem
    
    SetGrdBS
    
End Sub

Private Sub SetGrdItem()
    Dim i As Integer
        
    grdItem.Rows = 10
    grdItem.Cols = 6
    
    grdItem.FixedRows = 1
    grdItem.FixedCols = 1
    
    For i = 0 To grdItem.Rows - 1
        grdItem.RowHeight(i) = 315
    Next
    
    cmbItem.Visible = False
    txtQty.Visible = False
    cmbUnit.Visible = False
    txtPrice.Visible = False
    txtAmt.Visible = False
        
    grdItem.TextMatrix(0, 0) = "S.No."
    grdItem.TextMatrix(0, 1) = "Item"
    grdItem.TextMatrix(0, 2) = "Qty."
    grdItem.TextMatrix(0, 3) = "Unit"
    grdItem.TextMatrix(0, 4) = "Price"
    grdItem.TextMatrix(0, 5) = "Amount"
    
    grdItem.ColWidth(0) = 600
    grdItem.ColWidth(1) = cmbItem.Width
    grdItem.ColWidth(2) = txtQty.Width
    grdItem.ColWidth(3) = cmbUnit.Width
    grdItem.ColWidth(4) = txtPrice.Width
    grdItem.ColWidth(5) = txtAmt.Width
    
    For i = 1 To grdItem.Rows - 1
        grdItem.TextMatrix(i, 0) = CStr(i)
    Next
    
End Sub

Private Sub SetGrdBS()
    Dim i As Integer
        
    grdBS.Rows = 10
    grdBS.Cols = 4
    
    grdBS.FixedRows = 1
    grdBS.FixedCols = 1
    
    For i = 0 To grdBS.Rows - 1
        grdBS.RowHeight(i) = 315
    Next
    
    cmbBSName.Visible = False
    txtBSPercent.Visible = False
    txtBSAmt.Visible = False
        
    grdBS.TextMatrix(0, 0) = "S.No."
    grdBS.TextMatrix(0, 1) = "Bill Sundry Name"
    grdBS.TextMatrix(0, 2) = "BS Percent"
    grdBS.TextMatrix(0, 3) = "BS Amount"
    
    grdBS.ColWidth(0) = 600
    grdBS.ColWidth(1) = cmbBSName.Width
    grdBS.ColWidth(2) = txtBSPercent.Width
    grdBS.ColWidth(3) = txtBSAmt.Width
    
    For i = 1 To grdBS.Rows - 1
        grdBS.TextMatrix(i, 0) = CStr(i)
    Next
    
End Sub

Private Sub grdBS_DblClick()
    Dim i As Integer
    Dim LeftPos As Long
    
    LeftPos = grdBS.Left
    For i = 0 To grdBS.Col - 1
        LeftPos = LeftPos + grdBS.ColWidth(i)
    Next
    
    Select Case grdBS.Col
    
        Case 1
            
            cmbBSName.Visible = True
            cmbBSName.Top = grdBS.Top + grdBS.CellTop
            cmbBSName.Left = LeftPos
            cmbBSName.Text = grdBS.TextMatrix(grdBS.row, 1)
            cmbBSName.SetFocus
            
        Case 2
            txtBSPercent.Visible = True
            txtBSPercent.Top = grdBS.Top + grdBS.CellTop
            txtBSPercent.Left = LeftPos
            txtBSPercent.Text = grdBS.TextMatrix(grdBS.row, 2)
            txtBSPercent.SetFocus
            
        Case 3
            txtBSAmt.Visible = True
            txtBSAmt.Top = grdBS.Top + grdBS.CellTop
            txtBSAmt.Left = LeftPos
            txtBSAmt.Text = grdBS.TextMatrix(grdBS.row, 3)
            txtBSAmt.SetFocus
            
    End Select
    
End Sub

Private Sub grdItem_DblClick()
    Dim i As Integer
    Dim LeftPos As Long
    
    LeftPos = grdItem.Left
    For i = 0 To grdItem.Col - 1
        LeftPos = LeftPos + grdItem.ColWidth(i)
    Next
    
    Select Case grdItem.Col
    
        Case 1
            
            cmbItem.Visible = True
            cmbItem.Top = grdItem.Top + grdItem.CellTop
            cmbItem.Left = LeftPos
            cmbItem.Text = grdItem.TextMatrix(grdItem.row, 1)
            cmbItem.SetFocus
            
        Case 2
            txtQty.Visible = True
            txtQty.Top = grdItem.Top + grdItem.CellTop
            txtQty.Left = LeftPos
            txtQty.Text = grdItem.TextMatrix(grdItem.row, 2)
            txtQty.SetFocus
            
        Case 3
            cmbUnit.Visible = True
            cmbUnit.Top = grdItem.Top + grdItem.CellTop
            cmbUnit.Left = LeftPos
            cmbUnit.Text = grdItem.TextMatrix(grdItem.row, 3)
            cmbUnit.SetFocus
            
        Case 4
            txtPrice.Visible = True
            txtPrice.Top = grdItem.Top + grdItem.CellTop
            txtPrice.Left = LeftPos
            txtPrice.Text = grdItem.TextMatrix(grdItem.row, 4)
            txtPrice.SetFocus
            
        Case 5
            txtAmt.Visible = True
            txtAmt.Top = grdItem.Top + grdItem.CellTop
            txtAmt.Left = LeftPos
            txtAmt.Text = grdItem.TextMatrix(grdItem.row, 5)
            txtAmt.SetFocus
            
            
    End Select
    
End Sub

Private Sub txtAmt_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtAmt <> "" Then
            grdItem.TextMatrix(grdItem.row, 5) = txtAmt.Text
            txtAmt.Text = ""
        End If
        txtAmt.Visible = False
    End If
End Sub

Private Sub txtBSAmt_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtBSAmt <> "" Then
            grdBS.TextMatrix(grdBS.row, 3) = txtBSAmt.Text
            txtBSAmt.Text = ""
        End If
        txtBSAmt.Visible = False
    End If
End Sub

Private Sub txtBSPercent_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtBSPercent.Text <> "" Then
            grdBS.TextMatrix(grdBS.row, 2) = txtBSPercent.Text
            txtBSPercent.Text = ""
        End If
        txtBSPercent.Visible = False
    End If
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

Private Sub txtPrice_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtPrice.Text <> "" Then
            grdItem.TextMatrix(grdItem.row, 4) = txtPrice.Text
            grdItem.TextMatrix(grdItem.row, 5) = CStr(grdItem.TextMatrix(grdItem.row, 2) * grdItem.TextMatrix(grdItem.row, 4))
            txtPrice.Text = ""
        End If
        txtPrice.Visible = False
    End If
End Sub

Private Sub txtQty_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyReturn Then
        If txtQty.Text <> "" Then
            grdItem.TextMatrix(grdItem.row, 2) = txtQty.Text
            txtQty.Text = ""
        End If
        txtQty.Visible = False
    End If
End Sub


