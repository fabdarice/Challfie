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

        if params[:device_token].blank?
          device = Device.find_by user_id: user.id          
        else
          device = Device.find_or_create_by(token: params[:device_token])
        end

        if params[:active].blank?
          active_device = true
        else
          active_device = params[:active]
        end
                
        if not device.blank?        
          device.user = user
          device.active = active_device
          device.type_device = type_device
          device.save
        end

        render json: {}                
      end
    end
end
