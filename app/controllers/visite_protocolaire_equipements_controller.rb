class VisiteProtocolaireEquipementsController < ApplicationController
	 include ApplicationHelper
   before_action :page_def
  before_action :set_visite_protocolaire_equipement, only: [:show, :edit, :update, :destroy]
 before_action :page_acc 
  # GET /visite_protocolaire_equipements
  # GET /visite_protocolaire_equipements.json
  def index
    @visite_protocolaire_equipements = VisiteProtocolaireEquipement.all
     @visite_protocolaire_equipements =@visite_protocolaire_equipements.sort_by {|visite| [visite.type_equipement.nom_constructeur,visite.type_equipement.type_equipement ]}

  end

  # GET /visite_protocolaire_equipements/1
  # GET /visite_protocolaire_equipements/1.json
  def show
    @carte_travail=DocDiver.where("type_doc_id=10 and id_entite=?",params[:id])
  end

  # GET /visite_protocolaire_equipements/new
  def new
    @visite_protocolaire_equipement = VisiteProtocolaireEquipement.new
  end

  # GET /visite_protocolaire_equipements/1/edit
  def edit
	#calcul présentation heure minute
	@visite_protocolaire_equipement.valeur_potentiel=get_pot(@visite_protocolaire_equipement.valeur_potentiel,@visite_protocolaire_equipement.type_potentiel.type_potentiel)
	@visite_protocolaire_equipement.tolerance=get_pot(@visite_protocolaire_equipement.tolerance,@visite_protocolaire_equipement.type_potentiel.type_potentiel)
  #gestion des programme de visite
	@Carte_travail_docs=DocDiver.where("type_doc_id=9 and id_entite=?",params[:id])
	@doc_diver=DocDiver.new
	#doc = mm par défaut
	@doc_diver.type_doc_id=10
	@doc_diver.id_entite=@visite_protocolaire_equipement.id
  
  end

  # POST /visite_protocolaire_equipements
  # POST /visite_protocolaire_equipements.json
  def create
    @visite_protocolaire_equipement = VisiteProtocolaireEquipement.new(visite_protocolaire_equipement_params.permit(:idtype_potentiel,:valeur_potentiel,:idtype_equipement,:Nom,:tolerance,:commentaire,:gv,:va,:carte))
	if (@visite_protocolaire_equipement.type_potentiel.type_potentiel=="Heure de vol") then 
		@visite_protocolaire_equipement.valeur_potentiel=to_mn(visite_protocolaire_equipement_params["valeur_potentiel"]) 
		@visite_protocolaire_equipement.tolerance=to_mn(visite_protocolaire_equipement_params["tolerance"]) 
	end
    respond_to do |format|
      if @visite_protocolaire_equipement.save
        format.html { redirect_to @visite_protocolaire_equipement, notice: 'la Visite protocolaire équipement a été créé.' }
        format.json { render action: 'show', status: :created, location: @visite_protocolaire_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @visite_protocolaire_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visite_protocolaire_equipements/1
  # PATCH/PUT /visite_protocolaire_equipements/1.json
  def update
	@test=visite_protocolaire_equipement_params.permit(:idtype_potentiel,:valeur_potentiel,:idtype_machine,:Nom,:tolerance,:potentiel_variable,:commentaire,:gv,:va,:carte)
	if (@test[:idtype_potentiel]=="3") then 
		@test["valeur_potentiel"]=to_mn(visite_protocolaire_equipement_params["valeur_potentiel"]) 
		@test["tolerance"]=to_mn(visite_protocolaire_equipement_params["tolerance"]) 
	end
    respond_to do |format|
      if @visite_protocolaire_equipement.update(@test)
        format.html { redirect_to @visite_protocolaire_equipement, notice: 'la Visite protocolaire équipement a été mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visite_protocolaire_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visite_protocolaire_equipements/1
  # DELETE /visite_protocolaire_equipements/1.json
  def destroy
    @visite_protocolaire_equipement.destroy
    respond_to do |format|
      format.html { redirect_to visite_protocolaire_equipements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visite_protocolaire_equipement
      @visite_protocolaire_equipement = VisiteProtocolaireEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visite_protocolaire_equipement_params
      params[:visite_protocolaire_equipement]
    end
end
