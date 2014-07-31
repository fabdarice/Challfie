class SelfiesController < ApplicationController
	before_filter :authenticate_user!

	def new
		@selfie = Selfie.new
	end

	def create
		@selfie = Selfie.new(selfie_params)
		@selfie.user = current_user

		if @selfie.save
			redirect_to root_path
		else
			render 'selfies/new'
		end
	end

	def filter_by_keyword
	    if params[:search] == 'emptySelection'
	      @challenges = Challenge.all
	    else
	      @solr_search = Challenge.search do
	        fulltext params[:search]
	      end      
	      @challenges = @solr_search.results
	    end

	    respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	    end
	end

	def update
		@selfie = Selfie.find(params[:id])
		@selfie.update_attributes(selfie_params)
		@selfie.save

		respond_to do |format|
	      format.html { render :nothing => true }
	      format.js { }
	    end
	end

	def destroy
	   selfie = Selfie.find(params[:id])
		session[:return_to] ||= request.referer
		if (selfie.destroy)
		flash[:notice] = 'Book deleted.'
		end
		redirect_to session[:return_to]
	 end

	private

    def selfie_params
      params.require(:selfie).permit(:message, :photo, :challenge_id)
    end



end
