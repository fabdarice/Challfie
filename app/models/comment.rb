class Comment < ActiveRecord::Base
	#attr :message, :selfie_id, :user_id
	belongs_to :selfie
	belongs_to :user

	validates :message, presence: true


end
