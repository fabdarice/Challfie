module Api
    class NotificationsController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index
        @notifications = current_user.notifications.order('created_at DESC').paginate(:page => params[:page])
        unread_notifications = current_user.notifications.where(read: 0)
        
        render json: @notifications, meta: {new_alert_nb: unread_notifications.count}
     	end

     	def refresh
	      @notifications = current_user.notifications.where("id > ? ", params[:last_alert_id]).order('created_at DESC')
	      unread_notifications = current_user.notifications.where(read: 0)
	      
	      render json: @notifications, meta: {new_alert_nb: unread_notifications.count}
	   end

	   def all_read
	   	current_user.notifications.where(read: false).update_all(read: true)
      render json: {}
	   end

    end
end
