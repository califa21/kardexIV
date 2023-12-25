class Machine < ActiveRecord::Base
belongs_to:type_machine, :foreign_key =>:type_machine_idtype_machine
validates_presence_of :type_machine_idtype_machine ,:message => "le type de machine ne peut etre vide"
validates_presence_of :Immatriculation ,:message => "l'immatriculation ne peut etre vide"
validates_presence_of :num_serie, :message => "le numéro de série ne peut etre vide"
validates_presence_of :date_construct, :message => "la date de construction ne peut être vide"
has_many :modif_repar, :foreign_key =>:id_machine
has_many :montage_equipement, :foreign_key =>:idmachine


def self.couleur(id)
	# fait le tour de l'état d'une machine pour indiquer si probléme de maintien en navigabilité
	#couleur ( 0 = vert; 1 orange ; 2 rouge)
	# calcul des visites machines et equipement
	couleur=Machine.couleur_visite(id)
	#calcul des CN machine
	if (couleur<2) then
		cool=Machine.couleur_cn_machine(id)
		if (cool > couleur) then couleur=cool end
	end
	#calcul des CN équipement
	if (couleur<2) then
		cool=Machine.couleur_cn_equipement(id)
		if (cool > couleur) then couleur=cool end
	end
	if (couleur<2) then
		cool=Machine.couleur_potentiel_machine(id)
		if (cool > couleur) then couleur=cool end
	end
	
	return (couleur)
end
def self.tab_visite(id)
#récupère machine
	if !(id.nil?) then
		u=find(id)
		vis_pro=VisiteProtocolaire.where("idtype_machine = ?",  u.type_machine_idtype_machine)
		return nil if vis_pro.nil?
	else
		vis_pro=VisiteProtocolaire.all
	end
	j=0
	list=[]
	vis_pro.each do |vis_pro|
		list[j]=[vis_pro.Nom,vis_pro.id]
		j=j+1
	end
	return list
end
def self.couleur_visite(id)
	couleur=0
	# calcul des visites machines
	visites_machine=VisiteMachine.dernieres_visites(id)
	visites_machine.each do |visite|
		if (couleur<2) then
			#si le reste est négatif = rouge
			if (visite[1]["reste"]<0 )  then
				couleur =2 
			else
				reste=0.0
				#on traite en fonction du type de potentiel
				#on calcul le % restant 2 cas si calendaire ou si autre 
				if( visite[1]["visite_protocolaire"].type_potentiel.type_potentiel=="Calendaire") then 
					#potentiel calendaire différence en jours et potentiel en mois
					reste=visite[1]["reste"].to_f
					reste=reste/(visite[1]["visite_protocolaire"].valeur_potentiel.to_f*30.5)
				else
					#dans les autres cas de protentiel pas de soucis 
					reste = visite[1]["reste"].to_f/visite[1]["visite_protocolaire"].valeur_potentiel.to_f
				end
				if (reste<0.05) then couleur=1 end
			end
		end
	end
	#calcul des vistes équipement
	#calcul des visites équipement montée sur la machine 
	visites_equipement=VisiteEquipement.dernieres_visites(id)
	# visite par visite on regarde
	if (couleur<2) then
		visites_equipement.each do |visite|
			if (visite[1]["couleur"] > couleur) then couleur=visite[1]["couleur"] end
		end
	end
	return (couleur)
end

def self.couleur_cn_machine(id)
	couleur=0
	#calcul des application CN machine
	cn_machine=ExecCnMachine.etat_cn(id)
	cn_machine.each do |cn_ex|
		if (cn_ex[1]["couleur"] > couleur) then couleur=cn_ex[1]["couleur"] end
	end
	return (couleur)
end
def self.couleur_cn_equipement(id)
	cn_equipement_machine=ExecCnEquipement.etat_cn(id)
	couleur=0
	cn_equipement_machine.each do |cn_ex|
		if (cn_ex[1]["couleur"] > couleur) then couleur=cn_ex[1]["couleur"] end
	end
	return(couleur)
end
def self.couleur_potentiel_machine(id)
	couleur=0
	#calcul des potentiels machine
	pots_machs=PotentielMachine.potentiel_machine(id)
	pots_machs.each do |pot_mach|
		if (pot_mach["reste"] <0) then 
			couleur=2
		else
			if(pot_mach["type_potentiel"]=="Calendaire") then 
				#potentiel calendaire différence en jours et potentiel en mois
				reste=pot_mach["reste"].to_f 
				reste=reste/(pot_mach["val_potentiel"] .to_f)
				reste=reste/30.5
			else
				#dans les autres cas de protentiel pas de soucis 
				reste = pot_mach["reste"].to_f/pot_mach["val_potentiel"].to_f
			end
			if (reste<0.05) then couleur=1 end	
		end
	end
	#calcul des potentiels équipement
	if (couleur<2) then
		montages=Equipement.potentiel_restant_machine(id)
		#on prend équipement par équipement
		montages.each do |montage| 
			equipement=montage[1]["equipement"]
			#potentiel restant au montage de l'équipement 
			if (montage[1]["couleur"] > couleur) then couleur=montage[1]["couleur"] end
		end
	end
	return(couleur)
end


end
