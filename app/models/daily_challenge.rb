class DailyChallenge < ActiveRecord::Base
	# attr :challenge_id

	belongs_to :challenge

	def set_daily_challenge_fr		
		daily_challenge_book = Book.where(name: 'DailyChallenge').first
		challenge = daily_challenge_book.challenges.where("point = 0").order('created_at').first

		if challenge.blank?
			random_offset =  daily_challenge_book.challenges.count
			challenge = Challenge.offset(rand(random_offset)).first			
		else
			challenge.point = 20
			challenge.save	
		end
		
		daily_challenge = DailyChallenge.new
		daily_challenge.challenge = challenge 
		if daily_challenge.save			
			daily_challenge.send_daily_challenge_notifications("fr")
		end
	end

	def set_daily_challenge_us
		daily_challenge = DailyChallenge.last
		daily_challenge.send_daily_challenge_notifications("en")		
	end


	def send_daily_challenge_notifications(location)
		User.where(locale: location).each do |user|
			user.add_notifications("Today's <strong>daily challenge</strong> : \"#{self.challenge.description_en}\"", "<strong>Challenge du jour</strong> : \"#{self.challenge.description_fr}\"",  user , nil, nil, Notification.type_notifications[:daily_challenge])				
		end			
	end
	handle_asynchronously :send_daily_challenge_notifications

end
