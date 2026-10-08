Public Class Form1

    Private Sub btnSaveAcc_Click(sender As Object, e As EventArgs) Handles btnSaveAcc.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim ErrMsg As String = ""

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY16 is installed then use below line of code
        FI = CreateObject("Busy2L17.CFixedInterface")

        'If BUSY14 is installed then plz uncomment below line
        'Set FI = CreateObject("Busy2L16.CFixedInterface")


        'Opens the Busy database - SQL server
        FI.opencsdb("C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0012")
        'OpenCSDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"Rachna" - SQL Server Name
        '"sa" - SQL Server UserName
        '"busy" - SQL Server Password
        '"BusyComp0003" - Busy Company Code

        ''    Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0010"
        ''    OpenDB function has following parameters
        ''    "C:\Busywin\" - BusyPath where Busy is installed
        ''    "D:\Busy Data" - DataPath where Busy Data is stored
        ''    "BusyComp0006" - Busy Company Code


        'XML without BillByBill References
        'XMLStr = "<Account><Name>Acc1</Name><ParentGroup>Sundry Creditors</ParentGroup></Account>"


        'With BillByBill References
        XMLStr = "<Account><Name>ABC</Name><ParentGroup>Sundry Creditors</ParentGroup><OPBal>-10000</OPBal><PYBal>-10000</PYBal><BillByBillBalancing>True</BillByBillBalancing>"
        XMLStr = XMLStr & "<BillByBillDetail>"
        XMLStr = XMLStr & "<BillReference><Method>1</Method><SrNo>1</SrNo><RefNo>Ref1</RefNo><Date>01-04-2016</Date><DueDate>03-04-2016</DueDate><Value1>-4000</Value1></BillReference>"
        XMLStr = XMLStr & "<BillReference><Method>1</Method><SrNo>2</SrNo><RefNo>Ref2</RefNo><Date>01-04-2016</Date><DueDate>03-04-2016</DueDate><Value1>-6000</Value1></BillReference>"
        XMLStr = XMLStr & "</BillByBillDetail>"
        XMLStr = XMLStr & "<CreditDaysForSale>2</CreditDaysForSale><CreditDaysForPurc>2</CreditDaysForPurc>"
        XMLStr = XMLStr & "</Account>"



        'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        'MasterType for Account Master is 2
        If FI.SaveMasterFromXML(2, XMLStr, ErrMsg) Then
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

    Private Sub btnSaveItem_Click(sender As Object, e As EventArgs) Handles btnSaveItem.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim ErrMsg As String = ""

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        FI = CreateObject("Busy2L17.CFixedInterface")

        'Opens the Busy database - SQL server
        FI.opencsdb("C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0012")
        'OpenCSDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"Rachna" - SQL Server Name
        '"sa" - SQL Server UserName
        '"busy" - SQL Server Password
        '"BusyComp0003" - Busy Company Code

        '    Opens the BUSY Database - MS_Access
        '    FI.OpenDB "C:\Busywin\", "D:\Busy Data", "Comp0009"
        '    OpenDB function has following parameters
        '    "C:\Busywin\" - BusyPath where Busy is installed
        '    "D:\Busy Data" - DataPath where Busy Data is stored
        '    "BusyComp0006" - Busy Company Code


        'Plain Item master with Opening bal
        XMLStr = "<Item><Name>Item10.abc.xyz</Name><ParentGroup>General</ParentGroup><MainUnit>Pcs.</MainUnit><OPStockInMainUnit>10</OPStockInMainUnit><OPAmount>1000</OPAmount></Item>"


        'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        'MasterType for Item Master is 6
        If FI.SaveMasterFromXML(6, XMLStr, ErrMsg) Then
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

    Private Sub btnSaveUnit_Click(sender As Object, e As EventArgs) Handles btnSaveUnit.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim ErrMsg As String = ""

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        FI = CreateObject("Busy2L17.CFixedInterface")

        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0004"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code


        '    Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\Busywin\", "D:\Busy Data", "Comp0010")
        '    OpenDB function has following parameters
        '    "C:\Busywin\" - BusyPath where Busy is installed
        '    "D:\Busy Data" - DataPath where Busy Data is stored
        '    "BusyComp0006" - Busy Company Code


        XMLStr = "<Unit><Name>ABC</Name></Unit>"

        'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        'MasterType for Unit Master is 8
        If FI.SaveMasterFromXML(8, XMLStr, ErrMsg) Then
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

    Private Sub btnSaveBillSundry_Click(sender As Object, e As EventArgs) Handles btnSaveBillSundry.Click
        Dim FI As Object
        Dim XMLStr As String = ""
        Dim ErrMsg As String = ""

        Me.Cursor = System.Windows.Forms.Cursors.WaitCursor

        'If BUSY16 is installed then use below line of code
        FI = CreateObject("Busy2L17.CFixedInterface")

        'If BUSY14 is installed then plz uncomment below line
        'Set FI = CreateObject("Busy2L16.CFixedInterface")


        '    'Opens the Busy database - SQL server
        '    FI.opencsdb "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0004"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0003" - Busy Company Code

        '    Opens the BUSY Database - MS_Access
        FI.OpenDB("C:\Busywin\", "D:\Busy Data", "Comp0010")
        '    OpenDB function has following parameters
        '    "C:\Busywin\" - BusyPath where Busy is installed
        '    "D:\Busy Data" - DataPath where Busy Data is stored
        '    "BusyComp0006" - Busy Company Code


        XMLStr = "<BillSundry><Name>Discount1</Name><PrintName>Discount</PrintName><SubTotalDesc>Total</SubTotalDesc><BSNature>Discount</BSNature>"
        XMLStr = XMLStr & "<AffectAccountingInSale>True</AffectAccountingInSale><AffectAccountingInPurc>True</AffectAccountingInPurc><AffactSale>True</AffactSale><AffactPurc>True</AffactPurc><AdjustInSaleAmt>True</AdjustInSaleAmt><AdjustInPurcAmt>True</AdjustInPurcAmt><AdjustSaleInPartyAmt>True</AdjustSaleInPartyAmt><AdjustPurcInPartyAmt>True</AdjustPurcInPartyAmt>"
        XMLStr = XMLStr & "<AmountBasis>1</AmountBasis><PointOfCalculation>2</PointOfCalculation><PercentOfAmount>100</PercentOfAmount><NoOfPBS>1</NoOfPBS>"
        XMLStr = XMLStr & "<Type>0</Type></BillSundry>"

        'Type = 0 ; For Subtractive
        'Type = 1 ; For Additive

        'Amount Basis ABSOLUTE = 0
        'Amount Basis PERCENTAGE = 1
        'Amount Basis MAINQTY = 2
        'Amount Basis BS_ALTQTY = 3

        'POINT OF CALCULATION BASIC_AMT = 0
        'POINT OF CALCULATION MRP_AMT = 1
        'POINT OF CALCULATION NETT_AMT = 2
        'POINT OF CALCULATION PREVBS_AMT = 4
        'POINT OF CALCULATION TOTAL_AMT = 5
        'POINT OF CALCULATION TAXABLE_AMT = 6
        'POINT OF CALCULATION LIST_PRICE = 7
        'POINT OF CALCULATION OTHER_BSMAST_AMT = 8
        'POINT OF CALCULATION OTHER_BSMAST_APPLIED_ON = 9


        'Function Defination in Busy - SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean
        'MasterType for Bill Sundry Master is 9
        If FI.SaveMasterFromXML(9, XMLStr, ErrMsg) Then
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
End Class
