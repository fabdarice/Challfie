class SelfiesController < ApplicationController
	before_filter :authenticate_user!
	

	def new
		@selfie = Selfie.new
	end

	def create
		@selfie = Selfie.new(selfie_params)
				
		# Selfie has been taken with laptop/desktop Webcam		
		if (!params[:mywebcamdata].blank? and params[:myinputtype] == "webcam")			
			@selfie.photo = params[:mywebcamdata]
			@selfie.photo_file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_selfie_webcamupload.jpg"
		end

		@selfie.user = current_user

		if @selfie.save
			# Share the selfie on Facebook
			if params[:mysharefacebook] == "1"
				@graph = Koala::Facebook::API.new(current_user.oauth_token)
				#puts "FILENAME = " + "#{Rails.root}/public" + current_user.selfies.first.photo.url(:original).split("?")[0]
				share_post_message = "Challfie Challenge : " + @selfie.challenge.description + "\n\n" + @selfie.message 
				@graph.put_picture("#{Rails.root}/public" + @selfie.photo.url(:original).split("?")[0], { "message" => share_post_message })
			end	

			redirect_to root_path
		else
			render 'selfies/new'
		end
	end

	def show		
		@selfie = Selfie.find(params[:id])

		if @selfie.private and @selfie.user != current_user			
			if !current_user.is_following?(@selfie.user)
				render 'selfies/restricted'				
			else
				render :layout => false
			end			
		else			
			render :layout => false
		end				
	end

	def filter_by_keyword
	    if params[:search] == 'emptySelection'
	      @challenges = Challenge.all
	    else
	      @solr_search = Challenge.search do
	        fulltext params[:search]
	      end      
	      @challenges = @solr_search.results
	    end

	    respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	    end
	end

	def update
		@selfie = Selfie.find(params[:id])		
		@selfie.update_attributes(selfie_params)		
		@selfie.save

		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	    end
	end

	def destroy
	   selfie = Selfie.find(params[:id])
		session[:return_to] ||= request.referer
		if (selfie.destroy)
		flash[:notice] = 'Book deleted.'
		end
		redirect_to session[:return_to]
	end

	def approve
		@selfie = Selfie.find(params[:id])
		@selfie.vote_by :voter => current_user

		@selfie.set_approval_status!("upvote")

		if @selfie.user != current_user
			user_link = view_context.link_to current_user.username, user_path(current_user)			
			@selfie.user.add_notifications("#{user_link} has approved your challenge <strong><i>#{@selfie.challenge.description_en}</i></strong>.", 
													"#{user_link} a approuvé ton challenge <strong><i>#{@selfie.challenge.description_fr}</i></strong>.",
													current_user , @selfie, nil)
		end
		
		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end
	end

	def disapprove
		@selfie = Selfie.find(params[:id])
		@selfie.downvote_from current_user

		@selfie.set_approval_status!("downvote")

		if @selfie.user != current_user
			user_link = view_context.link_to current_user.username, user_path(current_user)			
			@selfie.user.add_notifications("#{user_link} has rejected your challenge <strong><i>#{@selfie.challenge.description_en}</i></strong>.", 
													"#{user_link} a rejeté ton challenge <strong><i>#{@selfie.challenge.description_fr}</i></strong>.",
													current_user , @selfie, nil)
		end

		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end
	end
		
	
	private
    def selfie_params
      params.require(:selfie).permit(:message, :photo, :challenge_id, :private)
    end

end
