class Owner < ApplicationRecord
  has_many :teams, -> { order(league_year: :asc) }
  has_many :team_matchups, -> { order(matchup_date: :asc) }, through: :teams
  has_many :championships, class_name: "Season", foreign_key: "champion_id"
  has_many :second_places, class_name: "Season", foreign_key: "second_place_id"
  has_many :third_places, class_name: "Season", foreign_key: "third_place_id"
  has_many :last_places, class_name: "Season", foreign_key: "last_place_id"

  def self.luck_hash
    hash = {}
    Owner.all.each { |owner| hash[owner.full_name.gsub(/\s+/, "")] = owner.lucky_wins.count }
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

  def lucky_wins
    winning_matchups.to_a.keep_if { |match| match.lucky_win? }
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
    "#{w}-#{l}-#{d}"
  end

  def head_to_head_vs_all
    hash = {}
    Owner.where.not(id: id).each do |owner|
      hash[owner.full_name] = head_to_head_record(owner.id)
    end
    hash
  end
end
