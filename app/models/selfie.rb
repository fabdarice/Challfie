class Selfie < ActiveRecord::Base
	#attributes :user_id, :message, :photo, :shared_fb, :challenge_id, :private, :approval_status, :is_daily, :flag_count, 
	#:blocked, :hidden, :photo_meta

	self.per_page = 4

	has_attached_file :photo, 
                    :styles => {:mobile => "450x", :thumb => ""}, 
                    :convert_options => { :thumb => Proc.new { |instance| instance.photo_dimension(150, 150) }  },                    							 
                    :path => "/:class/:attachment/:id_user/:id/:style/:filename",
                    :default_url => "/assets/missing.png"

  
	validates :photo, :attachment_presence => true
	validates_with AttachmentPresenceValidator, :attributes => :photo
	#validates_with AttachmentSizeValidator, :attributes => :photo, :less_than => 10.megabytes ==> This Make iOS image upload bug 
	validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
   #validates_attachment_file_name :photo, :matches => [/png\Z/, /jpe?g\Z/] # ==> This Make iOS image upload bug 
   #do_not_validate_attachment_file_type :photo

	belongs_to :user
	belongs_to :challenge
	has_many :comments, dependent: :destroy

	acts_as_votable

	Paperclip.interpolates :id_user do |attachment, style|
	  attachment.instance.user_id
	end	

	def photo_dimension(width=400, height=400)
	   dimensions = Paperclip::Geometry.from_file(photo.queued_for_write[:original].path)
	   min = dimensions.width > dimensions.height ? dimensions.height : dimensions.width

	   if min < width
			width = min
			height = min
	   end
	  "-gravity Center -crop #{min}x#{min}+0+0 +repage -resize #{width}x#{height}^"
	end   

	def set_approval_status!(typevote)
		if (typevote == "upvote" and self.approval_status == 1) or (typevote == "downvote" and self.approval_status == 2) or (self.hidden == true)			
			return
		else
			upvotes = self.get_upvotes.size
			downvotes = self.get_downvotes.size

			if (upvotes + downvotes) >= 5
				vote_ratio = upvotes.to_f / (upvotes + downvotes)				
				if vote_ratio >= 0.75
					# Selfie Status = Approved
					if self.approval_status != 1
						self.update_column(:approval_status, 1)

						if self.is_daily													
							challenge_very_easy = self.user.current_book.challenges.where("difficulty = ?", self.challenge.difficulty).first							
							challenge_value = challenge_very_easy.point
						else
							challenge_value = self.challenge.point
						end

						self.user.update_column(:points, challenge_value + self.user.points)										
						self.user.unlock_book!												
						self.user.add_notifications("Congratulations! Your #{self.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{self.challenge.description_en}</i></strong>\" has been approved.", 
															 "Félicitations! Ton #{self.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{self.challenge.description_fr}</i></strong>\" a été approuvé.",
															 self.user , self, nil, Notification.type_notifications[:selfie_status])	
					end	
				else
					# Selfie Status = Unapproved
					if self.approval_status != 2
						tmp_approval_status = self.approval_status
						self.update_column(:approval_status, 2)	

						if self.is_daily
							challenge_very_easy = self.user.current_book.challenges.where("difficulty = ?", self.challenge.difficulty).first							
							challenge_value = challenge_very_easy.point
						else
							challenge_value = self.challenge.point
						end

						if tmp_approval_status == 1
							self.user.update_column(:points, self.user.points - challenge_value)																
						end
						self.user.add_notifications("Unfortunately.. your #{self.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{self.challenge.description_en}</i></strong>\" has been rejected.", 
															"Malheureusement.. ton #{self.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{self.challenge.description_fr}</i></strong>\" a été rejeté.",
															self.user , self, nil, Notification.type_notifications[:selfie_status])																		
					end
				end			
			end			
		end
	end   

end
