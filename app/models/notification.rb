class Notification < ActiveRecord::Base
	#:id, :message_fr, :message_en, :user_id, :author_id, :selfie_id, :book_id, :read, :type_notification

  # Notification Type
  enum type_notification: { comment_mine: 0, comment_other: 1, selfie_approval: 2, selfie_status: 3, friend_request: 4, book_unlock: 5, daily_challenge: 6 }

	belongs_to :user, :class_name => "User"
	belongs_to :author, :class_name => "User"
	belongs_to :selfie
	belongs_to :book

  self.per_page = 20

  def message
	  if I18n.locale == :fr      
      msg = self.message_fr
    else
      msg = self.message_en
    end
  end
end
