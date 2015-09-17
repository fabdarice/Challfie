class AddPriorityToChallenge < ActiveRecord::Migration
  def change
  	add_column :challenges, :priority, :int, :default => 0

  	add_index :challenges, :priority  	
  end
end
