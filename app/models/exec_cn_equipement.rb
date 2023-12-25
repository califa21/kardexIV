class ExecCnEquipement < ActiveRecord::Base
	belongs_to:equipement, :foreign_key =>:id_equipement
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:cn_equipement, :foreign_key =>:idcn_equipement
	validates_presence_of :val_potentiel_exec ,:message => "le relevé de potentiel doit figurer"
	validates_presence_of :date_exec ,:message => "la date de la visite doit figurer"
	validates_presence_of :id_equipement ,:message => "l'équipement doit être défini"
	validates_presence_of :idcn_equipement,:message => "la CN doit être définie"
	
	
def self.etat_cn(id_mach,*date)
	# on selectionne les équipements montés sur une machine donnée
	 montages= EstMonteSur.where("idmachine=? and date_retrait is null",id_mach.to_i).order("idequipement")
	 if (date.empty?) then 
		releve=Carnet.liste_machine_carnet(id_mach) 
		releve["date_releve"]=Date.today
	else 
		releve=MaintPrevi.potentiel_a_date(date[0],id_mach)
	end
	 i=0
	 list_def= Hash.new
	 #pour chaque équipement monté
	 montages.each do |montage|
		# list_def[i.to_s]=montages
		#i=i+1
		 #si on a des CN alors on affiche
		  dcn=CnEquipement.where("idtype_equipement =?", montage.equipement.idtypeequipement)
		dcn.each do |cn_ex|
			list=etat_cn_unique(cn_ex,id_mach,montage.idequipement,montage,releve)
			list["idmachine"]=id_mach
			list["equipement_type"]=montage.equipement.type_equipement.nom_constructeur+" " + montage.equipement.type_equipement.type_equipement+" "+montage.equipement.num_serie
			list["num_serie"]=montage.equipement.num_serie
			list["idequipement"]=montage.idequipement
			list["moteur_helice"]=3
			if (montage.equipement.type_equipement.moteur) then list["moteur_helice"]=1 end
			if (montage.equipement.type_equipement.helice) then list["moteur_helice"]=2 end
			list_def[i.to_s]=list
			i=i+1
		end
	end
	return list_def

end

def self.etat_cn_unique(cn_ex,id_machine,id_equipement,montage,releve)
	#récuration de l'état d'un type de cn pour un equipement donné sur une machine donnée
	visites=self.order('date_exec desc').where(id_equipement: id_equipement , idcn_equipement:  cn_ex.id).first
	list=Hash.new
	list["visite_protocolaire"]=cn_ex
	case cn_ex.type_potentiel.type_potentiel
		when "Calendaire"
			list["val_dernier_releve"]=releve["date_releve"]
		when "utilisation moteur" 
			list["val_dernier_releve"]=releve["heure_moteur"]
		when "Heure de vol" 
				list["val_dernier_releve"]=releve["heure_de_vol"]
		when "Nb cycles" 
				list["val_dernier_releve"]=releve["nombre_cycle"]
		else
			list["val_dernier_releve"]=0
		end
		if visites.nil? then
			#si aucun relevé 
			list["idvisite_equipement"]=nil
			list["date_visite"]="pas_applique"
			list["idtype_potentiel"]=0
			list["val_potentiel"]=0
			list["nom"]="pas de visite de ce type faite"
			list["NA"]=false
			#calcul du potentiel restant présupposé les potentiels au montages sont pleins (ie toutes les visites sont faites)
			case cn_ex.type_potentiel.type_potentiel
			when "Calendaire"
				# on calcule avec les dates
				list["butee"]= montage.date_montage>>cn_ex.val_potentiel.to_i
				list["val_potentiel"]=montage.date_montage
			
			when "Une fois"
				list['butee']= ''
				list['val_potentiel']=''
			else
				#la c'est simple on somme les potentiels
				#on détermine le potentiel au montage 
				pot_init=PotentielMontage.find(:all,:conditions =>["idtype_potentiel=? and idest_monte_sur=?",cn_ex.idtype_potentiel,montage.id])
				if (pot_init[0].valeur_machine_jour_montage.nil?) then
					list["butee"]=0
					list["val_potentiel"]=0
				else
					list["butee"]=pot_init[0].valeur_machine_jour_montage+cn_ex.val_potentiel
					list["val_potentiel"]=pot_init[0].valeur_machine_jour_montage
				end
			end
		else
			#on remplit le tableau
			list["idvisite_equipement"]=visites.id
			list["date_visite"]=visites.date_exec
			list["idtype_potentiel"]=visites.idtype_potentiel
			list["NA"]=visites.non_applicable
			if (visites.non_applicable) then
				list["butee"]=  ''
				list["val_potentiel"]=''
			#on calcule les potentiels restant
			elsif(cn_ex.type_potentiel.type_potentiel=="Calendaire") then
				# on calcule avec les dates
				list["butee"]= visites.date_exec>>cn_ex.val_potentiel.to_i
				list["val_potentiel"]=visites.date_exec
			else
				#la c'est simple on somme les potentiels
				list["butee"]=visites.val_potentiel_exec+cn_ex.val_potentiel
				list["val_potentiel"]=visites.val_potentiel_exec
			end
			
		end
		if (cn_ex.type_potentiel.type_potentiel=='Une fois' or  list["NA"]) then
			list['reste']=0
		else
			list['reste']=list['butee']-list['val_dernier_releve']
			#list['reste_tol']=list['butee_tol']-list['val_dernier_releve']
		end
		
		#calcul de la couleur
		couleur=0
		if (list["reste"]<0 or list["date_visite"] == "pas_applique" )  then
			couleur =2 
		else
			reste=0.0
			#on traite en fonction du type de potentiel
			#on calcul le % restant 2 cas si calendaire ou si autre 
			if(cn_ex.type_potentiel.type_potentiel=="Calendaire") then 
				#potentiel calendaire différence en jours et potentiel en mois
				reste=list["reste"].to_f 
				reste=reste/(cn_ex.val_potentiel.to_f)
				reste=reste/30.5
			elsif (cn_ex.type_potentiel.type_potentiel=="Une fois" ) then
			#si une foi et exécuté pas de pb de reste donc 100%
			reste=1
			else
				#dans les autres cas de protentiel pas de soucis 
				reste = list["reste"].to_f/cn_ex.val_potentiel.to_f
			end
			if (reste<0.05) then couleur=1 end
		end
		if (cn_ex.est_annule or list["NA"]) then couleur=0 end
		list["couleur"]=couleur
	return list
end


end
