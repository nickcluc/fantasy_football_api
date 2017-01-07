class SetWebResponseIdOnTeam < ActiveRecord::Migration[5.0]
  def change
    Team.all.each do |team|
      team.web_response = WebResponse.find_by(league_year: team.league_year)
      team.save!
    end
  end
end
