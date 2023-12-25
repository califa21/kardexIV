class TypeMachine < ActiveRecord::Base
	default_scope { order 'Nom_constructeur,type_machine ASC'}
	validates_presence_of :Nom_constructeur,:message => "le constructeur ne peut être vide"
	validates_presence_of :type_machine ,:message => "le type machine ne peut être vide"
	has_many :potentiel_machine, :foreign_key =>:idtype_machine
	has_many :visite_protocolaire, :foreign_key =>:idtype_machine
end
