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
        Me.btnExecuteQry = New System.Windows.Forms.Button()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.btnAddSaleVch = New System.Windows.Forms.Button()
        Me.btnModifySaleVch = New System.Windows.Forms.Button()
        Me.btnModifyByVchCode = New System.Windows.Forms.Button()
        Me.btnAddMaster = New System.Windows.Forms.Button()
        Me.btnModifyMaster = New System.Windows.Forms.Button()
        Me.btnModifyMasterByName = New System.Windows.Forms.Button()
        Me.btnAddJrnlVch = New System.Windows.Forms.Button()
        Me.btnOpenDB = New System.Windows.Forms.Button()
        Me.btnCloseDB = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'btnExecuteQry
        '
        Me.btnExecuteQry.Location = New System.Drawing.Point(15, 157)
        Me.btnExecuteQry.Name = "btnExecuteQry"
        Me.btnExecuteQry.Size = New System.Drawing.Size(91, 23)
        Me.btnExecuteQry.TabIndex = 0
        Me.btnExecuteQry.Text = "Execute Query"
        Me.btnExecuteQry.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 21)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(39, 13)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Label1"
        '
        'btnAddSaleVch
        '
        Me.btnAddSaleVch.Location = New System.Drawing.Point(15, 211)
        Me.btnAddSaleVch.Name = "btnAddSaleVch"
        Me.btnAddSaleVch.Size = New System.Drawing.Size(106, 23)
        Me.btnAddSaleVch.TabIndex = 2
        Me.btnAddSaleVch.Text = "Add Sale Voucher"
        Me.btnAddSaleVch.UseVisualStyleBackColor = True
        '
        'btnModifySaleVch
        '
        Me.btnModifySaleVch.Location = New System.Drawing.Point(15, 240)
        Me.btnModifySaleVch.Name = "btnModifySaleVch"
        Me.btnModifySaleVch.Size = New System.Drawing.Size(159, 23)
        Me.btnModifySaleVch.TabIndex = 3
        Me.btnModifySaleVch.Text = "Modify Sale Voucher (by Key)"
        Me.btnModifySaleVch.UseVisualStyleBackColor = True
        '
        'btnModifyByVchCode
        '
        Me.btnModifyByVchCode.Location = New System.Drawing.Point(15, 269)
        Me.btnModifyByVchCode.Name = "btnModifyByVchCode"
        Me.btnModifyByVchCode.Size = New System.Drawing.Size(183, 23)
        Me.btnModifyByVchCode.TabIndex = 4
        Me.btnModifyByVchCode.Text = "Modify Sale Voucher (by VchCode)"
        Me.btnModifyByVchCode.UseVisualStyleBackColor = True
        '
        'btnAddMaster
        '
        Me.btnAddMaster.Location = New System.Drawing.Point(276, 211)
        Me.btnAddMaster.Name = "btnAddMaster"
        Me.btnAddMaster.Size = New System.Drawing.Size(106, 23)
        Me.btnAddMaster.TabIndex = 5
        Me.btnAddMaster.Text = "Add Master"
        Me.btnAddMaster.UseVisualStyleBackColor = True
        '
        'btnModifyMaster
        '
        Me.btnModifyMaster.Location = New System.Drawing.Point(276, 240)
        Me.btnModifyMaster.Name = "btnModifyMaster"
        Me.btnModifyMaster.Size = New System.Drawing.Size(136, 23)
        Me.btnModifyMaster.TabIndex = 6
        Me.btnModifyMaster.Text = "Modify Master (by Code)"
        Me.btnModifyMaster.UseVisualStyleBackColor = True
        '
        'btnModifyMasterByName
        '
        Me.btnModifyMasterByName.Location = New System.Drawing.Point(276, 269)
        Me.btnModifyMasterByName.Name = "btnModifyMasterByName"
        Me.btnModifyMasterByName.Size = New System.Drawing.Size(136, 23)
        Me.btnModifyMasterByName.TabIndex = 7
        Me.btnModifyMasterByName.Text = "Modify Master (by Name)"
        Me.btnModifyMasterByName.UseVisualStyleBackColor = True
        '
        'btnAddJrnlVch
        '
        Me.btnAddJrnlVch.Location = New System.Drawing.Point(15, 318)
        Me.btnAddJrnlVch.Name = "btnAddJrnlVch"
        Me.btnAddJrnlVch.Size = New System.Drawing.Size(128, 23)
        Me.btnAddJrnlVch.TabIndex = 8
        Me.btnAddJrnlVch.Text = "Add Journal Voucher"
        Me.btnAddJrnlVch.UseVisualStyleBackColor = True
        '
        'btnOpenDB
        '
        Me.btnOpenDB.Location = New System.Drawing.Point(15, 97)
        Me.btnOpenDB.Name = "btnOpenDB"
        Me.btnOpenDB.Size = New System.Drawing.Size(128, 23)
        Me.btnOpenDB.TabIndex = 9
        Me.btnOpenDB.Text = "Open DB "
        Me.btnOpenDB.UseVisualStyleBackColor = True
        '
        'btnCloseDB
        '
        Me.btnCloseDB.Location = New System.Drawing.Point(181, 97)
        Me.btnCloseDB.Name = "btnCloseDB"
        Me.btnCloseDB.Size = New System.Drawing.Size(106, 23)
        Me.btnCloseDB.TabIndex = 11
        Me.btnCloseDB.Text = "Close DB"
        Me.btnCloseDB.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(513, 382)
        Me.Controls.Add(Me.btnCloseDB)
        Me.Controls.Add(Me.btnOpenDB)
        Me.Controls.Add(Me.btnAddJrnlVch)
        Me.Controls.Add(Me.btnModifyMasterByName)
        Me.Controls.Add(Me.btnModifyMaster)
        Me.Controls.Add(Me.btnAddMaster)
        Me.Controls.Add(Me.btnModifyByVchCode)
        Me.Controls.Add(Me.btnModifySaleVch)
        Me.Controls.Add(Me.btnAddSaleVch)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.btnExecuteQry)
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents btnExecuteQry As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btnAddSaleVch As System.Windows.Forms.Button
    Friend WithEvents btnModifySaleVch As System.Windows.Forms.Button
    Friend WithEvents btnModifyByVchCode As System.Windows.Forms.Button
    Friend WithEvents btnAddMaster As System.Windows.Forms.Button
    Friend WithEvents btnModifyMaster As System.Windows.Forms.Button
    Friend WithEvents btnModifyMasterByName As System.Windows.Forms.Button
    Friend WithEvents btnAddJrnlVch As System.Windows.Forms.Button
    Friend WithEvents btnOpenDB As System.Windows.Forms.Button
    Friend WithEvents btnCloseDB As System.Windows.Forms.Button

End Class
