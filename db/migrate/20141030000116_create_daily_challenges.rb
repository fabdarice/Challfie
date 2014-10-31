class CreateDailyChallenges < ActiveRecord::Migration
  def change
    create_table :daily_challenges do |t|
    	t.belongs_to :challenge
      t.timestamps
    end
  end
end
