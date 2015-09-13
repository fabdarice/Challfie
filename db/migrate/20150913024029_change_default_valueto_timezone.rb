class ChangeDefaultValuetoTimezone < ActiveRecord::Migration
  def change
  	change_column :users, :timezone, :string, :default => "Europe/Paris"

  end
end
