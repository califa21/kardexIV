function initPage(){jQuery(function(r){return r("#date_pre_toto_2i").change(function(){var e,t,a;return e=r("select#date_pre_toto_1i :selected").val(),t=r("select#date_pre_toto_2i :selected").val(),a=r("select#date_pre_toto_3i :selected").val(),""===t&&(state="0"),jQuery.get("/kardex/maint_previs/recalcul.js?annee="+e+"&mois="+t+"&jour="+a),!1})}),jQuery(function(r){return r("#date_pre_toto_1i").change(function(){var e,t,a;return e=r("select#date_pre_toto_1i :selected").val(),t=r("select#date_pre_toto_2i :selected").val(),a=r("select#date_pre_toto_3i :selected").val(),""===t&&(state="0"),jQuery.get("/kardex/maint_previs/recalcul.js?annee="+e+"&mois="+t+"&jour="+a),!1})}),jQuery(function(r){return r("#date_pre_toto_3i").change(function(){var e,t,a;return e=r("select#date_pre_toto_1i :selected").val(),t=r("select#date_pre_toto_2i :selected").val(),a=r("select#date_pre_toto_3i :selected").val(),""===t&&(state="0"),jQuery.get("/kardex/maint_previs/recalcul.js?annee="+e+"&mois="+t+"&jour="+a),!1})})}$(function(){initPage()}),$(window).bind("page:change",function(){initPage()});