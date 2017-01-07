class AddTotalScoreToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :total_score, :integer
  end
end
