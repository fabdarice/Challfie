class RegistrationsController < Devise::RegistrationsController  
  after_action :only => :create do 
    initiate_first_book(nil)
  end

  def update    
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # For Rails 3
    # account_update_params = params[:user]    

    @user = User.find(current_user.id)
    @user.username_activated = true
    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?      
      account_update_params.delete("current_password")
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")

      if @user.update_attributes(account_update_params)
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true
        redirect_to after_update_path_for(@user)
      else      
        render "users/edit", layout: 'application'
      end
    else
      if @user.update_with_password(account_update_params)
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true
        redirect_to after_update_path_for(@user)
      else      
        render "users/edit", layout: 'application'
      end   
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  

end