class AddFromMobileToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :from_mobileapp, :boolean, :default => false
  end
end
