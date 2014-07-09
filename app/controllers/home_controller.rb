class HomeController < ApplicationController
	before_filter :authenticate_user!

 	def index
		@selfies = Selfie.where(user_id: current_user.id)
	end
end
