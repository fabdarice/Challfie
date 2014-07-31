class CommentsController < ApplicationController
	def create
    @selfie = Selfie.find(params[:selfie_id])
    @comment = @selfie.comments.build(comments_params)
    @comment.user = current_user
    @comment.save    

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
