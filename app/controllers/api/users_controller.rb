module Api
  class UsersController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    # Show User Profil Page
    def show
      user = User.friendly.find(params[:user_id])      
      render json: user
    end  

 
    # Update Photo profil
    def update              
      if params[:mobile_upload_file]      
        current_user.avatar = params[:mobile_upload_file]
        current_user.avatar_file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_userprofile_mobileupload.jpg"
      end

      if params[:new_username]
        current_user.username = params[:new_username]
        current_user.username_activated = true
      end
          
      if current_user.save
        render json: current_user
      else
        render json: current_user.errors
      end
    end
    

    # Show Current User Profil Page
    def show_current_user
      render json: current_user
    end

    # get an User's list of selfies
    def list_selfies
      user = User.friendly.find(params[:user_id])

      if current_user == user or current_user.is_following?(user)
        user_selfies = user.selfies.where("blocked = false and hidden = false").order("created_at DESC").paginate(:page => params[:page], :per_page => 39)
      else
        user_selfies = user.selfies.where("private = false and blocked = false and hidden = false").order("created_at DESC").paginate(:page => params[:page], :per_page => 39)
      end
      followers = user.followers(1)
      following = user.all_following
      #books = user.books
      number_selfie_approved = user.selfies.where("blocked = false and hidden = false and approval_status = 1").count

      render json: user_selfies.includes(:challenge), meta: {number_selfies: user_selfies.count, number_following: following.count, number_followers: followers.count, number_approved: number_selfie_approved}
    end


    def following       
      # LIST OF ALL FRIEND FOLLOWING
      @following = current_user.all_following
      @following = @following.sort_by {|u| u.username.downcase}
      @following = @following.paginate(:page => params["page"], :per_page => 20)

      # Number of unread Notifications
      unread_notifications = current_user.notifications.where(read: 0)  
      # Number of New Friends Request
      pending_request = current_user.followers(0)    
      render json: @following, each_serializer: FriendsSerializer, scope: current_user, meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}    
    end

    def followers       
      # LIST OF ALL FOLLOWERS
      @followers = current_user.followers(1).paginate(:page => params["page"], :per_page => 20)
      # Number of unread Notifications
      unread_notifications = current_user.notifications.where(read: 0)  
      # Number of New Friends Request
      pending_request = current_user.followers(0)    
      render json: @followers, each_serializer: FriendsSerializer, scope: current_user, meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}    
    end

    # Get list of friends requests and suggestions
    def suggestions_and_request      
      if params[:page] == "1"        
        @pending_request = current_user.followers(0)
      else         
        @pending_request = []
      end

      # Friends Suggestions
      @friends_suggestions = current_user.friends_suggestions.paginate(:page => params[:page], :per_page => 20)
      # Number of unread Notifications
      unread_notifications = current_user.notifications.where(read: 0)  

      if current_user.oauth_token.blank? or current_user.uid.blank?
        is_facebook_link = false
      else
        is_facebook_link = true
      end
      # Number of New Friends Request
      pending_request = current_user.followers(0) 
      render json: {
        request: ActiveModel::ArraySerializer.new(@pending_request, each_serializer: FriendsSerializer, scope: current_user),
        suggestions: ActiveModel::ArraySerializer.new(@friends_suggestions, each_serializer: FriendsSerializer, scope: current_user),
        new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count, is_facebook_link: is_facebook_link        
      }
    end

    def follow
      @user = User.friendly.find(params[:user_id])
      current_user.follow(@user)
      if current_user.following?(@user)
        @follow = Follow.find_by followable_id: @user.id, follower_id: current_user.id
        @follow.status = 0
        if @follow.save
          @user.add_notifications(" has requested to follow you.", 
                        " souhaite faire parti de ta liste d'abonnées.",
                        current_user , nil, nil, Notification.type_notifications[:friend_request])
          render :json => {:success => true}
        else
          render :json => {:success => false}
        end
      else
        render :json => {:success => false}
      end
    end

    # Delete a Following Relationship
    def unfollow
      @user = User.friendly.find(params[:user_id])

      @follow = Follow.find_by followable_id: @user.id, follower_id: current_user.id
      @follow.status = 2
      
      if @follow.save
          render :json => {:success => true}
      else 
          render :json => {:success => false}
      end
    end

    # Accept a follower request
    def accept_request
      @user = User.friendly.find(params[:user_id])
      @follow = Follow.find_by followable_id: current_user.id, follower_id: @user.id
      @follow.status = 1
      if @follow.save
        @user.add_notifications(" has accepted your <strong>friend request</strong>.", 
                      " a accepté ta <strong>demande d'ami</strong>.",
                      current_user , nil, nil, Notification.type_notifications[:friend_request])
        render :json => {:success => true}
      else 
        render :json => {:success => false}
      end    
      
    end

    # Delete a Followers or Decline a pending Request
    def remove_follower
      @user = User.friendly.find(params[:user_id])

      @follow = Follow.find_by followable_id: current_user.id, follower_id: @user.id
      @follow.status = 2

      if @follow.save
          render :json => {:success => true}
      else
          render :json => {:success => false}
      end
    end

    def remove_suggestions
      @user = User.friendly.find(params[:user_id])
      current_user.follow(@user)

      if current_user.following?(@user)
        @follow = Follow.find_by followable_id: @user.id, follower_id: current_user.id
        @follow.status = 2
        
        if @follow.save
            render :json => {:success => true}
        else 
            render :json => {:success => false}
        end
      else 
          render :json => {:success => false}
      end            
    end


    def autocomplete_search_user    
      search = User.search do
        fulltext params[:user_input].gsub("@", " ")
        with :blocked, false
        paginate :page => 1, :per_page => 30
      end

      @users = search.results
      render json: @users, each_serializer: FriendsSerializer, scope: current_user              
    end


    def facebook_link
      auth = {
                :provider => "facebook",
                :uid => params[:uid],
                :info => {                                    
                  :first_name => params[:firstname],
                  :last_name => params[:lastname],
                }, 
                :credentials => {
                  :token => params[:fbtoken],
                  :expires_at => params[:fbtoken_expires_at]
                },
                :extra => {
                  :raw_info => {
                    :locale => params[:fb_locale]
                  }
                }
              }

      if params[:facebook_picture].blank?
        user_facebook_picture = "http://graph.facebook.com/" + params[:uid].to_s + "/picture?type=large"
      else
        user_facebook_picture = params[:facebook_picture]
      end
   
      current_user.update_attributes(provider: auth[:provider],
                                    uid: auth[:uid],                                                                             
                                    oauth_token: auth[:credentials][:token],
                                    oauth_expires_at: Time.at(auth[:credentials][:expires_at]),
                                    facebook_picture: user_facebook_picture.gsub!("http", "https"))
      
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
        render :json => {:success => false, :message => "There was an error authenticating you with your Facebook account. Please try again later."}               
      else
        render :json => {:success => true}
      end        
      
    end

    def ranking
      users = current_user.following(1)
      users << current_user      
      users = users.sort_by{|u| -u.points} 
      hash_user = Hash[users.map.with_index.to_a]      
      users = users.paginate(:page => params["page"], :per_page => 20)
      render json: {
        users: ActiveModel::ArraySerializer.new(users, each_serializer: UserrankingSerializer, scope: current_user),
        current_user: ActiveModel::ArraySerializer.new([current_user], each_serializer: UserrankingSerializer, scope: current_user),
        current_rank: hash_user[current_user] + 1
      }
      #render json: users, each_serializer: UserrankingSerializer, scope: current_user, meta: {current_rank: , current_user: current_user}
    end

    def ranking_global
      users = User.where("blocked = false").order("points DESC").paginate(:page => params["page"], :per_page => 20, :total_entries => 100)
      render json: {
        users: ActiveModel::ArraySerializer.new(users, each_serializer: UserrankingSerializer, scope: current_user),
        current_user: ActiveModel::ArraySerializer.new([current_user], each_serializer: UserrankingSerializer, scope: current_user),
        current_rank: current_user.current_rank
      }      
    end
    
  end  
end