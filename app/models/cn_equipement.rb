class CnEquipement < ActiveRecord::Base
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:type_equipement, :foreign_key =>:idtype_equipement
	has_many:exec_cn_equipement,:foreign_key=>:id_cn_equipement
	has_many :type_cn_equipement_lance, :foreign_key=>'type_cn_equipement_lance_id'
	has_many :bon_lancement, through: :type_cn_equipement_lance
	validates_presence_of :val_potentiel ,:message => "le potentiel doit être défini"
	validates_presence_of :idtype_potentiel, :message => "le type de potentiel doit être défini"
	validates_presence_of :idtype_equipement, :message => "le type d'&eacute;quipement doit être défini"
end
