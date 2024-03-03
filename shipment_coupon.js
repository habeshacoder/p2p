
frappe.ui.form.on('Shipment Coupon', {
    sales_order_no: function (frm, cdt, cdn) {
      if(!frm.doc.number_of_coupons){
                      frappe.throw({
								title: __("Mandatory"),
								message: __("Please insert number of coupons")
							});
         }else{frappe.call({
            method: "frappe.client.get_list",
            args: {
                parent: frm.doc.sales_order_no,
                doctype: 'Sales Order Item',
                filters: { "parent": frm.doc.sales_order_no },
                fields: ['*']
            },
            callback: function (response) {
                 
                if (response.message && response.message.length > 0) {
                     console.log("here excuted");
                    var res = response.message[0];
                    console.log("the respons is",res)
                    frm.clear_table("coupon_detail");
                    var number_of_columns = parseInt(frm.doc.number_of_coupons);
                    for (var i = 0; i < number_of_columns; i++) {
                        var child = frm.add_child("coupon_detail");
                        child.item = res.item_code;
                        child.description = res.description;
                        child.uom = res.stock_uom;
                        child.unit_price = res.rate;
                        child.quantity = res.qty / frm.doc.number_of_coupons;
                        child.amount = parseFloat(child.rate * (res.qty / frm.doc.number_of_coupons));
                        child.coupon_no = `SSH-COP-${i.toString().padStart(3, '0')}`;
                        child.bar_code = `SSH-COP-${i.toString().padStart(3, '0')}`;
                        child.name1 = res.name;
                    }
                    frm.refresh_field('coupon_detail');

                    frappe.call({
                        method: "frappe.client.get_value",
                        args: {
                            doctype: 'Sales Order',
                            filters: { "name": response.message[0].parent },
                            fieldname: ['*']
                        },
                        callback: function (response) {
                            if (response.message) {
                                console.log("the response from sales Order is", response.message);
                                frm.set_value("customer", response.message.customer);
                                frm.set_value("order_date", response.message.transaction_date);
                                frm.set_value("customer", "read_only", 1);
                                frm.set_value("order_date", "read_only", 1);
                                refresh_field("customer");
                                refresh_field("order_date");

                            }
                        }
                    });
                } else {
                    

                }
            }
        })}
        
    },
  number_of_coupons:function(frm,cdt,cdn){
    if(!frm.doc.sales_order_no){
       frappe.throw({
								title: __("Mandatory"),
								message: __("Please Select Saes Order")
		});
  

}

}


});
