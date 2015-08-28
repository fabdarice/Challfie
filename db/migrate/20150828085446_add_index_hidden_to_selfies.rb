class AddIndexHiddenToSelfies < ActiveRecord::Migration
  def change
  	add_index :selfies, :hidden
  	add_index :selfies, :blocked
  	add_index :selfies, :private
  end
end
