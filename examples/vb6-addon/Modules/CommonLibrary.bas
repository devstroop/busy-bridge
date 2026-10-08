Attribute VB_Name = "CommonLibrary"
Option Explicit

Public Function DateStr(p_Date As Date) As String
    If g_Provider = DB_JET Then
        DateStr = "#" & Format(p_Date, "mm-dd-yyyy") & "#"
    Else
        DateStr = "'" & Format(p_Date, "mm-dd-yyyy") & "'"
    End If
End Function
Public Sub FlushCol(ByRef p_COl As Collection)
    Set p_COl = Nothing
    Set p_COl = New Collection
End Sub
Public Function DateRangeStr(p_StartDate As Date, p_EndDate As Date) As String
    If g_Provider = DB_JET Then
        DateRangeStr = "#" & Format(p_StartDate, "mm-dd-yyyy") & "# and #" & Format(p_EndDate, "mm-dd-yyyy") & "#"
    Else
        DateRangeStr = "'" & Format(p_StartDate, "mm-dd-yyyy") & "' And '" & Format(p_EndDate, "mm-dd-yyyy") & "'"
    End If
End Function
Public Function Text2Date(ByVal sStr As String) As Date
    Dim sComp1 As String
    Dim sComp2 As String
    Dim sComp3 As String
    Dim sTempStr As String
    Dim nPos As Integer
    Dim nLen As Integer
    Dim nCompNo As Integer
    Dim i As Integer
    Dim nYear As Integer
    Dim DayVal As Integer, MonthVal As Integer, YearVal As Integer

    On Error GoTo ErrHandler

    nLen = Len(sStr)

    nCompNo = 1

    For i = 1 To nLen

        sTempStr = Mid$(sStr, i, 1)

        If Asc(sTempStr) >= vbKey0 And Asc(sTempStr) <= vbKey9 Then

            Select Case nCompNo

                    Case 1
                            sComp1 = sComp1 + sTempStr

                    Case 2
                            sComp2 = sComp2 + sTempStr

                    Case 3
                            sComp3 = sComp3 + sTempStr

            End Select
        Else
            nCompNo = nCompNo + 1
            If nCompNo > 3 Then GoTo ErrHandler
        End If
    Next

    If Len(sComp3) = 1 Or Len(sComp3) = 3 Then
        GoTo ErrHandler
    End If

    If Len(sComp3) = 2 Then
        nYear = CInt(Left$(sComp3, 2))

        If nYear < 80 Then
            nYear = nYear + 2000
        Else
            nYear = nYear + 1900
        End If

        sComp3 = CStr(nYear)
    End If

    If g_CC.DateFormat = DD_MM_YYYY Then
        DayVal = CInt(sComp1)
        MonthVal = CInt(sComp2)
    Else
        MonthVal = CInt(sComp1)
        DayVal = CInt(sComp2)
    End If

    YearVal = CInt(sComp3)

    sTempStr = MonthName(MonthVal) & " " & CStr(DayVal) & " " & CStr(YearVal)

    Text2Date = CDate(sTempStr)

    Exit Function

ErrHandler:

    Text2Date = 0

End Function

Public Function MakeNodeValue(Doc As MSXML2.DOMDocument, Node As MSXML2.IXMLDOMNode, p_NodeStr As String, p_NodeVal As Variant, p_NodeDataType As Integer) As MSXML2.IXMLDOMNode
    Dim NodeChild As MSXML2.IXMLDOMNode
        
    Set NodeChild = Node.appendChild(Doc.createElement(p_NodeStr))
    NodeChild.Text = p_NodeVal
    
    Set MakeNodeValue = NodeChild
    
End Function
