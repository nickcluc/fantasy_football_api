class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string  :name
      t.string  :abbreviation
      t.string  :logo_url
      t.integer :wins
      t.integer :losses
      t.integer :ties
      t.float   :points_for
      t.float   :points_against
      t.integer :league_year
      t.integer :standing
      t.integer :acquisitions
      t.integer :drops
      t.integer :trades
      t.integer :acquisition_spent
      t.integer :acquisition_remaining
      t.integer :current_streak
      t.integer :owner_id
      t.integer :external_team_id
      t.timestamps
    end
  end
end
