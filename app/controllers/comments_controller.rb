class CommentsController < ApplicationController
  before_filter :authenticate_user!

	def create
    @selfie = Selfie.find(params[:selfie_id])
    @comment = @selfie.comments.build(comments_params)
    @comment.user = current_user
    if @comment.save
      if @selfie.matchup == nil   
        if @selfie.user != current_user
          @selfie.user.add_notifications(" has commented on your selfie : \"<i>#{@comment.message.truncate(60)}</i>\".", 
                                        " a commenté sur ton selfie : \"<i>#{@comment.message.truncate(60)}</i>\".",
                                        current_user , @selfie, nil, Notification.type_notifications[:comment_mine], nil)

        end 
      
        comment_list_user =  @selfie.comments.select(:user_id).uniq
        comment_list_user.each do |f|
          if f.user != current_user and f.user != @selfie.user               
            f.user.add_notifications(" has commented on <strong>#{@selfie.user.username}'s</strong> selfie : \"<i>#{@comment.message.truncate(60)}</i>\" .", 
                                    " a commenté sur le selfie de <strong>#{@selfie.user.username}</strong> : \"<i>#{@comment.message.truncate(60)}</i>\" .",
                                    current_user , @selfie, nil, Notification.type_notifications[:comment_other], nil)
          end  
        end 
      else
        if @selfie.user != current_user
          @selfie.user.add_notifications(" has commented on your selfie duel : \"<i>#{@comment.message.truncate(60)}</i>\".", 
                                        " a commenté sur ton selfie duel : \"<i>#{@comment.message.truncate(60)}</i>\".",
                                        current_user , @selfie, nil, Notification.type_notifications[:matchup], @selfie.matchup)
        end  

        comment_list_user =  @selfie.comments.select(:user_id).uniq
        comment_list_user.each do |f|
          if f.user != current_user and f.user != @selfie.user               
            f.user.add_notifications(" has commented on <strong>#{@selfie.user.username}'s</strong> selfie duel: \"<i>#{@comment.message.truncate(60)}</i>\" .", 
                                    " a commenté sur le selfie duel de <strong>#{@selfie.user.username}</strong> : \"<i>#{@comment.message.truncate(60)}</i>\" .",
                                    current_user , @selfie, nil, Notification.type_notifications[:matchup], @selfie.matchup)
          end  
        end 
      end   
    end   

    respond_to do |format|
      format.html { render :nothing => true }
      format.js { }
    end    
  end

  def show_selfie_comments
    @selfie = Selfie.find(params[:id])
    @comments = @selfie.comments.includes(:user)

    respond_to do |format|
      format.html { render :nothing => true }
      format.js { }
    end 
  end

  private
		def comments_params
			params.require(:comment).permit(:message)
		end
end
