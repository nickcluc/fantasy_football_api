namespace :parse_data do
  desc "Parse owner data from ESPN response"
  task :owners => :environment do
    WebResponse.all.each do |response|
      # Create or Update members
      JSON.parse(response.response_body)['leaguesettings']['leagueMembers'].each do |member_json|
        next if member_json['userProfileId'] == -1

        owner = Owner.find_or_initialize_by espn_id: member_json['userProfileId']
        owner.first_name = member_json['firstName']
        owner.last_name = member_json['lastName']
        owner.username = member_json['userName']
        owner.league_creator = member_json['isLeagueCreator']
        owner.league_manager = member_json['isLeagueManager']
        if owner.new_record?
          transaction_type = "created"
        elsif owner.changed?
          transaction_type = "updated"
        else
          puts "Owner #{owner.full_name} no change"
          next
        end
        puts "Owner #{owner.full_name} #{transaction_type}!" if owner.save!
      end
    end unless WebResponse.count == 0
  end

  desc "Parse Team data from ESPN"
  task :teams => :environment do
    WebResponse.all.each do |response|
      response.teams.each do |team_json|
        begin
          t = Team.build_from_json(team_json,response.league_year.to_i, response)
          t.save!
        rescue => err
          puts "error for response #{response.id}: #{err.backtrace}"
        end
      end
    end
  end

  desc "Parse Team Matchups data from ESPN"
  task :team_matchups => :environment do
    Team.all.each do |team|
      team.build_team_matchups
    end

    TeamMatchup.no_dates.each do |matchup|
      TeamMatchup.transaction do
        szn = Season.find_by(league_year: matchup.season_id)
        matchup.matchup_date = szn.first_week_date + (matchup.week_number - 1).weeks
        matchup.save!
      end
    end
  end

  desc "Parse Season Data"
  task :seasons => :environment do
    KICKOFF_HASH = {
      "2011" => "12/9/2011",
      "2012" => "10/9/2012",
      "2013" => "9/9/2013",
      "2014" => "8/9/2014",
      "2015" => "14/9/2015",
      "2016" => "12/9/2016",
      "2017" => "11/9/2017",
      "2018" => "10/9/2018"
    }
    WebResponse.all.each do |response|
      json = JSON.parse response.response_body
      Season.transaction do
        season = Season.find_or_initialize_by(league_year: response.league_year)

        season.first_week_date = Date.parse KICKOFF_HASH[season.league_year.to_s]
        if json['leaguesettings']['finalCalculatedRanking']
          champ_id = json['leaguesettings']['finalCalculatedRanking'][0] || nil
          second_id = json['leaguesettings']['finalCalculatedRanking'][1] || nil
          third_id = json['leaguesettings']['finalCalculatedRanking'][2] || nil
          last_id = json['leaguesettings']['playoffSeedings'].last || nil
          season.champion_id = Owner.find_by(espn_id: json['leaguesettings']['teams'][champ_id.to_s]['owners'].first['ownerId']).id
          season.second_place_id = Owner.find_by(espn_id: json['leaguesettings']['teams'][second_id.to_s]['owners'].first['ownerId']).id
          season.third_place_id = Owner.find_by(espn_id: json['leaguesettings']['teams'][third_id.to_s]['owners'].first['ownerId']).id
          season.last_place_id = Owner.find_by(espn_id: json['leaguesettings']['teams'][last_id.to_s]['owners'].first['ownerId']).id
        end

        season.save!
      end
    end
  end
end
