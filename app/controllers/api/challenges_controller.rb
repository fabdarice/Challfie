module Api
    class ChallengesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index    		
    	  books = current_user.books.order('level')

        if current_user.oauth_token.blank? or current_user.uid.blank?
          isFacebookLinked = false
        else
          isFacebookLinked = true
        end
    	  
        render json: books, meta: {isFacebookLinked: isFacebookLinked}
      end
          
    end
end
