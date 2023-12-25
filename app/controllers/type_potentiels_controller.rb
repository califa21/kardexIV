class TypePotentielsController < ApplicationController
protect_from_forgery except: :get_unitee
	
	 def get_unitee
		if !(params[:cn_mach_id].nil?) then 
			 @type_potentiel=CnMachine.find(params[:cn_mach_id]).type_potentiel
		elsif !(params[:visite_equ_id].nil?)
			 @type_potentiel=VisiteProtocolaireEquipement.find(params[:visite_equ_id]).type_potentiel 
		elsif !(params[:cn_equi_id].nil?)
			 @type_potentiel=CnEquipement.find(params[:cn_equi_id]).type_potentiel 
		else
			 @type_potentiel=TypePotentiel.find(params[:pot_id])
		end
			 
	   respond_to do |format|
		format.js  {}
	end
	end

end