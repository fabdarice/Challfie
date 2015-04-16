class AddIndexToNotifications < ActiveRecord::Migration
  def change
  	add_index :notifications, :user_id
  	add_index :notifications, :author_id
  	add_index :notifications, :selfie_id  	
  	add_index :notifications, :read
  	add_index :notifications, :created_at
  end
end
