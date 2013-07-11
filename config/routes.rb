Oats::Application.routes.draw do
  devise_for :users, :skip => [:sessions], :controllers => {:registrations => "registrations"}
  resources :users
  resources :user_imports
  resources :companies
  resources :worktimes
  resources :offices
  resources :billings
  
  root to: 'static_pages#home'

  post "add", :to =>"users#add"
  put "change_password/:id", :to =>"users#change_password"
  post "checkin", :to => "worktimes#create"
  post "checkout", :to => "worktimes#update"
  post "mobile_signin", :to => "users#mobile_signin"
  post "mobile_graph", :to => "worktimes#mobile_graph"

  devise_scope :user do
    get "signin" => "devise/sessions#new", :as => :new_user_session
    post "signin" => "devise/sessions#create", :as => :user_session
    delete "signout" => "devise/sessions#destroy", :as => :destroy_user_session
    get "signup", :to => "devise/registrations#new"
  end
  
  get "/help", :to => 'static_pages#help'
  get "/about", :to => 'static_pages#about'
  get "/privacy", :to => 'static_pages#privacy'
  get "/testimony", :to => 'static_pages#testimony'
  get "/contact", :to => 'static_pages#contact'
  get "/terms", :to => 'static_pages#terms'
  get "/download", :to => 'static_pages#download'

  match "*path", :to => "static_pages#routing_error"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
