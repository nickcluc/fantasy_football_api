class AddRegularSeasonToTeamMatchups < ActiveRecord::Migration[5.0]
  def change
    add_column :team_matchups, :regular_season, :boolean
  end
end
