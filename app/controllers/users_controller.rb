class UsersController < ApplicationController
	autocomplete :user, :username

	def show
		@user = User.friendly.find(params[:id])
		@followers = @user.followers(1)		
		if params["tab"] == "timeline"			
			@is_timeline_tab = true			
		else
			@is_timeline_tab = false			
		end
		@selfies = @user.selfies.order("created_at DESC").paginate(:page => params["page"], :per_page => 30)
		@timeline_selfie = @user.selfies.order("created_at DESC").paginate(:page => params["page"])
		@books = Book.all
	end

	def edit
		@user = current_user
	end

	def update
		@user = User.friendly.find(params[:id])		
		if (!params[:mywebcamdata].blank? and params[:myinputtype] == "webcam")
			@user.avatar = params[:mywebcamdata]
			@user.avatar_file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_user_webcamupload.jpg"
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
		flash[:notice] = "You are now following #{@user.username}."
		
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end  
	end

	def unfollow
		@user = User.friendly.find(params[:id])
		current_user.stop_following(@user)
		flash[:notice] = "You are now unfollowing #{@user.username}."
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end  
	end

	def friends
		@user = current_user
		# LIST OF ALL FRIEND FOLLOWING
		@following = current_user.all_following;		 
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
		user_link = view_context.link_to current_user.username, user_path(current_user)
		
		@user.add_notifications("#{user_link} has accepted your <strong>following request</strong>.", current_user , nil, nil)
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
			fulltext params[:user_input]
			paginate :page => 1, :per_page => 10
		end

		@users = search.results		
		list = @users.map {|u| Hash[id: u.id, label: u.username, name: u.username, imgsrc: u.show_profile_picture, slug: u.slug, mutualfriends: current_user.number_mutualfriends(u)]}
    	render json: list		
	end


	private
		def users_params
			params.require(:user).permit(:username, :firstname, :lastname, :email, :avatar, :password)
		end
end
