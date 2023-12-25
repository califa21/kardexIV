class EstMonteSursController < ApplicationController
	include ApplicationHelper
    before_action :page_def
  before_action :set_est_monte_sur, only: [:show, :edit, :update, :destroy]
 before_action :page_acc
 protect_from_forgery  except: :val_pot
  # GET /est_monte_surs
  # GET /est_monte_surs.json
  def index
    @montage_equipements =  EstMonteSur.joins(:machine => :type_machine,:equipement => :type_equipement).order("type_machines.type_machine","machines.Immatriculation","type_equipements.nom_constructeur","type_equipements.type_equipement")
    #@montage_equipements=@montage_equipements.sort_by{|montage|  [montage.machine.type_machine.type_machine,montage.machine.Immatriculation]}
  end

  # GET /est_monte_surs/1
  # GET /est_monte_surs/1.json
  def show
	@vis_equip= VisiteEquipement.where(["idequipement=? and nom=?",@montage_equipement.idequipement,"visite montage"])
  end

  # GET /est_monte_surs/new
  def new
   @est_monte_sur = EstMonteSur.new

  end

  # GET /est_monte_surs/1/edit
  def edit
	#on initialise
	@couple=Hash.new()
	#on récupère le montage en cause 
	@est_monte_sur  = EstMonteSur.find(params[:id])
	@date_1=@est_monte_sur.date_montage.strftime('%d/%m/%Y')
	if @est_monte_sur.date_retrait.nil? then  @date_2="" else @est_monte_sur.date_retrait.strftime('%d/%m/%Y') end
	#on récupère les éléments de potentiels 
	@elt_pot=@est_monte_sur.potentiel_montage
	#on récupère les éléments liée aux visites protocolaires
	@couple[:idmachine]=@est_monte_sur.idmachine
	@couple[:idequipement]=@est_monte_sur.idequipement
	set_pot(@couple)
	 
  end

  # POST /est_monte_surs
  # POST /est_monte_surs.json
  def create
    @est_monte_sur = EstMonteSur.new(est_monte_sur_params)
    @pots=params[:pot]
    #raise @pots.inspect
    @prot=params[:potentiel_montage_vis]
    respond_to do |format|
      if @est_monte_sur.save
	      #on crée les potentiels au montages
	       j=0
		if !@pots.nil? then
			@pots.each do |pot|
				@res=PotentielMontage.new()
				@res.idest_monte_sur = @est_monte_sur[:id]
				@res.idpotentiel_equipement = pot[1][:id_pot]
				@res.idtype_potentiel=pot[1][:idtype_potentiel]
				#présent #on corrige si heure minute
				if (@res.idtype_potentiel)==3 then 
					@res.valeur_potentiel_montage=to_mn(pot[1][:valeur_potentiel_montage])
					@res.valeur_machine_jour_montage= to_mn( pot[1][:valeur_machine_jour_montage])
				else
					@res.valeur_potentiel_montage=pot[1][:valeur_potentiel_montage]
					@res.valeur_machine_jour_montage=  pot[1][:valeur_machine_jour_montage]
				end
				
				@res.save
				j=j+1
			end
		end
		#on crée des visites protocolaires bidon pour démarrer les potentiels
		if !@prot.nil?
			#on récupère toutes visites protocolaires
			@equipement=Equipement.find(@est_monte_sur[:idequipement])
			#on crée une visite bidon par visites protocolaires
			@vis_pro=@equipement.type_equipement.visite_protocolaire_equipement
			@vis_pro.each do |vi_pro|
				#on cree une visite
				@vis_equip=VisiteEquipement.new
				@vis_equip.idequipement=@est_monte_sur[:idequipement]
				@vis_equip.date_visite=@est_monte_sur.date_montage
				@vis_equip.idtype_potentiel=vi_pro.idtype_potentiel
				#valeur de réalisation
				@val=@prot[vi_pro.idtype_potentiel.to_s]
				if (vi_pro.idtype_potentiel==3 ) then
					@vis_equip.val_potentiel=to_mn(@val[:valeur_machine_jour_montage])
				else
					@vis_equip.val_potentiel=@val[:valeur_machine_jour_montage]
				end
				@vis_equip.id_visite_protocolaire_equipement=vi_pro.id
				@vis_equip.nom="visite montage"
				#on corrige si hm
				@vis_equip.save
			end
			
		end
        format.html { redirect_to @est_monte_sur, notice: 'Est monte sur was successfully created.' }
        format.json { render action: 'show', status: :created, location: @est_monte_sur }
      else
        format.html { render action: 'new' }
        format.json { render json: @est_monte_sur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /est_monte_surs/1
  # PATCH/PUT /est_monte_surs/1.json
  def update
    respond_to do |format|
      if  @montage_equipement.update(est_monte_sur_params)
	      #manque la mise à jour des potentiels
	      @pots=params[:pot]
		if !@pots.nil? then
			@pots.each do |pot|
				#on charge le potentiel montage
				@res=PotentielMontage.find(pot[0])
				#@res.idest_monte_sur = @est_monte_sur[:id]
				#@res.idpotentiel_equipement = pot[1][:id_pot]
				#présent 
				if (pot[1][:valeur_machine_jour_montage].empty?) then pot[1][:valeur_machine_jour_montage]=0 end
				@res.valeur_potentiel_montage=pot[1][:valeur_potentiel_montage]
				@res.valeur_machine_jour_montage= pot[1][:valeur_machine_jour_montage]
				#pas dispo 
				#@res.idtype_potentiel=pot[1][:idtype_potentiel]
				@res.update(valeur_potentiel_montage: pot[1][:valeur_potentiel_montage],valeur_machine_jour_montage: pot[1][:valeur_machine_jour_montage])
			end
		end
	format.html { redirect_to  @montage_equipement, notice: 'Montage correctement mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @est_monte_sur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /est_monte_surs/1
  # DELETE /est_monte_surs/1.json
  def destroy
     @montage_equipement.destroy
    respond_to do |format|
      format.html { redirect_to est_monte_surs_url }
      format.json { head :no_content }
    end
  end
  def val_pot
	@couple=Hash.new()
	@elt_pot=Array.new()
	#on récupère entrée l'id machine et l'id équipement 
	  #on regarde s'il existe un montage correspondant 
	@est_monte_sur = EstMonteSur.where("date_retrait is null and idequipement = ? and idmachine = ? " ,  params[:equip_id] , params[:mach_id]).first
	if (@est_monte_sur.nil?) then 
		releve=Carnet.liste_machine_carnet(params[:mach_id])
		#si non on récupére  pour l'équipement les potentiels
		equipement=Equipement.find( params[:equip_id])
		potentiel_equi=equipement.type_equipement.potentiel_equipement
		i=0
		#on enregsitre le potentiel moteur si l'équipement est une hélice ou un moteur pour la gestion des bons de lancement
		@pot_moteur=false
		potentiel_equi.each do |po_equi|
			potentiel=PotentielMontage.new()
			potentiel.potentiel_equipement=PotentielEquipement.new()
			potentiel.idpotentiel_equipement=po_equi.id
			potentiel.idtype_potentiel=po_equi.type_potentiel.id
			potentiel.valeur_potentiel_montage=po_equi.valeur_potentiel
			if po_equi.type_potentiel.type_potentiel=="Calendaire" then 
				potentiel.valeur_machine_jour_montage=0
			elsif po_equi.type_potentiel.type_potentiel=="utilisation moteur" then
				potentiel.valeur_machine_jour_montage=releve["heure_moteur"]
				#si on enrgistre le potentiel moteur 
				@pot_moteur=true
			elsif po_equi.type_potentiel.type_potentiel=="Heure de vol" then 
				potentiel.valeur_machine_jour_montage=pres_val(releve["heure_de_vol"],"Heure de vol")
			elsif po_equi.type_potentiel.type_potentiel=="Nb cycles" then
				potentiel.valeur_machine_jour_montage=releve["nombre_cycle"]
			else
				potentiel.valeur_machine_jour_montage=0
			end
			potentiel.id=i
			i=i+1
			@elt_pot.push(potentiel)
		end
		#on traite le cas moteur ou hélice sans potentiel mais pour suivre la durée de vie
		if (!@pot_moteur & (equipement.type_equipement.moteur || equipement.type_equipement.helice)) then
			potentiel=PotentielMontage.new()
			#on enregistre le potentiel moteur
			potentiel.idtype_potentiel=4
			potentiel.valeur_potentiel_montage=0
			potentiel.valeur_machine_jour_montage=releve["heure_moteur"]
			#juste pour numéroter
			potentiel.id=i
			i=i+1
			@elt_pot.push(potentiel)
		end
		#2) les potentiels du type d'équipement
		@couple[:idmachine]= params[:mach_id]
		@couple[:idequipement]= params[:equip_id]
		set_pot(@couple)
	 else
		@elt_pot=@est_monte_sur.potentiel_montage
		#on récupère les éléments liée aux visites protocolaires
		@couple[:idmachine]=@est_monte_sur.idmachine
		@couple[:idequipement]=@est_monte_sur.idequipement
		set_pot(@couple)
	end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_est_monte_sur
      @montage_equipement = EstMonteSur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def est_monte_sur_params
      params[:est_monte_sur].permit(:idequipement,:idmachine,:date_montage,:date_retrait)
    end
    def set_pot(id_montage_equi)
     @param=id_montage_equi
	 if (@param[:idmachine]!="" and @param[:idequipement]!="" and @param[:idmachine]!="0" and @param[:idequipement]!="0" ) then 
		 @ok=true
		 @releve=Carnet.liste_machine_carnet(@param[:idmachine])
		 #initialisation
		 @tot=Hash.new
		 j=0
		 #on identifie les potentiels à récup
		 @equipement=Equipement.find(@param[:idequipement])
		 #on récupère les types de potentiels equipement
		 @pots=@equipement.type_equipement.potentiel_equipement
		 #il faut aussi récupérer les types de potentiels des visites protocoliare de cetype d'équipement
		@vis_prot=@equipement.type_equipement.visite_protocolaire_equipement
		@vis_prot.each do |pot|
			@A_faire=Hash.new
			 @A_faire["typ_pot"]=pot.type_potentiel.type_potentiel
			 if (pot.type_potentiel.type_potentiel=="Calendaire") then @val=0
			elsif (pot.type_potentiel.type_potentiel=="Nb cycles") then @val=@releve["nombre_cycle"].to_s
			elsif (pot.type_potentiel.type_potentiel=="Heure de vol") then @val=@releve["heure_de_vol"].to_s
			else @val= @releve["heure_moteur"].to_s
			end
			@A_faire["valeur_carnet_montage"]= @val
			@A_faire["id_pot"]=pot.type_potentiel.id
			 @tot[pot.type_potentiel.id]=@A_faire
			 j=j+1
		  end
		 #on récupère les valeurs du dernier relevé
		 @releve=Carnet.liste_machine_carnet(@param[:idmachine])
		 @potos=params[:potentiel_montage]
	else
		@ok=false
	end
end
end
