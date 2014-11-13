class ConfirmationsController < Devise::ConfirmationsController
	layout 'extra_pages'
	skip_before_action :check_browser, only: [:show]

	def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if not browser.mobile?
	    yield resource if block_given?

	    if resource.errors.empty?
	      set_flash_message(:notice, :confirmed) if is_flashing_format?
	      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
	    else
	      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
	    end
	 else
	 	flash[:notice] = "Your account has been confirmed."
      redirect_to mobile_info_path
	 end
  end

end