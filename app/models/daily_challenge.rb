class DailyChallenge < ActiveRecord::Base
	# attr :challenge_id

	belongs_to :challenge
	has_many :users

	def set_daily_challenge		
		daily_challenge_book = Book.where(name: 'DailyChallenge').first

		challenge = daily_challenge_book.challenges.where("priority > 0").order('priority DESC').first
		challenge = daily_challenge_book.challenges.where("point = 0").order('created_at').first if challenge.blank?

		if challenge.blank?
			random_offset =  daily_challenge_book.challenges.count
			challenge = daily_challenge_book.challenges.offset(rand(random_offset)).first			
		else
			challenge.point = 20
			challenge.priority = 0
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
				user.add_notifications("Today's <strong>daily challenge</strong> : \"#{daily_challenge.challenge.description_en}\"", "<strong>Challenge du jour</strong> : \"#{daily_challenge.challenge.description_fr}\"",  user , nil, nil, Notification.type_notifications[:daily_challenge], nil)	
				user.daily_challenge = daily_challenge
				user.save

=begin
# If I ever want to implement Daily Matchup
				matchup_opponent = user.find_user_daily_matchups
				if matchup_opponent
					user.create_daily_matchup(matchup_opponent, Matchup.type[:daily], 1.day.from_now, daily_challenge)
				else
					user.add_notifications("Today's <strong>daily challenge</strong> : \"#{daily_challenge.challenge.description_en}\"", "<strong>Challenge du jour</strong> : \"#{daily_challenge.challenge.description_fr}\"",  user , nil, nil, Notification.type_notifications[:daily_challenge], nil)	
				end		
=end				
			end				
		end	
	end

	#handle_asynchronously :send_daily_challenge_notifications_delay

end
