class CnMachinesController < ApplicationController
	 include ApplicationHelper
  before_action :set_cn_machine, only: [:show, :edit, :update, :destroy]
  before_action :page_def
  before_action :page_acc
  # GET /cn_machines
  # GET /cn_machines.json
  def index
    @cn_machines = CnMachine.all.includes(:type_potentiel,:type_machine)
    @cn_machines=@cn_machines.sort_by {|cn_machine| [cn_machine.type_machine.Nom_constructeur, cn_machine.type_machine.type_machine,cn_machine.reference]}
  end

  # GET /cn_machines/1
  # GET /cn_machines/1.json
  def show
	@cn_machine = CnMachine.find(params[:id])
	@cn_docs=DocDiver.where("type_doc_id=1 and id_entite=?",params[:id])
	@bs_docs=DocDiver.where("type_doc_id=3 and id_entite=?",params[:id])
  end

  # GET /cn_machines/new
  def new
    @cn_machine = CnMachine.new
    if !(params[:idtype_machine].nil?) then 
		@cn_machine.idtype_machine=params[:idtype_machine]
	end
  end

  # GET /cn_machines/1/edit
  def edit
	@cn_machine.val_potentiel= pres_perio(@cn_machine.val_potentiel,@cn_machine.type_potentiel.type_potentiel)
	@cn_docs=DocDiver.where("type_doc_id=1 and id_entite=?",params[:id])
	@bs_docs=DocDiver.where("type_doc_id=3 and id_entite=?",params[:id])
	@doc_diver=DocDiver.new
	 #doc = cn machine par défaut
	@doc_diver.type_doc_id=1
	@doc_diver.id_entite=@cn_machine.id
  end

  # POST /cn_machines
  # POST /cn_machines.json
  def create
   @cn_machine = CnMachine.new(params[:cn_machine].permit(:idtype_machine,:date_premiere_execution,:reference,:service_bulletin,:est_annule,:idtype_potentiel,:val_potentiel,:nom,:commentaire))
   if (@cn_machine.type_potentiel.type_potentiel=="Heure de vol") then @cn_machine.val_potentiel=to_mn(params[:cn_machine][:val_potentiel]) end

    respond_to do |format|
      if @cn_machine.save
        format.html {
		#a faire un test si param retour on redirige sur le type machine sinon on reboucle sur la liste des VP
		if (params[:retour].nil?) then 
			redirect_to(@cn_machine, :notice => 'la Cn a ete cree.') 
		else
			@type_machine = TypeMachine.find(params[:retour])
			@visite_protocolaires=VisiteProtocolaire.find_all_by_idtype_machine(params[:retour])
			@potentiel_machines=PotentielMachine.find_all_by_idtype_machine(params[:retour])
			@cn_machines=CnMachine.find_all_by_idtype_machine(params[:retour])
			render 'type_machines/show',:notice => 'la Cn a ete cree.'
		end	
		}
        format.xml  { render :xml => @cn_machine, :status => :created, :location => @cn_machine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cn_machine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cn_machines/1
  # PATCH/PUT /cn_machines/1.json
  def update
    respond_to do |format|
	if (cn_machine_params["idtype_potentiel"]=="3") then 
		cn_machine_params["val_potentiel"]=to_mn(cn_machine_params["val_potentiel"]) 
	end
      if @cn_machine.update(cn_machine_params.permit(:idtype_machine,:date_premiere_execution,:reference,:service_bulletin,:est_annule,:idtype_potentiel,:val_potentiel,:nom,:commentaire))
        @cn_docs=DocDiver.where("type_doc_id=1 and id_entite=?",params[:id])
        @bs_docs=DocDiver.where("type_doc_id=3 and id_entite=?",params[:id])
        format.html { redirect_to @cn_machine, notice: 'Cn machine correctement mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cn_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cn_machines/1
  # DELETE /cn_machines/1.json
  def destroy
    @cn_machine.destroy
    respond_to do |format|
      format.html { redirect_to cn_machines_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cn_machine
      @cn_machine = CnMachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cn_machine_params
      params[:cn_machine]
    end
end
