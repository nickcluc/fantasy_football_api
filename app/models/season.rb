class Season < ApplicationRecord
  has_one :champion, class_name: "Owner"
  has_one :second_place, class_name: "Owner"
  has_one :third_place, class_name: "Owner"
  has_one :last_place, class_name: "Owner"

  def team_matchups
    TeamMatchup.where(season_id: league_year)
  end

  def total_median_score
    weeks = team_matchups.pluck(:week_number).uniq
    week_scores = weeks.map { |week| scores_per_week(week) }
    medians = week_scores.map { |scores| Statistics.median(scores) }
    Statistics.sum(medians)
  end

  def self.all_total_medians
    Statistics.sum Season.all.map(&:total_median_score)
  end

  private

  def scores_per_week(week_number)
    team_matchups.where(week_number: week_number).pluck(:score)
  end
end
