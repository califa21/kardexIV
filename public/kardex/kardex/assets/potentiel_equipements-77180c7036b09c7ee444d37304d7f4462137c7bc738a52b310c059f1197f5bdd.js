$(function() {
  initPagePot_e();
});
$(window).bind('page:change', function() {
  initPagePot_e();
});
function initPagePot_e() {
 jQuery(function($) {
  return $("#potentiel_equipement_idtype_potentiel").change(function() {
    var state, test, texte;
    state= $("select#potentiel_equipement_idtype_potentiel :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get('/kardex/type_potentiels/get_unitee'+".js?pot_id=" + state );
    return false;
  });
});

}



;
