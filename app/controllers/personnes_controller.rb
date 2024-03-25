class PersonnesController < ApplicationController
before_action :page_acc
 before_action :page_def
  # GET /personnes
  # GET /personnes.json
  def index
    @personnes = Personne.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personnes }
    end
  end

  # GET /personnes/1
  # GET /personnes/1.xml
  def show
    @personne = Personne.find(params[:id])
	@travaux =BonLancement.where("(id_re =? or id_re_decou=?) and date_fin_trav is not null",params[:id],params[:id]).order(date_fin_trav: :desc)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @personne }
    end
  end

  # GET /personnes/new
  # GET /personnes/new.xml
  def new
    @personne = Personne.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personne }
    end
  end

  # GET /personnes/1/edit
  def edit
    @personne = Personne.find(params[:id])
    @date_1=@personne.date_val_lic.strftime("%d/%m/%Y")
  end

  # POST /personnes
  # POST /personnes.xml
  def create
    @personne = Personne.new(params[:personne].permit(:Nom, :prenom, :login, :id_fonction,:pass,:pil_prop,:num_licence_mec,:autor,:date_val_lic))

    respond_to do |format|
      if @personne.save
        format.html { redirect_to(@personne, :notice => 'utilisateur créé') }
        format.xml  { render :xml => @personne, :status => :created, :location => @personne }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @personne.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /personnes/1
  # PUT /personnes/1.xml
  def update
    @personne = Personne.find(params[:id])

    respond_to do |format|
      #if @personne.update_attributes(personne_profile_parameters)
      if @personne.update(params[:personne].permit(:Nom, :prenom, :login, :id_fonction,:pass,:pil_prop,:num_licence_mec,:autor,:date_val_lic))
        format.html { redirect_to(@personne, :notice => 'utilisateur modifié') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personne.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personnes/1
  # DELETE /personnes/1.xml
  def destroy
    @personne = Personne.find(params[:id])
    @personne.destroy
    respond_to do |format|
      format.html { redirect_to(personnes_url) }
      format.xml  { head :ok }
    end
  end
  private
  def personne_profile_parameters
    params.require(:personne).permit(:Nom, :prenom, :login, :idfonction,:pass,:pil_prop,:num_licence_mec,:autor,:date_val_lic)
  end
end
