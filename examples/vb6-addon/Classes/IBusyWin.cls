VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "IBusyWin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sub ActivateDB(p_Data As Collection)
    
    g_Provider = p_Data(6)

    Set g_FI = p_Data(50)
    
End Sub

Public Sub Start()
    Dim InvalMsg As String
        
    Screen.MousePointer = vbHourglass
    
    g_BusyOpen = True
    
    Set g_CC = CreateObject("Busy2L18.CCompany")
        
    If g_CC.Load(InvalMsg) = False Then
        MsgBox InvalMsg
    End If
    
    Set g_fMain = New frmMain
    g_fMain.Show vbModal
    
    Exit Sub
    
End Sub




