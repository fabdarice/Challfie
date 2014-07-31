class Challenge < ActiveRecord::Base
	#attr :description, :point

	has_many :categories, :through => :category_challenges
  	has_many :category_challenges, dependent: :destroy
	has_many :selfies
	belongs_to :book

	searchable do 
   	text :description
  	end

end
