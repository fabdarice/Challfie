class Contact < ActiveRecord::Base
	def show_type
		case self.type_contact
		when 1 
			return "Report a bug"
		when 2
			return "Require Assistance for your account"
		when 3
			return "Report obscene, pornographic, offensive content"
		when 4
			return "Give suggestions for the website"
		when 5
			return "Contact us for any marketing or advertising request"
		when 6
			return "Others"
		else
			return ""
		end		
	end
end
