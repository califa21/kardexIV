class PotentielMachinesController < ApplicationController
  include ApplicationHelper
  before_action :page_def
  before_action :set_potentiel_machine, only: [:show, :edit, :update, :destroy]
before_action :page_acc
  # GET /potentiel_machines
  # GET /potentiel_machines.json
  def index
    @potentiel_machines = PotentielMachine.all.includes(:type_potentiel,:type_machine)
  end

  # GET /potentiel_machines/1
  # GET /potentiel_machines/1.json
  def show
  end

  # GET /potentiel_machines/new
  def new
    @potentiel_machine = PotentielMachine.new
  end

  # GET /potentiel_machines/1/edit
  def edit
	#remise en forme du potentiel pour heure minute
	@potentiel_machine.valeur_potentiel=get_pot(@potentiel_machine.valeur_potentiel,@potentiel_machine.type_potentiel.type_potentiel)
  end

  # POST /potentiel_machines
  # POST /potentiel_machines.json
  def create
    @potentiel_machine = PotentielMachine.new(potentiel_machine_params.permit(:idtype_potentiel,:idtype_machine,:valeur_potentiel,:nom))
	if (@potentiel_machine.type_potentiel.type_potentiel=="Heure de vol") then 
		@potentiel_machine.valeur_potentiel=to_mn(potentiel_machine_params["valeur_potentiel"]) 
	end
    respond_to do |format|
      if @potentiel_machine.save
        format.html { redirect_to @potentiel_machine, notice: 'Potentiel machine créé' }
        format.json { render action: 'show', status: :created, location: @potentiel_machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @potentiel_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /potentiel_machines/1
  # PATCH/PUT /potentiel_machines/1.json
  def update
	if (potentiel_machine_params[:idtype_potentiel]=="3") then 
		potentiel_machine_params["valeur_potentiel"]=to_mn(potentiel_machine_params.permit(:valeur_potentiel)["valeur_potentiel"]) 
	end
    respond_to do |format|
      if @potentiel_machine.update(potentiel_machine_params.permit(:idtype_potentiel,:idtype_machine,:valeur_potentiel,:nom))
        format.html { redirect_to @potentiel_machine, notice: 'Potentiel machine mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @potentiel_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /potentiel_machines/1
  # DELETE /potentiel_machines/1.json
  def destroy
    @potentiel_machine.destroy
    respond_to do |format|
      format.html { redirect_to potentiel_machines_url }
      format.json { head :no_content }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_potentiel_machine
      @potentiel_machine = PotentielMachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def potentiel_machine_params
      params[:potentiel_machine]
    end
end
