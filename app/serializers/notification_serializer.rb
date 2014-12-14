class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :message, :read, :type_notification

  has_one :user
  has_one :selfie
  has_one :book

  def message
  	if I18n.locale == :fr
        object.message_fr
      else
        object.message_en
      end
  end

  
end
