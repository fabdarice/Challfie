class Challenge < ActiveRecord::Base
	#attr :description, :point

	has_many :categories, :through => :category_challenges
  	has_many :category_challenges, dependent: :destroy
	has_many :selfies
	belongs_to :book

	searchable do 
   	text :description
  	end

  	def difficulty_icon
  		case self.difficulty
  		when 1
  			"star_very_easy.png"
  		when 2
  			"star_easy.png"
  		when 3
  			"star_intermediate.png"
  		when 4
  			"star_hard.png"
  		else
  			"star_very_hard.png"
  		end
  	end


    def difficulty_verbose
      case self.difficulty
      when 1
        "Very Easy Challenge"
      when 2
        "Easy Challenge" 
      when 3
        "Intermediate Challenge"
      when 4
        "Hard Challenge"
      else
        "Very Hard Challenge"
      end
    end
end
