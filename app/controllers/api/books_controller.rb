module Api
    class BooksController < ApplicationController
      before_filter :authenticate_user_from_token!
      respond_to :json

    	def index
        books = Book.all.order('level ASC')
        render json: books
      end

      def level_progression
        unread_notifications = current_user.notifications.where(read: 0)
        pending_request = current_user.followers(0)
        progress_percentage = current_user.next_book_progression
        current_level = current_user.current_book.name
        next_level = current_user.next_book.name

        render :json=> {:success=>true, progress_percentage: progress_percentage, current_level: current_level, next_level: next_level,
          new_alert_nb: unread_notifications.count, new_friends_request_nb: pending_request.count}
      end
      
    end
end
