module Api
  class SelfiesController < ApplicationController

    before_filter :authenticate_user_from_token!
    skip_before_filter  :verify_authenticity_token, :only => [:create]

    respond_to :json

    def index
      respond_with Selfie.all
    end

    def show
      respond_with Selfie.find(params[:id])
    end

    def create
      # respond_with User.create(access_token: params[:access_token], city: params[:city], created_at: Time.now, phone: params[:phone], region: params[:region], updated_at: Time.now)
      @selfie = Selfie.create(name: params[:message])      
      respond_to do |format|
        if @selfie.save
          format.json {render json: @selfie}
        else
          format.json {render json: {:error_message => @selfie.error, :status => 402}}
        end
      end
    end

    def update
#                  respond_with User.update(params[:id], params[:users])

    end

    def destroy
      #            respond_with User.destroy(params[:id])

    end

    private
  
      def authenticate_user_from_token!
        login = params[:login].presence
        user       = login && (User.find_by_email(login) || User.find_by_username(login))
   
        # Notice how we use Devise.secure_compare to compare the token
        # in the database with the token given in the params, mitigating
        # timing attacks.
        if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
          sign_in user, store: false
        end
      end
    
  end
end