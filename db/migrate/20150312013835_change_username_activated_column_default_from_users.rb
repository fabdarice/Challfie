class ChangeUsernameActivatedColumnDefaultFromUsers < ActiveRecord::Migration
  def change
  	change_column :users, :username_activated, :boolean, default: true
  end
end
