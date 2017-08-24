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

  def career_length
    object.teams.count
  end

  def career_wins
    object.teams.pluck(:wins).inject(0){|sum,x| sum + x }
  end

  def career_losses
    object.teams.pluck(:losses).inject(0){|sum,x| sum + x }
  end

  def min_score
    object.regular_season_scores_array.min
  end

  def max_score
    object.regular_season_scores_array.max
  end
end
