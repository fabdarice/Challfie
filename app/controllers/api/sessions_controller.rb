module Api
  class SessionsController < Devise::SessionsController

    skip_before_filter  :verify_authenticity_token
    before_filter :ensure_params_exist, :only => [:create ]

    before_filter :authenticate_user!, :except => [:create, :destroy]

    skip_before_filter  :verify_authenticity_token, :only => [:create]
    respond_to :json

    def create
      resource = User.find_for_database_authentication(:username => params[:login]) || User.find_for_database_authentication(:email => params[:login])
      return invalid_login_attempt unless resource

      if resource.blocked == true
        render :json=> {:success=>false, :message=> I18n.translate('sign_in.account_blocked')}, :status=>401
        return
      end

      if params[:timezone].blank?
        params[:timezone] = "Europe/Paris"
      end

      if params[:password]
        if resource.valid_password?(params[:password])
          resource.update(locale: I18n.locale, timezone: params[:timezone])
          sign_in(:user, resource)                  
          render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :username_activated => resource.username_activated}
          return
        end
      end

      if params[:token]
        if resource.authentication_token == params[:token]
          resource.update(locale: I18n.locale, timezone: params[:timezone])
          sign_in(:user, resource)        
          render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :username_activated => resource.username_activated}
          return
        end        
      end

      invalid_login_attempt
    end

    #def destroy
     # sign_out(resource_name)
    #end

    protected
    def ensure_params_exist
      return unless params[:login].blank?
      render :json=>{:success=>false, :message=> I18n.translate('sign_in.missing_username')}, :status=>401
    end

    def invalid_login_attempt
      render :json=> {:success=>false, :message=> I18n.translate('sign_in.error_login_or_password')}, :status=>401
    end
  end
end