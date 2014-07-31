class AddLevelToBook < ActiveRecord::Migration
  def change
  	add_column :books, :level, :integer
  end
end
