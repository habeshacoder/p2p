frappe.ui.form.on("Utilization Register Table", {
  first_half_operator: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    if (child.first_half_operator) {
      frappe.call({
        method: "frappe.client.get_value",
        args: {
          doctype: "Employee",
          filters: {
            name: child.first_half_operator,
          },
          fieldname: "employee_name",
        },
        callback: function (response) {
          if (response.message && response.message.employee_name) {
            console.log(
              "Fetched Employee Name:",
              response.message.employee_name
            );
            frappe.model.set_value(
              cdt,
              cdn,
              "first_half_name",
              response.message.employee_name
            );
          } else {
            console.log(
              "No Employee Name found for:",
              child.first_half_operator
            );
          }
        },
      });
    }
  },
  second_half_operator: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    if (child.second_half_operator) {
      frappe.call({
        method: "frappe.client.get_value",
        args: {
          doctype: "Employee",
          filters: {
            name: child.second_half_operator,
          },
          fieldname: "employee_name",
        },
        callback: function (response) {
          if (response.message && response.message.employee_name) {
            console.log(
              "Fetched Employee Name:",
              response.message.employee_name
            );
            frappe.model.set_value(
              cdt,
              cdn,
              "second_half_name",
              response.message.employee_name
            );
          } else {
            console.log(
              "No Employee Name found for:",
              child.second_half_operator
            );
          }
        },
      });
    }
  },
});
cur_frm.add_fetch("equipment_type", "equipment_type", "equipment_type");
cur_frm.add_fetch("checked_by", "employee_name", "checker_name");
cur_frm.add_fetch("approved_by", "employee_name", "approver_name");
frappe.ui.form.on("Equipment Daily Time Utilization Register", {
  onload: function (frm) {
    // Check if the linked employee field is set
    if (frm.doc.checked_by) {
      frappe.db.get_value(
        "Employee",
        frm.doc.checked_by,
        "employee_name",
        function (data) {
          // Set the employee name as the value of the checked_by field
          frm.set_value("checked_by", data.employee_name);
        }
      );
    }
  },
});

frappe.ui.form.on("Equipment Daily Time Utilization Register", {
  refresh: function (frm) {
    frm.fields_dict["utilization_register_table"].grid.on_row_add = function (
      doc,
      cdt,
      cdn
    ) {
      var child = locals[cdt][cdn];
      setWorkedHours(child);
    };
    frm.fields_dict["utilization_register_table"].grid.on_row_add = function (
      doc,
      cdt,
      cdn
    ) {
      var child = locals[cdt][cdn];
      setDifferenceOfKm(child);
    };
    frm.fields_dict["utilization_register_table"].grid.on_row_refresh =
      function (doc, cdt, cdn) {
        var child = locals[cdt][cdn];
        setWorkedHours(child);
      };
    frm.fields_dict["utilization_register_table"].grid.on_row_refresh =
      function (doc, cdt, cdn) {
        var child = locals[cdt][cdn];
        setDifferenceOfKm(child);
      };
  },
  onload: function (frm) {
    frappe.call({
      method: "frappe.client.get_value",
      args: {
        doctype: "User",
        filters: { name: frappe.session.user },
        fieldname: ["full_name"],
      },
      callback: function (response) {
        var user = response.message;
        if (user) {
          frm.set_value("prepared_by", user.full_name);
        }
      },
    });
  },
});

frappe.ui.form.on("Utilization Register Table", {
  plate_no: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    // Fetch information from the linked doctype using a server call
    frappe.call({
      method: "frappe.client.get_value",
      args: {
        doctype: "Equipment Birth Certificate Form",
        filters: { plate_no: child.plate_no },
        fieldname: ["equipment_type"],
      },
      callback: function (response) {
        if (response.message) {
          // Update the "equipment_type" field in the current child table row
          frappe.model.set_value(
            cdt,
            cdn,
            "equipment_type",
            response.message.equipment_type
          );
        }
      },
    });
  },
  first_half_start: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    var is_valid;
    is_valid = isValid(child.first_half_start);
    console.log(`is valid is ${is_valid}`);
    if (is_valid == true) {
      setWorkedHours(child);
    } else {
      frappe.throw(
        `Invalid  12 hour format on "first half start" : ${child.first_half_start}`
      );
    }
  },
  first_half_end: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    var is_valid;
    is_valid = isValid(child.first_half_end);
    console.log(`is valid is ${is_valid}`);
    if (is_valid == true) {
      setWorkedHours(child);
    } else {
      frappe.throw(
        `Invalid  12 hour format  on "first half end" : ${child.first_half_end}`
      );
    }
  },
  second_half_start: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    var is_valid;
    is_valid = isValid(child.second_half_start);
    console.log(`is valid is ${is_valid}`);
    if (is_valid == true) {
      setWorkedHours(child);
    } else {
      frappe.throw(
        `Invalid  12 hour format on "second half start": ${child.second_half_start}`
      );
    }
  },
  second_half_end: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    var is_valid;
    is_valid = isValid(child.second_half_end);
    console.log(`is valid is ${is_valid}`);
    if (is_valid == true) {
      setWorkedHours(child);
    } else {
    
      frappe.throw(
        `Invalid  12 hour format on "second half end" : ${child.second_half_end}`
      );

    }
  },
  initial: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];

    setDifferenceOfKm(child);
  },
  final: function (frm, cdt, cdn) {
    var child = locals[cdt][cdn];
    setDifferenceOfKm(child);
  },
});

function setWorkedHours(child) {
  var first_half_start_hour = returnHour(
    child.first_half_start,
    child.time1,
    1
  );
  var first_half_end_hour = returnHour(child.first_half_end, child.time2, 1);
  var second_half_start_hour = returnHour(
    child.second_half_start,
    child.time3,
    2
  );
  var second_half_end_hour = returnHour(child.second_half_end, child.time4, 2);
  console.log(
    `the data respectively is as follows ${first_half_start_hour}  ${first_half_end_hour}`
  );
  var first_half;
  var second_half;
  if (first_half_end_hour > first_half_start_hour) {
    first_half = first_half_end_hour - first_half_start_hour;
  } else if (first_half_end_hour < first_half_start_hour) {
    first_half = 12 - first_half_start_hour + first_half_end_hour;
  } else if (first_half_start_hour > 0 && first_half_end_hour > 0) {
    first_half = 12 - first_half_start_hour + (12 - first_half_end_hour);
  } else {
    first_half = 0;
  }

  if (second_half_end_hour > second_half_start_hour) {
    second_half = second_half_end_hour - second_half_start_hour;
  } else if (second_half_end_hour < second_half_start_hour) {
    second_half = 12 - first_half_start_hour + second_half_end_hour;
  } else if (second_half_end_hour > 0 && second_half_start_hour > 0) {
    second_half = 12 - second_half_start_hour + (12 - second_half_end_hour);
  } else {
    second_half = 0;
  }

  var worked_hours = first_half + second_half;
  frappe.model.set_value(child.doctype, child.name, "worked_hrs", worked_hours);
}
function isValid(hour) {
  console.log(`passed hour is ${hour}`);
  var value = "";
  var is_valid = false;
  if (typeof hour === "string") {
    value = hour;
  } else {
    value = hour.toString();
  }
  if (value.includes(".")) {
    var parts = value.split(".");
    if (parts[0].length > 2) {
      is_valid = false;
      console.log("excute 1");
    } else if (0 > parseInt(parts[0]) || parseInt(parts[0]) > 12) {
      is_valid = false;
      console.log(`excute 2`);
    } else {
      var decimalPart = parts[1];
      if (decimalPart.length > 2) {
        var check_minute = parseInt(decimalPart.slice(0, 2));
        if (0 > check_minute || check_minute > 60) {
          is_valid = false;
        }
      } else {
        if (0 > parseInt(decimalPart) || parseInt(decimalPart) > 60) {
          is_valid = false;
        } else {
          is_valid = true;
        }
      }
    }
    // Convert all digits after the decimal point to minutes var decimalPart = parts[1];
  } else if (value.length > 2) {
    is_valid = false;
  } else if (0 > parseInt(value) || parseInt(value) > 12) {
    is_valid = false;
  } else {
    is_valid = true;
  }
  return is_valid;
}

function returnHour(data, time, shift) {
  console.log(`date:${data} time:${time} shift:${shift}`);
  var value;
  if (typeof data === "string") {
    value = data;
  } else {
    value = data.toString();
  }

  var hours = 0;
  var totalHour = 0;

  if (value.includes(".")) {
    var parts = value.split(".");
    if (parts[0].length > 2) {
      hours = parseFloat(parts[0].slice(0, 2));
      console.log(`parsed hours is ${hours} unparsed hours ${parts[0]}`);
    } else {
      hours = parseFloat(parts[0]);
    }

    // Convert all digits after the decimal point to minutes
    var decimalPart = parts[1];

    if (decimalPart.length === 1) {
      decimalPart = parts[1].slice(0, 1) + "0";
    } else {
      decimalPart = parts[1].slice(0, 2);
    }

    console.log(`decimal part ${decimalPart}`);
    var minutes_to_hrs = parseFloat(decimalPart) / 60; // Corrected calculation
    console.log(`minutes to hours is ${minutes_to_hrs}`);
    totalHour = hours + minutes_to_hrs;
    console.log(
      `parts 1 ${hours} part2 ${parts[1]} decimal part ${decimalPart}`
    );
  } else {
    totalHour = parseFloat(value);
  }

  return totalHour;
}

function setDifferenceOfKm(child) {
  var difference = child.final - child.initial;
  frappe.model.set_value(child.doctype, child.name, "diff", difference);
}
