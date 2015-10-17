module Api
    class ChallengesController < ApplicationController
      skip_before_filter  :verify_authenticity_token
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index    		
    	  books = current_user.books.where('visible = true and active = true').order('level')        
        special_books = Book.where("tier = 0 and visible = true and active = true")

        special_books.each do |special_book|          
          books.unshift(special_book)
        end

        #Create a temporary Daily Book containing the Daily Challenge for Display -->
        daily_book = Book.new(name: I18n.translate('selfie.daily_challenge_title'), level: 0, visible: true, active: true, required_points: 0, tier: 0) 
        daily_challenge = current_user.daily_challenge       
        daily_book.challenges << daily_challenge.challenge if daily_challenge 

        books.unshift(daily_book)            

        if current_user.oauth_token.blank? or current_user.uid.blank?
          isFacebookLinked = false
        else
          begin  
            isFacebookLinked = true              
            @graph = Koala::Facebook::API.new(current_user.oauth_token)

            permissions = @graph.get_connections("me", "permissions")
            permissions_existence = permissions.any? {|permissions| permissions["permission"] == "user_friends"} && 
                                      permissions.any? {|permissions| permissions["permission"] == "public_profile"} &&
                                      permissions.any? {|permissions| permissions["permission"] == "email"} &&
                                      permissions.any? {|permissions| permissions["permission"] == "publish_actions"}

            if permissions_existence == true
              permissions.each do |permission|                              
              case permission["permission"]
                when "user_friends"
                  if permission["status"] != "granted"
                    isFacebookLinked = false
                    break
                  end
                when "public_profile"
                  if permission["status"] != "granted"                    
                    isFacebookLinked = false
                    break
                  end
                when "email"
                  if permission["status"] != "granted"                    
                    isFacebookLinked = false
                    break
                  end
                when "publish_actions"
                  if permission["status"] != "granted"                                      
                    isFacebookLinked = false
                    break
                  end
                else
                  # DO NOTHING
                end
              end
            else
              isFacebookLinked = false
            end

          rescue Koala::Facebook::APIError 
            logger.info "[OAuthException] Either the user's access token has expired, they've logged out of Facebook, deauthorized the app, or changed their password"            
            current_user.oauth_token = nil 
            current_user.save       
            isFacebookLinked = false
          end           
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
