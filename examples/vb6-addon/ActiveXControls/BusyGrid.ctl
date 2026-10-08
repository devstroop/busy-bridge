VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "mshflxgd.ocx"
Begin VB.UserControl BusyGrid 
   ClientHeight    =   735
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3750
   ScaleHeight     =   735
   ScaleWidth      =   3750
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid fGrid1 
      Height          =   735
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   3735
      _ExtentX        =   6588
      _ExtentY        =   1296
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
   Begin VB.Menu mnuGrid 
      Caption         =   "Grid Options"
      Begin VB.Menu mnuDelete 
         Caption         =   "Delete Row"
      End
      Begin VB.Menu mnuBlank1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuInsert 
         Caption         =   "Insert Row"
      End
   End
End
Attribute VB_Name = "BusyGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private m_ControlArray As Collection
Public LeftPos As Long
Public TopPos As Long

Private m_OldRowNo As Integer
Private m_OldRowForKey As Integer
Private m_OldColForKey As Integer


Private m_RowDeleteInsert As Integer

Public ValidRow As Boolean

Private m_CanBeChanged As Boolean
Private m_CantChangeMsg As String
Private m_CanDeleteRow As Boolean
Private m_CanInsertRow As Boolean
Private m_CanEditCol As Boolean

Public ValidCol As Boolean

Event MyGridTextChanged(p_Row As Integer, p_Col As Integer, p_Contents As String)
Event MyColEntryDone(p_Row As Integer, p_Col As Integer)
Event KeyPress(KeyAscii As Integer)
Event KeyDown(KeyCode As Integer, Shift As Integer)
Event ValidateRow(p_RowNo As Integer)
Event ValidateCol(p_RowNo As Integer, p_ColNo As Integer)
Event Click()
Event DblClick()
Event MyGotFocus()
Event MyLostFocus()
Event Scroll()
Event MyRowDeleted(RowNo As Integer)
Event MyRowInserted(RowNo As Integer)
Event MyRowChanged(NewRowNo As Integer, OldRowNo As Integer)
Event RowColChange()
Event MyGridLeave()
Event MyCanDeleteRow(ByVal RowNo As Integer, ByRef strError As String)
Event MyCanInsertRow(ByVal RowNo As Integer, ByRef strError As String)
Event MyCanEditCol(ByVal RowNo As Integer, ByVal ColNo As Integer, ByRef strError As String)

Private Sub ActivateDataEntry()
    Dim MyControl As Control
    Dim strError As String
    
    If m_CanBeChanged Then
        ValidRow = True
        
        If fGrid1.Row >= fGrid1.FixedRows Then
            RaiseEvent ValidateRow(fGrid1.Row - 1)
            DoEvents
        End If
        
        If ValidRow Then
            m_CanEditCol = True
            RaiseEvent MyCanEditCol(fGrid1.Row, fGrid1.Col, strError)
            DoEvents
            
            If m_CanEditCol Then
            
                Set MyControl = m_ControlArray(fGrid1.Col + 1 - fGrid1.FixedCols)
        
                MyControl.Left = LeftPos + fGrid1.CellLeft + fGrid1.Left
                MyControl.Top = TopPos + fGrid1.CellTop + fGrid1.Top
                MyControl.Visible = True
                MyControl.Text = fGrid1.Text
                MyControl.SetFocus
            
                If fGrid1.RowIsVisible(fGrid1.Row) = False Then
                    fGrid1.TopRow = fGrid1.Row
                End If
            Else
                ShowCantChangeMsg strError
            End If
        End If
    Else
        ShowCantChangeMsg m_CantChangeMsg
    End If
    
End Sub
Private Sub fGrid1_Click()
    RaiseEvent Click
End Sub
Private Sub DisableAllControls()
    Dim i As Integer
          
    For i = 1 To m_ControlArray.Count
    
        m_ControlArray(i).Visible = False
        
    Next

End Sub
Private Sub fGrid1_DblClick()
    If fGrid1.MouseCol >= fGrid1.FixedCols Then
        If fGrid1.MouseRow >= fGrid1.FixedRows Then
            ActivateDataEntry
        End If
    End If
    RaiseEvent DblClick
End Sub
Private Sub fGrid1_GotFocus()
    m_OldRowForKey = fGrid1.Row
    m_OldColForKey = fGrid1.Col
    DisableAllControls
    RaiseEvent MyRowChanged(1, -1)
    RaiseEvent MyGotFocus
    
End Sub
Private Sub fGrid1_KeyDown(KeyCode As Integer, Shift As Integer)
    Dim BText As BusyText
    Dim CalVal As Double
    Dim strError As String
    Dim MasterName As String
    
    If Shift = 0 Then
        If KeyCode = vbKeyF9 Then
            m_RowDeleteInsert = fGrid1.Row
            mnuDelete_Click
            KeyCode = 0
        ElseIf KeyCode = vbKeyF10 Then
            KeyCode = 0
'            CalVal = ShowCalculator()
'            If CalVal <> 0 And m_CanBeChanged Then
'                Set BText = m_ControlArray(fGrid1.Col)
'                If BText.BoxType = 1 Then
'                    m_CanEditCol = True
'                    RaiseEvent MyCanEditCol(fGrid1.Row, fGrid1.Col, strError)
'                    DoEvents
'                    If m_CanEditCol Then
'                        SetGridText fGrid1.Row, fGrid1.Col, FormatNum(CalVal, BText.MaxChar, BText.MaxDecimal, True, False)
'                    End If
'                End If
'                Set BText = Nothing
'            End If
            fGrid1.SetFocus
        ElseIf KeyCode = vbKeyF3 Then
            KeyCode = 0
'            fGrid1.MousePointer = flexHourglass
'            Set BText = m_ControlArray(fGrid1.Col)
'            If BText.BoxType = 5 And BText.MasterType <> 0 Then
'                MasterName = AddMaster(BText.MasterType, ADD_ONE)
'                If Trim$(MasterName) <> "" And m_CanBeChanged Then
'                    m_CanEditCol = True
'                    RaiseEvent MyCanEditCol(fGrid1.Row, fGrid1.Col, strError)
'                    DoEvents
'                    If m_CanEditCol Then
'                        SetGridText fGrid1.Row, fGrid1.Col, MasterName
'                        SendKeys "{ENTER}"
'                    End If
'                End If
'            End If
'            Set BText = Nothing
'            fGrid1.SetFocus
'            fGrid1.MousePointer = flexDefault
        ElseIf KeyCode = vbKeyInsert Then
            m_RowDeleteInsert = fGrid1.Row
            mnuInsert_Click
            KeyCode = 0
        ElseIf KeyCode = vbKeyUp And m_OldRowForKey = fGrid1.FixedRows Then
            KeyCode = 0
            SendKeys "+{TAB}"
        ElseIf KeyCode = vbKeyLeft And m_OldRowForKey > fGrid1.FixedRows And m_OldColForKey = fGrid1.FixedCols Then
            KeyCode = 0
            fGrid1.Row = fGrid1.Row - 1
            fGrid1.Col = fGrid1.Cols - 1
        ElseIf KeyCode = vbKeyRight And m_OldRowForKey < (fGrid1.Rows - fGrid1.FixedRows) And m_OldColForKey = fGrid1.Cols - 1 Then
            KeyCode = 0
            fGrid1.Row = fGrid1.Row + 1
            fGrid1.Col = fGrid1.FixedCols
        End If
    End If
    
    If (Shift And vbAltMask) > 0 And KeyCode = vbKeyM Then
        KeyCode = 0
'        fGrid1.MousePointer = flexHourglass
'        Set BText = m_ControlArray(fGrid1.Col)
'        If BText.BoxType = 5 And BText.MasterType <> 0 Then
'            ModifyMasterByName BText.MasterType, GetGridText(fGrid1.Row, fGrid1.Col)
'        End If
'        Set BText = Nothing
'        fGrid1.SetFocus
'        fGrid1.MousePointer = flexDefault
    End If
    
    m_OldRowForKey = fGrid1.Row
    m_OldColForKey = fGrid1.Col
    
    RaiseEvent KeyDown(KeyCode, Shift)
    
End Sub
Private Sub fGrid1_KeyPress(KeyAscii As Integer)
    Dim KeyChar As String
    
    If KeyAscii <> vbKeyBack Then
        If KeyAscii <> vbKeyReturn Then
            ActivateDataEntry
        Else
            ValidCol = True
            RaiseEvent ValidateCol(fGrid1.Row, fGrid1.Col)
            
            If ValidCol Then
            
                RaiseEvent MyColEntryDone(fGrid1.Row, fGrid1.Col)
                
                If fGrid1.Col < fGrid1.Cols - 1 Then
                    fGrid1.Col = fGrid1.Col + 1
                    m_OldColForKey = fGrid1.Col
                    RowColChangedByCode
                Else
                    If fGrid1.Row < fGrid1.Rows - 1 Then
                        fGrid1.Row = fGrid1.Row + 1
                        fGrid1.Col = fGrid1.FixedCols
                        m_OldRowForKey = fGrid1.Row
                        m_OldColForKey = fGrid1.Col
                        RowColChangedByCode
                    End If
                End If
                
                If Not fGrid1.RowIsVisible(fGrid1.Row) Then
                    fGrid1.TopRow = fGrid1.TopRow + 1
                End If
            Else
                ActivateDataEntry
                'If ValidRow Then
                    'SendKeys Chr(KeyAscii)
                'End If
            End If
        End If
    Else
        SendKeys "+{TAB}"
    End If
    
    If KeyAscii <> vbKeyReturn And KeyAscii <> vbKeyBack Then
        If ValidRow And CanEditCol Then
            KeyChar = Chr(KeyAscii)
            Select Case KeyChar
                Case "(", ")", "+", "~", "%", "^"
                    SendKeys "{" & KeyChar & "}"
                Case Else
                    SendKeys KeyChar
            End Select
        End If
    End If
    
    RaiseEvent KeyPress(KeyAscii)
    
End Sub
Private Sub fGrid1_LostFocus()
    Dim i As Integer
    Dim bFound As Boolean
    
    RaiseEvent MyLostFocus
    
    bFound = False
    
    For i = 1 To m_ControlArray.Count
        If UserControl.Parent.ActiveControl.hWnd = m_ControlArray(i).hWnd Then
            bFound = True
            Exit For
        End If
    Next
    
    If Not bFound Then
        m_OldRowNo = -1
        DisableAllControls
        RaiseEvent MyGridLeave
    End If
    
End Sub
Public Property Get hWnd() As Long
    hWnd = fGrid1.hWnd
End Property
Private Sub fGrid1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    If Button = vbRightButton And fGrid1.MouseCol < fGrid1.FixedCols And fGrid1.MouseRow >= fGrid1.FixedRows Then
        
        fGrid1.SetFocus
        fGrid1.Row = fGrid1.MouseRow
        
        RowColChangedByCode
        
        m_RowDeleteInsert = fGrid1.MouseRow
            
        mnuDelete.Caption = "Delete Row ( No. - " & CStr(fGrid1.MouseRow) & " )"
        mnuInsert.Caption = "Insert Row ( No. - " & CStr(fGrid1.MouseRow) & " )"
        
        PopupMenu mnuGrid
        
    End If
    
End Sub
Private Sub fGrid1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If fGrid1.MouseCol < fGrid1.FixedCols And fGrid1.MouseRow >= fGrid1.FixedRows Then
        fGrid1.MousePointer = flexCustom
    Else
        fGrid1.MousePointer = flexDefault
    End If
    
End Sub
Private Sub fGrid1_RowColChange()
    RaiseEvent RowColChange
    
    If fGrid1.Row <> m_OldRowNo Then
        RaiseEvent MyRowChanged(fGrid1.Row, m_OldRowNo)
        m_OldRowNo = fGrid1.Row
    End If
    
End Sub
Public Sub RowColChangedByCode()
    Call fGrid1_RowColChange
End Sub
Private Sub fGrid1_Scroll()
    Dim i As Integer
    
    DisableAllControls
    RaiseEvent Scroll
    
End Sub
Private Sub mnuDelete_Click()
    Dim strError As String
    
    If m_CanBeChanged Then
        m_CanDeleteRow = True
        RaiseEvent MyCanDeleteRow(m_RowDeleteInsert, strError)
        DoEvents
        
        If m_CanDeleteRow Then
            DeleteRow m_RowDeleteInsert
        Else
            ShowSorryMsg strError, "Can Not Delete Row"
        End If
    Else
        ShowCantChangeMsg m_CantChangeMsg
    End If
    
End Sub
Private Sub mnuInsert_Click()
    Dim strError As String
    
    If m_CanBeChanged Then
        m_CanInsertRow = True
        RaiseEvent MyCanInsertRow(m_RowDeleteInsert, strError)
        DoEvents
        
        If m_CanInsertRow Then
            InsertRow m_RowDeleteInsert
        Else
            ShowSorryMsg strError, "Can Not Insert Row"
        End If
    Else
        ShowCantChangeMsg m_CantChangeMsg
    End If
    
End Sub

Private Sub UserControl_Initialize()
    m_OldRowNo = -1
    m_OldRowForKey = -1
    m_OldColForKey = -1
    m_CanBeChanged = True
    m_CantChangeMsg = ""
End Sub

Private Sub UserControl_Resize()
    fGrid1.Move 0, 0, ScaleWidth, ScaleHeight
End Sub
Public Sub UpDateControlArray(p_ControlArray As Collection)
    Set m_ControlArray = p_ControlArray
End Sub

Public Property Get grid() As MSHFlexGrid
    Set grid = fGrid1
End Property

Private Sub UserControl_Terminate()
    Set m_ControlArray = Nothing
End Sub

Public Sub DeleteRow(RowNo As Integer)
    Dim i, j As Integer
    Dim Offset As Integer
    Dim FixedCols As Integer
    
    FixedCols = fGrid1.FixedCols
    
    If RowNo >= fGrid1.FixedRows And RowNo < fGrid1.Rows Then
                
        For i = RowNo To fGrid1.Rows - 1
            
            Offset = i * fGrid1.Cols
            
            For j = FixedCols To fGrid1.Cols - 1
                If i < fGrid1.Rows - 1 Then
                    'SetGridText i, j, fGrid1.TextArray(Offset + j + fGrid1.Cols)
                    fGrid1.TextArray(Offset + j) = fGrid1.TextArray(Offset + j + fGrid1.Cols)
                Else
                    'SetGridText i, j, ""
                    fGrid1.TextArray(Offset + j) = ""
                End If
            Next
        Next
    End If
    
    RaiseEvent MyRowDeleted(RowNo)
    
End Sub
Public Sub InsertRow(RowNo As Integer)
    Dim i, j As Integer
    Dim Offset As Integer
    Dim FixedCols As Integer
    
    FixedCols = fGrid1.FixedCols
    
    If RowNo >= fGrid1.FixedRows And RowNo < fGrid1.Rows Then
                
        For i = fGrid1.Rows - 1 To RowNo Step -1
            Offset = i * fGrid1.Cols
            
            For j = FixedCols To fGrid1.Cols - 1
                If i <> RowNo Then
                    'SetGridText i, j, fGrid1.TextArray(Offset + j - fGrid1.Cols)
                    fGrid1.TextArray(Offset + j) = fGrid1.TextArray(Offset + j - fGrid1.Cols)
                Else
                    'SetGridText i, j, ""
                    fGrid1.TextArray(Offset + j) = ""
                End If
            Next
        Next
        
        
            
    End If
    
    RaiseEvent MyRowInserted(RowNo)
    
End Sub
Public Sub SetGridText(ByVal p_Row As Integer, ByVal p_Col As Integer, ByVal p_Contents As String)
    Dim TextIndex As Integer
    
    TextIndex = (p_Row * fGrid1.Cols) + p_Col
    fGrid1.TextArray(TextIndex) = p_Contents
    
    RaiseEvent MyGridTextChanged(p_Row, p_Col, p_Contents)
    
End Sub
Public Function GetGridText(p_Row As Integer, p_Col As Integer) As String
    Dim TextIndex As Integer
    
    TextIndex = (p_Row * fGrid1.Cols) + p_Col
    GetGridText = fGrid1.TextArray(TextIndex)
    
End Function
Public Sub ColEntryDone(p_Row As Integer, p_Col As Integer)
    RaiseEvent MyColEntryDone(p_Row, p_Col)
End Sub
Public Sub FocusShiftingToNewControl(p_NewHwnd As Long)
    Dim i As Integer
    Dim bFound As Boolean
    
    bFound = False
    
    If p_NewHwnd = hWnd Then
        bFound = True
    Else
        For i = 1 To m_ControlArray.Count
            If p_NewHwnd = m_ControlArray(i).hWnd Then
                bFound = True
                Exit For
            End If
        Next
    End If

    If Not bFound Then
        RaiseEvent MyRowChanged(-1, m_OldRowNo)
        m_OldRowNo = -1
        DisableAllControls
        RaiseEvent MyGridLeave
    End If
    

End Sub
Public Property Get CanBeChanged() As Boolean
    CanBeChanged = m_CanBeChanged
End Property

Public Property Let CanBeChanged(ByVal New_CanBeChanged As Boolean)
    m_CanBeChanged = New_CanBeChanged
    PropertyChanged "CanBeChanged"
End Property

Public Property Get CanDeleteRow() As Boolean
    CanDeleteRow = m_CanDeleteRow
End Property

Public Property Let CanDeleteRow(ByVal New_CanDeleteRow As Boolean)
    m_CanDeleteRow = New_CanDeleteRow
    PropertyChanged "CanDeleteRow"
End Property
Public Property Get CanEditCol() As Boolean
    CanEditCol = m_CanEditCol
End Property

Public Property Let CanEditCol(ByVal New_CanEditCol As Boolean)
    m_CanEditCol = New_CanEditCol
    PropertyChanged "CanEditCol"
End Property

Public Property Get CanInsertRow() As Boolean
    CanInsertRow = m_CanInsertRow
End Property

Public Property Let CanInsertRow(ByVal New_CanInsertRow As Boolean)
    m_CanInsertRow = New_CanInsertRow
    PropertyChanged "CanInsertRow"
End Property

Public Property Get CantChangeMsg() As String
    CantChangeMsg = m_CantChangeMsg
End Property

Public Property Let CantChangeMsg(ByVal New_CantChangeMsg As String)
    m_CantChangeMsg = New_CantChangeMsg
    PropertyChanged "CantChangeMsg"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=fGrid1,fGrid1,-1,Enabled
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Returns/sets a value that determines whether an object can respond to user-generated events."
    Enabled = fGrid1.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    fGrid1.Enabled() = New_Enabled
    PropertyChanged "Enabled"
End Property

'Load property values from storage
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    fGrid1.Enabled = PropBag.ReadProperty("Enabled", True)
End Sub

'Write property values to storage
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    Call PropBag.WriteProperty("Enabled", fGrid1.Enabled, True)
End Sub

