class ContactsController < ApplicationController
	layout 'extra_pages'

  def new
    @contact = Contact.new    
  end

  def create
    #if verify_recaptcha
      @contact = Contact.new(contacts_params)
      
      if @contact.email.blank?
        @contact.email = 'Anonymous@challfie.com'
      end

      if @contact.save
        flash[:notice] = "Thank you very much for reaching out to us. Your message has been transfered. We will get back at you as soon as possible."
        redirect_to new_contact_path
      else
        flash[:error] = "Error while sending this message. Try again later."  
        render 'new'      
      end
    #else
    #  flash[:error] = "Your entry don't match the words in the box. Please try again."  
    #  redirect_to new_contact_path, flash: {manifesto_modal: true}
    #end
  end

  def destroy
    contact = Contact.find(params[:id])
    session[:return_to] ||= request.referer
    if (contact.destroy)
    flash[:notice] = 'Contact deleted.'
    end
    redirect_to controller:'administration', action:'contacts'
  end

  private
    def contacts_params
      params.require(:contact).permit(:email, :message, :type_contact)
    end
end
