class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar, :book_tier, :book_level

  def book_tier
  	return object.current_book.tier
  end

  def book_level
  	return object.current_book.name
  end
  
end
