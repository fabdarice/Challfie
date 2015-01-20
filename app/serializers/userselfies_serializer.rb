class UserselfiesSerializer < ActiveModel::Serializer

  attributes :photo

  def photo
  	return object.photo.url(:mobile)
  end
 
end
