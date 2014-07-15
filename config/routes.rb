GSN::Application.routes.draw do
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

  match 'auth/:provider/callback', to: 'services#create', via: [:get, :post]
  match '/groups/create_group', to: 'groups#create_group', via: [:post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  get '/node_attribute/code_image/:id', to: 'node_attribute#code_image'
  resources :node_types 
  resources :node_attributes
  resources :users do
    member do
     get 'show_other_node'
     post 'create_relation'
    end
    collection do
      post 'show'      
    end
  end
  resources :user_identities
  resources :groups
  resources :group_types
  resources :sessions, only: [:new, :create, :destroy]
  # resources :microposts, only: [:create, :destroy]

  match '/home',    to: 'static_pages#home',    via: 'get'
  match '/signup',  to: 'user_identities#new',       via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'  
  match '/signout', to: 'sessions#destroy',     via: Rails.env.test? ? 'get' : 'delete'
  match 'confirm_user/:token', to: 'sessions#confirm_user', via: 'get', as: :confirmation

  root  'static_pages#home'

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
