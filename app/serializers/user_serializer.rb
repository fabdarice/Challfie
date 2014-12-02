class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar, :book_tier, :book_level

  def book_tier
  	return object.current_book.tier
  end

  def book_level
  	return object.current_book.name
  end

  def avatar
	  	if object.not_from_facebook?
	        object.avatar
	   else
	      if object.avatar.blank?
	        object.facebook_picture
	      else            
	        object.avatar
	      end
	   end
  end
  
end
