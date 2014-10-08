class BooksController < ApplicationController
	before_filter :redirect_if_not_admin, :only => [:new, :create, :edit, :update, :destroy]

	def new
		@book = Book.new
	end

	def show
		@book = Book.find(params[:id])
		if @book.level > current_user.book_level
			render 'selfies/restricted'
		else
		
			@challenges = @book.challenges.order('difficulty ASC')

			# Test if Book unlock first
			render :layout => false
		end
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
		  params.require(:book).permit(:name, :required_points, :cover, :level, :thumb)
		end
end
