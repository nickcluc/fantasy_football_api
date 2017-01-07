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
      response.teams.each{|team_json| Team.build_from_json(team_json,response.league_year.to_i).save! }
    end
  end

  desc "Parse Team Matchups data from ESPN"
  task :team_matchups => :environment do
    Team.all.each do |team|
      team.build_team_matchups
    end
  end
end
