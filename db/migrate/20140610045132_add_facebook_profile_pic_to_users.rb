class AddFacebookProfilePicToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :facebook_picture, :string
  end
end
