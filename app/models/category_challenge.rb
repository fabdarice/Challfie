class CategoryChallenge < ActiveRecord::Base
	belongs_to :category
	belongs_to :challenge
end
