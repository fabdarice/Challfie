class Notification < ActiveRecord::Base
	belongs_to :user, :class_name => "User"
  	belongs_to :author, :class_name => "User"
  	belongs_to :selfie

  	self.per_page = 20
end
