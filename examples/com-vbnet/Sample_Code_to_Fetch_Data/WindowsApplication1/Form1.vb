

Public Class Form1

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

    End Sub

    Private Sub cmdMastList_Click(sender As Object, e As EventArgs) Handles cmdMastList.Click
        On Error Resume Next

        Dim FI As Object
        Dim Qry As String
        Dim RowNo As Long
        Dim UnitQry As String
        Dim PGQry As String
        Dim Rst As DAO.Recordset

        FI = CreateObject("Busy2L17.CFixedInterface")


        '    'Opens the BUSY database - SQL server
        '    FI.OpenCSDB "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0002"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0002" - Busy Company Code

        'OR

        'For Access Mode - To Open BUSY Database
        FI.OpenDB("C:\Busywin\", "D:\Busy Data\", "Comp0009")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data\" - Data Path
        '"Comp0001" - Busy Company Code

        MsgBox("Database Connected")

        RowNo = 0

        SetGrdMastList()
        'Fetch Values from Database through Queries

        PGQry = ",(Select M1.Name from Master1 as M1 where M1.code=Master1.ParentGrp) as ParentGrpName"
        UnitQry = ",(Select M1.Name from Master1 as M1 where M1.code=Master1.CM1) as UnitName"

        Qry = "Select Name,Code,Alias" & PGQry & UnitQry & " from Master1 where Master1.MasterType=6 order by name"
        'This query will return list of all the Item Masters as MasterType=6 belongs to Item Master in Master1 table.

        rst = FI.GetRecordset(Qry)

        If rst.RecordCount > 0 Then
            rst.MoveLast()
            rst.MoveFirst()
            Do While Not rst.EOF
                'MsgBox Trim$(rst!Name.Value)

                DataGridView1.Rows(RowNo).Cells(0).Value = RowNo + 1
                DataGridView1.Rows(RowNo).Cells(1).Value = Rst.Fields("Name").Value.ToString
                DataGridView1.Rows(RowNo).Cells(2).Value = Rst.Fields("Alias").Value.ToString
                DataGridView1.Rows(RowNo).Cells(3).Value = Rst.Fields("UnitName").Value.ToString
                DataGridView1.Rows(RowNo).Cells(4).Value = Rst.Fields("ParentGrpName").Value.ToString

                RowNo = RowNo + 1

                rst.MoveNext()
            Loop
        End If


        'Close Busy Company which is opened thru OpenCSDB/OpenDB function
        FI.CloseDB()

        FI = Nothing
    End Sub

    Private Function SetGrdMastList()
        DataGridView1.Enabled = True

        DataGridView1.ColumnCount = 5
        DataGridView1.RowCount = 20
        DataGridView1.Columns(0).Name = "SrNo"
        DataGridView1.Columns(1).Name = "Item Name"
        DataGridView1.Columns(2).Name = "Item Alias"
        DataGridView1.Columns(3).Name = "Main Name"
        DataGridView1.Columns(4).Name = "Parent Group"

    End Function

    Private Function SetGrdVchList()
        DataGridView1.Enabled = True


        DataGridView1.ColumnCount = 13
        DataGridView1.RowCount = 20

        DataGridView1.Columns(0).Name = "S.No."
        DataGridView1.Columns(0).Name = "Vch. Date"
        DataGridView1.Columns(0).Name = "Vch. No."
        DataGridView1.Columns(0).Name = "Party"
        DataGridView1.Columns(0).Name = "Sale Type"
        DataGridView1.Columns(0).Name = "Tax Category"
        DataGridView1.Columns(0).Name = "Item Name"
        DataGridView1.Columns(0).Name = "CGST Rate"
        DataGridView1.Columns(0).Name = "SGST Rate"
        DataGridView1.Columns(0).Name = "CGST Amt"
        DataGridView1.Columns(0).Name = "SGST Amt"
        DataGridView1.Columns(0).Name = "IGST Rate"
        DataGridView1.Columns(0).Name = "IGST Amt"


    End Function

    Private Sub cmdVchList_Click(sender As Object, e As EventArgs) Handles cmdVchList.Click
        On Error Resume Next

        Dim FI As Object
        Dim Qry As String
        Dim rst As DAO.Recordset
        Dim RowNo As Long
        Dim Q1 As String
        Dim Q2 As String
        Dim Q3 As String
        Dim Q4 As String
        Dim OldVchCode As Long

        FI = CreateObject("Busy2L17.CFixedInterface")


        '    'Opens the BUSY database - SQL server
        '    FI.OpenCSDB "C:\Busywin\", "Rachna", "sa", "busy", "BusyComp0002"
        '    'OpenCSDB function has following parameters
        '    '"C:\Busywin\" - BusyPath where Busy is installed
        '    '"Rachna" - SQL Server Name
        '    '"sa" - SQL Server UserName
        '    '"busy" - SQL Server Password
        '    '"BusyComp0002" - Busy Company Code

        'OR

        'For Access Mode - To Open BUSY Database
        FI.OpenDB("C:\Busywin\", "D:\Busy Data\", "Comp0009")
        'OpenDB function has following parameters
        '"C:\Busywin\" - BusyPath where Busy is installed
        '"D:\Busy Data\" - Data Path
        '"Comp0001" - Busy Company Code

        MsgBox("Database Connected")

        RowNo = 0

        SetGrdVchList()

        'Fetch Values from Database through Queries

        Q1 = ",(Select M1.Name from Master1 as M1 where M1.code=PartyCode) as PartyName"
        Q2 = ",(Select M1.Name from Master1 as M1 where M1.code=StPtCode) as STPTName"
        Q3 = ",(Select M1.Name from Master1 as M1 where M1.code=TaxCatCode) as TaxCategory"
        Q4 = ",(Select M1.Name from Master1 as M1 where M1.code=ItemCode) as ItemName"

        Qry = "Select * " & Q1 & Q2 & Q3 & Q4 & " from VchGSTSumItemWise"

        rst = FI.GetRecordset(Qry)

        If rst.RecordCount > 0 Then
            rst.MoveLast()
            rst.MoveFirst()
            Do While Not rst.EOF
                'MsgBox Trim$(rst!Name.Value)

                DataGridView1.DataSource = rst

                DataGridView1.Rows(RowNo).Cells(0).Value = RowNo + 1


                If OldVchCode <> rst.Fields("VchCode").Value Then

                    DataGridView1.Rows(RowNo).Cells(1).Value = FI.formatdate(rst.Fields("Date").Value)
                    DataGridView1.Rows(RowNo).Cells(2).Value = rst.Fields("VchNo").Value
                    DataGridView1.Rows(RowNo).Cells(3).Value = rst.Fields("PartyName").Value
                    DataGridView1.Rows(RowNo).Cells(4).Value = rst.Fields("STPTName").Value
                    DataGridView1.Rows(RowNo).Cells(5).Value = rst.Fields("TaxCategory").Value

                    OldVchCode = rst.Fields("VchCode").Value
                Else

                    DataGridView1.Rows(RowNo).Cells(1).Value = ""
                    DataGridView1.Rows(RowNo).Cells(2).Value = ""
                    DataGridView1.Rows(RowNo).Cells(3).Value = ""
                    DataGridView1.Rows(RowNo).Cells(4).Value = ""
                    DataGridView1.Rows(RowNo).Cells(5).Value = ""
                End If

                DataGridView1.Rows(RowNo).Cells(5).Value = rst.Fields("ItemName").ToString

                If rst.Fields("LockType").Value = 0 Then     'Local
                    DataGridView1.Rows(RowNo).Cells(7).Value = rst.Fields("TaxRate").ToString
                    DataGridView1.Rows(RowNo).Cells(8).Value = rst.Fields("TaxRate1").ToString
                    DataGridView1.Rows(RowNo).Cells(9).Value = rst.Fields("TaxAmt").ToString
                    DataGridView1.Rows(RowNo).Cells(10).Value = rst.Fields("TaxAmt1").ToString
                    DataGridView1.Rows(RowNo).Cells(11).Value = ""
                    DataGridView1.Rows(RowNo).Cells(12).Value = ""
                Else
                    DataGridView1.Rows(RowNo).Cells(7).Value = ""
                    DataGridView1.Rows(RowNo).Cells(8).Value = ""
                    DataGridView1.Rows(RowNo).Cells(9).Value = ""
                    DataGridView1.Rows(RowNo).Cells(10).Value = ""
                    DataGridView1.Rows(RowNo).Cells(11).Value = rst.Fields("TaxRate").ToString
                    DataGridView1.Rows(RowNo).Cells(12).Value = rst.Fields("TaxAmt").ToString
                End If

                RowNo = RowNo + 1

                rst.MoveNext()
            Loop
        End If


        'Close Busy Company which is opened thru OpenCSDB/OpenDB function
        FI.CloseDB()

        FI = Nothing

    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        On Error GoTo EH
        Dim FI As Object

        FI = CreateObject("Busy2L17.CFixedInterface")

        MsgBox(FI.GetDongleSrNo)

        Exit Sub

EH:
        MsgBox(Err.Description)
    End Sub
End Class
