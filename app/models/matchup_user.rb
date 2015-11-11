class MatchupUser < ActiveRecord::Base
	# :matchup_id, :user_id, :is_creator
	belongs_to :matchup

	belongs_to :user, :class_name => "User"	
end
