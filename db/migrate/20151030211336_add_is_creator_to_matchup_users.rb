class AddIsCreatorToMatchupUsers < ActiveRecord::Migration
  def change
  	add_column :matchup_users, :is_creator, :boolean, :default => false, index: true
  end
end
