class AddFlagCountToSelfies < ActiveRecord::Migration
  def change
  	add_column :selfies, :flag_count, :int, :default => 0
  end
end
