class CarnetsReport < Prawn::Document 
  def to_pdf (carnets)
	  require "prawn/measurement_extensions"
	  #rapport PDF des relevé machines
	  #en entrée la variable carnets qui contient pour chaque machine le relevé
	  #génération en tête CAB
	  font "Helvetica", :size => 12
	  bounding_box [0, 274.mm], {:width => 47.mm, :height => 25.mm} do
		transparent(1){ stroke_bounds }
		move_down(1.mm)
		image "#{Rails.root}/app/reports/cab_bloc.jpg",{:scale => 0.6,:position => :center}
		text "Centre aÃ©ronautique de Beynes" , {:align=>:center,:min_font_size => 10}
	end
	bounding_box [47.mm, 274.mm], {:width => 85.mm, :height => 25.mm }do
		transparent(1) { stroke_bounds }
		move_down 5.mm
		text " MANUEL CAE DE L'ORGANISME COMBINE DE ", {:align=>:center}
		text "MAINTIEN DE NAVIGABILITE PARTIE-CAO", {:align=>:center, :valign=>:center}
	end
	bounding_box [132.mm, 274.mm], :width => 54.mm, :height => 25.mm do
		data=[["Page","1"],["Edition","1"], ["Amendement","0"], ["Date","02/2021"] ,["",""]]
		transparent(1) { stroke_bounds }
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 10, :height =>5.mm ,:padding => [0, 0, 0, 0], :width => 27.mm,:borders =>[:left, :right]}) 
	end
	  move_down 10.mm
	  font "Helvetica", :size => 16
	  text "ANNEXE 6 :RELEVE D'HEURES HEBDOMADAIRE",{:font_size=>25,:style => :bold,:align=>:center}
	  move_down 8.mm
	  font "Helvetica", :size => 10
	  bounding_box [0, cursor], :width => 152.mm, :height => 14.mm do
		transparent(1) { stroke_bounds }
		test="semaine NÂ°"
		cell1=make_cell(test, { :align=>:center,:overflow => :shrink_to_fit, :width => 30.mm,:height => 13.mm,:padding => [0, 0, 0, 0], :borders =>[:right]})
		cell2= make_cell("", { :align=>:center,:overflow => :shrink_to_fit, :width => 30.mm,:height => 13.mm,:padding => [0, 0, 0, 0], :borders =>[:right]})
		cell2_bis= make_cell("", { :align=>:center,:overflow => :shrink_to_fit, :width => 30.mm,:height => 13.mm,:padding => [0, 0, 0, 0], :borders =>[:right]})
		cell3= make_cell("visa Chef Pilote",{ :align=>:center,:overflow => :shrink_to_fit, :width => 30.mm,:height => 13.mm,:padding => [0, 0, 0, 0], :borders =>[:right]})
		cell4= make_cell("",{ :align=>:center,:overflow => :shrink_to_fit,:padding => [0, 0, 0, 0], :borders =>[]})
		cell5= make_cell("",{ :align=>:center,:overflow => :shrink_to_fit,:padding => [0, 0, 0, 0], :borders =>[]})
		data= [[cell1,cell2,cell2_bis,cell3,cell4,cell5]]
		table(data) 
	end
	  #en tête du tableau des valeurs carnet
	 data= Array.new(carnets.length+1) {Array.new(6)}
	 i=0
	 data[i]=["type machine","immatriculation","date relevÃ©","heure de vol","nombre de cycle","heure moteur","Ã©tat visite"]
	 j=4
	 i=1
	  #copie des valeurs
	  carnets.each do |carnet| 
		  couleur_mach=Machine.couleur(carnet[1]["machine"])
		  if (couleur_mach==2) then couleur="FF0000" elsif  (couleur_mach==1) then couleur = "FFA500"  else couleur="00FF00"  end 
		 data[i]=[
			carnet[1]["type_machine"],
			carnet[0], 
			carnet[1]["date_releve"].strftime('%d/%m/%Y') ,
			to_hdv(carnet[1]["heure_de_vol"]),
			carnet[1]["nombre_cycle"],
			carnet[1]["heure_moteur"],
			Prawn::Table::Cell::Text.new( self, [0,0], :content =>"",:background_color=>couleur)
		]
		i=i+1
	  end
	  table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit,:padding => [0,1.mm, 0, 1.mm]})
	  #bas de page ?
	  render

  end
  def to_hdv(val)
	  potin=(val.to_i/60).to_i
	to_hdv=potin.to_s+":"+sprintf('%02.0f',val.to_i-60*potin)
  end
  
  # permet le transcodage UTF8 -CP 1252
  #def clean_up(dirty_text)
#	newstr = ""
#	dirty_text.length.times do |i|
#		character = dirty_text[i]
#		newstr += if character < 0x80
#			character.chr
#		elsif character < 0xC0
#			"\xC2" + character.chr
#		else
#			"\xC3" + (character - 64).chr
#		end
#	end
#	newstr
#	end
end