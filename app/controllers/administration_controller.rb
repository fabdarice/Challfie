class AdministrationController < ApplicationController
	def challenges
		@books = Book.order("id")
	end

	def books
		@books = Book.order("id").paginate(page: params[:page])
	end

	def categories
		@categories = Category.order("name").paginate(page: params[:page])
	end
end
