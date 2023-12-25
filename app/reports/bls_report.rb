class BlsReport < Prawn::Document 
	#impression des kardex par machines
	def to_pdf(id_bl)
		require "prawn/measurement_extensions"
		#chargement font ttf
		font_families.update("Arial" => {
			normal: Rails.root.join('public/font/ARIALN.TTF').to_s,
			italic:   Rails.root.join('public/font/ARIALNI.TTF').to_s,
			bold:  Rails.root.join('public/font/ARIALNB.TTF').to_s,
			bold_italic:  Rails.root.join('public/font/ARIALNBI.TTF').to_s
		})
		font ('Arial')
		######################################################################
		# récupération des données
		@bon_lancement = BonLancement.find(id_bl)
		#################################################################################
		# entête de page
		repeat :all do
			#mise en place entête
			 font 'Arial', {:size => 12}
			bounding_box [0, 280.mm], {:width => 47.mm, :height => 25.mm} do
				transparent(1){ stroke_bounds }
				move_down(1.mm)
				image "#{Rails.root}/app/reports/cab_bloc.jpg",{:scale => 0.6,:position => :center}
				text "Centre Aéronautique de Beynes" , {:align=>:center,:min_font_size => 10,:style=>:bold}
			end
			bounding_box [47.mm, 280.mm], {:width => 87.mm, :height => 25.mm }do
				transparent(1) { stroke_bounds }
				move_down 5.mm
				text(" MANUEL CAE DE L'ORGANISME COMBINE 
				DE MAINTIEN DE LA NAVIGABILITE PARTIE CAO",{:align=>:center,:style=>:bold,:min_font_size => 12,})
				text("ANNEXES",{:align=>:center,:style=>:bold})
			end
			bounding_box [134.mm, 280.mm], :width => 54.mm, :height => 25.mm do
				data=[ ["",""],["Edition","1"],["Amendement","0"], ["Date","02/2021"], ["",""]]
				transparent(1) { stroke_bounds }
				table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 12, :height =>5.mm ,:padding => [0, 0, 0, 0], :width => 27.mm,:borders =>[:left, :right]}) 
			end
			stroke_horizontal_rule
		end
		#####################################################################################################"
		#données de d'utilisation
		move_down 5.mm
		text("<u>Annexe 11</u>",{:align=>:center,:size => 16,:style => :bold,:inline_format => true})
		move_down 5.mm
		text("BON DE LANCEMENT ET EXECUTION N° BL"+num_bl(@bon_lancement) ,{:align=>:center,:size => 16,:style => :bold})
		font 'Arial', :size => 10
		move_down 9.mm
		text("Immatriculation : "+@bon_lancement.machine.Immatriculation + "          Date:"+@bon_lancement.date_lancement.strftime('%d/%m/%Y')+"                au   "+val_date(@bon_lancement.date_fin_trav),{:align=>:left,:style => :bold})
		move_down 5.mm
		########################################################################################################"
		#relevé d'heure
		#récupération machine 
		machine=Machine.find(@bon_lancement.id_machine)
		#récupération dernière GV
		vis_pro=VisiteProtocolaire.where(idtype_machine: @bon_lancement.machine.type_machine_idtype_machine,gv: true).load
		vis_pro.each do |vi_pro|
			visites=VisiteMachine.where("idmachine=? and id_visite_protocolaire=? and date_visite < ?",@bon_lancement.id_machine,vi_pro.id,@bon_lancement.date_lancement).order("date_visite asc").last
			if visites.nil? then
				#pas de visite =>  on donne le nombre d'heure totale ( en principe il y a de toute façon la visite initiale
				@hgv=@bon_lancement.heure_machine.round(0)
			else
				@hgv=(@bon_lancement.heure_machine - visites.fait_a_heure).round(0)
			end
		end	
		# idem pour la denière VA
		vis_pro=VisiteProtocolaire.where(idtype_machine: @bon_lancement.machine.type_machine_idtype_machine,va: true).load
		vis_pro.each do |vi_pro|
	
	#modif à faire visite à prendre en compte est la dernière visite avant la date de lancement
			visites=VisiteMachine.where("idmachine=? and id_visite_protocolaire=? and date_visite < ?",@bon_lancement.id_machine,vi_pro.id,@bon_lancement.date_lancement).order("date_visite asc").last
			if visites.nil? then
				#pas de visite => 
				@hva=@bon_lancement.heure_machine.round(0)
			else
				@hva=(@bon_lancement.heure_machine - visites.fait_a_heure).round(0)
			end
		end	
		#récupération des données Moteur 
		moteurs=Equipement.joins(:est_monte_sur,:type_equipement).where(type_equipements: {moteur: true },est_monte_surs: {idmachine: @bon_lancement.id_machine ,date_retrait: nil})
		moteurs.each do |moteur|
			@marque_moteur=moteur.type_equipement.nom_constructeur
			@type_moteur=moteur.type_equipement.type_equipement
			@num_moteur=moteur.num_serie
			#récupération des valeurs de montages
			pot_init=PotentielMontage.where(idtype_potentiel: 4,idest_monte_sur: moteur.est_monte_sur[0].id)
			potinit_val=pot_init[0].valeur_machine_jour_montage
			#calcul heure totale
			@htm=(@bon_lancement.heure_moteur - potinit_val).round(2)
			#récupération dernière GV
			vis_pro=VisiteProtocolaireEquipement.where(idtype_equipement: moteur.idtypeequipement,gv: true).load
			vis_pro.each do |vi_pro|
				visites=VisiteEquipement.where("idequipement=? and id_visite_protocolaire_equipement=? and date_visite < ?",moteur.id,vi_pro.id,@bon_lancement.date_lancement).order("date_visite asc").last
				@hmgv=(@bon_lancement.heure_moteur - visites.fait_a_heure_moteur).round(2) 
			end	
			#récupération dernière VA
			vis_pro=VisiteProtocolaireEquipement.where(idtype_equipement: moteur.idtypeequipement,va: true).load
			vis_pro.each do |vi_pro|
				visites=VisiteEquipement.where("idequipement=? and id_visite_protocolaire_equipement=? and date_visite < ?",moteur.id,vi_pro.id,@bon_lancement.date_lancement).order("date_visite asc").last
					@hmva=(@bon_lancement.heure_moteur -  visites.fait_a_heure_moteur).round(2)
			end	
		end
		#récupération helice idem moteur sauf que Hélice
		helice=Equipement.joins(:est_monte_sur,:type_equipement).where(type_equipements: {helice: true },est_monte_surs: {idmachine: @bon_lancement.id_machine ,date_retrait: nil}).order("date_montage desc").first
		if (!helice.nil?) then
			@marque_helice=helice.type_equipement.nom_constructeur
			@type_helice=helice.type_equipement.type_equipement
			@num_helice=helice.num_serie
			#il faut selectionner le bon montage 
			montages=helice.est_monte_sur
			montages.each do |montage|
				if montage.date_retrait.nil? then @le_dernier_montage=montage end
			end
			pot_init=PotentielMontage.where(idtype_potentiel: 4,idest_monte_sur: @le_dernier_montage.id).last
			#potinit_val=pot_init[0].valeur_machine_jour_montage
			potinit_val=pot_init.valeur_machine_jour_montage
			@hth=(@bon_lancement.heure_moteur - potinit_val).round(2)
			vis_pro=VisiteProtocolaireEquipement.where(idtype_equipement: helice.idtypeequipement,gv: true).load
			vis_pro.each do |vi_pro|
				visites=VisiteEquipement.where("idequipement=? and id_visite_protocolaire_equipement=? and date_visite < ?",helice.id,vi_pro.id,@bon_lancement.date_lancement).order("date_visite asc").last
				if visites.nil? then
					#pas de visite => 
					@hhgv=(@bon_lancement.heure_moteur - potinit_val).round(2)
				else
					@hhgv=(@bon_lancement.heure_moteur - visites.fait_a_heure_moteur ).round(2)
				end
			end
			
			vis_pro=VisiteProtocolaireEquipement.where(idtype_equipement: helice.idtypeequipement,va: true).load
			vis_pro.each do |vi_pro|
				visites=VisiteEquipement.where("idequipement=? and id_visite_protocolaire_equipement=? and date_visite < ?",helice.id,vi_pro.id,@bon_lancement.date_lancement).order("date_visite asc").last
				if visites.nil? then
					#pas de visite => 
					@hhva=(@bon_lancement.heure_moteur - potinit_val).round(2)
				else
					@hhva=(@bon_lancement.heure_moteur -  visites.fait_a_heure_moteur).round(2)
				end
			end
		end	
		##############################################################################################################################
		#impression du tableau de valeur récupérée
		text("Situation de l’aéronef à l’entrée des travaux",{:align=>:center,:style => :bold})
		data= Array.new(4) {Array.new(6)}
		data[0]=["","MARQUE","TYPE","N° SERIE","HT","HR","HGV"]
		data[1] =["Cellule",@bon_lancement.machine.type_machine.Nom_constructeur,@bon_lancement.machine.type_machine.type_machine,@bon_lancement.machine.num_serie,to_hdv(@bon_lancement.heure_machine),to_hdv(@hva),to_hdv(@hgv)]
		data[2]=["Moteur",@marque_moteur,@type_moteur,@num_moteur,@htm,@hmva,@hmgv]
		data[3]=["Hélice",@marque_helice,@type_helice,@num_helice,@hth,@hhva,@hhgv]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8, :height =>6.mm ,:padding => [0, 0, 0, 0], :width => 26.mm,:border_width => 0}) do |table1|
			table1.rows(1..3).style(:border=>[:right,:bottom,:left,:top],:border_width => 1)
			for i in 1..6 do 
				table1.cells[0,i].style(:border=>[:right,:bottom,:left,:top],:border_width => 1,:background_color => 'E8E8D0')
			end
			for i in 1..3 do 
				table1.cells[i,0].style(:background_color => 'E8E8D0')
			end
			
		end
		############################################################################
		#pour mémoire nombre de lancement et tachy
		move_down(2.mm)
		comp=""
		if !(@bon_lancement.heure_moteur.nil? ||@bon_lancement.heure_moteur==0) then comp=comp+"Référence Tachy :" +@bon_lancement.heure_moteur.to_s end
		if  !(@bon_lancement.cycle.nil?  || @bon_lancement.cycle==0 ) then comp=comp+" Nombre lancement :" +@bon_lancement.cycle.to_s end
		text(comp,{:align=>:right,:size => 8,:style=>:italic,:color => "0000ff",:inline_format=> true})
		##############################################################################################################################
		#impression du tableau des travaux 
		#entete tableau avec merge de cell
		move_down(2.mm)
		data = Array.new(1) {Array.new(3)}
		data[0]=["Nature des travaux","Lancement","Exécution"]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8,:background_color => 'E8E8D0', :height =>10.mm ,:padding => [0, 0, 0, 0],:border_width => 0}) do |table2|
			table2.cells[0,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>98.mm)
			table2.cells[0,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[0,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
		end
		#travaux lancés
		data = Array.new(5) {Array.new(4)}
		#calcul des visites ( merge de nom de viste
		@vis=""
		 @bon_lancement.visite_protocolaire.each do |vis_prot|
			@vis=@vis+"\n "+vis_prot.Nom
		end
		@bon_lancement.type_visite_equipement_lance.order("type_visite_equipement_lances.id_equipement").each do |vis_equi|
			
			@vis=@vis+"\n"+vis_equi.equipement.type_equipement.type_equipement+" "+vis_equi.visite_protocolaire_equipement.Nom
		end
		#on supprime la notion autre travaux pour remettre sur les travaux programmés
		#@vis=@vis+"\n"+@bon_lancement.autre_travaux
		#calcul des CN à appliquer
		@cn=""
		#cn machine
		@bon_lancement.cn_machine.each do |cn|
			if !(@cn=="") then
				@cn=@cn+"\n"+cn.reference+":"+cn.nom
				else
				@cn=cn.reference+":"+cn.nom
			end
		end
		#cn equipement
		@bon_lancement.type_cn_equipement_lance.order("id_equipement").each do |cn|
			if !(@cn=="") then
				@cn=@cn + "\n" + cn.equipement.type_equipement.type_equipement  + ":" + cn.cn_equipement.reference+ cn.cn_equipement.nom
				else
				@cn= cn.equipement.type_equipement.type_equipement  + ":" + cn.cn_equipement.reference + ":" + cn.cn_equipement.nom
			end
		end
		# signataire CN
		if !(@cn=="") then 
				@rn_cn=rn(@bon_lancement)
				@re_cn=re(@bon_lancement)
			else 
				@re_cn=""
				@rn_cn=""
				@cn="/"
		end
			
		#signataire BS
		@bs=""
		if !(@bs=="") then 
				@rn_bs= rn(@bon_lancement)
				@re_bs=re(@bon_lancement)
			else 
				@re_bs=""
				@rn_bs=""
				@bs="/"
		end
		#signataire pièce
		if !(@bon_lancement.piece_changee.count==0) then 
				@rn_cp= rn(@bon_lancement)
				@re_cp=re(@bon_lancement)
				############################################
				# amodifier lister les piéces
				@cp=""
				@bon_lancement.piece_changee.each do |piece|
					@cp=@cp+piece.nom+"\n"
				end
				#@cp=@bon_lancement.piece_chgt
			else 
				@re_cp=""
				@rn_cp=""
				@cp="/"
		end
		#Application des BS
		data[0]=["Visites","Selon Programme","RN","RE"]
		#c est ici qu'il faut rajouter date révision PE
		data[1]=[@vis,@bon_lancement.machine.type_machine.ref_manuel_entretien + val_date(@bon_lancement.machine.type_machine.date_approb),rn(@bon_lancement),re(@bon_lancement)]
		data[2]=["CN:",@cn,@rn_cn,@re_cn]
		data[3]=["BS:",@bs,@rn_bs,@re_bs]
		data[4]=["Pièces à remplacer",@cp,@rn_cp,@re_cp]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6,:padding => [0, 0, 0, 0],:border_width => 0}) do |table2|
			table2.cells[0,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>38.mm, :height =>5.mm,:background_color => 'E8E8D0',)
			table2.cells[0,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>60.mm ,:background_color => 'E8E8D0')
			table2.cells[0,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm,:background_color => 'E8E8D0')
			table2.cells[0,3].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm,:background_color => 'E8E8D0')
			table2.cells[1,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>38.mm, :height =>20.mm)
			table2.cells[1,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>60.mm)
			table2.cells[1,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[1,3].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
			table2.cells[2,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>38.mm, :height =>10.mm,:background_color => 'E8E8D0')
			table2.cells[2,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>60.mm, :height =>15.mm, :min_font_size => 4)
			table2.cells[2,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[2,3].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
			table2.cells[3,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>38.mm, :height =>10.mm,:background_color => 'E8E8D0')
			table2.cells[3,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>60.mm)
			table2.cells[3,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[3,3].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
			table2.cells[4,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>38.mm, :height =>20.mm,:background_color => 'E8E8D0')
			table2.cells[4,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>60.mm)
			table2.cells[4,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[4,3].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
		end
		data = Array.new(1) {Array.new(3)}
		data[0]=["Travaux supplémentaires","Lancement\n  RN","Exécution\n  RE"]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8,:background_color => 'E8E8D0', :height =>10.mm ,:padding => [0, 0, 0, 0],:border_width => 0}) do |table2|
			table2.cells[0,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>98.mm)
			table2.cells[0,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[0,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
		end
		@rn_decou=rn_decou(@bon_lancement)
		@re_decou=re_decou(@bon_lancement)
		data = Array.new(1) {Array.new(4)}
		data[0]=["Programmés",@bon_lancement.trav_prog,@rn_cp,@re_cp]
		data[1]=["Découverts en visite",@bon_lancement.trav_decou,@rn_decou,@re_decou]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8, :height =>15.mm ,:padding => [0, 0, 0, 0],:border_width => 0}) do |table2|
			table2.cells[0,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>31.mm,:background_color => 'E8E8D0')
			table2.cells[0,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>67.mm)
			table2.cells[0,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[0,3].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
			table2.cells[1,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>31.mm,:background_color => 'E8E8D0')
			table2.cells[1,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>67.mm)
			table2.cells[1,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>37.mm)
			table2.cells[1,3].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
		end
		data=Array.new(1) {Array.new(2)}
		data[0]=["Fiches anomalies","Acceptation Report"]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8,:background_color => 'E8E8D0', :height =>10.mm ,:padding => [0, 0, 0, 0],:border_width => 0}) do |table2|
			table2.cells[0,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>135.mm)
			table2.cells[0,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
		end
		data=Array.new(3) {Array.new(3)}
		data[0]=["Réf.\n Fiche anomalie","Détail","RN"]
		data[1]=["","Néant",""]
		data[2]=["","",""]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8, :height =>10.mm ,:padding => [0, 0, 0, 0],:border_width => 0}) do |table2|
			
			table2.cells[0,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>31.mm,:background_color => 'E8E8D0')
			table2.cells[0,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>104.mm,:background_color => 'E8E8D0')
			table2.cells[0,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm,:background_color => 'E8E8D0')
			table2.cells[1,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>31.mm)
			table2.cells[1,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>104.mm)
			table2.cells[1,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
			table2.cells[2,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>31.mm)
			table2.cells[2,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>104.mm)
			table2.cells[2,2].style(:border=>[:right,:left,:top],:border_width => 1,:width=>47.mm)
		end
		data=Array.new(1) {Array.new(2)}
		if  @bon_lancement.date_fin_trav.nil? then cr="" else cr= "CR"+num_bl(@bon_lancement) end
		data[0]=["Réference compte rendu de travaux",cr]
		table(data,:cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8, :height =>10.mm ,:padding => [0, 0, 0, 0],:border_width => 0}) do |table2|
			table2.cells[0,0].style(:border=>[:right,:left,:top],:border_width => 1,:width=>77.mm,:background_color => 'E8E8D0')
			table2.cells[0,1].style(:border=>[:right,:left,:top],:border_width => 1,:width=>105.mm)
		end
		
		number_pages "<page> / <total>", 
                                {:start_count_at => 1,
                                :at => [bounds.right - 50, 0],
                                :align => :right,
				:size => 8}	
		#number_pages "<page> in a total of <total>", [bounds.right - 50, 0]
		 render
	 end
	 def com_equip (type_equipement)
		 move_down 10.mm
		font "Times-Roman", :size => 12
		 result = case type_equipement
			when 1 then "Moteur"
			when 2 then "Hélice"
			when 3 then "Divers"
			else "PB"
		end
		text  result
		move_down 10.mm
		font "Times-Roman", :size => 8
	 end
	private 
	def rn(bon_lancement)
		if bon_lancement.rn.nil? then
			@rn=""
		else
			@rn=bon_lancement.rn.Nom+"\n"+val_date(bon_lancement.date_lancement)
		end
	end
	def re(bon_lancement)
		if bon_lancement.re.nil? then
			@re=""
		else
			@re=bon_lancement.re.Nom+"\n"+val_date(bon_lancement.date_exec)
		end
	end
	def rn_decou(bon_lancement)
		if bon_lancement.rn_decou.nil? then
			@rn=""
		else
			@rn=bon_lancement.rn_decou.Nom+"\n"+val_date(bon_lancement.date_decou)
		end
	end
	def re_decou(bon_lancement)
		if bon_lancement.re_decou.nil? then
			@re=""
		else
			@re=bon_lancement.re_decou.Nom+"\n"+val_date(bon_lancement.date_exec_decou)
		end
	end
	def val_date(date_c)
		if !date_c.nil? then return date_c.strftime('%d/%m/%Y') else return ("") end
	end
	def num_bl (bl)
		return(bl.numero+bl.machine.Immatriculation.last(4))
	end
	def to_hdv(val)
	  potin=(val.to_i/60).to_i
	to_hdv=potin.to_s+":"+sprintf('%02.0f',val.to_i-60*potin)
  end
end
