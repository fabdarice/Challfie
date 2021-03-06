module NotificationsHelper
	def display_notification_message(notif_obj)				
		msg = ""
		if notif_obj.comment_mine? or notif_obj.comment_other? or notif_obj.selfie_approval? or notif_obj.friend_request? or notif_obj.matchup?
	   	msg = link_to "#{notif_obj.author.username}", user_path(notif_obj.author)  	        
	   end
	   
	   # when Notification.selfie_approval

	   # when Notification.selfie_status

	   # when Notification.friend_request

	   # when Notification.book_unlock 
	   msg = msg + raw(notif_obj.message)	   	     
	end

	def cache_key_for_notifications
	    count          = Notification.count
	    max_updated_at = Notification.maximum(:updated_at).try(:utc).try(:to_s, :number)
	    "notifications/all-#{count}-#{max_updated_at}"
	end
end
