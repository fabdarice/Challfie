module Api
  class AdministratorsController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    def list_flag_selfies
      if current_user.administrator >= 4
        selfies = Selfie.where('flag_count > 0 and blocked = false').order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
        render json: selfies
      else
        render :json=> {:success=>false}
      end
    end    

    def block_selfie
      if current_user.administrator >= 4
        selfie = Selfie.find(params[:selfie_id])
        selfie.blocked = true
        if selfie.save
          render :json=> {:success=>true}
        else
          render :json=> {:success=>false}
        end
      else
        render :json=> {:success=>false}
      end
    end

    def block_user
      if current_user.administrator >= 4
        user = User.find(params[:user_id])
        user.blocked = true
        if user.save
          render :json=> {:success=>true}
        else
          render :json=> {:success=>false}
        end
      else
        render :json=> {:success=>false}
      end
    end

    def clear_flag_selfie
      if current_user.administrator >= 4
        selfie = Selfie.find(params[:selfie_id])
        selfie.flag_count = 0
        if selfie.save
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