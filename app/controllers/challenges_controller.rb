class ChallengesController < ApplicationController
	def new
		@challenge = Challenge.new
		@category_challenges = @challenge.category_challenges.build
	end

	def create
		@challenge = Challenge.new(challenge_params)
		
		if @challenge.save
			flash[:notice] = "Success : A new challenge has been created."
			redirect_to controller:'administration', action:'challenges'
		else
			flash[:alert] = "Error : Fail to create a new challenge."
			render 'new'
		end
	end

	def index
		@challenges = Challenge.all
	end

	def edit
		@challenge = Challenge.find(params[:id])
	end

	def update
		@challenge = Challenge.find(params[:id])
		@challenge.update_attributes(challenge_params)
		if @challenge.save
			redirect_to controller:'administration', action:'challenges'
		else
			render 'edit'
		end
	end

	def destroy
		challenge = Challenge.find(params[:id])
		session[:return_to] ||= request.referer
		if (challenge.destroy)
		flash[:notice] = 'Challenge deleted.'
		end
		redirect_to controller:'administration', action:'challenges'
	end

	

	private
	 def challenge_params
	 	params.require(:challenge).permit(:description, :point, :book_id, :category_ids => [])
	 end
end
