class UserrankingSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar, :book_tier, :book_level, :is_facebook_picture, :is_following, :is_pending, :uid, :oauth_token, :points, :progression

  #delegate :current_user, to: :scope

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

  def is_following
    @follow =  Follow.where('follower_id = ? and followable_id = ? and blocked = false', @scope.id, object.id)
    if @follow.count == 0 
      return false
    else
      return true
    end
  end

  def is_pending
    @follow =  Follow.where('status = 0 and follower_id = ? and followable_id = ? and blocked = false', @scope.id, object.id)
    if @follow.count == 0 
      return false
    else
      return true
    end
  end 
  
  def progression
    return object.next_book_progression
  end

end