$(document).ready(function(){
	$("#cen_id_machine").change(function() {
		 state= this.value;
		if (state === "") {
			state = "0";
		}
		jQuery.get('/kardex/cens/get_heure_tot'+".js?id_machine=" + state );
		return false;
		});
	    
    
    
    
    });
