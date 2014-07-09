class CreateCategoryChallenges < ActiveRecord::Migration
  def change
    create_table :category_challenges do |t|
    	t.references :category
    	t.references :challenge
      t.timestamps
    end
  end
end
