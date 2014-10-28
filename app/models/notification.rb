class Notification < ActiveRecord::Base
	#:id, :message_fr, :message_en, :user_id, :author_id, :selfie_id, :read

	belongs_to :user, :class_name => "User"
  	belongs_to :author, :class_name => "User"
  	belongs_to :selfie
  	belongs_to :book

  	self.per_page = 20

  	def message
	 if I18n.locale == :fr
      self.message_fr
    else
      self.message_en
    end
  	end
end
