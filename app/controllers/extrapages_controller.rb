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
		browser.meta.each do |f|
			logger.info "BROWSER META = " + f.to_s
			if f.to_s == "ios"
				logger.info "IS TRUE IOS"
			end
		end
		if browser.meta.include?("ios")
			@is_iphone = true
			logger.info "IS IOS"
		else
			@is_iphone = false
			logger.info "IS NOT IOS"
		end
	end
end
