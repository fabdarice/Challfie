class AddBookToNotifications < ActiveRecord::Migration
  def change
  	add_reference :notifications, :book, index: true
  end
end
