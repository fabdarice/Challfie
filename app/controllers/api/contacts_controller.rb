module Api
  class ContactsController < ApplicationController
  	before_filter :authenticate_user_from_token!
    respond_to :json

    def create      
      contact = Contact.new
      contact.email = current_user.email
      contact.message = params[:message]
      contact.type_contact = params[:type_contact]
      
      if contact.save        
        render :json=> {:success=>true, :message => "Your message has been transfered. We will get back at you as soon as possible."}
      else      
        render :json=> {:success=>false, :message => "Error while sending this message. Try again later."}
      end      
    end

  end
end