
frappe.ui.form.on('Loading Advice', {
    coupon_number: function (frm, cdt, cdn) {
        frappe.call({
            method: "frappe.client.get_list",
            args: {
                doctype: 'Coupon Detail',
                filters: { "coupon_no": frm.doc.coupon_number },
                fields: ['*']
            },
            callback: function (response) {
                if (response.message && response.message.length > 0) {
                    console.log("the response qty is", response.message);
                    // qty = response.message[0].total_qty;
                    // unit_price=response.message[0].rate;
                    // frm.set_value("customer",response.message[0].customer);
                    // frm.set_value("order_date",response.message[0].transaction_date);
                    //  frm.set_value("customer","read_only",1);
                    // frm.set_value("order_date","read_only",1);
                    // refresh_field("customer");
                    // refresh_field("order_date");
                    // frappe.call({
                    //     method: "frappe.client.get_value",
                    //     args: {
                    //         doctype: 'Item',
                    //         filters: { "name": response.message[0].item_code },
                    //         fieldname: ['description', 'stock_uom', 'item_code']
                    //     },
                    //     callback: function (response) {
                    //         if (response.message && frm.doc.number_of_coupons) {
                    //             frm.clear_table("coupon_detail");

                    //             var number_of_columns = parseInt(frm.doc.number_of_coupons);
                    //             for (var i = 0; i < number_of_columns; i++) {
                    //                 var child = frm.add_child("coupon_detail");
                    //                 child.item = response.message.item_code;
                    //                 child.description = response.message.description;
                    //                 child.uom = response.message.stock_uom;
                    //                 child.unit_price=unit_price;
                    //                 child.amount=parseFloat(child.unit_price*(qty / frm.doc.number_of_coupons));
                    //                 child.coupon_no=`SSH-COP-${i.toString().padStart(3, '0')}`;
                    //                 child.quantity = qty / frm.doc.number_of_coupons;
                    //                 child.bar_code = `SSH-COP-${i.toString().padStart(3, '0')}`;
                    //             }
                    //             frm.refresh_field('coupon_detail'); // Refresh the child table field
                    //         }
                    //     }
                    // });
                }
            }
        });
    }
});
