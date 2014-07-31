class UsersController < ApplicationController
	def edit
		@user = User.friendly.find(params[:id])
	end

	def update
		@user = User.friendly.find(params[:id])
		@user.update_attributes(users_params)
		if @user.save
			redirect_to root_path
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
		# LIST OF ALL FRIEND FOLLOWING
		@following = current_user.all_following;
		 
		# LIST OF ALL FOLLOWERS
		@followers = current_user.followers(true)

		# LIST OF ALL PENDING REQUEST
		@pending_request = current_user.followers(false)
	end

	def accept_request
		@user = User.friendly.find(params[:id])
		@follow = Follow.find_by followable_id: current_user.id, follower_id: @user.id
		@follow.status = 1
		@follow.save
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end 
	end

	def remove_follower
		@user = User.friendly.find(params[:id])
		@user.stop_following(current_user)
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end 
	end

	private
		def users_params
			params.require(:user).permit(:username, :firstname, :lastname, :email, :avatar, :password)
		end
end
