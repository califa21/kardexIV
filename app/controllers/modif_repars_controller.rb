class ModifReparsController < ApplicationController
  before_action :page_def
  before_action :set_modif_repar, only: [:show, :edit, :update, :destroy]
 before_action :page_acc

  # GET /modif_repars
  # GET /modif_repars.json
  def index
    @modif_repars = ModifRepar.all
    @modif_repars=@modif_repars.sort_by {|modif_repar| [modif_repar.machine.type_machine.type_machine, modif_repar.machine.Immatriculation]}

  end

  # GET /modif_repars/1
  # GET /modif_repars/1.json
  def show
  end

  # GET /modif_repars/new
  def new
   
    @modif_repar = ModifRepar.new
     if !(params[:id_machine].nil?) then @modif_repar.id_machine=params[:id_machine] end
    @date_1= Date.today.strftime('%d/%m/%Y')
  end

  # GET /modif_repars/1/edit
  def edit
	    @date_1= @modif_repar.date_rel.strftime('%d/%m/%Y')
  end

  # POST /modif_repars
  # POST /modif_repars.json
  def create
    @modif_repar = ModifRepar.new(modif_repar_params.permit(:sb,:Objet,:ref,:date_rel,:fait_par,:id_machine))

    respond_to do |format|
      if @modif_repar.save
        format.html { redirect_to @modif_repar, notice: 'Modif repar was successfully created.' }
        format.json { render action: 'show', status: :created, location: @modif_repar }
      else
        format.html { render action: 'new' }
        format.json { render json: @modif_repar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modif_repars/1
  # PATCH/PUT /modif_repars/1.json
  def update
    respond_to do |format|
      if @modif_repar.update(modif_repar_params.permit(:sb,:Objet,:ref,:date_rel,:fait_par,:id_machine))
        format.html { redirect_to @modif_repar, notice: 'Modif repar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @modif_repar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modif_repars/1
  # DELETE /modif_repars/1.json
  def destroy
    @modif_repar.destroy
    respond_to do |format|
      format.html { redirect_to modif_repars_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modif_repar
      @modif_repar = ModifRepar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modif_repar_params
      params[:modif_repar]
    end
end
