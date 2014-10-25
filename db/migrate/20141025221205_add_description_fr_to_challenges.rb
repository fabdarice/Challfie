class AddDescriptionFrToChallenges < ActiveRecord::Migration
  def change
  	add_column :challenges, :description_fr, :string
  end
end
