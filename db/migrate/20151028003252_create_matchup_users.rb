class CreateMatchupUsers < ActiveRecord::Migration
  def change
    create_table :matchup_users do |t|
    	t.belongs_to :matchup, index: true
    	t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
