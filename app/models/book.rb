class Book < ActiveRecord::Base
	#attr :name, :required_points, :cover, :tier, :level, :thumb
	has_many :challenges, dependent: :destroy
	has_many :users, :through => :book_users
	has_many :book_users, dependent: :destroy

	has_attached_file :cover, :styles => { :medium => "150x" }, :default_url => "/assets/missing.png"
  
  	validates_attachment :cover,
						  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
						  :size => { :in => 0..5.megabytes }

	has_attached_file :thumb, :default_url => "/assets/missing.png"
  
  validates_attachment :thumb,              
              :default_url => "/assets/missing.png", 
						  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
						  :size => { :in => 0..5.megabytes }					  


   def tier_name
   	case self.tier
   	when 1
      if I18n.locale == :fr
        "Niveau <br>débutant"
      else
        "Newbie <br>Level"
      end
    when 2
      if I18n.locale == :fr
        "Niveau <br>apprenti"
      else
        "Apprentice <br>Level"
      end         
    when 3
      if I18n.locale == :fr
        "Niveau <br>maître"
      else
        "Master <br>Level"
      end          
    when 0
      if I18n.locale == :fr
        "Challfie spécial"
      else
        "Challfie Special"
      end 
    end  	
   end

   def book_color
      case self.tier
      when 1
        # Newbie Tier
        "#bfa499"        
      when 2
        # Apprentice Tier
        "#89b7b4"        
      when 3
        # Master Tier
        "#f1eb6c"        
      end  
   end

end
