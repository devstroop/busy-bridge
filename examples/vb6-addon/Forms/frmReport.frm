VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MShflxgd.ocx"
Begin VB.Form frmReport 
   BackColor       =   &H8000000C&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   7995
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   14070
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7995
   ScaleWidth      =   14070
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdQuit 
      Caption         =   "Quit"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   6480
      TabIndex        =   1
      Top             =   7200
      Width           =   1095
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid FG1 
      Height          =   6495
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   13575
      _ExtentX        =   23945
      _ExtentY        =   11456
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
   Begin VB.Label lblTotal 
      BackColor       =   &H8000000C&
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Index           =   0
      Left            =   2400
      TabIndex        =   2
      Top             =   7200
      Width           =   1455
   End
End
Attribute VB_Name = "frmReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_FieldsInfo As Collection

Private m_ShowTotalsFor As Collection
Private m_Totals() As Double

Private m_StartDate As Date
Private m_EndDate As Date

Private Sub cmdQuit_Click()
    Unload Me
End Sub

Private Sub FG1_Scroll()
    UpdateTotalsLeftPos
End Sub

Private Sub Form_Load()

    lblTotal(0).Visible = False
    lblTotal(0).Alignment = vbRightJustify

    Me.Caption = "Account Day Book"
End Sub

Public Function SetInputValues(p_StartDate As Date, p_EndDate As Date)
    m_StartDate = p_StartDate
    m_EndDate = p_EndDate
End Function

Public Function UpdateFieldsInfo()
    Set m_FieldsInfo = GetFieldsColForDayBook
End Function

Public Function SetFieldsInfo()
    Dim i As Integer
    Dim Count As Integer
    Dim LeftPos As Long
    Dim j As Integer
    Dim SRFld As Collection

    Count = 0

    FlushCol m_ShowTotalsFor

    FG1.FixedCols = 0
'    FG1.FixedRows = 1

    FG1.Rows = 2
    FG1.Cols = m_FieldsInfo.Count

    ReDim m_Totals(1 To m_FieldsInfo.Count) As Double

    For i = 0 To m_FieldsInfo.Count - 1
        FlushCol SRFld
        
        Set SRFld = m_FieldsInfo(i + 1)
        
        FG1.TextArray(i) = SRFld(1)

        If SRFld(3) = FLD_ALIGN_CENTRE Then
            FG1.ColAlignment(i) = flexAlignCenterCenter
        ElseIf SRFld(3) = FLD_ALIGN_RIGHT Then
            FG1.ColAlignment(i) = flexAlignRightCenter
        Else
            FG1.ColAlignment(i) = flexAlignLeftCenter
        End If

        FG1.ColWidth(i) = SRFld(2)

        If SRFld(4) = True Then
            m_ShowTotalsFor.Add i
            If Count = 0 Then
                lblTotal(Count).Visible = True
            Else
                Load lblTotal(Count)
                lblTotal(Count).Visible = True
            End If
            lblTotal(Count).Alignment = vbRightJustify
            lblTotal(Count).Width = FG1.ColWidth(i)
            lblTotal(Count).Top = FG1.Top + FG1.Height + 50
            lblTotal(Count).Left = GetColLeft(i)
            Count = Count + 1
        End If
    Next

End Function

Public Function GenRep()
    Dim Rst As Recordset
    Dim i As Integer
    Dim row As Integer

    row = 1

'    FlushCol m_Totals
    For i = 1 To UBound(m_Totals)
        m_Totals(i) = 0
    Next

    Set Rst = GenRepForAccdayBook

    If Rst.RecordCount > 0 Then
        Rst.MoveLast
        Rst.MoveFirst

        Do While Not Rst.EOF

            AddData2Grid Rst, row

            FG1.AddItem ""
            row = row + 1

            Rst.MoveNext
        Loop
    End If

    Set Rst = Nothing

End Function

Private Function AddData2Grid(Rst As Recordset, p_Row As Integer)
    Dim Amt As Double

    With Rst
        If !SrNo = 1 Then
            FG1.TextMatrix(p_Row, 0) = Format(!Date, "dd-mm-yyyy")
            FG1.TextMatrix(p_Row, 1) = g_FI.VchType2ShortName(!VchType)
            FG1.TextMatrix(p_Row, 2) = Trim$(!VchNo)
        Else
            FG1.TextMatrix(p_Row, 0) = ""
            FG1.TextMatrix(p_Row, 1) = ""
            FG1.TextMatrix(p_Row, 2) = ""
        End If

        FG1.TextMatrix(p_Row, 3) = !MastName
        If !Value1 < -ZERO_VAL Then
            FG1.TextMatrix(p_Row, 4) = Format(Abs(!Value1), "#######0.00") 'FormatNum(Abs(!Value1), AMT_MAX_CHAR, g_CC.CurDecimal, True, True)
            m_Totals(1) = m_Totals(1) + Abs(!Value1)
            FG1.TextMatrix(p_Row, 5) = ""
        Else
            FG1.TextMatrix(p_Row, 4) = ""
            FG1.TextMatrix(p_Row, 5) = Format(Abs(!Value1), "#######0.00") 'FormatNum(Abs(!Value1), AMT_MAX_CHAR, g_CC.CurDecimal, True, True)
            m_Totals(2) = m_Totals(2) + Abs(!Value1)
        End If
        FG1.TextMatrix(p_Row, 6) = !ShortNar
    End With

End Function

Public Function ShowForm()
        
    Screen.MousePointer = vbHourglass

    UpdateFieldsInfo
    SetFieldsInfo
    GenRep

    ShowTotalsInfo

    Screen.MousePointer = vbDefault

    Me.Show vbModal

End Function

Private Sub ShowTotalsInfo()
    Dim i As Integer

    For i = 1 To m_ShowTotalsFor.Count
        lblTotal(i - 1).Caption = Format(m_Totals(i), "#######0.00") 'FormatNum(m_Totals(i), AMT_MAX_CHAR, g_CC.CurDecimal, True, True)
    Next

End Sub

Private Function ColVisible(p_ColNo As Integer) As Boolean
    Dim i As Integer
    Dim Wid As Long
    Dim Margin As Long

    Margin = FG1.ColWidth(p_ColNo) / 2

    For i = FG1.LeftCol To p_ColNo
        Wid = Wid + FG1.ColWidth(i)
    Next

    If (Wid - Margin) > FG1.Width Or p_ColNo < FG1.LeftCol Then
        ColVisible = False
    Else
        ColVisible = True
    End If


End Function

Private Sub UpdateTotalsLeftPos()
    Dim i As Integer
    Dim ColNo As Integer

    For i = 1 To m_ShowTotalsFor.Count
        ColNo = m_ShowTotalsFor(i) - 1
        'If fg1.ColIsVisible(ColNo) Then
        If ColVisible(ColNo) Then
            lblTotal(i - 1).Visible = True
            lblTotal(i - 1).Left = GetColLeft(ColNo)

            'If lblTotal(i - 1).Left + lblTotal(i - 1).Width > fg1.Left + fg1.Width Then
                'lblTotal(i - 1).Width = lblTotal(i - 1).Width - ((lblTotal(i - 1).Left + lblTotal(i - 1).Width) - (fg1.Left + fg1.Width))
            'Else
                'lblTotal(i - 1).Width = fg1.ColWidth(ColNo)
            'End If

        Else
            lblTotal(i - 1).Visible = False
        End If
    Next

End Sub

Private Function GetColLeft(p_ColNo As Integer) As Long
    Dim i As Integer

    GetColLeft = FG1.Left

    For i = FG1.LeftCol To p_ColNo - 1
        GetColLeft = GetColLeft + FG1.ColWidth(i)
    Next

End Function

Public Function GenQryStrForDayBook() As String
    Dim QryStr As String
    Dim RecTypeStr As String

    RecTypeStr = " Tran2.RecType = " & CStr(T2_ACC_DATA)

    QryStr = "SELECT Tran2.TranType,Tran2.Date,Tran2.VchType,Tran2.VchNo,Tran2.Value1,Tran2.ShortNar,Tran2.VchSeriesCode,Tran2.VchCode,Tran2.SrNo," & g_FI.MastCode2NameQryStr("Tran2.MasterCode1") & " as MastName from Tran2 Where " & RecTypeStr & " And Tran2.Date Between " & DateRangeStr(m_StartDate, m_EndDate) & " Order By Tran2.Date,Tran2.VchType,Tran2.VchNo,Tran2.VchCode,Tran2.SrNo"

    GenQryStrForDayBook = QryStr

End Function

Public Function GenRepForAccdayBook() As Recordset
    Dim qry As String
    Dim Rst As Recordset

    qry = GenQryStrForDayBook
    Set GenRepForAccdayBook = g_FI.GetRecordset(qry)

End Function

Public Function GetFieldsColForDayBook() As Collection
    Dim FieldsInfo As Collection
    Dim Col As Collection
    
    FlushCol FieldsInfo
    
    FlushCol Col: Col.Add "Date": Col.Add 1200: Col.Add FLD_ALIGN_CENTRE: Col.Add False: FieldsInfo.Add Col
    FlushCol Col: Col.Add "Type": Col.Add 700: Col.Add FLD_ALIGN_CENTRE: Col.Add False: FieldsInfo.Add Col
    FlushCol Col: Col.Add "Vch/Bill No.": Col.Add 1800: Col.Add FLD_ALIGN_CENTRE: Col.Add False: FieldsInfo.Add Col
    FlushCol Col: Col.Add "Account": Col.Add 4200: Col.Add FLD_ALIGN_LEFT: Col.Add False: FieldsInfo.Add Col
    FlushCol Col: Col.Add "Debit": Col.Add 1500: Col.Add FLD_ALIGN_RIGHT: Col.Add True: FieldsInfo.Add Col
    FlushCol Col: Col.Add "Credit": Col.Add 1500: Col.Add FLD_ALIGN_RIGHT: Col.Add True: FieldsInfo.Add Col
    FlushCol Col: Col.Add "Short Narration": Col.Add 3000: Col.Add FLD_ALIGN_LEFT: Col.Add False: FieldsInfo.Add Col
    
    Set GetFieldsColForDayBook = FieldsInfo

End Function

