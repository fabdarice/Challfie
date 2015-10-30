class FriendsSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar, :book_tier, :book_level, :book_image, :nb_mutual_friend, :is_facebook_picture, :nb_followers, :is_pending, :is_following, :blocked

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

  def nb_mutual_friend
  	return @scope.number_mutualfriends(object)  
  end

  def nb_followers
    return object.followers(1).count
  end

  def is_pending
    @follow =  Follow.where('follower_id = ? and followable_id = ? and blocked = false and status = 0', @scope.id, object.id)
    if @follow.count == 0 
      return false
    else
      return true
    end
  end

  def is_following
    @follow =  Follow.where('follower_id = ? and followable_id = ? and blocked = false and (status = 0 or status = 1)', @scope.id, object.id)
    if @follow.count == 0 
      return false
    else
      return true
    end
  end
  
end
