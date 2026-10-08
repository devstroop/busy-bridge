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
        Me.btnSaveAcc = New System.Windows.Forms.Button()
        Me.btnSaveItem = New System.Windows.Forms.Button()
        Me.btnSaveUnit = New System.Windows.Forms.Button()
        Me.btnSaveBillSundry = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'btnSaveAcc
        '
        Me.btnSaveAcc.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaveAcc.Location = New System.Drawing.Point(56, 53)
        Me.btnSaveAcc.Name = "btnSaveAcc"
        Me.btnSaveAcc.Size = New System.Drawing.Size(263, 46)
        Me.btnSaveAcc.TabIndex = 0
        Me.btnSaveAcc.Text = "Save Acc Master thru XML"
        Me.btnSaveAcc.UseVisualStyleBackColor = True
        '
        'btnSaveItem
        '
        Me.btnSaveItem.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaveItem.Location = New System.Drawing.Point(56, 115)
        Me.btnSaveItem.Name = "btnSaveItem"
        Me.btnSaveItem.Size = New System.Drawing.Size(263, 46)
        Me.btnSaveItem.TabIndex = 1
        Me.btnSaveItem.Text = "Save Item Master thru XML"
        Me.btnSaveItem.UseVisualStyleBackColor = True
        '
        'btnSaveUnit
        '
        Me.btnSaveUnit.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaveUnit.Location = New System.Drawing.Point(56, 177)
        Me.btnSaveUnit.Name = "btnSaveUnit"
        Me.btnSaveUnit.Size = New System.Drawing.Size(263, 46)
        Me.btnSaveUnit.TabIndex = 2
        Me.btnSaveUnit.Text = "Save Unit Master thru XML"
        Me.btnSaveUnit.UseVisualStyleBackColor = True
        '
        'btnSaveBillSundry
        '
        Me.btnSaveBillSundry.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSaveBillSundry.Location = New System.Drawing.Point(56, 239)
        Me.btnSaveBillSundry.Name = "btnSaveBillSundry"
        Me.btnSaveBillSundry.Size = New System.Drawing.Size(263, 46)
        Me.btnSaveBillSundry.TabIndex = 3
        Me.btnSaveBillSundry.Text = "Save Bill Sundry Master thru XML"
        Me.btnSaveBillSundry.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(372, 340)
        Me.Controls.Add(Me.btnSaveBillSundry)
        Me.Controls.Add(Me.btnSaveUnit)
        Me.Controls.Add(Me.btnSaveItem)
        Me.Controls.Add(Me.btnSaveAcc)
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents btnSaveAcc As System.Windows.Forms.Button
    Friend WithEvents btnSaveItem As System.Windows.Forms.Button
    Friend WithEvents btnSaveUnit As System.Windows.Forms.Button
    Friend WithEvents btnSaveBillSundry As System.Windows.Forms.Button

End Class
