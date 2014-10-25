class AddTiersToBooks < ActiveRecord::Migration
  def change
  	add_column :books, :tier, :integer
  end
end
