class Contact < ActiveRecord::Base
	def show_type
		case self.type_contact
		when 1 
			return "Report a bug"
		when 2
			return "Request assistance for your account"
		when 3
			return "Report obscene, offensive content"
		when 4
			return "Give suggestions for the website"		
		when 5
			return "Others"
		else
			return ""
		end		
	end
end
