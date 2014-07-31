Challfie::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  resources :locations
  resources :selfies do
    resources :comments
  end
  resources :books
  resources :categories
  resources :challenges
  get '/selfies/filter/:search' => 'selfies#filter_by_keyword', as: :selfie_filter

  resources :users do
    member do
      get :follow
      get :unfollow
      get :friends
      get :accept_request
      get :remove_follower
    end
  end

  get '/administration/:action' => 'administration', :as => :administration


  namespace :api, defaults:{format: 'json'} do
    resources :locations
    resources :users, :only => [:show, :index]
    #devise_for :users, :controllers => { :sessions => "api/sessions", :registrations => "api/registrations"}

    devise_scope :user do
      post   '/users/sign_in'  => 'sessions#create',  as: :user_session
      delete '/users/sign_out' => 'sessions#destroy', as: :destroy_user_session
      post   '/users'  => 'registrations#create',  as: :user_registration

      post  '/users/password'  => 'passwords#create', as: :user_password
      put   '/users/password'  => 'passwords#update', as: nil
      patch '/users/password'  => 'passwords#update', as: nil
      post "/users/facebook" => "registrations#create_from_facebook", :as => :create_from_facebook

    end
  end

end
