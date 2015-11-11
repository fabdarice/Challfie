class ChangeColumnsForMatchups < ActiveRecord::Migration
  def change
  	rename_column :matchups, :end_date, :start_date
  	add_column :matchups, :duration, :int, :default => 1
  end
end
