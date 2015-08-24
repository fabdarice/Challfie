class Device < ActiveRecord::Base
	#token, #user_id, #type_device

	#type_device iOS : 0
	#type_device Android : 1

	belongs_to :user
end
