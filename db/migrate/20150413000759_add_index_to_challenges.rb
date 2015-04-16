class AddIndexToChallenges < ActiveRecord::Migration
  def change
  	add_index :challenges, :book_id
  end
end
