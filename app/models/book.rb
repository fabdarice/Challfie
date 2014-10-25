class Book < ActiveRecord::Base
	#attr :name, :required_points, :cover
	has_many :challenges, dependent: :destroy
	has_many :users, :through => :book_users
	has_many :book_users, dependent: :destroy

	has_attached_file :cover, :styles => { :medium => "400x" }, :default_url => "/assets/missing.jpg"
  
  	validates_attachment :cover,
						  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
						  :size => { :in => 0..5.megabytes }

	has_attached_file :thumb, :default_url => "/assets/missing.jpg"
  
  	validates_attachment :thumb,
						  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
						  :size => { :in => 0..5.megabytes }					  


   def tier_name
   	case self.tier
   	when 1
        if I18n.locale == :fr
          "Niveau <br>débutant"
        else
          "Newbie <br>Tier"
        end
      when 2
        if I18n.locale == :fr
          "Niveau <br>apprentit"
        else
          "Apprentice <br>Tier"
        end         
      when 3
        if I18n.locale == :fr
          "Niveau <br>Maître"
        else
          "Master <br>Tier"
        end          
      when 0
        if I18n.locale == :fr
          "Niveau Challfie Spécial"
        else
          "Challfie Special Tier"
        end 
      end  	
   end

end
