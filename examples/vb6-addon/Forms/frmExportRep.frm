VERSION 5.00
Begin VB.Form frmExportRep 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Export Data"
   ClientHeight    =   2610
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5580
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   2610
   ScaleWidth      =   5580
   StartUpPosition =   2  'CenterScreen
   Begin BusyS04001.BusyText txtFormat 
      Height          =   255
      Left            =   1920
      TabIndex        =   6
      Top             =   600
      Width           =   3255
      _ExtentX        =   5741
      _ExtentY        =   450
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.ListBox lstFormat 
      Height          =   840
      Left            =   4680
      TabIndex        =   0
      Top             =   1560
      Width           =   735
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&OK"
      Height          =   495
      Left            =   1560
      Style           =   1  'Graphical
      TabIndex        =   5
      Top             =   1800
      Width           =   975
   End
   Begin VB.CommandButton cmdQuit 
      Caption         =   "&Quit"
      Height          =   495
      Left            =   2760
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   1800
      Width           =   975
   End
   Begin BusyS04001.BusyText txtPath 
      Height          =   255
      Left            =   1920
      TabIndex        =   7
      Top             =   1080
      Width           =   3255
      _ExtentX        =   5741
      _ExtentY        =   450
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label Label1 
      Caption         =   "File Name"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   1080
      Width           =   1575
   End
   Begin VB.Label lblCaption 
      Alignment       =   2  'Center
      Caption         =   "Export Report Data"
      Height          =   255
      Left            =   360
      TabIndex        =   2
      Top             =   120
      Width           =   5055
   End
   Begin VB.Label Label2 
      Caption         =   "Data Format"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   600
      Width           =   1575
   End
End
Attribute VB_Name = "frmExportRep"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Public KeyPressed As Boolean
Public FileName As String
Public ExportType As Integer
Public FileChs As Integer
Public Done As Boolean

Private Function ExportTypeStr2Num(p_Str As String) As Integer
    Dim RetVal As Integer
    
    Select Case p_Str
        Case "Text File - Comma Delimited"
            RetVal = EXPORT_TEXT_D1
        Case "Microfost Excel - 97 or Above"
            RetVal = EXPORT_EXCEL
        Case "Microfost Access - 97 or Above"
            RetVal = EXPORT_ACCESS
        Case "HTML"
            RetVal = EXPORT_HTML
        Case Else
            RetVal = 0
    End Select
    
    ExportTypeStr2Num = RetVal
    
End Function
Private Function ExportTypeNum2Str(p_Num As String) As String
    Dim RetVal As String
    
    Select Case p_Num
        Case EXPORT_TEXT_D1
            RetVal = "Text File - Comma Delimited"
        Case EXPORT_EXCEL
            RetVal = "Microfost Excel - 97 or Above"
        Case EXPORT_ACCESS
            RetVal = "Microfost Access - 97 or Above"
        Case EXPORT_HTML
            RetVal = "HTML"
        Case Else
            RetVal = ""
    End Select
    
    ExportTypeNum2Str = RetVal
    
End Function

Public Sub SaveRec()
    Dim strError As String
    
    Done = True
    ExportType = ExportTypeStr2Num(txtFormat.Text)
    
    If ExportType = 0 Then
        FieldInvalidMsg "Invalid data export format."
        Done = False
    End If
    
    If Done Then
        If Trim$(txtPath.Text) = "" Then
            Done = False
            FieldInvalidMsg "File name is blank."
        End If
    End If
    
    If Done Then
        If FileExist(txtPath.Text) Then
            FileChs = GetOption3("The file '" & Trim$(txtPath.Text) & "' already exist.", "Overwrite", "Append", "Cancel", "File Exist !", 1)
            If FileChs = 1 Then
                FileChs = FILE_CREATE
            ElseIf FileChs = 2 Then
                FileChs = FILE_APPEND
            End If
        Else
            If CanCreateFile(txtPath.Text, strError) Then
                FileChs = FILE_CREATE
            Else
                Done = False
                FieldInvalidMsg "The specified file can not be created (" & strError & ").", "Can't Create File !"
            End If
        End If
        If FileChs = 3 Or FileChs = 0 Then
            Done = False
        End If
    End If
    
    If Done Then
        FileName = txtPath.Text
        Unload Me
    Else
        txtFormat.SetFocus
    End If
        
End Sub

Private Sub cmdQuit_Click()
    QuitRec
End Sub

Private Sub cmdSave_Click()
    SaveRec
End Sub
Private Sub SetFormSize()
'    Me.Left = fMainForm.Left + FORM_LEFT
'    Me.Top = fMainForm.Top + FORM_TOP
End Sub
Public Sub QuitRec()
    Done = False
    Unload Me
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    If Shift = 0 And KeyCode = vbKeyF2 Then
        KeyCode = 0
        SaveRec
    End If
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = vbKeyEscape Then
        QuitRec
    End If
End Sub

Private Sub Form_Load()
    Dim i As Integer
    
    lblCaption.Left = 0
    lblCaption.Tag = "H4"
    txtPath.BoxType = 0
    txtPath.MaxChar = 50
            
    txtPath.Text = ""
    txtFormat.Text = ""
    
    txtFormat.BoxType = 4
    txtFormat.UpdateListBox lstFormat
    txtFormat.ShowListAtStartup = True
    
    lstFormat.AddItem ExportTypeNum2Str(EXPORT_TEXT_D1)
    lstFormat.AddItem ExportTypeNum2Str(EXPORT_EXCEL)
    lstFormat.AddItem ExportTypeNum2Str(EXPORT_HTML)
    
    i = 0
    SetTabIndex txtFormat, i: i = i + 1
    lstFormat.TabIndex = i: i = i + 1
    SetTabIndex txtPath, i: i = i + 1
    cmdSave.TabIndex = i: i = i + 1
    cmdQuit.TabIndex = i: i = i + 1
    
    cmdQuit.Tag = "NV"
    
    SetFormSize
    
    SetInputForm Me
    
'    UpdateSBMsg Sb1, GetSBMsg(SBT_DONE)
    
'    UpdateStatusControls Sb1, Frm1, Ani1, Me
    
End Sub


Private Sub Form_Resize()
    CheckMainForm Me
    lblCaption.Width = Me.Width
End Sub


Private Sub Label1_Click()
    If Me.txtPath.Visible Then Me.txtPath.SetFocus
End Sub

Private Sub Label2_Click()
    If Me.txtFormat.Visible Then Me.txtFormat.SetFocus
End Sub

Private Sub txtFormat_MyGotFocus()
    lstFormat.Left = txtFormat.Left
    lstFormat.Top = txtFormat.Top + txtFormat.Height + 50
End Sub

Private Sub txtPath_ValidateEntry()
    Dim fso As FileSystemObject
    Dim ExportType As Integer
    Dim Extension As String
    
    If Trim$(txtPath.Text) <> "" Then
        Set fso = New FileSystemObject
        If fso.GetExtensionName(txtPath.Text) = "" Then
            ExportType = ExportTypeStr2Num(txtFormat.Text)
            Select Case ExportType
                Case EXPORT_TEXT_D1
                    Extension = ".txt"
                Case EXPORT_EXCEL
                    Extension = ".xls"
                Case EXPORT_ACCESS
                    Extension = ".mdb"
                Case EXPORT_HTML
                    Extension = ".html"
                Case Else
                    Extension = ""
            End Select
            txtPath.Text = txtPath.Text & Extension
        End If
        Set fso = Nothing
    End If
End Sub
