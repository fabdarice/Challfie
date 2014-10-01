class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
    	t.string :email
    	t.text :message
    	t.integer :type_contact
      t.timestamps
    end
  end
end
