class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	
	def new
		@notification = Notification.new
	end

	def create
		@notification = Notification.new(notification_params)	
		challfie = User.find_by username: 'Challfie'

		if challfie 			
			#User.all.each do |user|
			user = User.find_by username: 'fabdR'
				user.add_notifications(@notification.message_en, @notification.message_fr, challfie, nil, nil, Notification.type_notifications[:challfie_message])									
			#end

			flash[:notice] = "Notification has been created."
			render 'new'			
		else
			flash[:alert] = "Challfie user doesn't exists."
			render 'new'
		end	
	end

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

	private
		def notification_params
		  params.require(:notification).permit(:message_fr, :message_en, :type_notification)
		end

end
