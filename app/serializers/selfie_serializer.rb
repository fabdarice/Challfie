class SelfieSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :message, :photo, :shared_fb, :private, :approval_status, :is_daily, :creation_date, :nb_upvotes, :nb_downvotes, :nb_comments, :last_comment, :status_vote, :flag_count, :blocked, :ratio_photo

  delegate :current_user, to: :scope


  has_one :user
  has_one :challenge

  def creation_date
  	return time_ago_in_words(object.created_at)
  end

  def photo
  	return object.photo.url(:mobile)
  end

  def nb_upvotes
  	return object.get_upvotes.size
  end

  def nb_downvotes
  	return object.get_downvotes.size
  end

  def nb_comments
  	return object.comments.count
  end

  def last_comment
  	last_comment = object.comments.last

  	if last_comment             
  		{:message => last_comment.message.squish, :username => last_comment.user.username, :user_id => last_comment.user.id }  	
  	else
  		{}
  	end
  end

  def status_vote
    # api_current_user is defined in the application controller and represent the current user log in
    if current_user.voted_up_on? object
      return 1
    end
    if current_user.voted_down_on? object 
      return 2
    end
    return 0
  end

  def ratio_photo
    return object.photo.aspect_ratio
  end

end
