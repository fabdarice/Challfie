class CategoriesController < ApplicationController
	before_filter :redirect_if_not_admin, :only => [:new, :create, :edit, :update, :destroy]
	
	def new
		@category = Category.new
		@category_challenges = @category.category_challenges.build
	end

	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:notice] = "Success : A new category has been created."
			redirect_to controller:'administration', action:'categories'
		else
			flash[:alert] = "Error : Fail to create a category."
			render 'new'
		end
	end

	def index
		@categories = Category.all
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		@category.updates_attributes(category_params)

		if @category.save
			flash[:notice] = "Success : The category has been updated."
			redirect_to controller:'administration', action:'categories'
		else
			flash[:alert] = "Error : Fail to update the category."
			render 'edit'
		end
	end

	def destroy
	   category = Category.find(params[:id])
		session[:return_to] ||= request.referer
		if (category.destroy)
		flash[:notice] = 'Category deleted.'
		end
		redirect_to controller:'administration', action:'categories'
	 end

	private
	 def category_params
	 	params.require(:category).permit(:name)
	 end
end
