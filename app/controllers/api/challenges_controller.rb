module Api
    class ChallengesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index
        challenges = Challenge.all.order('difficulty, point')
        render json: challenges
      end
          
    end
end
