class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :message, :username
  
  def username
  	return object.user.username
  end

  def message
  	return object.message.squish
  end
end
