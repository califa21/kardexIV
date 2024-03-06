class CensReport < Prawn::Document 
	#impression de l'état des CEN
	def to_pdf()
		require "prawn/measurement_extensions"
		######################################################################
		# récupération des données
		@cen=VisiteMachine.joins({machine: :type_machine},:visite_protocolaire).select("type_machines.Nom_constructeur,type_machines.type_machine,machines.Immatriculation,max(date_visite) as perim").where("visite_protocolaires.nom LIKE '%cen%' and not machines.vendu").group("type_machines.Nom_constructeur,type_machines.type_machine,machines.Immatriculation").order("perim,type_machines.Nom_constructeur,type_machines.type_machine,machines.Immatriculation")
		
		#################################################################################
		# entête de page
		repeat :all do
			#mise en place entête
			 font "Times-Roman", :size => 12
			bounding_box [0, 274.mm], {:width => 47.mm, :height => 25.mm} do
				transparent(1){ stroke_bounds }
				move_down(1.mm)
				image "#{Rails.root}/app/reports/cab_bloc.jpg",{:scale => 0.6,:position => :center}
				text "Centre aéronautique de Beynes" , {:align=>:center,:min_font_size => 10}
			end
			bounding_box [47.mm, 274.mm], {:width => 85.mm, :height => 25.mm }do
				transparent(1) { stroke_bounds }
				move_down 5.mm
				text " Etat des CEN du parc", {:align=>:center}
			end
			bounding_box [132.mm, 274.mm], :width => 54.mm, :height => 25.mm do
				data=[["",""], ["",""], ["Date",Time.now.strftime('%d/%m/%Y')], ["",""], ["Agrément","FR.CAO.0066"]]
				transparent(1) { stroke_bounds }
				table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 10, :height =>5.mm ,:padding => [0, 0, 0, 0], :width => 27.mm,:borders =>[:left, :right]}) 
			end
			stroke_horizontal_rule
		end
		#####################################################################################################"
		#données générales
		move_down 10.mm
		font "Times-Roman", :size => 18
		text("CEN",{:align=>:center})
		font "Times-Roman", :size => 8
		move_down 18.mm
		data= Array.new(@cen.length+1) {Array.new(4)}
		data[0] =["constructeur", "type","Immat","date d'échéance du Cen"]
		i=1
		@cen.each do |cen|
			data[i]=[cen.Nom_constructeur,cen.type_machine,cen.Immatriculation,(cen.perim+12.month).strftime('%d/%m/%Y')]
			i=i+1
		end
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 28.mm},:header => true) 
		number_pages "<page> / <total>", 
                                {:start_count_at => 1,
                                :at => [bounds.right - 50, 0],
                                :align => :right,
				:size => 8}	
		#number_pages "<page> in a total of <total>", [bounds.right - 50, 0]
		 render
		 
	 end
	 def start_new_page(options={})
		 require "prawn/measurement_extensions"
		 #surcharge de la fonction new page 
		super(options)
		move_down 26.mm
	end
	
end
