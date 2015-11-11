class ChangeColumnTypeForMatchup < ActiveRecord::Migration
  def change
  	rename_column :matchups, :type, :type_matchup
  	rename_column :matchups, :start_date, :end_date
  end
end
