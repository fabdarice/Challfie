class AddTypeToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :type_notification, :int, :default => 0
  end
end
