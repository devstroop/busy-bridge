**Custom Data Entry Screen in BUSY**

**BUSY** is a three-tier application. The first tier (front-end) is the one that interacts with the user. It then invokes the functions provided in the second tier (Business logic layer) to write to or read from the third tier (Databases). In this model, the first tier is totally independent of second and third tier. The second and third tiers, however, are specific to each other and work as a single inseparable unit. Just like the first tier of BUSY, any application software can use BUSY business logic layer to perform the functions provided by it.

If we have a look at the structure of Busy Application, it consists of two files, an EXE File named as Busy.EXE and a DLL File named as Busy2L.DLL. The EXE File represents the user interface of the Busy Application. The DLL File handles all the validation as well as data management issues for the application.

**Internal AddOns**

Additional utilities or external software can be added to BUSY as Add-Ons according to user specifications. Add-Ons are small requirement specific projects that use BUSY data. Internal Add-Ons are invoked from BUSY application and are visible in the application just like any other menu. When you open an internal Add-On then you do not need to specify the company whose data you want to use. You just have to open the required company in BUSY and then you can use the Add-On, which will be displayed in a menu named *Add-Ons*.

To create an internal Add-On, you have to perform the following steps:

- Select ***ActiveX DLL*** project in Visual Basic.

- After creating a project, create a class named ***IBusyWin***.

- In the *IBusyWin* class, you have to create two functions name ***ActivateDB*** and ***Start***.

Let us discuss these two functions in detail.

- ActivateDB

> ***ActivateDB*** sub procedure is used to connect Internal Add-On to the database. In this function, first you have to create a late bound instance of ***CFixedInterface*** class of **Busy2L.dll**. This function accepts ***p_Data*** as its input parameter. Given below is a sample code that will help you understand better.

Public g_FI as Object ‘Global variable used for CFixedInterface Class

> Public Sub ActivateDB (p_Data As Collection)
>
> g_Provider = p_Data(6)
>
> g_User = p_Data(1)
>
> Set g_FI = p_Data(50)
>
> End Sub

- Start

> After the ActivateDB function is called, next function call is ***Start*** function. In the *Start* function, you have to create an instance of the form that will be used as the main or first form of the project. Given below is a sample code for this function.
>
> Public Sub Start()
>
> Set fMain = New frmMain
>
> fMain.Show vbModal
>
> Exit Sub
>
> End Sub

After developing internal Add-On, you have to add it to the BUSY application so that it will be displayed in the BUSY application as a menu. To add internal Add-On to the BUSY application, perform the following steps:

- Click the drive in which the BUSY application is installed. For example if the BUSY application is in *C* drive then click *C:\BusyWin\System* folder.

- In the *System* folder, create a text file and save it as ***.ini*** file with name **AddOns**. So the name of the file will be ***AddOns.ini***.

- In the file, write the name of DLL project followed by a semicolon and the name for the Add-On that you want to be displayed as a menu in the application. For example, the name of your DLL project is *Prj_Incentive* and you want that the name of the Add-On to be displayed as menu in the application will be *Incentives* then you have to write *Prj_Incentive;Incentive* in the *AddOns.ini* file.

Given below is a screenshot of BUSY application after including the internal Add-On.

<img src="media/image1.jpg" style="width:6.5in;height:2.69792in" />

**<u>Saving of Master Through XML</u>**

Function used to save a master through XML is SaveMasterFromXML. Defination of this function is as:

*Public Function SaveMasterFromXML(ByVal p_MasterType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True) As Boolean*

Input Parameters for this function are:

p_MasterType = Integer Type; Each Master in BUSY is given a unique integer value for identification for e.g. Account master =2, Account Group master =1, Item Master=6 etc. (refer to BUSY Constants file).

p_XMLStr = String Type; For saving of a master through XML, master data should be provided in BUSY predefined XML string format. This XML format for a master can be generated through utility provided in BUSY itself (Administration -\> Data Export Import (XML) -\> Export Data -\> Masters).

p_ErrStr = String Type (ByRefence variable); if for any reason specified master is not saved in BUSY then this variable holds the reason for not saving the master.

p_Modify = Boolean Type (Optional); if the specified master already exists in the BUSY database then this flag decides whether to modify the master or not. If you don’t want to modify an already existing master then set this flag to False. By default value of this flag is True.

**<u>Saving of Voucher Through XML</u>**

Function used to save a voucher/transaction through XML is SaveVchFromXML. Defination of this function is as:

*Public Function SaveVchFromXML(ByVal p_VchType As Variant, ByVal p_XMLStr As Variant, ByRef p_ErrStr As Variant, Optional ByVal p_Modify = True, Optional ByVal p_ModifyKey = 0) As Boolean*

Input Parameters for this function are:

p_VchType = Integer Type; Each Transaction in BUSY is given a unique integer value for identification for e.g. SALE =9, PURCHASE =2, SALE_RETURN=3 etc. (refer to BUSY Constants).

p_XMLStr = String Type; For saving of a transaction through XML, voucher data should be provided in BUSY predefined XML string format. This XML format for a voucher can be generated through utility provided in BUSY itself (Administration -\> Data Export Import (XML) -\> Export Data -\> Transactions).

p_ErrStr = String Type (ByRefence variable); if for any reason specified voucher data is not saved in BUSY then this variable holds the reason for not saving the voucher.

p_Modify = Boolean Type (Optional); if the specified voucher already exists in the BUSY database then this flag decides whether to modify the voucher or not. If you don’t want to modify an already existing voucher then set this flag to False. By default value of this flag is True.

p_ModifyKey = Integer Type; this value is relevant only if Modify flag is set to True. Values of Modify key are:

VCHNO_SERIES_DATE = 0

VCHNO_ONLY = 1

VCHNO_DATE = 2

VCHNO_SERIES = 3

VCHCODE_ONLY = 5

These modify keys tells the parameters on which voucher modification depends. Suppose if the key is VCHNO_SERIES_DATE then criteria of voucher modification is decided on Voucher No + Voucher Series + Voucher date fields.

**<u>Fetching Data</u>**

Functions used to fetch data from the BUSY company database are GetRecordset, ExecuteQuery and GetRecordsetFromCompanyDB. Defination of these functions are:

- *Public Function GetRecordset(p_StrQry) As Recordset*

This function will execute the specified query in the BUSY company financial year database (e.g. db12018) and returns the resultant DAO (Data Access Object) recordset.

- *Public Function GetRecordsetFromCompanyDB(p_StrQry) As Recordset*

This function will execute the specified query in the BUSY company database (e.g. db) and returns the resultant DAO (Data Access Object) recordset.

- *Public Sub ExecuteQuery(p_StrQry As Variant, Optional p_RaiseError As Variant = True, Optional p_ErrMsg As Variant)*

This function is used to execute the specified query in the BUSY company financial year database.

------ x ------
