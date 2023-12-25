class DocDiversController < ApplicationController
  before_action :set_doc_diver, only: [:show, :edit, :update, :destroy]
 before_action :page_acc
  before_action :page_def

  # GET /doc_divers
  # GET /doc_divers.json
  def index
    @doc_divers = DocDiver.all
  end

  # GET /doc_divers/1
  # GET /doc_divers/1.json
  def show
  end

  # GET /doc_divers/new
  def new
    @doc_diver = DocDiver.new
  end

  # GET /doc_divers/1/edit
  def edit
	@retour="doc_divers"
  end

  # POST /doc_divers
  # POST /doc_divers.json
  def create
    @doc_diver = DocDiver.new(doc_diver_params)
    respond_to do |format|
      if @doc_diver.save
        format.html { redirect_to @doc_diver, notice: 'Doc diver was successfully created.' }
        format.json { render action: 'show', status: :created, location: @doc_diver }
      else
        format.html { render action: 'new' }
        format.json { render json: @doc_diver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_divers/1
  # PATCH/PUT /doc_divers/1.json
  def update
    respond_to do |format|
      if @doc_diver.update(doc_diver_params)
        format.html { redirect_to @doc_diver, notice: 'Doc diver was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @doc_diver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_divers/1
  # DELETE /doc_divers/1.json
  def destroy
	  
    @doc_diver.destroy
    respond_to do |format|
      format.html { redirect_to doc_divers_url }
      format.json { head :no_content }
    end
  end
  def save_doc
	  # sauvegarde d'un doc
	  #on vérifie qu'on a tout
	if(!params[:upload].nil?) then
		@doc=DocDiver.new(params[:doc_diver].permit(:Nom,:type_doc_id,:adresse,:id_entite)) 
		upload=params[:upload]
		#on calcule une clé aléatoire
		value = ""; 8.times{value  << (65 + rand(25)).chr}
		#on determine le nom
		name =  upload['datafile'].original_filename
		name=value+"_"+(DocDiver.sanitize_filename(upload['datafile'].original_filename))
		directory = "public/data"
		# on crée le path
		path = File.join(directory, name)
		 #on sauvegarde le fichier en public/data nom=cle+nom
		File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
		 #on sauvegarde l'enregistrement
		 #on compléte par les params calculés à savoir l'adresse
		 @doc.adresse=name
		 @doc.save
	end
	 #@type_mach=TypeMachine.find(@doc.id_entite)
	  #on redirige sur la modification de cn_machines
	  if (!(params[:retour].nil?)) then 
	  redirect_to (url_for(:controller=> params[:retour],:action=> 'edit',:id=>@doc.id_entite))
	end
  
  end
  def envoi_doc
	  @doc_diver = DocDiver.find(params[:id])
	  directory = "public/data"
	  # on crée le path
	  path = File.join(directory,@doc_diver.adresse)
	  send_file(path)
  end
  def suppr_doc
	  #on retrouve le doc 
	  @doc=DocDiver.find(params[:id_fichier])
	  #on supprime le fichier
	  directory = "public/data"
	  # on crée le path
	  path = File.join(directory, @doc.adresse)
	   File.delete(path)
	  #on supprime l'enregistrement
	 @doc.destroy
	  #on rederectionne avec le msg
	  respond_to do |format|
		format.html { redirect_to(type_machines_url) }
		format.xml  { head :ok }
	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_diver
      @doc_diver = DocDiver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doc_diver_params
      params[:doc_diver].permit(:Nom,:type_doc_id,:adresse,:id_entite)
    end
end
