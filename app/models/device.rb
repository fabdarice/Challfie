class Device < ActiveRecord::Base
	#token, #user_id
	belongs_to :user
end
