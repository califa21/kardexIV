class VisiteEquipement < ActiveRecord::Base
belongs_to:equipement, :foreign_key =>:idequipement
belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
belongs_to:visite_protocolaire_equipement, :foreign_key =>:id_visite_protocolaire_equipement
validates_presence_of :val_potentiel ,:message => "le relevÃ© de potentiel doit figurer"
validates_presence_of :date_visite ,:message => "la date de la visite doit figurer"
validates_presence_of :idequipement ,:message => "l'Ã©quipement doit figurer"
validates_presence_of :id_visite_protocolaire_equipement ,:message => "le type de la visite doit figurer"

def self.dernieres_visites(id_mach,*date)
	#rÃ©cupÃ¨re poour les équipement d'une machine les états de visites 
	#en entrée la machine et la date ( facultatif si omis date= date du jour
	#on récupére les donnée machine ( carnet ou calcul)
	if (date.empty?) then 
		releve=Carnet.liste_machine_carnet(id_mach) 
		releve["date_releve"]=Date.today
	else 
		releve=MaintPrevi.potentiel_a_date(date[0],id_mach)
	end
	# on selectionne les équipements montés sur une machine donnée
	 montages= EstMonteSur.where("idmachine=? and date_retrait is null",id_mach)
	 i=0 #compteur d'item
	 #ahsh de retour
	 list_def =  Hash.new
	 #on boucle sur les équipements montés
	 montages.each do |montage|
		 #pour chaque montage on prend les visites protocolaires du type d'équipement
		 vis_pro=VisiteProtocolaireEquipement.where(idtype_equipement: montage.equipement.type_equipement.id).load
		 vis_pro.each do |vi_pro|
			 #on boucle sur les type de visites
			 #on recherche la dernière visites en date 
			 #définition du Hash de récupéretion des données 
			list=Hash.new
			#on récupére les données liés à la visite
			list=derniere_visite(vi_pro,id_mach,montage.idequipement,montage,releve)
			list_def[i.to_s]=list
			i=i+1
		 end
		 
	 end
	 return(list_def)
 end 
 #calcul de l'état d'une visite
 def self.derniere_visite(vi_pro,id_mach,id_equipement,montage,releve)
	#récupération de la dernière visiste réalisé pour le type de  visite protcolaire en question
	#visites=find_by_idequipement_and_id_visite_protocolaire_equipement(montage.idequipement,vi_pro.id,:last, :order => "date_visite desc")
	visites=self.where("idequipement=? and id_visite_protocolaire_equipement=?",montage.idequipement,vi_pro.id).order("date_visite asc").last
	#on cree le tableau qui va bien
	list=Hash.new
	#on  constitue un tableau avec l'ID équipement, le nom et les valeurs associées ( HDV,CYCLE,heure moteur)
	list["visite_protocolaire"]=vi_pro
	if visites.nil?
		#si aucun relevé 
		list["idvisite_equipement"]=nil
		list["date_visite"]=Date.new(1900,1,1)
		list["idtype_potentiel"]=0
		list["val_potentiel"]=0
		list["nom"]="pas de visite de ce type faite"
		#calcul du potentiel restant présupposé les potentiels au montages sont pleins (ie toutes les visites sont faites)
		if(vi_pro.type_potentiel.type_potentiel=="Calendaire")
			# on calcule avec les dates
			list["butee"]= montage.equipement.date_montage+vi_pro.valeur_potentiel.month
			list["butee_tol"]=list["butee"]+vi_pro.tolerance.month
			list["val_potentiel"]=montage.equipement.date_montage
		else
			#la c'est simple on somme les potentiels
			#on détermine le potentiel au montage 
			pot_init=PotentielMontage.find_all_by_idtype_potentiel_and_idest_monte_sur(vi_pro.idtype_potentiel,montage.idest_monte_sur)
			list["butee"]=pot_init[0].valeur_machine_jour_montage+vi_pro.valeur_potentiel
			list["butee_tol"]=list["butee"]+vi_pro.tolerance
			list["val_potentiel"]=pot_init[0].valeur_machine_jour_montage
			list["pot"]=pot_init
		end
		#on rajoute la bonne valeur du carnet 
		if vi_pro.type_potentiel.type_potentiel=="Calendaire" then 
			list["val_dernier_releve"]=releve["date_releve"]
		elsif vi_pro.type_potentiel.type_potentiel=="utilisation moteur" then
			list["val_dernier_releve"]=releve["heure_moteur"]
		elsif vi_pro.type_potentiel.type_potentiel=="Heure de vol" then 
			list["val_dernier_releve"]=releve["heure_de_vol"]
		elsif vi_pro.type_potentiel.type_potentiel=="Nb cycles" then
			list["val_dernier_releve"]=releve["nombre_cycle"]
		else
			list["val_dernier_releve"]=0
		end
		
	else
		#on remplit le tableau
		list["idvisite_equipement"]=visites.id
		list["date_visite"]=visites.date_visite
		list["idtype_potentiel"]=visites.idtype_potentiel
		list["nom"]=visites.nom
		#on calcule les potentiels restant
		if(vi_pro.type_potentiel.type_potentiel=="Calendaire")
			# on calcule avec les dates
			list["butee"]= visites.date_visite>>vi_pro.valeur_potentiel.to_i
			list["butee_tol"]=list["butee"]>>vi_pro.tolerance.to_i
			list["val_potentiel"]=visites.date_visite
		else
			#la c'est simple on somme les potentiels
			list["butee"]=visites.val_potentiel+vi_pro.valeur_potentiel
			list["butee_tol"]=list["butee"]+vi_pro.tolerance
			list["val_potentiel"]=visites.val_potentiel
		end
		#on rajoute la bonne valeur du carnet 
		if vi_pro.type_potentiel.type_potentiel=="Calendaire" then 
			list["val_dernier_releve"]=releve["date_releve"]
		elsif vi_pro.type_potentiel.type_potentiel=="utilisation moteur" then
			list["val_dernier_releve"]=releve["heure_moteur"]
		elsif vi_pro.type_potentiel.type_potentiel=="Heure de vol" then 
			list["val_dernier_releve"]=releve["heure_de_vol"]
		elsif vi_pro.type_potentiel.type_potentiel=="Nb cycles" then
			list["val_dernier_releve"]=releve["nombre_cycle"]
		else
			list["val_dernier_releve"]=0
		end
	end
	list["idmachine"]=id_mach
	list["type_equipement"]=montage.equipement.type_equipement.nom_constructeur+" " + montage.equipement.type_equipement.type_equipement+" "+montage.equipement.num_serie
	list["num_serie"]=montage.equipement.num_serie
	list["reste"]=list["butee"]-list["val_dernier_releve"] 
	list["reste_tol"]=list["butee_tol"] - list["val_dernier_releve"]
	list["moteur_helice"]=3
	if (montage.equipement.type_equipement.moteur) then list["moteur_helice"]=1 end
	if (montage.equipement.type_equipement.helice) then list["moteur_helice"]=2 end
	couleur=0
	if (list["reste"]<0 )  then
		couleur =2 
	else
		reste=0.0
		#on traite en fonction du type de potentiel
		#on calcul le % restant 2 cas si calendaire ou si autre 
		if(vi_pro.type_potentiel.type_potentiel=="Calendaire") then 
			#potentiel calendaire différence en jours et potentiel en mois
			reste=list["reste"].to_f 
			reste=reste/(vi_pro.valeur_potentiel.to_f)
			reste=reste/30.5
		else
			#dans les autres cas de protentiel pas de soucis 
			reste = list["reste"].to_f/vi_pro.valeur_potentiel.to_f
		end
		if (reste<0.05) then couleur=1 end
	end
	list["couleur"]=couleur
	list["id_equipement"]=montage.idequipement
	return (list)
end

end
