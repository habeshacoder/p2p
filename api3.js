cur_frm.add_fetch('equip_code','equipment_type','equip_type');
frappe.ui.form.on('Tyre Control Card', {
 onload: function(frm) {
  frappe.call({
   method: 'frappe.client.get_value',
   args: {
    doctype: 'User',
    filters: { name: frappe.session.user },
    fieldname: ['full_name']
   },
   callback: function(response) {
    var user = response.message;
    if (user) {
     frm.set_value('encoded_by', user.full_name);
    }
   }
  });
 }
});
frappe.ui.form.on('Tyre Control Table', {
    equip_code: function(frm, cdt, cdn) {
        var child = locals[cdt][cdn];
        // Fetch information from the linked doctype using a server call
        frappe.call({
            method: "frappe.client.get_value",
             args: {
                doctype: 'Equipment Birth Certificate Form',
                filters: { plate_no: child.equip_code},
                fieldname: ['equipment_type']
            },
            callback: function(response) {
                if (response.message) {
                    // Update the "equipment_type" field in the current child table row
                    frappe.model.set_value(cdt, cdn, "equip_type", response.message.equipment_type);
                }
            }
        });
    }});