class AddStatusToFollows < ActiveRecord::Migration
  def change
  	add_column :follows, :status, :integer, :default => 0
  end
end
