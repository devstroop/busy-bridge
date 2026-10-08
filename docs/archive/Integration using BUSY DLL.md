**Integration through XML**

Integration with other software means when we need to connect BUSY and any other existing application being used by customer. It implies that if a customer is using any other application and simultaneously wants to save its data in BUSY then it can also be done.

For example, a company wanted that all the orders placed online on its web portal should not be fed again in BUSY and at the same time inventory for the same should be maintained. For this purpose a bridge application can be developed. With this bridge application, company’s portal and BUSY database can be connected in such a way that as an order is placed on the portal is automatically got posted in the BUSY software and accordingly affects the stock of items.

In this option, Data exchange is done through predefined BUSY format **XML files**. This option uses already installed DLL of BUSY application that means you don’t need to take any DLL reference in your project.

For this purpose, we have to use one class **CFixedInterface**. First of all we have to create an object of this class. Object of this class will be created through ‘CreateObject’ command as we would not include any reference of any DLL in the integration project. We would use the DLL installed by BUSY application on your machine.

Dim FI as Object

Set FI = CreateObject (“Busy2L17.CFixedInterface”)

In the above statement we have created an object of the CFixedInterface class through the reference DLL of installed BUSY17 on your machine. We have to create an object depending upon the version of BUSY installed. For e.g. if BUSY17 is installed, then we have to create an object as **BUSY2L17.CFixedInterface** and if BUSY18 is installed then we have to use **BUSY2L18.CFixedInterface**.

After that we have to open the databases of the companies created in BUSY for various operations. There are two types of database modes in BUSY, Access and MSSQL. Command used to open the databases for Access is **OpenDB** and for SQL is **OpenCSDB**. Definition for both these functions are as:

<u>For Access:</u>

*Public Function OpenDB(p_BusyPath As String, p_DataPath As String, p_CompCode As String) As Boolean*

Input parameters for this function are:

p_BusyPath = string data type; refers to the path where BUSY is installed. For e.g. “C:\BusyWin\\

p_DataPath = string data type; refers to the path where BUSY company data is stored. For e.g. “C:\BusyWin\Data\\

p_CompCode = string data type; refers to the BUSY Company code. For e.g. “Comp0001”

<u>For SQL</u>

*Public Function OpenCSDB(p_BusyPath As String, p_ServerName As String, p_UserName As String, p_Pwd As String, p_CompCode As String) As Boolean*

Input parameters for this function are:

p_BusyPath = string data type; refers to the path where BUSY is installed, for e.g. “C:\BusyWin\\.

p_ServerName = string data type; refers to the name of MSSQL Server.

p_UserName = string data type; refers to valid MSSQL server User ID. Default MSSQL user name is ‘*Sa’*.

p_Pwd = string data type; refers to password that you have specified for the MSSQL user name.

p_CompCode = string data type; refers to the BUSY Company code for e.g. “BusyComp0001”.

After opening of databases various operations can be performed like saving of a master or a transaction or to fetch data from database.

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

p_VchType = Integer Type; Each Transaction in BUSY is given a unique integer value for identification for e.g. SALE =9, PURCHASE =2, SALE_RETURN=3 etc. (refer to Voucher Types).

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

This function will execute the specified query in the BUSY company financial year database (e.g. db12016) and returns the resultant DAO (Data Access Object) recordset.

- *Public Function GetRecordsetFromCompanyDB(p_StrQry) As Recordset*

This function will execute the specified query in the BUSY company database (e.g. db) and returns the resultant DAO (Data Access Object) recordset.

- *Public Sub ExecuteQuery(p_StrQry As Variant, Optional p_RaiseError As Variant = True, Optional p_ErrMsg As Variant)*

This function is used to execute the specified query in the BUSY company financial year database.

------ x ------
