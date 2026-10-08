Attribute VB_Name = "MainModule"
Option Explicit

Public g_CC As Object

Public g_Provider As Integer

Public g_FI As Object

Public g_BigNum As Boolean

Public g_BusyPath As String
Public g_DataPath As String
Public g_CompCode As String
Public g_User As String
Public g_PWD As String

Public g_fMain As frmMain

Public g_BusyOpen As Boolean


Public Sub CloseApp()
    
    If g_BusyOpen = True Then
        
        Set g_FI = Nothing
        Set g_CC = Nothing
        
        If Not (g_fMain Is Nothing) Then
            Unload g_fMain
            Set g_fMain = Nothing
        End If
        
    End If
    
End Sub

Public Function LoadVchSeries(ByVal p_VchType As Integer) As Collection
    Dim rstMaster As Recordset
    Dim Col As Collection
    
    FlushCol Col
    
    Set rstMaster = g_FI.GetRecordset("SELECT Name FROM MASTER1 WHERE MASTERTYPE = " & CStr(SERIES_MAST) & " AND I1 = " & p_VchType & " ORDER BY MASTER1.NAME")
    
    With rstMaster
        If .RecordCount > 0 Then
            Do While Not .EOF
                Col.Add MasterName2Series(!Name)
                .MoveNext
            Loop
        End If
    End With
    
    Set LoadVchSeries = Col
    
    Set rstMaster = Nothing
    Set Col = Nothing
    
End Function

Private Function MasterName2Series(p_MasterName As String) As String
    Dim ret As String
    
    ret = Mid$(p_MasterName, 3)
    
    MasterName2Series = ret
    
End Function


Public Function GetLastVchDate() As Date
    Dim Rst As Recordset
    
    GetLastVchDate = g_CC.BegDate
    
    Set Rst = g_FI.GetRecordset("SELECT TOP 1 DATE FROM TRAN1 ORDER BY TRAN1.DATE DESC")
    With Rst
        If .RecordCount > 0 Then
            GetLastVchDate = !Date
        End If
    End With
    
    Set Rst = Nothing
    
End Function


Public Function GetAccList() As Collection
    Dim qry As String
    Dim Rst As Recordset
    Dim RetVal As Collection

    FlushCol RetVal

    qry = "SELECT NAMEALIAS FROM HELP1 WHERE RECTYPE = " & CStr(H1_PARTY) & " AND NAMEORALIAS=" & CStr(NA_NAME)
    Set Rst = g_FI.GetRecordset(qry)

    If Rst.RecordCount > 0 Then
        Rst.MoveFirst
        Do While Not Rst.EOF
            RetVal.Add Rst!NameAlias.Value
            Rst.MoveNext
        Loop
    End If

    Set GetAccList = RetVal

    Set Rst = Nothing

End Function

Public Function GetMastList(p_MastType As Integer) As Collection
    Dim qry As String
    Dim Rst As Recordset
    Dim RetVal As Collection

    FlushCol RetVal

    qry = "SELECT NAME FROM MASTER1 WHERE MASTERTYPE=" & CStr(p_MastType)
    Set Rst = g_FI.GetRecordset(qry)
    
    If Rst.RecordCount > 0 Then
        Rst.MoveFirst
        Do While Not Rst.EOF
            RetVal.Add Rst!Name.Value
            Rst.MoveNext
        Loop
    End If

    Set GetMastList = RetVal

    Set Rst = Nothing

End Function


