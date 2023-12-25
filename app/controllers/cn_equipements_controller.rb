class CnEquipementsController < ApplicationController
	 include ApplicationHelper
  before_action :page_def
  before_action :set_cn_equipement, only: [:show, :edit, :update, :destroy]
before_action :page_acc
  # GET /cn_equipements
  # GET /cn_equipements.json
  def index
    @cn_equipements = CnEquipement.all
     @cn_equipements=@cn_equipements.sort_by{|cn_equip| [cn_equip.type_equipement.nom_constructeur,cn_equip.type_equipement.type_equipement]}

  end

  # GET /cn_equipements/1
  # GET /cn_equipements/1.json
  def show
	@cn_docs=DocDiver.where("type_doc_id=2 and id_entite=?",params[:id])
	@bs_docs=DocDiver.where("type_doc_id=4 and id_entite=?",params[:id])
  end

  # GET /cn_equipements/new
  def new
    @cn_equipement = CnEquipement.new
     if !(params[:id_type_equipement].nil?) then 
		@cn_equipement.idtype_equipement=params[:id_type_equipement]
	end
     @cn_equipement.val_potentiel=0
  end

  # GET /cn_equipements/1/edit
  def edit
	  @cn_equipement.val_potentiel=pres_perio(@cn_equipement.val_potentiel,@cn_equipement.type_potentiel.type_potentiel)
	@cn_docs=DocDiver.find(:all,:conditions=>["type_doc_id=2 and id_entite=?",params[:id]])
	@bs_docs=DocDiver.find(:all,:conditions=>["type_doc_id=4 and id_entite=?",params[:id]])
	@doc_diver=DocDiver.new
	 #doc = cn équipement par défaut
	@doc_diver.type_doc_id=2
	@doc_diver.id_entite=@cn_equipement.id
  end

  # POST /cn_equipements
  # POST /cn_equipements.json
  def create
    @cn_equipement = CnEquipement.new(cn_equipement_params.permit(:idtype_equipement,:date_premiere_execution,:reference,:service_bulletin,:est_annule,:idtype_potentiel,:val_potentiel,:nom,:commentaire))
	 if (@cn_equipement.type_potentiel.type_potentiel=="Heure de vol") then @cn_equipement.val_potentiel=to_mn(params[:cn_equipement][:val_potentiel]) end
    respond_to do |format|
      if @cn_equipement.save
        format.html { 
		if (params[:retour].nil?) then 
			redirect_to(@cn_equipement, :notice => 'Cn équipement créée.')
		else
			#renvoi vers la page détails machine
			redirect_to url_for(:controller => 'type_equipements',:action=>"show", :id => params[:retour]), :notice => 'Cn équipement créée.'
		end
		#
		 }
        format.json { render action: 'show', status: :created, location: @cn_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @cn_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cn_equipements/1
  # PATCH/PUT /cn_equipements/1.json
  def update
	  if (cn_equipement_params["idtype_potentiel"]=="3") then 
		cn_equipement_params["val_potentiel"]=to_mn(cn_equipement_params["val_potentiel"]) 
	end
    respond_to do |format|
      if @cn_equipement.update(cn_equipement_params.permit(:idtype_equipement,:date_premiere_execution,:reference,:service_bulletin,:est_annule,:idtype_potentiel,:val_potentiel,:nom,:commentaire))
        format.html { redirect_to @cn_equipement, notice: 'Cn équipement modifiée.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cn_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cn_equipements/1
  # DELETE /cn_equipements/1.json
  def destroy
    @cn_equipement.destroy
    respond_to do |format|
      format.html { redirect_to cn_equipements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cn_equipement
      @cn_equipement = CnEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cn_equipement_params
      params[:cn_equipement]
    end
end
