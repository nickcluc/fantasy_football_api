class Team < ApplicationRecord
  belongs_to :owner

  private
  def self.build_from_json(team_json,league_year)
    # team_json should come from response['leaguesettings']['teams'].values.each
    t =                       self.find_or_initialize_by(external_team_id:"#{league_year}#{team_json['teamId']}".to_i)
    t.owner =                 Owner.find_by(espn_id: team_json['owners'].first['ownerId'])
    t.name =                  "#{team_json['teamLocation']} #{team_json['teamNickname']}"
    t.logo_url =              team_json['logoUrl']
    t.abbreviation =          team_json['teamAbbrev']
    t.wins =                  team_json['record']['overallWins']
    t.losses =                team_json['record']['overallLosses']
    t.ties =                  team_json['record']['overallTies']
    t.points_for =            team_json['record']['pointsFor']
    t.points_against =        team_json['record']['pointsAgainst']
    t.league_year =           league_year
    t.standing =              team_json['record']['overallStanding']
    t.current_streak =        team_json['record']['streakLength']
    t.acquisitions =          team_json['teamTransactions']['overallAcquisitionTotal'] - team_json['teamTransactions']['offseasonAcquisitionTotal']
    t.acquisition_spent =     team_json['teamTransactions']['acquisitionBudgetSpent']
    t.acquisition_remaining = 100 - t.acquisition_spent
    t.drops =                 team_json['teamTransactions']['drops']
    t.trades =                team_json['teamTransactions']['trades']

    t
  end
end
