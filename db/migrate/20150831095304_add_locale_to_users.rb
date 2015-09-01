class AddLocaleToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :locale, :string, :default => "en"

  	add_index :users, :locale
  end
end
