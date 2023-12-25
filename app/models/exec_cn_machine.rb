class ExecCnMachine < ActiveRecord::Base
	belongs_to:machine, :foreign_key =>:id_machine
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:cn_machine, :foreign_key =>:idcn_machine
	validates_presence_of :val_potentiel_exec ,:message => 'le relevÃ© de potentiel doit figurer'
	validates_presence_of :date_exec ,:message => 'la date de la visite doit figurer'
	validates_presence_of :id_machine ,:message => 'la machine doit figurer'
	validates_presence_of :idcn_machine ,:message => 'la CN doit figurer'

def self.etat_cn(id_mach,*date)
	liste2=Hash.new
	# on selectionne les CN machines  du type de machine
	machine=Machine.find(id_mach)
	dcn=CnMachine.where(idtype_machine: machine.type_machine_idtype_machine)
	#récupération état potentiel 
	if (date.empty?) then 
		releve=Carnet.liste_machine_carnet(id_mach) 
		releve["date_releve"]=Date.today
	else 
		releve=MaintPrevi.potentiel_a_date(date[0],id_mach)
	end
	
	#visite par visiste protocolaire on selectionne la dernière
	dcn.each do |cn_ex|
		list=Hash.new
		visites=self.where('id_machine = ? and idcn_machine= ? ',id_mach,cn_ex.id).order('date_exec asc').last
		if cn_ex.type_potentiel.type_potentiel=='Calendaire' then 
			list['val_dernier_releve']=releve["date_releve"]
		elsif cn_ex.type_potentiel.type_potentiel=='utilisation moteur' then
			list['val_dernier_releve']=releve['heure_moteur']
		elsif cn_ex.type_potentiel.type_potentiel=='Heure de vol' then 
			list['val_dernier_releve']=releve['heure_de_vol']
		elsif cn_ex.type_potentiel.type_potentiel=='Nb cycles' then
			list['val_dernier_releve']=releve['nombre_cycle']
		else
			list['val_dernier_releve']=0
		end
	#on cree le tableau qui va bien
		#on  constitue un tableau avec l'ID machine et les valeurs associées ( HDV,CYCLE,heure moteur)
		if visites.nil? then
			#si aucune visites
			list["nom"]="cn pas applique"
			list['idvisite_machine']=nil
			list['date_visite']='pas applique '
			list['idtype_potentiel']=0
			list['val_potentiel']=0
			if(cn_ex.type_potentiel.type_potentiel=='Calendaire') then
				# on calcule avec les dates
				list['butee']= machine.date_construct
				list['val_potentiel']=machine.date_construct
			else if (cn_ex.type_potentiel.type_potentiel=='Une fois') then
				list['butee']= ''
				list['val_potentiel']=''
			else 
				#la c'est simple on somme les potentiels
				list['butee']=0
				list['val_potentiel']=0
				list["NA"]=false
			end
			end
		else
			list['idexec_cn_machine']=visites.id
			list['date_visite']=visites.date_exec.strftime('%d/%m/%Y')
			list['idtype_potentiel']=visites.idtype_potentiel
			list['nom']=visites.cn_machine.nom
			list["NA"]=visites.non_applicable
			#on calcule les potentiels restant
			if(cn_ex.type_potentiel.type_potentiel=='Calendaire') then
				# on calcule avec les dates
				list['butee']= visites.date_exec>>cn_ex.val_potentiel.to_i
				list['val_potentiel']=visites.date_exec
			else if (cn_ex.type_potentiel.type_potentiel=='Une fois') then
				list['butee']= ''
				list['val_potentiel']=''
			else 
				#la c'est simple on somme les potentiels
				list['butee']=visites.val_potentiel_exec+cn_ex.val_potentiel
				list['val_potentiel']=visites.val_potentiel_exec
			end
			end

		end
		if (cn_ex.type_potentiel.type_potentiel=='Une fois') then
			list['reste']=0
		else
			list['reste']=list['butee']-list['val_dernier_releve']
		end
		
		list['visite_protocolaire']= cn_ex
		list['idmachine']=id_mach
		couleur=0
		#calcul de la couleur
		if (list["reste"]<0 or  list["date_visite"] == "pas applique ") then
			couleur =2 
		else
			reste=0.0
			#on calcul le % restant 2 cas si calendaire ou si autre 
			if( cn_ex.type_potentiel.type_potentiel=="Calendaire") then 
				#potentiel calendaire différence en jours et potentiel en mois
				reste=list["reste"].to_f
				reste=reste/(cn_ex.val_potentiel.to_f*30.5)
			elsif (cn_ex.type_potentiel.type_potentiel=="Une fois") then
				#si une foi et exécuté pas de pb de reste donc 100%
				reste=1
			else
				#dans les autres cas de protentiel pas de soucis 
				reste = list["reste"].to_f/cn_ex.val_potentiel.to_f
			end
			if (reste<0.05) then couleur=1 end
		end
		if (cn_ex.est_annule) then couleur=0 end
		list["couleur"]=couleur
		liste2[cn_ex.id]=list
	end
	return liste2
end
end
