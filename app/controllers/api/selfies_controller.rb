module Api
  class SelfiesController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    def timeline
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id
    
      @selfies = Selfie.where("user_id in (?)", list_following_ids).order("created_at DESC").paginate(:page => params["page"])      
      unread_notifications = current_user.notifications.where(read: 0)

      render json: @selfies, meta: {new_alert_nb: unread_notifications.count}
    end
    

    def refresh
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id

      @selfies = Selfie.where("user_id in (?) and id >= ?", list_following_ids, params[:last_selfie_id]).order("created_at DESC")
      unread_notifications = current_user.notifications.where(read: 0)
      
      render json: @selfies, meta: {new_alert_nb: unread_notifications.count}
    end

    def approve
      selfie = Selfie.find(params[:id])
      selfie.vote_by :voter => current_user

      selfie.set_approval_status!("upvote")

      if selfie.user != current_user        
        selfie.user.add_notifications(" has approved your #{selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_en}</i></strong>\".", 
                            " a approuvé ton #{selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_fr}</i></strong>\".",
                            current_user , selfie, nil, Notification.type_notifications[:selfie_approval])
      end      
      render :json=> {:success=>true, :approval_status=>selfie.approval_status, :selfie_id => selfie.id}
    end

    def reject
      selfie = Selfie.find(params[:id])
      selfie.downvote_from current_user

      selfie.set_approval_status!("downvote")

      if selfie.user != current_user        
        selfie.user.add_notifications(" has rejected your #{selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_en}</i></strong>\".", 
                            " a rejeté ton #{selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_fr}</i></strong>\".",
                            current_user , selfie, nil, Notification.type_notifications[:selfie_approval])
      end
      render :json=> {:success=>true, :approval_status=>selfie.approval_status, :selfie_id => selfie.id}
    end

    def list_comments
      selfie = Selfie.find(params[:id])
      render json: selfie.comments
    end

  end    
end