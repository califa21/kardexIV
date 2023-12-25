class EquipementVautPoursController < ApplicationController
    before_action :page_def
  before_action :set_equipement_vaut_pour, only: [:show, :edit, :update, :destroy]
 before_action :page_acc

  # GET /equipement_vaut_pours
  # GET /equipement_vaut_pours.json
  def index
    @equipement_vaut_pours = EquipementVautPour.all
  end

  # GET /equipement_vaut_pours/1
  # GET /equipement_vaut_pours/1.json
  def show
  end

  # GET /equipement_vaut_pours/new
  def new
    @equipement_vaut_pour = EquipementVautPour.new
  end

  # GET /equipement_vaut_pours/1/edit
  def edit
  end

  # POST /equipement_vaut_pours
  # POST /equipement_vaut_pours.json
  def create
    @equipement_vaut_pour = EquipementVautPour.new(equipement_vaut_pour_params)

    respond_to do |format|
      if @equipement_vaut_pour.save
        format.html { redirect_to @equipement_vaut_pour, notice: 'Equipement vaut pour was successfully created.' }
        format.json { render action: 'show', status: :created, location: @equipement_vaut_pour }
      else
        format.html { render action: 'new' }
        format.json { render json: @equipement_vaut_pour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipement_vaut_pours/1
  # PATCH/PUT /equipement_vaut_pours/1.json
  def update
    respond_to do |format|
      if @equipement_vaut_pour.update(equipement_vaut_pour_params)
        format.html { redirect_to @equipement_vaut_pour, notice: 'Equipement vaut pour was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @equipement_vaut_pour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipement_vaut_pours/1
  # DELETE /equipement_vaut_pours/1.json
  def destroy
    @equipement_vaut_pour.destroy
    respond_to do |format|
      format.html { redirect_to equipement_vaut_pours_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipement_vaut_pour
      @equipement_vaut_pour = EquipementVautPour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipement_vaut_pour_params
      params[:equipement_vaut_pour].permit(:maitre_id,:induite_id,:commentaire)
    end
end
