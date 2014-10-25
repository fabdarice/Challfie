class ExtrapagesController < ApplicationController
	layout 'extra_pages', except: [:mobile]
	layout 'mobile_layout', only: [:mobile]
	skip_before_action :check_browser, only: [:mobile]


	def privacy_page 
	end

	def terms
	end

	def about_us
	end

	def mobile
		
	end
end
