class EquipementVautPour < ActiveRecord::Base
	belongs_to :maitre , :class_name =>"VisiteProtocolaireEquipement"
	belongs_to :induite, :class_name =>"VisiteProtocolaireEquipement"
	validates_presence_of :maitre_id ,:message => "la visite de référence doit exister"
	validates_presence_of :induite_id ,:message => "la visite induite doit exister"
	validate :meme_type_machine
 
  def meme_type_machine
    if (self.maitre.idtype_equipement!=self.induite.idtype_equipement) then
      errors.add(:pb_type_machine, "les deux visites n'ont pas le même type d'équipement")
    end
  end
end
