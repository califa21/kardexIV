Rails.application.routes.draw do
#	scope '/kardex' do

resources :cens do
	  collection do
		  get 'get_heure_tot'
	  end
  end
  resources :bon_lancements do 
	  collection do
		  get 'get_type_visite'
	  end
  end
   resources :maint_previs  do
	  collection do
		  get 'recalcul'
	  end
  end

  resources :equipement_vaut_pours

  resources :vaut_pours

  resources :est_monte_surs do 
	  collection do
		  get 'val_pot'
	  end
  end
  

  resources :equipements

  resources :visite_equipements do 
	  collection do
		get  'get_visite_equ'
		get 'get_type_visite'
	end
end


  resources :exec_cn_equipements do 
	  collection do
		get  'cn_type_equipement'
	end
end
  
  

  resources :cn_equipements

  resources :potentiel_equipements

  resources :visite_protocolaire_equipements

  resources :type_equipements

  resources :modif_repars

  resources :visite_machines do
	  collection do
		  get 'get_type_visite'
		  get 'get_type_machine'
	  end
  end
  

  resources :exec_cn_machines do
	collection do
		get 'cn_typemachine'
	end
end


  resources :doc_divers do
	  collection do
		  get 'envoi_doc'
		  post 'save_doc'
		  post 'suppr_doc'
	  end
  end
  
  resources :potentiel_machines 
  
  resources :type_potentiels  do
	  collection do
		  get 'get_unitee'
	  end
  end

  resources :cn_machines

  resources :visite_protocolaires

  resources :type_machines

  resources :machines

  resources :carnets

  resources :page_acces

  resources :personnes

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
resources :personnes do
end

resources :appli do
  collection do
    get 'login'
    post 'login'
    post 'create_new'
    get 'logout'
    get 'welcome'
    get 'bandeau_gauche'
  end
end
resources :machines do
end
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  root :to => 'machines#index'
 # match '/:controller/:action/:id'
  #match '/:controller/:action/:id.:format'
#end
end
