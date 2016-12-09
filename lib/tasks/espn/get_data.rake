namespace :get_data do
  desc "Get owner data from ESPN"
  task :owners => :environment do
    league_years = 2011..Time.new.year

    league_years.each do |year|
      query = {
        leagueId: '445805',
        seasonId: year
      }
      req = HTTParty.get('http://games.espn.com/ffl/api/v2/leagueSettings', query: query )

      settings = req['leaguesettings']
      # Create or Update members
      settings['leagueMembers'].each do |member_json|
        next if member_json['userProfileId'] == -1
        owner = Owner.find_or_initialize_by( espn_id: member_json['userProfileId'] )

        if owner.new_record?
          transaction_type = "created"
        else
          transaction_type = "updated"
        end

        owner.first_name = member_json['firstName']
        owner.last_name = member_json['lastName']
        owner.username = member_json['userName']
        owner.league_creator = member_json['isLeagueCreator']
        owner.league_manager = member_json['isLeagueManager']
        puts "Owner #{owner.full_name} #{transaction_type}!" if owner.save!
      end
    end
  end
end
