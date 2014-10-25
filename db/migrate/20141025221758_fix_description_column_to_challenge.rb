class FixDescriptionColumnToChallenge < ActiveRecord::Migration
  def change
  	rename_column :challenges, :description, :description_en
  end
end
