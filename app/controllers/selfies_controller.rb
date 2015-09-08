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
		@selfie.shared_fb = true if params[:mysharefacebook] == "1"

		daily_challenge = DailyChallenge.last		
		if daily_challenge != nil and @selfie.challenge == daily_challenge.challenge			
			@selfie.is_daily = true		
		end

		if @selfie.save
			# Share the selfie on Facebook
			if params[:mysharefacebook] == "1"
				@graph = Koala::Facebook::API.new(current_user.oauth_token)
				#puts "FILENAME = " + "#{Rails.root}/public" + current_user.selfies.first.photo.url(:original).split("?")[0]
				#share_post_message = "Challfie Challenge : " + @selfie.challenge.description + "\n\n" + @selfie.message 
				
				@graph.put_picture(@selfie.photo.url(:original).split("?")[0], { "message" => @selfie.message })
				
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
		@users_books = current_user.books.order('level')

	   if params[:search] == 'emptySelection'	    		      
	       daily_book = Book.new(name: "Daily Challenge", level: 0) 
			 daily_challenge = DailyChallenge.last 
			 daily_book.challenges << daily_challenge.challenge if daily_challenge 
			 @users_books.unshift(daily_book) if daily_challenge     
	   else
	      @solr_search = Challenge.search do
	        fulltext params[:search]
	   	end      
	      @challenges = @solr_search.results

		 	newbie_book_one = Book.new(name: "Newbie I", level: 1) 	
			newbie_book_two = Book.new(name: "Newbie II", level: 2) 
			newbie_book_three = Book.new(name: "Newbie III", level: 3) 
			apprentice_one = Book.new(name: "Apprentice I", level: 4) 
			apprentice_two = Book.new(name: "Apprentice I", level: 5) 
			apprentice_three = Book.new(name: "Apprentice I", level: 6) 
			master_one = Book.new(name: "Master I", level: 7) 
			master_two = Book.new(name: "Master I", level: 8) 
			master_three = Book.new(name: "Master I", level: 9) 			 

			@challenges.each do |challenge| 				 
				if @users_books.where(id: challenge.book.id).present? 					 
					newbie_book_one.challenges << challenge if challenge.book.level == 1 
					newbie_book_two.challenges << challenge if challenge.book.level == 2 
					newbie_book_three.challenges << challenge if challenge.book.level == 3   
					apprentice_one.challenges << challenge if challenge.book.level == 4   
					apprentice_two.challenges << challenge if challenge.book.level == 5   
					apprentice_three.challenges << challenge if challenge.book.level == 6   
					master_one.challenges << challenge if challenge.book.level == 7   
					master_two.challenges << challenge if challenge.book.level == 8   
					master_three.challenges << challenge if challenge.book.level == 9   					
				end  
			end 

			@users_books = [] 
			@users_books << newbie_book_one if newbie_book_one.challenges.size != 0 
			@users_books << newbie_book_two if newbie_book_two.challenges.size != 0 
			@users_books << newbie_book_three if newbie_book_three.challenges.size != 0 
			@users_books << apprentice_one if apprentice_one.challenges.size != 0 
			@users_books << apprentice_two if apprentice_two.challenges.size != 0 
			@users_books << apprentice_three if apprentice_three.challenges.size != 0 
			@users_books << master_one if master_one.challenges.size != 0 
			@users_books << master_two if master_two.challenges.size != 0 
			@users_books << master_three if master_three.challenges.size != 0 
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
		# This isn't a destroy permanently, it's updating a Hidden field
	   selfie = Selfie.find(params[:id])

	   selfie_approved = selfie.approval_status	   
	   challenge_points = selfie.challenge.point	   

	   selfie.hidden = true

	   if current_user == selfie.user
			session[:return_to] ||= request.referer
			
			if (selfie.save)
				flash[:notice] = 'Selfie deleted.'				
				
				#Delete Notifications related to that selfie
				notifications_to_delete = Notification.where(selfie_id: params[:id])
				notifications_to_delete.each do |notification|
					notification.destroy
				end

				# Update user points
				# remove points win by this selfie if it was approved
				if selfie_approved == 1							
					current_user.points = current_user.points - challenge_points
					current_user.save
				end
				
			end
			redirect_to session[:return_to]		
		end
	end

	def approve
		@selfie = Selfie.find(params[:id])
		@selfie.vote_by :voter => current_user

		@selfie.set_approval_status!("upvote")

		if @selfie.user != current_user			
			@selfie.user.add_notifications(" has approved your #{@selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{@selfie.challenge.description_en}</i></strong>\".", 
													" a approuvé ton #{@selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{@selfie.challenge.description_fr}</i></strong>\".",
													current_user , @selfie, nil, Notification.type_notifications[:selfie_approval])
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
			@selfie.user.add_notifications(" has rejected your #{@selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{@selfie.challenge.description_en}</i></strong>\".", 
													" a rejeté ton #{@selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{@selfie.challenge.description_fr}</i></strong>\".",
													current_user , @selfie, nil, Notification.type_notifications[:selfie_approval])
		end

		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	   end
	end
		
	
	private
    def selfie_params
      params.require(:selfie).permit(:message, :photo, :challenge_id, :private, :shared_fb, :flag_count, :blocked)
    end

end
