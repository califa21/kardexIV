class ExecCnEquipementsController < ApplicationController
	include ApplicationHelper
 before_action :page_def
 before_action :set_exec_cn_equipement, only: [:show, :edit, :update, :destroy]
 before_action :page_acc 
  
  # GET /exec_cn_equipements
  # GET /exec_cn_equipements.json
  def index
    @exec_cn_equipements = ExecCnEquipement.all
    @exec_cn_equipements = @exec_cn_equipements.sort_by { |exec_cn_equipement| 
[exec_cn_equipement.equipement.type_equipement.nom_constructeur,
exec_cn_equipement.equipement.type_equipement.type_equipement,exec_cn_equipement.equipement.num_serie,
exec_cn_equipement.cn_equipement.nom ] }
  end

  # GET /exec_cn_equipements/1
  # GET /exec_cn_equipements/1.json
  def show
  end

  # GET /exec_cn_equipements/new
  def new
    @exec_cn_equipement = ExecCnEquipement.new
   @date_1= Date.today.strftime('%d/%m/%Y')
    if !(params[:id_equipement].nil?) then 
		@exec_cn_equipement.id_equipement=params[:id_equipement]
	end
    @exec_cn_equipement.val_potentiel_exec=0
    @unite=" "
    if !(params[:idcn_equipement].nil?) then 
		@exec_cn_equipement.idcn_equipement=params[:idcn_equipement]
		#recup type de protentiel lié à la visite 
		@visite_prot=CnEquipement.find(params[:idcn_equipement])
		@unite=@visite_prot.type_potentiel.unitee_saisie
    end
  end

  # GET /exec_cn_equipements/1/edit
  def edit
	  @date_1=@exec_cn_equipement.date_exec.strftime('%d/%m/%Y')
	  @exec_cn_equipement.val_potentiel_exec=pres_val(@exec_cn_equipement.val_potentiel_exec,@exec_cn_equipement.cn_equipement.type_potentiel.type_potentiel)
  end

  # POST /exec_cn_equipements
  # POST /exec_cn_equipements.json
  def create
	  @cn_equipement_exec=exec_cn_equipement_params.permit(:id_equipement,:idcn_equipement,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire)
	  @cn_equipement=CnEquipement.find(exec_cn_equipement_params[:idcn_equipement])
	  if (@cn_equipement.type_potentiel.type_potentiel=="Heure de vol") then 
		  @cn_equipement_exec[:val_potentiel_exec]=to_mn(@cn_equipement_exec[:val_potentiel_exec])
	  end
    @exec_cn_equipement = ExecCnEquipement.new(exec_cn_equipement_params.permit(:id_equipement,:idcn_equipement,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire))
    respond_to do |format|
      if @exec_cn_equipement.save
        format.html {
		if (params[:retour].nil?) then 
			redirect_to(@exec_cn_equipement, :notice => 'Execution CN equipement prise en compte.') 
		else
				#renvoi vers la page détails equipement
			redirect_to url_for(:controller => 'machines',:action=>"show", :id => params[:retour],:onglet =>3), :notice => 'Execution CN equipement prise en compte.'
		end 
	}
        format.json { render action: 'show', status: :created, location: @exec_cn_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @exec_cn_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exec_cn_equipements/1
  # PATCH/PUT /exec_cn_equipements/1.json
  def update
	   @cn_equipement_exec=exec_cn_equipement_params.permit(:id_equipement,:idcn_equipement,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire)
	  @cn_equipement=CnEquipement.find(exec_cn_equipement_params[:idcn_equipement])
	  if (@cn_equipement.type_potentiel.type_potentiel=="Heure de vol") then 
		  @cn_equipement_exec[:val_potentiel_exec]=to_mn(@cn_equipement_exec[:val_potentiel_exec])
	  end
    respond_to do |format|
      if @exec_cn_equipement.update(exec_cn_equipement_params.permit(:id_equipement,:idcn_equipement,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire))
        format.html { redirect_to @exec_cn_equipement, notice: 'Exec cn equipement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exec_cn_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exec_cn_equipements/1
  # DELETE /exec_cn_equipements/1.json
  def destroy
    @exec_cn_equipement.destroy
    respond_to do |format|
      format.html { redirect_to exec_cn_equipements_url }
      format.json { head :no_content }
    end
  end
  def cn_type_equipement
	type_equi=Equipement.find(params[:cn_equi_id]).type_equipement.id
	@CnEquis=CnEquipement.where('idtype_equipement=?',type_equi)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exec_cn_equipement
      @exec_cn_equipement = ExecCnEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exec_cn_equipement_params
      params[:exec_cn_equipement]
    end
end
