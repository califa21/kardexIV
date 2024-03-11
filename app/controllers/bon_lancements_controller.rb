class BonLancementsController < ApplicationController
	include ApplicationHelper
  before_action :page_def
  before_action :set_bon_lancement, only: [:show, :edit, :update, :destroy]
 before_action :page_acc
  # GET /bon_lancements
  # GET /bon_lancements.json
  def index
    @bon_lancements = BonLancement.all.order(id: :desc)
  end

  # GET /bon_lancements/1
  # GET /bon_lancements/1.json
  def show
	respond_to do |format|
		format.html {}
		format.pdf { 
			#bon de lancement seul
			if (params[:type_rapport].nil? || params[:type_rapport]=="lancement") then 
				rap =BlsReport.new(:page_size => "A4", :page_layout => :portrait)
				output=rap.to_pdf(params[:id])
				send_data output, :filename => "bl"+@bon_lancement.numero+".pdf",:type => "application/pdf"
			#lancement avec carte de travail
			elsif (params[:type_rapport]=="lancement_cv") then 
				#d'abord on fabrique le PDF de lancement
				rap =BlsReport.new(:page_size => "A4", :page_layout => :portrait)
				output = rap.to_pdf(params[:id])
				pdf1=CombinePDF.new
				pdf1 << CombinePDF.parse(output)
				directory = "public/data"
				#pour chaque visite protocoaire lancée on récupère le PDF correspondant à la carte de travail
				carte1=false
				@bon_lancement.visite_protocolaire.each do |vis_prot|
					if (vis_prot.carte) then
							@id_machine =vis_prot.idtype_machine
							carte1=true 
						end
				end
				if carte1 then
					@carte_travail=DocDiver.where("type_doc_id=9 and id_entite=?",@id_machine)
						carte = @carte_travail.first
							# on cr饠le path
							path = File.join(directory, carte.adresse)
							pdf1 <<  CombinePDF.load(path, unsafe: true, allow_optional_content: true)
				end
					
				#pour chaque visite d'équipement
				@equi=0
				carte2= false
				@bon_lancement.type_visite_equipement_lance.order("type_visite_equipement_lances.id_equipement").each do |vis_equi|
						if (vis_equi.visite_protocolaire_equipement.carte and !carte2) then
					
							@carte_travail=DocDiver.where("type_doc_id=10 and id_entite=?",vis_equi.equipement.type_equipement.id)
							carte = @carte_travail.first
							# on cr饠le path
							path = File.join(directory, carte.adresse)
							pdf1 <<  CombinePDF.load(path, unsafe: true, allow_optional_content: true)
							carte2= true
						end
						if @equi != vis_equi.id_equipement then 
							if @equi !=0 then carte2= false end
							@equi = vis_equi.id_equipement
						end
				end
				#on envoi
				send_data pdf1.to_pdf, :filename => "bl"+@bon_lancement.numero+".pdf",:type => "application/pdf"
			else
				rap=CrReport.new(:page_size => "A4", :page_layout => :portrait)
				output=rap.to_pdf(params[:id])
				send_data output, :filename => "rap"+@bon_lancement.numero+".pdf",:type => "application/pdf"
			end
		}
        end
  end

  # GET /bon_lancements/new
  def new
	@date_1= Date.today.strftime('%d/%m/%Y')
    @bon_lancement = BonLancement.new
	if !(params[:id_machine].nil?) then 
		@bon_lancement.id_machine=params[:id_machine]
					#on recupére les visites susceptibles d'être lancé
				@vis_prots=VisiteMachine.dernieres_visites(@bon_lancement.id_machine)
				@cn_machine=ExecCnMachine.etat_cn(@bon_lancement.id_machine)
				@visites_equipement=VisiteEquipement.dernieres_visites(@bon_lancement.id_machine)
				@visites_equipement=@visites_equipement.sort_by {|visite_equipement| visite_equipement[1]["moteur_helice"]}
				@cn_equipement_machine=ExecCnEquipement.etat_cn(@bon_lancement.id_machine)
				@cn_equipement_machine=@cn_equipement_machine.sort_by{|cn_equipement| [cn_equipement[1]["moteur_helice"],cn_equipement[1]["equipement_type"]]}
				#gestion  heure minute carnet
				@carnet=Carnet.liste_machine_carnet(params[:id_machine])
				@bon_lancement.heure_machine=pres_val(@carnet["heure_de_vol"],"Heure de vol")
				@bon_lancement.heure_moteur=@carnet["heure_moteur"]
				@bon_lancement.cycle=@carnet["nombre_cycle"]
	end
    3.times {@bon_lancement.piece_changee.build}
  end

  # GET /bon_lancements/1/edit
  def edit
	@date_1= @bon_lancement.date_lancement.strftime('%d/%m/%Y')
	#on recupére les visites susceptibles d'être lancé
	@vis_prots=VisiteMachine.dernieres_visites(@bon_lancement.id_machine)
	@cn_machine=ExecCnMachine.etat_cn(@bon_lancement.id_machine)
	@visites_equipement=VisiteEquipement.dernieres_visites(@bon_lancement.id_machine)
	@visites_equipement=@visites_equipement.sort_by {|visite_equipement| visite_equipement[1]["moteur_helice"]}
	@cn_equipement_machine=ExecCnEquipement.etat_cn(@bon_lancement.id_machine)
	@cn_equipement_machine=@cn_equipement_machine.sort_by{|cn_equipement| [cn_equipement[1]["moteur_helice"],cn_equipement[1]["equipement_type"]]}
	3.times {@bon_lancement.piece_changee.build}
	#gestion  heure minute carnet
	@bon_lancement.heure_machine=pres_val(@bon_lancement.heure_machine,"Heure de vol")
  end

  # POST /bon_lancements
  # POST /bon_lancements.json
  def create
	  params[:bon_lancement][:heure_machine]=to_mn(params[:bon_lancement][:heure_machine])
	@bon_lancement = BonLancement.new((params[:bon_lancement].permit(:numero,:date_lancement,:id_machine,:autre_travaux,:piece_chgt,:heure_machine,:heure_moteur,:cycle,:id_re,:id_rn,:id_re_decou,:id_rn_decou,:trav_prog,:trav_decou,:date_decou,:date_exec,:date_fin_trav,:date_exec_decou,piece_changee_attributes: [:nom,:id,:_destroy,:easa_form1_ref]))
)
	#on corrige les heures minutes
	
    respond_to do |format|
      if @bon_lancement.save
        format.html {
			#on crée les visites lancées
			if (!params["vis_prot"].nil?) then
				params["vis_prot"].each do |vis_prot|
					if(vis_prot[1].include? "yes") then
							#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
							lance=TypeVisiteLance.new()
							lance.bon_lancement_id=@bon_lancement.id
							#reference de la visite protocolaire  lancée
							lance.type_visite_lance_id=vis_prot[0]
							#potentiel de lancement corrigé si heure de vol
							lance.val_pot_lancement=conv_param(params["vis_pot"][vis_prot[0]],lance.visite_protocolaire.type_potentiel.type_potentiel)
							lance.save
					end
				end
			end
			
			#on crée les applications de CN lancées
			if (!params["cn_ex"].nil?) then
				params["cn_ex"].each do |cn_ex|
					if(cn_ex[1].include? "yes") then
							#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
							lance=TypeCnLance.new()
							lance.bon_lancement_id=@bon_lancement.id
							lance.type_cn_lance_id=cn_ex[0]
							lance.val_pot_lancement=conv_param(params["vis_pot_cn"][cn_ex[0]],lance.cn_machine.type_potentiel.type_potentiel)
							lance.save
					end
				end
			end
			#création visite équipement
			if (!params["vis_equi"].nil?) then
				params["vis_equi"].each do |vis_eq|
					vis_eq[1].each do |vis_prot|
						if(vis_prot[1].include? "yes") then
								#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
								lance=TypeVisiteEquipementLance.new()
								lance.id_equipement=vis_prot[0]
								lance.bon_lancement_id=@bon_lancement.id
								lance.type_visite_equipement_lance_id=vis_eq[0]
								lance.val_pot_lancement=conv_param(params["vis_pot_equi"][vis_eq[0]][vis_prot[0]],lance.visite_protocolaire_equipement.type_potentiel.type_potentiel)
								lance.save
						end
					end
				end
			end
			#création application CN équipement
			if (!params["cn_ex_eq"].nil?) then
				params["cn_ex_eq"].each do |cn_eq|
				#pour chaque cn boucle sur les eéquipements concernés
					cn_eq[1].each do|vis_prot|
						#boucle par equipement
						if(vis_prot[1].include? "yes") then
							#la case est coché donc 2 solutions
							if(vis_prot[1]== "yes") then
								#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
								lance=TypeCnEquipementLance.new()
								lance.bon_lancement_id=@bon_lancement.id
								lance.type_cn_equipement_lance_id=cn_eq[0]
								lance.val_pot_lancement=conv_param(params["vis_pot_cn_eq"][cn_eq[0]][vis_prot[0]],lance.cn_equipement.type_potentiel.type_potentiel)
								lance.id_equipement=vis_prot[0]
								lance.save
							end
						end
					end
				end
			end
			redirect_to @bon_lancement, notice: 'le Bon de lancement a été créé.' 
			}
        format.json { render action: 'show', status: :created, location: @bon_lancement }
      else
        format.html { render action: 'new' }
        format.json { render json: @bon_lancement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bon_lancements/1
  # PATCH/PUT /bon_lancements/1.json
  def update
    respond_to do |format|
	    #première chose à vérifier est ce que la machine à changer 
	    if(@bon_lancement.id_machine!=bon_lancement_params[:id_machine].to_i) then 
		      #si oui on détruit les lancements de visites de CN etc ....
		    TypeVisiteLance.destroy_all(:bon_lancement_id=>@bon_lancement.id)
		    TypeCnLance.destroy_all(:bon_lancement_id=>@bon_lancement.id)
		end
	  params[:bon_lancement][:heure_machine]= to_mn(params[:bon_lancement][:heure_machine])

      if @bon_lancement.update(params[:bon_lancement].permit(:numero,:date_lancement,:id_machine,:autre_travaux,:piece_chgt,:heure_machine,:heure_moteur,:cycle,:id_re,:id_rn,:id_re_decou,:id_rn_decou,:trav_prog,:trav_decou,:date_decou,:date_exec,:date_fin_trav,:date_exec_decou,piece_changee_attributes: [:nom,:id,:_destroy,:easa_form1_ref]))
        format.html {
		#sauvegarde des visites cochées
		if (!params["vis_prot"].nil?) then
			params["vis_prot"].each do |vis_prot|
				if(vis_prot[1].include? "yes") then
					#la case est coché donc 2 solutions
					if(vis_prot[1]== "yes") then
						#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
						lance=TypeVisiteLance.new()
						
					else
						#la visite était déjà lancée on update 
						#on récupère le numéro de l'enregistrement
						id_vis=vis_prot[1][3..vis_prot[1].length]
						#on met à jour
						lance=TypeVisiteLance.find(id_vis)
					end
					lance.bon_lancement_id=@bon_lancement.id
					lance.type_visite_lance_id=vis_prot[0]
					
					lance.val_pot_lancement=conv_param(params["vis_pot"][vis_prot[0]],lance.visite_protocolaire.type_potentiel.type_potentiel)
					lance.save
				else 
					#on est dans le cas d'un no 
					#2 cas possible soit la viste n'existe pas et on fait rien soit elle existe et on supprime
					if(vis_prot[1]!= "no") then
						#on récupère le numéro
						id_vis=vis_prot[1][2..vis_prot[1].length]
						lance=TypeVisiteLance.find(id_vis)
						#on détruit
						lance.destroy
					end
				end
			end
		end
		
		#idem en matière de CN machine
		if(!params["cn_ex"].nil?) then
			params["cn_ex"].each do |vis_prot|
				if(vis_prot[1].include? "yes") then
					#la case est coché donc 2 solutions
					if(vis_prot[1]== "yes") then
						#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
						lance=TypeCnLance.new()
					else
						#la visite était déjà lancée on update 
						#on récupère le numéro de l'enregistrement
						id_vis=vis_prot[1][3..vis_prot[1].length]
						#on met à jour
						lance=TypeCnLance.find(id_vis)
					end
					lance.bon_lancement_id=@bon_lancement.id
					lance.type_cn_lance_id=vis_prot[0]
					lance.val_pot_lancement=conv_param(params["vis_pot_cn"][vis_prot[0]],lance.cn_machine.type_potentiel.type_potentiel)
					lance.save
				else 
					#on est dans le cas d'un no 
					#2 cas possible soit la viste n'existe pas et on fait rien soit elle existe et on supprime
					if(vis_prot[1]!= "no") then
						#on récupère le numéro
						id_vis=vis_prot[1][2..vis_prot[1].length]
						lance=TypeCnLance.find(id_vis)
						#on détruit
						lance.destroy
					end
				end
			end
		end
		#on met en place les vistes équipement
		if (!params["vis_equi"].nil?) then
			params["vis_equi"].each do |vis_eq|
				#pour chaque cn boucle sur les eéquipements concernés
				vis_eq[1].each do|vis_prot|
					#boucle par equipement
					if(vis_prot[1].include? "yes") then
						#la case est coché donc 2 solutions
						if(vis_prot[1]== "yes") then
							#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
							lance=TypeVisiteEquipementLance.new()
						else
							#la visite était déjà lancée on update 
							#on récupère le numéro de l'enregistrement
							id_vis=vis_prot[1][3..vis_prot[1].length]
							#on met à jour
							lance=TypeVisiteEquipementLance.find(id_vis)
						end
						lance.bon_lancement_id=@bon_lancement.id
						lance.type_visite_equipement_lance_id=vis_eq[0]
						lance.val_pot_lancement=conv_param(params["vis_pot_equi"][vis_eq[0]][vis_prot[0]],lance.visite_protocolaire_equipement.type_potentiel.type_potentiel)
						lance.id_equipement=vis_prot[0]
						lance.save
					else 
						#on est dans le cas d'un no 
						#2 cas possible soit la viste n'existe pas et on fait rien soit elle existe et on supprime
						if(vis_prot[1]!= "no") then
							#on récupère le numéro
							id_vis=vis_prot[1][2..vis_prot[1].length]
							lance=TypeVisiteEquipementLance.find(id_vis)
							#on détruit
							lance.destroy
						end
					end
				end
			end
		end
		if(!params["cn_ex_eq"].nil?) then
			params["cn_ex_eq"].each do |cn_eq|
				#pour chaque cn boucle sur les eéquipements concernés
				cn_eq[1].each do|vis_prot|
					#boucle par equipement
					if(vis_prot[1].include? "yes") then
						#la case est coché donc 2 solutions
						if(vis_prot[1]== "yes") then
							#la visite n'était pas lancée précedement donc on créé un nouvel enregistrement
							lance=TypeCnEquipementLance.new()
						else
							#la visite était déjà lancée on update 
							#on récupère le numéro de l'enregistrement
							id_vis=vis_prot[1][3..vis_prot[1].length]
							#on met à jour
							lance=TypeCnEquipementLance.find(id_vis)
						end
						lance.bon_lancement_id=@bon_lancement.id
						lance.type_cn_equipement_lance_id=cn_eq[0]
						lance.val_pot_lancement=conv_param(params["vis_pot_cn_eq"][cn_eq[0]][vis_prot[0]],lance.cn_equipement.type_potentiel.type_potentiel)
						lance.id_equipement=vis_prot[0]
						lance.save
					else 
						#on est dans le cas d'un no 
						#2 cas possible soit la viste n'existe pas et on fait rien soit elle existe et on supprime
						if(vis_prot[1]!= "no") then
							#on récupère le numéro
							id_vis=vis_prot[1][2..vis_prot[1].length]
							lance=TypeCnEquipementLance.find(id_vis)
							#on détruit
							lance.destroy
						end
					end
				end
			end
		end
		redirect_to @bon_lancement, notice: 'le Bon de lancement a été mis à jour.'
	}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bon_lancement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bon_lancements/1
  # DELETE /bon_lancements/1.json
  def destroy
    @bon_lancement.destroy
    respond_to do |format|
      format.html { redirect_to bon_lancements_url }
      format.json { head :no_content }
    end
  end
def get_type_visite
	if (params[:id_bl]=="0") then
		@bon_lancement = BonLancement.new
		@carnet=Carnet.liste_machine_carnet(params[:id_machine])
		@bon_lancement.heure_machine=pres_val(@carnet["heure_de_vol"],"Heure de vol")
		@bon_lancement.heure_moteur=@carnet["heure_moteur"]
		@bon_lancement.cycle=@carnet["nombre_cycle"]
	else
		@bon_lancement =BonLancement.find(params[:id_bl])
	end
	@vis_prots=VisiteMachine.dernieres_visites(params[:id_machine])
	@cn_machine=ExecCnMachine.etat_cn(params[:id_machine])
	@visites_equipement=VisiteEquipement.dernieres_visites(params[:id_machine])
	@visites_equipement=@visites_equipement.sort_by {|visite_equipement| [visite_equipement[1]["moteur_helice"],visite_equipement[1]["equipement_type"],visite_equipement[1]["id_equipement"]]}
	@cn_equipement_machine=ExecCnEquipement.etat_cn(params[:id_machine])
	@cn_equipement_machine=@cn_equipement_machine.sort_by{|cn_equipement| [cn_equipement[1]["moteur_helice"],cn_equipement[1]["equipement_type"],cn_equipement[1]["id_equipement"]] }
		
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bon_lancement
      @bon_lancement = BonLancement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bon_lancement_params
	
      params[:bon_lancement].permit(:numero,:date_lancement,:id_machine,:autre_travaux,:piece_chgt,:heure_machine,:heure_moteur,:cycle,:id_re,:id_rn,:id_re_decou,:id_rn_decou,:trav_prog,:trav_decou,:date_decou,:date_exec,:date_fin_trav,:date_exec_decou,piece_changee_attributes: [:nom,:id,:_destroy,:easa_form1_ref])
    end
    #convertion des valeurs en fonction du potentiel de saisie
    def conv_param(val,pot)
	if (pot=="Heure de vol") then 
		conv_param=to_mn(val)
	elsif (pot=="Calendaire")
		conv_param=to_std_date(val)
	else 
		conv_param=val
	end
    end
end
