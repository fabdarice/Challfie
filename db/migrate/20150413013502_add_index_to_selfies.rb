class AddIndexToSelfies < ActiveRecord::Migration
  def change
  	add_index :selfies, :user_id  	
  	add_index :selfies, :created_at
  end
end
