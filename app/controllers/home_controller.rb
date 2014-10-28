class HomeController < ApplicationController
	before_filter :authenticate_user!

	autocomplete :user, :username, :limit => 10

 	def index 	 		
 		
 		users_following = current_user.following(1)
 		list_following_ids = users_following.map{|u| u.id}
 		list_following_ids << current_user.id
 		
		@selfies = Selfie.where("user_id in (?)", list_following_ids).order("created_at DESC").paginate(:page => params["page"])
		@selfie = Selfie.new
	end

	def auto_refresh
		

		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	    end  
	end

end
