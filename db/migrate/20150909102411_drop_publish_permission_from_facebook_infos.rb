class DropPublishPermissionFromFacebookInfos < ActiveRecord::Migration
  def change
  	remove_column :facebook_infos, :publish_permissions
  end
end
