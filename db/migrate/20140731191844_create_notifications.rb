class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.text :message
    	t.references :user
      t.references :author    	
    	t.references :selfie
    	t.boolean :read, :default => false
      t.timestamps
    end
  end
end
