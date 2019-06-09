namespace :get_data do
  desc "Make web Request and store response"
  task :request => :environment do
    LEAGUE_YEARS.each do |year|
      uri_string = "http://fantasy.espn.com/apis/v3/games/ffl/seasons/#{year}/segments/0/leagues/#{LEAGUE_ID}" +
        "?view=mDraftDetail&view=mLiveScoring" +
        "&view=mMatchupScore&view=mPendingTransactions" +
        "&view=mPositionalRatings&view=mSettings" +
        "&view=mTeam&view=modular&view=mNav"

      response = HTTParty.get uri_string

      if response.content_type != "application/json"
        raise "Response from API not JSON"
      end

      wr = WebResponse.find_or_initialize_by league_year: year
      if wr.persisted? && wr.updated_at.today?
        puts "We already updated #{wr.league_year} today"
        next
      end
      #/ffl/api/v2/leagueSchedules?leagueId=445805&rand=0023623302299
      next if response.code >= 400
      wr.external_league_id = response['id']
      wr.response_body = response.body.force_encoding('iso8859-1').encode('utf-8')
      wr.save!
    end
  end

  desc "Get football player data and store response"
  task players: :environment do
    uri = "https://api.sleeper.app/v1/players/nfl"

    touched_today = PlayerResponse.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).
      or(PlayerResponse.where(updated_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).any?

    if touched_today
      puts "player info retrieved today"
      next
    end

    pr = PlayerResponse.first || PlayerResponse.new
    response = HTTParty.get uri

    pr.response_body = response.body
    pr.save!
  end
end
