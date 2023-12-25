class AppliController < ApplicationController
#before_filter :page_acc 
  def signup
	@personne = Personne.new(@params[:personne])
	if request.post?  
		if @personne.save
			session[:personne] = Personne.authenticate(@personne.login, @personne.pass)
			flash[:message] = "enregistrement rÃ©ussi"
			redirect_to :action => "welcome"          
		else
			flash[:warning] = "ajout non permis"
		end
	end
  end
#fonction login 
  def login
	if request.post?
		if session[:personne] = Personne.authenticate(params[:personne][:login], params[:personne][:pass])
			flash[:message]  = "Bonjour "
			#redirect_to_stored
			redirect_to :controller=>"machines",:action => "index"
			return
		else
			flash[:warning] = "Utilisateur inconnu"
		end
	end
	render :layout => "login"
  end
  def logout
	system "rake kardexIV:save_file"
	session[:personne] = nil
	flash[:message] = 'dÃ©loguer'
	redirect_to :action => 'login'
  end
  def welcome
	@frame=1
  end

  def edit
  end

  def forgot_password
end
  def bandeau_gauche
	if (!(session[:personne].nil?)) then
	  #récupère l'utilisateur courant
		@utilisateur = Personne.find(session[:personne] )
		#récupère ses fonctions
		@fonction = Fonction.find(@utilisateur[:id_fonction])
		@est_acces=EstAcce.where("fonction_idfonction=?",@fonction.id).joins(:page_acce=>:menu_item).order("ordre_aff").all 
		#tri du tableau
	else
		@utilisateur= "pb"
	  end
	respond_to do |format|
		format.html # show.html.erb
		format.xml  { render :xml => @utilisateur }
	end
end

end