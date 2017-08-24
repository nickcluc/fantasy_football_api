class OwnerSerializer < ActiveModel::Serializer
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
    :regular_season_scores_array,
    :min_score,
    :max_score

  has_many :teams

  def teams
    object.teams.order('league_year')
  end
end
