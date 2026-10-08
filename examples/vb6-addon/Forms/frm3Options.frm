VERSION 5.00
Begin VB.Form frm3Options 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form2"
   ClientHeight    =   1425
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6345
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1425
   ScaleWidth      =   6345
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmd3 
      Height          =   495
      Left            =   4440
      TabIndex        =   4
      Top             =   840
      Width           =   1815
   End
   Begin VB.CommandButton cmd2 
      Height          =   495
      Left            =   2280
      TabIndex        =   3
      Top             =   840
      Width           =   1815
   End
   Begin VB.CommandButton cmd1 
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   840
      Width           =   1815
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Enabled         =   0   'False
      Height          =   495
      Left            =   240
      ScaleHeight     =   495
      ScaleWidth      =   495
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000080&
      Height          =   615
      Left            =   840
      TabIndex        =   1
      Top             =   120
      UseMnemonic     =   0   'False
      Width           =   5055
   End
End
Attribute VB_Name = "frm3Options"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Option1 As String
Public Option2 As String
Public Option3 As String
Public Result As Integer
Public PicID As String
Public Msg As String
Public Title As String
Public DefaultValue As Integer
Private Sub AdjustSize()
'    Me.Top = fMainForm.Top + (fMainForm.Height - Me.Height) / 2
'    Me.Left = fMainForm.Left + (fMainForm.Width - Me.Width) / 2
End Sub

Private Sub cmd1_Click()
    Result = 1
    Unload Me
End Sub

Private Sub cmd2_Click()
    Result = 2
    Unload Me
End Sub

Private Sub cmd3_Click()
    Result = 3
    Unload Me
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
'    GlobalKeyDownHandler KeyCode, Shift
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = vbKeyEscape Then
        Result = 0
        Unload Me
    End If
End Sub

Private Sub Form_Load()
    Dim fnt As New StdFont
    
    Result = 0
    
    Me.KeyPreview = True
    
    If DefaultValue = 2 Then
        cmd2.TabIndex = 0
    ElseIf DefaultValue = 3 Then
        cmd3.TabIndex = 0
    Else
        cmd1.TabIndex = 0
    End If
    
        
    Label1.ForeColor = g_ColorMsgBoxFG
    Label1.Font.Name = "Arial"
    'Label1.FontBold = True
    Label1.Font.Size = 9
    
    
'    SetButtonStyle cmd1
'    SetButtonStyle cmd2
'    SetButtonStyle cmd3
    
    fnt.Name = "Arial"
    fnt.Bold = True
    'fnt.Italic = True
    fnt.Size = 8
    
    Set cmd1.Font = fnt
    Set cmd2.Font = fnt
    Set cmd3.Font = fnt
    
    AdjustSize
    cmd1.Caption = Option1
    cmd2.Caption = Option2
    cmd3.Caption = Option3
'    Me.Icon = LoadResPicture(g_BusyLogoResName, vbResIcon)
    
    Me.Caption = " " & Title
    Label1.Caption = Msg
    Picture1.Picture = LoadResPicture(PicID, GetPicType(PicID))
    Screen.MousePointer = vbDefault
    
End Sub




Private Sub Form_Resize()
    CheckMainForm Me
End Sub
