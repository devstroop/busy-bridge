<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.btnSaleIgst = New System.Windows.Forms.Button()
        Me.btnSaleRetIgst = New System.Windows.Forms.Button()
        Me.btnPurcIgst = New System.Windows.Forms.Button()
        Me.btnPurcRetIgst = New System.Windows.Forms.Button()
        Me.btnJrnl = New System.Windows.Forms.Button()
        Me.btnPurcOrdIgst = New System.Windows.Forms.Button()
        Me.btnDelete = New System.Windows.Forms.Button()
        Me.btnStkJrnl = New System.Windows.Forms.Button()
        Me.btnSaleLgst = New System.Windows.Forms.Button()
        Me.btnSaleRetLgst = New System.Windows.Forms.Button()
        Me.btnPurcLgst = New System.Windows.Forms.Button()
        Me.btnPurcRetLgst = New System.Windows.Forms.Button()
        Me.btnPurcOrdLgst = New System.Windows.Forms.Button()
        Me.btnSavePayment = New System.Windows.Forms.Button()
        Me.btnSaveReceipt = New System.Windows.Forms.Button()
        Me.btnSaveDebitNote = New System.Windows.Forms.Button()
        Me.btnSaveCreditNote = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'btnSaleIgst
        '
        Me.btnSaleIgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnSaleIgst.Location = New System.Drawing.Point(60, 20)
        Me.btnSaleIgst.Name = "btnSaleIgst"
        Me.btnSaleIgst.Size = New System.Drawing.Size(357, 37)
        Me.btnSaleIgst.TabIndex = 0
        Me.btnSaleIgst.Text = "Save Sale Voucher thru XML(IGST)"
        Me.btnSaleIgst.UseVisualStyleBackColor = True
        '
        'btnSaleRetIgst
        '
        Me.btnSaleRetIgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaleRetIgst.Location = New System.Drawing.Point(60, 76)
        Me.btnSaleRetIgst.Name = "btnSaleRetIgst"
        Me.btnSaleRetIgst.Size = New System.Drawing.Size(357, 37)
        Me.btnSaleRetIgst.TabIndex = 1
        Me.btnSaleRetIgst.Text = "Save Sale Return Voucher thru XML(IGST)"
        Me.btnSaleRetIgst.UseVisualStyleBackColor = True
        '
        'btnPurcIgst
        '
        Me.btnPurcIgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPurcIgst.Location = New System.Drawing.Point(60, 132)
        Me.btnPurcIgst.Name = "btnPurcIgst"
        Me.btnPurcIgst.Size = New System.Drawing.Size(357, 37)
        Me.btnPurcIgst.TabIndex = 2
        Me.btnPurcIgst.Text = "Save Purchase Voucher thru XML(IGST)"
        Me.btnPurcIgst.UseVisualStyleBackColor = True
        '
        'btnPurcRetIgst
        '
        Me.btnPurcRetIgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPurcRetIgst.Location = New System.Drawing.Point(60, 188)
        Me.btnPurcRetIgst.Name = "btnPurcRetIgst"
        Me.btnPurcRetIgst.Size = New System.Drawing.Size(357, 37)
        Me.btnPurcRetIgst.TabIndex = 3
        Me.btnPurcRetIgst.Text = "Save Purchase Return Vch thru XML(IGST)"
        Me.btnPurcRetIgst.UseVisualStyleBackColor = True
        '
        'btnJrnl
        '
        Me.btnJrnl.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnJrnl.Location = New System.Drawing.Point(60, 346)
        Me.btnJrnl.Name = "btnJrnl"
        Me.btnJrnl.Size = New System.Drawing.Size(357, 37)
        Me.btnJrnl.TabIndex = 4
        Me.btnJrnl.Text = "Save Jrnl Voucher thru XML"
        Me.btnJrnl.UseVisualStyleBackColor = True
        '
        'btnPurcOrdIgst
        '
        Me.btnPurcOrdIgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPurcOrdIgst.Location = New System.Drawing.Point(60, 240)
        Me.btnPurcOrdIgst.Name = "btnPurcOrdIgst"
        Me.btnPurcOrdIgst.Size = New System.Drawing.Size(357, 37)
        Me.btnPurcOrdIgst.TabIndex = 5
        Me.btnPurcOrdIgst.Text = "Save PO Voucher thru XML(IGST)"
        Me.btnPurcOrdIgst.UseVisualStyleBackColor = True
        '
        'btnDelete
        '
        Me.btnDelete.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnDelete.Location = New System.Drawing.Point(60, 506)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.Size = New System.Drawing.Size(153, 37)
        Me.btnDelete.TabIndex = 6
        Me.btnDelete.Text = "Delete Vch"
        Me.btnDelete.UseVisualStyleBackColor = True
        '
        'btnStkJrnl
        '
        Me.btnStkJrnl.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnStkJrnl.Location = New System.Drawing.Point(60, 293)
        Me.btnStkJrnl.Name = "btnStkJrnl"
        Me.btnStkJrnl.Size = New System.Drawing.Size(357, 37)
        Me.btnStkJrnl.TabIndex = 7
        Me.btnStkJrnl.Text = "Save Stock Journal thru XML"
        Me.btnStkJrnl.UseVisualStyleBackColor = True
        '
        'btnSaleLgst
        '
        Me.btnSaleLgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnSaleLgst.Location = New System.Drawing.Point(423, 20)
        Me.btnSaleLgst.Name = "btnSaleLgst"
        Me.btnSaleLgst.Size = New System.Drawing.Size(339, 37)
        Me.btnSaleLgst.TabIndex = 8
        Me.btnSaleLgst.Text = "Save Sale Voucher thru XML(LGST)"
        Me.btnSaleLgst.UseVisualStyleBackColor = True
        '
        'btnSaleRetLgst
        '
        Me.btnSaleRetLgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaleRetLgst.Location = New System.Drawing.Point(423, 76)
        Me.btnSaleRetLgst.Name = "btnSaleRetLgst"
        Me.btnSaleRetLgst.Size = New System.Drawing.Size(339, 37)
        Me.btnSaleRetLgst.TabIndex = 9
        Me.btnSaleRetLgst.Text = "Save Sale Return Voucher thru XML(LGST)"
        Me.btnSaleRetLgst.UseVisualStyleBackColor = True
        '
        'btnPurcLgst
        '
        Me.btnPurcLgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPurcLgst.Location = New System.Drawing.Point(423, 132)
        Me.btnPurcLgst.Name = "btnPurcLgst"
        Me.btnPurcLgst.Size = New System.Drawing.Size(339, 37)
        Me.btnPurcLgst.TabIndex = 10
        Me.btnPurcLgst.Text = "Save Purchase Voucher thru XML(LGST)"
        Me.btnPurcLgst.UseVisualStyleBackColor = True
        '
        'btnPurcRetLgst
        '
        Me.btnPurcRetLgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPurcRetLgst.Location = New System.Drawing.Point(423, 188)
        Me.btnPurcRetLgst.Name = "btnPurcRetLgst"
        Me.btnPurcRetLgst.Size = New System.Drawing.Size(339, 37)
        Me.btnPurcRetLgst.TabIndex = 11
        Me.btnPurcRetLgst.Text = "Save Purchase Return Vch thru XML(LGST)"
        Me.btnPurcRetLgst.UseVisualStyleBackColor = True
        '
        'btnPurcOrdLgst
        '
        Me.btnPurcOrdLgst.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPurcOrdLgst.Location = New System.Drawing.Point(423, 240)
        Me.btnPurcOrdLgst.Name = "btnPurcOrdLgst"
        Me.btnPurcOrdLgst.Size = New System.Drawing.Size(339, 37)
        Me.btnPurcOrdLgst.TabIndex = 12
        Me.btnPurcOrdLgst.Text = "Save PO Voucher thru XML(LGST)"
        Me.btnPurcOrdLgst.UseVisualStyleBackColor = True
        '
        'btnSavePayment
        '
        Me.btnSavePayment.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSavePayment.Location = New System.Drawing.Point(60, 399)
        Me.btnSavePayment.Name = "btnSavePayment"
        Me.btnSavePayment.Size = New System.Drawing.Size(357, 37)
        Me.btnSavePayment.TabIndex = 20
        Me.btnSavePayment.Text = "Save Payment Vch thru XML"
        Me.btnSavePayment.UseVisualStyleBackColor = True
        '
        'btnSaveReceipt
        '
        Me.btnSaveReceipt.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaveReceipt.Location = New System.Drawing.Point(423, 399)
        Me.btnSaveReceipt.Name = "btnSaveReceipt"
        Me.btnSaveReceipt.Size = New System.Drawing.Size(339, 37)
        Me.btnSaveReceipt.TabIndex = 19
        Me.btnSaveReceipt.Text = "Save Receipt Vch thru XML"
        Me.btnSaveReceipt.UseVisualStyleBackColor = True
        '
        'btnSaveDebitNote
        '
        Me.btnSaveDebitNote.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaveDebitNote.Location = New System.Drawing.Point(423, 448)
        Me.btnSaveDebitNote.Name = "btnSaveDebitNote"
        Me.btnSaveDebitNote.Size = New System.Drawing.Size(339, 37)
        Me.btnSaveDebitNote.TabIndex = 18
        Me.btnSaveDebitNote.Text = "Save Debit Note Vch thru XML"
        Me.btnSaveDebitNote.UseVisualStyleBackColor = True
        '
        'btnSaveCreditNote
        '
        Me.btnSaveCreditNote.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaveCreditNote.Location = New System.Drawing.Point(60, 448)
        Me.btnSaveCreditNote.Name = "btnSaveCreditNote"
        Me.btnSaveCreditNote.Size = New System.Drawing.Size(357, 37)
        Me.btnSaveCreditNote.TabIndex = 17
        Me.btnSaveCreditNote.Text = "Save Credit Note Vch thru XML"
        Me.btnSaveCreditNote.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(809, 564)
        Me.Controls.Add(Me.btnSavePayment)
        Me.Controls.Add(Me.btnSaveReceipt)
        Me.Controls.Add(Me.btnSaveDebitNote)
        Me.Controls.Add(Me.btnSaveCreditNote)
        Me.Controls.Add(Me.btnPurcOrdLgst)
        Me.Controls.Add(Me.btnPurcRetLgst)
        Me.Controls.Add(Me.btnPurcLgst)
        Me.Controls.Add(Me.btnSaleRetLgst)
        Me.Controls.Add(Me.btnSaleLgst)
        Me.Controls.Add(Me.btnStkJrnl)
        Me.Controls.Add(Me.btnDelete)
        Me.Controls.Add(Me.btnPurcOrdIgst)
        Me.Controls.Add(Me.btnJrnl)
        Me.Controls.Add(Me.btnPurcRetIgst)
        Me.Controls.Add(Me.btnPurcIgst)
        Me.Controls.Add(Me.btnSaleRetIgst)
        Me.Controls.Add(Me.btnSaleIgst)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents btnSaleIgst As System.Windows.Forms.Button
    Friend WithEvents btnSaleRetIgst As System.Windows.Forms.Button
    Friend WithEvents btnPurcIgst As System.Windows.Forms.Button
    Friend WithEvents btnPurcRetIgst As System.Windows.Forms.Button
    Friend WithEvents btnJrnl As System.Windows.Forms.Button
    Friend WithEvents btnPurcOrdIgst As System.Windows.Forms.Button
    Friend WithEvents btnDelete As System.Windows.Forms.Button
    Friend WithEvents btnStkJrnl As System.Windows.Forms.Button
    Friend WithEvents btnSaleLgst As System.Windows.Forms.Button
    Friend WithEvents btnSaleRetLgst As System.Windows.Forms.Button
    Friend WithEvents btnPurcLgst As System.Windows.Forms.Button
    Friend WithEvents btnPurcRetLgst As System.Windows.Forms.Button
    Friend WithEvents btnPurcOrdLgst As System.Windows.Forms.Button
    Friend WithEvents btnSavePayment As System.Windows.Forms.Button
    Friend WithEvents btnSaveReceipt As System.Windows.Forms.Button
    Friend WithEvents btnSaveDebitNote As System.Windows.Forms.Button
    Friend WithEvents btnSaveCreditNote As System.Windows.Forms.Button

End Class
