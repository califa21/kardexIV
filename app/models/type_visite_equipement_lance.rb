class TypeVisiteEquipementLance < ActiveRecord::Base
	belongs_to :bon_lancement
	belongs_to :visite_protocolaire_equipement,:foreign_key=>:type_visite_equipement_lance_id
	belongs_to :equipement,:foreign_key=>:id_equipement
end