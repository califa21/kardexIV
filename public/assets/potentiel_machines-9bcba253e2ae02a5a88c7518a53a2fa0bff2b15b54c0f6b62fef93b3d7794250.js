$(function() {
  initPage_pot_mach();
});
$(window).bind('page:change', function() {
   initPage_pot_mach();
});
function  initPage_pot_mach() {
 jQuery(function($) {
  return $("#potentiel_machine_idtype_potentiel").change(function() {
    var state, test, texte;
    state= $("select#potentiel_machine_idtype_potentiel :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get('/kardex/type_potentiels/get_unitee'+".js?pot_id=" + state );
    return false;
  });
});

};
