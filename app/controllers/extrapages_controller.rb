class ExtrapagesController < ApplicationController
	skip_before_action :check_browser, only: [:mobile]


	def privacy_page 
		render layout: "extra_pages"
	end

	def terms
		render layout: "extra_pages"
	end

	def about_us
		render layout: "extra_pages"
	end

	def mobile		
		if browser.meta.include?("ios")
			@is_iphone = true			
		else
			@is_iphone = false			
		end
		render layout: "mobile_layout"
	end
end
