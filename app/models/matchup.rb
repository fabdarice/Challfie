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

end
