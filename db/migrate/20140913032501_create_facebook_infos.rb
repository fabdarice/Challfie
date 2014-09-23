class CreateFacebookInfos < ActiveRecord::Migration
  def change
    create_table :facebook_infos do |t|
    	t.belongs_to :user
    	t.string :facebook_uid
  		t.string :facebook_lastname
  		t.string :facebook_firstname
  		t.string :facebook_email  		
  		t.string :facebook_locale
      t.timestamps
    end
  end
end
