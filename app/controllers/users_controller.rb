class UsersController < ApplicationController
	autocomplete :user, :username
	before_filter :authenticate_user!

	def show
		@user = User.friendly.find(params[:id])
		@followers = @user.followers(1)		
		if params["tab"] == "timeline"			
			@is_timeline_tab = true			
		else
			@is_timeline_tab = false			
		end
		@selfies = @user.selfies.where("blocked = false and hidden = false").order("created_at DESC").paginate(:page => params["page"], :per_page => 20)
		@timeline_selfie = @user.selfies.where("blocked = false and hidden = false").order("created_at DESC").paginate(:page => params["page"]).includes(:challenge)
		@books = Book.where("visible = true and active = true and tier > 0").order(tier: :asc, level: :asc)
	end

	def edit
		@user = current_user
	end

	def update		
		@user = User.friendly.find(params[:id])		
		if (!params[:mywebcamdata].blank? and params[:myinputtype] == "webcam")
			@user.avatar = params[:mywebcamdata]
			@user.avatar_file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_userprofile_webcamupload.jpg"
		else
			@user.update_attributes(users_params)
		end
		if @user.save
			redirect_to user_path(@user)
		else
			render 'edit'
		end
	end

	def follow
		@user = User.friendly.find(params[:id])
		current_user.follow(@user)
		@user.add_notifications(" has requested to follow you.", 
										" souhaite faire parti de ta liste d'abonnées.",
										current_user , nil, nil, Notification.type_notifications[:friend_request])
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end  
	end

	def unfollow
		@user = User.friendly.find(params[:id])
		current_user.stop_following(@user)
		flash[:notice] = "You unfollowed #{@user.username}."
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end  
	end

	def friends
		@user = current_user
		# LIST OF ALL FRIEND FOLLOWING
		@following = current_user.all_following
		@following = @following.sort_by {|u| u.username.downcase}
		# LIST OF ALL FOLLOWERS
		@followers = current_user.followers(1)
		# LIST OF ALL PENDING REQUEST
		@pending_request = current_user.followers(0)

		@friends_suggestions = @user.friends_suggestions
	end

	def accept_request
		@user = User.friendly.find(params[:id])
		@follow = Follow.find_by followable_id: current_user.id, follower_id: @user.id
		@follow.status = 1
		@follow.save			
		@user.add_notifications(" has accepted your <strong>request</strong>.", 
										" a accepté ta <strong>demande d'abonnement</strong>.",
										current_user , nil, nil, Notification.type_notifications[:friend_request])
		@followers = current_user.followers(1)
		@pending_request = current_user.followers(0)
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end 
	end

	def remove_follower
		@user = User.friendly.find(params[:id])
		@user.stop_following(current_user)
		@pending_request = current_user.followers(0)
		@followers = current_user.followers(1)
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end 
	end

	def block
		@user = User.friendly.find(params[:id])
		current_user.block(@user)
		@pending_request = current_user.followers(0)
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end 
	end

	def autocomplete_search_user		
		search = User.search do
			fulltext params[:user_input].gsub("@", " ")
			paginate :page => 1, :per_page => 10
		end

		@users = search.results		

		list = @users.map {|u| Hash[id: u.id, label: u.username, name: u.username, imgsrc: u.show_profile_picture("thumb"), slug: u.slug, mutualfriends: current_user.number_mutualfriends(u)]}
    	render json: list		
	end


	private
		def users_params
			params.require(:user).permit(:username, :firstname, :lastname, :email, :avatar, :password, :blocked)
		end
end
