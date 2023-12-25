class Carnet < ActiveRecord::Base
belongs_to:machine, :foreign_key =>:machine_idmachine
validates_presence_of :nombre_cycle ,:message => "le nombre de cycle doit figurer"
validates_presence_of :heure_de_vol, :message => "le nombre d'heure de vol doit etre défini"
validates_presence_of :date_releve ,:message => "la date du relevé doit figurer"
validates_presence_of :machine_idmachine ,:message => "la machine doit être indiquée"
def self.liste_machines_carnet(*date)
	# on selectionne toutes les machines
	list=Hash.new
	
	Machine.where("vendu is false").each do |machine|
		#on récupère pour chaque machines les relevés
		if (date.empty?) then
			list[machine.Immatriculation]=Carnet.liste_machine_carnet(machine.id)
		else
			list[machine.Immatriculation]=Carnet.liste_machine_carnet(machine.id,date)
		end
		list[machine.Immatriculation]["type_machine"]=machine.type_machine.type_machine
	end
	list =list.sort_by{|carnet|  [carnet[1]["type_machine"],carnet[0]]}
	return list
end  
def self.liste_machine_carnet(id_mach,*date)
	# on selectionne toutes les machines
		list=Hash.new
		if (date.empty?) then
			u=self.where("machine_idmachine = ?", id_mach).order("date_releve asc","auto desc","id asc" ).last 
		else
			u=self.where("machine_idmachine = ? and date_releve<= ?", id_mach,date[0]).order("date_releve asc","auto desc","id asc").last
		end
		#on  constitue un tableau avec l'ID machine et les valeurs associées ( HDV,CYCLE,heure moteur)
		if u.nil?
			#si aucun relevé
			list["heure_de_vol"]=0
			list["nombre_cycle"]=0
			list["heure_moteur"]=0
			list["date_releve"]=Date.parse("01/01/1900")
			list["id_carnet"]=nil
			list["auto"]=false
		else
			#on remplit le tableau
			list["heure_de_vol"]=u.heure_de_vol
			list["nombre_cycle"]=u.nombre_cycle
			list["heure_moteur"]=u.heure_moteur
			list["date_releve"]=u.date_releve
			list["id_carnet"]=u.id
			list["auto"]=u.auto
		end
		list["machine"]=id_mach
		#list["type_machine"]=type_machine
	return list
end  
def self.utilisation_moyenne(id_machine)
	#calcule en fonction l'age de la machine l'utilisation moyenne
	list=Hash.new
	#on récupère le dernier relevé
	releve=Carnet.liste_machine_carnet(id_machine)
	#on récupère la date de fabrication de la machine
	mach=Machine.find(id_machine)
	age = (releve["date_releve"]- mach.date_construct)/365
	#on construit le tableau
	list["machine"]=id_machine
	list["heure_de_vol"]=releve["heure_de_vol"].to_f/age
	list["nombre_cycle"]=releve["nombre_cycle"].to_f/age
	list["heure_moteur"]=releve["heure_moteur"].to_f/age
	return(list)
end


end
