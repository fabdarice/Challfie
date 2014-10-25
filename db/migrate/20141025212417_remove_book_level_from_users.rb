class RemoveBookLevelFromUsers < ActiveRecord::Migration
  def change
  	  remove_column :users, :book_level
  end
end
