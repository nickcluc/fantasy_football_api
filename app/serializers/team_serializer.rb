class TeamSerializer < ActiveModel::Serializer
  attributes :id,
  :league_year,
  :name,
  :points_for,
  :points_against,
  :wins,
  :losses
end
