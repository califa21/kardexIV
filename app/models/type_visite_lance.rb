class TypeVisiteLance < ActiveRecord::Base
	belongs_to :bon_lancement
	belongs_to :visite_protocolaire,:foreign_key=>:type_visite_lance_id
end