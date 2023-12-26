class VerifcnsController < ApplicationController
  before_action :page_acc
  before_action :page_def
  before_action :set_verifcn, only: %i[ show edit update destroy ]

  # GET /verifcns or /verifcns.json
  def index
    @verifcns = Verifcn.all
  end

  # GET /verifcns/1 or /verifcns/1.json
  def show
  end

  # GET /verifcns/new
  def new
    @verifcn = Verifcn.new
    @verifcn.date_verif =  Date.today.strftime('%d/%m/%Y')
  end

  # GET /verifcns/1/edit
  def edit
  end

  # POST /verifcns or /verifcns.json
  def create
    @verifcn = Verifcn.new(verifcn_params)

    respond_to do |format|
      if @verifcn.save
        format.html { redirect_to @verifcn, notice: "Date de vérification ajoutée." }
        format.json { render :show, status: :created, location: @verifcn }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @verifcn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /verifcns/1 or /verifcns/1.json
  def update
    respond_to do |format|
      if @verifcn.update(verifcn_params)
        format.html { redirect_to @verifcn, notice: "Date de vérification mise à jour." }
        format.json { render :show, status: :ok, location: @verifcn }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @verifcn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /verifcns/1 or /verifcns/1.json
  def destroy
    @verifcn.destroy
    respond_to do |format|
      format.html { redirect_to verifcns_url, notice: "date de vérification supprimée." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_verifcn
      @verifcn = Verifcn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def verifcn_params
      params.fetch(:verifcn, {}).permit(:date_verif,:id_verificateur)
    end
end
