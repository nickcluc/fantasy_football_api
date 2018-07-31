class AddDateToMatchup < ActiveRecord::Migration[5.2]
  def change
    add_column :team_matchups, :matchup_date, :date
  end
end
