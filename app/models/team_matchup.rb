class TeamMatchup < ApplicationRecord
  belongs_to :team

  after_save :update_total

  def date
    szn = Season.find_by(league_year: season_id)
    szn.first_week_date + (week_number - 1).weeks
  end

  def opponent
    Team.find(opponent_id) unless bye?
  end

  def win?
    score > opponent_score unless bye?
  end

  def loss?
    !win?
  end

  def bye?
    opponent_id.nil? && opponent_score.nil?
  end

  def lucky_win?
    raise "Not a win" unless win?
    weekly_head_to_head_whole_league <= 0.333
  end

  def final_score
    "#{team.abbreviation}: #{score} - #{opponent.abbreviation}: #{opponent_score}"
  end

  def weekly_head_to_head_whole_league
    w = 0
    l = 0
    d = 0
    matchups = TeamMatchup.where(season_id: season_id, week_number: week_number, regular_season:true).where.not(id: id)
    matchups.each do |match|
      if score > match.score
        w += 1
      elsif score < match.score
        l += 1
      else
        d += 1
      end
    end
    (w.to_f/(matchups.count - d).to_f).round(3)
  end

  protected

  def update_total
    team.total_score = team.sum
    team.save!
  end
end
