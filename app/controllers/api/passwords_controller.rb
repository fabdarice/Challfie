module Api
	class PasswordsController < Devise::PasswordsController
		skip_before_filter :verify_authenticity_token
	   before_filter :ensure_email_exist, :only => [:create ]	
	   respond_to :json

	  # POST /resource/password
	   def create
	     resource = User.find_by email: params[:email]

	     if resource.blank?
	     		render :json=> {:success=>false, :message => "Email address doesn't exist."}
	     else 

		     resource = resource.send_reset_password_instructions

		     if resource
		      render :json=> {:success=>true, :message => "Check your mailbox for reset password instructions."}
		     else
		      render :json=> {:success=>false, :message => "Couldn't send the reset password instructions. Try again later or do it through the website www.challfie.com."}
		     end
		  end  
	   end
	
		protected
			def ensure_email_exist
				return unless params[:email].blank?
	      	render :json=>{:success=>false, :message=>"Missing email parameter"}, :status=>401
			end

	end
end