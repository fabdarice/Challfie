class SelfiesController < ApplicationController
	before_filter :authenticate_user!

	def new
		@selfie = Selfie.new
	end

	def create
		@selfie = Selfie.new(selfie_params)
		@selfie.user = current_user

		if @selfie.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	private

    def selfie_params
      params.require(:selfie).permit(:message, :photo)
    end

end
