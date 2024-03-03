frappe.ui.form.on('Employee Promotion', {
    validate: function(frm) {
        // Get the new_designation value from the current Employee Promotion record
        var newDesignation = frm.doc.new_designation;

        // Fetch the Employee record linked to this promotion
        frappe.call({
            method: 'erpnext.hr.update_employee_designation',
            args: {
                employee_promotion: frm.doc.name,
                new_designation: newDesignation
            },
            callback: function(response) {
              console.log("mployee data updated successfully");
            }
        });
    }
});