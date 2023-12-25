class TypeCnEquipementLance < ActiveRecord::Base
	belongs_to :bon_lancement
	belongs_to :cn_equipement,:foreign_key=>:type_cn_equipement_lance_id
	belongs_to :equipement,:foreign_key=>:id_equipement
end