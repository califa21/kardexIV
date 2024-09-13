class OutilsController < ApplicationController
  before_action :page_acc
  before_action :set_outil, only: %i[ show edit update destroy ]
  before_action :page_def
   

  # GET /outils or /outils.json
  def index
    @outils = Outil.all
  end

  # GET /outils/1 or /outils/1.json
  def show
    @certificats=DocDiver.where("type_doc_id=11 and id_entite=?",params[:id])
  end

  # GET /outils/new
  def new
    @outil = Outil.new
    @date_1= Date.today.strftime('%d/%m/%Y')
    
  end

  # GET /outils/1/edit
  def edit
    @date_1= @outil.date_der_etalon.strftime('%d/%m/%Y')
    @certif_docs=DocDiver.where("type_doc_id=11 and id_entite=?",params[:id])
	@doc_diver=DocDiver.new
	#doc = mm par défaut
	@doc_diver.type_doc_id=11
	@doc_diver.id_entite=@outil.id
  end

  # POST /outils or /outils.json
  def create
    @outil = Outil.new(outil_params)

    respond_to do |format|
      if @outil.save
        format.html { redirect_to @outil, notice: "Outil was successfully created." }
        format.json { render :show, status: :created, location: @outil }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @outil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /outils/1 or /outils/1.json
  def update
    respond_to do |format|
      if @outil.update(outil_params)
        format.html { redirect_to @outil, notice: "Outil was successfully updated." }
        format.json { render :show, status: :ok, location: @outil }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @outil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /outils/1 or /outils/1.json
  def destroy
    @outil.destroy
    respond_to do |format|
      format.html { redirect_to outils_url, notice: "Outil was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outil
      @outil = Outil.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def outil_params
      params.fetch(:outil, {}).permit(:nom,:date_der_etalon,:duree_val)
    end
end
