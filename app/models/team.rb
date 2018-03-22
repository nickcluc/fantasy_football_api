class Team < ApplicationRecord
  include Statistics

  belongs_to :owner
  belongs_to :web_response
  has_many   :team_matchups


  def scores
    team_matchups.pluck(:score)
  end

  def regular_season_matchup_count
    team_matchups.where(regular_season: true).count
  end

  def score_by_week(week_number)
    team_matchups.find_by(week_number: week_number).score
  end

  def sum
    Statistics.sum(scores)
  end

  def update_total
    total_score = sum
    self.save!
  end

  def regular_season_average_score
    points_for / regular_season_matchup_count
  end

  def league_year_matchups(league_year, regular_season=true)
    team_matchups.where(season_id: league_year, regular_season: regular_season)
  end

  def median
    sorted = scores.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def sample_variance
    scores_arr = scores
    m = scores_arr.inject(0){|accum, i| accum + i }.to_f / scores_arr.size
    sum = scores_arr.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(scores_arr.length - 1).to_f
  end


  def std_dev
    return Math.sqrt(sample_variance).round(3)
  end

  def build_team_matchups
    json = JSON.parse(web_response.response_body).deep_symbolize_keys
    reg_season_week_count = json[:leaguesettings][:regularSeasonMatchupPeriodCount]
    team_id = external_team_id.to_s
    team_id.slice! league_year.to_s
    team_json = json[:leaguesettings][:teams][team_id.to_sym]
    team_json[:scheduleItems].each do |si|
      week_number = si[:matchupPeriodId]
      matchup_json = si[:matchups].first
      if matchup_json[:awayTeamId] == team_id.to_i
        score = matchup_json[:awayTeamScores].first
        opponent_external_identifier = "#{league_year}#{matchup_json[:homeTeamId]}" unless matchup_json[:homeTeamId].to_s.empty?
        opponent_score = matchup_json[:homeTeamScores].first unless matchup_json[:homeTeamScores].nil?
      elsif matchup_json[:homeTeamId] == team_id.to_i
        score = matchup_json[:homeTeamScores].first
        opponent_external_identifier = "#{league_year}#{matchup_json[:awayTeamId]}" unless matchup_json[:awayTeamId].to_s.empty?
        opponent_score = matchup_json[:awayTeamScores].first unless matchup_json[:awayTeamScores].nil?
      end
      begin
        tm = TeamMatchup.find_or_initialize_by(team_id: id, week_number: week_number, season_id: league_year)
        tm.regular_season = week_number <= reg_season_week_count
        tm.score = score
        tm.opponent_id = Team.find_by(external_team_id: opponent_external_identifier).id
        tm.opponent_score = opponent_score
        tm.save!
      rescue => err
        print "#{opponent_external_identifier}"
      end
    end
  end

  def self.build_from_json(team_json,league_year, wr)
    # team_json should come from response['leaguesettings']['teams'].values.each
    t =                       self.find_or_initialize_by(external_team_id:"#{league_year}#{team_json['teamId']}".to_i)
    t.web_response =          wr
    t.owner =                 Owner.find_by(espn_id: team_json['owners'].first['ownerId'])
    t.name =                  "#{team_json['teamLocation']} #{team_json['teamNickname']}"
    t.logo_url =              team_json['logoUrl']
    t.abbreviation =          team_json['teamAbbrev']
    t.wins =                  team_json['record']['overallWins']
    t.losses =                team_json['record']['overallLosses']
    t.ties =                  team_json['record']['overallTies']
    t.points_for =            team_json['record']['pointsFor']
    t.points_against =        team_json['record']['pointsAgainst']
    t.league_year =           league_year
    t.standing =              team_json['record']['overallStanding']
    t.current_streak =        team_json['record']['streakLength']
    t.acquisitions =          team_json['teamTransactions']['overallAcquisitionTotal'] - team_json['teamTransactions']['offseasonAcquisitionTotal']
    t.acquisition_spent =     team_json['teamTransactions']['acquisitionBudgetSpent']
    t.acquisition_remaining = 100 - t.acquisition_spent
    t.drops =                 team_json['teamTransactions']['drops']
    t.trades =                team_json['teamTransactions']['trades']

    t
  end
end
