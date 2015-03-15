module Api
    class DevicesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def create        
        user = User.find_by username: params[:login]
        device = Device.find_or_create_by(token: params[:device_token])
        device.user = user
        device.save
        render json: {}                
      end
    end
end
