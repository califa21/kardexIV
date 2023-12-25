class TypeMachinesController < ApplicationController
	 before_action :page_def
	before_action :set_type_machine, only: [:show, :edit, :update, :destroy]
	before_action  :page_acc
  # GET /type_machines
  # GET /type_machines.json
  def index
    @type_machines = TypeMachine.all
  end

  # GET /type_machines/1
  # GET /type_machines/1.json
  def show
	@visite_protocolaires=VisiteProtocolaire.where("idtype_machine=?",params[:id])
	@potentiel_machines=PotentielMachine.where("idtype_machine=?",params[:id])
	@cn_machines=CnMachine.where("idtype_machine=?",params[:id])
	@mm_docs=DocDiver.where("type_doc_id=5 and id_entite=?",params[:id])
    @ct_docs=DocDiver.where("type_doc_id=9 and id_entite=?",params[:id])
  end

  # GET /type_machines/new
  def new
    @type_machine = TypeMachine.new
  end

  # GET /type_machines/1/edit
  def edit
	@type_machine = TypeMachine.find(params[:id])
	@mm_docs=DocDiver.where("type_doc_id=5 and id_entite=?",params[:id])
    @ct_docs=DocDiver.where("type_doc_id=9 and id_entite=?",params[:id])
	@doc_diver=DocDiver.new
	#doc = mm par défaut
	@doc_diver.type_doc_id=5
	@doc_diver.id_entite=@type_machine.id
  end

  # POST /type_machines
  # POST /type_machines.json
  def create
    @type_machine = TypeMachine.new(type_machine_params)

    respond_to do |format|
      if @type_machine.save
        format.html { redirect_to @type_machine, notice: 'le nouveau type machine a été créé .' }
        format.json { render action: 'show', status: :created, location: @type_machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @type_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_machines/1
  # PATCH/PUT /type_machines/1.json
  def update
    respond_to do |format|
      if @type_machine.update(type_machine_params)
        format.html { redirect_to @type_machine, notice: 'Le type machine a été mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @type_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_machines/1
  # DELETE /type_machines/1.json
  def destroy
    @type_machine.destroy
    respond_to do |format|
      format.html { redirect_to type_machines_url }
      format.json { head :no_content }
    end
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_machine
      @type_machine = TypeMachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_machine_params
      params[:type_machine].permit(:Nom_constructeur,:type_machine,:ref_manuel_entretien,:revision,:date_revision,:date_approb,:date_revue)
    end
    
    
    
end
