class VisiteProtocolaire < ActiveRecord::Base
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:type_machine, :foreign_key =>:idtype_machine
	has_many:visite_machine,:foreign_key=>:id_visite_protocolaire
	has_many :maitre, :class_name => 'VautPour', :foreign_key => 'maitre_id'
	has_many :induite,:class_name => 'VautPour', :foreign_key => 'induite_id'
	has_many :type_visite_lance, :foreign_key=>:type_visite_lance_id
	has_many :bon_lancement, through: :type_visite_lance
	validates_presence_of :valeur_potentiel ,:message => "le potentiel doit etre défini"
	validates_presence_of :idtype_potentiel, :message => "le type de potentiel doit etre défini"
	validates_presence_of :idtype_machine, :message => "le type de machine  doit etre défini"
end
