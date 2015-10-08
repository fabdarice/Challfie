module Api
    class NotificationsController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index
        @notifications = current_user.notifications.order('id DESC').paginate(:page => params[:page], :per_page => 20)
        unread_notifications = current_user.notifications.where(read: 0)
        
        render json: @notifications, meta: {new_alert_nb: unread_notifications.count}
     	end

     	def refresh
	      @notifications = current_user.notifications.where("id >= ? ", params[:last_alert_id]).order('id DESC')
	      unread_notifications = current_user.notifications.where(read: 0)
	      
	      render json: @notifications, meta: {new_alert_nb: unread_notifications.count}
	    end

	    def all_read

        if params[:last_notification_id].blank?          
          current_user.notifications.where(read: false).update_all(read: true)
        else          
          current_user.notifications.where("'read' = false and id <= ?", params[:last_notification_id]).update_all(read: true)
        end
	   	  
        render json: {}
	    end

    end
end
