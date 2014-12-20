module Api
  class UsersController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    def following       
      # LIST OF ALL FRIEND FOLLOWING
      @following = current_user.all_following
      @following = @following.sort_by {|u| u.username.downcase}

      unread_notifications = current_user.notifications.where(read: 0)
      # LIST OF ALL FOLLOWERS
      #@followers = current_user.followers(1)
      # LIST OF ALL PENDING REQUEST
      #@pending_request = current_user.followers(0)

      #@friends_suggestions = current_user.friends_suggestions
      render json: @following, each_serializer: FriendsSerializer, meta: {new_alert_nb: unread_notifications.count}    
    end

    def followers       
      # LIST OF ALL FOLLOWERS
      @followers = current_user.followers(1)
      unread_notifications = current_user.notifications.where(read: 0)      
      render json: @followers, each_serializer: FriendsSerializer, meta: {new_alert_nb: unread_notifications.count}    
    end

    def friends_suggestions       
      # LIST OF ALL FRIENDS SUGGESTIONS      
      @friends_suggestions = current_user.friends_suggestions
      unread_notifications = current_user.notifications.where(read: 0)      
      render json: @friends_suggestions, each_serializer: FriendsSerializer, meta: {new_alert_nb: unread_notifications.count}    
    end

    def index
      respond_with User.all
    end

    def show
      respond_with User.where(username: params[:login]).first
    end
  end  
end