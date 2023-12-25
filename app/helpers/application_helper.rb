module ApplicationHelper
def image_add()
	return (image_tag("add.png", :border => 0))
end
def image_del()
	return (image_tag("cross.png", :border => 0))
end
def image_mod()
	return (image_tag("pencil.png", :border => 0))
end
def image_nouv()
	return (image_tag("report_add.png", :border => 0))
end
def image_visite
	return (image_tag("account_functions.png", :border => 0))
end
def image_print
	return (image_tag("printer.png", :border => 0))
end

def mod_link(path)
	return (link_to image_mod,path,:title => "Modifier")
end
def del_link(path)
		return ( link_to image_del, path,  method: :delete, data: {confirm:  'êtes vous sur?'})
end
def new_link(path)
	return (link_to image_add,path,:title =>"Nouveau")
end
def new_visite(path)
	return (link_to image_visite,path,:title =>"saisir nouvelle exécution de la visite")
end
def print_link(path)
	return (link_to image_print,path,:title =>"Impression")
end	
 def styling(couleur)
	  if (couleur==2) then @styling='KO' elsif  (couleur==1) then @styling='half_ko'  else @styling='OK'  end
  end
  #présente un potentiel restant ( en jours,en heure minute ou heure et centième)
  def pres_pot(pot,type_pot)
	 if(type_pot=="Calendaire") then 
		 toto=sprintf('%.0f', pot.to_f)+" jours" 
	
	elsif(type_pot=="Heure de vol") then
		potin=(pot/60).to_i
		toto=potin.to_s+":"+sprintf('%02.0f',(pot-60*potin).abs)
	else
		toto=sprintf('%.0f', pot.to_f)
	end 
	if(toto=="0") then toto="" end
	@pres_pot=toto
end
def pres_pot_mod(pot,type_pot)
	 if(type_pot=="Calendaire") then 
		 toto=sprintf('%.0f', pot.to_f)
	
	elsif(type_pot=="Heure de vol") then
		potin=(pot/60).to_i
		toto=potin.to_s+":"+sprintf('%02.0f',pot-60*potin)
	else
		toto=sprintf('%.2f', pot.to_f)
	end 
	if(toto=="0") then toto="" end
	@pres_pot=toto
end
#présente une valeur ( une date, heure minute,heure centième sans unitée)
def pres_val(val,type_pot)
 if(val.nil?) then toto=""
   elsif( type_pot=="Calendaire") then 
	   if (val==0) then 
		   toto="" 
	   else  
		   if val.is_a?(String) then
			if val.length > 8 then toto=Date.parse(val).strftime('%d/%m/%Y') else toto=val end
		else
			toto=val.strftime('%d/%m/%Y') 
		end
	   end
    elsif(type_pot=="Heure de vol") then
		potin=(val.to_i/60).to_i
		toto=potin.to_s+":"+sprintf('%02.0f',val.to_i-60*potin)
   else 
	   toto= sprintf('%.2f',val.to_f)
   end 
   #toto=@pres_val
   if (toto=="0") then toto="" end
   @pres_val=toto
end
#présente un interval avec unité en mois hdv ou h/c 
def pres_perio(perio,type_pot)
	 if(type_pot=="Calendaire") then 
		 toto=sprintf('%.0f', perio.to_f)+" mois" 
	
	elsif(type_pot=="Heure de vol") then
		potin=(perio/60).to_i
		toto=potin.to_s+" hdv"
	elsif(type_pot=="utilisation moteur") then
		toto=sprintf('%.2f Heure et centième',perio.to_f)
	elsif(type_pot=="Une fois") then
		toto=""
	else
		toto=sprintf('%.0f Nb cycles',perio.to_f)
	end 
	if(toto=="0") then toto="" end
	@pres_pot=toto
end
def get_pot (pot,type_pot)
	#prepare le potentiel pour saisie
	if (type_pot=="Heure de vol") then
		potin=(pot/60).to_i
		get_pot=potin.to_s+":"+sprintf('%02.0f',pot-60*potin)
	else
		get_pot=pot
	end
end

def val_date(date_c)
	if !date_c.nil? then return date_c.strftime('%d/%m/%Y') else return (date_c) end
end
def to_std_date(date_f)
	vals=date_f.split('/')
	to_std_date=vals[2]+"-"+vals[1]+"-"+vals[0]
end
end
