class AddCurrentDailyChallengeToUsers < ActiveRecord::Migration
  def change
  	add_reference :users, :daily_challenge, index: true  	
  end
end
