class AddPublishPermissionsToFacebookInfos < ActiveRecord::Migration
  def change
  	 add_column :facebook_infos, :publish_permissions, :boolean, :default => false
  end
end
