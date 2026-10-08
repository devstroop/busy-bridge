**Integration Using BUSY Web Service**

Given below is a list in tabular form of various Service Codes provided by BUSY.

<table style="width:99%;">
<colgroup>
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 16%" />
<col style="width: 14%" />
<col style="width: 26%" />
<col style="width: 7%" />
<col style="width: 2%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;"><p><strong><u>Service Codes</u></strong></p></th>
<th colspan="2" style="text-align: center;"><p><strong><u>Description</u></strong></p></th>
<th colspan="2" style="text-align: center;"><p><strong><u>Parameters</u></strong></p></th>
<th colspan="3" style="text-align: center;"><p><strong><u>Response</u></strong></p></th>
</tr>
</thead>
<tbody>
<tr>
<td rowspan="3" style="text-align: center;"><p><strong>1</strong></p></td>
<td rowspan="3"><p><strong>Get XML from Recordset</strong></p></td>
<td rowspan="3" style="text-align: center;"><p>This service will execute a SQL query on the opened BUSY Company Database and will return the XML string of resultant recordset in response body</p></td>
<td style="text-align: center;"><p><strong>Qry</strong></p></td>
<td><p>SQL Query string to be executed</p></td>
<td><p><strong>Body</strong></p></td>
<td colspan="2"><p>XML String of resultant recordset</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>User Name</strong></p></td>
<td><p>Valid User Name of the BUSY Company</p></td>
<td><p><strong>Result</strong></p></td>
<td colspan="2"><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td><p>Valid Password for that user of BUSY Company</p></td>
<td><p><strong>Description</strong></p></td>
<td colspan="2"><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td rowspan="4" style="text-align: center;"><p><strong>2</strong></p></td>
<td rowspan="4" style="text-align: center;"><p><strong>Add Voucher from XML</strong></p></td>
<td rowspan="4" style="text-align: center;"><p>This service is used to add a new voucher in BUSY from XML string. This XML string should be in predefined XML format.</p></td>
<td style="text-align: center;"><p><strong>VchType</strong></p></td>
<td style="text-align: center;"><p>Specify Voucher Type for which voucher is to be added. For constant value of Voucher Types kindly refer to BUSY Constants.doc file</p></td>
<td><p><strong>Body</strong></p></td>
<td colspan="2"><p>Unique Voucher Code generated (long value)</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>VchXML</strong></p></td>
<td style="text-align: center;"><p>XML string of Voucher Data that is to be added in BUSY. XML string should be in BUSY predefined format.</p></td>
<td><p><strong>Result</strong></p></td>
<td colspan="2"><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
<td><p><strong>Description</strong></p></td>
<td colspan="2"><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
<td colspan="3"></td>
</tr>
<tr>
<td rowspan="5" style="text-align: center;"><p><strong>3</strong></p></td>
<td rowspan="5" style="text-align: center;"><p><strong>Modify Voucher from XML by Voucher No.</strong></p></td>
<td rowspan="5" style="text-align: center;"><p>This Service is used to modify a voucher from XML string using Voucher No. as its key</p></td>
<td style="text-align: center;"><p><strong>VchType</strong></p></td>
<td style="text-align: center;"><p>Specify Voucher Type for which voucher is to be added. For constant value of Voucher Types kindly refer to BUSY Constants.doc file</p></td>
<td><p><strong>Result</strong></p></td>
<td colspan="2"><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>VchXML</strong></p></td>
<td style="text-align: center;"><p>XML string of Voucher Data that is to be added in BUSY. XML string should be in BUSY predefined format.</p></td>
<td><p><strong>Description</strong></p></td>
<td colspan="2"><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>ModifyKey</strong></p></td>
<td style="text-align: center;"><p>ModifyKey is the basis or criteria to modify a voucher. Different values for ModifyKey are:</p>
<p><u>VCHNO_ONLY = 1</u>; voucher is modified on the basis of Voucher No. only.</p>
<p><u>VCHNO_DATE = 2</u>; voucher is modified on the basis of voucher no. and voucher Date</p>
<p><u>VCHNO_SERIES=3</u>;</p>
<p>voucher is modified on the basis of voucher no. and voucher Series</p>
<p><u>VCHNO_SERIES_DATE = 4</u>; voucher is modified on the basis of Voucher no., Series and Date</p>
<p><u>VCHCODE_ONLY = 5</u>; voucher is modified on the basis of Voucher Code.</p></td>
<td colspan="3" rowspan="3"></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
</tr>
<tr>
<td rowspan="5" style="text-align: center;"><p><strong>4</strong></p></td>
<td rowspan="5" style="text-align: center;"><p><strong>Modify Voucher from XML by Voucher Code</strong></p></td>
<td rowspan="5" style="text-align: center;"><p>This Service is used to modify a voucher from XML string using Voucher Code.</p></td>
<td style="text-align: center;"><p><strong>VchType</strong></p></td>
<td style="text-align: center;"><p>Specify Voucher Type for which voucher is to be added. For constant value of Voucher Types kindly refer to BUSY Constants.doc file</p></td>
<td colspan="2"><p><strong>Body</strong></p></td>
<td><p>Voucher Code (long value)</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>VchXML</strong></p></td>
<td style="text-align: center;"><p>XML string of Voucher Data that is to be added in BUSY. XML string should be in BUSY predefined format.</p></td>
<td colspan="2"><p><strong>Result</strong></p></td>
<td><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>VoucherCode</strong></p></td>
<td style="text-align: center;"><p>Specify the unique voucher code of the voucher</p></td>
<td colspan="2"><p><strong>Description</strong></p></td>
<td><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
<td colspan="3" rowspan="2"></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
</tr>
<tr>
<td rowspan="4" style="text-align: center;"><p><strong>5</strong></p></td>
<td rowspan="4" style="text-align: center;"><p><strong>Add Master from XML</strong></p></td>
<td rowspan="4" style="text-align: center;"><p>This service is used to add a new Master in BUSY from XML string. This XML string should be in predefined XML format.</p></td>
<td style="text-align: center;"><p><strong>MasterType</strong></p></td>
<td style="text-align: center;"><p>Specify Master Type for which master is to be added. For constant value of Master Types kindly refer to BUSY Constants.doc file</p></td>
<td colspan="2"><p><strong>Body</strong></p></td>
<td><p>Unique Master Code generated (long value)</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>MasterXML</strong></p></td>
<td style="text-align: center;"><p>XML string of Master Data that is to be added in BUSY. XML string should be in BUSY predefined format.</p></td>
<td colspan="2"><p><strong>Result</strong></p></td>
<td><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
<td colspan="2"><p><strong>Description</strong></p></td>
<td><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
<td colspan="3"></td>
</tr>
<tr>
<td rowspan="4" style="text-align: center;"><p><strong>6</strong></p></td>
<td rowspan="4" style="text-align: center;"><p><strong>Modify Master From XML by Code</strong></p></td>
<td rowspan="4" style="text-align: center;"><p>This Service is used to modify a master from XML string using Master Code.</p></td>
<td style="text-align: center;"><p><strong>MasterCode</strong></p></td>
<td style="text-align: center;"><p>Specify Master Code of the master that is to be modified.</p></td>
<td colspan="2"><p><strong>Body</strong></p></td>
<td><p>Master Code (long value)</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>MasterXML</strong></p></td>
<td style="text-align: center;"><p>XML string of Master Data that is to be modified in BUSY. XML string should be in BUSY predefined format.</p></td>
<td colspan="2"><p><strong>Result</strong></p></td>
<td><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
<td colspan="2"><p><strong>Description</strong></p></td>
<td><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
<td colspan="3"></td>
</tr>
<tr>
<td rowspan="5" style="text-align: center;"><p><strong>7</strong></p></td>
<td rowspan="5" style="text-align: center;"><p><strong>Modify Master From XML by Name</strong></p></td>
<td rowspan="5" style="text-align: center;"><p>This Service is used to modify a master from XML string using Master Name.</p></td>
<td style="text-align: center;"><p><strong>MasterName</strong></p></td>
<td style="text-align: center;"><p>Specify Master Name of the master that is to be modified.</p></td>
<td colspan="2"><p><strong>Result</strong></p></td>
<td><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>MasterType</strong></p></td>
<td style="text-align: center;"><p>Specify Master Type for which master is to be added. For constant value of Master Types kindly refer to BUSY Constants.doc file</p></td>
<td colspan="2"><p><strong>Description</strong></p></td>
<td><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>MasterXML</strong></p></td>
<td style="text-align: center;"><p>XML string of Master Data that is to be modified in BUSY. XML string should be in BUSY predefined format.</p></td>
<td colspan="3" rowspan="3"></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;"><p><strong>8</strong></p></td>
<td rowspan="3" style="text-align: center;"><p><strong>GetVchXML</strong></p></td>
<td rowspan="3" style="text-align: center;"><p>This service is used to get the voucher data in XML format.</p></td>
<td style="text-align: center;"><p><strong>VoucherCode</strong></p></td>
<td style="text-align: center;"><p>Specify the unique voucher code of the voucher for which XML is to be retrieved</p></td>
<td colspan="2"><p><strong>Body</strong></p></td>
<td><p>XML String of voucher data</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
<td colspan="2"><p><strong>Result</strong></p></td>
<td><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
<td colspan="2"><p><strong>Description</strong></p></td>
<td><p>returns the error message if Result is ‘F’</p></td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;"><p><strong>9</strong></p></td>
<td rowspan="3" style="text-align: center;"><p><strong>GetMasterXML</strong></p></td>
<td rowspan="3" style="text-align: center;"><p>This service is used to get the master data in XML format.</p></td>
<td style="text-align: center;"><p><strong>MasterCode</strong></p></td>
<td style="text-align: center;"><p>Specify the unique master code of the master for which XML is to be retrieved</p></td>
<td colspan="2"><p><strong>Body</strong></p></td>
<td><p>XML String of master data</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>UserName</strong></p></td>
<td style="text-align: center;"><p>Valid User Name of the BUSY Company</p></td>
<td colspan="2"><p><strong>Result</strong></p></td>
<td><p>‘T’/’F’ ; ‘T’ stands for True and ‘F’ stands for False</p></td>
</tr>
<tr>
<td style="text-align: center;"><p><strong>Pwd</strong></p></td>
<td style="text-align: center;"><p>Valid Password for that user of BUSY Company</p></td>
<td colspan="2"><p><strong>Description</strong></p></td>
<td><p>returns the error message if Result is ‘F’</p></td>
</tr>
</tbody>
</table>
