$(function() {
  initPageVE();
});
$(window).bind('page:change', function() {
  initPageVE();
});
function initPageVE() {
 jQuery(function($) {
  return $("#visite_equipement_id_visite_protocolaire_equipement").change(function() {
    var state, equipement;
    state= $("select#visite_equipement_id_visite_protocolaire_equipement :selected").val();
    equipement =$("select#visite_equipement_idequipement :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get('/kardex/visite_equipements/get_type_visite'+".js?id_visite_protocolaire=" + state+"&id_equipement="+equipement );
  });
});

 jQuery(function($) {
  return $("#visite_equipement_idequipement").change(function() {
    var state,vis_prot
    state= $("select#visite_equipement_idequipement :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get('/kardex/visite_equipements/get_visite_equ'+".js?id_equipement=" + state );
  });
});
};
