$(function() {
  initPageecnmach();
});
$(window).bind('page:change', function() {
  initPageecnmach();
});
function initPageecnmach() {
 jQuery(function($) {
  return $("#exec_cn_machine_idcn_machine").change(function() {
    var state, test, texte;
    state= $("select#exec_cn_machine_idcn_machine :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get('/kardex/type_potentiels/get_unitee'+".js?cn_mach_id=" + state  );

    return false;
  });
});

 jQuery(function($) {
  return $("#exec_cn_machine_id_machine").change(function() {
    var state
    state= $("select#exec_cn_machine_id_machine :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get('/kardex/exec_cn_machines/cn_typemachine'+".js?machine_id=" + state );

    return false;
  });
});


};
