VERSION 5.00
Begin VB.UserControl BusyText 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   ClientHeight    =   225
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2535
   ScaleHeight     =   225
   ScaleWidth      =   2535
   Begin VB.TextBox Text1 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      Height          =   230
      Left            =   0
      MouseIcon       =   "BusyText.ctx":0000
      TabIndex        =   0
      Top             =   0
      Width           =   2535
   End
   Begin VB.Menu mnuBusyTextBox 
      Caption         =   ""
      Begin VB.Menu mnuAddNew 
         Caption         =   "Add New "
      End
      Begin VB.Menu mnuBlank1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuModify 
         Caption         =   "Modify"
      End
   End
End
Attribute VB_Name = "BusyText"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Different type of boxes are as follows
'   0   -   Text
'   1   -   Numeric
'   2   -   Date
'   3   -   Choice ( among the list of characters supplied )
'   4   -   Pick from the list box
'   5   -   Pick from the database
'   6   -   Yes/No
'   7   -   D/C     Used to get the input of Dr & Cr


Option Explicit

Const m_Def_TextTypeAfterExit = 4
Const m_Def_ExitFromEnter = True
Const m_Def_ExitFromBS = True
Const m_Def_ExitFromDownArrowKey = True
Const m_Def_ExitFromUpArrowKey = True
Const m_Def_MaxChar = 40
Const m_Def_MaxDecimal = 3
Const m_Def_BoxType = 0
Const m_Def_Choice = ""
Const m_Def_UseInGrid = 0


Private m_ToMakeCharCapital As Boolean

Private m_AllowNegative As Boolean
Private m_nAttribute As Integer
Private m_bShowListAtStartup As Boolean
Private m_ProportionalFont As Boolean
Private m_bAutoResizeList As Boolean
Private m_nMasterType As Integer

Private m_CantChangeMsg As String
Private m_CanBeChanged As Boolean

Private m_Listbox1 As ListBox
Private m_Browse As CBrowse
Private m_Grid As MSHFlexGrid
Private m_BusyGrid As BusyGrid

Private m_ColNo As Integer
Private m_RowNo As Integer

Private m_nPosition As Integer

Private m_ValidEntry As Boolean

Private m_InhouseValid As Boolean

Private m_TabOrder As Integer

Dim m_TextTypeAfterExit As Integer
Dim m_BackColorWhenNotSelected As Long
Dim m_BackColorWhenSelected As Long
Dim m_ForeColorWhenNotSelected As Long
Dim m_ForeColorWhenSelected As Long
Dim m_ForeColorWhenCantChange As Long
Dim m_BackColorWhenCantChange As Long
Dim m_ExitFromEnter As Boolean
Dim m_ExitFromBS As Boolean
Dim m_ExitFromDownArrowKey As Boolean
Dim m_ExitFromUpArrowKey As Boolean
Dim m_MaxChar As Integer
Dim m_MaxDecimal As Integer
Dim m_ClearText As Boolean
Dim m_OldVal As String
Dim m_BoxType As Integer        ' 0 - Alphanumeric : 1 - Numeric : 2 - Date : 3 - Choice : 4 - List Box : 5 - Db List Box
Dim m_DoubleVal As Double
Dim m_DCVal As Integer
Dim m_BoolVal As Boolean
Dim m_DateVal As Date
Dim m_Choice As String
Dim m_UseInGrid As Integer     ' Indicates whether this control will be used in a grid or not


'Event Declarations:
Event Change() 'MappingInfo=Text1,Text1,-1,Change
Attribute Change.VB_Description = "Occurs when the contents of a control have changed."
Event EntryDone()
Event ValidateEntry()
'Event ShowInvalidMsg()
Event MyGotFocus()
Event MyLostFocus()
Event Click() 'MappingInfo=Text1,Text1,-1,Click
Attribute Click.VB_Description = "Occurs when the user presses and then releases a mouse button over an object."
Event DblClick() 'MappingInfo=Text1,Text1,-1,DblClick
Attribute DblClick.VB_Description = "Occurs when the user presses and releases a mouse button and then presses and releases it again over an object."
Event KeyDown(KeyCode As Integer, Shift As Integer) 'MappingInfo=Text1,Text1,-1,KeyDown
Attribute KeyDown.VB_Description = "Occurs when the user presses a key while an object has the focus."
Event KeyPress(KeyAscii As Integer) 'MappingInfo=Text1,Text1,-1,KeyPress
Attribute KeyPress.VB_Description = "Occurs when the user presses and releases an ANSI key."
Event KeyUp(KeyCode As Integer, Shift As Integer) 'MappingInfo=Text1,Text1,-1,KeyUp
Attribute KeyUp.VB_Description = "Occurs when the user releases a key while an object has the focus."
Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=Text1,Text1,-1,MouseDown
Attribute MouseDown.VB_Description = "Occurs when the user presses the mouse button while an object has the focus."
Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=Text1,Text1,-1,MouseMove
Attribute MouseMove.VB_Description = "Occurs when the user moves the mouse."
Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=Text1,Text1,-1,MouseUp
Attribute MouseUp.VB_Description = "Occurs when the user releases the mouse button while an object has the focus."

Public Function SetAttribute(p_nAttribute As Integer)
    m_nAttribute = p_nAttribute
End Function
Public Function GetAttribute() As Integer
    GetAttribute = m_nAttribute
End Function
Public Property Let ShowListAtStartup(p_bShowListAtStartup As Boolean)
    m_bShowListAtStartup = p_bShowListAtStartup
End Property
Public Property Let ProportionalFont(p_ProportionalFont As Boolean)
    m_ProportionalFont = p_ProportionalFont
End Property
Public Property Get ProportionalFont() As Boolean
    ProportionalFont = m_ProportionalFont
End Property

Public Property Let AutoResizeList(p_bAutoResizeList As Boolean)
    m_bAutoResizeList = p_bAutoResizeList
End Property

Public Property Let MasterType(p_nMasterType As Integer)
    m_nMasterType = p_nMasterType
End Property

Public Property Get MasterType() As Integer
    MasterType = m_nMasterType
End Property

Public Sub UpdateBusyGrid(p_BusyGrid As BusyGrid)
    Set m_BusyGrid = p_BusyGrid
    Set m_Grid = m_BusyGrid.grid
End Sub
Public Sub ForceText(p_Text As String)
    Dim CantChangeStatus As Boolean
    
    CantChangeStatus = m_CanBeChanged
    
    m_CanBeChanged = True
    
    Text1.Text = p_Text
    
    m_CanBeChanged = CantChangeStatus
    
End Sub
Public Sub UpdateColNo(p_ColNo As Integer)
    m_ColNo = p_ColNo
End Sub
Private Sub UpdateList(sText As String)

    Dim colItems As Collection
    Dim i As Integer
    
    Set colItems = m_Browse.GetList(sText)
        
    m_Listbox1.Clear
    
    For i = 1 To colItems.Count
        m_Listbox1.AddItem (colItems.Item(i))
    Next
           
    If m_Listbox1.ListCount > 0 Then
        m_Listbox1.ListIndex = 0
    End If
    
End Sub

Private Sub CheckValidEntry()

    m_ValidEntry = True
        
    If m_CanBeChanged Then
        If m_BoxType = 4 Then
            If FindItemInList(Text1.Text, True) < 0 Then
                m_ValidEntry = False
                ShowList
            End If
        ElseIf m_BoxType = 5 Then
            If FindItemInList(Text1.Text, True) < 0 Then
                m_ValidEntry = False
            End If
            
            If m_ValidEntry = False Then
                m_ValidEntry = m_Browse.SeekEntry(Text1.Text)
            End If
            
            If m_ValidEntry = False Then
                ShowList
            End If
        End If
    End If
    
End Sub
Private Function FindItemInList(ByVal sText As String, bFullCompare As Boolean) As Integer
    Dim i As Integer
    Dim sTemp As String
    Dim nLen As Integer
    
    Dim bRetVal As Integer
    
    bRetVal = -1
    nLen = Len(sText)
    
    If Trim(sText) <> "" Then
       
        For i = 0 To m_Listbox1.ListCount - 1
                        
            If bFullCompare = True Then
                'sTemp = m_Listbox1.List(i)
                sTemp = Left$(m_Listbox1.List(i), m_MaxChar)
            Else
                sTemp = Left$(m_Listbox1.List(i), nLen)
            End If
            
            If CompareStr(sTemp, sText) = 0 Then
                bRetVal = i
                
                Exit For
            End If
        
        Next
        
    End If
    
    FindItemInList = bRetVal
    
End Function

'Private Sub mnuAddNew_Click()
'
'    If m_BoxType = 5 And m_nMasterType <> 0 Then
'        AddNewMaster
'    End If
'
'End Sub

'Private Sub mnuModify_Click()
'    If m_BoxType = 5 And m_nMasterType <> 0 Then
'        ModifyMasterByCode m_nMasterType, g_MS.MasterName2Code(Text1.Text, m_nMasterType)
'    End If
'End Sub

Private Sub UserControl_Resize()
    Text1.Move 0, 0, ScaleWidth, ScaleHeight
End Sub
Private Function MakeFirstLetterCapitalForEachWord(ByVal p_Text As String) As String
    Dim retStr As String
    
    retStr = p_Text
    
    If Trim$(retStr) <> "" Then
        
        retStr = UCase$(Left$(p_Text, 1)) + Right$(p_Text, Len(p_Text) - 1)
        
        m_nPosition = 1
    
        Do
            If Mid$(retStr, m_nPosition, 1) = " " Then
                retStr = Mid$(retStr, 1, m_nPosition) + UCase$(Mid$(retStr, m_nPosition + 1, 1)) + Mid$(retStr, m_nPosition + 2, Len(retStr) - m_nPosition)
            End If
            
            m_nPosition = m_nPosition + 1
            
        Loop While m_nPosition - 1 <> Len(retStr)
        
    End If
    
    MakeFirstLetterCapitalForEachWord = retStr
    
End Function

Public Sub UpdateTextBoxVals()
    Dim TempDate As Date
    
    If Len(Trim$(Text1.Text)) > m_MaxChar Then
        Text1.Text = Left$(Text1.Text, m_MaxChar)
    End If
    
    If BoxType = 0 Then
                           
        If Trim(Text1.Text) <> "" And m_ToMakeCharCapital Then
                    
            Select Case m_TextTypeAfterExit
                
                Case 2
                    Text1.Text = UCase$(Text1.Text)
                Case 3
                    If Trim(Text1.Text) <> "" Then
                        Text1.Text = UCase$(Left$(Text1.Text, 1)) + Right$(Text1.Text, Len(Text1.Text) - 1)
                    End If
                Case 4
                    Text1.Text = MakeFirstLetterCapitalForEachWord(Text1.Text)
            End Select
        End If
    ElseIf BoxType = 1 Then
        'Call CheckDecimalPlacesInText
        
        DoubleVal = Text2Dbl(Text1.Text)
        
    ElseIf BoxType = 2 Then
        
        TempDate = CheckDate(Text1.Text, m_DateVal)
        
        If TempDate = 0 Then
            'FieldInvalidMsg "This date is invalid.", "Invalid Date"
            Beep
            m_InhouseValid = False
            Text1.Text = m_OldVal
            m_ClearText = True
        Else
            m_InhouseValid = True
            DateVal = TempDate
        End If
        
    ElseIf BoxType = 3 Then
        Call CheckChoice
        
        If m_TextTypeAfterExit > 1 Then
             Text1.Text = UCase$(Text1.Text)
        End If
    ElseIf (BoxType = 4 Or BoxType = 5) Then
        If m_Listbox1.ListIndex >= 0 And m_Listbox1.Visible = True Then
            If BoxType = 4 Then
                Text1.Text = Left$(m_Listbox1.List(m_Listbox1.ListIndex), m_MaxChar)
            Else
                Text1.Text = Left$(m_Browse.GetActualValue(m_Listbox1.List(m_Listbox1.ListIndex)), m_MaxChar)
            End If
        End If
        m_Listbox1.Visible = False
    ElseIf BoxType = 6 Then
        If CompareStr(Text1.Text, "Y") = 0 Then
            m_BoolVal = True
        Else
            m_BoolVal = False
        End If
    ElseIf BoxType = 7 Then
        If CompareStr(Text1.Text, "D") = 0 Then
            m_DCVal = DEBIT
        Else
            m_DCVal = CREDIT
        End If
    End If
    
    
End Sub
Public Function Changed() As Boolean
    If Text1.Text <> m_OldVal Then
        Changed = True
    Else
        Changed = False
    End If
End Function

Private Sub ShowList()
    Dim nLen As Integer
    Dim i As Integer
    Dim sTemp As String
    Dim bFound As Integer
            
    bFound = FindItemInList(Text1.Text, False)
    
    If bFound < 0 And m_BoxType = 5 Then
        UpdateList Text1.Text
        bFound = FindItemInList(Text1.Text, False)
    End If
       
    If bFound < 0 Then
        Text1.Text = ""
        If m_Listbox1.ListCount > 0 Then
            m_Listbox1.ListIndex = 0
        End If
    Else
        m_Listbox1.ListIndex = bFound
    End If
    
    m_Listbox1.Visible = True
    
End Sub
Private Function ValidBrowseKey(key As Integer) As Boolean
    Dim sText As String
    Dim nLen As Integer
    Dim i As Integer
    Dim sTemp As String
    Dim bFound As Boolean
           
    bFound = ValidListKey(key)
    
    If bFound = False Then
        
        sText = Text1.Text + Chr(key)
        bFound = m_Browse.SoftSeek(sText)
        
        If bFound = True Then
            UpdateList (sText)
        End If
        
    End If
    
    
    ValidBrowseKey = bFound
    
End Function
Private Function ValidListKey(key As Integer) As Boolean
    Dim sText As String
    Dim nLen As Integer
    Dim i As Integer
    Dim sTemp As String
    Dim bFound As Boolean
    
    bFound = False
    
    sText = Text1.Text + Chr(key)
        
    nLen = Len(sText)
    
    For i = 0 To m_Listbox1.ListCount - 1
                        
        sTemp = Left$(m_Listbox1.List(i), nLen)
        
        If CompareStr(sTemp, sText) = 0 Then
            m_Listbox1.ListIndex = i
            bFound = True
            Exit For
        End If
        
    Next
        
    
    
    ValidListKey = bFound
    
End Function

Private Function ValidChoiceKey(key As Integer) As Boolean

    Dim bRetVal As Boolean
    Dim sStr As String
    
    sStr = Chr(key)
    
    If InStr(m_Choice, sStr) > 0 Then
        bRetVal = True
    Else
        bRetVal = False
    End If
    
    ValidChoiceKey = bRetVal
    
End Function

Private Function ValidNumKey(key As Integer) As Boolean
    
    ' 46 indicated decimal
    ' 45 indicates '-'
    
    Dim bRetVal As Boolean
    
    bRetVal = True
        
    If (key < vbKey0 Or key > vbKey9) And key <> 46 And key <> 45 Then
        bRetVal = False
    Else
        If key = 46 And (InStr(Text1.Text, ".") > 0 Or m_MaxDecimal = 0) Then
            bRetVal = False
        End If
        
        If key = 45 And (InStr(Text1.Text, "-") > 0 Or Not m_AllowNegative Or Text1.SelStart > 0) Then
            bRetVal = False
        End If
    End If
    
    
    ValidNumKey = bRetVal
    
End Function

Private Function ValidDateKey(key As Integer) As Boolean
    Dim bRetVal As Boolean
    
    bRetVal = True
    
    If (key < vbKey0 Or key > vbKey9) And (key <> 45 And key <> 46 And key <> 47) Then
        bRetVal = False
    End If
    
    
    ValidDateKey = bRetVal
    
End Function
Private Sub Text1_GotFocus()
    Dim MaxElmtForList As Integer
    
    If Trim$(Text1.Text) = "" Then
        m_ToMakeCharCapital = True
    Else
        m_ToMakeCharCapital = False
    End If
    
    If m_UseInGrid = 1 Then
        m_RowNo = m_Grid.Row
    End If
    
    m_OldVal = Text1.Text
    
    If m_CanBeChanged Then
        Text1.BackColor = m_BackColorWhenSelected
        Text1.ForeColor = m_ForeColorWhenSelected
    Else
        Text1.BackColor = m_BackColorWhenCantChange
        Text1.ForeColor = m_ForeColorWhenCantChange
    End If
    
    m_ClearText = True
    
    Text1.SelStart = 0
    
    'If BoxType = 1 And m_UseInGrid = 0 Then     '   Numeric Box
    If BoxType = 1 Then     '   Numeric Box
        If m_CanBeChanged Then
            Text1.Text = FormatNum(DoubleVal, m_MaxChar, m_MaxDecimal, False)
        End If
        
    End If
    
    If m_bAutoResizeList And (m_BoxType = 5 Or m_BoxType = 4) Then
        m_Listbox1.Width = Text1.Width
        If m_BoxType = 5 Then
            m_Listbox1.Height = m_Browse.GetMaxElmt * 250
        Else
            If m_Listbox1.ListCount < 3 Then
                MaxElmtForList = 3
            ElseIf m_Listbox1.ListCount > 6 Then
                MaxElmtForList = 6
            Else
                MaxElmtForList = m_Listbox1.ListCount
            End If
            m_Listbox1.Height = MaxElmtForList * 250
        End If
    End If
    
    RaiseEvent MyGotFocus
    
    
    If (BoxType = 4 Or BoxType = 5) And m_bShowListAtStartup = True Then
        Call ShowList
    End If
    
End Sub
Private Sub SetFocusToGrid()
    UpdateTextBoxVals
    m_BusyGrid.SetGridText m_RowNo, m_ColNo + m_Grid.FixedCols, Text1.Text
    'm_Grid.TextArray((m_RowNo * m_Grid.Cols) + m_ColNo + m_Grid.FixedCols) = Text1.Text
    m_Grid.SetFocus
End Sub
Private Sub SetFocusToGridAndIncrementCol()
    UpdateTextBoxVals
    m_BusyGrid.SetGridText m_RowNo, m_ColNo + m_Grid.FixedCols, Text1.Text
    'm_Grid.TextArray((m_RowNo * m_Grid.Cols) + m_ColNo + m_Grid.FixedCols) = Text1.Text
    m_Grid.SetFocus
    m_BusyGrid.ColEntryDone m_Grid.Row, m_Grid.Col
    
    If m_Grid.Col < m_Grid.Cols - 1 Then
        m_Grid.Col = m_Grid.Col + 1
        m_BusyGrid.RowColChangedByCode
    Else
        If m_Grid.Row < m_Grid.Rows - 1 Then
            m_Grid.Col = m_Grid.FixedCols
            m_Grid.Row = m_Grid.Row + 1
            m_BusyGrid.RowColChangedByCode
        End If
    End If
End Sub
Private Sub SetFocusToGridAndDecrementCol()
    UpdateTextBoxVals
    m_BusyGrid.SetGridText m_RowNo, m_ColNo + m_Grid.FixedCols, Text1.Text
    
    'm_Grid.TextArray((m_RowNo * m_Grid.Cols) + m_ColNo + m_Grid.FixedCols) = Text1.Text

    If m_Grid.Col > m_Grid.FixedCols Then
        m_Grid.SetFocus
        m_Grid.Col = m_Grid.Col - 1
        m_BusyGrid.RowColChangedByCode
    Else
        If m_Grid.Row > m_Grid.FixedRows Then
            m_Grid.SetFocus
            m_Grid.Row = m_Grid.Row - 1
            m_BusyGrid.RowColChangedByCode
        Else
            SendKeys "+{TAB}", True '(vbKeyTab)
        End If
    End If
End Sub
Private Sub ProcessKeyForYesNo(KeyCode As Integer)
    Dim TempStr As String
    
    TempStr = Chr(KeyCode)
    
    If TempStr = "N" Or TempStr = "n" Then
        Text1.Text = "N"
    ElseIf TempStr = "Y" Or TempStr = "y" Then
        Text1.Text = "Y"
    ElseIf KeyCode = vbKeySpace Then
        If Text1.Text = "Y" Then
            Text1.Text = "N"
        Else
            Text1.Text = "Y"
        End If
    End If
        
    Text1.SelStart = 0
    
End Sub
Private Sub ProcessKeyForDrCr(KeyCode As Integer)
    Dim TempStr As String
    
    TempStr = Chr(KeyCode)
    
    If TempStr = "D" Or TempStr = "d" Then
        Text1.Text = "D"
    ElseIf TempStr = "C" Or TempStr = "c" Then
        Text1.Text = "C"
    ElseIf KeyCode = vbKeySpace Then
        If Text1.Text = "C" Then
            Text1.Text = "D"
        Else
            Text1.Text = "C"
        End If
    End If
        
    Text1.SelStart = 0
    
End Sub
Private Sub Text1_KeyPress(KeyAscii As Integer)
    Dim ABC As Integer
    
    If KeyAscii = 10 Then       '   Ctrl + Enter
        KeyAscii = 0
    End If
    
    If m_CanBeChanged Or KeyAscii = vbKeyReturn Or (KeyAscii = vbKeyBack And Text1.SelStart = 0) Then
        If m_BoxType = 6 Then
            ProcessKeyForYesNo KeyAscii
        End If
        
        If m_BoxType = 7 Then
            ProcessKeyForDrCr KeyAscii
        End If
        
        If KeyAscii <> vbKeyReturn And KeyAscii <> vbKeyBack And m_ClearText = True And m_BoxType <> 6 And m_BoxType <> 7 Then
            Text1.Text = ""
            m_ToMakeCharCapital = True
            m_ClearText = False
        End If

        If (m_BoxType = 4 Or m_BoxType = 5) And KeyAscii <> vbKeyReturn And KeyAscii <> vbKeyBack Then
            If m_Listbox1.Visible = False Then
                Call ShowList
            End If
        End If
        
        Select Case KeyAscii
            Case vbKeyEscape
                If m_BoxType = 4 Or m_BoxType = 5 Then
                    If m_Listbox1.Visible = True Then
                        m_Listbox1.Visible = False
                        KeyAscii = 0
                    End If
                End If
                
            Case vbKeyReturn
                    
                If m_ExitFromEnter = True Then
                
                    KeyAscii = 0
                    
                    If (m_BoxType = 4 Or m_BoxType = 5) Then
                        If m_Listbox1.Visible = True And m_Listbox1.ListIndex >= 0 Then
                            Text1.Text = Left$(m_Listbox1.List(m_Listbox1.ListIndex), m_MaxChar)
                        End If
                    End If
                    
                    Call CheckValidEntry
                    
                    If m_ValidEntry = True Then
                        If m_UseInGrid = 0 Then
                            RaiseEvent EntryDone
                            SendKeys "{TAB}", True '(vbKeyTab)
                        Else
                            UpdateTextBoxVals
                            RaiseEvent ValidateEntry
                            Text1.SetFocus
                            If m_ValidEntry = True Then
                                SetFocusToGridAndIncrementCol
                            End If
                        End If
                    End If

                End If
                
            Case vbKeyBack
                ABC = Text1.SelStart
                
                If Text1.SelStart = 0 Then
                    KeyAscii = 0
                    If m_BoxType = 4 Or m_BoxType = 5 Then
                        If m_Listbox1.Visible = True And Trim(Text1.Text) = "" Then
                            m_Listbox1.ListIndex = -1
                        End If
                    End If
                                    
                    If m_UseInGrid = 0 Then
                        If m_ExitFromBS Then
                            SendKeys "+{TAB}", True '(vbKeyTab)
                        Else
                            Beep
                        End If
                    Else
                        SetFocusToGridAndDecrementCol
                    End If
                    
                Else
                    If (m_BoxType = 4 Or m_BoxType = 5) Then
                        If m_Listbox1.Visible = True Then
                            
                            Text1.Text = Left$(Text1.Text, Text1.SelStart - 1)
                            Text1.SelStart = Len(Text1.Text)
                            KeyAscii = 0
                            
                            ShowList
                        Else
                            ShowList
                        End If
                    ElseIf m_BoxType = 6 Or m_BoxType = 7 Then
                        KeyAscii = 0
                    End If
                End If
                
            Case Else
                If m_BoxType <> 6 And m_BoxType <> 7 Then
                    If Len(Text1.Text) < m_MaxChar Then
                        m_nPosition = Text1.SelStart
                    Else
                        If KeyAscii = vbKeyBack Then
                            Text1.SelText = ""
                        Else
                            KeyAscii = 0
                        End If
                    End If
                End If
                   
                If KeyAscii > 0 Then
                    If BoxType = 1 Then  ' Numeric Box
                        If ValidNumKey(KeyAscii) = False Then
                            KeyAscii = 0
                        End If
                    ElseIf BoxType = 2 Then ' Date Box
                        If ValidDateKey(KeyAscii) = False Then
                            KeyAscii = 0
                        End If
                    ElseIf BoxType = 3 Then
                        If ValidChoiceKey(KeyAscii) = False Then
                            KeyAscii = 0
                        End If
                    ElseIf BoxType = 4 Then
                        If ValidListKey(KeyAscii) = False Then
                            KeyAscii = 0
                        End If
                    ElseIf BoxType = 5 Then
                        If ValidBrowseKey(KeyAscii) = False Then
                            KeyAscii = 0
                        End If
                    ElseIf BoxType = 6 Or BoxType = 7 Then
                        KeyAscii = 0
                    End If
                    
                    If KeyAscii = 0 And (m_BoxType <> 6 And m_BoxType <> 7) Then
                        Beep
                    End If
                    
                End If
                    
           End Select
           
           
        RaiseEvent KeyPress(KeyAscii)
    Else
        KeyAscii = 0
        ShowCantChangeMsg m_CantChangeMsg
        'MsgBox m_CantChangeMsg, vbOKOnly, "Can't Change"
    End If
    
    If m_BoxType = 6 Or m_BoxType = 7 Then
        Text1.SelStart = 0
    End If
    
End Sub
'Private Sub AddNewMaster()
'    Dim strPrevText As String
'    Dim strLastAdded As String
'    Dim bListState As Boolean
'
'    strPrevText = Text1.Text
'    bListState = m_Listbox1.Visible
'
'    strLastAdded = AddMaster(m_nMasterType, ADD_ONE)
'
'    If m_UseInGrid = 1 Then
'        Text1.SetFocus
'    End If
'
'    If Trim$(strLastAdded) <> "" Then
'        Text1.Text = strLastAdded
'        If m_UseInGrid = 0 Then
'            SendKeys "{TAB}", True '(vbKeyTab)
'        Else
'            SetFocusToGridAndIncrementCol
'        End If
'    Else
'        Text1.Text = strPrevText
'        'Text1.SelStart = Len(Text1.Text)
'        m_Listbox1.Visible = bListState
'    End If
'
'End Sub

Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)
    Dim sTemp As String
    Dim colItems As Collection
    Dim i As Integer
    Dim AltDown As Boolean
    Dim MastCode As Long
    Dim CalVal As Double        ' Value returned from calculator
    
    If KeyCode = vbKeyLeft Or KeyCode = vbKeyRight Or KeyCode = vbKeyHome Or KeyCode = vbKeyEnd Or KeyCode = vbKeyDelete Then
        m_ClearText = False
    End If
                                          
    If (Shift And vbCtrlMask) > 0 Then
        m_ClearText = False
    End If
    
    If (Shift And vbCtrlMask) > 0 And m_BoxType = 0 And m_CanBeChanged Then
        If KeyCode = vbKeyU Then
            KeyCode = 0
            If Text1.SelLength > 0 Then
                Text1.SelText = UCase$(Text1.SelText)
            Else
                Text1.Text = UCase$(Text1.Text)
            End If
        ElseIf KeyCode = vbKeyL Then
            KeyCode = 0
            If Text1.SelLength > 0 Then
                Text1.SelText = LCase$(Text1.SelText)
            Else
                Text1.Text = LCase$(Text1.Text)
            End If
        ElseIf KeyCode = vbKeyF Then
            KeyCode = 0
            If Text1.SelLength > 0 Then
                Text1.SelText = MakeFirstLetterCapitalForEachWord(Text1.SelText)
            Else
                Text1.Text = MakeFirstLetterCapitalForEachWord(Text1.Text)
            End If
        End If
    End If
    
    If (Shift And vbCtrlMask) > 0 And KeyCode = vbKeyReturn Then
        KeyCode = 0
        m_ClearText = False
    End If
    
'    If Shift = 0 And KeyCode = vbKeyF10 Then
'        KeyCode = 0
'        If m_UseInGrid = 1 Then
'            SetFocusToGrid
'            SendKeys "{F10}"
'        Else
'            CalVal = ShowCalculator()
'            If CalVal <> 0 And BoxType = 1 And m_CanBeChanged Then
'                DoubleVal = CalVal
'            End If
'        End If
'    End If
    
            
    Select Case KeyCode
                  
        Case vbKeyRight, vbKeyEnd
            If m_BoxType = 6 Or m_BoxType = 7 Then
                KeyCode = 0
            End If
                
        Case vbKeyDelete
            If Not m_CanBeChanged Then
                KeyCode = 0
                ShowCantChangeMsg m_CantChangeMsg
                'MsgBox m_CantChangeMsg, vbOKOnly, "Can't Change"
            Else
                If m_BoxType = 6 Or m_BoxType = 7 Then
                    KeyCode = 0
                End If
            End If
            
        Case vbKeyF3
        
'            If m_BoxType = 5 And m_nMasterType <> 0 Then
'                AddNewMaster
'            End If
                        
        Case vbKeyN
        
'            If m_BoxType = 5 And m_nMasterType <> 0 Then
'                AltDown = (Shift And vbAltMask) > 0
'                If AltDown Then
'                    AddNewMaster
'                End If
'            End If
                        
        Case vbKeyM
        
'            If m_BoxType = 5 And m_nMasterType <> 0 Then
'                AltDown = (Shift And vbAltMask) > 0
'                If AltDown Then
'                    MastCode = g_MS.MasterName2CodeIfExist(Text1.Text, m_nMasterType)
'                    If MastCode <> 0 Then
'                        ModifyMasterByCode m_nMasterType, MastCode
'                    End If
'                End If
'            End If
            
        Case vbKeyUp
                
            If (m_BoxType <> 4 And m_BoxType <> 5) Then
                If m_ExitFromUpArrowKey Then
                    KeyCode = 0
                    
                    If m_UseInGrid = 0 Then
                        SendKeys "+{TAB}", True '(vbKeyTab)
                    Else
                        SetFocusToGridAndDecrementCol

                    End If
                    

                End If
            Else
                If m_Listbox1.Visible = True Then
                    KeyCode = 0
                    
                    If m_BoxType = 5 And m_Listbox1.ListCount > 0 And m_Listbox1.ListIndex = 0 Then
                        sTemp = m_Browse.GetPrev(m_Listbox1.List(0))
                        If Trim(sTemp) <> "" Then
                            If m_Listbox1.ListCount >= m_Browse.GetMaxElmt Then
                                m_Listbox1.RemoveItem m_Listbox1.ListCount - 1
                            End If
                            m_Listbox1.AddItem sTemp, 0
                            
                        End If
                    End If
                        
                    If m_Listbox1.ListIndex > 0 Then
                         m_Listbox1.ListIndex = m_Listbox1.ListIndex - 1
                    End If
                    
                Else
                    If m_ExitFromUpArrowKey Then
                        KeyCode = 0
                        
                        If m_UseInGrid = 0 Then
                            SendKeys "+{TAB}", True '(vbKeyTab)
                        Else
                            SetFocusToGridAndDecrementCol
                        End If
                    End If
                End If
            End If
             
        Case vbKeyDown
            
            If (m_BoxType <> 4 And m_BoxType <> 5) Then
                If m_ExitFromDownArrowKey Then
                
                    Call CheckValidEntry
                
                    If m_ValidEntry = True Then
                        KeyCode = 0
                            
                        If m_UseInGrid = 0 Then
                            RaiseEvent EntryDone
                            SendKeys "{TAB}", True '(vbKeyTab)
                        Else
                            UpdateTextBoxVals
                            RaiseEvent ValidateEntry
                            Text1.SetFocus
                            If m_ValidEntry = True Then
                                SetFocusToGridAndIncrementCol
                            End If
                        End If
                    End If
                End If
            Else
                If m_Listbox1.Visible = True Then
                    KeyCode = 0
                    
                    If m_BoxType = 5 And m_Listbox1.ListCount > 0 And m_Listbox1.ListIndex = m_Listbox1.ListCount - 1 Then
                        sTemp = m_Browse.GetNext(m_Listbox1.List(m_Listbox1.ListCount - 1))
                        If Trim(sTemp) <> "" Then
                            m_Listbox1.RemoveItem 0
                            m_Listbox1.AddItem sTemp, m_Listbox1.ListCount
                        End If
                    End If
                    
                    If m_Listbox1.ListIndex < m_Listbox1.ListCount - 1 Then
                        m_Listbox1.ListIndex = m_Listbox1.ListIndex + 1
                    End If
                Else
                    If m_ExitFromDownArrowKey = True Then
            
                        Call CheckValidEntry
                
                        If m_ValidEntry = True Then
                            
                            KeyCode = 0
                            
                            If m_UseInGrid = 0 Then
                                RaiseEvent EntryDone
                                SendKeys "{TAB}", True '(vbKeyTab)
                            Else
                                UpdateTextBoxVals
                                RaiseEvent ValidateEntry
                                Text1.SetFocus
                                If m_ValidEntry = True Then
                                    SetFocusToGridAndIncrementCol
                                End If
                            End If
                        End If
                    End If
                End If
            End If
            
    Case vbKeyPageUp
            
            If (m_BoxType = 4 Or m_BoxType = 5) Then
                If m_Listbox1.Visible = True And m_Listbox1.ListCount > 0 Then
                
                    KeyCode = 0
                    
                    If m_Listbox1.ListIndex > 0 Then
                        m_Listbox1.ListIndex = 0
                    Else
                        If m_BoxType = 5 Then
                            Set colItems = m_Browse.GetPrevList(m_Listbox1.List(0))
                        
                            If colItems.Count > 0 Then
                            
                                m_Listbox1.ListIndex = -1
                                For i = 1 To colItems.Count
                        
                                    sTemp = colItems(i)
                        
                                    If m_Listbox1.ListCount >= m_Browse.GetMaxElmt Then
                                        m_Listbox1.RemoveItem m_Listbox1.ListCount - 1
                                    End If
                                
                                    m_Listbox1.AddItem sTemp, 0
                                
                                Next
                            
                                m_Listbox1.ListIndex = 0
                            
                            End If
                        End If
                    End If
                End If
            End If
            
        Case vbKeyPageDown
        
               If (m_BoxType = 4 Or m_BoxType = 5) Then
                If m_Listbox1.Visible = True And m_Listbox1.ListCount > 0 Then
                
                    KeyCode = 0
                    
                    If m_Listbox1.ListIndex < m_Listbox1.ListCount - 1 Then
                        m_Listbox1.ListIndex = m_Listbox1.ListCount - 1
                    Else
                        If m_BoxType = 5 Then
                            Set colItems = m_Browse.GetNextList(m_Listbox1.List(m_Listbox1.ListCount - 1))
                        
                            If colItems.Count > 0 Then
                                m_Listbox1.ListIndex = -1
                                For i = 1 To colItems.Count
                        
                                    sTemp = colItems(i)
                        
                                    m_Listbox1.RemoveItem 0
                                
                                    m_Listbox1.AddItem sTemp, m_Listbox1.ListCount
                                
                                Next
                            
                                m_Listbox1.ListIndex = m_Listbox1.ListCount - 1
                            
                            End If
                        End If
                    End If
                End If
            End If
            
    End Select
     
    If m_BoxType = 6 Or m_BoxType = 7 Then
        Text1.SelStart = 0
    End If

    RaiseEvent KeyDown(KeyCode, Shift)
    
End Sub

Private Sub CheckChoice()
    If InStr(m_Choice, Text1.Text) <= 0 Then
        Text1.Text = m_OldVal
    End If
End Sub

Private Sub Text1_LostFocus()
    Dim TempDate As Date
    Dim bToValidate As Boolean
    
    Text1.SelStart = 0
    
    bToValidate = True
    m_InhouseValid = True
    
    UpdateTextBoxVals
    
    If m_InhouseValid Then
    
        If m_UseInGrid = 1 Then
             m_BusyGrid.SetGridText m_RowNo, m_ColNo + m_Grid.FixedCols, Text1.Text
            'm_Grid.TextArray((m_RowNo * m_Grid.Cols) + m_ColNo + m_Grid.FixedCols) = Text1.Text
        End If
             
        If Text1.Visible = False Then
            bToValidate = False
        End If
        
        If bToValidate And UserControl.Parent.ActiveControl.TabIndex > m_TabOrder And UserControl.Parent.hWnd = Screen.ActiveForm.hWnd And UserControl.Parent.ActiveControl.Tag <> "NV" Then    ' NV indicates - Not Validate
             bToValidate = True
        Else
             bToValidate = False
        End If
     
        If m_UseInGrid = 1 And bToValidate = True Then
        
            If m_Grid.Row < m_RowNo Then
                bToValidate = False
            ElseIf m_Grid.Row = m_RowNo Then
                If m_Grid.Col - m_Grid.FixedCols < m_ColNo Then
                    bToValidate = False
                End If
            End If
            
        End If
     
         Text1.BackColor = m_BackColorWhenNotSelected
         Text1.ForeColor = m_ForeColorWhenNotSelected
             
         If bToValidate Then
             
             m_ValidEntry = True
             RaiseEvent ValidateEntry
        
             If m_ValidEntry = False Then
                 
                 If m_UseInGrid = 1 Then
                     m_Grid.Row = m_RowNo
                     m_Grid.SetFocus
                 Else
                     Text1.SetFocus
                 End If
                 
                 m_ClearText = True
                 
             Else
                 
                 RaiseEvent MyLostFocus
                 
                 If m_UseInGrid = 1 Then
                     m_BusyGrid.FocusShiftingToNewControl (UserControl.Parent.ActiveControl.hWnd)
                 End If
             End If
         Else
                             
             If m_UseInGrid = 1 Then
                 m_BusyGrid.FocusShiftingToNewControl (UserControl.Parent.ActiveControl.hWnd)
             End If
             
         End If
    Else
        If m_UseInGrid = 1 Then
            m_Grid.Row = m_RowNo
            m_Grid.SetFocus
        Else
            Text1.SetFocus
        End If
        
        m_ClearText = True
    End If
    
End Sub

Private Sub UserControl_InitProperties()
   
    
    m_BackColorWhenNotSelected = vbWhite
    m_BackColorWhenSelected = vbWhite
    m_ForeColorWhenNotSelected = vbBlack
    m_ForeColorWhenSelected = vbBlack
    m_ForeColorWhenCantChange = vbRed
    m_BackColorWhenCantChange = vbWhite
            
    m_AllowNegative = False
    
    
    m_CanBeChanged = True
    m_CantChangeMsg = ""
    
    m_ExitFromEnter = m_Def_ExitFromEnter
    m_ExitFromBS = m_Def_ExitFromBS
    m_ExitFromDownArrowKey = m_Def_ExitFromDownArrowKey
    m_ExitFromUpArrowKey = m_Def_ExitFromUpArrowKey
    m_MaxChar = m_Def_MaxChar
    m_MaxDecimal = m_Def_MaxDecimal
    m_TextTypeAfterExit = m_Def_TextTypeAfterExit
    m_BoxType = m_Def_BoxType
    m_UseInGrid = m_Def_UseInGrid
    m_Choice = m_Def_Choice
    m_OldVal = ""
    m_TabOrder = 0
        
    Text1.ForeColor = vbBlack
    Text1.BackColor = vbWhite
    
    m_nMasterType = 0
    m_nAttribute = 0
    m_bShowListAtStartup = False
    m_ProportionalFont = False
    m_bAutoResizeList = True
    
End Sub
Public Sub InitControl()

    ForeColor = g_ColorUnSelectedTextFG
    BackColor = g_ColorUnSelectedTextBG
    m_ForeColorWhenSelected = g_ColorSelectedTextFG
    m_BackColorWhenSelected = g_ColorSelectedTextBG
    m_ForeColorWhenNotSelected = g_ColorUnSelectedTextFG
    m_BackColorWhenNotSelected = g_ColorUnSelectedTextBG
    m_ForeColorWhenCantChange = g_ColorCantChangeTextFG
    m_BackColorWhenCantChange = g_ColorCantChangeTextBG
    m_CantChangeMsg = ""
    m_ExitFromEnter = True
    m_ExitFromBS = True
    m_ExitFromUpArrowKey = True
    m_ExitFromDownArrowKey = True
    'm_TextTypeAfterExit = 4
    m_UseInGrid = 0
    
    If m_BoxType = 5 Or m_BoxType = 4 Then
        m_bAutoResizeList = True
    End If
    
End Sub
'Load property values from storage
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    
    Text1.BackColor = PropBag.ReadProperty("BackColor", vbWhite)
    Text1.ForeColor = PropBag.ReadProperty("ForeColor", vbBlack)
    Text1.Enabled = PropBag.ReadProperty("Enabled", True)
    
'    Set Font = PropBag.ReadProperty("Font", Ambient.Font)
    
    Text1.WhatsThisHelpID = PropBag.ReadProperty("WhatsThisHelpID", 0)
        
    m_CanBeChanged = PropBag.ReadProperty("CanBeChanged", True)
    'm_ExitFromEnter = PropBag.ReadProperty("ExitFromEnter", m_Def_ExitFromEnter)
    'm_ExitFromBS = PropBag.ReadProperty("ExitFromBS", m_Def_ExitFromBS)
    'm_ExitFromDownArrowKey = PropBag.ReadProperty("ExitFromDownArrowKey", m_Def_ExitFromDownArrowKey)
    'm_ExitFromUpArrowKey = PropBag.ReadProperty("ExitFromUpArrowKey", m_Def_ExitFromUpArrowKey)
    m_MaxChar = PropBag.ReadProperty("MaxChar", m_Def_MaxChar)
    m_MaxDecimal = PropBag.ReadProperty("MaxDecimal", m_Def_MaxDecimal)
    m_TextTypeAfterExit = PropBag.ReadProperty("TextTypeAfterExit", m_Def_TextTypeAfterExit)
       
    m_BoxType = PropBag.ReadProperty("BoxType", m_Def_BoxType)
    'm_Choice = PropBag.ReadProperty("Choice", m_Def_Choice)
    'm_UseInGrid = PropBag.ReadProperty("UseInGrid", m_Def_UseInGrid)
    
    'm_BackColorWhenSelected = PropBag.ReadProperty("BackColorWhenSelected", vbWhite)
    'm_ForeColorWhenSelected = PropBag.ReadProperty("ForeColorWhenSelected", vbBlack)
        
    'm_BackColorWhenNotSelected = PropBag.ReadProperty("BackColorWhenNotSelected", vbWhite)
    'm_ForeColorWhenNotSelected = PropBag.ReadProperty("ForeColorWhenNotSelected", vbBlack)
    
    'm_BackColorWhenCantChange = PropBag.ReadProperty("BackColorWhenCantChange", vbWhite)
    'm_ForeColorWhenCantChange = PropBag.ReadProperty("ForeColorWhenCantChange", vbRed)
    
    Text1.SelText = PropBag.ReadProperty("SelText", "")
    Text1.SelStart = PropBag.ReadProperty("SelStart", 0)
    Text1.SelLength = PropBag.ReadProperty("SelLength", 0)
    Text1.Text = PropBag.ReadProperty("Text", "")
    
    Text1.PasswordChar = PropBag.ReadProperty("PasswordChar", "")
End Sub

Private Sub UserControl_Terminate()
    Set m_BusyGrid = Nothing
    Set m_Grid = Nothing
    Set m_Browse = Nothing
End Sub

'Write property values to storage
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
      
   
    
    Call PropBag.WriteProperty("BackColor", Text1.BackColor, vbWhite)
    Call PropBag.WriteProperty("ForeColor", Text1.ForeColor, vbBlack)
    
    Call PropBag.WriteProperty("Enabled", Text1.Enabled, True)
    Call PropBag.WriteProperty("Font", Font, Ambient.Font)
       
    Call PropBag.WriteProperty("WhatsThisHelpID", Text1.WhatsThisHelpID, 0)
    
    Call PropBag.WriteProperty("CanBeChanged", m_CanBeChanged, True)
    'Call PropBag.WriteProperty("ExitFromEnter", m_ExitFromEnter, m_Def_ExitFromEnter)
    'Call PropBag.WriteProperty("ExitFromBS", m_ExitFromBS, m_Def_ExitFromBS)
    'Call PropBag.WriteProperty("ExitFromDownArrowKey", m_ExitFromDownArrowKey, m_Def_ExitFromDownArrowKey)
    'Call PropBag.WriteProperty("ExitFromUpArrowKey", m_ExitFromUpArrowKey, m_Def_ExitFromUpArrowKey)
    Call PropBag.WriteProperty("MaxChar", m_MaxChar, m_Def_MaxChar)
    Call PropBag.WriteProperty("MaxDecimal", m_MaxDecimal, m_Def_MaxDecimal)
    Call PropBag.WriteProperty("TextTypeAfterExit", m_TextTypeAfterExit, m_Def_TextTypeAfterExit)
    Call PropBag.WriteProperty("BoxType", m_BoxType, m_Def_BoxType)
    'Call PropBag.WriteProperty("Choice", m_Choice, m_Def_Choice)
    'Call PropBag.WriteProperty("UseInGrid", m_UseInGrid, m_Def_UseInGrid)

    Call PropBag.WriteProperty("SelText", Text1.SelText, "")
    Call PropBag.WriteProperty("SelStart", Text1.SelStart, 0)
    Call PropBag.WriteProperty("SelLength", Text1.SelLength, 0)
    Call PropBag.WriteProperty("Text", Text1.Text, "")
    
    'Call PropBag.WriteProperty("BackColorWhenSelected", m_BackColorWhenSelected, vbWhite)
    'Call PropBag.WriteProperty("ForeColorWhenSelected", m_ForeColorWhenSelected, vbBlack)
    
    'Call PropBag.WriteProperty("BackColorWhenNotSelected", m_BackColorWhenNotSelected, vbWhite)
    'Call PropBag.WriteProperty("ForeColorWhenNotSelected", m_ForeColorWhenNotSelected, vbBlack)
    
    'Call PropBag.WriteProperty("BackColorWhenCantChange", m_BackColorWhenCantChange, vbWhite)
    'Call PropBag.WriteProperty("ForeColorWhenCantChange", m_ForeColorWhenCantChange, vbRed)
    
    Call PropBag.WriteProperty("PasswordChar", Text1.PasswordChar, "")
End Sub
Public Property Let AllowNegative(p_AllowNegative As Boolean)
    m_AllowNegative = p_AllowNegative
End Property

Public Property Get DoubleVal() As Double
    m_DoubleVal = Text2Dbl(Text1.Text)
    m_DoubleVal = Round(m_DoubleVal, m_MaxDecimal)
    DoubleVal = m_DoubleVal
End Property

Public Property Let DoubleVal(ByVal New_DoubleVal As Double)
    Dim Num As Double
    If m_BoxType = 1 Then
        If m_CanBeChanged Then
            Num = Round(New_DoubleVal, m_MaxDecimal)
            If Not IfZero(Num) Then
                m_DoubleVal = Num
            Else
                m_DoubleVal = 0
            End If
            PropertyChanged "DoubleVal"
            Text1.Text = FormatNum(m_DoubleVal, m_MaxChar, m_MaxDecimal, True)
        End If
    End If
End Property
Public Function ForceDoubleVal(ByVal New_DoubleVal As Double)
    Dim Num As Double
    Dim OldCanChangeStatus As Boolean
    
    If m_BoxType = 1 Then
        OldCanChangeStatus = m_CanBeChanged
        m_CanBeChanged = True
        Num = Round(New_DoubleVal, m_MaxDecimal)
        If Not IfZero(Num) Then
            m_DoubleVal = Num
        Else
            m_DoubleVal = 0
        End If
        PropertyChanged "DoubleVal"
        Text1.Text = FormatNum(m_DoubleVal, m_MaxChar, m_MaxDecimal, True)
        m_CanBeChanged = OldCanChangeStatus
    End If
    
End Function

Public Property Get IntVal() As Integer
    If DoubleVal >= -32768 And DoubleVal < 32767 Then
        IntVal = CInt(DoubleVal)
    Else
        IntVal = 0
    End If
End Property
Public Property Let IntVal(ByVal New_IntVal As Integer)
    If m_BoxType = 1 Then
        If m_CanBeChanged Then
            DoubleVal = CDbl(New_IntVal)
            PropertyChanged "IntVal"
        End If
    End If
End Property
Public Property Get BoolVal() As Boolean
    If CompareStr(Text1.Text, "Y") = 0 Then
        m_BoolVal = True
    Else
        m_BoolVal = False
    End If
    
    BoolVal = m_BoolVal
End Property

Public Property Let BoolVal(ByVal New_BoolVal As Boolean)
    If m_BoxType = 6 Then
        If m_CanBeChanged Then
            m_BoolVal = New_BoolVal
            PropertyChanged "BoolVal"
            If m_BoolVal = True Then
                Text1.Text = "Y"
            Else
                Text1.Text = "N"
            End If
        End If
    End If
End Property

Public Function ForceBoolVal(ByVal New_BoolVal As Boolean)
    Dim OldCanChangeStatus As Boolean
    If m_BoxType = 6 Then
        OldCanChangeStatus = m_CanBeChanged
        m_CanBeChanged = True
        m_BoolVal = New_BoolVal
        PropertyChanged "BoolVal"
        If m_BoolVal = True Then
            Text1.Text = "Y"
        Else
            Text1.Text = "N"
        End If
        m_CanBeChanged = OldCanChangeStatus
    End If
End Function

Public Property Get DCVal() As Integer
    If CompareStr(Text1.Text, "D") = 0 Then
        m_DCVal = DEBIT
    Else
        m_DCVal = CREDIT
    End If
    
    DCVal = m_DCVal
End Property
Public Property Let DCVal(ByVal New_DCVal As Integer)
    If m_BoxType = 7 Then
        If m_CanBeChanged Then
            m_DCVal = New_DCVal
            PropertyChanged "DCVal"
            If m_DCVal = DEBIT Then
                Text1.Text = "D"
            Else
                Text1.Text = "C"
            End If
        End If
    End If
End Property

Public Function ForceDCVal(ByVal New_DCVal As Integer)
    Dim OldCanChangeStatus As Boolean
    If m_BoxType = 7 Then
        OldCanChangeStatus = m_CanBeChanged
        m_CanBeChanged = True
        m_DCVal = New_DCVal
        PropertyChanged "DCVal"
        If m_DCVal = DEBIT Then
            Text1.Text = "D"
        Else
            Text1.Text = "C"
        End If
        m_CanBeChanged = OldCanChangeStatus
    End If
End Function

Public Property Get DateVal() As Date
    DateVal = m_DateVal
End Property

Public Property Let DateVal(ByVal New_DateVal As Date)
    
    If m_BoxType = 2 Then
        If m_CanBeChanged Then
            m_DateVal = New_DateVal
            PropertyChanged "DateVal"
            Text1.Text = FormatDate(m_DateVal, True)
        End If
    End If
End Property
Public Function ForceDateVal(ByVal New_DateVal As Date)
    Dim OldCanChangeStatus As Boolean
    If m_BoxType = 2 Then
        OldCanChangeStatus = m_CanBeChanged
        m_CanBeChanged = True
        m_DateVal = New_DateVal
        PropertyChanged "DateVal"
        Text1.Text = FormatDate(m_DateVal, True)
        m_CanBeChanged = OldCanChangeStatus
    End If
End Function

Public Property Get Choice() As String
    Choice = m_Choice
End Property

Public Property Let Choice(ByVal New_Choice As String)

    m_Choice = New_Choice
    PropertyChanged "Choice"
        
End Property

Public Property Get TextTypeAfterExit() As Integer
    TextTypeAfterExit = m_TextTypeAfterExit
End Property

Public Property Let TextTypeAfterExit(ByVal New_TextTypeAfterExit As Integer)
    m_TextTypeAfterExit = New_TextTypeAfterExit
    PropertyChanged "TextTypeAfterExit"
End Property


Public Property Get OldVal() As String
    OldVal = m_OldVal
End Property
Public Property Get hWnd() As Long
Attribute hWnd.VB_Description = "Returns a handle (from Microsoft Windows) to an object's window."
    hWnd = Text1.hWnd
End Property


Public Property Get BackColorWhenNotSelected() As Long
Attribute BackColorWhenNotSelected.VB_MemberFlags = "400"
    BackColorWhenNotSelected = m_BackColorWhenNotSelected
End Property

Public Property Let BackColorWhenNotSelected(ByVal New_BackColorWhenNotSelected As Long)
    m_BackColorWhenNotSelected = New_BackColorWhenNotSelected
    PropertyChanged "BackColorWhenNotSelected"
End Property
Public Property Get BackColorWhenSelected() As Long
Attribute BackColorWhenSelected.VB_MemberFlags = "400"
    BackColorWhenSelected = m_BackColorWhenSelected
End Property

Public Property Let BackColorWhenSelected(ByVal New_BackColorWhenSelected As Long)
    m_BackColorWhenSelected = New_BackColorWhenSelected
    PropertyChanged "BackColorWhenSelected"
End Property

Public Property Get BackColorWhenCantChange() As Long
    BackColorWhenCantChange = m_BackColorWhenCantChange
End Property

Public Property Let BackColorWhenCantChange(ByVal New_BackColorWhenCantChange As Long)
    m_BackColorWhenCantChange = New_BackColorWhenCantChange
    PropertyChanged "BackColorWhenCantChange"
End Property

Public Property Get ForeColorWhenCantChange() As Long
    ForeColorWhenCantChange = m_ForeColorWhenCantChange
End Property

Public Property Let ForeColorWhenCantChange(ByVal New_ForeColorWhenCantChange As Long)
    m_ForeColorWhenCantChange = New_ForeColorWhenCantChange
    PropertyChanged "ForeColorWhenCantChange"
End Property

Public Property Get BoxType() As Integer
    BoxType = m_BoxType
End Property

Public Property Get UseInGrid() As Integer
    UseInGrid = m_UseInGrid
End Property

Public Property Let UseInGrid(ByVal New_UseInGrid As Integer)
    m_UseInGrid = New_UseInGrid
    PropertyChanged "UseInGrid"
End Property

Public Property Get SelStart() As Integer
    SelStart = Text1.SelStart
End Property

Public Property Let SelStart(ByVal New_SelStart As Integer)
    Text1.SelStart = New_SelStart
    PropertyChanged "SelStart"
End Property

Public Property Get SelLength() As Integer
    SelLength = Text1.SelLength
End Property

Public Property Let SelLength(ByVal New_SelLength As Integer)
    Text1.SelLength = New_SelLength
    PropertyChanged "SelLength"
End Property

Public Property Get SelText() As String
    SelText = Text1.SelText
End Property

Public Property Let SelText(ByVal New_SelText As String)
    Text1.SelText = New_SelText
    PropertyChanged "SelText"
End Property
Public Property Get CantChangeMsg() As String
    CantChangeMsg = m_CantChangeMsg
End Property

Public Property Let CantChangeMsg(ByVal New_CantChangeMsg As String)
    m_CantChangeMsg = New_CantChangeMsg
    PropertyChanged "CantChangeMsg"
End Property
Public Property Let BoxType(ByVal New_BoxType As Integer)
    m_BoxType = New_BoxType
    
    If m_BoxType = 1 Then
        DoubleVal = 0
        m_MaxChar = 16
        m_MaxDecimal = 0
    ElseIf m_BoxType = 2 Then
        DateVal = Now
        m_MaxChar = 10
        m_MaxDecimal = 0
    ElseIf m_BoxType = 3 Then
        Choice = ""
        m_MaxChar = 1
        m_MaxDecimal = 0
    ElseIf m_BoxType = 6 Then
        BoolVal = False
        m_MaxChar = 1
        m_MaxDecimal = 0
    ElseIf m_BoxType = 7 Then
        DCVal = DEBIT
        m_MaxChar = 1
        m_MaxDecimal = 0
    End If
    PropertyChanged "BoxType"
End Property

Public Property Get ForeColorWhenNotSelected() As Long
Attribute ForeColorWhenNotSelected.VB_MemberFlags = "400"
    ForeColorWhenNotSelected = m_ForeColorWhenNotSelected
End Property

Public Property Let ForeColorWhenNotSelected(ByVal New_ForeColorWhenNotSelected As Long)
    m_ForeColorWhenNotSelected = New_ForeColorWhenNotSelected
    PropertyChanged "ForeColorWhenNotSelected"
End Property

Public Property Get ForeColorWhenSelected() As Long
Attribute ForeColorWhenSelected.VB_MemberFlags = "400"
    ForeColorWhenSelected = m_ForeColorWhenSelected
End Property

Public Property Let ForeColorWhenSelected(ByVal New_ForeColorWhenSelected As Long)
    m_ForeColorWhenSelected = New_ForeColorWhenSelected
    PropertyChanged "ForeColorWhenSelected"
End Property

Public Property Get ExitFromEnter() As Boolean
    ExitFromEnter = m_ExitFromEnter
End Property

Public Property Let ExitFromEnter(ByVal New_ExitFromEnter As Boolean)
    m_ExitFromEnter = New_ExitFromEnter
    PropertyChanged "ExitFromEnter"
End Property
Public Property Get ExitFromBS() As Boolean
    ExitFromBS = m_ExitFromBS
End Property

Public Property Let ExitFromBS(ByVal New_ExitFromBS As Boolean)
    m_ExitFromBS = New_ExitFromBS
    PropertyChanged "ExitFromBS"
End Property

Public Property Get CanBeChanged() As Boolean
    CanBeChanged = m_CanBeChanged
End Property

Public Property Let CanBeChanged(ByVal New_CanBeChanged As Boolean)
    m_CanBeChanged = New_CanBeChanged
    PropertyChanged "CanBeChanged"
End Property

Public Property Get ExitFromDownArrowKey() As Boolean
    ExitFromDownArrowKey = m_ExitFromDownArrowKey
End Property

Public Property Let ExitFromDownArrowKey(ByVal New_ExitFromDownArrowKey As Boolean)
    m_ExitFromDownArrowKey = New_ExitFromDownArrowKey
    PropertyChanged "ExitFromDownArrowKey"
End Property

Public Property Get ExitFromUpArrowKey() As Boolean
    ExitFromUpArrowKey = m_ExitFromUpArrowKey
End Property

Public Property Let ExitFromUpArrowKey(ByVal New_ExitFromUpArrowKey As Boolean)
    m_ExitFromUpArrowKey = New_ExitFromUpArrowKey
    PropertyChanged "ExitFromUpArrowKey"
End Property

Public Property Get MaxChar() As Integer
    MaxChar = m_MaxChar
End Property

Public Property Let MaxChar(ByVal New_MaxChar As Integer)
    If m_BoxType <> 2 And m_BoxType <> 6 And m_BoxType <> 7 Then
        m_MaxChar = New_MaxChar
        PropertyChanged "MaxChar"
    End If
End Property
Public Property Get TabOrder() As Integer
    TabOrder = m_TabOrder
End Property

Public Property Let TabOrder(ByVal New_TabOrder As Integer)
    m_TabOrder = New_TabOrder
    PropertyChanged "TabOrder"
End Property

Public Property Get MaxDecimal() As Integer
    MaxDecimal = m_MaxDecimal
End Property

Public Property Let MaxDecimal(ByVal New_MaxDecimal As Integer)
    m_MaxDecimal = New_MaxDecimal
    Round m_DoubleVal, m_MaxDecimal
    PropertyChanged "MaxDecimal"
End Property
Public Function InHouseValidated() As Boolean
' To be used for in house date validation
    InHouseValidated = m_InhouseValid
End Function

Private Sub UserControl_Initialize()
'    DoubleVal = 0
'    DateVal = Now
    
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,hWnd

Private Sub Text1_Change()
    
    If Not m_CanBeChanged Then
        ShowCantChangeMsg m_CantChangeMsg
        'MsgBox m_CantChangeMsg, vbOKOnly, "Can't Change"
        Text1.Text = m_OldVal
    Else
        RaiseEvent Change
    End If
    
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Text
Public Property Get Text() As String
Attribute Text.VB_Description = "Returns/sets the text contained in the control."
    Text = Text1.Text
End Property

Public Property Let Text(ByVal New_Text As String)
    If m_CanBeChanged Then
        Text1.Text() = New_Text
        
        If m_BoxType = 1 Then
            m_DoubleVal = Text2Dbl(New_Text)
        ElseIf m_BoxType = 2 Then
            m_DateVal = Text2Date(New_Text)
        ElseIf m_BoxType = 6 Then
            If New_Text = "Y" Then
                m_BoolVal = True
            Else
                m_BoolVal = False
            End If
        ElseIf m_BoxType = 7 Then
            If New_Text = "C" Then
                m_DCVal = CREDIT
            Else
                m_DCVal = DEBIT
            End If
        End If
        
        PropertyChanged "Text"
    Else
        ShowCantChangeMsg m_CantChangeMsg
    End If
End Property


'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Enabled
Public Property Get Enabled() As Boolean
    Enabled = Text1.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    Text1.Enabled() = New_Enabled
    PropertyChanged "Enabled"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Refresh
Public Sub Refresh()
    Text1.Refresh
End Sub

Private Sub Text1_Click()
    If m_BoxType = 6 Or m_BoxType = 7 Then
        Text1.SelStart = 0
    End If
    RaiseEvent Click
End Sub

Private Sub Text1_DblClick()
    RaiseEvent DblClick
End Sub

Private Sub Text1_KeyUp(KeyCode As Integer, Shift As Integer)
    RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub Text1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    'If Button = vbRightButton And m_BoxType = 5 And m_nMasterType <> 0 Then
        'PopupMenu mnuBusyTextBox
    'End If
    
    RaiseEvent MouseDown(Button, Shift, X, Y)
    
End Sub

Private Sub Text1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    RaiseEvent MouseMove(Button, Shift, X, Y)
    
End Sub

Private Sub Text1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    RaiseEvent MouseUp(Button, Shift, X, Y)
End Sub
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Returns/sets the background color used to display text and graphics in an object."
Attribute BackColor.VB_MemberFlags = "400"
    BackColor = Text1.BackColor
End Property
Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    Text1.BackColor() = New_BackColor
    PropertyChanged "BackColor"
End Property
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Returns/sets the foreground color used to display text and graphics in an object."
Attribute ForeColor.VB_MemberFlags = "400"
    ForeColor = Text1.ForeColor
End Property
Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    Text1.ForeColor() = New_ForeColor
    PropertyChanged "ForeColor"
End Property
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "Returns a Font object."
Attribute Font.VB_UserMemId = -512
Attribute Font.VB_MemberFlags = "400"
    Set Font = Text1.Font
End Property
Public Property Set Font(ByVal New_Font As Font)
    Set Text1.Font = New_Font
    PropertyChanged "Font"
End Property
Public Sub UpdateListBox(ByRef New_ListBox1 As Object)
    Set m_Listbox1 = New_ListBox1
    m_Listbox1.Visible = False
End Sub
Public Function GetListBox() As ListBox
    Set GetListBox = m_Listbox1
End Function
Public Sub UpdateBrowse(ByRef New_Browse As Object, Optional p_ClearList As Boolean = False)
    Set m_Browse = Nothing
    Set m_Browse = New_Browse
    If p_ClearList Then
        m_Listbox1.Clear
    End If
End Sub
Public Property Get ValidEntry() As Boolean
    ValidEntry = m_ValidEntry
End Property

Public Property Let ValidEntry(ByVal New_ValidEntry As Boolean)
    m_ValidEntry = New_ValidEntry
    PropertyChanged "ValidEntry"
    If m_ValidEntry = False Then
        Text1.SetFocus
    End If
End Property
Public Property Get CurrentRow() As Integer
    CurrentRow = m_RowNo
End Property
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,PasswordChar
Public Property Get PasswordChar() As String
Attribute PasswordChar.VB_Description = "Returns/sets a value that determines whether characters typed by a user or placeholder characters are displayed in a control."
    PasswordChar = Text1.PasswordChar
End Property

Public Property Let PasswordChar(ByVal New_PasswordChar As String)
    Text1.PasswordChar() = New_PasswordChar
    PropertyChanged "PasswordChar"
End Property
