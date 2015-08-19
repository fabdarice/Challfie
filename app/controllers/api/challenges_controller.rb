module Api
    class ChallengesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index    		
    	  books = current_user.books.order('level')

        #Create a temporary Daily Book containing the Daily Challenge for Display -->
        daily_book = Book.new(name: "Daily Challenge", level: 0)
        daily_challenge = DailyChallenge.last
        daily_book.challenges << daily_challenge.challenge if daily_challenge
        books.unshift(daily_book) if daily_challenge

        if current_user.oauth_token.blank? or current_user.uid.blank?
          isFacebookLinked = false
          isPublishPermissionEnabled = false
        else
          isFacebookLinked = true
          isPublishPermissionEnabled = current_user.facebook_info.publish_permissions
        end
    	  
        render json: books, meta: {isFacebookLinked: isFacebookLinked, isPublishPermissionEnabled: isPublishPermissionEnabled}
      end

      def daily_challenge
        dailychallenge = DailyChallenge.last
        if dailychallenge
          render json: {daily_challenge: dailychallenge.challenge.description}
        else
          render json: nil
        end

      end
          
    end
end
