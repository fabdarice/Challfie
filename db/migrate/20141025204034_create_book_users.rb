class CreateBookUsers < ActiveRecord::Migration
  def change
    create_table :book_users do |t|
    	t.references :book
    	t.references :user      
      t.timestamps
    end
  end
end
