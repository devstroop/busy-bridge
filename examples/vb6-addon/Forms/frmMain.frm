VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H8000000C&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Sample Internal AddOn"
   ClientHeight    =   4395
   ClientLeft      =   150
   ClientTop       =   420
   ClientWidth     =   6315
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4395
   ScaleWidth      =   6315
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdQuit 
      Caption         =   "Quit"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1560
      TabIndex        =   3
      Top             =   3000
      Width           =   3135
   End
   Begin VB.CommandButton cmdAddPayment 
      Caption         =   "Add Payment Voucher"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1560
      TabIndex        =   2
      Top             =   1560
      Width           =   3135
   End
   Begin VB.CommandButton cmdGenerateReport 
      Caption         =   "Generate Acc Day Book Report"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1560
      TabIndex        =   1
      Top             =   2280
      Width           =   3135
   End
   Begin VB.CommandButton cmdAddSale 
      Caption         =   "Add Sales Voucher"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1560
      TabIndex        =   0
      Top             =   840
      Width           =   3135
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdAddPayment_Click()
    Dim frm As frmAccVch
    
    Set frm = New frmAccVch
    frm.Show vbModal
    Set frm = Nothing
    
End Sub

Private Sub cmdAddSale_Click()
    Dim frm As New frmInvVch
    
    frm.Show vbModal
    Set frm = Nothing
End Sub

Private Sub cmdGenerateReport_Click()
    Dim frm As frmInputRepOpt
    
    Set frm = New frmInputRepOpt
    frm.Show vbModal
    Set frm = Nothing
End Sub

Private Sub cmdQuit_Click()
    CloseApp
End Sub

Private Sub Form_Load()
    Screen.MousePointer = vbDefault
    
    Me.Caption = "Sample Internal AddOn"
End Sub
