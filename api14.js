cur_frm.add_fetch('driver', 'employee_name','driver_name'); 
cur_frm.add_fetch('mechanic','employee_name', 'mechanic_name'); 

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
frappe.ui.form.on("Maintenance Visit",{
  plate_no:function(frm,cdt,cdn){
  frappe.call({
   method: 'frappe.client.get_list',
   args: {
    doctype: 'Equipment Birth Certificate Form',
    filters: { name:frm.doc.plate_no},
    fields: ['equipment_type',"model","chasis_no","motor_number","case"]
   },
   callback: function(response) {
     var machine=response.message[0];
     if(machine){

     console.log("response message of birth cirtificate is",response.message[0])
     frm.set_value("type_of_trucker",machine.equipment_type);
     frm.set_value("part_number",machine.motor_number);
     frm.set_value("model_number",machine.model);
     frm.set_value("chasis_number",machine.chasis_no);
           } 
 
   }
  });
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
frappe.ui.form.on("Road Carrigeway and Side Drainage form", {
    onload: function(frm, cdt, cdn) {
        var list = [
            "left side shoulder deformation",
            "left side shoulder vegetation",
            "left side shoulder embank erosion",
            "left side side drain siltation",
            "left side side drain scour",
            "Carrigeway Rutting",
            "Carrigeway Corrugation",
            "Carrigeway Camber/cross fall",
            "Carrigeway gravel thickness",
            "Carrigeway erosion gullies",
            "Carrigeway potholes",
            "Carrigeway Loose gravel",
            "Carrigeway Stoniness/coarse texture",
            "right side shoulder deformation",
            "right side shoulder vegetation",
            "right side shoulder embank erosion",
            "right side side drain siltation",
            "right sizde side drain scour"
        ];
    var list2=[
            "Depth",
            "Width",
            "Depth",
            "Depth",
            "Depth",
            "Depth",
            "Depth",
            "Depth",
            "Thickness",
            "Depth",
            "Depth",
            "Thickness",
            "Avg Agg size",
            "Depth",
            "Width",
            "Depth",
            "Depth",
            "Depth",
            "Depth"
             ]
        for (var i = 0; i < list.length; i++) {
            var table_row = frm.add_child("road_carrige_way_and_drainage_table");
             table_row.carriageway_condition=list[i];
             table_row.avarage_severity=list2[i];
        }

        frm.refresh_field("road_carrige_way_and_drainage_table");
    }
});


cur_frm.add_fetch("item_code", "item_name", "item_name");
cur_frm.add_fetch("item_code", "description", "description");
cur_frm.add_fetch("item_code", "stock_uom", "uom");
cur_frm.add_fetch("item_code", "location", "location");
frappe.ui.form.on('Maintenance Schedule', {

	po_no: function(frm) {
		if (frm.doc.po_no) {
			frm.clear_table('items_from_purchase_order');
			console.log("Test 1");
			frappe.model.with_doc('Purchase Order', frm.doc.po_no, function() {
				console.log("Test 2", frm.doc.po_no)
				let source_doc = frappe.model.get_doc('Purchase Order', frm.doc.po_no);
				console.log("source doc", source_doc)

				$.each(source_doc.items, function(index, source_row) {

					console.log("Test 3");
					const target_row = frm.add_child('items_from_purchase_order');
					target_row.item_code = source_row.item_code;
					target_row.stock_quantity = source_row.stock_quantity;
					target_row.item_name = source_row.item_name;
					target_row.uom = source_row.uom;
					target_row.amount = source_row.amount;
					target_row.qty = source_row.qty;
					target_row.rate = source_row.rate;
					target_row.description = source_row.description;

				});

				frm.refresh_field('items_from_purchase_order');
			});
		}
	},
});
frappe.ui.form.on('Maintenance Schedule Item', {
  //when equip_code of Tyre Control Table changes it fetches data from the database and assign to equp_type of table document rows
    item_code: function(frm, cdt, cdn) {
        var child = locals[cdt][cdn];
        // Fetch information from the linked doctype using a server call
        frappe.call({
            method: "frappe.client.get_value",
             args: {
                doctype: 'Stock Ledger Entry',
                filters: { item_code: child.item_code},
                fieldname: ['qty_after_transaction']
            },
            callback: function(response) {
                if (response.message) {
                // Update the "equipment_type" field in the current child table row
                   frappe.model.set_value(cdt, cdn, "stock_quantity", response.message.qty_after_transaction);
                   frappe.model.set_df_property(cdt, cdn,'stock_quantity', 'read_only', 1); // Make stock_quantity readonly
                    frm.refresh();
					//  frappe.model.set_value(d.doctype, d.name, 'ot_total_in_birr', (d.ot_normal_amount + d.ot_knight_

                }
            }
        });
    }});
frappe.ui.form.on('Purchase Order Item', {
  //when equip_code of Tyre Control Table changes it fetches data from the database and assign to equp_type of table document rows
    item_code: function(frm, cdt, cdn) {
        var child = locals[cdt][cdn];
        // Fetch information from the linked doctype using a server call
        frappe.call({
            method: "frappe.client.get_value",
             args: {
                doctype: 'Stock Ledger Entry',
                filters: { item_code: child.item_code},
                fieldname: ['qty_after_transaction']
            },
            callback: function(response) {
                if (response.message) {
                // Update the "equipment_type" field in the current child table row
                   frappe.model.set_value(cdt, cdn, "stock_quantity", response.message.qty_after_transaction);
                frappe.model.set_df_property(cdt, cdn,'stock_quantity', 'read_only', 1); // Make stock_quantity readonly
                frm.refresh();
					//  frappe.model.set_value(d.doctype, d.name, 'ot_total_in_birr', (d.ot_normal_amount + d.ot_knight_

                }
            }
        });
    }});