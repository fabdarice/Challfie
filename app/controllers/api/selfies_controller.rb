module Api
  class SelfiesController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    def timeline
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id
    
      @selfies = Selfie.where("user_id in (?)", list_following_ids).order("created_at DESC").paginate(:page => params["page"])
      #render :json=> {:success=>true, :selfies => @selfies, :user_photo => current_user.avatar.url}
      render json: @selfies
    end

    def refresh
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id
      @selfies = Selfie.where("user_id in (?) and id >= ?", list_following_ids, params[:last_selfie_id]).order("created_at DESC")
      render json: @selfies
    end

    def approve
      selfie = Selfie.find(params[:id])
      selfie.vote_by :voter => current_user

      selfie.set_approval_status!("upvote")

      if selfie.user != current_user
        user_link = view_context.link_to current_user.username, user_path(current_user)     
        selfie.user.add_notifications("#{user_link} has approved your #{selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} <strong><i>#{selfie.challenge.description_en}</i></strong>.", 
                            "#{user_link} a approuvé ton #{selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} <strong><i>#{selfie.challenge.description_fr}</i></strong>.",
                            current_user , selfie, nil)
      end
      
      render :json=> {:success=>true, :approval_status=>selfie.approval_status}
    end

    def reject
      selfie = Selfie.find(params[:id])
      selfie.downvote_from current_user

      selfie.set_approval_status!("downvote")

      if selfie.user != current_user
        user_link = view_context.link_to current_user.username, user_path(current_user)     
        selfie.user.add_notifications("#{user_link} has rejected your #{selfie.is_daily ? "<u>daily challenge</u>" : "challenge"} <strong><i>#{selfie.challenge.description_en}</i></strong>.", 
                            "#{user_link} a rejeté ton #{selfie.is_daily ? "<u>challenge du jour</u>" : "challenge"} <strong><i>#{selfie.challenge.description_fr}</i></strong>.",
                            current_user , selfie, nil)
      end
      render :json=> {:success=>true, :approval_status=>selfie.approval_status}
    end

    def show
      respond_with Selfie.find(params[:id])
    end

    def create
      # respond_with User.create(access_token: params[:access_token], city: params[:city], created_at: Time.now, phone: params[:phone], region: params[:region], updated_at: Time.now)
      @selfie = Selfie.create(name: params[:message])      
      respond_to do |format|
        if @selfie.save
          format.json {render json: @selfie}
        else
          format.json {render json: {:error_message => @selfie.error, :status => 402}}
        end
      end
    end



  end    
end