class AddMatchupToNotifications < ActiveRecord::Migration
  def change
  	add_reference :notifications, :matchup, index: true
  end
end
