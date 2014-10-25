class ExtrapagesController < ApplicationController
	layout 'extra_pages'
	skip_before_filter :check_browser, :only => [:mobile]


	def privacy_page 
	end

	def terms
	end

	def about_us
	end

	def mobile
		layout 'mobile_layout'
	end
end
