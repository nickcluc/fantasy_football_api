class TeamSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
    :league_year,
    :name,
    :points_for,
    :points_against,
    :wins,
    :losses

  set_key_transform :dash
end
