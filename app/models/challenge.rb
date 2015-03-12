class Challenge < ActiveRecord::Base
	#attr :description_en, :point, :description_fr, :book_id, :difficulty
  default_scope { order("difficulty") }


	has_many :categories, :through => :category_challenges
  has_many :category_challenges, dependent: :destroy
	has_many :selfies
	belongs_to :book

	searchable do 
    text :description_fr, :description_en
  end

  def description
    if I18n.locale == :fr      
      self.description_fr
    else      
      self.description_en
    end
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
      if I18n.locale == :fr
        "Challenge très facile"
      else
        "Very Easy Challenge"
      end
    when 2
      if I18n.locale == :fr
        "Challenge facile"
      else
        "Easy Challenge"
      end         
    when 3
      if I18n.locale == :fr
        "Challenge moyen"
      else
        "Intermediate Challenge"
      end          
    when 4
      if I18n.locale == :fr
        "Challenge difficile"
      else
        "Hard Challenge"
      end         
    else
      if I18n.locale == :fr
        "Challenge très difficile"
      else
        "Very Hard Challenge"
      end         
    end
  end
end
