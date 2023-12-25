class PotentielEquipement < ActiveRecord::Base
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:type_equipement, :foreign_key =>:idtype_equipement
	validates_presence_of :idtype_equipement,:message => "le type d'équipement ne peut être vide"
	validates_presence_of :idtype_potentiel,:message => "le type de potentiel ne peut être vide"
end
