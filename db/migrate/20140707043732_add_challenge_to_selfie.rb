class AddChallengeToSelfie < ActiveRecord::Migration
  def self.up
    add_column :selfies, :challenge_id, :integer
    add_index :selfies, :challenge_id
  end

  def self.down
    remove_column :selfies, :challenge_id
  end
end
