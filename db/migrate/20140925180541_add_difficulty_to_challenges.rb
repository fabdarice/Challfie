class AddDifficultyToChallenges < ActiveRecord::Migration
  def change
  	add_column :challenges, :difficulty, :integer
  end
end
