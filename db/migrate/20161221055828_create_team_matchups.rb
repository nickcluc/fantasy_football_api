class CreateTeamMatchups < ActiveRecord::Migration[5.0]
  def change
    create_table :team_matchups do |t|
      t.integer :team_id
      t.integer :score
      t.integer :season_id
      t.integer :week_number
      t.timestamps
    end
  end
end
