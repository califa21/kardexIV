//modif
function active_onglet( num_onglet) {
	// en entrée numéro de l'onglet à activer
	//boucle sur les onglets
	for (i=1;i<7;i++){
		// rend invisible tous les onglets autre que l'onglet à activer
		//rend visible tous les border bottom des case onglets
		
		document.getElementById('fx'.concat(i)).style.borderBottom='solid'
		document.getElementById('f'.concat(i)).style.visibility='hidden'
	}
	document.getElementById('f'.concat(num_onglet)).style.visibility='visible'
	document.getElementById('fx'.concat(num_onglet)).style.borderBottom='#000000 '
	return
	//fin
};
