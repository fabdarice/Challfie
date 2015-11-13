module Api
	class MatchupsController < ApplicationController
		skip_before_filter  :verify_authenticity_token
      before_filter :authenticate_user_from_token!
      respond_to :json

		def index
					
		end

		def active_matchups
			matchups = []

			pending_matchups = current_user.matchups.where(status: Matchup.statuses[:pending])
			pending_matchups.each do |pending_matchup|
				matchups << pending_matchup
			end

			inprogress_matchups = current_user.matchups.where(status: Matchup.statuses[:accepted])
			inprogress_matchups.each do |inprogress_matchup|
				matchups << inprogress_matchup
			end

			render json: matchups
		end

		def complete_matchups
			matchups = current_user.matchups.complete
			render json: matchups
		end

		def accept_reject_matchup
			matchup = Matchup.find(params[:matchup_id])
			if matchup and current_user.matchups.where(id: matchup.id, status: Matchup.statuses[:pending]).count != 0			
				matchup.status = params[:matchup_status].to_i
				matchup.end_date = Time.now + matchup.duration.days
				
				if matchup.save					
					if params[:matchup_status].to_i == Matchup.statuses[:accepted]				
						matchup.matchup_users.each do |matchup_user|
							if matchup_user.is_creator == true								
								creator = matchup_user.user
								puts creator.username
								creator.add_notifications(" has agreed to your <strong>duel</strong> for [\"#{matchup.challenge.description_en}\"]", 
                              " a accepté <strong>ton duel</strong> pour [\"#{matchup.challenge.description_fr}\"]",
                              current_user, nil, nil, Notification.type_notifications[:matchup], matchup)
							end
						end						
					end
					render json: matchup
				else
					render json: {}
				end
			else
				render json: {}
			end
		end

		def new
         opponent = User.friendly.find(params[:opponent_id])

         if opponent
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

	        current_user_profile_pic = current_user.show_profile_picture("medium")
	        current_user_stats = current_user.nb_win_matchups.to_s + "-" + current_user.nb_lose_matchups.to_s

	        opponent_user_stats = opponent.nb_win_matchups.to_s + "-" + opponent.nb_lose_matchups.to_s
	    	  
	        render json: books, meta: {userProfilPic: current_user_profile_pic, currentUserStats: current_user_stats, opponentStats: opponent_user_stats}  
	      else
	      	render json: nil
	      end    
		end

		def create			
			if params[:opponent_id].blank? or params[:duration].blank? or (params[:description].blank? and params[:challenge_id].blank?)
				puts "params[:opponent_id].blank? or params[:duration].blank? or (params[:description].blank? and params[:challenge_id].blank?)"
				render :json=> {:success=>false}
				return
			end

			if params[:challenge_id].blank?
				# Create Own Challenge
				custom_challenge_book = Book.find_by name: "Custom User Challenge"
				if custom_challenge_book
					challenge = Challenge.new(description_en: params[:description], description_fr: params[:description], point: 0, difficulty: 0, priority: 0)
					challenge.book = custom_challenge_book
					if not challenge.save
						puts "if not challenge.save"
						render :json=> {:success=>false}
						return
					end
				else
					puts "custom_challenge_book"
					render :json=> {:success=>false}
					return
				end				
			else
				# Chose among existing Challenges
				challenge = Challenge.find(params[:challenge_id])
			end
			
			opponent = User.friendly.find(params[:opponent_id])			

			if challenge.blank? or opponent.blank?		
				puts "challenge or opponent"				
				render :json=> {:success=>false}
				return
			end
			
			if current_user.challenge_matchup(opponent, challenge, Matchup.type_matchups[:one_vs_one], Matchup.statuses[:pending], params[:duration]) 
				# Successfully created the matchup
				render :json=> {:success=>true}
				return
			else	
				puts "current_user.challenge_matchup(opponent, challenge, Matchup.statuses[:pending], params[:duration]) "
				render :json=> {:success=>false}
				return
			end
		end

	end
end
