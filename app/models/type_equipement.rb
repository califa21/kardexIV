class TypeEquipement < ActiveRecord::Base
	default_scope { order 'nom_constructeur,type_equipement ASC'}
	validates_presence_of :nom_constructeur,:message => "le constructeur ne peut être vide"
	validates_presence_of :type_equipement ,:message => "le type equipement ne peut être vide"
	has_many:potentiel_equipement,:foreign_key =>:idtype_equipement
	has_many:visite_protocolaire_equipement,:foreign_key =>:idtype_equipement
	has_many:cn_equipement,:foreign_key =>:idtype_equipement
	has_many:equipement,:foreign_key=>:idtype_equipement
end
