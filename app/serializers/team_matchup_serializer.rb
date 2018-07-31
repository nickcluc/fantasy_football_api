class TeamMatchupSerializer
  include FastJsonapi::ObjectSerializer

  attributes :opponent_id,
    :opponent_score,
    :score,
    :season_id,
    :team_id,
    :matchup_date,
    :week_number

    belongs_to :team
end
