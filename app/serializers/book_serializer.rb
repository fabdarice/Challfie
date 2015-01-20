class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :cover, :is_unlocked

  delegate :current_user, to: :scope

  has_many :challenges

  def is_unlocked
  	if current_user.books.exists?(id: object.id)
      return true
    else
      return false
    end
  end
    
end
