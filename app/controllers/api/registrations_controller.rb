module Api
  class RegistrationsController < Devise::RegistrationsController    
    skip_before_filter :verify_authenticity_token
    after_action :only => :create do
      initiate_first_book(params[:login])
    end

    respond_to :json

    def create
      user = User.new(username: params[:login], firstname: params[:firstname], lastname: params[:lastname], password: params[:password], 
                      email: params[:email], from_facebook: params[:from_facebook], from_mobileapp: params[:from_mobileapp], username_activated: true, locale: I18n.locale)
      user.skip_confirmation! 
      if user.save        
        render :json=> {:success => true, :auth_token => user.authentication_token, :login => user.username}
        return
      else
        warden.custom_failure!
        if params[:password].length < 6
          statuscode = 402
        elsif !(params[:login] =~ /\A[a-zA-Z\d]+\z/)
          statuscode = 403
        elsif (User.where(username: params[:login]).count == 1 || User.where(email: params[:email]).count == 1)
          statuscode = 404
        else
          statuscode = 401  
        end

        render :json => {:success => false, :message => user.errors}, :status=>statuscode
      end
    end

    def create_from_facebook        
      params[:email] = params[:uid].to_s + "@facebook.com" if params[:email].blank?      

      if params[:timezone].blank?
        params[:timezone] = "France"
      end

      auth = {
                :provider => "facebook",
                :uid => params[:uid],
                :info => {
                  :email => params[:email],
                  :name => params[:login],
                  :first_name => params[:firstname],
                  :last_name => params[:lastname],
                  :image => params[:profilepic]
                }, 
                :credentials => {
                  :token => params[:fbtoken],
                  :expires_at => params[:fbtoken_expires_at]
                },
                :extra => {
                  :raw_info => {
                    :locale => params[:fb_locale]
                  }
                }
              }

      resource = User.find_for_facebook_oauth(auth, true, params[:timezone])

      if resource
        if !user_signed_in?                  
          sign_in(:user, resource)
        end        
        render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :username_activated => resource.username_activated}
      else
        warden.custom_failure!
        render :json => {:success => false, :message => "Couln't create your account from Facebook. Please contact Challfie support on the website."}
      end
    end

    
    protected

    def invalid_login_attempt
      render :json=> {:success=>false, :message=> I18n.translate('sign_in.error_login_or_password')}, :status=>401
    end
  end
end