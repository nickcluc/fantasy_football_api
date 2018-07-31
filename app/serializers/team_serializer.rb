class TeamSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
    :league_year,
    :name,
    :points_for,
    :points_against,
    :wins,
    :losses

  has_many :team_matchups

  set_key_transform :dash
end
