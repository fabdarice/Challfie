class Selfie < ActiveRecord::Base
	#attributes :user_id, :message, :photo, :shared_fb, :challenge_id, :private, :approval_status

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

	def set_approval_status!(typevote)
		if (typevote == "upvote" and self.approval_status == 1) or (typevote == "downvote" and self.approval_status == 2)
			return
		else
			upvotes = self.get_upvotes.size
			downvotes = self.get_downvotes.size

			if upvotes >= 5
				vote_ratio = upvotes.to_f / (upvotes + downvotes)				
				if vote_ratio >= 0.75
					if self.approval_status != 1
						self.update_column(:approval_status, 1)
						self.user.update_column(:points, self.challenge.point + self.user.points)										
						self.user.unlock_book!												
						self.user.add_notifications("Congratulations! Your challenge <strong><i>#{self.challenge.description_en}</i></strong> has been approved.", 
															 "Félicitations! Ton challenge <strong><i>#{self.challenge.description_fr}</i></strong> a été approuvé.",
															 self.user , self, nil)	
					end	
				else
					if self.approval_status != 2
						tmp_approval_status = self.approval_status
						self.update_column(:approval_status, 2)						
						if tmp_approval_status == 1
							self.user.update_column(:points, self.user.points - self.challenge.point)																
						end
						self.user.add_notifications("Unfortunately.. your challenge <strong><i>#{self.challenge.description_en}</i></strong> has been rejected.", 
															"Malheureusement.. ton challenge <strong><i>#{self.challenge.description_fr}</i></strong> a été rejeté.",
															self.user , self, nil)																		
					end
				end
			else
				if self.approval_status == 1
					self.update_column(:approval_status, 2)												
					self.user.update_column(:points, self.user.points - self.challenge.point)																						
					self.user.add_notifications("Unfortunately.. your challenge <strong><i>#{self.challenge.description_en}</i></strong> has been unapproved.", 
														 "Malheureusement.. ton challenge <strong><i>#{self.challenge.description_fr}</i></strong> a été désapprouvé.",
														 self.user , self, nil)	
				end
			end			
		end
	end   

end
