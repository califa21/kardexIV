class PageAccesController < ApplicationController
    before_action :page_def
   before_action :set_page_acce, only: [:show, :edit, :update, :destroy]
  before_action :page_acc

  # GET /page_acces
  # GET /page_acces.json
  def index
    @page_acces = PageAcce.all
    
  end

  # GET /page_acces/1
  # GET /page_acces/1.json
  def show
  end

  # GET /page_acces/new
  def new
    @page_acce = PageAcce.new
    @fonctions= Fonction.all
  end

  # GET /page_acces/1/edit
  def edit
	  @fonctions= Fonction.all
  end

  # POST /page_acces
  # POST /page_acces.json
  def create
    #on sauve
    @page_acce = PageAcce.new(page_acce_params.permit(:Nom, :adresse, :menu_item_id))
    respond_to do |format|
      if @page_acce.save
        format.html { 
		 #on reprend fonction par fonction
		 @fonctions= Fonction.all
		 @fonctions.each do |fonction|
			 est_acce_params=params["est_acce"][fonction.id.to_s]
			 est_acce_params["fonction_idfonction"]=fonction.id
			 est_acce_params["page_acce_id"]=@page_acce.id
			@est_acce=EstAcce.new(est_acce_params.permit(:fonction_idfonction,:page_acce_id,:page_consult,:page_new,:page_modif,:page_suppr))
			@est_acce.save
		end
			# on créé les droits
		redirect_to @page_acce, notice: 'Page acce was successfully created.' 
	}
        format.json { render action: 'show', status: :created, location: @page_acce }
      else
        format.html { render action: 'new' }
        format.json { render json: @page_acce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_acces/1
  # PATCH/PUT /page_acces/1.json
  def update
    respond_to do |format|
      if @page_acce.update(page_acce_params.permit(:Nom, :adresse, :menu_item_id))
        format.html { 
		@fonctions= Fonction.all
		 #on reprend fonction par fonction 
		 @fonctions.each do |fonction|
			#si l'enregistrement existe on update sinon on créé
			@est_acce=EstAcce.where(" fonction_idfonction =? and page_acce_id=?",fonction.id,@page_acce.id)
			if @est_acce[0].nil? then
				#on cree
				est_acce_params=params["est_acce"][fonction.id.to_s]
				est_acce_params["fonction_idfonction"]=fonction.id
				est_acce_params["page_acce_id"]=@page_acce.id
				@est_acce=EstAcce.new(est_acce_params.permit(:fonction_idfonction,:page_acce_id,:page_consult,:page_new,:page_modif,:page_suppr))
				@est_acce.save
			else
				#puis on update
				est_acce_params=params["est_acce"][fonction.id.to_s]
				@est_acce[0].update(est_acce_params.permit(:page_consult,:page_new,:page_modif,:page_suppr))
			end
		end
		redirect_to @page_acce, notice: 'Page acce was successfully updated.' 
		}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page_acce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_acces/1
  # DELETE /page_acces/1.json
  def destroy
    @page_acce.destroy
    respond_to do |format|
      format.html { redirect_to page_acces_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_acce
      @page_acce = PageAcce.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_acce_params
      params[:page_acce]
    end
end
