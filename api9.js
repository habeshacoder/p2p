
frappe.ui.form.on('Maintenance Visit Purpose', {
    //when equip_code of Tyre Control Table changes it fetches data from the database and assign to equp_type of table document rows
    item_code: function (frm, cdt, cdn) {
        var child = locals[cdt][cdn];
        // Fetch information from the linked doctype using a server call
        frappe.call({
            method: "frappe.client.get_value",
            args: {
                doctype: 'Item',
                filters: { item_code: child.item_code },
                fieldname: ['stock_uom']
            },
            callback: function (response) {
                if (response.message) {
                    // Update the "equipment_type" field in the current child table row
                    frappe.model.set_value(cdt, cdn, "uom", response.message.stock_uom);
                    frm.refresh();
                    //  frappe.model.set_value(d.doctype, d.name, 'ot_total_in_birr', (d.ot_normal_amount + d.ot_knight_

                }
            }
        }),
            frappe.call({
                method: "frappe.client.get_value",
                args: {
                    doctype: 'Item',
                    filters: { item_code: child.item_code },
                    fieldname: ['stock_uom']
                },
                callback: function (response) {
                    if (response.message) {
                        // Update the "equipment_type" field in the current child table row
                        frappe.model.set_value(cdt, cdn, "uom", response.message.stock_uom);
                        frm.refresh();
                        //  frappe.model.set_value(d.doctype, d.name, 'ot_total_in_birr', (d.ot_normal_amount + d.ot_knight_

                    }
                }
            });
    },
    qty: function (frm, cdt, cdn) {
        calculateCost(frm, cdt, cdn);

    },
    rate: function (frm, cdt, cdn) {
        calculateCost(frm, cdt, cdn);
    }
});
frappe.ui.form.on('Manpower Cost', {   
    no_of_labor: function (frm, cdt, cdn) {

        calculateCost2(frm, cdt, cdn);

    },
    rate: function (frm, cdt, cdn) {
        calculateCost2(frm, cdt, cdn);
    }
});
function calculateCost(frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    var cost = child.rate * child.qty;
    frappe.model.set_value(cdt, cdn, 'cost', cost);
    frm.refresh();
    calculateTotal(frm);
}
function calculateCost2(frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    var cost = child.rate * child.no_of_labor;
    frappe.model.set_value(cdt, cdn,'cost', cost);
    frm.refresh();
    calculateTotal(frm);

}
function calculateTotal(frm){
  console.log("excute maintainance schedule")
      var total_manpower = 0;
    $.each(frm.doc.manpower_table, function(index, row) {
            total_manpower += row.cost;
        });
     frm.set_value("total_manpower_cost",total_manpower);
     var total_item= 0;
     $.each(frm.doc.purposes, function(index, row) {
            total_item += row.cost;
      });
    frm.set_value("total_item_cost",total_item);
    var manpowerAndItem=total_manpower + total_item;
    frm.set_value("cost_of_labors_and_items",manpowerAndItem);
    frm.refresh();
}
















frappe.ui.form.on("Traffic Count Result", {  
  onload: function(frm, cdt, cdn) {
        for (var i = 1; i <= 80; i++) {
            var table_row = frm.add_child("traffic_count_result_table");            
        }
        frm.doc.traffic_count_result_table[30].date="Total SUm OF Column A";
        frm.doc.traffic_count_result_table[31].date="Avarage(D=A/7)";
        frm.doc.traffic_count_result_table[32].date="N.f(E=(B+C)/C)";
        frm.doc.traffic_count_result_table[33].date="A.D.T(E*D)";
        frm.doc.traffic_count_result_table[34].date="";
        frm.doc.traffic_count_result_table[35].date="Night Time Count";
        frm.doc.traffic_count_result_table[65].date="Total(G)";
        frm.doc.traffic_count_result_table[66].date="Avarage";
        frm.doc.traffic_count_result_table[67].date="";
        frm.doc.traffic_count_result_table[68].date="Two days Count";
        frm.doc.traffic_count_result_table[71].date="Total(F)";
        frm.doc.traffic_count_result_table[72].date="Avarage";
        frm.doc.traffic_count_result_table[73].date="";
        frm.doc.traffic_count_result_table[74].date="Seasonal Count";
        frm.doc.traffic_count_result_table[75].date="Seasonal 1 ADT(H)";
        frm.doc.traffic_count_result_table[76].date="Seasonal 2 ADT(I)";
        frm.doc.traffic_count_result_table[77].date="Seasonal 3 ADt(J)";
        frm.doc.traffic_count_result_table[78].date="Avarage()";
        frm.doc.traffic_count_result_table[79].date="Seasonal Correction Factor";
        frm.doc.traffic_count_result_table[80].date="AADT";
        frm.refresh_field("traffic_count_result_table");
    }
});
frappe.ui.form.on("Traffic Count Result Table", {
car:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
lover:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
 s_bus:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
 },
 l_bus:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
 lover:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
 struck:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
mtruck:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
htruck:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
ttrailor:function(frm,cdt,cdn){
  calculateRowTotal(frm,cdt,cdn);
     
},
});
function calculateRowTotal(frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    var total = child.car + child.lover + child.s_bus + child.l_bus + child.struck + child.mtruck + child.htruck + child.ttrailor;
    frappe.model.set_value(cdt, cdn, "total", total);
    frm.refresh_field("traffic_count_result_table");
//   calculateAvarages(frm,cdt,cdn);
}
function calculateAvarages(frm,cdt,cdn){

    var total_qt = 0;
    
    $.each(frm.doc.traffic_count_result_table, function (index, row) {
        total_cost_ac += row.total;
        total_qt += row.total_qt1;
    });
    frm.set_value("total_cost", total_cost_ac);
    frm.set_value("total_qt",total_qt);
    frm.refresh();


}

