Userbase::Application.routes.draw do

  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'
  match '/switch_language/:lang'   => 'application#switch_language', :as => 'switch_language'
  # User and Postings
  devise_for :users, :controllers => {:registrations => 'registrations'}

  match 'filter_language/:locale' => 'application#set_language_filter', 
        :as => 'set_language_filter'
        
  match 'posting_preview' => 'postings#preview', :as => 'posting_preview'
  match 'episode_preview' => 'episodes#preview', :as => 'episode_preview'
  
  match 'archive/:month'  => 'welcome#archive',  :as => 'archive'
   
  resources  :users do
    resources :comments
    resources :episodes do
      resources :comments
    end
    resources :postings do
      resources :comments
      collection do
        post :edit_preview
      end
    end
    #resources :episodes
    member do
      get :avatar
    end
  end
  
  # Posting and Comments
  resources :postings do
    resources :comments
    resources :assets
    resources :assets do
      member do
        get :cancel
      end
    end
    collection do
      match '/tag/:tag' => 'postings#tag', :as => 'tag'
    end    
  end

  # Episodes
  resources :episodes do
    resources :comments
    collection do
      match '/tag/:tag' => 'episodes#tag', :as => 'tag'
    end
  end
  
  resources :comments

  
  get   "welcome/index"
  match 'feed' => 'welcome#index',                :as => 'feed'
  match 'rss'  => 'welcome#index',                :as => 'rss'
  match 'user' => 'welcome#user',                 :as => 'user_settings'
  match 'legal_notice' => 'welcome#legal_notice', :as => 'legal_notice'
  match 'about' => 'welcome#about',               :as => 'about'

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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
