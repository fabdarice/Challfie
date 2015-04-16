class AddIndexToBookUsers < ActiveRecord::Migration
  def change
  	add_index :book_users, [:user_id, :book_id], unique: true
  	add_index :book_users, :book_id
  end
end
