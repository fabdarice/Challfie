class PasswordsController < Devise::PasswordsController
  skip_before_action :check_browser, only: [:edit, :update]
   
  layout 'extra_pages'

  

end