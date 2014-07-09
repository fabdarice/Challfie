class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
    	t.integer :point
    	t.text :description
    	t.belongs_to :book
      t.timestamps
    end
  end
end
