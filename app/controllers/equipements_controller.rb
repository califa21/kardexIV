class EquipementsController < ApplicationController
    before_action :page_def
  before_action :set_equipement, only: [:show, :edit, :update, :destroy]
 before_action :page_acc
  # GET /equipements
  # GET /equipements.json
  def index
	@equipements = Equipement.all
	@equipements=@equipements.sort_by{|equipement| [equipement.type_equipement.nom_constructeur,equipement.type_equipement.type_equipement]}
  end

  # GET /equipements/1
  # GET /equipements/1.json
  def show
    #on determine la machine sur laquelle l'équipement est monté
    @est_monte=EstMonteSur.where("idequipement=? and date_retrait is null",@equipement.id)
    if(@est_monte[0].nil?) 
	    then 
			#si l'équipement n'est pas monté 
			@machine='' 
	    else 
			#si il est monté on récupére potentiel et visite
			@machine=Machine.find(@est_monte[0].idmachine) 
			@vis_equ=VisiteEquipement.where("idequipement=?",@equipement.id)
			@pot_rest= Equipement.potentiel_restant(@equipement.id)
	    end
    @mm_docs=DocDiver.where("type_doc_id=8 and id_entite=?",@equipement.idtypeequipement)
  end

  # GET /equipements/new
  def new
    @equipement = Equipement.new
  end

  # GET /equipements/1/edit
  def edit
    @mm_docs=DocDiver.where("type_doc_id=8 and id_entite=?",params[:id])
    @doc=DocDiver.new
    #doc = mm equipement par défaut
    @doc.type_doc_id=8
  end

  # POST /equipements
  # POST /equipements.json
  def create
    @equipement = Equipement.new(equipement_params.permit(:idtypeequipement,:num_serie))

    respond_to do |format|
      if @equipement.save
        format.html { redirect_to @equipement, notice: 'Equipement crÃ©Ã©' }
        format.json { render action: 'show', status: :created, location: @equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipements/1
  # PATCH/PUT /equipements/1.json
  def update
    respond_to do |format|
      if @equipement.update(equipement_params.permit(:idtypeequipement,:num_serie))
        format.html { redirect_to @equipement, notice: 'Equipement mis Ã  jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipements/1
  # DELETE /equipements/1.json
  def destroy
    @equipement.destroy
    respond_to do |format|
      format.html { redirect_to equipements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipement
      @equipement = Equipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipement_params
      params[:equipement]
    end
end
