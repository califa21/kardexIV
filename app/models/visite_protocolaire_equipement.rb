class VisiteProtocolaireEquipement < ActiveRecord::Base
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
belongs_to:type_equipement, :foreign_key =>:idtype_equipement
has_many:visite_equipement,:foreign_key=>:id_visite_protocolaire_equipement
has_many :type_visite_equipement_lance, :foreign_key=>'type_visite_equipement_lance_id'
has_many :bon_lancement, through: :type_visite_equipement_lance
has_many :maitre, :class_name => 'EquipementVautPour', :foreign_key => 'maitre_id'
has_many :induite,:class_name => 'EquipementVautPour', :foreign_key => 'induite_id'
validates_presence_of :valeur_potentiel ,:message => "le potentiel doit etre défini"
validates_presence_of :idtype_potentiel, :message => "le type de potentiel doit etre défini"
validates_presence_of :idtype_equipement, :message => "le type équipement doit etre défini"
end
