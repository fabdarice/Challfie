class RegistrationsController < Devise::RegistrationsController  
  after_filter :initiate_first_book, :only => :create

  def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # For Rails 3
    # account_update_params = params[:user]

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else      
      render "users/edit", layout: 'application'
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  def initiate_first_book
    first_level_book = Book.find_by level: 1
    book_users = BookUser.new
    book_users.user = resource
    book_users.book = first_level_book
    book_users.save

    # First 200 subscribers
    if User.count < 200
      challfie_special_book = Book.find_by level: 0
      book_users = BookUser.new
      book_users.user = resource
      book_users.book = challfie_special_book
      book_users.save
    end
  end

end