class AddFromFacebookToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :from_facebook, :boolean, :default => false
  end
end
