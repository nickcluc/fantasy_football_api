class AddIndicesToTeamMatchups < ActiveRecord::Migration[5.2]
  def change
    add_index :team_matchups, :opponent_id
    add_index :team_matchups, :team_id
    add_index :team_matchups, :season_id
  end
end
