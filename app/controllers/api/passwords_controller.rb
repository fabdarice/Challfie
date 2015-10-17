module Api
	class PasswordsController < Devise::PasswordsController
		
		skip_before_filter :verify_authenticity_token
	   before_filter :ensure_email_exist, :only => [:create ]	
	   respond_to :json

	  # POST /resource/password
	   def create
	     resource = User.find_by email: params[:email]

	     if resource.blank?
	     		render :json=> {:success=>false, :message => I18n.translate('password.email_doesnt_exist')}
	     else 

		     resource = resource.send_reset_password_instructions

		     if resource
		      render :json=> {:success=>true, :message => I18n.translate('password.send_email_instructions')}
		     else
		      render :json=> {:success=>false, :message => I18n.translate('password.send_email_error')}
		     end
		  end  
	   end
	
		protected
			def ensure_email_exist
				return unless params[:email].blank?
	      	render :json=>{:success=>false, :message=> I18n.translate('password.missing_email')}, :status=>401
			end

	end
end