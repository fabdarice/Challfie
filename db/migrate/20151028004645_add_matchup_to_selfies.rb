class AddMatchupToSelfies < ActiveRecord::Migration
  def change
  	add_reference :selfies, :matchup, index: true
  end
end
