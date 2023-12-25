class TypeEquipementsController < ApplicationController
   before_action :page_def
  before_action :set_type_equipement, only: [:show, :edit, :update, :destroy]
 before_action :page_acc
  # GET /type_equipements
  # GET /type_equipements.json
  def index
    @type_equipements = TypeEquipement.all
     @type_equipements=@type_equipements.sort_by {|type_equipement| type_equipement.nom_constructeur}
  end

  # GET /type_equipements/1
  # GET /type_equipements/1.json
  def show
	   @mm_docs=DocDiver.where("type_doc_id=8 and id_entite=?",params[:id])
       @cv_docs=DocDiver.where("type_doc_id=10 and id_entite=?",params[:id])
  end

  # GET /type_equipements/new
  def new
    @type_equipement = TypeEquipement.new
    @mm_docs=DocDiver.where("type_doc_id=8 and id_entite=?",params[:id])
    @doc=DocDiver.new
    @doc.type_doc_id=8
  end

  # GET /type_equipements/1/edit
  def edit
	@mm_docs=DocDiver.where("type_doc_id=8 and id_entite=?",params[:id])
        @doc_diver=DocDiver.new
	#doc = cn machine par d�faut
	@doc_diver.type_doc_id=8
	@doc_diver.id_entite=@type_equipement.id
  end

  # POST /type_equipements
  # POST /type_equipements.json
  def create
    @type_equipement = TypeEquipement.new(type_equipement_params.permit(:helice,:moteur,:nom_constructeur,:type_equipement))

    respond_to do |format|
      if @type_equipement.save
        format.html { redirect_to @type_equipement, notice: "type d'équipement correctement sauvegardé." }
        format.json { render action: 'show', status: :created, location: @type_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @type_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_equipements/1
  # PATCH/PUT /type_equipements/1.json
  def update
    respond_to do |format|
      if @type_equipement.update(type_equipement_params.permit(:helice,:moteur,:nom_constructeur,:type_equipement))
        format.html { redirect_to @type_equipement, notice:  "type d'équipement correctement sauvegardé." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @type_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_equipements/1
  # DELETE /type_equipements/1.json
  def destroy
    @type_equipement.destroy
    respond_to do |format|
      format.html { redirect_to type_equipements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_equipement
      @type_equipement = TypeEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_equipement_params
      params[:type_equipement]
    end
end
