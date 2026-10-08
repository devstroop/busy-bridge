> **<u>Designing Custom Validations</u>**

In this document, we will discuss all the steps involved in designing a Custom Validation.

**<u>Step 1</u>**

Click *Administration 🡪 Utilities 🡪 Customization 🡪 Custom Validation* menu. Create a new format by clicking *Add New* button.

*Pls Note: ‘Customization’ menu would be visible in following two ways:*

1.  *By copying UMS License (\*.UMS) file to BusyWin Folder.*

2.  *Using ‘CD’ in command line arguments while creating shortcut of BUSY*

To enhance security of custom validations, you can bind each custom validation script with serial no. / Dongle no. Along with binding, you can also provide password for modification or deletion of the script.

**<u>Step 2</u>**

Select the required format that you want to configure :

1.  **Vouchers**: In case of vouchers first you have to specify Voucher type and Form type for which you want to generate Custom Validation script, then Voucher Series Name is to be specified else script will be applicable to all series of specified Voucher Type.

2.  **Masters:** In case of Masters you have to specify Master type and Form type.

3.  **Main Form:** To generate custom validation script for Busy Main Form or if you want to take any action on company open or close.

Given here is a screenshot displaying script configuration for custom validation.

<img src="media/image1.png" style="width:6.27014in;height:4.41837in" alt="C:\Users\Sonia\Desktop\Doc\1.png" />

**<u>Step 3</u>**

After format configuration next step is to specify the logic for generating Customized script. A Data Entry Script Logic area appears with some predefined code written in it. Click *Edit Script* button to edit code or to write logic for the script. On clicking the button, the window will open script in the editable format in VBSEdit.

Given here is a screenshot displaying code in VBSEdit format.

<img src="media/image2.png" style="width:6.54211in;height:4.61458in" alt="C:\Users\Sonia\Desktop\Doc\2.png" />

In the VBSEdit window, there are some **predefined objects** defined at the starting of window. These predefined objects are:

- **BusyLib** – Use this object to access predefined functions build in Busy. For example, to convert MasterCode to name, you can use *BusyLib.MasterCode2Name* function that will accept MasterCode as its parameter and return name of Master.

- **BusyConst** – Use this object to access all the constants defined in Busy. For example, to access the value of *Account* master, you can use *BusyConst.ACC_MAST*.

- **BusyCompConfig** – Use this object to access value of company configurations defined in Features / Options if required. For example, to access currency decimal places defined in *Features / Options,* you can use *BusyCompConfig.CurDecimal* function and to access Quantity Decimal places defined in *Features / Options*, you can use *BusyCompConfig.QtyDecimal function.*

- **BusyForm** – Use this object to access all the controls and public properties and methods of the Busy Form on which validation script is applicable. For example, if script is to written for Item Master then to read the value of Item Name text box in the script you have to write *BusyForm.txtName.Text* where ‘*txtName’* is name of standard VB TextBox control used to input the value of Item Name and *‘Text’* is the property of the standard VB TextBox control.

**<u>Classes available in Voucher Custom Data Entry:</u>**

The controls which are visible on form you can directly read or update value of these controls using BusyForm. But the controls which are not visible on form you have to use these classes to read or update.

- **BusyVchData –** BusyVchData is a class which represents udtVchdata. For e.g. if you want to read or update VehicleNo in transport details you can use ***BusyVchData.VehicleNo***.

- **BusyItemData -**BusyItemData is a class which represents udtItemData. BusyItemData is used to access values of a single row of Item Grid. For e.g. to read or update Item Description1 row you can use ***BusyItemData.Desc1(p_Row),*** here p_Row is RowNo of Item grid.

- **BusyBSData –** BusyBsData is a class which represents udtBSData. BusyBSData is used to access values of a single row of Bill Sundry grid. For e.g. to read BSCode you can use ***BusyBSData.BSCode(p_Row),*** here p_Row is RowNo of Bill Sundry grid.

<!-- -->

- **BusyAccData –** BusyAccData represents udtAccData. BusyAccData is available in accounting vouchers and it is used to access values of a single row of Grid. For e.g. If you want to know Amount Type, you can use ***BusyAccData.AmountType(p_Row)***, here p_Row is RowNo of grid.

- **BusyBatchData –** BusyBatchData is used to access a single row of Batch data for a single Item grid Row. For e.g. to read or update BatchNo, you can use ***BusyBatchData.BatchNo(p_ItemRow,p_BatchRow),*** here p_ItemRow represents RowNo of Item grid and p_BatchRow represents RowNo of Batch grid.

- **BusyParamData –** BusyParamData is used to access a single row of Parameter data for a single Item grid Row. For e.g. to read or update BCN, you can use ***BusyParamData.BCN(p_ItemRow,p_ParamRow),*** here p_ItemRow represents RowNo of Item grid and p_ParamRow represents RowNo of Parameter grid.

- **BusySNData –** BusySNData is used to access a single row of SerialNo data for a single Item grid Row. For e.g. to read or update Serial no. Description, you can use ***BusySNData.Desc1(p_ItemRow,p_SNRow),*** here p_ItemRow represents RowNo of Item grid and p_SNRow represents RowNo of SerialNo grid.

- **BusyJobData –** BusyJobData is used to access a single row of JobWork data for a single Item grid Row. For e.g. to read JobID, you can use ***BusyJobData.JobID(p_ItemRow,p_JobRow),*** here p_ItemRow represents RowNo of Item grid and p_JobRow represents RowNo of JobWork grid.

- **BusyCCData –** BusyCCData is used to access a single row of CostCentre data. For e.g. to read CostCentre name, you can use ***BusyCCData.CCName(p_AccCode,p_CCRow),*** here p_AccCode represents code of account for which you want to read or update cost centre details and p_CCRow represents RowNo of CostCentre grid.

- **BusyBillRefData –** BusyBillRefData is used to access a single row of Bill Reference data. For e.g. to read or update BillRefNo, you can use ***BusyBillRefData.BillRefNo (p_AccCode,p_BillRefRow),*** here p_AccCode represents code of account for which you want to read or update Bill Reference and p_BillRefRow represents RowNo of Bill Reference grid.

**<u>For Customization following *Events* are available:</u>**

1.  **Text Box Events**

- **TextBox_Validate** - Occurs before a Text Box control loses its focus. The Validate event is used to verify the input to Text Box control before allowing the user to shift focus away from Text Box control. The Validate event is more suited to validating data entry than the LostFocus event because the LostFocus event (by definition) occurs after the focus has shifted. In contrast, by using the Validate event you can prevent the focus from ever shifting to another control until all validation rules have been met. For e.g. in Custom Validation script for Item Master if you want to restrict user to enter unit as ‘Pcs.’ only if Item Group is ‘Computer’ then you can use this event like:

> *Public Function txtUnit_Validate(p_ErrMsg)\
>     If StrComp(BusyForm.txtGroup.text , "Computer") = 0 And StrComp(BusyForm.txtUnit.text , "Pcs.") \<\> 0 Then*
>
> *\
>         txtUnit_Validate = False\
>         p_ErrMsg = "Invalid Unit for this Item Group."\
>     Else\
>         txtUnit_Validate = true\
>         p_ErrMsg = ""\
>     End If\
> End Function*

- **TextBox_GotFocus** – Occurs when TextBox control receives the focus. Typically, you use a GotFocus event to specify the actions that occur when a control receives the focus. By attaching GotFocus event you can enable/disable or update the value of any other control on the form. For e.g. in Custom Validation script for Item Master if you want to update the value of Item Group text box with default value as ‘General’, then you can use this event like:

> *Public Sub txtGroup_GotFocus()*
>
> *BusyForm.txtGroup.Text = "General"*
>
> *End Sub*

- **TextBox_LostFocus** – Occurs when TextBox control loses the focus. A LostFocus event procedure is primarily useful for verification and validation updates. Using LostFocus can cause validation to take place as the user moves the focus from the control. Another use for this type of event procedure is enable/disable or updates the value of any other control as in a GotFocus event procedure. For e.g. in Custom Validation script for Item Master if you want to update the value of Unit TextBox control as ‘Pcs.’ if the value of Item Group TextBox is ‘Computers’, then you can use this event like:

> *Public Sub txtGroup_LostFocus() \
>     If StrComp(BusyForm.txtGroup.Text, "Computer") = 0 Then\
>         BusyForm.txtUnit.Text = "Pcs."\
>     End If *
>
> *End Sub*

- **TextBox_KeyDown –** KeyDown event detect a physical keystroke in their KeyCode parameter. KeyDown can detect keystrokes not recognized by KeyPress, such as function, editing and navigation keys. This event is used to capture KeyDown on TextBox. For e.g. If you want to enter some extra Details of Party in AddOn form, then you can use KeyDown event of txtParty.

> *Public Sub txtParty_KeyDown(KeyCode, Shift)\
> if KeyCode = 13 then*
>
> *BusyLib.CallInternalAddOn "InternalAddOn"*

*End if*

*End Sub*

> (13 is KeyCode for VbKeyReturn)

- **TextBox_KeyPress –** KeyPress event detects a character in its KeyAscii parameter. KeyPress can distinguish between different ASCII characters generated by the same physical Keystroke. This event is used to capture KeyPress on TextBox.

> *Public Sub txtParty_KeyPress(KeyAscii)\
> if KeyAscii = 68 then*
>
> *Busylib.ShowMsg “Test Msg”*

*End if*

*End Sub*

68. s KeyAscii for VbKeyD)

<!-- -->

2.  **Command Button Events**

- **Command_Click –** Occurs on the click of existing Button or you can capture Click event of Busy command button which is added using custom script.

> *Public Sub command1_Click()\
>     Busylib.ShowMsg "Hello"\
> End Sub*

3.  **Form Events**

- **Form_KeyDown –** KeyDown event detect a physical keystroke in their KeyCode parameter. KeyDown can detect keystrokes not recognized by KeyPress, such as function, editing and navigation keys. This event used to capture KeyDown on Form.

> *Public Sub Form_KeyDown(KeyCode, Shift)\
> if KeyCode = 113 then*
>
> *Busylib.ShowMsg “Form KeyDown.”,”KeyDown”*

*End if*

*End Sub*

> (113 is KeyCode for VbKeyF3)

- **Form_KeyPress –** KeyPress event detects a character in its KeyAscii parameter. KeyPress can distinguish between different ASCII characters generated by the same physical Keystroke. This event is used to capture KeyPress on Form.

> *Public Sub Form_KeyPress(KeyAscii)\
> if KeyAscii = 68 then*
>
> *Busylib.ShowMsg “Test Msg”,”KeyPress”*

*End if*

*End Sub*

> (68 is KeyAscii for VbKeyD)

- **Form_Validate** – Occurs before saving all data input by user on the Form. This event is used to perform final validations before saving all the data of Master or Transaction to the database.

> *Public Function Form_Validate(p_ErrMsg)\
>     Form_Validate = True\
>     \
>     If BusyForm.txtNarration.text = "" Then\
>         Form_Validate = False\
>         p_ErrMsg = "Narration can’t be blank."\
>     End If     \
> End Function*

- **Form_Unload** – Occurs before a form closes. This event is used to show some information before Form the will be closed.

> *Public Sub Form_Unload(Cancel)\
>     Dim tmpVal\*
>
> *    tmpVal = *
>
> *BusyLib.GetAccClosingBal(1004,BusyForm.txtDate.DateVal)\
>     BusyLib.ShowMsg "Closing Bal. " & tmpVal ,"Closing Bal.!! "  \
> End Sub*

- **Form_QueryUnload** – Occurs before Form_Unload event. For e.g. If you want to restrict Form escape after item entry in grid then you can use this event.

> *Public Sub Form_QueryUnload(Cancel,UnloadMode)\
>     If GetData_grdItem(1,1) = "" then\
>         Cancel = 1\
>     End If \
> End Sub*

- **CanDelete –** Occurs before deletion of a Voucher or Master. For e.g. you can use this event to restrict voucher deletion.

> *Public Function CanDelete(p_ErrMsg)\
>        CanDelete = False                     *
>
> *p_ErrMsg = "You don't have rights to delete voucher.”\
> End Function*

- **BeforeSaving –** Occurs before saving of a voucher and before Form_Validate event. This event is used to update some values before voucher saving. Foe e.g. If you want to update Bill References before voucher saving.

> *Public Sub BeforeSaving()\
>     BusyBillRefData.BillRefNo(1008,1) = "R1"\
>     BusyBillRefData.Method(1008,1) = BusyConst.METHOD_NEWREF\
>     BusyBillRefData.Value1(1008,1) = 100\
>     BusyBillRefData.DueDate(1008,1) = BusyForm.txtDated.DateVal\
> End Sub*

- **AfterSaving –** Occurs after saving of a Voucher or Master. This event is used to perform some action after saving. For e.g. If you want to Print voucher after saving, then you can use this event. In this event there is a ByRef Parameter *p_VchCode,* to get currently saved VchCode.

> *Public Sub AfterSaving(p_VchCode)\
>     BusyLib.PrintDocument p_VchCode       *
>
> *End Sub*

- **BeforeDeletion –** You can use this event to perform some action before deletion of current voucher. This event occurs after CanDelete event.

- **AfterDeletion –** Occurs after deletion of a Voucher or Master. For e.g. If you want to delete some other data after deletion of current voucher then you can use this event.

4.  **Grid Events**

- **Grd_MyGridTextChanged –** Occurs while changing value of a particular cell in grid. For e.**g.** If you want to update Quantity while updating Item in grid you can use this event.

> *Public Sub grdItem_MyGridTextChanged(p_Row, p_Col, p_Contents)\
>     If p_col=1 then\
>         ThrowData_grdItem p_Row, 4, 100\
>     End if\
> End Sub*

- **Grd_MyColEntryDone –** Occurs after ValidateCol event when data entry of a cell has been done. This event is used to take some action on the basis of data entry of a cell in grid. For e.g. throw Price in grid on the basis of Item.

> *Public Function grdItem_MyColEntryDone(p_Row , p_Col)\
>     If p_Col = 1 Then\
>         \
>         If GetData_grdItem(p_Row,1) = "Item1" Then\
>             ThrowData_grdItem  p_row, 4 , 100\
>         ElseIf GetData_grdItem(p_Row,1) = " "Item2" Then\
>             ThrowData_grdItem  p_row, 4 , 200\
>         End If \
>     End If\
> End Function*

- **Grd_GotFocus –** Occurs when grid control receives the focus. By attaching GotFocus event you can enable/disable or update the value of any other control on the form. For e.g. in Custom Validation script for Item Master if you want to update the value of Item Group text box with default value as ‘General’, then you can use this event like:

> *Public Function grdBS_GotFocus()*
>
> *ThrowData_grdBS 1,1,"Discount"*
>
> *End Function*

- **Grd_ValidateCol -** The ValidateCol event is used to verify the input to Grid column before allowing the user to shift focus away from current column to next column. The ValidateCol event is suited to validating data entry.

> *Public Function grdBs_ValidateCol(p_Row,p_Col,p_ErrMsg)\
>     Dim BSName \
>     *
>
> *BSName =  GetData_grdBS(p_Row,1) \
>         \
>     If BusyLib.BlankStr(BSName) then\
>             grdBs_ValidateCol = False\
>            p_ErrMsg = "Invalid Data."\
>     Else\
>         grdBs_ValidateCol = True\
>         p_ErrMsg = ""\
>     End If \
> End Function*

- **Grd_ValidateRow -** The ValidateRow event is used to verify the input to Grid Row before allowing the user to shift focus away from current Row to next Row. The ValidateRow event is suited to validating data entry.

> *Public Function grdItem_ValidateRow(p_Row, p_ErrMsg)\
>     If GetData_grdItem(p_row, 4)\<= 0 Then\
>         p_errmsg = "Price Cannot be ZERO."\
>         grdItem_ValidateRow = False\
>     Else\
>         grdItem_ValidateRow = True\
>     End If\
> End Function*

- **Grd_MyCanDeleteRow –** Occurs before deletion of Grid Row. This event is used to restrict row deletion in grid.

> *Public Function grdItem_MyCanDeleteRow(p_Row, p_ErrMsg)\
>     grdItem_MyCanDeleteRow = False\
>     p_errMsg = "Can Not Delete Row"\
> End Function*

- **Grd_MyCanInsertRow –** Occurs before inserting a new Row in Grid. This event is used to restrict row insertion in grid.

> *Public Function grdItem_MyCanInsertRow(p_Row, p_ErrMsg)\
>     grdItem_MyCanInsertRow = False\
>     p_errMsg = "Can Not Insert Row"\
> End Function*

- **Grd_KeyDown –** KeyDown event detect a physical keystroke in their KeyCode parameter. KeyDown can detect keystrokes not recognized by KeyPress, such as function, editing and navigation keys. This event is used to capture KeyDown on Grid.

> *Public Sub grdItem_KeyDown(KeyCode, Shift)\
> if KeyCode = 113 then*
>
> *Busylib.ShowMsg “You can’t edit Party.”,”KeyDown”*

*End if*

*End If*

> (113 is KeyCode for vbKeyF3)

- **Grd_KeyPress -** KeyPress event detects a character in its KeyAscii parameter. KeyPress can distinguish between different ASCII characters generated by the same physical Keystroke. This event is used to capture KeyPress on Grid.

> *Public Sub grdItem_KeyPress(KeyAscii)\
> if KeyAscii = 68 then*
>
> *Busylib.ShowMsg “Test Msg”,”KeyPress”*

*End if*

*End If*

> (68 is KeyAscii for VbKeyD)

5.  **Menu Events**

- **Menu_Click –** Menu Click event is available in Main Form scripts only. This event is used to capture existing menu click. For e.g. If you want to open your AddOn form in place of Sales voucher node then you can use this event. This procedure receives two parameters, one is MenuId of the node on which you want to perform some action and other is a Boolean parameter to specify either you want to open Busy form after executing script or not.

> *Public Sub MenuClick(p_MenuID,p_OpenActualMenu)\
>     \
>     If p_MenuID = "M03-03-01" Then\
>        BusyLib.CallInternalAddOn "InternalAddOn"\
>         p_OpenActualMenu = False\
>     End If \
> End Sub*

**<u>Disable Busy Forms</u>**

Using Custom Data Entry you can also hide some Busy forms and open your redesigned AddOn forms. For e.g. If you want to hide Busy Parameter Data entry form, and in place of that you want to open your own designed Parameter AddOn then you can write ***DisableParamForm True*** in update objects to hide Parameter Form.

Given here is a screenshot displaying code to Disable Parameter Form.

<img src="media/image3.png" style="width:6.04167in;height:4.19792in" alt="C:\Users\Sonia\Desktop\Doc\4.png" />

> ------------------ x -----------------
