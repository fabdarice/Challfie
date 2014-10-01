class AddCurrentBookLevelToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :book_level, :integer, :default => 1
  end
end
