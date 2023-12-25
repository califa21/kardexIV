class VisiteMachine < ActiveRecord::Base
belongs_to:machine, :foreign_key =>:idmachine
belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
belongs_to:visite_protocolaire, :foreign_key =>:id_visite_protocolaire
#validates_presence_of :val_potentiel ,:message => "le relevÃ© de potentiel doit figurer"
validates_presence_of :date_visite ,:message => "la date de la visite doit figurer"
validates_presence_of :idmachine ,:message => "la machine doit Ãªtre dÃ©finie"
validates_presence_of :id_visite_protocolaire ,:message => "la date de la visite doit figurer"
validate :pot_var
 
  def pot_var
    if (self.visite_protocolaire.potentiel_variable and self.val_nouv_pot.nil?) then
      errors.add(:val_nouv_pot, "le potentiel de la visite doit Ãªtre rempli")
    end
  end
####################################################################################
#cacul pour une machine et une date l'état de toutes les vistes protocolaires
def self.dernieres_visites(id_mach,*date)
	#récupération des potentiels à date déterminée
	if (date.empty?) then 
		releve=Carnet.liste_machine_carnet(id_mach) 
		releve["date_releve"]=Date.today
	else 
		releve=MaintPrevi.potentiel_a_date(date[0],id_mach)
	end
	liste2=Hash.new
	# on selectionne les visites protocolaire du type de machine
	 machine=Machine.find(id_mach)
	vis_pro=VisiteProtocolaire.where(idtype_machine: machine.type_machine_idtype_machine).load
	#visite par visiste protocolaire on selectionne la dernière
	vis_pro.each do |vi_pro|
		list=Hash.new
		#visites=find_by_idmachine_and_id_visite_protocolaire(id_mach,vi_pro.id,[:last,:order => "date_visite desc"])
		visites=VisiteMachine.where("idmachine=? and id_visite_protocolaire=?",id_mach,vi_pro.id).order("date_visite asc").last
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
	#on cree le tableau qui va bien
		#on  constitue un tableau avec l'ID machine et les valeurs associées ( HDV,CYCLE,heure moteur)
		if visites.nil?
			#si aucun relevé 
			#on prend la valeur par défaut de la visite 
			list["idvisite_machine"]=nil
			list["date_visite"]=machine.date_construct
			list["idtype_potentiel"]=0
			list["val_potentiel"]=0
			list["nom"]="pas de visite de ce type faite"
			if(vi_pro.type_potentiel.type_potentiel=="Calendaire")
				# on calcule avec les dates
				list["butee"]= machine.date_construct>>vi_pro.valeur_potentiel.to_i
				list["butee_tol"]=list["butee"]>>vi_pro.tolerance.to_i
				list["val_potentiel"]=machine.date_construct
				list["reste"]=list["butee"] - list["val_dernier_releve"]
				list["reste_tol"]=list["butee_tol"] -list["val_dernier_releve"]
			else
				#la c'est simple on somme les potentiels
				list["butee"]=vi_pro.valeur_potentiel
				list["butee_tol"]=list["butee"]+vi_pro.tolerance
				list["val_potentiel"]=vi_pro.valeur_potentiel
				list["reste"]=list["butee"] - list["val_dernier_releve"]
				list["reste_tol"]=list["butee_tol"] -list["val_dernier_releve"]
			end
			
		else
			#on remplit le tableau
			#on teste si potentiel variable 
			if (vi_pro.potentiel_variable) 
				potentiel_cal=visites.val_nouv_pot
			else
				potentiel_cal=vi_pro.valeur_potentiel
			end
			list["idvisite_machine"]=visites.id
			list["date_visite"]=visites.date_visite
			list["idtype_potentiel"]=visites.idtype_potentiel
			list["nom"]=visites.nom
			#on calcule les potentiels restant
			if(vi_pro.type_potentiel.type_potentiel=="Calendaire")
				# on calcule avec les dates
				list["butee"]= visites.date_visite>>potentiel_cal.to_i #*(-1) #+vi_pro.valeur_potentiel.month
				list["butee_tol"]=list["butee"]>>vi_pro.tolerance.to_i
				list["val_potentiel"]=visites.date_visite
			else
				#la c'est simple on somme les potentiels
				list["butee"]=visites.val_potentiel+potentiel_cal #vi_pro.valeur_potentiel
				list["butee_tol"]=list["butee"]+vi_pro.tolerance
				list["val_potentiel"]=visites.val_potentiel
			end
			list["reste"]=list["butee"] - list["val_dernier_releve"]
			list["reste_tol"]=list["butee_tol"] -list["val_dernier_releve"]
		end
		couleur=0
		#on calcule la couleur 
		if (list["reste"]<0 )  then
			couleur =2 
		else
			reste=0.0
			#on traite en fonction du type de potentiel
			#on calcul le % restant 2 cas si calendaire ou si autre 
			if( vi_pro.type_potentiel.type_potentiel=="Calendaire") then 
				#potentiel calendaire différence en jours et potentiel en mois
				reste=list["reste"].to_f
				reste=reste/(vi_pro.valeur_potentiel.to_f*30.5)
			else
				#dans les autres cas de protentiel pas de soucis 
				reste = list["reste"].to_f/vi_pro.valeur_potentiel.to_f
			end
			if (reste<0.05) then couleur=1 end
		end
		list["couleur"]=couleur
		#on rajoute la bonne valeur du carnet 
		list["visite_protocolaire"]=vi_pro
		list["idmachine"]=id_mach
		liste2[vi_pro.id]=list
	end
	return liste2
end  
#########################################################################################
# calcul les vistes prévisibles à une date déterminé

def self.visites_previ(date)
	
	liste2=Hash.new
	#on prend la liste des machines 
	machines=Machine.find_each
	i=0
	machines.each do |machine|
		#pour chaque machine 
		#on prend le prévisionnel d'heure
		releve=MaintPrevi.potentiel_a_date(date,machine.id)
		#on récupère les visites protocolaires et la dernière exécution
		vis_pro=VisiteProtocolaire.where("idtype_machine = ?", machine.type_machine_idtype_machine)
		vis_pro.each do |vi_pro|
			list=Hash.new
			#visite par visiste protocolaire on selectionne la dernière
			visites=self.where("idmachine=? and id_visite_protocolaire=?",machine.id,vi_pro.id).order("date_visite asc").last
			#find_by_idmachine_and_id_visite_protocolaire(machine.id,vi_pro.id,:last, :order => "date_visite desc")
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
		#on cree le tableau qui va bien
			#on  constitue un tableau avec l'ID machine et les valeurs associées ( HDV,CYCLE,heure moteur)
			if visites.nil?
				#si aucun relevé 
				#on prend la valeur par défaut de la visite 
				list["idvisite_machine"]=nil
				list["date_visite"]=machine.date_construct
				list["idtype_potentiel"]=0
				list["val_potentiel"]=0
				list["nom"]="pas de visite de ce type faite"
				if(vi_pro.type_potentiel.type_potentiel=="Calendaire")
					# on calcule avec les dates
					list["butee"]= machine.date_construct>> vi_pro.valeur_potentiel.to_i
					list["butee_tol"]=list["butee"]>>vi_pro.tolerance.to_i
					list["val_potentiel"]=machine.date_construct
					list["reste"]=list["butee"] - list["val_dernier_releve"]
					list["reste_tol"]=list["butee_tol"] -list["val_dernier_releve"]
				else
					#la c'est simple on somme les potentiels
					list["butee"]=vi_pro.valeur_potentiel
					list["butee_tol"]=list["butee"]+vi_pro.tolerance
					list["val_potentiel"]=vi_pro.valeur_potentiel
					list["reste"]=list["butee"] - list["val_dernier_releve"]
					list["reste_tol"]=list["butee_tol"] -list["val_dernier_releve"]
				end
				
			else
				#on remplit le tableau
				#on teste si potentiel variable 
				if (vi_pro.potentiel_variable) 
					potentiel_cal=visites.val_nouv_pot
				else
					potentiel_cal=vi_pro.valeur_potentiel
				end
				list["idvisite_machine"]=visites.id
				list["date_visite"]=visites.date_visite
				list["idtype_potentiel"]=visites.idtype_potentiel
				list["nom"]=visites.nom
				#on calcule les potentiels restant
				if(vi_pro.type_potentiel.type_potentiel=="Calendaire")
					# on calcule avec les dates
					list["butee"]= visites.date_visite>>potentiel_cal.to_i  #+vi_pro.valeur_potentiel.month
					list["butee_tol"]=list["butee"]>>vi_pro.tolerance.to_i
					list["val_potentiel"]=visites.date_visite
				else
					#la c'est simple on somme les potentiels
					list["butee"]=visites.val_potentiel+potentiel_cal #vi_pro.valeur_potentiel
					list["butee_tol"]=list["butee"]+vi_pro.tolerance
					list["val_potentiel"]=visites.val_potentiel
				end
				list["reste"]=list["butee"] - list["val_dernier_releve"]
				list["reste_tol"]=list["butee_tol"] -list["val_dernier_releve"]
			end
			couleur=0
			#on calcule la couleur 
			if (list["reste"]<0 )  then
				couleur =2 
			else
				reste=0.0
				#on traite en fonction du type de potentiel
				#on calcul le % restant 2 cas si calendaire ou si autre 
				if( vi_pro.type_potentiel.type_potentiel=="Calendaire") then 
					#potentiel calendaire différence en jours et potentiel en mois
					reste=list["reste"].to_f
					reste=reste/(vi_pro.valeur_potentiel.to_f*30.5)
				else
					#dans les autres cas de protentiel pas de soucis 
					reste = list["reste"].to_f/vi_pro.valeur_potentiel.to_f
				end
				if (reste<0.05) then couleur=1 end
			end
			list["couleur"]=couleur
			list["releve"]=releve
			#on rajoute la bonne valeur du carnet 
			list["visite_protocolaire"]=vi_pro
			list["machine"]=machine
			if (list["reste"]<0 ) then 
				liste2[i.to_s]=list 
				i=i+1
			end
		end
	end
	return liste2
end  







end

