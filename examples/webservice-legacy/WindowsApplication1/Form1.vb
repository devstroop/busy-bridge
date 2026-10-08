
Imports System.Net
Imports System.IO
Imports System.Text


Public Class Form1

    Private m_UseName As String = "q" '"bureau" '"rachna"
    Private m_Pwd As String = "q" '"bureau21" '"rachna"

    Private Sub btnExecuteQry_Click(sender As Object, e As EventArgs) Handles btnExecuteQry.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim Qry As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        'Get All SALE Vchs 
        Qry = "Select * from Tran1 where VchType=9"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "1")    'Executes Query and return the resultant Recordset XML
        myWebHeaderCollection.Add("Qry", Qry)
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryXML = ReturnedHTML

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Data - " & res.GetResponseHeader("Content-Length")
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnAddSaleVch_Click(sender As Object, e As EventArgs) Handles btnAddSaleVch.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim XMLStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        XMLStr = "<Sale>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>02-08-2017</Date><VchType>9</VchType><VchNo>1</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1120</Amt><STAmount>120</STAmount><STPercent>6</STPercent><STPercent1>6</STPercent1><TaxBeforeSurcharge>60</TaxBeforeSurcharge><TaxBeforeSurcharge1>60</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1180</Amt><STAmount>180</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>90</TaxBeforeSurcharge><TaxBeforeSurcharge1>90</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Dozen</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1000</Amt><Exempted>True</Exempted><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>330</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>100</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</Sale>"


        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "2")    'Add a voucher
        myWebHeaderCollection.Add("VchType", "9")   'for SALE VchType=9
        myWebHeaderCollection.Add("VchXML", XMLStr)
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "VchCode generated is - " & ReturnedHTML
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnModifySaleVch_Click(sender As Object, e As EventArgs) Handles btnModifySaleVch.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim XMLStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        'To Modify change date of Vch
        XMLStr = "<Sale>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>10-08-2017</Date><VchType>9</VchType><VchNo>1</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1120</Amt><STAmount>120</STAmount><STPercent>6</STPercent><STPercent1>6</STPercent1><TaxBeforeSurcharge>60</TaxBeforeSurcharge><TaxBeforeSurcharge1>60</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1180</Amt><STAmount>180</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>90</TaxBeforeSurcharge><TaxBeforeSurcharge1>90</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Dozen</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1000</Amt><Exempted>True</Exempted><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>330</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>100</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</Sale>"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "3")    'Modify Vch By Key
        myWebHeaderCollection.Add("VchType", "9")   'for SALE VchType=9
        myWebHeaderCollection.Add("VchXML", XMLStr)
        myWebHeaderCollection.Add("ModifyKey", "3") 'ModifyKey = 3 = VchNo + Series + Date
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnModifyByVchCode_Click(sender As Object, e As EventArgs) Handles btnModifyByVchCode.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim XMLStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        'To Modify change date of Vch
        XMLStr = "<Sale>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>10-08-2017</Date><VchType>9</VchType><VchNo>1</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1120</Amt><STAmount>120</STAmount><STPercent>6</STPercent><STPercent1>6</STPercent1><TaxBeforeSurcharge>60</TaxBeforeSurcharge><TaxBeforeSurcharge1>60</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1180</Amt><STAmount>180</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>90</TaxBeforeSurcharge><TaxBeforeSurcharge1>90</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Dozen</UnitName><Qty>1</Qty><Price>1000</Price><Amt>1000</Amt><Exempted>True</Exempted><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>330</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>100</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</Sale>"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "4")    'Modify Vch By VchCode
        myWebHeaderCollection.Add("VchType", "9")   'for SALE VchType=9
        myWebHeaderCollection.Add("VchXML", XMLStr)
        myWebHeaderCollection.Add("VchCode", "2")
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnAddMaster_Click(sender As Object, e As EventArgs) Handles btnAddMaster.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim XMLStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        'Account Master with only Mandatory Fields
        XMLStr = "<Account><Name>Acc1</Name><ParentGroup>Sundry Creditors</ParentGroup></Account>"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "5")    'Adds a New Master
        myWebHeaderCollection.Add("MasterType", "2")   'for Account Master, MasterType=2
        myWebHeaderCollection.Add("MasterXML", XMLStr)
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnModifyMaster_Click(sender As Object, e As EventArgs) Handles btnModifyMaster.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim XMLStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        'Modify Address Details in Account Master
        XMLStr = "<Account><Name>Acc1</Name><ParentGroup>Sundry Creditors</ParentGroup></Account>"
        XMLStr = XMLStr & "<Address>"
        XMLStr = XMLStr & "<Address1>Add1</Address1><Address2>Add2</Address2><Address3>Add3</Address3><Address4>Add4</Address4><TelNo>01127371780</TelNo><Fax>123456789</Fax><Email>rachna.sapra@busy.in</Email>"
        XMLStr = XMLStr & "<GSTNo>GSTNo</GSTNo><Mobile>1234567890</Mobile><ITPAN>ABC123</ITPAN><TINNo>ABC123</TINNo><OF><OF0>A</OF0><OF1>B</OF1><OF2>C</OF2></OF><CountryCode>1141</CountryCode><StateCode>302</StateCode><RegionCode>304</RegionCode>"
        XMLStr = XMLStr & "</Address>"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "6")    'Modify a Master through XML string (by its Code)
        myWebHeaderCollection.Add("MasterCode", "1026")   'Specify Master Code that is to be modified
        myWebHeaderCollection.Add("MasterXML", XMLStr)
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnModifyMasterByName_Click(sender As Object, e As EventArgs) Handles btnModifyMasterByName.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim XMLStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        'Modify Address Details in Account Master
        XMLStr = "<Account><Name>Acc1</Name><ParentGroup>Sundry Creditors</ParentGroup></Account>"
        XMLStr = XMLStr & "<Address>"
        XMLStr = XMLStr & "<Address1>Add1</Address1><Address2>Add2</Address2><Address3>Add3</Address3><Address4>Add4</Address4><TelNo>01127371780</TelNo><Fax>123456789</Fax><Email>rachna.sapra@busy.in</Email>"
        XMLStr = XMLStr & "<GSTNo>GSTNo</GSTNo><Mobile>1234567890</Mobile><ITPAN>ABC123</ITPAN><TINNo>ABC123</TINNo><OF><OF0>A</OF0><OF1>B</OF1><OF2>C</OF2></OF><CountryCode>1141</CountryCode><StateCode>302</StateCode><RegionCode>304</RegionCode>"
        XMLStr = XMLStr & "</Address>"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "7") 'Modify a master through XML string (by its Name)
        myWebHeaderCollection.Add("MasterName", "Acc1")   'Specify Master Code that is to be modified
        myWebHeaderCollection.Add("MasterXML", XMLStr)
        myWebHeaderCollection.Add("MasterType", "2")    'For Account Master, MasterType=2
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnAddJrnlVch_Click(sender As Object, e As EventArgs) Handles btnAddJrnlVch.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim XMLStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader
        Dim QryXML As String
        Dim QryResult As String



        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        XMLStr = "<Journal>"
        XMLStr = XMLStr & "<VchSeriesName>Namhatta</VchSeriesName><Date>01-08-2017</Date><VchType>16</VchType>"
        XMLStr = XMLStr & "<AccEntries>"
        XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>2</AmountType><AmtMainCur>5000</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>Travelling Expenses</AccountName><AmountType>1</AmountType><AmtMainCur>2000</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>Advertisement &amp; Publicity</AccountName><AmountType>1</AmountType><AmtMainCur>2000</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>Books &amp; Periodicals</AccountName><AmountType>1</AmountType><AmtMainCur>1000</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "</AccEntries>"
        XMLStr = XMLStr & "</Journal>"


        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "2")    'Adds voucher through XML string
        myWebHeaderCollection.Add("VchType", "16")   'for Journal VchType=16
        myWebHeaderCollection.Add("VchXML", XMLStr)
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        QryResult = res.GetResponseHeader("Result")
        If QryResult = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "VchCode generated is - " & ReturnedHTML
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnOpenDB_Click(sender As Object, e As EventArgs) Handles btnOpenDB.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader

        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "51")   'Opens an Access Company
        myWebHeaderCollection.Add("CompCode", "Comp0008")
        myWebHeaderCollection.Add("UserName", m_UseName)
        myWebHeaderCollection.Add("Pwd", m_Pwd)

        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        RetVal = res.GetResponseHeader("Result")
        If RetVal = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Company Open successfully"
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub

    Private Sub btnCloseDB_Click(sender As Object, e As EventArgs) Handles btnCloseDB.Click
        Dim WinHTTP As HttpWebRequest
        Dim res As HttpWebResponse
        Dim UrlStr As String
        Dim RetVal As String = ""
        Dim ReturnedHTML As String = ""
        Dim sbSource As StringBuilder
        Dim reader As StreamReader

        UrlStr = "http://localhost:981"
        '    UrlStr = "http://192.168.0.32:981"

        WinHTTP = WebRequest.Create(UrlStr)

        WinHTTP.Method = "GET"

        Dim myWebHeaderCollection As New WebHeaderCollection

        myWebHeaderCollection.Add("SC", "52")   'Close a company
        
        WinHTTP.Headers = myWebHeaderCollection

        res = WinHTTP.GetResponse

        ' Get the stream associated with the response. 
        reader = New StreamReader(res.GetResponseStream())

        sbSource = New StringBuilder(reader.ReadToEnd())

        ReturnedHTML = sbSource.ToString()

        RetVal = res.GetResponseHeader("Result")
        If RetVal = "T" Then
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Company closed successfully"
        Else
            Label1.Text = "Result - " & res.GetResponseHeader("Result")
            Label1.Text = Label1.Text & vbCrLf & "Err Desc - " & res.GetResponseHeader("Description")
        End If

        WinHTTP = Nothing

    End Sub
End Class
