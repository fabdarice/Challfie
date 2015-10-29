class Matchup < ActiveRecord::Base
	#:chalenge_id, :winner_id, :type, :end_date

	belongs_to :challenge
	belongs_to :winner, class_name: "User"
	has_many :selfies
	has_many :matchups, :through => :matchup_users
  	has_many :matchup_users

end
