class MaintPrevi < ActiveRecord::Base
def self.potentiel_a_date(date,id_machine)
	list=Hash.new
	#on récupére le relevé à la date qui va bien 
	u=Carnet.where("machine_idmachine = ? and date_releve >?", id_machine,date).order("date_releve asc").first
	if (u.nil?) then 
		u= Carnet.where("machine_idmachine = ? ", id_machine).order("date_releve desc").first
		list["ko"]="KO"
	end
	#manque gestion du null!!
	#on récupére les utilisations moyennes 
	util=Carnet.utilisation_moyenne(id_machine)
	#on calcule le potentiel à la date déterminé
	list["machine"]=id_machine
	list["heure_de_vol"]=u.heure_de_vol.to_f+util["heure_de_vol"]
	list["nombre_cycle"]=u.nombre_cycle.to_f+util["nombre_cycle"]
	list["heure_moteur"]= (u.heure_moteur).to_f+util["heure_moteur"].to_f
	list["date_releve"]=u.date_releve.to_date+12.month
	list["carnet"]=u
	return (list)
end


end
