class Owner < ApplicationRecord
  has_many :teams, -> { order(league_year: :desc) }
  has_many :team_matchups, -> { order(matchup_date: :asc) }, through: :teams
  has_many :championships, -> { order(league_year: :desc) }, class_name: "Season", foreign_key: "champion_id"
  has_many :second_places, -> { order(league_year: :desc) }, class_name: "Season", foreign_key: "second_place_id"
  has_many :third_places, -> { order(league_year: :desc) }, class_name: "Season", foreign_key: "third_place_id"
  has_many :last_places, -> { order(league_year: :desc) }, class_name: "Season", foreign_key: "last_place_id"

  def self.luck_hash
    hash = {}
    Owner.all.map do |owner|
      wins            = owner.winning_matchups.count
      losses          = owner.losing_matchups.count
      lucky_wins      = owner.lucky_wins.count
      strong_wins     = owner.strong_wins.count
      unlucky_losses  = owner.unlucky_losses.count
      lucky_factor    = (lucky_wins.to_f / wins.to_f).round(5)
      unlucky_factor  = -(unlucky_losses.to_f / losses.to_f).round(5)
      {
        name: owner.full_name,
        stats:{
          wins: wins,
          losses: losses,
          lucky_wins: lucky_wins,
          strong_wins: strong_wins,
          unlucky_losses: unlucky_losses,
          lucky_factor: lucky_factor,
          unlucky_factor: unlucky_factor,
        },
        luck_score: (lucky_factor + unlucky_factor).round(5),
      }
    end.sort_by{|hash| hash[:luck_score]}.reverse
  end

  def self.strong_hash
    hash = {}
    Owner.all.each { |owner| hash[owner.full_name.gsub(/\s+/, "")] = owner.strong_wins.count }
    hash
  end

  def regular_season_scores_array
    regular_season_matchups.pluck(:score)
  end

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

  def regular_season_matchups
    team_matchups.where(regular_season: true)
  end

  def winning_matchups
    regular_season_matchups.where('score > opponent_score')
  end

  def losing_matchups
    regular_season_matchups.where('score < opponent_score')
  end

  def lucky_wins
    winning_matchups.to_a.keep_if { |match| match.lucky_win? }
  end

  def strong_wins
    winning_matchups.to_a.keep_if { |match| match.strong_win? }
  end

  def unlucky_losses
    losing_matchups.to_a.keep_if { |match| match.unlucky_loss? }
  end

  def league_year_matchups(league_year=nil, regular_season=nil)
    matchups = team_matchups
    matchups = matchups.where(regular_season: regular_season) unless regular_season.nil?
    matchups = matchups.where(season_id: league_year) unless league_year.nil?
    matchups
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

  def career_length
    teams.count
  end

  def career_wins
    teams.pluck(:wins).inject(0){|sum,x| sum + x }
  end

  def career_losses
    teams.pluck(:losses).inject(0){|sum,x| sum + x }
  end

  def min_score
    regular_season_matchups.pluck(:score).min
  end

  def max_score
    regular_season_matchups.pluck(:score).max
  end

  def py_expectation
    tpa = Season.all_total_medians
    exp = 1.5*Math.log((total_points+tpa)/regular_season_matchups.count)
    ((total_points**exp)/(total_points**exp+tpa**exp))*regular_season_matchups.count
    # 1/(1+(totsl_points/total_points_against)**2)
  end

  def head_to_head_record(other_owner_id,regular_season=true)
    return if other_owner_id == self.id
    other_owner = Owner.find(other_owner_id)
    w = 0
    l = 0
    d = 0
    league_year_matchups(nil,regular_season).where(opponent_id: other_owner.teams.pluck(:id)).each do |match|
      if match.win?
        w += 1
      elsif match.loss?
        l += 1
      else
        d += 1
      end
    end
    {
      name: other_owner.full_name,
      wins: w,
      losses: l,
      draws: d,
    }
  end

  def head_to_head_vs_all
    Owner.where.not(id: id).map do |owner|
      head_to_head_record(owner.id)
    end
  end

  def opponents
    Owner.where.not(id: self.id)
  end

  def weekly_record_vs_everyone(season, week)
    other_matchups = TeamMatchup.where(week_number: week_number, season_id: season_id).not(team_id: team_id)
  end
end
