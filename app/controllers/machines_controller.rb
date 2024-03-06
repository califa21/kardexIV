class MachinesController < ApplicationController
 before_action :page_def
  before_action :set_machine, only: [:show, :edit, :update, :destroy]
 before_action :page_acc 
  # GET /machines
  # GET /machines.json
  def index
    @machines = Machine.where("vendu is false")
    @machines_vendu=Machine.where("vendu is true")
    @modif=EstAcce.page_acc("machines","edit",session[:personne].id_fonction)
    @suppr= EstAcce.page_acc("machines","destroy",session[:personne].id_fonction)
    @machines=@machines.sort_by{|machine|  [machine.type_machine.type_machine, machine.Immatriculation]}
     respond_to do |format|
      format.html {}
      format.pdf { 
		@machines=@machines.sort_by{|machine|  [machine.type_machine.type_machine, machine.Immatriculation]}
		test =CensReport.new(:page_size => "A4", :page_layout => :portrait)
		output=test.to_pdf()
		send_data output, :filename => "cen.pdf",:type => "application/pdf"
      }
      end
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
	   respond_to do |format|
      format.html {
		 @machine = Machine.find(params[:id])
		      #r√©cup√©ration des relev√©s
		    @releve=Carnet.liste_machine_carnet(params[:id])
		    #r√©cup√©ration des visites
		    @visite_machines=VisiteMachine.dernieres_visites(params[:id])
		    #rÈcupÈration des Èquipements montÈs sur la machine 
		    @equipement=EstMonteSur.where(["idmachine=? and date_retrait is null",params[:id]]).all
		    @montages=Equipement.potentiel_restant_machine(params[:id])
		    @montages=@montages.sort_by {|potentiel_restant| potentiel_restant[1]["moteur_helice"] }
		    #visite ‡ trier en fonction moteur et hÈlice
		    @visites_equipement=VisiteEquipement.dernieres_visites(params[:id])
		    @visites_equipement=@visites_equipement.sort_by {|visite_equipement| visite_equipement[1]["moteur_helice"]}
		    @cn_machine=ExecCnMachine.etat_cn(params[:id])
		    #cn on trie en fonction moteur
		    @cn_equipement_machine=ExecCnEquipement.etat_cn(params[:id])
		    @cn_equipement_machine=@cn_equipement_machine.sort_by{|cn_equipement| [cn_equipement[1]["moteur_helice"],cn_equipement[1]["equipement_type"]]}
		    @modif_repars=@machine.modif_repar
		    @pots_machs=PotentielMachine.potentiel_machine(params[:id])
		    #calcul de l'age
		    @age_annee = (Date.today- @machine.date_construct).to_i/365
		    @age_mois= (((Date.today- @machine.date_construct).to_i)-(365 *@age_annee))/30
		    #rÈcupÈration utilisation moyenne
		    @util=Carnet.utilisation_moyenne(params[:id])
		    #a calculer couleur d'onglet 
		    #couleur visite protocolaire (machine + Èquipement)
		    @couleur_visite = Machine.couleur_visite(params[:id])
		    #couleur CN machine 
		    @couleur_cn_machine=Machine.couleur_cn_machine(params[:id])
		    #couleur CN equipement
		    @couleur_cn_equipement=Machine.couleur_cn_equipement(params[:id])
		    #couleur durÈe de vie
		    @couleur_potentiel_machine=Machine.couleur_potentiel_machine(params[:id])
		    #rÈcupÈration des manuels maintenance disponibles
		    @mm_docs=DocDiver.where(["type_doc_id=5 and id_entite=?",@machine.type_machine.id]).all
		    #calcul de l'onglet courant pour retour des autres pages
		    @onglet=Array.new(7,'hidden')
		    if params[:onglet].nil? then @onglet[0]="visible" else @onglet[params[:onglet].to_i]="visible" end
		    @onglet1=Array.new(7,'visible')
		    if params[:onglet].nil? then @onglet1[0]="hidden" else @onglet1[params[:onglet].to_i]="hidden" end
			 @bon_lancements = BonLancement.where(id_machine: params[:id]).order(id: :desc)
	}# show.html.erb
	format.xml  { render :xml => @machine }
	format.pdf { 
		test =KardexsReport.new view_context,{:page_size => "A4", :page_layout => :portrait}
		output=test.to_pdf(params[:id])
		send_data output, :filename => "Kardex.pdf",:type => "application/pdf"
      }
    end
	  
	  
	  
  end

  # GET /machines/new
  def new
	  @machine = Machine.new
	  @date_1= Date.today.strftime('%d/%m/%Y')
  end

  # GET /machines/1/edit
  def edit
	   @date_1= @machine.date_construct.strftime('%d/%m/%Y')
  end

  # POST /machines
  # POST /machines.json
  def create
    @machine = Machine.new(machine_params.permit(:Immatriculation,:num_serie,:date_construct,:type_machine_idtype_machine,:vendu))

    respond_to do |format|
      if @machine.save
        format.html { redirect_to @machine, notice: 'Machine cr√©√©e.' }
        format.json { render action: 'show', status: :created, location: @machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machines/1
  # PATCH/PUT /machines/1.json
  def update
    respond_to do |format|
      if @machine.update(machine_params.permit(:Immatriculation,:num_serie,:date_construct,:type_machine_idtype_machine,:vendu))
        format.html { redirect_to @machine, notice: 'Machinemise √† jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machines/1
  # DELETE /machines/1.json
  def destroy
    @machine.destroy
    respond_to do |format|
      format.html { redirect_to machines_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_params
      params[:machine]
    end
end
