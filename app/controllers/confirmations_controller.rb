class ConfirmationsController < Devise::ConfirmationsController
	layout 'extra_pages'
	skip_before_action :check_browser

	def show
	   self.resource = resource_class.confirm_by_token(params[:confirmation_token])
	    
		yield resource if block_given?

		if resource.errors.empty?
			if not browser.mobile?
			   set_flash_message(:notice, :confirmed) if is_flashing_format?
			   respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
			else
			 	flash[:notice] = "Your account has been confirmed."
			   redirect_to mobile_info_path
		 	end   
		else
			respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
		end	 
  	end
end