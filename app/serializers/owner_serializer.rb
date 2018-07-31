class OwnerSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
    :first_name,
    :last_name,
    :full_name,
    :username,
    :espn_id,
    :league_manager,
    :league_creator,
    :total_points,
    :total_points_against,
    :career_length,
    :career_wins,
    :career_losses,
    :average_total_points,
    :average_regular_season_score,
    :min_score,
    :max_score

  has_many :teams
  has_many :team_matchups
  has_many :championships
  has_many :second_places
  has_many :third_places
  has_many :last_places
end
