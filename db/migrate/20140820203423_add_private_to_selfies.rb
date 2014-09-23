class AddPrivateToSelfies < ActiveRecord::Migration
  def change
  		add_column :selfies, :private, :boolean, :default => false
  end
end
