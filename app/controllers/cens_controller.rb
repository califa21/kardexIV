class CensController < ApplicationController
	include ApplicationHelper
  before_action :page_def
  before_action :set_cen, only: %i[ show edit update destroy ]
  before_action :page_acc 
  helper_method :val_pot
  protect_from_forgery  except: [:get_heure_tot]
  # GET /cens or /cens.json
  def index
    @cens = Cen.all.order(num_cen: :desc)
  end

  # GET /cens/1 or /cens/1.json
  def show
	  respond_to do |format|
		format.html {}
		format.docx {
		#format docx
		#teste cen ou AC15
		if (params[:type_rapport] == "cen") then
			#CEN
			#on ouvre le template
			doc = Doc.new("#{Rails.root}/app/reports/15c.docx", "#{Rails.root}/tmp/docx/")
			# on modifie 
			doc.replace("$num_cen$", @cen.num_cen)
			doc.replace("$const$", @cen.machine.type_machine.Nom_constructeur.upcase)
			doc.replace("$modele$", @cen.machine.type_machine.type_machine)
		        doc.replace("$immat$", @cen.machine.Immatriculation)
			doc.replace("$num_serie$", @cen.machine.num_serie)
			doc.replace("$deliv$", @cen.deliv.strftime('%d.%m.%Y'))
			doc.replace("$exp$", @cen.expire.strftime('%d.%m.%Y'))
			doc.replace("$heure_tot$", @cen.heure_cellule)
			doc.replace("$nom$",@cen.personne.Nom.upcase + " " +@cen.personne.prenom[0].upcase)
			doc.replace("$poet$",@cen.personne.autor)

		      # Write the document back to a temporary file
		       tmp_file = Tempfile.new('word_template', "#{Rails.root}/tmp/")
		       tmp_file.close
		      doc.commit(tmp_file.path)
		      # Respond to the request by sending the temp file
		      send_file tmp_file.path, filename: "cen#{@cen.num_cen.to_s}.docx", disposition: 'attachment'
					
					#on envoi
		elsif (params[:type_rapport] == "ac158d") then
			doc = Doc.new("#{Rails.root}/app/reports/ac158e_FR.docx", "#{Rails.root}/tmp")
			# on modifie 
			doc.replace("$immat$", @cen.machine.Immatriculation)
			doc.replace("$model$", @cen.machine.type_machine.type_machine)
		        doc.replace("$num_serie$", @cen.machine.num_serie)
			doc.replace("$heure_cellule$", @cen.heure_cellule)
			#moteur
			moteurs=Equipement.joins(:est_monte_sur,:type_equipement).where(type_equipements: {moteur: true },est_monte_surs: {idmachine: @cen.id_machine ,date_retrait: nil})
			if (moteurs.length >0) then
				# c'est appareil avce moteur
					doc.replace("$moteur_typ$", moteurs[0].type_equipement.nom_constructeur + moteurs[0].type_equipement.type_equipement)
					doc.replace("$mot_serie$",  moteurs[0].num_serie)
					pot_init=PotentielMontage.where(idtype_potentiel: 4,idest_monte_sur: moteurs[0].est_monte_sur[0].id)
					potinit_val=pot_init[0].valeur_machine_jour_montage
					
				else
					#planeur pur
					doc.replace("$moteur_typ$","/")
					doc.replace("$mot_serie$",  "/")
				end
			#helice
			moteurs=Equipement.joins(:est_monte_sur,:type_equipement).where(type_equipements: {helice: true },est_monte_surs: {idmachine: @cen.id_machine ,date_retrait: nil})
			if (moteurs.length >0) then
				# c'est appareil avce moteur
					doc.replace("$hel$", moteurs[0].type_equipement.nom_constructeur + moteurs[0].type_equipement.type_equipement)
					doc.replace("$helice_serie$",  moteurs[0].num_serie)
					pot_init=PotentielMontage.where(idtype_potentiel: 4,idest_monte_sur: moteurs[0].est_monte_sur[0].id)
					potinit_val=pot_init[0].valeur_machine_jour_montage
					
				else
					#planeur pur
					doc.replace("$hel$","/")
					doc.replace("$helice_serie$",  "/")
				end
			
			if (@cen.nuissance_sonore) then
					doc.replace("$nui_oui$", "\u2612".encode('utf-8'))
					doc.replace("$nui_non$", "\u2610".encode('utf-8'))
				else
					doc.replace("$nui_oui$", "\u2610".encode('utf-8'))
					doc.replace("$nui_non$", "\u2612".encode('utf-8'))
				end
			doc.replace("$date$", @cen.deliv.strftime('%d.%m.%Y'))
			nom = @cen.personne.Nom.upcase + " " +@cen.personne.prenom[0].upcase
			doc.replace("$nom$", nom)
			

		     # Write the document back to a temporary file
		       tmp_file = Tempfile.new('word_template', "#{Rails.root}/tmp/")
		       tmp_file.close
		      doc.commit(tmp_file.path)
		      # Respond to the request by sending the temp file
		      send_file tmp_file.path, filename: "ac158_#{@cen.num_cen.to_s}.docx", disposition: 'attachment'
					
			#on envoi
		else
			#annexe V
			doc = Doc.new("#{Rails.root}/app/reports/examen_nav_CAB.docx", "#{Rails.root}/tmp")
			# on modifie 
			doc.replace("$const$", @cen.machine.type_machine.Nom_constructeur.upcase)
			doc.replace("$immat$", @cen.machine.Immatriculation,true)
			doc.replace("$modele$", @cen.machine.type_machine.type_machine)
		        doc.replace("$num_serie$", @cen.machine.num_serie)
			doc.replace("$heure_cellule$", @cen.heure_cellule)
			doc.replace("$heure_tot$", @cen.heure_cellule)
			#gestion des PE
			#moteur
			moteurs=Equipement.joins(:est_monte_sur,:type_equipement).where(type_equipements: {moteur: true },est_monte_surs: {idmachine: @cen.id_machine ,date_retrait: nil})
			if (moteurs.length >0) then
				# c'est appareil avce moteur
					doc.replace("$moteur_cons$", moteurs[0].type_equipement.nom_constructeur)
					doc.replace("$moteur_typ$", moteurs[0].type_equipement.nom_constructeur + moteurs[0].type_equipement.type_equipement)
					doc.replace("$mot_serie$",  moteurs[0].num_serie)
					pot_init=PotentielMontage.where(idtype_potentiel: 4,idest_monte_sur: moteurs[0].est_monte_sur[0].id)
					potinit_val=pot_init[0].valeur_machine_jour_montage
					
				else
					#planeur pur
					doc.replace("$moteur_cons$","/")
					doc.replace("$moteur_typ$","/")
					doc.replace("$mot_serie$",  "/")
				end
			#helice
			moteurs=Equipement.joins(:est_monte_sur,:type_equipement).where(type_equipements: {helice: true },est_monte_surs: {idmachine: @cen.id_machine ,date_retrait: nil})
			if (moteurs.length >0) then
				# c'est appareil avce moteur
					doc.replace("$helice_cons$", moteurs[0].type_equipement.nom_constructeur)
					doc.replace("$helice_model$", moteurs[0].type_equipement.type_equipement)
					doc.replace("$helice_serie$", moteurs[0].num_serie)
					pot_init=PotentielMontage.where(idtype_potentiel: 4,idest_monte_sur: moteurs[0].est_monte_sur[0].id)
					potinit_val=pot_init[0].valeur_machine_jour_montage
					
				else
					#planeur pur
					doc.replace("$helice_cons$","/")
					doc.replace("$helice_model$","/")
					doc.replace("$helice_serie$",  "/")
				end
			
			if (@cen.nuissance_sonore) then
					doc.replace("$nui_oui$", "\u2612".encode('utf-8'))
				else
					doc.replace("$nui_oui$", "\u2610".encode('utf-8'))
				end
			doc.replace("$pe$",@cen.machine.type_machine.ref_manuel_entretien)
			doc.replace("$rev$",@cen.machine.type_machine.revision)
			if (@cen.machine.type_machine.date_revision.nil?) then doc.replace("$pe_rev$","") else doc.replace("$pe_rev$",@cen.machine.type_machine.date_revision.strftime('%d.%m.%Y'))end
			if (@cen.machine.type_machine.date_approb.nil?) then doc.replace("$approb$","") else doc.replace("$approb$",@cen.machine.type_machine.date_approb.strftime('%d.%m.%Y')) end 
			doc.replace("$date$", @cen.deliv.strftime('%d.%m.%Y'))
			doc.replace("$deliv$", @cen.deliv.strftime('%d.%m.%Y'),true)
			nom = @cen.personne.Nom.upcase + " " +@cen.personne.prenom[0].upcase
			doc.replace("$nom$", nom)
			

		     # Write the document back to a temporary file
		       tmp_file = Tempfile.new('word_template', "#{Rails.root}/tmp/")
		       tmp_file.close
		      doc.commit(tmp_file.path)
		      # Respond to the request by sending the temp file
		      send_file tmp_file.path, filename: "annexeV_#{@cen.num_cen.to_s}.docx", disposition: 'attachment'
		end
		
		}
	end
	
  end

  # GET /cens/new
  def new
    @date_1= Date.today.strftime('%d/%m/%Y')
    @cen = Cen.new
  end

  # GET /cens/1/edit
  def edit
	  @date1=@cen.deliv.strftime('%d/%m/%Y')
	  @date2=@cen.expire.strftime('%d/%m/%Y')
  end

  # POST /cens or /cens.json
  def create
    @cen = Cen.new(cen_params)

    respond_to do |format|
      if @cen.save
        format.html { redirect_to @cen, notice: "Cen was successfully created." }
        format.json { render :show, status: :created, location: @cen }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cens/1 or /cens/1.json
  def update
    respond_to do |format|
      if @cen.update(cen_params)
        format.html { redirect_to @cen, notice: "Cen was successfully updated." }
        format.json { render :show, status: :ok, location: @cen }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cens/1 or /cens/1.json
  def destroy
    @cen.destroy
    respond_to do |format|
      format.html { redirect_to cens_url, notice: "Cen was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def get_heure_tot
	        releve=Carnet.liste_machine_carnet(params[:id_machine])
		@heure_tot=pres_val(releve["heure_de_vol"],"Heure de vol")
	  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cen
      @cen = Cen.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cen_params
      params.fetch(:cen, {}).permit(:num_cen, :deliv,:expire,:heure_cellule,:id_machine,:id_personne,:nuissance_sonore)
    end
end
