class DailyChallenge < ActiveRecord::Base
	# attr :challenge_id

	belongs_to :challenge

	def set_daily_challenge		
		c = Challenge.count
		random_challenge = Challenge.offset(rand(c)).first
		daily_challenge = DailyChallenge.new
		daily_challenge.challenge = random_challenge
		daily_challenge.save
	end

end
