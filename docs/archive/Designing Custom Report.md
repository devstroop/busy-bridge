**<u>Steps for Activating Custom Report Designing</u>**

From BUSY 3.9 (h) version onwards, to activate designing of Custom report on a computer, you must have a License file on it. This license file is same as provided for using the UMS software. If you are already having a License file for UMS (dealer company name.ums) then you can copy that file to BusyWin folder and start designing Custom report.

If you do not have a license file for UMS then you can obtain it from BUSY office by providing the hard disk number of the computers on which you want to design the Custom reports. To extract Hard Disk serial number of the computer, you can use the *Show Hard Disk Serial No.* option provided under Help menu of BUSY. Once you get the Hard Disk Serial number of the computer, give it to the BUSY office and BUSY will then Email you the License file (dealer’s company name.ums). Copy this license file to the BusyWin folder and start designing Custom Reports.

**Note: You can design Custom reports only on those computers whose hard disk serial number is bound in the License file.**

**<u>Steps for Designing Custom Report</u>**

1.  Click *Administration 🡪 Utilities 🡪 Custom Report/Scripts 🡪 Design Custom Report* menu. Create a new format by clicking *Add New* button.

> ***Note** : ‘Design Custom Report’ menu would be visible by copying UMS License (\*.UMS) file to BusyWin Folder.*

2.  Select the required format that you want to configure. After selecting a format, specify title for the report in *Title of Report* field.

3.  After specifying the title, the next step is to specify the Report Options for generating the reports. Report Options specifies the input parameters required for generating the reports. For example, if you want to generate report for a particular date range then you have to specify the starting date (from which) and ending date (up to which) data is to be picked. These starting date and ending date can be referred as Report Options. Similarly along with date, you also want that report would be generated for a party as specified by you. In this case, you would also take input for the party for which the report is to be generated. Hence the Party Name would also be your Report Option. Along with selecting a Report Option, you have to specify the caption for the Report Option also. For example, for Starting Date, you can select Report Option as Start_Date and specify its caption as *Specify Starting Date*. Similarly for Party Name, you can select the Report Option as Account_Name and specify its caption *Select Party*. For example, you want to generate custom report for displaying the Accounts Day Book as it appears in BUSY reports then basic input parameters to generate the report are Start_Date and End_Date. Given here is a screenshot displaying various Report Options and their captions.

> <img src="media/image1.png" style="width:5.62083in;height:3.99792in" />

4.  After specifying the Report Options with the required captions, the next step is to specify the columns that you want to appear in the report. For example, you want to generate custom report for displaying the Accounts Day Book as it appears in BUSY reports. For this purpose, you will specify six columns in the report. The first column will be Vch. Date, second column will be Vch. Type, third column will be Vch. No., fourth column will be Particulars, fifth column will be Debit Amount and sixth column will be Credit Amount. After specifying the columns, you will specify the configuration for these columns i.e. total characters required for each value, whether the values should be left aligned or right aligned and so on. To specify and configure Report Headings, click *Configure Report Heading Fields* tab. On clicking the tab, a *Header Field Configuration* grid appears with various fields. The fields in the grid are:

    - Heading – Specify the heading for the column.

    - Data Type – Select the data type for the column. For example, if the column is for party name then you can select the data type as Text or if the column is for displaying date then you can select the data type as Date and so on.

    - Alignment – Select alignment for the values that will appear in the column.

    - No. of Characters – Specify number of characters to be used for the column. This is required for controlling the column width.

    - No. of Decimal – This field gets active only if you have selected Data Type as Numeric or Numeric with Dr. / Cr.. Specify the number of decimal places required for the values displayed in the column. For example, in the *No. of Characters* field, you have specified the value as 20 and in *No. of Decimal* field, you have specified the value as 4. In this case, out of total 20 characters, 16 characters will be reserved for the value displayed before decimal and 4 characters will be reserved for value displayed after decimal.

    - Show Total – Select *Yes* option in this field, if you want to display total of all the values displayed in this column.

> Given here is a screenshot displaying Header Configuration for displaying the Accounts Day Book as it appears in BUSY reports.
>
> <img src="media/image2.png" style="width:5.42917in;height:3.99792in" />

5.  After specifying the Report Options and Report Headings, the next step is to specify the logic for generating the report. For specifying the Report logic, click *Report Logic* tab. On clicking the *Report Logic* tab, a *Writing Logic for Report Generation* screen appears with some predefined code written in it. Given here is a screenshot displaying *Writing Logic for Report Generation* screen.

> <img src="media/image3.png" style="width:5.64236in;height:3.99792in" />

6.  In the *Writing Logic for Report generation* screen, click *Edit Script* button to edit code or to write logic for the report. On clicking the button, the window will open script in the editable format in VBSEdit. Given here is a screenshot displaying code in VBSEdit format.

<img src="media/image4.png" style="width:6.26111in;height:4.53681in" />

> In the VBsEdit window, there are some **predefined objects** defined at the starting of window. These predefined objects are:

- **BusyLib** – Use this object to access predefined functions build in Busy. For example, to convert MasterCode to name, you can use *BusyLib.MasterCode2Name* function that will accept MasterCode as its parameter and return name of Master.

- **BusyConst** – Use this object to access all the constants defined in Busy. For example, to access the value of *Account* master, you can use *BusyConst.ACC_MAST*.

- **BusyRepOpt** – Use this object to access value of input parameters specified by the User. For example, *BusyRepOpt.OptStartDate* will give value of start date that is specified by User.

- **BusyCompConfig** – Use this object to access value of company configurations defined in Features / Options if required. For example, to access currency decimal places defined in *Features / Options,* you can use *BusyCompConfig.CurDecimal* function and to access Quantity Decimal places defined in *Features / Options*, you can use *BusyCompConfig.QtyDecimal function.*

> There are also some **predefined procedures** in the window that are used to throw data on screen. These predefined procedures are:

- **Grid_Throw_Data**

> *Public Sub Grid_Throw_Data (p_Data)*
>
> This sub procedure is used to throw data of one column on the grid of screen report. The procedure accepts data as its parameter which has to be shown on screen.

- **Grid_Next_Row**

> *Public Sub Grid_Next_Row (p_OnEnterInfo)*
>
> This sub procedure is used to jump to the next row, after data for one row has been filled up. The procedure accepts *p_OnEnterInfo* as its parameter. This is required for Audit Trial feature of *BUSY* i.e. when you press *Enter* key on one row it show its corresponding row details in another screen. If you do not want to show any details then leave this parameter as blank string. Considering the above stated example of Account Day Book report, on enter of each row its corresponding voucher is opened in modify mode. Each voucher is uniquely identified by its internal automatically generated voucher code. So we will pass voucher code as a parameter to this procedure like:
>
> Grid_Next_Row rst.Fields(“VchCode”).value

- **Grid_Next_Row_With_Special_Effects**

> *Public Sub Grid_Next_Row_With_Special_Effects (p_OnEnterInfo, p_SEConst)*
>
> This sub procedure is same as **Grid_Next_Row** sub procedure. This procedure accepts *p_OnEnterInfo* and *p_SEConst* as its parameter. This procedure is used to jump to next row and apply Special Effects to current row.
>
> Grid_Next_Row_With_Special_Effects rst.Fields(“VchCode”).value, BusyConst.SPECIAL_EFFECTS_SUB_DETAILS

- **Grid_New_Entry**

> *Public Sub Grid_New_Entry()*
>
> This sub procedure is used to update the new entry in the report. For example, if a screen report displays single voucher details in four separate rows, then no. of entry for that voucher will be one and no. of rows will be four. Basically if you have multiple rows in a single object then this procedure will be used so that details of a single object would not be repeated.
>
> *In the Report Logic window, there is a ‘Treat Single Row as Single Entry’ checkbox. If you have enabled this option then BUSY will always treat each row of an object as a separate entry.*

- **Grid_Total_Rows**

> *Public Sub Grid_Total_Rows(p_TotalRows)*
>
> This procedure is used to update the total no. of rows to status bar of screen report. It accepts total no. of rows (fetched from recordset object) as its parameter.
>
> For **On Enter Details**, there is a predefined sub procedure ‘***OnEnterChs***’.
>
> *Public Sub OnEnterChs(p_OnEnterInfo)*
>
> This sub procedure is used to view sub details of each row of a report. This procedure receives p_OnEnterInfo as its parameter. p_OnEnterInfo is the information that is provided while calling Grid_Next_Row procedure in the GenerateRep procedure. This is information through which each row is uniquely identified. For example, while viewing Account Day Book, if you press *Enter* key on a row in a report, the corresponding voucher will open in Modify mode. A voucher is uniquely identified through its voucher code. So, voucher code is passed in Grid_Next_Row procedure.
>
> Public Sub OnEnterChs(p_OnEnterInfo)\
>     OnEnter_Modify_Voucher p_OnEnterInfo\
> End Sub
>
> Similarly to open a master in Modify mode on enter of a row, we will use OnEnter_Modify_Master predefined procedure. To open an Account Ledger report on enter of a row we will use OnEnter_Acc_Ledger predefined procedure. Now, if one wants to show multiple choices to user so that user would able to select what he wants to open on pressing *Enter* key instead of opening one type of report always. For this case first we have to make p_OnEnterInfo of our choice. p_OnEnterInfo is the string information that is passed in Grid_Next_Row procedure. For example if we want to give choices either to open voucher in modify mode or to open Account Ledger report then we have pass VchCode (to uniquely identify a voucher) and Account Code (for which Ledger is to be shown) separated by delimiter to this p_OnEnterInfo in Grid_Next_Row procedure like
>
> Grid_Next_Row rst.Fields(“VchCode”).Value & “;” & rst.Fields(“MasterCode1”).Value
>
> In OnEnterChs procedure, this information is then split up to get required values. A collection has to be build up of choices and passed to ‘ShowOnEnterChs’ function of BusyLib.
>
> Public Sub OnEnterChs(p_OnEnterInfo)\
>      Dim Chs \
>      Dim Col\
>      Dim Arr\
>      Dim VchCode\
>      Dim AccCode\
>     \
>      Set Col=BusyLib.GetCollectionObj\
>     \
>      BusyLib.AddItemInCol Col,"Modify Voucher"\
>      BusyLib.AddItemInCol Col,"Account Ledger"\
>     \
>      If BusyLib.ShowOnEnterChs(Chs,Col) Then        
>
> Arr=Split(p_OnEnterInfo,";")\
>          VchCode=Arr(0)\
>          AccCode=Arr(1)\
>         \
>          If chs= 1 Then   'Modify Voucher\
>             OnEnter_Modify_Voucher VchCode\
>          Else      'Open Account Ledger\
>              OnEnter_Acc_Ledger AccCode,BusyRepOpt.OptStartDate, BusyRepOpt.OptEndDate\
>          End If\
>      End If\
>     \
> End Sub
>
> The predefined sub procedures used for on enter details defined in the script are:

- **OnEnter_Modify_Master**

> *Public Sub OnEnter_Modify_Master (p_MasterType, p_MasterCode)*
>
> This sub procedure is used to open master in Modify mode on pressing *Enter* key on a row of screen report. This procedure accepts MasterType and MasterCode as its parameter. MasterType identifies which type of master it is such as *Account* master, *Item* master, *Unit* master and so on. For this we have constant available for all these MasterTypes. MasterCode is a unique code in BUSY, which is generated automatically on saving a Master.

- **OnEnter_Modify_Voucher**

> *Public Sub OnEnter_Modify_Voucher (p_VchCode)*
>
> This sub procedure is used to open voucher in Modify mode on pressing *Enter* key on a row of screen report. This procedure accepts VchCode as its parameter. Vchcode is a unique code in BUSY, which is generated automatically on saving a voucher.

- **OnEnter_Acc_Ledger**

> *Public Sub OnEnter_Acc_Ledger (p_AccCode,p_StartDate,p_EndDate)*
>
> This sub procedure is used to open Account Ledger on pressing *Enter* key on an account in a row of screen report. The procedure accepts Account code, Start date and End date as its input parameter.

- **OnEnter_Item_Ledger**

> *Public Sub OnEnter_Item_Ledger (p_ItemCode,p_MCCode,p_StartDate,p_EndDate,p_ShowVal,p_IUT)*
>
> This sub procedure is used to open Item Ledger on pressing *Enter* key on an item in a row of screen report. The procedure accepts Item code, Material Center code, Start date, End date, Show Item Value also, Item Unit in which report is to be shown as its input parameter.

- **OnEnter_Acc_Ledger_With_RepOpt**

> *Public Sub OnEnter_Acc_Ledger_With_RepOpt (p_RepOptObj)*
>
> This sub procedure is used to open Account Ledger on pressing *Enter* key on an account in a row of screen report. This procedure is same as **OnEnter_Acc_Ledger** except that it accepts object of **CRepOptions** class as its parameter. All the input parameters Account Code, Start Date and End Date required to generate Account Ledger report are specified in this RepOpt object like:
>
> Dim RepOpt
>
> Set RepOpt = CreateObject(“Busy2L39.CRepOptions”)
>
> RepOpt.OptAccCode = Account Code
>
> RepOpt.OptStartDate = Start Date
>
> RepOpt.OptEndDate = End Date

- **OnEnter_Item_Ledger_With_RepOpt**

> *Public Sub OnEnter_Item_Ledger_With_RepOpt (p_RepOptObj)*
>
> This sub procedure is used to open Item Ledger on pressing *Enter* key on an item in a row of screen report. This procedure is same as **OnEnter_Item_Ledger** except that it accepts object of **CRepOptions** class as its parameter. All the input parameters Item Code Material Center code, Start date, End date, Show Item Value also, Item Unit in which report is to be shown required to generate Item Ledger report are specified in this RepOpt object like:
>
> Dim RepOpt
>
> Set RepOpt = CreateObject(“Busy2L39.CRepOptions”)
>
> RepOpt.OptItemCode = Item Code
>
> RepOpt.OptMCCode = MC Code
>
> RepOpt.OptStartDate = Start Date
>
> RepOpt.OptEndDate = End Date
>
> RepOpt.OptShowValue = ShowVal
>
> RepOpt.OptIUT = IUT

- **OnEnter_Vch_List**

> *Public Sub OnEnter_Vch_List(p_VchType,p_StartDate,p_EndDate, p_VchSeriesCode)*
>
> This sub procedure is used to open list of vouchers of specified voucher type on pressing *Enter* key on a row of screen report. This procedure accepts VchType, Start Date, End Date and VchSeriesCode as its input parameter.

- **OnEnter_Vch_List_With_RepOpt**

> *Public Sub OnEnter_Vch_List_With_RepOpt (p_RepOptObj)*
>
> This sub procedure is used to open list of vouchers of specified voucher type on pressing *Enter* key on a row of screen report. This procedure accepts object of **CRepOptions** class as its parameter in which input parameters to be specified are:
>
> Dim RepOpt
>
> Set RepOpt = CreateObject(“Busy2L39.CRepOptions”)
>
> RepOpt.OptVchType = Vch. Type Constant
>
> RepOpt.OptStartDate = Start Date
>
> RepOpt.OptEndDate = End Date
>
> RepOpt.OptVchSeriesCode = Voucher series code (if to generate report for one voucher series)

- **OnEnter_Custom_Report**

> *Public Sub OnEnter_Custom_Report (p_FormatName,p_RepOptObj)*
>
> This sub procedure is used to open another Custom Report on pressing *Enter* key on a row of screen report. This procedure accepts Format Name of Custom Report (which we want to open) and an object of CRepOptions class as its input parameter. In this p_RepOptObj we can specify all the input parameters of another custom report which we have specified in ‘Configure Report Options Tab’ of ‘Configure Format for Custom Report’ form. For example if we want to open another custom report to show an account Ledger with format name ‘Acc Ledger’ and Account Code, Start Date and End Date as its input parameter like:
>
> Dim RepOpt
>
> Set RepOpt = CreateObject(“Busy2L39.CRepOptions”)
>
> RepOpt.AccCode= Account Code
>
> RepOpt.OptStartDate = Start Date
>
> RepOpt.OptEndDate = End Date
>
> OnEnter_Custom_Report “Acc Ledger”,RepOpt
>
> **‘GenerateRep’ Procedure**
>
> **‘GenerateRep’** is a predefined function in the script. Actual core logic required to generate any screen report is to be written in this function only. In this function, you need to perform the following steps:

- First of all, build query string that will fetch the required data from database.

- Get recordset of the above build query string using **BusyLib.GetRecordset** function. This function accepts p_strQry (variant type) i.e. query string as its parameter and returns recordset type object. For example, to generate Account Day Book report, the query string will be

> Dim Qry
>
> Dim rst
>
> Qry="Select Date,VchNo,VchType,Mastercode1,Value1,VchCode from tran2 where RecType=" & CStr(BusyConst.T2_ACC_DATA) & " And date \>= " & BusyLib.GetDateQryStr(BusyRepOpt.OptStartDate) & " And date \<=" & BusyLib.GetDateQryStr(BusyRepOpt.OptEndDate)   
>
>     Set rst= BusyLib.GetRecordset(Qry)\
>     
>
> *Note: In VBScript language there is only one data type i.e. variant. We can’t define a variable as string or double.*

- Next step is to show all the data stored in this recordset object on the screen. For this we have to browse recordset object one by one and throw data on screen. For the above discussed report we will browse recordset object as follows:

> With rst\
>         If .RecordCount\>0 Then\
>             .MoveLast\
>             .MoveFirst\
>             \
>             Grid_Total_Rows .RecordCount\
>             \
>             Do While Not .EOF\
>                 \
>                 If OldVchCode\<\>.Fields("VchCode").Value Then    \
>                     Grid_New_Entry \
>                                 \
>                     Grid_Throw_Data .Fields("Date").Value\
>                     Grid_Throw_Data BusyLib.VchType2ShortName(.Fields("VchType").Value)\
>                     Grid_Throw_Data .Fields("VchNo").Value\
>                     \
>                     OldVchCode=.Fields("VchCode").Value\
>                 Else\
>                     Grid_Throw_Data ""\
>                     Grid_Throw_Data ""\
>                     Grid_Throw_Data ""\
>                 End If\
>                 \
>                 Grid_Throw_Data BusyLib.MasterCode2Name(.Fields("MasterCode1").Value)\
>                 \
>                 If .Fields("Value1").Value \< BusyConst.ZERO_VAL Then                                    \
>                     Grid_Throw_Data Abs(.Fields("Value1").Value)\
>                     Grid_Throw_Data ""\
>                 Else\
>                     Grid_Throw_Data ""\
>                     Grid_Throw_Data .Fields("Value1").Value\
>                 End If\
>                 \
>                 Grid_Next_Row .Fields("VchCode").Value\
>                 \
>                 .MoveNext\
>             Loop\
>         End If\
>     End With\
>     
>
> **‘Grid_Throw_Data’** sub procedure is used to throw data of one column on the screen. After data of one row has been thrown on screen, we will use ‘**Grid_Next_Row**’ sub procedure to move to next row of the screen.
>
> After Custom Report logic has been build up in VBSEdit, save the script and gets back to BUSY. Click Save button in ‘Configure Format for Custom Report’ window to save all the configurations for the Custom Report.
>
> **<u>How to View Custom Report</u>**
>
> This Custom Report can be viewed from *Display 🡪 Custom Report 🡪 (Format Name)* menu.
>
> ------------------ x -----------------
