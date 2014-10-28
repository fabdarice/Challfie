class AddMessageFrToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :message_fr, :string
  end
end
