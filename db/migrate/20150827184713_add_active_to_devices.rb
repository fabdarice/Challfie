class AddActiveToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :active, :boolean, :default => true

  	add_index :devices, :active
  	add_index :devices, :type_device
  end
end
