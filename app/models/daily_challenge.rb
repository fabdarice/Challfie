class DailyChallenge < ActiveRecord::Base
	# attr :challenge_id

	belongs_to :challenge

	def set_daily_challenge		
		daily_challenge_book = Book.where(name: 'DailyChallenge').first
		challenge = daily_challenge_book.challenges.where("point = 0").order('created_at').first

		if challenge.blank?
			random_offset =  daily_challenge_book.challenges.count
			challenge = daily_challenge_book.challenges.offset(rand(random_offset)).first			
		else
			challenge.point = 20
			challenge.save	
		end
		
		daily_challenge = DailyChallenge.new
		daily_challenge.challenge = challenge 
		daily_challenge.save						
	end

	def send_daily_challenge_notifications					
		daily_challenge = DailyChallenge.last		
		User.all.each do |user|
			current_time = Time.now.in_time_zone(user.timezone)
			if current_time.hour == 5
				user.add_notifications("Today's <strong>daily challenge</strong> : \"#{daily_challenge.challenge.description_en}\"", "<strong>Challenge du jour</strong> : \"#{daily_challenge.challenge.description_fr}\"",  user , nil, nil, Notification.type_notifications[:daily_challenge])	
			end				
		end	
	end

	#handle_asynchronously :send_daily_challenge_notifications_delay

end
