namespace :get_data do
  desc "Make web Request and store response"
  task :request => :environment do
    LEAGUE_YEARS.each do |year|
      query = { leagueId: '445805', seasonId: year }
      wr = WebResponse.find_or_initialize_by league_year: year
      if wr.updated_at.today?
        puts "We already updated #{wr.league_year} today"
        next
      end
      response = HTTParty.get 'http://games.espn.com/ffl/api/v2/leagueSettings', query: query
      wr.external_league_id = response['metadata']['leagueId']
      wr.response_body = response.body
      wr.save!
    end
  end

  desc "Get owner data from ESPN"
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
end
