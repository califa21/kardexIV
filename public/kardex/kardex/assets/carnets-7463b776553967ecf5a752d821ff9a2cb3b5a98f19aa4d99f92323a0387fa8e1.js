//function de calcul des sommes horaires dans les carnets
function somme_sexa(h1,h2){
	//en entrée 2 variable string heure minute avec un séparateur ,:.
	//en sortie variable string sous forme heure:minute
	//on sépare en heure minute + controle cohérence
	var reg=new RegExp("[ ,.:]", "g");
	var tab1=h1.split(reg);
	var tab2=h2.split(reg);
	var h11=parseInt(tab1[0])
	if (tab1.length==2) {
		var h11=parseInt(tab1[0],10)
		var m11=parseInt(tab1[1],10)
	}else {
		var h11=parseInt(tab1[0],10)
		var m11=parseInt("0")
	}
	if (m11>60) {return ("err:err")}
	if (tab2.length==2) {
		var h21=parseInt(tab2[0],10)
		var m22=parseInt(tab2[1],10)
	}else {
		var h21=parseInt(tab2[0],10)
		var m22=parseInt("0")
	}
	if (m22>60) {return ("err:err")}
	//on somme les minutes
	var minute=m11+m22
	//si supérieure à 60 => retenu
	if (minute>59) {
		minute=minute-60
		var retenu=1
	}else{
		var retenu=0
	}
	//somme des heures + retenue
	var heure=retenu+h11+h21
	if (minute<10){
		var somme=heure+":0"+minute
	}else{
		var somme=heure+":"+minute
	}
	//var somme=(heure+":"+(minute<10?"0"+minute:minute));
	//chaine compléte
	return(somme)
}
//somme de tous les élémenst du carnet
function somme_tout(id_select){
	var val_control= document.getElementById('ligne_L_'+id_select).value;
	//on récupère l'id du select qui change
	var reg=new RegExp("[ ,.:]", "g");
	var tab1=val_control.split(reg);
	// on norme sur la Base yyyyy:ZZ 
	if (tab1.length==2) {
		// il y a des minutes
		if (tab1[1].length==2) {
			// il y a deux chiffre après la virgule
			val_control=tab1[0]+":"+tab1[1]
		}else{
			//il n'y a qu'un chiffre donc dizaine de mn
			val_control=tab1[0]+":"+tab1[1]+"0"
		}
	}else{
		//des heures entières
		val_control=tab1[0]+":00"
	}
	document.getElementById('ligne_L_'+id_select).value= val_control
	var somme=document.getElementById('ligne_L_0').value
	for (i=1;i<16;i++){
		relev= document.getElementById('ligne_L_'.concat(i)).value
		somme= somme_sexa(somme,relev)
	}
	//on recopie
	document.getElementById('total_total').value=""+somme
}
function transfert_total(){
	var val_control= document.getElementById('total_total').value
	var reg=new RegExp("[ ,.:]", "g");
	var tab1=val_control.split(reg);
	document.getElementById('carnet_heure_de_vol').value=tab1[0]
}
function raz_page(){
	document.getElementById('ligne_L_0').value= document.getElementById('total_total').value
	for (i=1;i<16;i++){
		document.getElementById('ligne_L_'.concat(i)).value="00:00"
	}
}
;
