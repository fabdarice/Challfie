class ChangeMessageTypeInNotifications < ActiveRecord::Migration
  def change
  	change_column :notifications, :message_fr, :text
  end
end
