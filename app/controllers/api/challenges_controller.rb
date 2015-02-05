module Api
    class ChallengesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index    		
    	  books = current_user.books.order('level')
    	  #challenges = []
    	  #books.each do |book|
    	  #	challenges << book.challenges.order('difficulty, point')
    	  #end
        #challenges = Challenge.all.order('difficulty, point')
        render json: books
      end
          
    end
end
