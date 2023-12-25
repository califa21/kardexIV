class VautPour < ActiveRecord::Base
	belongs_to :maitre , :class_name =>"VisiteProtocolaire"
	belongs_to :induite, :class_name =>"VisiteProtocolaire"
	validates_presence_of :maitre_id ,:message => "la visite de référence doit exister"
	validates_presence_of :induite_id ,:message => "la visite induite doit exister"
	validate :meme_type_machine
 
  def meme_type_machine
    if (self.maitre.idtype_machine!=self.induite.idtype_machine) then
      errors.add(:pb_type_machine, "les deux visites n'ont pas le même type de machine")
    end
  end
end
