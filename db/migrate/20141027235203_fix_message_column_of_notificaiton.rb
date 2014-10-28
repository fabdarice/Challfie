class FixMessageColumnOfNotificaiton < ActiveRecord::Migration
  def change
  	rename_column :notifications, :message, :message_en
  end
end
