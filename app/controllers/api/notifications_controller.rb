module Api
    class NotificationsController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index
        @notifications = current_user.notifications.order('created_at DESC').paginate(:page => params[:page])
        render json: @notifications
    end
end
