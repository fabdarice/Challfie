class BooksController < ApplicationController
	def new
		@book = Book.new
	end

	def create
		@book = Book.new(book_params)
		if @book.save
			flash[:notice] = "New book has been created."
			redirect_to controller:'administration', action:'books'
		else
			flash[:alert] = "Failed to create a new book."
			render 'new'
		end
	end

	def index
		@books = Book.all
	end

	def edit
		@book = Book.find(params[:id])
	end

	def update
		@book = Book.find(params[:id])
		@book.update_attributes(book_params)

		if @book.save
			redirect_to controller:'administration', action:'books'
		else
			render 'edit'
		end
	end

	def destroy
	   book = Book.find(params[:id])
		session[:return_to] ||= request.referer
		if (book.destroy)
		flash[:notice] = 'Book deleted.'
		end
		redirect_to session[:return_to]
	 end

	private
		def book_params
		  params.require(:book).permit(:name, :required_points, :cover, :level)
		end
end
