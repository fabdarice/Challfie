class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController  

  def facebook
    if user_signed_in?
      auth = request.env["omniauth.auth"] 
      myparams = request.env["omniauth.params"]  
             
      current_user.update_attributes(provider: auth[:provider],
                                    uid: auth[:uid],                                                                             
                                    oauth_token: auth[:credentials][:token],
                                    oauth_expires_at: Time.at(auth[:credentials][:expires_at]))
      
      facebook_info = FacebookInfo.find_by(user_id: current_user.id)
          
      if facebook_info == nil
        facebook_info = FacebookInfo.new(facebook_lastname: auth[:info][:last_name],
                                        facebook_firstname: auth[:info][:first_name],
                                        facebook_locale: auth[:extra][:raw_info][:locale])
        facebook_info.user = current_user
      else
        facebook_info.update_attributes(facebook_lastname: auth[:info][:last_name],
                                       facebook_firstname: auth[:info][:first_name],
                                       facebook_locale: auth[:extra][:raw_info][:locale])
      end
      
      if !current_user.save or !facebook_info.save       
        flash[:error] = "There was an error authenticating you with your Facebook account. Please try again later."                
        redirect_to root_path
      else
        if myparams["type"] == "friends_search"
          redirect_to root_path
        end
      end
    else
      # Creating a new Facebook user or new Facebook session
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], false)

      if @user              
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?      
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end        
  end

end