class PotentielMachine < ActiveRecord::Base
	
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:type_machine, :foreign_key =>:idtype_machine
	validates_presence_of :idtype_machine,:message => "le type machine ne peut être vide"
	validates_presence_of :idtype_potentiel,:message => "le type potentiel ne peut être vide"
	def self.potentiel_machine(id_machine,*date)
	#calcul les potentiels restant pour une machine
	machine=Machine.find(id_machine)
	if (date.empty?) then 
		releve=Carnet.liste_machine_carnet(id_machine) 
		releve["date_releve"]=Date.today
	else 
		releve=MaintPrevi.potentiel_a_date(date[0],id_machine)
	end
	potentiel=machine.type_machine.potentiel_machine
	pots_machs=Array.new
	j=0
	potentiel.each do |potentiel_machine|
		pot_mach=Hash.new
		pot_mach["nom"]=potentiel_machine.nom
		pot_mach["val_pot"]=potentiel_machine.valeur_potentiel
		pot_mach["unitee"]=potentiel_machine.type_potentiel.unitee
		pot_mach["type_potentiel"]=potentiel_machine.type_potentiel.type_potentiel
		if potentiel_machine.type_potentiel.type_potentiel=="Calendaire" then 
			pot_mach["val_dernier_releve"]=releve["date_releve"]
		elsif potentiel_machine.type_potentiel.type_potentiel=="utilisation moteur" then
			pot_mach["val_dernier_releve"]=releve["heure_moteur"]
		elsif potentiel_machine.type_potentiel.type_potentiel=="Heure de vol" then 
			pot_mach["val_dernier_releve"]=releve["heure_de_vol"]
		elsif potentiel_machine.type_potentiel.type_potentiel=="Nb cycles" then
			pot_mach["val_dernier_releve"]=releve["nombre_cycle"]
		else
			pot_mach["val_dernier_releve"]=0
		end
		if(potentiel_machine.type_potentiel.type_potentiel=="Calendaire")
			# on calcule avec les dates
			pot_mach["butee"]= machine.date_construct + potentiel_machine.valeur_potentiel.month
			pot_mach["val_potentiel"]=machine.date_construct
			pot_mach["reste"]=(machine.date_construct + potentiel_machine.valeur_potentiel.month) - releve["date_releve"]
			reste=pot_mach["reste"].to_f 
			reste=reste/(pot_mach["val_potentiel"] .to_f)
			reste=reste/30.5
		elsif
			#ici c'est calculé en minute donc on remet en heure minutes
			pot_mach["butee"]=self.to_hm(potentiel_machine.valeur_potentiel)
			pot_mach["val_potentiel"]=to_hm(potentiel_machine.valeur_potentiel)
			pot_mach["reste"]=potentiel_machine.valeur_potentiel - pot_mach["val_dernier_releve"]
			reste = ((potentiel_machine.valeur_potentiel - pot_mach["val_dernier_releve"])/potentiel_machine.valeur_potentiel).to_f
		else
			#la c'est simple on somme les potentiels
			pot_mach["butee"]=potentiel_machine.valeur_potentiel
			pot_mach["val_potentiel"]=potentiel_machine.valeur_potentiel
			pot_mach["reste"]=pot_mach["butee"] - pot_mach["val_dernier_releve"]
			reste = pot_mach["reste"].to_f/pot_mach["val_potentiel"].to_f
		end
		#calcul de la couleur
		if (pot_mach["reste"] <0) then 
			couleur=2
		else
			if (reste<0.05) then couleur=1 end	
		end
		pot_mach["couleur"]=couleur
		pots_machs[j]=pot_mach
		j=j+1
	end
	return (pots_machs)
end
 private
def self.to_hm(val)
	potin=(val/60).to_i
	return (potin.to_s+":"+sprintf('%02.0f',val-60*potin))
end 
end
