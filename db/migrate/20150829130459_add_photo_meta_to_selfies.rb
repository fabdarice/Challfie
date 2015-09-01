class AddPhotoMetaToSelfies < ActiveRecord::Migration
  def change
  	add_column :selfies, :photo_meta, :text
  end
end
