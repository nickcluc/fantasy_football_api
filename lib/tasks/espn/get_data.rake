namespace :get_data do
  desc "Make web Request and store response"
  task :request => :environment do
    LEAGUE_YEARS.each do |year|
      query = { leagueId: LEAGUE_ID, seasonId: year }
      wr = WebResponse.find_or_initialize_by league_year: year
      if wr.persisted? && wr.updated_at.today?
        puts "We already updated #{wr.league_year} today"
        next
      end
      response = HTTParty.get 'http://games.espn.com/ffl/api/v2/leagueSettings', query: query
      next if response.code >= 400
      wr.external_league_id = response['metadata']['leagueId']
      wr.response_body = response.body
      wr.save!
    end
  end
end
