cur_frm.add_fetch("Employee", "salary", "salary");
cur_frm.add_fetch("Employee", "perdiem", "perdiem");

frappe.ui.form.on("Additional Salary", {
     salary: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
                frappe.model.set_value(cdt, cdn, "ot_normal_amount", (d.ot_normal_hour/208) * 1.5 * d.salary);
     }
 });

frappe.ui.form.on("Additional Salary", {
      ot_normal_hour: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
                frappe.model.set_value(cdt, cdn, "ot_normal_amount", (d.ot_normal_hour/208) * 1.5 * d.salary);
     }
 });


frappe.ui.form.on("Additional Salary", {
     salary: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
                frappe.model.set_value(cdt, cdn, "ot_knight_amount", (d.ot_knight_hour/208) * 1.75 * d.salary);
     }
 });

frappe.ui.form.on("Additional Salary", {
      ot_knight_hour: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
                frappe.model.set_value(cdt, cdn, "ot_knight_amount", (d.ot_knight_hour/208) * 1.75 * d.salary);
     }
 });



frappe.ui.form.on("Additional Salary", {
     salary: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
                frappe.model.set_value(cdt, cdn, "ot_weekend_amount", (d.ot_weekend_hour/208) * 2 * d.salary);
     }
 });

frappe.ui.form.on("Additional Salary", {
     ot_weekend_hour: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
       frappe.model.set_value(cdt, cdn, "ot_weekend_amount", (d.ot_weekend_hour/208) * 2 * d.salary);
     }
 });



frappe.ui.form.on("Additional Salary", {
     salary: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
        frappe.model.set_value(cdt, cdn, "ot_holiday_amount", (d.ot_holiday_hour/208) * 2.5 * d.salary);
     }
 });

frappe.ui.form.on("Additional Salary", {
    ot_holiday_hour: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
       frappe.model.set_value(cdt, cdn, "ot_holiday_amount", (d.ot_holiday_hour/208) * 2.5 * d.salary);
     }
 });


frappe.ui.form.on("Additional Salary", {
      ot_normal_amount: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
        frappe.model.set_value(d.doctype, d.name, 'ot_total_in_birr', (d.ot_normal_amount + d.ot_knight_amount));
     }
 });


frappe.ui.form.on("Additional Salary", {
     ot_knight_amount: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
    frappe.model.set_value(d.doctype, d.name, 'ot_total_in_birr', (d.ot_normal_amount + d.ot_knight_amount));
     }
 });


frappe.ui.form.on("Additional Salary", {
      ot_weekend_amount: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
     frappe.model.set_value(d.doctype, d.name, 'ot_total_2', (d.ot_weekend_amount + d.ot_holiday_amount));
     }
 });


frappe.ui.form.on("Additional Salary", {
     ot_holiday_amount: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
        frappe.model.set_value(d.doctype, d.name, 'ot_total_2', (d.ot_weekend_amount + d.ot_holiday_amount));
     }
 });



frappe.ui.form.on("Additional Salary", {
      ot_total_2: function(frm, cdt, cdn){
        var d = locals[cdt][cdn];
        frappe.model.set_value(d.doctype, d.name, 'overtime_total', (d.ot_total_in_birr + d.ot_total_2));
     }
 });


frappe.ui.form.on("Additional Salary", {
     ot_total_in_birr: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
        frappe.model.set_value(d.doctype, d.name, 'overtime_total', (d.ot_total_in_birr + d.ot_total_2));
     }
 });



frappe.ui.form.on("Additional Salary",{
     perdiem: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
        frappe.model.set_value(cdt, cdn, "perdiem_in_birr", (d.perdiem_no_of_days * d.perdiem));
     }
 });

frappe.ui.form.on("Additional Salary", {
      perdiem_no_of_days: function(frm, cdt, cdn) {
        var d = locals[cdt][cdn];
        frappe.model.set_value(cdt, cdn, "perdiem_in_birr", (d.perdiem_no_of_days * d.perdiem));
     }
 });


