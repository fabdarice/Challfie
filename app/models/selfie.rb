class Selfie < ActiveRecord::Base
	has_attached_file :photo, :styles => { :medium => "400x", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  
  	validates_attachment :photo, :presence => true,
						  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
						  :size => { :in => 0..5.megabytes }

	belongs_to :user
	belongs_to :challenge
	has_many :comments

end
