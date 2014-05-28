module Api
  class RegistrationsController < Devise::RegistrationsController    
    skip_before_filter :verify_authenticity_token
    respond_to :json

    def create
      user = User.new(username: params[:login], password: params[:password], email: params[:email])
      user.skip_confirmation! 
      if user.save
        render :json=> {:success => true, :auth_token => user.authentication_token, :login => user.username}
        return
      else
        warden.custom_failure!
        render :json => {:success => false, :message => user.errors}
      end
    end


    protected

    def invalid_login_attempt
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end
  end
end