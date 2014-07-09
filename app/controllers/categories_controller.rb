class CategoriesController < ApplicationController
	def new
		@category = Category.new
		@category_challenges = @category.category_challenges.build
	end

	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:notice] = "Success : A new category has been created."
			redirect_to root_path
		else
			flash[:alert] = "Error : Fail to create a category."
			render 'new'
		end
	end

	def index
		@categories = Category.all
	end

	private
	 def category_params
	 	params.require(:category).permit(:name)
	 end
end
