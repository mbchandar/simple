ActionController::Routing::Routes.draw do |map|
  map.resources :offers

  map.resources :offers


  map.resources :users


  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  
  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }
  
  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end
  
  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"
  map.resources :home
   
  map.namespace :seller do |seller|
    seller.root :controller => :seller
    seller.resources :products, :collection => { :search => :get}
    seller.resources :reviews
  end

  map.namespace :system do |system|
    system.root :controller => :admin
    system.resources :categories
    system.resources :manufacturers
  end
  
  # See how all your routes lay out with "rake routes"
  
  # Install the default routes as the lowest priority.
  
  map.resources :products
  map.resources :sessions

  map.resources :cart

  map.payment '/payment',:controller=>'payment'
  #map.home '', :controller => 'home', :action => 'index'
  map.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete } do |users|
    users.resource :account
    users.resources :roles
  end
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.dashboard '/dashboard', :controller => 'dashboard', :action => 'index'
  map.orders '/orders',:controller=>'products',:action=>'my_orders'

  map.settings '/settings',:controller=>'settings',:action => 'index'
  # more for routes
  map.change_password '/change_password', :controller => 'users', :action => 'change_password'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password', :controller => 'users', :action => 'reset_password'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '/:id', :controller => 'products',:action => 'show'

end
