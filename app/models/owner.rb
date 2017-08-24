class Owner < ApplicationRecord
  has_many :teams
  has_many :team_matchups, through: :teams

  def full_name
    "#{first_name} #{last_name}"
  end

  # Regular Season & Post Season
  def total_points_array
    teams.pluck(:total_score)
  end

  # Regular Season
  def points_for_array
    teams.pluck(:points_for)
  end

  def points_against_array
    teams.pluck(:points_against)
  end

  def regular_season_scores_array
    team_matchups.where(regular_season: true).pluck(:score)
  end

  def total_points
    Statistics.sum(points_for_array).round(2)
  end

  def total_points_against
    Statistics.sum(points_against_array).round(2)
  end

  def average_total_points
    Statistics.average(points_for_array, points_for_array.count).round(2)
  end

  def average_regular_season_score
    Statistics.average(teams.pluck(:points_for), team_matchups.where(regular_season: true).count).round(2)
  end

  def self.sorted_by_average_regular_season_score
    Owner.all.sort_by(&:average_regular_season_score).reverse
  end
end
