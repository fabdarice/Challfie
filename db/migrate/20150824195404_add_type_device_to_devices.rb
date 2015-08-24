class AddTypeDeviceToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :type_device, :int, :default => 0
  end
end
