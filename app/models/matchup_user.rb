class MatchupUser < ActiveRecord::Base
	# :matchup_id, :user_id
	belongs_to :user
	belongs_to :matchup
end
