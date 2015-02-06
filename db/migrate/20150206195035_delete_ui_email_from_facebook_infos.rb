class DeleteUiEmailFromFacebookInfos < ActiveRecord::Migration
  def change
  	remove_column :facebook_infos, :facebook_uid
  	remove_column :facebook_infos, :facebook_email
  end
end

