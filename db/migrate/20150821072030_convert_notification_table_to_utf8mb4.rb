class ConvertNotificationTableToUtf8mb4 < ActiveRecord::Migration
  def change
  	# for each table that will store unicode execute:
    execute "ALTER TABLE notifications CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"    
  end
end
