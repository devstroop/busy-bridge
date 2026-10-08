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
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnSR = New System.Windows.Forms.Button()
        Me.btnPurc = New System.Windows.Forms.Button()
        Me.btnPR = New System.Windows.Forms.Button()
        Me.btnJrnl = New System.Windows.Forms.Button()
        Me.btnPO = New System.Windows.Forms.Button()
        Me.btnDelete = New System.Windows.Forms.Button()
        Me.btnStkJrnl = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'btnSave
        '
        Me.btnSave.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnSave.Location = New System.Drawing.Point(60, 20)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(318, 37)
        Me.btnSave.TabIndex = 0
        Me.btnSave.Text = "Save Sale Voucher thru XML"
        Me.btnSave.UseVisualStyleBackColor = True
        '
        'btnSR
        '
        Me.btnSR.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSR.Location = New System.Drawing.Point(60, 76)
        Me.btnSR.Name = "btnSR"
        Me.btnSR.Size = New System.Drawing.Size(318, 37)
        Me.btnSR.TabIndex = 1
        Me.btnSR.Text = "Save Sale Return Voucher thru XML"
        Me.btnSR.UseVisualStyleBackColor = True
        '
        'btnPurc
        '
        Me.btnPurc.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPurc.Location = New System.Drawing.Point(60, 132)
        Me.btnPurc.Name = "btnPurc"
        Me.btnPurc.Size = New System.Drawing.Size(318, 37)
        Me.btnPurc.TabIndex = 2
        Me.btnPurc.Text = "Save Purchase Voucher thru XML"
        Me.btnPurc.UseVisualStyleBackColor = True
        '
        'btnPR
        '
        Me.btnPR.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPR.Location = New System.Drawing.Point(60, 188)
        Me.btnPR.Name = "btnPR"
        Me.btnPR.Size = New System.Drawing.Size(318, 37)
        Me.btnPR.TabIndex = 3
        Me.btnPR.Text = "Save Purchase Return Voucher thru XML"
        Me.btnPR.UseVisualStyleBackColor = True
        '
        'btnJrnl
        '
        Me.btnJrnl.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnJrnl.Location = New System.Drawing.Point(60, 244)
        Me.btnJrnl.Name = "btnJrnl"
        Me.btnJrnl.Size = New System.Drawing.Size(318, 37)
        Me.btnJrnl.TabIndex = 4
        Me.btnJrnl.Text = "Save Jrnl Voucher thru XML"
        Me.btnJrnl.UseVisualStyleBackColor = True
        '
        'btnPO
        '
        Me.btnPO.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnPO.Location = New System.Drawing.Point(60, 300)
        Me.btnPO.Name = "btnPO"
        Me.btnPO.Size = New System.Drawing.Size(318, 37)
        Me.btnPO.TabIndex = 5
        Me.btnPO.Text = "Save PO Voucher thru XML"
        Me.btnPO.UseVisualStyleBackColor = True
        '
        'btnDelete
        '
        Me.btnDelete.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnDelete.Location = New System.Drawing.Point(60, 412)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.Size = New System.Drawing.Size(318, 37)
        Me.btnDelete.TabIndex = 6
        Me.btnDelete.Text = "Delete"
        Me.btnDelete.UseVisualStyleBackColor = True
        '
        'btnStkJrnl
        '
        Me.btnStkJrnl.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnStkJrnl.Location = New System.Drawing.Point(60, 356)
        Me.btnStkJrnl.Name = "btnStkJrnl"
        Me.btnStkJrnl.Size = New System.Drawing.Size(318, 37)
        Me.btnStkJrnl.TabIndex = 7
        Me.btnStkJrnl.Text = "Save Stock Journal thru XML"
        Me.btnStkJrnl.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(420, 483)
        Me.Controls.Add(Me.btnStkJrnl)
        Me.Controls.Add(Me.btnDelete)
        Me.Controls.Add(Me.btnPO)
        Me.Controls.Add(Me.btnJrnl)
        Me.Controls.Add(Me.btnPR)
        Me.Controls.Add(Me.btnPurc)
        Me.Controls.Add(Me.btnSR)
        Me.Controls.Add(Me.btnSave)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents btnSR As System.Windows.Forms.Button
    Friend WithEvents btnPurc As System.Windows.Forms.Button
    Friend WithEvents btnPR As System.Windows.Forms.Button
    Friend WithEvents btnJrnl As System.Windows.Forms.Button
    Friend WithEvents btnPO As System.Windows.Forms.Button
    Friend WithEvents btnDelete As System.Windows.Forms.Button
    Friend WithEvents btnStkJrnl As System.Windows.Forms.Button

End Class
