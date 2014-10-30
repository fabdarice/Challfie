class AddIsDailyToSelfies < ActiveRecord::Migration
  def change
  		add_column :selfies, :is_daily, :boolean, :default => false
  end
end
