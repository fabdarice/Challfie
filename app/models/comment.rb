class Comment < ActiveRecord::Base
	#attr :message
	belongs_to :selfie
	belongs_to :user
end
