class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.text :message
      t.references :selfie
      t.references :user
      t.timestamps
    end
  end
end
