class BooksController < ApplicationController
	def new
		@book = Book.new
	end

	def create
		@book = Book.new(book_params)
		if @book.save
			flash[:notice] = "New book has been created."
			redirect_to root_path
		else
			flash[:alert] = "Failed to create a new book."
			render 'new'
		end
	end

	def index
		@books = Book.all
	end

	private
		def book_params
		  params.require(:book).permit(:name, :required_points, :cover)
		end
end
