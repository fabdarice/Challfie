class AddAttachmentPhotoToSelfies < ActiveRecord::Migration
  def self.up
    change_table :selfies do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :selfies, :photo
  end
end
