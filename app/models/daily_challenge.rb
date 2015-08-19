class DailyChallenge < ActiveRecord::Base
	# attr :challenge_id

	belongs_to :challenge

	def set_daily_challenge		
		c = Challenge.count
		random_challenge = Challenge.offset(rand(c)).first
		daily_challenge = DailyChallenge.new
		daily_challenge.challenge = random_challenge
		if daily_challenge.save			
			daily_challenge.send_daily_challenge_notifications
		end
	end


	def send_daily_challenge_notifications
		User.all.each do |user|
			user.add_notifications("Today's <strong>daily challenge</strong> : \"#{self.challenge.description_en}\"", "<strong>Challenge du jour</strong> : \"#{self.challenge.description_fr}\"",  user , nil, nil, Notification.type_notifications[:daily_challenge])				
		end			
	end
	handle_asynchronously :send_daily_challenge_notifications

end
