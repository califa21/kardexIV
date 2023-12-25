$(function() {
  initPage();
});
$(window).bind('page:change', function() {
  initPage();
});
function initPage() {
 jQuery(function($) {
  return $("#date_pre_toto_2i").change(function() {
    var annee,mois,jour;
	  annee= $("select#date_pre_toto_1i :selected").val();
    mois= $("select#date_pre_toto_2i :selected").val();
    jour= $("select#date_pre_toto_3i :selected").val();
    if (mois === "") {
      state = "0";
    }
     jQuery.get('/kardex/maint_previs/recalcul'+".js?annee="+annee+"&mois=" + mois+"&jour="+jour );
    return false;
  });
});
 jQuery(function($) {
  return $("#date_pre_toto_1i").change(function() {
    var annee,mois,jour;
	  annee= $("select#date_pre_toto_1i :selected").val();
    mois= $("select#date_pre_toto_2i :selected").val();
    jour= $("select#date_pre_toto_3i :selected").val();
    if (mois === "") {
      state = "0";
    }
    jQuery.get('/kardex/maint_previs/recalcul'+".js?annee="+annee+"&mois=" + mois+"&jour="+jour );
    return false;
  });
});
 jQuery(function($) {
  return $("#date_pre_toto_3i").change(function() {
    var annee,mois,jour;
	  annee= $("select#date_pre_toto_1i :selected").val();
    mois= $("select#date_pre_toto_2i :selected").val();
    jour= $("select#date_pre_toto_3i :selected").val();
    if (mois === "") {
      state = "0";
    }
    jQuery.get('/kardex/maint_previs/recalcul'+".js?annee="+annee+"&mois=" + mois+"&jour="+jour );
   
    return false;
  });
});
};
