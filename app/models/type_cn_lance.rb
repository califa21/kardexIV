class TypeCnLance < ActiveRecord::Base
	belongs_to :bon_lancement
	belongs_to :cn_machine,:foreign_key=>:type_cn_lance_id
end