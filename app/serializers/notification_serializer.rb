class NotificationSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper  

  attributes :id, :message, :read, :type_notification, :selfie_id, :selfie_img, :book_img, :time_ago

  has_one :author
  
  def message
    msg = ""
  	if I18n.locale == :fr
      msg = object.message_fr
    else
      msg = object.message_en
    end

    return ActionView::Base.full_sanitizer.sanitize(msg)
  end

  def time_ago
    return time_ago_in_words(object.created_at)
  end

  def selfie_img
    if object.selfie    
      return object.selfie.photo.url(:mobile)
    else
      return nil
    end
  end

  def book_img
    if object.book    
      return object.book.cover.url(:medium)
    else
      return nil
    end
  end
  
end
