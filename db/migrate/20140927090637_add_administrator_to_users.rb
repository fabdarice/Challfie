class AddAdministratorToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :administrator, :integer, :default => 0
  end
end
