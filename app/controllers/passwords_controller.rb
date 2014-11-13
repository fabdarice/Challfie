class PasswordsController < Devise::PasswordsController
  skip_before_action :check_browser, only: [:edit, :update]
   
  layout 'extra_pages'

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
    	if not browser.mobile?
	      resource.unlock_access! if unlockable?(resource)
	      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
	      set_flash_message(:notice, flash_message) if is_flashing_format?
	      sign_in(resource_name, resource)
	      respond_with resource, location: after_resetting_password_path_for(resource)
	   else
	   	flash[:notice] = "Your password has been successfully changed."
      	redirect_to mobile_info_path
	   end
    else
      respond_with resource
    end
  end

end