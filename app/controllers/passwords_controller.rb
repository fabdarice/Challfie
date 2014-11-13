class PasswordsController < Devise::PasswordsController
  layout 'extra_pages'

  skip_before_action :check_browser, only: [:edit]

end