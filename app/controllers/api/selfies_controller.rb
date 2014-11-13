module Api
  class SelfiesController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    def timeline
      users_following = current_user.following(1)
      list_following_ids = users_following.map{|u| u.id}
      list_following_ids << current_user.id
    
      @selfies = Selfie.where("user_id in (?)", list_following_ids).order("created_at DESC").paginate(:page => params["page"])
      respond_with @selfies
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