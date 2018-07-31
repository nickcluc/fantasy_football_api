namespace :get_data do
  desc "Make web Request and store response"
  task :request => :environment do
    LEAGUE_YEARS.each do |year|
      query = { leagueId: LEAGUE_ID, seasonId: year, rand: rand(10 ** 13) }
      wr = WebResponse.find_or_initialize_by league_year: year
      if wr.persisted? && wr.updated_at.today?
        puts "We already updated #{wr.league_year} today"
        next
      end
      response = HTTParty.get 'http://games.espn.com/ffl/api/v2/leagueSettings', query: query
      #/ffl/api/v2/leagueSchedules?leagueId=445805&rand=0023623302299
      next if response.code >= 400
      wr.external_league_id = response['metadata']['leagueId']
      wr.response_body = response.body.force_encoding('iso8859-1').encode('utf-8')
      wr.save!
    end
  end
end
