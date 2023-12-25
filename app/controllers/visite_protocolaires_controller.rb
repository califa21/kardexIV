class VisiteProtocolairesController < ApplicationController
	 include ApplicationHelper
   before_action :page_def
  before_action :set_visite_protocolaire, only: [:show, :edit, :update, :destroy]
  before_action :page_acc 

  # GET /visite_protocolaires
  # GET /visite_protocolaires.json
  def index
   @visite_protocolaires = VisiteProtocolaire.all.includes(:type_potentiel,:type_machine)
    @visite_protocolaires=@visite_protocolaires.sort_by {|visite_protocolaire| [visite_protocolaire.type_machine.Nom_constructeur,visite_protocolaire.type_machine.type_machine]}
  end

  # GET /visite_protocolaires/1
  # GET /visite_protocolaires/1.json
  def show
	  @carte_travail=DocDiver.where("type_doc_id=9 and id_entite=?",params[:id])
  end

  # GET /visite_protocolaires/new
  def new
    @visite_protocolaire = VisiteProtocolaire.new
  end

  # GET /visite_protocolaires/1/edit
  def edit
	#calcul pr�sentation heure minute
	@visite_protocolaire.valeur_potentiel=get_pot(@visite_protocolaire.valeur_potentiel,@visite_protocolaire.type_potentiel.type_potentiel)
	@visite_protocolaire.tolerance=get_pot(@visite_protocolaire.tolerance,@visite_protocolaire.type_potentiel.type_potentiel)
	#gestion des programme de visite
	@Carte_travail_docs=DocDiver.where("type_doc_id=9 and id_entite=?",params[:id])
	@doc_diver=DocDiver.new
	#doc = mm par défaut
	@doc_diver.type_doc_id=9
	@doc_diver.id_entite=@visite_protocolaire.id

  end

  # POST /visite_protocolaires
  # POST /visite_protocolaires.json
  def create
    @visite_protocolaire = VisiteProtocolaire.new(visite_protocolaire_params)
	if (@visite_protocolaire.type_potentiel.type_potentiel=="Heure de vol") then 
		@visite_protocolaire.valeur_potentiel=to_mn(visite_protocolaire_params["valeur_potentiel"]) 
		@visite_protocolaire.tolerance=to_mn(visite_protocolaire_params["tolerance"]) 
	end
    respond_to do |format|
      if @visite_protocolaire.save
        format.html { redirect_to @visite_protocolaire, notice: 'Visite protocolaire créée.' }
        format.json { render action: 'show', status: :created, location: @visite_protocolaire }
      else
        format.html { render action: 'new' }
        format.json { render json: @visite_protocolaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visite_protocolaires/1
  # PATCH/PUT /visite_protocolaires/1.json
  def update
	@test=visite_protocolaire_params.permit(:idtype_potentiel,:valeur_potentiel,:idtype_machine,:Nom,:tolerance,:potentiel_variable,:commentaire,:gv,:va,:carte)
	if (@test[:idtype_potentiel]=="3") then 
		@test["valeur_potentiel"]=to_mn(visite_protocolaire_params["valeur_potentiel"]) 
		@test["tolerance"]=to_mn(visite_protocolaire_params["tolerance"]) 
	end
    respond_to do |format|
      if @visite_protocolaire.update(@test)
        format.html { redirect_to @visite_protocolaire, notice: 'Visite protocolaire mise à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visite_protocolaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visite_protocolaires/1
  # DELETE /visite_protocolaires/1.json
  def destroy
    @visite_protocolaire.destroy
    respond_to do |format|
      format.html { redirect_to visite_protocolaires_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visite_protocolaire
      @visite_protocolaire = VisiteProtocolaire.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visite_protocolaire_params
      params[:visite_protocolaire].permit(:idtype_potentiel,:valeur_potentiel,:idtype_machine,:Nom,:tolerance,:potentiel_variable,:commentaire,:gv,:va,:carte)
    end
end
