class ChallengesController < ApplicationController
	def new
		@challenge = Challenge.new
		@category_challenges = @challenge.category_challenges.build
	end

	def create
		@challenge = Challenge.new(challenge_params)
		@challenge.category_challenges.build(params[:category_challenge][:category_ids].map{|cat| {category_id:cat} if !cat.blank?}.compact)
		
		if @challenge.save
			flash[:notice] = "Success : A new challenge has been created."
			redirect_to root_path
		else
			flash[:alert] = "Error : Fail to create a new challenge."
			render 'new'
		end
	end

	def index
		@challenges = Challenge.all
	end

	private
	 def challenge_params
	 	params.require(:challenge).permit(:description, :point, :book_id)
	 end
end
