module Api
  class SessionsController < Devise::SessionsController
    before_filter :ensure_params_exist, :only => [:create ]

    before_filter :authenticate_user!, :except => [:create, :destroy]

    skip_before_filter  :verify_authenticity_token, :only => [:create]
    respond_to :json

    def create
      resource = User.find_for_database_authentication(:username => params[:login]) || User.find_for_database_authentication(:email => params[:login])
      return invalid_login_attempt unless resource

      if params[:password]
        if resource.valid_password?(params[:password])
          sign_in(:user, resource)        
          render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login}
          return
        end
      end

      if params[:token]
        if resource.authentication_token == params[:token]
          sign_in(:user, resource)        
          render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login}
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
      render :json=>{:success=>false, :message=>"Missing username parameter"}, :status=>422
    end

    def invalid_login_attempt
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end
  end
end