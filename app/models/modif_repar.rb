class ModifRepar < ActiveRecord::Base
	belongs_to:machine, :foreign_key =>:id_machine
	validates_presence_of :Objet ,:message => "l'objet doit figurer"
	validates_presence_of :date_rel ,:message => "la date de réalisation doit figurer"
	validates_presence_of :id_machine ,:message => "la machine doit figurer"

end
