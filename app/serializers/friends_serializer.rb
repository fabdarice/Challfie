class FriendsSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar, :book_tier, :book_level, :nb_mutual_friend, :is_facebook_picture

  delegate :current_user, to: :scope

  def book_tier
  	return object.current_book.tier
  end

  def book_level
  	return object.current_book.name
  end

  def avatar
	  	if object.not_from_facebook?
	        object.avatar.url(:thumb)
	   else
	      if object.avatar.blank?
	        object.facebook_picture
	      else            
	        object.avatar.url(:thumb)
	      end
	   end
  end

  def is_facebook_picture
      if object.not_from_facebook?
          return false
     else
        if object.avatar.blank?
          return true
        else            
          return false
        end
     end
  end

  def nb_mutual_friend
  	return current_user.number_mutualfriends(object)
  end
  
end
