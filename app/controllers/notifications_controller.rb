class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	
	
	def index
		@notifications = current_user.notifications.order('created_at DESC').paginate(:page => params[:page]).includes(:author, :selfie, :book)
	end

	def all_read		
		current_user.notifications.where(read: false).update_all(read: true)
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { render :nothing => true }
	   end  
	end
end
