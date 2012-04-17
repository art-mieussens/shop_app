Homy::Application.routes.draw do

  root :to => 'home#index'
  
  resource :connection, :only => [:new, :create, :destroy]

  get '/pos_menu' => 'pos_menu#index'  
  get '/products_menu' => 'products_menu#index'
  get '/contact_book_menu' => 'contact_book_menu#index'
  get '/admin_menu' => 'admin_menu#index'
  get '/sales_menu' => 'sales_menu#index'
 
 #users and roles 
  resources :users do
    resources :roles
  end
  resources :role_assignments
  resources :roles do
    resources :roles
  end
  
  #contact_book
  resources :people
  resources :bussinesses 
  resources :contacts
  resources :appointments
  
  resources :suppliers do
    resources :products
  end
  
  #products
  resources :product_categories, :except => :show do
    resources :product_categories, :except => :show
    resources :products
  end  
  
  resources :products do
    resources :inventory_movements
    resource :product_transformation do
      get :new_product
      post :create_product
    end
  end
  
  resources :product_transformations do
    post :apply
  end  
  resources :product_transformation_lines

  resources :rates

  #sales
  resources :sales do
    post :close #close and process the sale
    put :open #delete inventory movements and reopen the sale
    get :check_payment
    post :pay
    get :print_ticket
    collection do
      get :abstract
    end
    resources :sale_lines
  end

  resources :cash_registers

  #inventory
  get 'inventories/existences'
  post 'inventories/existences_make_spreadsheet'
  resources :inventories do
    resources :inventory_balances
  end
  resources :inventory_movements
  resources :merchandise_receptions do
    resources :merchandise_reception_lines
    post 'process_and_close'
  end

            
  resources :printers do
    member do
      put :select
    end
  end          
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
