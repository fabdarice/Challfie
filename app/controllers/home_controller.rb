class HomeController < ApplicationController
	before_filter :authenticate_user!

	autocomplete :user, :username, :limit => 10

 	def index 	 		 		
 		users_following = current_user.following(1)
 		list_following_ids = users_following.map{|u| u.id}
 		list_following_ids << current_user.id
 		
		@selfies = Selfie.where("user_id in (?)", list_following_ids).order("created_at DESC").paginate(:page => params["page"]).includes(:user, :challenge, comments: [:user])
		@selfie = Selfie.new
		
	end

	def auto_refresh
		# REFRESH SELFIES ON TIMELINE
		users_following = current_user.following(1)
 		list_following_ids = users_following.map{|u| u.id}
 		list_following_ids << current_user.id  
 		@new_selfies = Selfie.where("user_id in (?) and created_at > ?", list_following_ids, Time.at(params[:after_selfie].to_i)).order("created_at DESC")

 		# REFRESH NOTIFICATIONS
 		time_reference = Time.at(Time.now.to_i - (params[:interval].to_i / 1000) - 2)
 		@new_notifications = current_user.notifications.where("created_at > ?", time_reference).order('created_at DESC')

 		# REFRESH FRIENDS REQUEST
 		user_followers = Follow.where('status = 0 and followable_id = ? and blocked = false and created_at > ?', current_user.id, time_reference)
 		@new_friends_requests = []
	   user_followers.each do |f|
	      user = User.friendly.find(f.follower_id)
	   	@new_friends_requests << user
    	end
    	
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	    end  
	end

end
