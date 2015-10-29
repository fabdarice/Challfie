class CreateMatchups < ActiveRecord::Migration
  def change
    create_table :matchups do |t|
    	t.belongs_to :challenge, index:true
    	t.references :winner, references: :users, index: true
    	t.integer :type
    	t.datetime :end_date
      t.timestamps
    end
  end
end
