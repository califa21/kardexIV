class MaintPrevisController < ApplicationController
before_action :page_def	
 before_action :page_acc 
  # GET /maint_previs
  # GET /maint_previs.xml
  def index
    @tableau_mois=["Janvier","F&eacutevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","D&eacutecembre"]
     @date_fin=Date.today.to_s
    @machines = Machine.find_each
    @machines=@machines.sort_by{|machine|  machine.type_machine.type_machine}
    @pot=Equipement.liste_pot_hs(@date_fin)
    @vis_equip=Equipement.visite_equipement(@date_fin)
    @vis_equip=@vis_equip.sort_by{|visite|  [visite[1]["type_equipement"],visite[1]["nom_machine"]] }
    @vis_machine=VisiteMachine.visites_previ(@date_fin)
    @vis_machine=@vis_machine.sort_by{|visite|  visite[1]["visite_protocolaire"].Nom }
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @maint_previs }
    end
  end

  # GET /maint_previs/1
  # GET /maint_previs/1.xml
  def show
	  #on récupère les visites machines
	@date_fin=params['date'] #Date.today.to_s
	@machine = Machine.find(params[:id])
	@visite_machines=VisiteMachine.dernieres_visites(params[:id],@date_fin)
	@equipement=EstMonteSur.where("idmachine=? and date_retrait is null",params[:id])
	@montages=Equipement.potentiel_restant_machine(params[:id],@date_fin)
	@visites_equipement=VisiteEquipement.dernieres_visites(params[:id],@date_fin)
	@pots_machs=PotentielMachine.potentiel_machine(params[:id],@date_fin)
	@cn_machine=ExecCnMachine.etat_cn(params[:id],@date_fin)
	@cn_equipement_machine=ExecCnEquipement.etat_cn(params[:id],@date_fin)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @maint_previ }
    end
  end

  # GET /maint_previs/new
  # GET /maint_previs/new.xml
  def new
   

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @maint_previ }
    end
  end

  # GET /maint_previs/1/edit
  def edit
    
  end

  # POST /maint_previs
  # POST /maint_previs.xml
  def create
    

    respond_to do |format|
      if @maint_previ.save
        format.html { redirect_to(@maint_previ, :notice => 'MaintPrevi was successfully created.') }
        format.xml  { render :xml => @maint_previ, :status => :created, :location => @maint_previ }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @maint_previ.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /maint_previs/1
  # PUT /maint_previs/1.xml
  def update
   

    respond_to do |format|
      if @maint_previ.update_attributes(params[:maint_previ])
        format.html { redirect_to(@maint_previ, :notice => 'MaintPrevi was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @maint_previ.errors, :status => :unprocessable_entity }
      end
    end
  end
  
def recalcul
	@param=params
	annee=(params["annee"].to_i-1)
	@date_fin=((annee).to_s+"-"+params["mois"].to_s+"-"+params["jour"].to_s).to_date
	@machines = Machine.find_each
	@machines=@machines.sort_by{|machine|  machine.type_machine.type_machine}
	@pot=Equipement.liste_pot_hs(@date_fin)
	@vis_equip=Equipement.visite_equipement(@date_fin)
	@vis_equip=@vis_equip.sort_by{|visite|  [visite[1]["type_equipement"],visite[1]["nom_machine"]] }
	@vis_machine=VisiteMachine.visites_previ(@date_fin)
	@vis_machine=@vis_machine.sort_by{|visite|  visite[1]["visite_protocolaire"].Nom }
	  respond_to do |format|
		format.js 
	end
end
  # DELETE /maint_previs/1
  # DELETE /maint_previs/1.xml
  def destroy
    

    respond_to do |format|
      format.html { redirect_to(maint_previs_url) }
      format.xml  { head :ok }
    end
  end
end
