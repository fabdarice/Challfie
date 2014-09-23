class CommentsController < ApplicationController
	def create
    @selfie = Selfie.find(params[:selfie_id])
    @comment = @selfie.comments.build(comments_params)
    @comment.user = current_user
    @comment.save   
    user_link = view_context.link_to current_user.username, user_path(current_user) 

    if @selfie.user != current_user
      @selfie.user.add_notifications("#{user_link} has commented on your selfie : \"<i>#{@comment.message.truncate(60)}</i>\".", current_user , @selfie)
    end  

    comment_list_user =  @selfie.comments.select(:user_id).uniq
    comment_list_user.each do |f|
      if f.user != current_user and f.user != @selfie.user               
        f.user.add_notifications("#{user_link} has commented on <strong>#{@selfie.user.username}'s</strong> selfie : \"<i>#{@comment.message.truncate(60)}</i>\" .", current_user , @selfie)
      end  
    end  

    respond_to do |format|
      format.html { render :nothing => true }
      format.js { }
    end    
  end

  def show_selfie_comments
    @selfie = Selfie.find(params[:id])
    @comments = @selfie.comments

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
