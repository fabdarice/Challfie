class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  include Rails.application.routes.url_helpers
  include ActionController::Serialization

  protect_from_forgery with: :null_session
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_language
  before_action :check_browser

  layout :layout_by_resource

  # to allow access to current_user on active model serializers
  serialization_scope :view_context


  protected

  def check_browser 
       
    if browser.mobile?
      redirect_to mobile_path
    end        
  end

  def set_user_language    
    #puts I18n.available_locales
    available = %w(en fr)
    I18n.locale = http_accept_language.compatible_language_from(available)    
    #I18n.locale = "fr"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :avatar) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :firstname, :lastname, :email, :password, :password_confirmation, :current_password) }
  end

  
  def authenticate_user_from_token!
    request.env["devise.skip_trackable"] = true        
    login = params[:login].presence
    user       = login && (User.find_by_email(login) || User.find_by_username(login))
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
      sign_in user, store: false      
      return true
    end
    
    render :json=> {:success=>false, :message=>"You need to be authenticate."}, :status=>421
  end

  def layout_by_resource
    if devise_controller?
      'application_not_signed_in'
    else
      'application'
    end
  end
  # This is our new function that comes before Devise's one
  
  def handle_fb_exception exception
    if exception.fb_error_type.eql? 'OAuthException'
      logger.debug "[OAuthException] Either the user's access token has expired, they've logged out of Facebook, deauthorized the app, or changed their password"
      oauth = Koala::Facebook::OAuth.new("602651779842453", "321dc4c41861b95a4f879de8d98b127a", user_omniauth_callback_url(:facebook))   

      # If there is a code in the url, attempt to request a new access token with it
      if params.has_key? 'code'
        code = params['code']
        logger.debug "We have the following code in the url: #{code}"
        logger.debug "Attempting to fetch a new access token..."
        token_hash = oauth.get_access_token_info code
        logger.debug "Obtained the following hash for the new access token:"
        logger.debug token_hash.to_yaml
        redirect_to root_path
      else # Since there is no code in the url, redirect the user to the Facebook auth page for the app
        oauth_url = oauth.url_for_oauth_code :permissions => 'email, user_friends, public_profile, user_birthday, publish_actions, user_photos'
        logger.debug "No code was present; redirecting to the following url to obtain one: #{oauth_url}"
        redirect_to oauth_url
      end
    else
      logger.debug "Since the error type is not an 'OAuthException', this is likely a bug in the Koala gem; reraising the exception..."
      raise exception
    end
  end

  def redirect_if_not_admin
    if current_user.administrator <= 3
      redirect_to root_path
    end
  end

  def initiate_first_book(username)
    user = resource || (User.find_by username: username)

    if user and not user.username.blank?        
      first_level_book = Book.find_by level: 1
      book_users = BookUser.new
      book_users.user = user
      book_users.book = first_level_book
      book_users.save

      # First 200 subscribers
      if User.count < 200
        challfie_special_book = Book.find_by level: 0
        book_users = BookUser.new
        book_users.user = user
        book_users.book = challfie_special_book
        book_users.save
      end
    end
  end


end
