class AddStatusToMatchups < ActiveRecord::Migration
  def change
  	#challfie #selfie #challenge #selfiechallenge
  	add_column :matchups, :status, :int, default: 0, index: true
  end
end
