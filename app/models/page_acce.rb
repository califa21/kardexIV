class PageAcce < ActiveRecord::Base
#has_many :fonction, :through => :est_acce
has_many :est_acce
belongs_to:menu_item,:foreign_key =>:menu_item_id
validates_presence_of :Nom
validates_presence_of :adresse
validates_presence_of :menu_item_id
end
