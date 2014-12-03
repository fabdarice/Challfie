Challfie::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  get '/auto_refresh' => 'home#auto_refresh'

  post '/user/autocomplete_search_user' => 'users#autocomplete_search_user'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :passwords => "passwords", :confirmations => "confirmations", :registrations => "registrations" }

  get '/users' => 'home#index'

  resources :users, :only => [:update, :show] do
    member do
      get :follow
      get :unfollow      
      get :accept_request
      get :remove_follower
      get :block
    end    
  end
  get '/friends' => 'users#friends', as: :user_friends
  get '/edit' => 'users#edit', as: :edit_user

  resources :selfies do
    resources :comments, :only => [:create]
  end
  get '/selfies/approve/:id' => 'selfies#approve', as: :selfie_approve
  get '/selfies/disapprove/:id' => 'selfies#disapprove', as: :selfie_disapprove
  get '/selfies/filter/:search' => 'selfies#filter_by_keyword', as: :selfie_filter
  
  get '/selfies/:id/comments/showall' => 'comments#show_selfie_comments', as: :selfie_comments_showall

  resources :books
  resources :categories
  resources :challenges
  resources :notifications, :only => [:index]
  get '/notifications/all_read' => 'notifications#all_read'
  

  get '/administration/:action' => 'administration', :as => :administration

  get '/privacy' => 'extrapages#privacy_page'
  get '/terms' => 'extrapages#terms'  
  get '/about_us' => 'extrapages#about_us'
  get '/mobile' => 'extrapages#mobile'  
  get '/mobile_info' => 'extrapages#mobile_info'  

  resources :contacts, :only => [:new, :create, :destroy]

  match "/404", :to => "errors#not_found", via: 'get'
  match "/422", :to => "errors#unacceptable", via: 'get'
  match "/500", :to => "errors#internal_error", via: 'get'

  
  resources :errors, :only => [:show]  


  namespace :api, defaults:{format: 'json'} do
    
    resources :users, :only => [:show, :index]
    #devise_for :users, :controllers => { :sessions => "api/sessions", :registrations => "api/registrations"}

    devise_scope :user do
      post   '/users/sign_in'  => 'sessions#create',  as: :user_session
      delete '/users/sign_out' => 'sessions#destroy', as: :destroy_user_session
      post   '/users'  => 'registrations#create',  as: :user_registration

      post  '/users/password'  => 'passwords#create', as: :user_password      
      post "/users/facebook" => "registrations#create_from_facebook", :as => :create_from_facebook

    end

    
    post '/selfies' => 'selfies#timeline', as: :selfies_timeline
    post '/selfies/refresh' => 'selfies#refresh', as: :selfies_refresh
    post '/selfie/approve' => 'selfies#approve', as: :selfie_approve
    post '/selfie/reject' => 'selfies#reject', as: :selfie_reject
    
  end

end
