class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :cover, :is_unlocked, :tier

  delegate :current_user, to: :scope

  has_many :challenges

  def is_unlocked
  	if current_user.books.exists?(id: object.id) or (object.tier == 0)
      return true
    else
      return false
    end
  end


end
