class AddHiddenToSelfies < ActiveRecord::Migration
  def change
  	add_column :selfies, :hidden, :boolean, :default => false
  end
end
