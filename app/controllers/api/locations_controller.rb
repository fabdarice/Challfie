module Api
  class LocationsController < ApplicationController
    #doorkeeper_for :all

    before_filter :authenticate_user_from_token!

    before_filter :authenticate_user!
  
    # !!!!!!!!!!!!!!!!!! CHECK IF ALTERNATIVE SOLUTION . I.E OAUTH2 !!!!!!!!!!!!!!!!!!!
    skip_before_filter  :verify_authenticity_token, :only => [:create]


    respond_to :json

    def index
      respond_with Location.all
    end

    def show
      respond_with User.find(params[:id])
    end

    def create
      # respond_with User.create(access_token: params[:access_token], city: params[:city], created_at: Time.now, phone: params[:phone], region: params[:region], updated_at: Time.now)
      @location = Location.create(name: params[:name], address: params[:address], latitude: params[:latitude], longitude: params[:longitude])      
      respond_to do |format|
        if @location.save
          format.json {render json: @location}
        else
          format.json {render json: {:error_message => @location.error, :status => 402}}
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
     
        if user
         puts 'User = ' + user.email
       end
        # Notice how we use Devise.secure_compare to compare the token
        # in the database with the token given in the params, mitigating
        # timing attacks.
        if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
          sign_in user, store: false
        end
      end
    
  end
end