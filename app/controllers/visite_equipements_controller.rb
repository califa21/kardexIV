class VisiteEquipementsController < ApplicationController
	include ApplicationHelper
	 before_action :page_def
	before_action :set_visite_equipement, only: [:show, :edit, :update, :destroy]
	before_action :page_acc 
	helper_method :val_pot
	protect_from_forgery  except: [:get_type_visite, :get_visite_equ]
  # GET /visite_equipements
  # GET /visite_equipements.json
  def index
    @visite_equipements = VisiteEquipement.includes(:equipement => :type_equipement).order("type_equipements.nom_constructeur,type_equipements.type_equipement,equipements.num_serie,id_visite_protocolaire_equipement desc")
     end

  # GET /visite_equipements/1
  # GET /visite_equipements/1.json
  def show
  end

  # GET /visite_equipements/new
  def new
	@date_1=Date.today.strftime('%d/%m/%Y')
	@visite_equipement = VisiteEquipement.new
	 if !(params[:id_equipement].nil?) then 
		@visite_equipement.idequipement=params[:id_equipement].to_i
	end
	@unite=" "
	if !(params[:id_visite_pro].nil?) then 
		@visite_equipement.id_visite_protocolaire_equipement=params[:id_visite_pro]
		#recup type de protentiel lié à la visite 
		@visite_prot=VisiteProtocolaireEquipement.find(params[:id_visite_pro])
		@unite=@visite_prot.type_potentiel.unitee_saisie
		@visite_induites=@visite_prot.maitre
	end
	if (!params[:id_visite_pro].nil? and !params[:id_equipement].nil? and @unite!="date") then
		@visite_equipement.val_potentiel=val_pot(params[:id_equipement],@visite_prot.type_potentiel.type_potentiel)
	end
	if !(@visite_equipement.visite_protocolaire_equipement.nil?) then
		@carn=(@visite_equipement.visite_protocolaire_equipement.va or @visite_equipement.visite_protocolaire_equipement.gv)
	else
		@carn=false
	end
		
	if @carn then
		#equip=Equipement.find(params[:id_equipement])
		mont= EstMonteSur.where("date_retrait is null and idequipement=?",params[:id_equipement])
		#on récupére le carnet
		releve=Carnet.liste_machine_carnet(mont[0].idmachine)
		@visite_equipement.fait_a_heure_moteur=releve["heure_moteur"]
		
	end
	#on récupère les visites induites
	
  end

  # GET /visite_equipements/1/edit
  def edit
	@date_1=@visite_equipement.date_visite.strftime('%d/%m/%Y')
	@visite_prot=@visite_equipement.visite_protocolaire_equipement
	if !(params[:id_equipement].nil?) then 
		@visite_equipement.idequipement=params[:id_equipement]
	end
	@unite=" "
	if !(params[:id_visite_pro].nil?) then 
		@visite_equipement.id_visite_protocolaire_equipement=params[:id_visite_pro]
		#recup type de protentiel lié à la visite 
		@visite_prot=VisiteProtocolaireEquipement.find(params[:id_visite_pro])
		@unite=@visite_prot.type_potentiel.unitee_saisie
	end
	#si les deux sont définis on récupère la valeur du carnet
	#sinon potentiel = 0
	@visite_equipement.val_potentiel=pres_val(@visite_equipement.val_potentiel,@visite_prot.type_potentiel.type_potentiel)
	if (!params[:id_visite_pro].nil? and !params[:id_equipement].nil? and @unite!="date") then
		@visite_equipement.val_potentiel=val_pot(params[:id_equipement],@visite_prot.type_potentiel.type_potentiel)
	end
	
	 if !(@visite_prot.nil?) then
		@carn=(@visite_prot.va or @visite_prot.gv)
	else
		@carn=false
	end
  end

  # POST /visite_equipements
  # POST /visite_equipements.json
  def create
    @visite_equipement = VisiteEquipement.new(visite_equipement_params.permit(:idequipement,:date_visite,:idtype_potentiel,:val_potentiel,:id_visite_protocolaire_equipement,:nom,:commentaire,:fait_a_heure_moteur))
    if (@visite_equipement.visite_protocolaire_equipement.type_potentiel.type_potentiel=="Heure de vol") then 
		@visite_equipement.val_potentiel=to_mn(visite_equipement_params["val_potentiel"]) 
	end
    respond_to do |format|
      if @visite_equipement.save
	#on passe aux visites induites
	#on récupére toutes les visites induites
	@visite_induites=@visite_equipement.visite_protocolaire_equipement.maitre
	val_pot=params[:induite]
       #pour chaque visites induites
       @visite_induites.each  do |induite|
	       #on initailise une visite equipement avec les paramètres de la visite maitre
		@vis_equ_ind=VisiteEquipement.new(visite_equipement_params.permit(:idequipement,:date_visite,:idtype_potentiel,:val_potentiel,:id_visite_protocolaire_equipement,:nom,:commentaire,:fait_a_heure_moteur) )
		#on modifie les valeurs ad hoc
		@vis_equ_ind.id_visite_protocolaire_equipement=induite.induite.id
		@vis_equ_ind.idtype_potentiel=induite.induite.type_potentiel.id
		@vis_equ_ind.val_potentiel=val_pot[induite.induite.id.to_s]["pot_montage"]
		if (@vis_equ_ind.visite_protocolaire_equipement.type_potentiel.type_potentiel=="Heure de vol") then 
				@vis_equ_ind.val_potentiel=to_mn(val_pot[induite.induite.id.to_s]["pot_montage"]) 
			end
		#et pis on sauvegarde
		@vis_equ_ind.save
       end
	       
        format.html {if (params[:retour].nil?) then 
		redirect_to(@visite_equipement, :notice => 'visite équipement créée.')
	else
		#renvoi vers la page détails machine
		redirect_to url_for(:controller => 'machines',:action=>"show", :id => params[:retour],:onglet =>1), :notice => 'visite équipement créée.'
	end
	 }
        format.json { render action: 'show', status: :created, location: @visite_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @visite_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visite_equipements/1
  # PATCH/PUT /visite_equipements/1.json
  def update
    respond_to do |format|
	if (@visite_equipement.visite_protocolaire_equipement.type_potentiel.type_potentiel=="Heure de vol") then 
		visite_equipement_params["val_potentiel"]=to_mn(visite_equipement_params["val_potentiel"]) 
	end
      if @visite_equipement.update(visite_equipement_params.permit(:idequipement,:date_visite,:idtype_potentiel,:val_potentiel,:id_visite_protocolaire_equipement,:nom,:commentaire,:fait_a_heure_moteur))
        format.html { redirect_to @visite_equipement, notice: "La visite d'équipement a été correctement mis à jour." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visite_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visite_equipements/1
  # DELETE /visite_equipements/1.json
  def destroy
    @visite_equipement.destroy
    respond_to do |format|
      format.html { redirect_to visite_equipements_url }
      format.json { head :no_content }
    end
  end
  
  def get_type_visite
	  #remet à jour la division "Unité" donc on calcule
	  @visite_equipement=VisiteEquipement.new
	  @visite_prot=VisiteProtocolaireEquipement.find(params[:id_visite_protocolaire])
	  @unite=@visite_prot.type_potentiel.unitee_saisie
	  @visite_equipement.val_potentiel=val_pot(params[:id_equipement],@visite_prot.type_potentiel.type_potentiel)
	  @visite_induites=@visite_prot.maitre
	  if !(@visite_prot.nil?) then
		@carn=(@visite_prot.va or @visite_prot.gv)
	else
		@carn=false
	end
		
	if @carn then
		#equip=Equipement.find(params[:id_equipement])
		mont= EstMonteSur.where("date_retrait is null and idequipement=?",params[:id_equipement])
		#on récupére le carnet
		releve=Carnet.liste_machine_carnet(mont[0].idmachine)
		@visite_equipement.fait_a_heure_moteur=pres_val(releve["heure_moteur"],"Heure de vol")
		@visite_equipement.fait_cycle=releve["nombre_cycle"]
	end
	respond_to do |format|
		format.js 
	end
  end
  
  
  def get_visite_equ
	@equipement=Equipement.find(params[:id_equipement])
	@vpes=VisiteProtocolaireEquipement.where('idtype_equipement = ? ',@equipement.type_equipement.id)
	
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visite_equipement
      @visite_equipement = VisiteEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visite_equipement_params
      params[:visite_equipement]
    end
    def val_pot(id_equipement,type_pot)
		#on récupére la machine 
		equip=Equipement.find(id_equipement)
		mont= EstMonteSur.where("date_retrait is null and idequipement=?",params[:id_equipement])
		#on récupére le carnet
		releve=Carnet.liste_machine_carnet(mont[0].idmachine)
		#on récupère la valeur
		case type_pot
			when "Calendaire"
				val_potentiel=0
			when "utilisation moteur"
				val_potentiel=releve["heure_moteur"]
			when "Heure de vol" 
			#on modifie pour coller Heure/minute
				potin=(releve["heure_de_vol"]/60).to_i
				val_potentiel=get_pot=potin.to_s+":"+sprintf('%02.0f',releve["heure_de_vol"]-(60*potin))
			when "Nb cycles" 
				val_potentiel=releve["nombre_cycle"]
			else
				val_potentiel=0
		end
		@val_pot=val_potentiel
    end
    
end
