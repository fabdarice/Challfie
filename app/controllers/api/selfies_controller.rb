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

      challfie_admin = User.find_by username: "Challfie"

      if challfie_admin.blank?
        @selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false)) and blocked = false and hidden = false", list_following_ids, list_following_ids_pending).order("created_at DESC").paginate(:page => params["page"])
      else
        @selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false) or (user_id = ? and created_at > ?)) and blocked = false and hidden = false ", list_following_ids, list_following_ids_pending, challfie_admin.id, current_user.created_at).order("created_at DESC").paginate(:page => params["page"])
      end

      # Number of New Notifications
      unread_notifications = current_user.notifications.where(read: 0)
      # Number of New Friends Request
      pending_request = current_user.followers(0)

      render json: @selfies.includes(:user, :challenge), meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count, profile_picture: current_user.show_profile_picture(:medium)}
    end
    

    def refresh
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id

      users_following_pending = current_user.following(0)
      list_following_ids_pending = users_following_pending.map{|u| u.id}    

      challfie_admin = User.find_by username: "Challfie"

      if challfie_admin.blank?
        @selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false)) and id >= ? and blocked = false and hidden = false", list_following_ids, list_following_ids_pending, params[:last_selfie_id]).order("created_at DESC")
      else
        @selfies = Selfie.where("(user_id in (?) or (user_id in (?) and private = false) or (user_id = ? and created_at > ?)) and id >= ? and blocked = false and hidden = false", list_following_ids, list_following_ids_pending, challfie_admin.id, current_user.created_at, params[:last_selfie_id]).order("created_at DESC")    
      end  

      # Number of New Notifications
      unread_notifications = current_user.notifications.where(read: 0)
      # Number of New Friends Request
      pending_request = current_user.followers(0)
      
      render json: @selfies.includes(:user, :challenge), meta: {new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}
    end

    def approve
      selfie = Selfie.find(params[:id])
      selfie.vote_by :voter => current_user

      if selfie.user != current_user        
        selfie.user.add_notifications(" has approved your #{selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_en}</i></strong>\".", 
                            " a approuvé ton #{selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_fr}</i></strong>\".",
                            current_user , selfie, nil, Notification.type_notifications[:selfie_approval])
      end  
      selfie.set_approval_status!("upvote")

          
      render :json=> {:success=>true, :approval_status=>selfie.approval_status}
    end

    def reject
      selfie = Selfie.find(params[:id])
      selfie.downvote_from current_user

      if selfie.user != current_user        
        selfie.user.add_notifications(" has rejected your #{selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_en}</i></strong>\".", 
                            " a rejeté ton #{selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} \"<strong><i>#{selfie.challenge.description_fr}</i></strong>\".",
                            current_user , selfie, nil, Notification.type_notifications[:selfie_approval])
      end

      selfie.set_approval_status!("downvote")

      
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
      render json: selfie, meta: {hidden: selfie.hidden}      
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

      if not params[:approval_status].blank?      
        @selfie.approval_status = params[:approval_status]

        if params[:approval_status] == "1"
          current_user.points = current_user.points + challenge.point
          current_user.save        
        end
      end
      
      current_user_time = Time.now.in_time_zone(current_user.timezone)
      daily_challenge = current_user.daily_challenge      
      if @selfie.challenge == daily_challenge.challenge     
        @selfie.is_daily = true   
      end

      if @selfie.save
        facebook_error = false
        #Share the selfie on Facebook
        if @selfie.shared_fb == true
          begin                
            @graph = Koala::Facebook::API.new(current_user.oauth_token)                    
            @graph.put_picture(@selfie.photo.url(:original).split("?")[0], { "message" => @selfie.message })
          rescue Koala::Facebook::APIError
            logger.debug "[OAuthException] Either the user's access token has expired, they've logged out of Facebook, deauthorized the app, or changed their password"
            current_user.oauth_token = nil 
            current_user.save    
            facebook_error = true
          end   
        end         
        if facebook_error == true
          render :json=> {:success=>false}        
        else
          render :json=> {:success=>true}        
        end
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

      # Not a permanent destroy but a hidden flag
      selfie = Selfie.find(params[:selfie_id])

      selfie.hidden = true

      selfie_approved = selfie.approval_status

      if (selfie.is_daily or selfie.challenge.book.tier == 0) and current_user.username != 'Challfie'                           
        challenge_very_easy = selfie.user.current_book.challenges.where("difficulty = ?", selfie.challenge.difficulty).first              
        challenge_points = challenge_very_easy.point               
      else                        
        challenge_points = selfie.challenge.point
      end      

      if selfie.user == current_user
        if selfie.save          
          # remove points win by this selfie if it was approved
          if selfie_approved == 1 and current_user.username != 'Challfie' 
            current_user.points = current_user.points - challenge_points
            current_user.save
          end

          #Delete Permanently Notifications related to that selfie
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

    def list_approval
      selfie = Selfie.find(params[:selfie_id])

      users = selfie.votes_for.up.by_type(User).voters.paginate(:page => params["page"], :per_page => 20)
      render json: users, each_serializer: FriendsSerializer, scope: current_user

    end


    def list_reject
      selfie = Selfie.find(params[:selfie_id])

      users = selfie.votes_for.down.by_type(User).voters.paginate(:page => params["page"], :per_page => 20)
      render json: users, each_serializer: FriendsSerializer, scope: current_user
    end

  end    
end