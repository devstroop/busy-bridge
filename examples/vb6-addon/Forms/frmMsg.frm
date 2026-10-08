VERSION 5.00
Begin VB.Form frmMsg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Form4"
   ClientHeight    =   1755
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4710
   Icon            =   "frmMsg.frx":0000
   LinkTopic       =   "Form4"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1755
   ScaleWidth      =   4710
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Cancel          =   -1  'True
      Caption         =   "Ok"
      Height          =   375
      Left            =   3720
      TabIndex        =   2
      Top             =   1320
      Width           =   855
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Enabled         =   0   'False
      Height          =   495
      Left            =   120
      ScaleHeight     =   495
      ScaleWidth      =   495
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Label1"
      Height          =   975
      Left            =   840
      TabIndex        =   0
      Top             =   120
      UseMnemonic     =   0   'False
      Width           =   3735
   End
End
Attribute VB_Name = "frmMsg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public SmallMsg As Boolean
Public LargeMsg As Boolean

Private m_SW As Long
Private m_SH As Long
Private m_LW As Long
Private m_LH As Long

Public Msg As String
Public Title As String
Public PicID As String
Private Sub Command1_Click()
    Unload Me
End Sub
Private Sub AdjustSize()
    If g_MainForm.WindowState <> vbNormal Then
        Me.Top = g_MainForm.Top + (g_MainForm.Height - Me.Height) / 2
        Me.Left = g_MainForm.Left + (g_MainForm.Width - Me.Width) / 2
    Else
        Me.Top = (Screen.Height - Me.Height) / 2
        Me.Left = (Screen.Width - Me.Width) / 2
    End If
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    GlobalKeyDownHandler KeyCode, Shift

End Sub

Private Sub Form_Load()
            
    m_SW = 300
    m_SH = 200
    m_LW = 300
    m_LH = 200
        
    If SmallMsg Then
        SetSmallSize
    End If

    AdjustSize
    
    Label1.ForeColor = g_ColorMsgBoxFG
    Label1.Font.Name = "Arial"
    Label1.Font.Size = 9
    
    Command1.FontBold = True
    Command1.FontItalic = True
    Command1.Font.Size = 9
    
    Me.Icon = LoadResPicture("ICO_BUSYLOGO", vbResIcon)
    Beep
    Me.Caption = " " & Title
    Label1.Caption = Msg
    
    Picture1.Picture = LoadResPicture(PicID, GetPicType(PicID))
    
    Screen.MousePointer = vbDefault
    
End Sub


Private Sub Form_Resize()
    CheckMainForm Me
End Sub

Public Sub SetSmallSize()
    Label1.Width = Label1.Width - m_SW
    Label1.Height = Label1.Height - m_SH
    Me.Width = Me.Width - m_SW
    Me.Height = Me.Height - m_SH
    Command1.Left = Command1.Left - m_SW
    Command1.Top = Command1.Top - m_SH
End Sub
Public Sub ResetSmallSize()
    Label1.Width = Label1.Width + m_SW
    Label1.Height = Label1.Height + m_SH
    Me.Width = Me.Width + m_SW
    Me.Height = Me.Height + m_SH
    Command1.Left = Command1.Left + m_SW
    Command1.Top = Command1.Top + m_SH
    Unload Me
End Sub

