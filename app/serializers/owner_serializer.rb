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
    :max_score,
    :head_to_head_vs_all

  has_many :teams
  has_many :team_matchups
  has_many :championships, record_type: :season
  has_many :second_places, record_type: :season
  has_many :third_places, record_type: :season
  has_many :last_places, record_type: :season
end
