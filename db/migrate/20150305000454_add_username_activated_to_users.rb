class AddUsernameActivatedToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :username_activated, :boolean, :default => false
  end
end
