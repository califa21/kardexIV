class DocDiver < ActiveRecord::Base
belongs_to:type_doc, :foreign_key =>:type_doc_id
validates_presence_of :type_doc_id ,:message => "le type de document doit être défini"

def self.sanitize_filename(file_name)
  # get only the filename, not the whole path (from IE)
  just_filename = File.basename(file_name) 
  # replace all none alphanumeric, underscore or perioids
  # with underscore
  just_filename.sub(/[^\w\.\-]/,'_') 
end

end