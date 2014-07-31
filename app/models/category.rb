class Category < ActiveRecord::Base
	#attr :name
	has_many :challenges, :through => :category_challenges
	has_many :category_challenges, dependent: :destroy

end
