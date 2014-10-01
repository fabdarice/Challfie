class AdministrationController < ApplicationController
	before_filter :redirect_if_not_admin

	def challenges
		@books = Book.order("id")
	end

	def books
		@books = Book.order("id").paginate(page: params[:page])
	end

	def categories
		@categories = Category.order("name").paginate(page: params[:page])
	end

	def contacts
		@contacts = Contact.order("created_at DESC").paginate(page: params[:page])
	end

	def users
		@users = User.order("lastname").paginate(page: params[:page])
	end
end
