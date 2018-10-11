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
    return unless win?
    win_pct_head_to_head_whole_week <= 0.5
  end

  def strong_win?
    return unless win?
    win_pct_head_to_head_whole_week >= 0.666
  end

  def unlucky_loss?
    return unless loss?
    losing_pct_head_to_head_whole_week <= 0.5
  end

  def final_score
    "#{team.abbreviation}: #{score} - #{opponent.abbreviation}: #{opponent_score}"
  end

  def median_score
    return unless regular_season?
    team_matchups = TeamMatchup.select([:season_id, :week_number, :score])
    distinct_weeks = team_matchups.where(regular_season:true).map{|tm| [tm.season_id, tm.week_number]}.uniq
    distinct_weeks.map
    Statistics.median(tms)
    # tms = TeamMatchup.where(season_id: season_id, week_number: week_number, regular_season:true).pluck(:score)
  end

  def weekly_head_to_head_whole_league
    record_hash = {
      w: 0,
      l: 0,
      d: 0
    }

    weekly_matchups.each do |match|
      if score > match.score
        record_hash[:w] += 1
      elsif score < match.score
        record_hash[:l] += 1
      else
        record_hash[:d] += 1
      end
    end
    record_hash
  end

  def weekly_matchups
    TeamMatchup.where(season_id: season_id, week_number: week_number, regular_season:true)
  end

  def win_pct_head_to_head_whole_week
    w = weekly_head_to_head_whole_league[:w]
    d = weekly_head_to_head_whole_league[:d]
    (w.to_f/(weekly_matchups.count - d).to_f).round(3)
  end

  def losing_pct_head_to_head_whole_week
    l = weekly_head_to_head_whole_league[:l]
    d = weekly_head_to_head_whole_league[:d]
    (l.to_f/(weekly_matchups.count - d).to_f).round(3)
  end

  def self.no_dates
    TeamMatchup.where(matchup_date: nil)
  end

  protected

  def update_total
    team.total_score = team.sum
    team.save!
  end
end
