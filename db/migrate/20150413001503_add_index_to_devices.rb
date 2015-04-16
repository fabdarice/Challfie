class AddIndexToDevices < ActiveRecord::Migration
  def change
  	add_index :devices, :token
  	add_index :devices, :user_id
  end
end
