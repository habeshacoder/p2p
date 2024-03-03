frappe.ui.form.on('Fuel Request for Equipment Form', {
    plate_no: function (frm) {
        if (frm.doc.plate_no) {
            frappe.call({
                method: 'frappe.client.get_value',
                args: {
                    doctype: 'Fuel Request for Equipment Form',
                    filters: { 'plate_no': frm.doc.plate_no, 'name': ['!=', frm.docname] },
                    fieldname: ['current_km_reading', 'date', 'current_fuel_issue']
                },
                callback: function (response) {
                    if (response.message) {
                        var current_previous_km_reading = response.message.current_km_reading;
                        var current_previous_fuel_issue = response.message.current_fuel_issue;
                        var current_previous_date_issued = response.message.date;
                        frm.set_value('previous_km_reading', current_previous_km_reading);
                        frm.set_value('fuel_issue', current_previous_fuel_issue);
                        frm.set_value('date_issued', current_previous_date_issued);
                        console.log(`current previous km reading is ${current_previous_km_reading}`);
                        console.log(`date issued ${current_previous_date_issued}`)
                        console.log(`fuel issue ${current_previous_fuel_issue}`)
                        // Set other fields as needed
                    }
                }
            });
            frappe.call({
                method: "frappe.client.get_value",
                args: {
                    doctype: "Equipment Birth Certificate Form",
                    filters: { 'plate_no': frm.doc.plate_no, 'name': ['!=', frm.docname] },
                    fieldname: ["equipment_type"],
                },
                callback: function (response) {
                    if (response.message) {
                        // Update the "equipment_type" field in the parent document
                        frm.set_value('equip_code',response.message.equipment_type);
                    }
                },
            })
        }
    },
    current_km_reading: function (frm) {
        if (frm.doc.current_km_reading && frm.doc.previous_km_reading && frm.doc.fuel_issue) {
            var difference = frm.doc.current_km_reading - frm.doc.previous_km_reading;
            var fuel_issue = frm.doc.fuel_issue; // Make sure fuel_issue is declared and assigned a value
            if (fuel_issue !== 0) {
                var kml = difference / fuel_issue;
                frm.set_value('kml', kml);
                frm.refresh_field('kml');
                console.log(`the new value from this ${kml}`)
            } else {
                // Handle the case where fuel_issue is zero
                // Display an error message or handle it as appropriate
            }
        }
    }
});
//frappe call and all its arguments
 frappe.call({
                method: "frappe.client.get_value",
                args: {
                    doctype: "Equipment Birth Certificate Form",
                    filters: { 'plate_no': frm.doc.plate_no, 'name': ['!=', frm.docname] },
                    fieldname: ["equipment_type"],//
                },
                callback: function (response) {
                    if (response.message) {
                        // Update the "equipment_type" field in the parent document
                        frm.set_value('equip_code',response.message.equipment_type);
                    }
                },
     })