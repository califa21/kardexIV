class CarnetsController < ApplicationController
  include ApplicationHelper
  before_action :page_def
  before_action :set_carnet, only: [:edit, :update, :destroy]
 before_action :page_acc
  # GET /carnets
  # GET /carnets.json
  def index
    if (params[:date].nil?) then 
		@carnet=Carnet.liste_machines_carnet()
	  else
		@carnet=Carnet.liste_machines_carnet(params[:date])
	end
	 respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @carnets }
      format.pdf { 
	test =CarnetsReport.new(:page_size => "A4", :page_layout => :portrait)
	output=test.to_pdf(@carnet)
	send_data output, :filename => "carnets.pdf",:type => "application/pdf"
      }
    end
end


  # GET /carnets/1
  # GET /carnets/1.json
  def show
	@carnets=Carnet.where("machine_idmachine=? and date_releve > DATE_SUB(CURDATE(), INTERVAL 70 DAY) ",params[:id]).order("date_releve desc")
	@machine=Machine.find(params[:id])
	#@carnet["machine"]=machine.Immatriculation

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @carnet }
      format.pdf { 
	output =CarnetReport.new.to_pdf(@carnets)
	send_data output, :filename => "carnet.pdf",:type => "application/pdf"
      }
    end
  end

  # GET /carnets/new
  def new
    @carnet = Carnet.new
    @date_1= Date.today.strftime('%d/%m/%Y')
    if !params[:id_machine].nil? then
		@carnet.machine_idmachine= params[:id_machine] 
		#on récupère les annciennes valeurs
		carnet_last=Carnet.liste_machine_carnet(params[:id_machine] )
		#et on recopie pour initialisation
		@carnet.heure_de_vol=pres_val(carnet_last["heure_de_vol"],"Heure de vol")
		@carnet.nombre_cycle=carnet_last["nombre_cycle"]
		@carnet.heure_moteur=carnet_last["heure_moteur"]
		#on récupére les lignes
		if (LigneCarnet.exists?(id: params[:id_machine])) then
			@ligne=LigneCarnet.find(params[:id_machine])
		else
			@ligne=LigneCarnet.new()
		end
		#on remet en forme
	end
end
  # GET /carnets/1/edit
  def edit
	  @date_1= @carnet.date_releve.strftime('%d/%m/%Y')
  end

  # POST /carnets
  # POST /carnets.json
  def create
    params[:carnet][:heure_de_vol]=to_mn(params[:carnet][:heure_de_vol])
    @carnet = Carnet.new(carnet_params)
    respond_to do |format|
	ligne=params[:ligne].permit(:L_0,:L_1,:L_2,:L_3,:L_4,:L_5,:L_6,:L_7,:L_8,:L_9,:L_10,:L_11,:L_12,:L_13,:L_14,:L_15,:ligne)
	#raise ligne.inspect
	ligne["id"]=@carnet.machine_idmachine
      if @carnet.save
	      if (LigneCarnet.exists?(ligne["id"])) then
		         @ligne=LigneCarnet.find(ligne["id"])
			@ligne.update(ligne)
		else
			@ligne=LigneCarnet.new(ligne)
			@ligne.save
		end
		format.html { 
				redirect_to action: "index", notice: 'Relevé correctement enregistré'
			}
		format.json { render action: 'show', status: :created, location: @carnet }
	else
		format.html { render action: 'new' }
		format.json { render json: @carnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carnets/1
  # PATCH/PUT /carnets/1.json
  def update
    respond_to do |format|
      params[:carnet][:heure_de_vol]=to_mn(params[:carnet][:heure_de_vol])
      if @carnet.update(carnet_params)
        format.html { redirect_to action: "show", :id =>carnet_params[:machine_idmachine] , notice: 'Relevé modifié' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @carnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carnets/1
  # DELETE /carnets/1.json
  def destroy
    @carnet.destroy
    respond_to do |format|
      format.html { redirect_to carnets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carnet
      @carnet = Carnet.find(params[:id])
      @carnet.heure_de_vol=pres_val(@carnet.heure_de_vol,"Heure de vol")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carnet_params
      params[:carnet].permit(:heure_de_vol,:nombre_cycle,:heure_moteur,:machine_idmachine,:date_releve)
      
    end
end
