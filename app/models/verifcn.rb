class Verifcn < ActiveRecord::Base
	validates_presence_of :date_verif
	belongs_to :verificateur, :foreign_key=>:id_verificateur, :class_name => "Personne"
end
