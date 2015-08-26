class AddVisibleAndActiveColumnToBooks < ActiveRecord::Migration
  def change
  	add_column :books, :visible, :boolean, :default => true
  	add_column :books, :active, :boolean, :default => true
  end
end
