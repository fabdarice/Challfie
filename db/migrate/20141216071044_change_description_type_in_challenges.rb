class ChangeDescriptionTypeInChallenges < ActiveRecord::Migration
  def change
  	change_column :challenges, :description_fr, :text
  end
end
