module Api
    class ChallengesController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index    		
    	  books = current_user.books.where('visible = true and active = true').order('level')        
        special_books = Book.where("tier = 0 and visible = true and active = true")

        special_books.each do |special_book|          
          books.unshift(special_book)
        end

        #Create a temporary Daily Book containing the Daily Challenge for Display -->
        daily_book = Book.new(name: "Daily Challenge", level: 0, visible: true, active: true, required_points: 0, tier: 0) 
        daily_challenge = current_user.daily_challenge       
        daily_book.challenges << daily_challenge.challenge if daily_challenge 

        books.unshift(daily_book)


        if current_user.oauth_token.blank? or current_user.uid.blank?
          isFacebookLinked = false
        else
          isFacebookLinked = true          
        end
    	  
        render json: books, meta: {isFacebookLinked: isFacebookLinked}
      end

      def daily_challenge
        dailychallenge = current_user.daily_challenge
        
        if dailychallenge
          render json: {daily_challenge: dailychallenge.challenge.description}
        else
          render json: nil
        end

      end
          
    end
end
