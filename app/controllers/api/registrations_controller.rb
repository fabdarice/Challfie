module Api
  class RegistrationsController < Devise::RegistrationsController    
    skip_before_filter :verify_authenticity_token
    respond_to :json

    def create
      user = User.new(username: params[:login], firstname: params[:firstname], lastname: params[:lastname], password: params[:password], email: params[:email], from_facebook: params[:from_facebook], from_mobileapp: params[:from_mobileapp])
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
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      auth = {
                :provider => "facebook",
                :uid => params[:uid],
                :info => {
                  :email => params[:email],
                  :name => params[:login],
                  :first_name => params[:firstname],
                  :last_name => params[:lastname],
                  :image => params[:profilepic]
                } 
              }

      resource = User.find_for_facebook_oauth(auth, true)
      if resource.persisted?
        sign_in(:user, resource)
        render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login}
      else
        warden.custom_failure!
        render :json => {:success => false, :message => resource.errors}
      end

    end


    protected

    def invalid_login_attempt
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end
  end
end