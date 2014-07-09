class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
    	t.text :name
    	t.integer :required_points
      t.timestamps
    end
  end
end
