class Matchup < ActiveRecord::Base
	#:challenge_id, :winner_id, :type, :end_date, :duration, :status

	# Enum for Type & Status
   enum type_matchup: { one_vs_one: 0 }
   enum status: { pending: 0, accepted: 1, declined: 2, ended: 3, ended_with_draw: 4 }

	belongs_to :challenge
	belongs_to :winner, class_name: "User"
	has_many :selfies
	has_many :users, :through => :matchup_users
  	has_many :matchup_users

  	scope :pending, where(status: self.statuses[:pending])
  	scope :in_progress, where(status: 1)
  	scope :complete, where("status=? or status=?", self.statuses[:ended], self.statuses[:ended_with_draw])

  	def scheduled_set_matchup_results
      matchups = Matchup.where("end_date < ? and status = ?", Time.now, Matchup.statuses[:accepted])
      matchups.each do |matchup|
      	selfies = matchup.selfies

      	winning_selfie = nil
      	winning_selfie_nb_approval = -1
      	is_draw = false

      	selfies.each do |selfie|
      		if selfie.get_upvotes.size == winning_selfie_nb_approval
      			is_draw = true      			
      		end
      		if selfie.get_upvotes.size > winning_selfie_nb_approval
      			winning_selfie = selfie
      			winning_selfie_nb_approval = selfie.get_upvotes.size
      			is_draw = false
      		end
      	end

      	if is_draw or winning_selfie.blank?
      		matchup.status = Matchup.statuses[:ended_with_draw]
      		matchup.users.each do |user|
      			user.add_notifications(" , it's a tie in the <strong>selfie duel</strong> : \"#{matchup.challenge.description_en}\"", 
      										  " , match nul pour ton <strong>selfie duel</strong> : \"#{matchup.challenge.description_fr}\"",  user , nil, nil, Notification.type_notifications[:matchup], matchup)	
      		end
      		
      	else
      		matchup.status = Matchup.statuses[:ended]
      		matchup.winner = winning_selfie.user
      		matchup.users.each do |user|      			
      			user.add_notifications(" is the winner of the <strong>selfie duel</strong> : \"#{matchup.challenge.description_en}\"", 
      										  " est le vainqueur du <strong>selfie duel</strong> : \"#{matchup.challenge.description_fr}\"",  winning_selfie.user , nil, nil, Notification.type_notifications[:matchup], matchup)	      			
      		end   

      		# Update User's points
      		challenge_very_easy = winning_selfie.user.current_book.challenges.where("difficulty = 1").first							
				challenge_value = challenge_very_easy.point															
				winning_selfie.user.update_column(:points, challenge_value + winning_selfie.user.points)	
				winning_selfie.user.unlock_book!												
      	end 

      	matchup.save
      end
  end

end
