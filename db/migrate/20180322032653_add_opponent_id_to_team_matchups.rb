class AddOpponentIdToTeamMatchups < ActiveRecord::Migration[5.1]
  def change
    add_column :team_matchups, :opponent_id, :integer
    add_column :team_matchups, :opponent_score, :integer
  end
end
