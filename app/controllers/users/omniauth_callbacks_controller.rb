class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController  
  def facebook
    if user_signed_in? and current_user.from_facebook == false      
      auth = request.env["omniauth.auth"] 
      myparams = request.env["omniauth.params"]  
             
      current_user.update_attributes(provider: auth[:provider],                                                                             
                                    oauth_token: auth[:credentials][:token],
                                    oauth_expires_at: Time.at(auth[:credentials][:expires_at]))
      
      facebook_info = FacebookInfo.find_by(user_id: current_user.id)
          
      if facebook_info == nil
        facebook_info = FacebookInfo.new(facebook_uid: auth[:uid], facebook_lastname: auth[:info][:last_name],
                                       facebook_firstname: auth[:info][:first_name], facebook_email: auth[:info][:email], facebook_locale: auth[:extra][:raw_info][:locale])
        facebook_info.user = current_user
      else
        facebook_info.update_attributes(facebook_uid: auth[:uid], facebook_lastname: auth[:info][:last_name],
                                       facebook_firstname: auth[:info][:first_name], facebook_email: auth[:info][:email], facebook_locale: auth[:extra][:raw_info][:locale])
      end
      
      if !current_user.save or !facebook_info.save       
        flash[:error] = "There was an error authenticating you with your Facebook account. Please try again later."
        current_user.update_attributes(provider: nil,                                                                             
                                    oauth_token: nil,
                                    oauth_expires_at: nil,
                                    uid: nil)
        facebook_info.update_attributes(facebook_uid: nil)
        current_user.save
        facebook_info.save
        redirect_to root_path
      else
        if myparams["type"] == "friends_search"
          redirect_to root_path
        end
      end
    else

      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], false)

      if @user.persisted?
        # IF FIRST TIME REGISTRATION FROM FACEBOOK 
        if BookUser.where(user_id: @user.id).count == 0
          first_level_book = Book.find_by level: 1
          book_users = BookUser.new
          book_users.user = @user
          book_users.book = first_level_book
          book_users.save

          # First 200 subscribers
          if User.count < 200
            challfie_special_book = Book.find_by level: 0
            book_users = BookUser.new
            book_users.user = @user
            book_users.book = challfie_special_book
            book_users.save
          end          
        end

        if !user_signed_in?                  
          sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
          set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        end
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end    
    
  end
  

end