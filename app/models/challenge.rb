class Challenge < ActiveRecord::Base
	#attr :description, :point

	has_many :categories, :through => :category_challenges
  	has_many :category_challenges
	has_many :selfies
	belongs_to :book

	accepts_nested_attributes_for :category_challenges
end
