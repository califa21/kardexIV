class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper :all
  def current_user
	session[:personne]
  end
  def redirect_to_stored
	 if return_to = session[:return_to]
		session[:return_to]=nil
	else
		redirect_to :controller=>'machines', :action=>'index'
	end
end
def page_def
	  if (!(session[:personne].nil?)) then
	  #r?p? l'utilisateur courant
		@utilisateur = Personne.find(session[:personne][:id] )
		#r?p? ses fonctions
		@fonction = Fonction.find(@utilisateur[:id_fonction])
		@est_acces=EstAcce.where("fonction_idfonction=?",@fonction.id).joins(:page_acce=>:menu_item).order("ordre_aff").all 
		#tri du tableau
	else
		@utilisateur= "pb"
	  end
  end
   def page_acc
	   #vérifie que la personne est logué
	   #raise (request.fullpath)
	if !session[:personne]
		flash[:warning]='Please login to continue'
		session[:return_to]=request.url
		redirect_to :controller => "appli", :action => "login"
		return (false)
	end
	#vérifie que la personne est autorisée à consulter la page 
	est_acce=EstAcce.joins(:page_acce).where('fonction_idfonction = ? AND page_acces.adresse = ? ',session[:personne].id_fonction,'/'.concat(params[:controller])) #si le résultat est null la page n'est pas consultable
	if (est_acce[0].nil?) then 
		#la est le problÃ¨me on ne redirige pas !!! 
		redirect_to({:controller=>'machine', :action=>'index'},:notice => "vous n'avez pas les droits d'acces") 
		return (false) 
	end
	#si non on regarde en fontion de la commande
	case params[:action]
		when "index","show" then
			#cas de la consultation
			if (est_acce[0].page_consult) then 
				return ( true) 
			else 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces") 
				return (false)
			end
		when "new","create" then
			#cas de la  création
			if (!est_acce[0].page_new) then 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces")
				return (false)
			else 
				return ( true) 
			end
		when "edit","update" then
			#cas de la modification
			if (!est_acce[0].page_modif) then 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces")
				return (false)
			else 
				return ( true) 
			end
		when "destroy" then
			if (!est_acce[0].page_suppr)  then 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces")
				return (false)
			else 
				return ( true) 
			end
		else 
			#destiné à couvrir les échanges "java" par ex
			return (true)
	end	
	#si on n'est pas sortie la page n'est pas accessible pour l'utilisateur inutile par ailleurs ...
	redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces")
	return(false)
end
  def to_mn(val)
	  #on split la chaine
	  positions=val.split(/[.,:']/)
	  #60 fois la valeur
	  mn=60*positions[0].to_i+positions[1].to_i
	  #plus la partie droite
 return mn
 end
end