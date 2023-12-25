#tache de sauvegarde automatique de la base au logout d'un utilisateur


desc <<-END_DESC
tache de sauvegarde de la base
  rake kardexIV:save_file RAILS_ENV="production"
END_DESC

namespace :kardexIV do
  task :save_file  do
	  sh "bash sav_kardex.sh"
  end
  end
