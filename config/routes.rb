Rails.application.routes.draw do

  ##static page
  root 'page#index'
  get 'page/about'
  get 'page/support'
  get 'page/plugins'
  get 'page/sample'
  get 'page/manual'
  get 'page/support_the_project'
  get 'page/contacts'
  get 'page/test'

  post   'api/add_field'
  post   'api/get_fields'
  post   'api/edit_field'
  post   'api/get_html'
  delete 'api/delete_field'
  post   'api/upd_project_setting'
  post   'api/controll_task'
  post   'api/get_generate_setting'
  post   'api/add_task_generating'
  post   'api/get_generate_progress'  

  resources :projects
  resources :plugins
  resources :files, :only => [:index]
  devise_for :users
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
end
