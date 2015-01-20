module Api
  class UsersController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    # Show User Profil Page
    def show
      user = User.friendly.find(params[:user_id])      
      render json: user
    end  

    # Show Current User Profil Page
    def show_current_user
      render json: current_user
    end

    # get an User's list of selfies
    def list_selfies
      user = User.friendly.find(params[:user_id])

      if current_user == user or current_user.is_following?(user)
        user_selfies = user.selfies.order("created_at DESC").paginate(:page => params[:page], :per_page => 12)
      else
        user_selfies = user.selfies.where("private = false").order("created_at DESC").paginate(:page => params[:page], :per_page => 12)
      end
      followers = user.followers(1)
      following = user.all_following
      books = user.books

      render json: user_selfies, meta: {number_selfies: user.selfies.count, number_following: following.count, number_followers: followers.count, number_books: books.count}
    end


    def following       
      # LIST OF ALL FRIEND FOLLOWING
      @following = current_user.all_following
      @following = @following.sort_by {|u| u.username.downcase}
      @following = @following.paginate(:page => params["page"], :per_page => 10)

      # Number of unread Notifications
      unread_notifications = current_user.notifications.where(read: 0)  
      # Number of New Friends Request
      pending_request = current_user.followers(0)    
      render json: @following, each_serializer: FriendsSerializer, scope: current_user, meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}    
    end

    def followers       
      # LIST OF ALL FOLLOWERS
      @followers = current_user.followers(1).paginate(:page => params["page"], :per_page => 10)
      # Number of unread Notifications
      unread_notifications = current_user.notifications.where(read: 0)  
      # Number of New Friends Request
      pending_request = current_user.followers(0)    
      render json: @followers, each_serializer: FriendsSerializer, scope: current_user, meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}    
    end

    # Get list of friends requests and suggestions
    def suggestions_and_request
      if current_user.oauth_token.blank? or (current_user.uid.blank? and (current_user.facebook_info and current_user.facebook_info.facebook_uid.blank?))
        is_facebook_link = false
      else
        is_facebook_link = true
      end

      if params[:page] == "1"        
        @pending_request = current_user.followers(0)
      else         
        @pending_request = []
      end

      # Friends Suggestions
      @friends_suggestions = current_user.friends_suggestions.paginate(:page => params[:page], :per_page => 10)
      # Number of unread Notifications
      unread_notifications = current_user.notifications.where(read: 0)  
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
      render json: {} 
    end

    # Delete a Following Relationship
    def unfollow
      @user = User.friendly.find(params[:user_id])
      current_user.stop_following(@user)   
      render json: {}         
    end

    # Accept a follower request
    def accept_request
      @user = User.friendly.find(params[:user_id])
      @follow = Follow.find_by followable_id: current_user.id, follower_id: @user.id
      @follow.status = 1
      @follow.save      
      @user.add_notifications(" has accepted your <strong>following request</strong>.", 
                      " a accepté ta <strong>demande d'ami</strong>.",
                      current_user , nil, nil, Notification.type_notifications[:friend_request])
      render json: {}
    end

    # Delete or Decline a Followers Relationship/Request
    def remove_follower
      @user = User.friendly.find(params[:user_id])
      @user.stop_following(current_user)     

      render json: {}       
    end


    def autocomplete_search_user    
      search = User.search do
        fulltext params[:user_input]
        paginate :page => 1, :per_page => 10
      end

      @users = search.results   
      render json: @users, each_serializer: FriendsSerializer, scope: current_user              
    end
    
  end  
end