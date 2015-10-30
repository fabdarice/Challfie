class UserrankingSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar, :book_tier, :book_level, :book_image, :is_facebook_picture, :is_following, :is_pending, :uid, :oauth_token, :points, :progression, :is_current_user

  #delegate :current_user, to: :scope

  def book_tier
  	return object.current_book.tier
  end

  def book_level
  	return object.current_book.name
  end

  def book_image
    return object.current_book.thumb.url(:original)
  end

  def avatar
	  object.show_profile_picture("thumb")
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

  def is_following
    @follow =  Follow.where('follower_id = ? and followable_id = ? and blocked = false and (status = 1 or status = 0)', @scope.id, object.id)
    if @follow.count == 0 
      return false
    else
      return true
    end
  end

  def is_pending
    @follow =  Follow.where('follower_id = ? and followable_id = ? and blocked = false and status = 0', @scope.id, object.id)
    if @follow.count == 0 
      return false
    else
      return true
    end
  end 
  
  def progression
    return object.next_book_progression
  end

  def is_current_user
    if object == @scope
      return true
    else
      return false
    end
  end
end
