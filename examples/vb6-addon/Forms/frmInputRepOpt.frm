VERSION 5.00
Begin VB.Form frmInputRepOpt 
   BackColor       =   &H8000000C&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Set Report Options"
   ClientHeight    =   3360
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5310
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3360
   ScaleWidth      =   5310
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdQuit 
      Caption         =   "Quit"
      Height          =   375
      Left            =   2160
      TabIndex        =   3
      Top             =   2040
      Width           =   975
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   375
      Left            =   1080
      TabIndex        =   2
      Top             =   2040
      Width           =   975
   End
   Begin VB.TextBox txtEndDate 
      Height          =   285
      Left            =   2040
      TabIndex        =   1
      Top             =   1080
      Width           =   1335
   End
   Begin VB.TextBox txtStartDate 
      Height          =   285
      Left            =   2040
      TabIndex        =   0
      Top             =   600
      Width           =   1335
   End
   Begin VB.Label lblEndDate 
      BackColor       =   &H8000000C&
      Caption         =   "End Date"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   480
      TabIndex        =   5
      Top             =   1080
      Width           =   1335
   End
   Begin VB.Label lblStartDate 
      BackColor       =   &H8000000C&
      Caption         =   "Start Date"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   480
      TabIndex        =   4
      Top             =   600
      Width           =   1335
   End
End
Attribute VB_Name = "frmInputRepOpt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public RepID As Integer


Private Sub cmdOk_Click()

    Dim fRep As frmReport

    Set fRep = New frmReport
    fRep.SetInputValues Text2Date(txtStartDate.Text), Text2Date(txtEndDate.Text)
    fRep.ShowForm
    Set fRep = Nothing

End Sub

Private Sub cmdQuit_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim Col As Collection
    Dim i As Integer

    Screen.MousePointer = vbHourglass

    txtStartDate.Text = Format(g_CC.BegFY, "dd-mm-yyyy")
    txtEndDate.Text = Format(GetLastVchDate, "dd-mm-yyyy")

    SetForm

    Screen.MousePointer = vbDefault

End Sub

Private Sub SetForm()

    lblStartDate.Top = lblStartDate.Top - 300
    txtStartDate.Top = lblStartDate.Top

    lblEndDate.Top = lblEndDate.Top - 300
    txtEndDate.Top = lblEndDate.Top

    cmdOk.Top = cmdOk.Top - 300
    cmdQuit.Top = cmdOk.Top

    Me.Height = Me.Height - 300
End Sub
