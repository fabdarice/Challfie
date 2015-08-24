module Api
    class DevicesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def create        
        user = User.find_by username: params[:login]

        if params[:type_device].blank?
          type_device = 0
        else
          type_device = params[:type_device]
        end

        device = Device.find_or_create_by(token: params[:device_token], type_device: type_device)        
        device.user = user
        device.save
        render json: {}                
      end
    end
end
