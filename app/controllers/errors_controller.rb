class ErrorsController < ApplicationController	
	layout 'extra_pages'
	
	def not_found
		render 'show'
	end

	def unacceptable
		render 'show'
	end

	def internal_error
		render 'show'
	end	

	def show

	end
end
