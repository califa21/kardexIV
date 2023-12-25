class Personne < ActiveRecord::Base

belongs_to :fonction,:foreign_key=>:id_fonction
validates_presence_of :Nom ,:message => "le nom ne peut etre vide"
validates_presence_of :login, :message => "le login ne peut etre vide"
validates_presence_of :pass, :message => "le mot de passe ne peut etre vide"
validates_uniqueness_of :login
validates_uniqueness_of :Nom ,:scope=>:prenom, :message=>"la combinaison Nom Pr&eacute;nom existe deja"
validates_length_of :login, :within => 3..40
validates_length_of :pass, :within => 5..40
  
  def self.authenticate(login, pass)
  u=find_by(login: login)
  return nil if u.nil?
  return u if (pass==u.pass)
  nil
end  
end
