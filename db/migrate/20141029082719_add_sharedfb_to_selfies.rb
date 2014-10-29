class AddSharedfbToSelfies < ActiveRecord::Migration
  def change
  	add_column :selfies, :shared_fb, :boolean, :default => false
  end
end
