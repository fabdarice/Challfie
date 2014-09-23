class Selfie < ActiveRecord::Base
	#attr_accessor :content_type, :original_filename, :image_data

	self.per_page = 4

	has_attached_file :photo, :styles => {  }, :default_url => "/assets/missing.jpg"

	has_attached_file :photo, 
                    :styles => {:medium => "", :thumb => "100x100>"}, 
                    :convert_options => { :medium => Proc.new { |instance| instance.photo_dimension } },
                    :default_url => "/assets/missing.jpg"
  
  	validates_attachment :photo, :presence => true,
						  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
						  :size => { :in => 0..5.megabytes }

	belongs_to :user
	belongs_to :challenge
	has_many :comments, dependent: :destroy

	acts_as_votable

	
	def photo_dimension(width=180, height=150)
	 dimensions = Paperclip::Geometry.from_file(photo.queued_for_write[:original].path)
	 min = dimensions.width > dimensions.height ? dimensions.height : dimensions.width
	 "-gravity Center -crop #{min}x#{min}+0+0 +repage -resize #{width}x#{height}^"
	end            

end
