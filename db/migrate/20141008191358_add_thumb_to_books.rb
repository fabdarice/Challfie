class AddThumbToBooks < ActiveRecord::Migration
  def self.up
    change_table :books do |t|
      t.attachment :thumb
    end
  end

  def self.down
    drop_attached_file :books, :thumb
  end
end
