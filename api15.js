frappe.ui.form.on("Road maintenance plan Table",{
 plan_1:function(frm,cdt,cdn){
 calculateTotalPlan(frm,cdt,cdn);
},
 plan_2:function(frm,cdt,cdn){
 calculateTotalPlan(frm,cdt,cdn);
},
 plan_3:function(frm,cdt,cdn){
 calculateTotalPlan(frm,cdt,cdn);
},
 plan_4:function(frm,cdt,cdn){
 calculateTotalPlan(frm,cdt,cdn);
},

work_1:function(frm,cdt,cdn){
 calculateTotalWork(frm,cdt,cdn);
},
 work_2:function(frm,cdt,cdn){
 calculateTotalWork(frm,cdt,cdn);
},
 work_3:function(frm,cdt,cdn){
 calculateTotalWork(frm,cdt,cdn);
},
 work_4:function(frm,cdt,cdn){
 calculateTotalWork(frm,cdt,cdn);
}
});
function calculateTotalPlan(frm,cdt,cdn){
 var child=locals[cdt][cdn];
var totalPlan=child.plan_1+child.plan_2+child.plan_3+child.plan_4;
 frappe.model.set_value(cdt,cdn,"toal_plan",totalPlan);
 frm.refresh_field("maintainance_plan_table")

}
function calculateTotalWork(frm,cdt,cdn){
var child=locals[cdt][cdn];
var totalWork=child.work_1+child.work_2+child.work_3+child.work_4;
frappe.model.set_value(cdt,cdn,"toal_work",totalWork);
frm.refresh_field("maintainance_plan_table")
}



