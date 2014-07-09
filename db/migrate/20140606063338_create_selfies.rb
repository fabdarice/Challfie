class CreateSelfies < ActiveRecord::Migration
  def change
    create_table :selfies do |t|
      t.belongs_to :user
      t.string :message
      t.timestamps
    end
  end
end
