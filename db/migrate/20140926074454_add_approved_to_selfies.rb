class AddApprovedToSelfies < ActiveRecord::Migration
  def change
  	add_column :selfies, :approval_status, :integer, :default => 0
  end
end
