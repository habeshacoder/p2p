frappe.ui.form.on("ARRCA Unpaved Road Quantities Form",{
    onload: function(frm, cdt, cdn) {
        var list = [
            "Left Side drain silt",
            "Left Side drain Scour",
            "Left Shoulder Deform",
            "Left Shoulder Scour",
            "Left Shoulder Vegtation",
            "Left Edge step",
            "left Edge damage",
            "Carrigeway Rutting",
            "Carrigeway Corrogation",
            "Carrigeway Cracking wheel track",
            "Carrigeway Creacking other",
            "Carrigeway Stripping",
            "Carrigeway photoles",
            "Carrigeway Bleeding",
            "Carrigeway Failures",
            "Carrigeway Safety",
            "Carrigeway lane Marking",
            "Right Side drain silt",
            "Right Side drain Scour",
            "RIght Shoulder Deform",
            "Right Shoulder Scour",
            "Right Shoulder Vegtation",
            "Right Edge step",
            "Right Edge damage"
        ];

        for (var i = 0; i < list.length; i++) {
            var table_row = frm.add_child("arrca_paved_road_quantities_form_table");
             table_row.carrige_condition=list[i];
        }

         frm.refresh_field("arrca_paved_road_quantities_form_table");
    }
   
   });


// የቋሚ ሰራተኞች ህክምና
// የኮንት ሰራተኞች ህክምና
// የደንብ ልብስ
// የጽህፈት መሳሪያ
// ህትመት
// ነዳጅና ዘይት
// ለሌሎች አላቂ እቃወች
// የጽዳት እቃወች
// ዉሎ አበል
// መጓጓዣ
// የተሽከርካሪ መለወጫ
// የተሽከርካሪ ጥገና
// ለማሽነሪ መለወጫ
// ለማሽነሪ ጥገና
// የጉልበት ኪራይ
// የአገልግሎት ክፍያ
// ለባንክ አገልግሎት
// ለተሽከርካሪ አመታዊ ምርምር
// ለስልክ
// ለዉሃ
// ቋሚ እቃቀች
// ለህንጻ 
// ለምርምር
