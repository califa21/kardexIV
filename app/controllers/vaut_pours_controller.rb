class VautPoursController < ApplicationController
 before_action :page_def 
 before_action :set_vaut_pour, only: [:show, :edit, :update, :destroy]
before_action :page_acc
  # GET /vaut_pours
  # GET /vaut_pours.json
  def index
    @vaut_pours = VautPour.all
  end

  # GET /vaut_pours/1
  # GET /vaut_pours/1.json
  def show
  end

  # GET /vaut_pours/new
  def new
    @vaut_pour = VautPour.new
  end

  # GET /vaut_pours/1/edit
  def edit
  end

  # POST /vaut_pours
  # POST /vaut_pours.json
  def create
    @vaut_pour = VautPour.new(vaut_pour_params)

    respond_to do |format|
      if @vaut_pour.save
        format.html { redirect_to @vaut_pour, notice: 'Vaut pour was successfully created.' }
        format.json { render action: 'show', status: :created, location: @vaut_pour }
      else
        format.html { render action: 'new' }
        format.json { render json: @vaut_pour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vaut_pours/1
  # PATCH/PUT /vaut_pours/1.json
  def update
    respond_to do |format|
      if @vaut_pour.update(vaut_pour_params)
        format.html { redirect_to @vaut_pour, notice: 'Vaut pour was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vaut_pour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vaut_pours/1
  # DELETE /vaut_pours/1.json
  def destroy
    @vaut_pour.destroy
    respond_to do |format|
      format.html { redirect_to vaut_pours_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vaut_pour
      @vaut_pour = VautPour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vaut_pour_params
      params[:vaut_pour].permit(:maitre_id,:induite_id,:commentaire)
    end
end
