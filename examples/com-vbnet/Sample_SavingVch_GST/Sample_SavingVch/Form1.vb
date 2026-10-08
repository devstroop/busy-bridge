Public Class Form1

    Private Sub btnSaleIgst_Click(sender As Object, e As EventArgs) Handles btnSaleIgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        'If BUSY 17 is installed, then plz use the below code
        FI = CreateObject("Busy2L17.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code



        'Opens the BUSY Database - MS_Access
        'FI.OpenDB("C:\Busywin\", "D:\Data", "Comp0010")
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 9    'For SALE vch. Vchtype=9

        XMLStr = "<Sale>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>9</VchType><VchNo>1</VchNo><STPTName>I/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>28</STPercent><TaxBeforeSurcharge>28</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>18</STPercent><TaxBeforeSurcharge>9</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>0.5</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</Sale>"





        ''Save XML string in Busy
        ''Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub
    Private Sub btnSaleLgst_Click(sender As Object, e As EventArgs) Handles btnSaleLgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        'If BUSY 17 is installed, then plz use the below code
        FI = CreateObject("Busy2L17.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code



        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 9    'For SALE vch. Vchtype=9


        XMLStr = "<Sale>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>9</VchType><VchNo>2</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>14</STPercent><STPercent1>14</STPercent1><TaxBeforeSurcharge>14</TaxBeforeSurcharge><TaxBeforeSurcharge1>14</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>4.5</TaxBeforeSurcharge><TaxBeforeSurcharge1>4.5</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>2.5</STPercent><STPercent1>2.5</STPercent1><TaxBeforeSurcharge>0.25</TaxBeforeSurcharge><TaxBeforeSurcharge1>0.25</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</Sale>"





        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnSaleRetIgst_Click(sender As Object, e As EventArgs) Handles btnSaleRetIgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor
        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 3    'For SALE RETURN vch. Vchtype=3

        XMLStr = "<SaleReturn>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>3</VchType><VchNo>1</VchNo><STPTName>I/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>28</STPercent><TaxBeforeSurcharge>28</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>18</STPercent><TaxBeforeSurcharge>9</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>0.5</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</SaleReturn>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnSaleRetLgst_Click(sender As Object, e As EventArgs) Handles btnSaleRetLgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor
        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 3    'For SALE RETURN vch. Vchtype=3

        XMLStr = "<SaleReturn>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>3</VchType><VchNo>2</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>14</STPercent><STPercent1>14</STPercent1><TaxBeforeSurcharge>14</TaxBeforeSurcharge><TaxBeforeSurcharge1>14</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>4.5</TaxBeforeSurcharge><TaxBeforeSurcharge1>4.5</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>2.5</STPercent><STPercent1>2.5</STPercent1><TaxBeforeSurcharge>0.25</TaxBeforeSurcharge><TaxBeforeSurcharge1>0.25</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</SaleReturn>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnPurcIgst_Click(sender As Object, e As EventArgs) Handles btnPurcIgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        '    'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code



        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 2    'For PURCHASE vch. Vchtype=2


        XMLStr = "<Purchase>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>2</VchType><VchNo>1</VchNo><STPTName>I/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>28</STPercent><TaxBeforeSurcharge>28</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>18</STPercent><TaxBeforeSurcharge>9</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>0.5</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"

        XMLStr = XMLStr & "</Purchase>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub
    Private Sub btnPurcLgst_Click(sender As Object, e As EventArgs) Handles btnPurcLgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        '    'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code



        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 2    'For PURCHASE vch. Vchtype=2


        XMLStr = "<Purchase>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>2</VchType><VchNo>2</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>14</STPercent><STPercent1>14</STPercent1><TaxBeforeSurcharge>14</TaxBeforeSurcharge><TaxBeforeSurcharge1>14</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>4.5</TaxBeforeSurcharge><TaxBeforeSurcharge1>4.5</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>2.5</STPercent><STPercent1>2.5</STPercent1><TaxBeforeSurcharge>0.25</TaxBeforeSurcharge><TaxBeforeSurcharge1>0.25</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"

        XMLStr = XMLStr & "</Purchase>"


        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnPurcRetIgst_Click(sender As Object, e As EventArgs) Handles btnPurcRetIgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 10    'For PURCHASE RETURN vch. Vchtype=10


        XMLStr = XMLStr & "<PurchaseReturn>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>10</VchType><VchNo>1</VchNo><STPTName>I/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>28</STPercent><TaxBeforeSurcharge>28</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>18</STPercent><TaxBeforeSurcharge>9</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>0.5</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</PurchaseReturn>"

        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub
    Private Sub btnPurcRetLgst_Click(sender As Object, e As EventArgs) Handles btnPurcRetLgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 10    'For PURCHASE RETURN vch. Vchtype=10


        XMLStr = XMLStr & "<PurchaseReturn>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>10</VchType><VchNo>2</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"
        XMLStr = XMLStr & "<VchOtherInfoDetails><Narration1>Sample Narration</Narration1></VchOtherInfoDetails>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>14</STPercent><STPercent1>14</STPercent1><TaxBeforeSurcharge>14</TaxBeforeSurcharge><TaxBeforeSurcharge1>14</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>4.5</TaxBeforeSurcharge><TaxBeforeSurcharge1>4.5</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Kgs.</UnitName><Qty>1</Qty><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>2.5</STPercent><STPercent1>2.5</STPercent1><TaxBeforeSurcharge>0.25</TaxBeforeSurcharge><TaxBeforeSurcharge1>0.25</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"
        XMLStr = XMLStr & "</PurchaseReturn>"

        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnJrnl_Click(sender As Object, e As EventArgs) Handles btnJrnl.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0005")
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored                                                           
        '"BusyComp0006" - Busy Company Code                                                                             


        VchType = 16   'For Journal vch. Vchtype=16    

        'For Gst nature "Not Applicable"
        'XMLStr = XMLStr & "<Journal>"
        'XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>16</VchType><VchNo>1</VchNo>"

        'XMLStr = XMLStr & "<AccEntries>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Office Maintenance Expenses</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>SBI</AccountName><AmountType>2</AmountType><AmtMainCur>112</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "</AccEntries>"

        'XMLStr = XMLStr & "</Journal>"


        XMLStr = XMLStr & "<Journal>"
        'GSTRectype=61 (for Gst nature "Consolidate RCM Payable")
        'GSTRectype=63 (for Gst nature "Registered Expense(B2B)")
        'GSTRectype=66 (for Gst nature "Tax Paid Expense(B2C)")
        'GSTRectype=65 (for Gst nature "ExemptExpense")
        'GSTRectype=70 (for Gst nature "Composition Expense")
        'GSTRectype=62 (for Gst nature "RCM/Unreg.Expense")
        'GSTRectype=1 (for Gst nature "GST Payment to Government")
        'GSTRectype=2 (for Gst nature "GST Tax Adjustments")
        'GSTRectype=54 (for Gst nature "Cr.Note received against purchase")
        'GSTRectype=53 (for Gst nature "Dr.Note received against purchase")

        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>16</VchType><VchNo>1</VchNo><GSTRectype>63</GSTRectype>"

        XMLStr = XMLStr & "<AccEntries>"
        XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Office Maintenance Expenses</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>SBI</AccountName><AmountType>2</AmountType><AmtMainCur>112</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "</AccEntries>"

        XMLStr = XMLStr & "<VchGstSumAcc>"
        XMLStr = XMLStr & "<PartyName>Busy Infotech Pvt. Ltd.</PartyName>"
        XMLStr = XMLStr & "<ItemGstDet><HSNCode>009</HSNCode><ITCEligibility>1</ITCEligibility><ItemName>Office Maintenance Expenses</ItemName><ItemSrNo>1</ItemSrNo><OrgVchDate>01-04-2018</OrgVchDate><OrgVchNo>001</OrgVchNo><TaxableAmt>100</TaxableAmt><TaxAmt>6</TaxAmt><TaxAmt1>6</TaxAmt1><TaxPercent>6</TaxPercent><TaxPercent1>6</TaxPercent1><UnitName>Pcs.</UnitName></ItemGstDet>"
        XMLStr = XMLStr & "</VchGstSumAcc>"

        XMLStr = XMLStr & "</Journal>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnCreditNote_Click(sender As Object, e As EventArgs) Handles btnSaveCreditNote.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0005")
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 18    'For Credit Note vch. Vchtype=18

        'For Gst nature "Not Applicable"
        'XMLStr = XMLStr & "<CrNote>"
        'XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>17</VchType><VchNo>1</VchNo><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1>"

        'XMLStr = XMLStr & "<AccEntries>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>2</AmountType><AmtMainCur>105</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>Sales</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "</AccEntries>"

        'XMLStr = XMLStr & "</CrNote>"


        XMLStr = XMLStr & "<CrNote>"
        'GSTRectype=51 (for Gst nature "Dr. note issued against sale")
        'GSTRectype=52 (for Gst nature "Cr. note issued against sale")
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>18</VchType><VchNo>1</VchNo><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><GSTRectype>52</GSTRectype>"

        XMLStr = XMLStr & "<AccEntries>"
        XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>2</AmountType><AmtMainCur>105</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>Sales</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "</AccEntries>"
        'Reason=0 (for Reason "07-Others")
        'Reason=1 (for Reason "02-Post Sale/Purc Discount")
        'Reason=2 (for Reason "03-Deficiency in services")
        'Reason=3 (for Reason "04-Correction in invoice")
        'Reason=4 (for Reason "05-Change in pos")
        'Reason=5 (for Reason "06-Finalization of provisional assessment")
        'Reason=6 (for Reason "01-Sale/Purc Return")
        XMLStr = XMLStr & "<VchGstSumAcc>"
        XMLStr = XMLStr & "<PartyName>Busy Infotech Pvt. Ltd.</PartyName><Reason>6</Reason>"
        XMLStr = XMLStr & "<ItemGstDet><HSNCode>123</HSNCode><ITCEligibility>1</ITCEligibility><ItemSrNo>1</ItemSrNo><OrgVchDate>01-04-2018</OrgVchDate><OrgVchNo>01</OrgVchNo><TaxableAmt>100</TaxableAmt><TaxAmt>2.5</TaxAmt><TaxAmt1>2.5</TaxAmt1><TaxPercent>2.5</TaxPercent><TaxPercent1>2.5</TaxPercent1><UnitName>Pcs.</UnitName></ItemGstDet>"
        XMLStr = XMLStr & "</VchGstSumAcc>"

        XMLStr = XMLStr & "</CrNote>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnDebitNote_Click(sender As Object, e As EventArgs) Handles btnSaveDebitNote.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0


        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0005")
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 17    'For Dedit Note vch. Vchtype=17

        'For Gst nature "Not Applicable"

        'XMLStr = XMLStr & "<DrNote>"
        'XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>17</VchType><VchNo>1</VchNo><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1>"

        'XMLStr = XMLStr & "<AccEntries>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>1</AmountType><AmtMainCur>105</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>2</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>2</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>Sales</AccountName><AmountType>2</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "</AccEntries>"

        'XMLStr = XMLStr & "</DrNote>"


        XMLStr = XMLStr & "<DrNote>"
        'GSTRectype=51 (for Gst nature "Dr. note issued against sale")
        'GSTRectype=52 (for Gst nature "Cr. note issued against sale")
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>17</VchType><VchNo>1</VchNo><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><GSTRectype>51</GSTRectype>"

        XMLStr = XMLStr & "<AccEntries>"
        XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>1</AmountType><AmtMainCur>105</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>2</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>2</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>Sales</AccountName><AmountType>2</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "</AccEntries>"
        'Reason=0 (for Reason "07-Others")
        'Reason=1 (for Reason "02-Post Sale/Purc Discount")
        'Reason=2 (for Reason "03-Deficiency in services")
        'Reason=3 (for Reason "04-Correction in invoice")
        'Reason=4 (for Reason "05-Change in pos")
        'Reason=5 (for Reason "06-Finalization of provisional assessment")
        'Reason=6 (for Reason "01-Sale/Purc Return")
        XMLStr = XMLStr & "<VchGstSumAcc>"
        XMLStr = XMLStr & "<PartyName>Busy Infotech Pvt. Ltd.</PartyName><Reason>6</Reason>"
        XMLStr = XMLStr & "<ItemGstDet><HSNCode>123</HSNCode><ITCEligibility>1</ITCEligibility><ItemSrNo>1</ItemSrNo><OrgVchDate>01-04-2018</OrgVchDate><OrgVchNo>01</OrgVchNo><TaxableAmt>100</TaxableAmt><TaxAmt>2.5</TaxAmt><TaxAmt1>2.5</TaxAmt1><TaxPercent>2.5</TaxPercent><TaxPercent1>2.5</TaxPercent1><UnitName>Pcs.</UnitName></ItemGstDet>"
        XMLStr = XMLStr & "</VchGstSumAcc>"

        XMLStr = XMLStr & "</DrNote>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnSaveReceipt_Click(sender As Object, e As EventArgs) Handles btnSaveReceipt.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0


        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0005")
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 14    'For Receipt vch. Vchtype=14

        'For Gst nature "Not Applicable"

        'XMLStr = XMLStr & "<Receipt>"
        'XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>14</VchType><VchNo>1</VchNo>"

        'XMLStr = XMLStr & "<AccEntries>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>2</AmountType><AmtMainCur>105</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>SBI</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "</AccEntries>"

        'XMLStr = XMLStr & "</Receipt>"


        XMLStr = XMLStr & "<Receipt>"
        'GSTRectype=56 (for Gst nature "Advance receipt")
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>14</VchType><VchNo>1</VchNo><GSTRectype>56</GSTRectype>"


        XMLStr = XMLStr & "<AccEntries>"
        XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Busy Infotech Pvt. Ltd.</AccountName><AmountType>2</AmountType><AmtMainCur>105</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>2.5</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>SBI</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "</AccEntries>"

        XMLStr = XMLStr & "<VchGstSumAcc>"
        XMLStr = XMLStr & "<PartyName>Busy Infotech Pvt. Ltd.</PartyName>"
        XMLStr = XMLStr & "<ItemGstDet><ItemSrNo>1</ItemSrNo><OrgVchNo>01</OrgVchNo><TaxableAmt>100</TaxableAmt><TaxAmt>2.5</TaxAmt><TaxAmt1>2.5</TaxAmt1><TaxPercent>2.5</TaxPercent><TaxPercent1>2.5</TaxPercent1></ItemGstDet>"
        XMLStr = XMLStr & "</VchGstSumAcc>"

        XMLStr = XMLStr & "</Receipt>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing

    End Sub

    Private Sub btnSavePayment_Click(sender As Object, e As EventArgs) Handles btnSavePayment.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0005")
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored                                                           
        '"BusyComp0006" - Busy Company Code                                                                             


        VchType = 19   'For Payment vch. Vchtype=19    

        'For Gst nature "Not Applicable"
        'XMLStr = XMLStr & "<Payment>"
        'XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>19</VchType><VchNo>1</VchNo>"

        'XMLStr = XMLStr & "<AccEntries>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Office Maintenance Expenses</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>SBI</AccountName><AmountType>2</AmountType><AmtMainCur>112</AmtMainCur></AccDetail>"
        'XMLStr = XMLStr & "</AccEntries>"

        'XMLStr = XMLStr & "</Payment>"

        XMLStr = XMLStr & "<Payment>"
        'GSTRectype=67 (for Gst nature "Advance payment to Unreg-Dealer")
        'GSTRectype=63 (for Gst nature "Registered Expense(B2B)")
        'GSTRectype=66 (for Gst nature "Tax Paid Expense(B2C)")
        'GSTRectype=65 (for Gst nature "ExemptExpense")
        'GSTRectype=70 (for Gst nature "Composition Expense")
        'GSTRectype=62 (for Gst nature "RCM/Unreg.Expense")
        'GSTRectype=1 (for Gst nature "GST Payment to Government")
        'GSTRectype=57 (for Gst nature "Refund against Advance Receipt")

        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2018</Date><VchType>19</VchType><VchNo>1</VchNo><GSTRectype>63</GSTRectype>"

        XMLStr = XMLStr & "<AccEntries>"
        XMLStr = XMLStr & "<AccDetail><SrNo>1</SrNo><AccountName>Office Maintenance Expenses</AccountName><AmountType>1</AmountType><AmtMainCur>100</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>2</SrNo><AccountName>CGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>3</SrNo><AccountName>SGST Output</AccountName><AmountType>1</AmountType><AmtMainCur>6</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "<AccDetail><SrNo>4</SrNo><AccountName>SBI</AccountName><AmountType>2</AmountType><AmtMainCur>112</AmtMainCur></AccDetail>"
        XMLStr = XMLStr & "</AccEntries>"

        XMLStr = XMLStr & "<VchGstSumAcc>"
        XMLStr = XMLStr & "<PartyName>Busy Infotech Pvt. Ltd.</PartyName>"
        XMLStr = XMLStr & "<ItemGstDet><HSNCode>009</HSNCode><ITCEligibility>1</ITCEligibility><ItemName>Office Maintenance Expenses</ItemName><ItemSrNo>1</ItemSrNo><OrgVchDate>01-04-2018</OrgVchDate><OrgVchNo>001</OrgVchNo><TaxableAmt>100</TaxableAmt><TaxAmt>6</TaxAmt><TaxAmt1>6</TaxAmt1><TaxPercent>6</TaxPercent><TaxPercent1>6</TaxPercent1><UnitName>Pcs.</UnitName></ItemGstDet>"
        XMLStr = XMLStr & "</VchGstSumAcc>"

        XMLStr = XMLStr & "</Payment>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnPurcOrdIgst_Click(sender As Object, e As EventArgs) Handles btnPurcOrdIgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        '    'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code



        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 13    'For PURCHASE ORDER vch. Vchtype=13


        XMLStr = "<PurchaseOrder>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>13</VchType><VchNo>1</VchNo><STPTName>I/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>1</QtyAltUnit><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>28</STPercent><TaxBeforeSurcharge>28</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>1</QtyAltUnit><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>18</STPercent><TaxBeforeSurcharge>9</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>1</QtyAltUnit><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>5</STPercent><TaxBeforeSurcharge>0.5</TaxBeforeSurcharge><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"

        XMLStr = XMLStr & "<PendingOrders>"
        XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 1</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
        XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>1</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-1</Value1><Value2>-1</Value2><ItemSrNo>1</ItemSrNo><tmpMasterCode1>40279</tmpMasterCode1><tmpMasterCode2>40276</tmpMasterCode2></OrderRefs>"
        XMLStr = XMLStr & "</OrderDetail>"

        XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 2</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
        XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>1</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-1</Value1><Value2>-1</Value2><ItemSrNo>2</ItemSrNo><tmpMasterCode1>40280</tmpMasterCode1><tmpMasterCode2>40276</tmpMasterCode2></OrderRefs>"
        XMLStr = XMLStr & "</OrderDetail>"

        XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 3</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
        XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>1</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-1</Value1><Value2>-1</Value2><ItemSrNo>3</ItemSrNo><tmpMasterCode1>40286</tmpMasterCode1><tmpMasterCode2>40276</tmpMasterCode2></OrderRefs>"
        XMLStr = XMLStr & "</OrderDetail>"
        XMLStr = XMLStr & "</PendingOrders>"

        XMLStr = XMLStr & "</PurchaseOrder>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub
    Private Sub btnPurcOrdLgst_Click(sender As Object, e As EventArgs) Handles btnPurcOrdLgst.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        '    'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0007"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code



        'Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 13    'For PURCHASE ORDER vch. Vchtype=13


        XMLStr = "<PurchaseOrder>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>13</VchType><VchNo>2</VchNo><STPTName>L/GST-ItemWise</STPTName><MasterName1>Busy Infotech Pvt. Ltd.</MasterName1><MasterName2>Main Store</MasterName2>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>Item 1</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>1</QtyAltUnit><Price>100</Price><Amt>128</Amt><STAmount>28</STAmount><STPercent>14</STPercent><STPercent1>14</STPercent1><TaxBeforeSurcharge>14</TaxBeforeSurcharge><TaxBeforeSurcharge1>14</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>Item 2</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>1</QtyAltUnit><Price>50</Price><Amt>59</Amt><STAmount>9</STAmount><STPercent>9</STPercent><STPercent1>9</STPercent1><TaxBeforeSurcharge>4.5</TaxBeforeSurcharge><TaxBeforeSurcharge1>4.5</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>3</SrNo><ItemName>Item 3</ItemName><UnitName>Pcs.</UnitName><Qty>1</Qty><QtyMainUnit>1</QtyMainUnit><QtyAltUnit>1</QtyAltUnit><Price>10</Price><Amt>10.5</Amt><STAmount>0.5</STAmount><STPercent>2.5</STPercent><STPercent1>2.5</STPercent1><TaxBeforeSurcharge>0.25</TaxBeforeSurcharge><TaxBeforeSurcharge1>0.25</TaxBeforeSurcharge1><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<BillSundries>"
        XMLStr = XMLStr & "<BSDetail><SrNo>1</SrNo><BSName>Discount</BSName><PercentVal>10</PercentVal><Amt>19.75</Amt></BSDetail>"
        XMLStr = XMLStr & "<BSDetail><SrNo>2</SrNo><BSName>Freight &amp; Forwarding Charges</BSName><Amt>10</Amt></BSDetail>"
        XMLStr = XMLStr & "</BillSundries>"

        XMLStr = XMLStr & "<PendingOrders>"
        XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 1</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
        XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>2</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-1</Value1><Value2>-1</Value2><ItemSrNo>1</ItemSrNo><tmpMasterCode1>40279</tmpMasterCode1><tmpMasterCode2>40277</tmpMasterCode2></OrderRefs>"
        XMLStr = XMLStr & "</OrderDetail>"

        XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 2</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
        XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>2</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-1</Value1><Value2>-1</Value2><ItemSrNo>2</ItemSrNo><tmpMasterCode1>40280</tmpMasterCode1><tmpMasterCode2>40277</tmpMasterCode2></OrderRefs>"
        XMLStr = XMLStr & "</OrderDetail>"

        XMLStr = XMLStr & "<OrderDetail><MasterName1>Item 3</MasterName1><MasterName2>Busy Infotech Pvt. Ltd.</MasterName2>"
        XMLStr = XMLStr & "<OrderRefs><Method>1</Method><SrNo>1</SrNo><RefNo>2</RefNo><Date>01-04-2016</Date><DueDate>01-04-2016</DueDate><Value1>-1</Value1><Value2>-1</Value2><ItemSrNo>3</ItemSrNo><tmpMasterCode1>40286</tmpMasterCode1><tmpMasterCode2>40277</tmpMasterCode2></OrderRefs>"
        XMLStr = XMLStr & "</OrderDetail>"
        XMLStr = XMLStr & "</PendingOrders>"

        XMLStr = XMLStr & "</PurchaseOrder>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnStkJrnl_Click(sender As Object, e As EventArgs) Handles btnStkJrnl.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim Narration As String = ""
        Dim Amt As Double = 0
        Dim Amt1 As Double = 0
        Dim ErrMsg As String = ""
        Dim AutoVchNo As Long = 0

        '    'If BUSY 16 is installed, then plz use the below code
        '    Set FI = CreateObject("Busy2L16.CFixedInterface")

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY 17 is installed, then plz. uncomment below line
        FI = CreateObject("Busy2L17.CFixedInterface")



        '    'Opens the Busy database - SQL server
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        'Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data" - DataPath where Busy Data is stored
        '"BusyComp0006" - Busy Company Code



        VchType = 8    'For Stock journal vch. Vchtype=8


        XMLStr = XMLStr & "<StockJournal>"
        XMLStr = XMLStr & "<VchSeriesName>Main</VchSeriesName><Date>01-04-2017</Date><VchType>8</VchType><VchNo>1</VchNo><StockUpdationDate>01-04-2016</StockUpdationDate><ConMCName>Main Store</ConMCName><MasterName1>Main Store</MasterName1><MasterName2>Main Store</MasterName2>"

        XMLStr = XMLStr & "<ItemEntries>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>012500</ItemName><UnitName>NOS</UnitName><Qty>1</Qty><Price>100</Price><Amt>100</Amt><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>200.350000.0</ItemName><UnitName>NOS</UnitName><Qty>1</Qty><Price>200</Price><Amt>200</Amt><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries>"

        XMLStr = XMLStr & "<ItemEntries1>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>1</SrNo><ItemName>200A.350000.0</ItemName><UnitName>NOS</UnitName><Qty>1</Qty><Price>22.04</Price><Amt>22.04</Amt><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "<ItemDetail><SrNo>2</SrNo><ItemName>212.090024.0</ItemName><UnitName>NOS</UnitName><Qty>1</Qty><Price>10</Price><Amt>10</Amt><MC>Main Store</MC></ItemDetail>"
        XMLStr = XMLStr & "</ItemEntries1>"

        XMLStr = XMLStr & "</StockJournal>"



        'Save XML string in Busy
        'Function Defination in Busy - SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        If FI.SaveVchFromXML(VchType, XMLStr, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Saved.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub btnDelete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click
        Dim FI As Object
        Dim VchSeries As String = ""
        Dim VchDate As String = ""
        Dim VchType As Integer = 0
        Dim VchNo As String = ""
        Dim ErrMsg As String = ""


        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        FI = CreateObject("Busy2L17.CFixedInterface")

        'Opens the Busy database - SQL server
        FI.OpenDB("C:\BusyWin\", "C:\BusyWin\DATA\", "COMP0004")
        'OpenCSDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"Rachna" - SQL Server Name
        '"sa" - SQL Server UserName
        '"busy" - SQL Server Password
        '"BusyComp0003" - Busy Company Code



        VchSeries = "Main"
        VchDate = Format(CDate("10-04-2016"), "dd-mm-yyyy")  'Date shud be in 'dd-mm-yyyy' format only
        VchType = 9    'For SALE vch. Vchtype=9
        VchNo = "1"

        'Delete Voucher in Busy
        'Function Defination in Busy - DeleteVch(ByVal p_VchType As Variant, ByVal p_VchSeriesName As Variant, ByVal p_VchDate As Variant, ByVal p_VchNo As Variant, ByRef p_ErrStr As Variant) As Boolean
        If FI.DeleteVch(VchType, VchSeries, VchDate, VchNo, ErrMsg) Then
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox("Deleted.")
        Else
            Me.Cursor = System.Windows.Forms.Cursors.Default
            MsgBox(ErrMsg)
        End If

        'Close Busy Company which is opened thru OpenCSDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

    End Sub
End Class
