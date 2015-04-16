class AddIndexToFacebookInfos < ActiveRecord::Migration
  def change
  	add_index :facebook_infos, :user_id
  end
end
