class AddWebResponseToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :web_response_id, :integer
  end
end
