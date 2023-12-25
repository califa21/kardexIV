class Cen  < ActiveRecord::Base
	belongs_to:machine, :foreign_key =>:id_machine
	belongs_to:personne, :foreign_key =>:id_personne
	validates :id_machine , presence: { message: "La machine n'est pas définie" }
	validates :id_personne , presence:  { message: "Le PEN n'est pas défini" }
	validates :num_cen , presence:  { message: "Le numéro du CEN n'est pas défini" }
	validates :deliv , presence:  { message: "La date d'examen n'est pas défini" }
	validates :expire , presence:  { message: "La date de validité n'est pas défini" }
end
