module Api
  class AdministratorsController < ApplicationController

    before_filter :authenticate_user_from_token!
    respond_to :json

    def list_flag_selfies
      if current_user.administrator >= 3
        selfies = Selfie.where('flag_count > 0 and blocked = false and hidden = false').order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
        selfies_json = []
        selfies.each do |selfie|
          selfies_json << selfie if selfie.user.blocked == false
        end
        render json: selfies_json
      else
        render :json=> {:success=>false}
      end
    end    

    def block_selfie
      if current_user.administrator >= 3
        selfie = Selfie.find(params[:selfie_id])
        selfie.blocked = true
        selfie.hidden = true
        selfie_approved = selfie.approval_status

        if selfie.is_daily or selfie.challenge.book.tier == 0                           
          challenge_very_easy = selfie.user.current_book.challenges.where("difficulty = ?", selfie.challenge.difficulty).first              
          challenge_points = challenge_very_easy.point               
        else                        
          challenge_points = selfie.challenge.point
        end  
        

        if selfie.save
          # remove points win by this selfie if it was approved
          if selfie_approved == 1
            selfie.user.points = selfie.user.points - challenge_points
            selfie.user.save
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

    def block_user
      if current_user.administrator >= 3
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
      if current_user.administrator >= 3
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