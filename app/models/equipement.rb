class Equipement < ActiveRecord::Base
validates_presence_of :idtypeequipement,:message => "le type equipement ne peut etre vide"
belongs_to :type_equipement, :foreign_key =>:idtypeequipement
has_many :est_monte_sur, :foreign_key =>:idequipement

def self.tab_visite(id)
#récupère équipement
  u=find(id)
  #list des visites protocolaires applicable
   vis_pro=VisiteProtocolaireEquipement.find_all_by_idtype_equipement(u.idtypeequipement)
  return nil if vis_pro.nil?
  j=0
  list=[]
  vis_pro.each do |vis_pro|
	list[j]=[vis_pro.Nom,vis_pro.id_visite_protocolaire_equipement]
	j=j+1
end
  return list
end  
def self.liste_pot_hs(date)
	#liste les éléments hs à une date déterminé
	list=Hash.new
	#on liste les équipements montés sur une machine qui ont un potentiel  ( montage join equipement join type_equipement join potentiel
	montages=EstMonteSur.joins(:machine).where("date_retrait is null and machines.vendu is false")
	j=0
	i=0
	montages.each do |montage|
		potrest=Hash.new
		#on teste si pot à la date est hs
		releve=MaintPrevi.potentiel_a_date(date,montage.idmachine)
		#on calcul les éléments de relevÃ©
		montage.equipement.type_equipement.potentiel_equipement.each do |pot|
			pot_rest=Hash.new
			#on calcul la valeur restante du potentiel
			#potentiel potentiel restant au montage - (potentiel du jour -le potentiel le jour du montage ) 
			#calcul du potentiel restant au montage
			pot_init=PotentielMontage.where("idpotentiel_equipement=? and idest_monte_sur=?",pot.id,montage.id)
			potinit_val=pot_init[0].valeur_potentiel_montage
			pot_rest["type_pot"]= pot.type_potentiel.type_potentiel
			if pot.type_potentiel.type_potentiel=="Calendaire" then 
				#la valeur du potentiel au montage = date de montage par contre il faut calculer en mois 
				pot_rest["reste"]=((montage.date_montage>>potinit_val.to_i)-(releve["date_releve"]))
				pot_rest["butee"]=(montage.date_montage>>potinit_val.to_i).strftime('%d/%m/%Y')
				pot_rest["estime"]=releve["date_releve"].strftime('%d/%m/%Y')
			elsif pot.type_potentiel.type_potentiel=="utilisation moteur" then
				pot_rest["reste"]=potinit_val-(releve["heure_moteur"]-pot_init[0].valeur_machine_jour_montage)
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pot_rest["estime"]=releve["heure_moteur"].to_i
			elsif pot.type_potentiel.type_potentiel=="Heure de vol" then 
				pot_rest["reste"]=potinit_val-(releve["heure_de_vol"]-pot_init[0].valeur_machine_jour_montage)
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pot_rest["estime"]=releve["heure_de_vol"].to_i
			elsif pot.type_potentiel.type_potentiel=="Nb cycles" then
				pot_rest["reste"]=potinit_val-(releve["nombre_cycle"]-pot_init[0].valeur_machine_jour_montage)
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pot_rest["estime"]=releve["nombre_cycle"]
			else
				pot_rest="pb"
			end
			#probléme a régler sur l'idetification unique ie pour chaque type de potentiel 
			pot_rest["nom_machine"]=montage.machine.Immatriculation
			pot_rest["type"]=montage.machine.type_machine.type_machine 
			pot_rest["num_serie"]=montage.equipement.num_serie
			pot_rest["type_equip"]=montage.equipement.type_equipement.nom_constructeur.to_s+" "+montage.equipement.type_equipement.type_equipement.to_s
			pot_rest["type_machine"]=montage.machine.type_machine.type_machine
			if(pot_rest["reste"]<0)  then 
				potrest=pot_rest 
				i=i+1
			end
			
		end
		if (!potrest.empty?) then
			list[j.to_s]=potrest #equip
			j=j+1
		end
	end
	#si oui on rajoute au tableau
	return(list)
end
##############################################################################
#calcul a une date déterminé les équipement à réviser 
#sur les potentiels calendaires basés sur la date 
#sur les autres sur une approximation 
def self.visite_equipement(date)
	list_def=Hash.new
	#on récupère les équipements
	#on liste les équipements montés sur une machine qui ont un potentiel  ( montage join equipement join type_equipement join visite_protocolaire
	montages=EstMonteSur.joins(:machine).where("date_retrait is null and machines.vendu is false")
	i=0
	j=0
	 #pour chaque équipement monté
	 montages.each do |montage|
		 #on détermine les vistes protocolaire à faire
		vis_pro=VisiteProtocolaireEquipement.where("idtype_equipement= ?",montage.equipement.type_equipement.id)
		list2=Hash.new
		vis_pro.each do |vi_pro|
			releve=MaintPrevi.potentiel_a_date(date,montage.idmachine)
			machine=Machine.find(montage.idmachine)
			#récupération de la dernière visiste réalisé pour le type de  visite protcolaire en question
			visites=VisiteEquipement.where("idequipement=? and id_visite_protocolaire_equipement=?",montage.idequipement,vi_pro.id).order("date_visite asc").last
			#find_by_idequipement_and_id_visite_protocolaire_equipement(montage.idequipement,vi_pro.id,:last, :order => "date_visite desc")
			list=Hash.new
			#on cree le tableau qui va bien
			#on  constitue un tableau avec l'ID équipement, le nom et les valeurs associées ( HDV,CYCLE,heure moteur)
			list["visite_protocolaire"]=vi_pro.Nom
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
					list["butee"]= montage.equipement.date_montage>>vi_pro.valeur_potentiel.to_i
					list["butee_tol"]=list["butee"]>>vi_pro.tolerance.to_i
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
			list["type_machine"]= machine.type_machine.type_machine
			list["nom_machine"]=machine.Immatriculation
			list["type_equipement"]=montage.equipement.type_equipement.nom_constructeur+" " + montage.equipement.type_equipement.type_equipement
			list["num_serie"]=montage.equipement.num_serie
			list["reste"]=list["butee"]-list["val_dernier_releve"] 
			list["reste_tol"]=list["butee_tol"] - list["val_dernier_releve"]
			list["pot"]=vi_pro.type_potentiel.type_potentiel
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
			if (list["reste"]<0) then 
				list_def[j]=list
				j=j+1
			end
		end
		#if !list2.empty? 
		#	list_def[i.to_s]=list2
		#	i=i+1
		#end
		#return liste2
	end
	return list_def
end
########################################################################################################
#réécriture propre du potentiel restant sur une machine  
def self.potentiel_restant_machine(id_machine,*date)
	list=Hash.new
	#on récupère la machine
	@machine = Machine.find(id_machine)
	#récupération des relevés
	if (date.empty?) then 
		releve=Carnet.liste_machine_carnet(id_machine) 
		releve["date_releve"]=Date.today
	else 
		releve=MaintPrevi.potentiel_a_date(date[0],id_machine)
	end
	#on récupère les équipements
	montages=EstMonteSur.where("idmachine=? and date_retrait is null",id_machine)
	j=0
	potrest=Hash.new
	montages.each do |montage|
		montage.equipement.type_equipement.potentiel_equipement.each do |pot|
			pot_rest=Hash.new
			#on calcul la valeur restante du potentiel
			#potentiel potentiel restant au montage - (potentiel du jour -le potentiel le jour du montage ) 
			#calcul du potentiel restant au montage
			pot_init=PotentielMontage.where("idpotentiel_equipement=? and idest_monte_sur=?",pot.id,montage.id)
			potinit_val=pot_init[0].valeur_potentiel_montage
			if pot.type_potentiel.type_potentiel=="Calendaire" then 
				#la valeur du potentiel au montage = date de montage par contre il faut calculer en mois 
				pot_rest["reste"]=sprintf('%02.0f Jours',(montage.date_montage>>potinit_val.to_i)-(releve["date_releve"]))
				pot_rest["butee"]=(montage.date_montage>>potinit_val.to_i).strftime('%d/%m/%Y')
				pourcent_reste= pot_rest["reste"].to_f / (potinit_val*30.5)
			elsif pot.type_potentiel.type_potentiel=="utilisation moteur" then
				pot_rest["reste"]=sprintf('%02.2f ',potinit_val-(releve["heure_moteur"]-pot_init[0].valeur_machine_jour_montage))
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pourcent_reste=(potinit_val-(releve["heure_moteur"]-pot_init[0].valeur_machine_jour_montage) )/ potinit_val
			elsif pot.type_potentiel.type_potentiel=="Heure de vol" then 
				val=potinit_val-(releve["heure_de_vol"]-pot_init[0].valeur_machine_jour_montage)
				pourcent_reste= val.to_f / (potinit_val)
				potin=(val/60).to_i
				toto=potin.to_s+":"+sprintf('%02.0f Hdv',val-60*potin)
				pot_rest["reste"]=toto #potinit_val-(releve["heure_de_vol"]-pot_init[0].valeur_machine_jour_montage)
				val =pot_init[0].valeur_machine_jour_montage+potinit_val
				potin=(val/60).to_i
				toto=potin.to_s+":"+sprintf('%02.0f',val-60*potin)
				pot_rest["butee"]=toto #pot_init[0].valeur_machine_jour_montage+potinit_val
			elsif pot.type_potentiel.type_potentiel=="Nb cycles" then
				pot_rest["reste"]=potinit_val-(releve["nombre_cycle"]-pot_init[0].valeur_machine_jour_montage)
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pourcent_reste= pot_rest["reste"].to_f / (potinit_val)
			else
				pot_rest="pb"
			end
			#probléme a régler sur l'idetification unique ie pour chaque type de potentiel 
			pot_rest["equipement"]=montage.equipement
			pot_rest["type_pot"]=pot.type_potentiel.type_potentiel
			pot_rest["val_pot"]=potinit_val
			pot_rest["id"]=pot
			pot_rest["unitee"]=pot.type_potentiel.unitee

			pot_rest["moteur_helice"]=3
			if (montage.equipement.type_equipement.moteur) then pot_rest["moteur_helice"]=1 end
			if (montage.equipement.type_equipement.helice) then pot_rest["moteur_helice"]=2 end
			if (pourcent_reste<0) then pot_rest["couleur"]=2 elsif  (pourcent_reste<0.05) then pot_rest["couleur"]=1  else pot_rest["couleur"]=0  end 
			potrest[j]=pot_rest
			j=j+1
		end
	end
return potrest
end
def self.potentiel_restant(idequipement,*date)
	list=Hash.new
	#on récupère le montage
	montages=EstMonteSur.where("idequipement=? and date_retrait is null",idequipement)
	#on récupère la machine
	@machine = Machine.find(montages[0].idmachine)
	#récupération des relevés
	if (date.empty?) then 
		releve=Carnet.liste_machine_carnet(montages[0].idmachine) 
		releve["date_releve"]=Date.today
	else 
		releve=MaintPrevi.potentiel_a_date(date[0],montages[0].idmachine)
	end
	
	j=0
	potrest=Hash.new
	montages.each do |montage|
	montage.equipement.type_equipement.potentiel_equipement.each do |pot|
			pot_rest=Hash.new
			#on calcul la valeur restante du potentiel
			#potentiel potentiel restant au montage - (potentiel du jour -le potentiel le jour du montage ) 
			#calcul du potentiel restant au montage
			pot_init=PotentielMontage.where("idpotentiel_equipement=? and idest_monte_sur=?",pot.id,montage.id)
			potinit_val=pot_init[0].valeur_potentiel_montage
			if pot.type_potentiel.type_potentiel=="Calendaire" then 
				#la valeur du potentiel au montage = date de montage par contre il faut calculer en mois 
				pot_rest["reste"]=((montage.date_montage >> potinit_val.to_i)-(releve["date_releve"])).to_i
				pot_rest["butee"]=(montage.date_montage >> potinit_val.to_i).strftime('%d/%m/%Y')
				pot_rest["valeur_courante"]=releve["date_releve"].strftime('%d/%m/%Y')
			elsif pot.type_potentiel.type_potentiel=="utilisation moteur" then
				pot_rest["reste"]=potinit_val-(releve["heure_moteur"]-pot_init[0].valeur_machine_jour_montage)
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pot_rest["valeur_courante"]=releve["heure_moteur"]
			elsif pot.type_potentiel.type_potentiel=="Heure de vol" then 
				pot_rest["reste"]=potinit_val-(releve["heure_de_vol"]-pot_init[0].valeur_machine_jour_montage)
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pot_rest["valeur_courante"]=releve["heure_de_vol"]
			elsif pot.type_potentiel.type_potentiel=="Nb cycles" then
				pot_rest["reste"]=potinit_val-(releve["nombre_cycle"]-pot_init[0].valeur_machine_jour_montage)
				pot_rest["butee"]=pot_init[0].valeur_machine_jour_montage+potinit_val
				pot_rest["valeur_courante"]=releve["nombre_cycle"]
			else
				pot_rest="pb"
			end
			#probléme a régler sur l'idetification unique ie pour chaque type de potentiel 
			pot_rest["equipement"]=montage.equipement
			pot_rest["type_pot"]=pot.type_potentiel.type_potentiel
			pot_rest["val_pot"]=potinit_val
			pot_rest["id"]=pot
			pot_rest["unitee"]=pot.type_potentiel.unitee
			if pot.type_potentiel.type_potentiel=="Calendaire" then 
				pourcent_reste= pot_rest["reste"].to_f / (potinit_val*30.5)
				
			else
				pourcent_reste= pot_rest["reste"].to_f / (potinit_val)
			end
			pot_rest["moteur_helice"]=3
			if (montage.equipement.type_equipement.moteur) then pot_rest["moteur_helice"]=1 end
			if (montage.equipement.type_equipement.helice) then pot_rest["moteur_helice"]=2 end
			if (pourcent_reste<0) then pot_rest["couleur"]=2 elsif  (pourcent_reste<0.05) then pot_rest["couleur"]=1  else pot_rest["couleur"]=0  end 
			potrest[j]=pot_rest
			j=j+1
		end
	end
	return(potrest)
	
end

end
