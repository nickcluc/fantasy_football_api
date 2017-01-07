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

  def points
    total_points_array.inject(0){|accum, i| accum + i }
  end

  def average_regular_season_score
    Statistics.average(teams.pluck(:points_for), team_matchups.where(regular_season: true).count)
  end

  def average_weekly_score

  end
end
