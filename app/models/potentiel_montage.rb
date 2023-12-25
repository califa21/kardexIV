class PotentielMontage < ActiveRecord::Base
	belongs_to:est_monte_sur, :foreign_key =>:idest_monte_sur
	belongs_to:potentiel_equipement, :foreign_key =>:idpotentiel_equipement
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	validates_presence_of :idest_monte_sur,:message => "la machine doit être précisée"
	#validates_presence_of :idpotentiel_equipement,:message => "le potentiel doit être précisé"
end
