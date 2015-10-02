class HomeController < ApplicationController
	before_filter :authenticate_user!

	autocomplete :user, :username, :limit => 10

 	def index 	 		 		 		
 		users_following = current_user.following(1) 		
 		list_following_ids = users_following.map{|u| u.id}
 		list_following_ids << current_user.id

 		users_following_pending = current_user.following(0)
 		list_following_ids_pending = users_following_pending.map{|u| u.id} 		
 		
		challfie_admin = User.find_by username: "Challfie"

 		if challfie_admin.blank?
 		  @selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false)) and blocked = false and hidden = false", list_following_ids, list_following_ids_pending).order("created_at DESC").paginate(:page => params["page"]).includes(:user, :challenge)        
      else
        @selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false) or (user_id = ? and created_at > ?)) and blocked = false and hidden = false", list_following_ids, list_following_ids_pending, challfie_admin.id, current_user.created_at).order("created_at DESC").paginate(:page => params["page"]).includes(:user, :challenge)        
      end
		
		@selfie = Selfie.new			
	end

	def auto_refresh
		# REFRESH SELFIES ON TIMELINE
		users_following = current_user.following(1)
 		list_following_ids = users_following.map{|u| u.id}
 		list_following_ids << current_user.id

 		users_following_pending = current_user.following(0)
 		list_following_ids_pending = users_following_pending.map{|u| u.id}

 		challfie_admin = User.find_by username: "Challfie"

      if challfie_admin.blank?
        @new_selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false)) and created_at > ? and blocked = false and hidden = false", list_following_ids, list_following_ids_pending, Time.at(params[:after_selfie].to_i)).order("created_at DESC").includes(:user, :challenge)        
      else
        @new_selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false) or (user_id = ? and created_at > ?)) and created_at > ? and blocked = false and hidden = false", list_following_ids, list_following_ids_pending, challfie_admin.id, current_user.created_at, Time.at(params[:after_selfie].to_i)).order("created_at DESC").includes(:user, :challenge)	
      end  		

 		# REFRESH NOTIFICATIONS
 		time_reference = Time.at(Time.now.to_i - (params[:interval].to_i / 1000) - 2)
 		@new_notifications = current_user.notifications.where("created_at > ?", time_reference).order('created_at DESC').includes(:author, :selfie, :book)

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
