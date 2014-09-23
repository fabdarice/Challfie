class Book < ActiveRecord::Base
	#attr :name, :required_points, :cover
	has_many :challenges, dependent: :destroy

	has_attached_file :cover, :styles => { :medium => "400x", :thumb => "100x100>" }, :default_url => "/assets/missing.jpg"
  
  	validates_attachment :cover, :presence => true,
						  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
						  :size => { :in => 0..5.megabytes }

end
