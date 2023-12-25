class EstMonteSur < ActiveRecord::Base
	belongs_to:machine, :foreign_key =>:idmachine
	belongs_to:equipement, :foreign_key =>:idequipement
	has_many :potentiel_montage, :foreign_key=>:idest_monte_sur
	validates_presence_of :idmachine ,:message => "la machine doit être définie"
	validates_presence_of :idequipement ,:message => "l'équipement doit être défini"
end
