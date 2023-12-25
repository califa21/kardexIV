$(function() {
   initPage_mt_sur();
});
$(window).bind('page:change', function() {
   initPage_mt_sur();
});
function initPage_mt_sur() {
 jQuery(function($) {
  return $("#est_monte_sur_idmachine").change(function() {
    var machine,equi;
    machine= $("select#est_monte_sur_idmachine :selected").val();
    if (machine === "") {
      machine = "0";
    }
    equi= $("select#est_monte_sur_idequipement :selected").val();
    if (equi === "") {
      equi = "0";
    }
     jQuery.get('/kardex/est_monte_surs/val_pot'+".js?mach_id=" + machine + '&equip_id='+equi );

    return false;
  });
});

jQuery(function($) {
  return $("#est_monte_sur_idequipement").change(function() {
    var machine,equi;
    machine= $("select#est_monte_sur_idmachine :selected").val();
    if (machine === "") {
      machine = "0";
    }
    equi= $("select#est_monte_sur_idequipement :selected").val();
    if (equi === "") {
      equi = "0";
    }
     jQuery.get('/kardex/est_monte_surs/val_pot'+".js?mach_id=" + machine + '&equip_id='+equi );

    return false;
  });
});


};
