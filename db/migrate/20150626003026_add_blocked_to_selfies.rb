class AddBlockedToSelfies < ActiveRecord::Migration
  def change
  	add_column :selfies, :blocked, :boolean, :default => false
  end
end
