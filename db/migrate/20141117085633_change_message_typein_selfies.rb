class ChangeMessageTypeinSelfies < ActiveRecord::Migration
  def change
  	change_column :selfies, :message, :text
  end
end
