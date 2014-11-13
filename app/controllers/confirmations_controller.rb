class ConfirmationsController < Devise::ConfirmationsController
	layout 'extra_pages'
	skip_before_action :check_browser, only: [:show]

end