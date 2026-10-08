**Customization and Integration Options in BUSY**

**<u>Customization</u>**

Customization in general refers to altering an existing product / thing to meet requirement of a particular individual. Customization is a tailor made solution for an individual’s demand and is done only to suit that person’s requirement.

BUSY is readymade software with a huge customer base catering to almost every industry, be it, FMCG, Pharmaceuticals, Electricals or any other which in itself is a very big and BUSY has done this successfully. To take care of the ever changing requirements of customers, BUSY always tries to incorporate as many features as possible in the product and time to time come up with new versions which include enhancement to existing features and addition of new features as per the market requirements.

Although BUSY tries to cater to the need of every type of industry and regularly make additions to the product, still at times some customers need tailor – made solutions specially designed to suit their business type. These types of changes are very difficult to incorporate in the product as they are required only for the customer’s business type and do not benefit other customers. For such type of changes, BUSY can be customized only for the particular customer who requires it. This type of customization is done by BUSY’s Solution Partners and is generally on chargeable basis.

**<u>Integration</u>**

Integration with external / third party application refers to smoothly connecting two applications wherein data fed in one application can be saved and retrieved from other application also.

BUSY can be very well integrated with external or third party applications for saving and retrieving of data. Basically integration of BUSY with some other software is done to obtain maximum output from both the software and for a seamless connectivity between the two. There are many BUSY users who are currently using BUSY application along with the other software they are using. This amalgamation of two software leads to smooth functioning of organizational work and offers desired result with minimum input of data. For example, many companies need a bridge application between BUSY and their Online portal so that orders entered on their website need not be entered again in BUSY. Customers with the help of our Solution Partners can build such application which work amazingly well in saving online data in BUSY and maintaining inventory effectively.

Integration and Customization in BUSY can be done through following five ways:

1.  Integration Using BUSY DLL

2.  Integration Using BUSY as Web Service.

3.  Internal AddOns (invoked from BUSY itself)

4.  Custom Reports in BUSY

5.  Custom Validation in BUSY

We will now have a look at the overview of all these modes. For detailed explanation on these modes, you can refer to documents created specifically for them.

1.  **Integration using BUSY DLL**

In this mode, we use BUSY application DLL to integrate with external applications and data exchange is done through predefined BUSY XML format. While integrating with BUSY using BUSY DLL, you are not required to open BUSY application.

**BUSY Application**

As BUSY is developed in VB6 hence all its DLLs are ActiveX DLL thus you do not need to take reference of these DLL. You only have to create a late bound object of BUSY2L17.CFixedInterface Object and to save a voucher / master, you just have to create an XML string and use the specified functions of BUSY API.

Create Voucher/Master,\
Fetch Data using SQL Queries

**Third Party Application**

(Data Exchange Through XML)

2.  **Integration using BUSY as Web Service**

While integrating with BUSY using BUSY as Web Service, BUSY acts a Web Server and start listening to Port 981. Third party application that you are using will then connect to BUSY Web Server through HTTP Web Service request. Once the third party application is connected with BUSY application it will then be able to easily save and retrieve data to / from BUSY. An important point to note here is that BUSY application should be open and the BUSY Company that you want to access should also be logged in at that time. Once you have connected external software to BUSY, you can then use different Service Codes created for different functionalities like Service Code 1 can be used to execute SQL Query and so on.

Web Service Request

**BUSY.EXE**

**Third Party Application**

Web Service Response

Web Service activated at Port 981

3.  **Custom Data Entry Screens (Internal AddOns in BUSY)**

Custom Data Entry Screen is used when the customer wants a totally new data entry screen through which he can enter the data and the same data should get saved in BUSY database. Basically if a customer does not want to use BUSY data entry screen and wants to develop his own data entry screen then it can be done by designing a custom data entry screen. For example if BUSY is being used in a hospital then the hospital billing data entry screen can be developed and the data captured in that screen can be saved in BUSY as Sales voucher.

4.  **Custom Reports in BUSY**

Custom Reports (through VB Script) are designed when a customer needs a particular report as per his requirement and that format is not available in BUSY. For example, if a customer wants to view sales and purchase in the same report and since this type of report is not available in BUSY, a custom report can be developed in which both the sales and purchase can be shown in a single report.

5.  **Custom Validation in BUSY**

> Custom Validation (through VB Script) is used for putting some special validations at the time of data entry as required by the customer. Basically, if a customer wants to put a particular restriction at the time of data entry or wants to see some extra information at the time of data entry then Custom Validation is used. For example, if a customer wants that Party master should not get saved unless, mobile number is entered then this case can be handled through Custom Validation. Taking another example, a customer wants that whenever he selects a Party in Sales voucher, the narration field should automatically get updated on the basis of Optional Fields data as specified in Party master, this can also be handled through Custom Validations.
>
> Above was a brief introduction to all three customization options available in BUSY. Detailed information for each mode has been provided in specific documentation.
>
> ------------------- x ----------------
