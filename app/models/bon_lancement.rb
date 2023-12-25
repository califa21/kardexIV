class BonLancement < ActiveRecord::Base
	validates_presence_of :id_machine
	validates_presence_of :numero
	validates_presence_of :date_lancement
	has_many :type_visite_lance,:foreign_key=>:bon_lancement_id
	has_many :visite_protocolaire, through: :type_visite_lance
	has_many :type_cn_lance,:foreign_key=>:bon_lancement_id
	has_many :cn_machine, through: :type_cn_lance
	has_many :type_visite_equipement_lance,:foreign_key=>:bon_lancement_id
	has_many :piece_changee,:foreign_key=>:id_bl
	has_many :visite_protocolaire_equipement, through: :type_visite_equipement_lance
	has_many :type_cn_equipement_lance,:foreign_key=>:bon_lancement_id
	has_many :cn_equipement, through: :type_cn_equipement_lance
	belongs_to :machine, :foreign_key =>:id_machine
	belongs_to :rn, :foreign_key=>:id_rn, :class_name => "Personne"
	belongs_to :re, :foreign_key=>:id_re, :class_name => "Personne"
	belongs_to :rn_decou, :foreign_key=>:id_rn_decou, :class_name => "Personne"
	belongs_to :re_decou, :foreign_key=>:id_re_decou, :class_name => "Personne"
	accepts_nested_attributes_for :piece_changee, :allow_destroy => true,:reject_if  => :all_blank
end
