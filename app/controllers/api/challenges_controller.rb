module Api
    class ChallengesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index    		
    	  books = current_user.books.where('level > 0 and visible = true and active = true').order('level')

        #Create a temporary Daily Book containing the Daily Challenge for Display -->
        daily_book = Book.new(name: "Daily Challenge", level: 0)

        current_user_time = Time.now.in_time_zone(current_user.timezone)        
        if current_user_time.hour < 5
          daily_challenge = DailyChallenge.offset(1).last
        else
          daily_challenge = DailyChallenge.last
        end         
        daily_book.challenges << daily_challenge.challenge if daily_challenge
        books.unshift(daily_book) if daily_challenge

        if current_user.oauth_token.blank? or current_user.uid.blank?
          isFacebookLinked = false
        else
          isFacebookLinked = true          
        end
    	  
        render json: books, meta: {isFacebookLinked: isFacebookLinked}
      end

      def daily_challenge
        current_user_time = Time.now.in_time_zone(current_user.timezone)
        
        if current_user_time.hour < 5
          dailychallenge = DailyChallenge.offset(1).last                    
        else
          dailychallenge = DailyChallenge.last
        end
        
        if dailychallenge
          render json: {daily_challenge: dailychallenge.challenge.description}
        else
          render json: nil
        end

      end
          
    end
end
