class CommentSerializer < ActiveModel::Serializer
  attributes :id, :message, :username

  def username
  	return object.user.username
  end

  def message
  	return object.message.squish
  end
end
