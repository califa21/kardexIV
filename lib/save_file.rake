#tache de sauvegarde automatique de la base au logout d'un utilisateur


desc <<-END_DESC
tache de sauvegarde de la base
  rake kardexIII:save_file RAILS_ENV="production"
END_DESC

namespace :kardexIII do
  task :save_file  do
	  sh "sav_kardex.bat"
  end
  end