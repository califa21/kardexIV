$(function() {
  initPagelanc();
});
$(window).bind('page:change', function() {
  initPagelanc();
});
function initPagelanc() {
 jQuery(function($) {
  return $("#bon_lancement_id_machine").change(function() {
    var state, machine;
    machine= $("select#bon_lancement_id_machine :selected").val();
    state =$("#id_bl").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get('/kardex/bon_lancements/get_type_visite'+".js?id_bl=" + state+"&id_machine="+machine );
    return false;
  });
});



};
 
