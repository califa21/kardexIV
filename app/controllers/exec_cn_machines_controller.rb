class ExecCnMachinesController < ApplicationController
	include ApplicationHelper
  before_action :page_def
  before_action :set_exec_cn_machine, only: [:show, :edit, :update, :destroy]
 before_action :page_acc
 protect_from_forgery except: :cn_typemachine

  # GET /exec_cn_machines
  # GET /exec_cn_machines.json
  def index
    @exec_cn_machines = ExecCnMachine.all.includes({cn_machine:  [:type_machine,:type_potentiel]},:machine )
    @exec_cn_machines=@exec_cn_machines.sort_by{|exec_cn_machine| [exec_cn_machine.machine.type_machine.type_machine,exec_cn_machine.machine.Immatriculation,exec_cn_machine.cn_machine.nom]}
  end

  # GET /exec_cn_machines/1
  # GET /exec_cn_machines/1.json
  def show
	  
  end

  # GET /exec_cn_machines/new
  def new
	@date_1= Date.today.strftime('%d/%m/%Y')
	@exec_cn_machine = ExecCnMachine.new
	 if !(params[:id_machine].nil?) then 
		@exec_cn_machine.id_machine=params[:id_machine]
	end
	@exec_cn_machine.val_potentiel_exec=0
	@unite="&nbsp;"
	if !(params[:idcn_machine].nil?) then 
		@exec_cn_machine.idcn_machine=params[:idcn_machine]
		#recup type de protentiel lié à la visite 
		@visite_prot=CnMachine.find(params[:idcn_machine])
		@unite=@visite_prot.type_potentiel.unitee_saisie
	end
	#manque préremplissage valeur carnet
	if !(params[:idcn_machine].nil?) and  !(params[:id_machine].nil? ) then 
		@exec_cn_machine.val_potentiel_exec=val_pot(params[:id_machine],@visite_prot.type_potentiel.type_potentiel)
	end
	
  end

  # GET /exec_cn_machines/1/edit
  def edit
	   @date_1=@exec_cn_machine.date_exec.strftime('%d/%m/%Y')
	   @exec_cn_machine.val_potentiel_exec=pres_val(@exec_cn_machine.val_potentiel_exec,@exec_cn_machine.cn_machine.type_potentiel.type_potentiel)
  end

  # POST /exec_cn_machines
  # POST /exec_cn_machines.json
  def create
	 @cn_machine_exec=exec_cn_machine_params.permit(:id_machine,:idcn_machine,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire)
	  @cn_machine=CnMachine.find(exec_cn_machine_params[:idcn_machine])
	  if (@cn_machine.type_potentiel.type_potentiel=="Heure de vol") then 
		  @cn_machine_exec[:val_potentiel_exec]=to_mn(@cn_machine_exec[:val_potentiel_exec])
	  end
    @exec_cn_machine = ExecCnMachine.new(@cn_machine_exec)
    respond_to do |format|
      if @exec_cn_machine.save
        format.html {
		if (params[:retour].nil?) then 
			redirect_to @exec_cn_machine, notice: 'Exécution de CN correctement enregistrée' 
		else
			#renvoi vers la page détails machine
			redirect_to url_for(:controller => 'machines',:action=>"show", :id => params[:retour],:onglet =>2), :notice => 'Execution CN machine pris en compte.'
		end
	}
        format.json { render action: 'show', status: :created, location: @exec_cn_machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @exec_cn_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exec_cn_machines/1
  # PATCH/PUT /exec_cn_machines/1.json
  def update
	  @cn_machine_exec=exec_cn_machine_params.permit(:id_machine,:idcn_machine,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire)
	  @cn_machine=CnMachine.find(exec_cn_machine_params[:idcn_machine])
	  if (@cn_machine.type_potentiel.type_potentiel=="Heure de vol") then 
		  @cn_machine_exec[:val_potentiel_exec]=to_mn(@cn_machine_exec[:val_potentiel_exec])
	  end
    respond_to do |format|
      if @exec_cn_machine.update(@cn_machine_exec.permit(:id_machine,:idcn_machine,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire))
        format.html { redirect_to @exec_cn_machine, notice: 'Exécution de CN mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exec_cn_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exec_cn_machines/1
  # DELETE /exec_cn_machines/1.json
  def destroy
    @exec_cn_machine.destroy
    respond_to do |format|
      format.html { redirect_to exec_cn_machines_url }
      format.json { head :no_content }
    end
  end
  def cn_typemachine
	@machine=Machine.find(params[:machine_id])
	@cn_machines=CnMachine.where('idtype_machine = ? ',@machine.type_machine.id)
	  respond_to do |format|
		format.js 
	end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exec_cn_machine
      @exec_cn_machine = ExecCnMachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exec_cn_machine_params
      params[:exec_cn_machine]
    end
    def val_pot(id_machine,typ_pot)
	    releve=Carnet.liste_machine_carnet(id_machine)
		#on récupère la valeur
		case typ_pot
			when "Calendaire"
			val_potentiel=0
			when "utilisation moteur"
			val_potentiel=releve["heure_moteur"]
			when "Heure de vol" 
				potin=(releve["heure_de_vol"]/60).to_i
				val_potentiel=get_pot=potin.to_s+":"+sprintf('%02.0f',releve["heure_de_vol"]-(60*potin))
			when "Nb cycles"  
			val_potentiel=releve["nombre_cycle"]
			else
			val_potentiel=0
		end
		@val_pot=val_potentiel
    end
end
