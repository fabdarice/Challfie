module Api
  class SelfiesController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    def timeline      
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id

      users_following_pending = current_user.following(0)
      list_following_ids_pending = users_following_pending.map{|u| u.id}
    
      @selfies = Selfie.where("(user_id in (?)) or (user_id in (?) and private = false) and blocked = false", list_following_ids, list_following_ids_pending).order("created_at DESC").paginate(:page => params["page"])

      # Number of New Notifications
      unread_notifications = current_user.notifications.where(read: 0)
      # Number of New Friends Request
      pending_request = current_user.followers(0)

      render json: @selfies, meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}
    end
    

    def refresh
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id

      users_following_pending = current_user.following(0)
      list_following_ids_pending = users_following_pending.map{|u| u.id}      

      @selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false)) and id >= ? and blocked = false", list_following_ids, list_following_ids_pending, params[:last_selfie_id]).order("created_at DESC")

      # Number of New Notifications
      unread_notifications = current_user.notifications.where(read: 0)
      # Number of New Friends Request
      pending_request = current_user.followers(0)
      
      render json: @selfies, meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}
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
      render :json=> {:success=>true, :approval_status=>selfie.approval_status}
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
      render :json=> {:success=>true, :approval_status=>selfie.approval_status}
    end

    def list_comments
      selfie = Selfie.find(params[:id])      

      if params[:all_comment] == "false"
        render json: selfie.comments.last(20)
      else
        render json: selfie.comments.last(100)
      end
    end

    def show
      selfie = Selfie.find(params[:id])
      render json: selfie
    end    

    def create            
      @selfie = Selfie.new
      @selfie.message = params[:message]
      @selfie.private = params[:is_private]
      @selfie.shared_fb = params[:is_shared_fb]
      challenge = Challenge.find(params[:challenge_id])
      @selfie.challenge = challenge
            
      @selfie.photo = params[:mobile_upload_file]
      @selfie.photo_file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_selfie_mobileupload.jpg"      

      @selfie.user = current_user
      
      daily_challenge = DailyChallenge.last   
      if @selfie.challenge == daily_challenge.challenge     
        @selfie.is_daily = true   
      end

      if @selfie.save
        #Share the selfie on Facebook
        if @selfie.shared_fb == true
          @graph = Koala::Facebook::API.new(current_user.oauth_token)                    
          if Rails.env.production?                        
            @graph.put_picture(@selfie.photo.url(:mobile).split("?")[0], { "message" => @selfie.message })
          else            
            @graph.put_picture("#{Rails.root}/public" + @selfie.photo.url(:mobile).split("?")[0], { "message" => @selfie.message })
          end
        end 

        render :json=> {:success=>true}        
      else
        render :json=> {:success=>false}        
      end
    end

    def flag_selfie
      selfie = Selfie.find(params[:selfie_id])
      selfie.flag_count += 1
      if selfie.save
        render :json=> {:success=>true}
      else
        render :json=> {:success=>false}
      end
    end

    def destroy
      selfie = Selfie.find(params[:selfie_id])

      if selfie.user == current_user
        if (selfie.destroy)
          #Delete Notifications related to that selfie
          notifications_to_delete = Notification.where(selfie_id: params[:selfie_id])
          notifications_to_delete.each do |notification|
            notification.destroy
          end
          render :json=> {:success=>true}
        else 
          render :json=> {:success=>false}
        end
      else 
          render :json=> {:success=>false}
      end      
    end

  end    
end