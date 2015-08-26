class CreateRailsPushNotificationsApps < ActiveRecord::Migration
  def self.up
    create_table :rails_push_notifications_gcm_apps do |t|
      t.string :gcm_key

      t.timestamps null: false
    end

  end
end
