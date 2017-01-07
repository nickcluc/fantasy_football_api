class OwnerSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :username, :espn_id, :league_manager, :league_creator, :average_regular_season_score

  has_many :teams
  has_many :team_matchups
end
