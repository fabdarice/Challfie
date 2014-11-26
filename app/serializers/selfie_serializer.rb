class SelfieSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :message, :photo, :shared_fb, :challenge_id, :private, :approval_status, :is_daily, :creation_date, :nb_upvotes, :nb_downvotes, :nb_comments, :last_comment

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
  	comment = object.comments.last
  	
  end

end
