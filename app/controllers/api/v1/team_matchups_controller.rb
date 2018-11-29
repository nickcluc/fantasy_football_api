class Api::V1::TeamMatchupsController < Api::V1::BaseController
  def index
    if params[:filter]
      @team_matchups = TeamMatchup.where(id: params[:filter][:id].split(',')).order(season_id: :asc, week_number: :asc)
      if params[:filter][:regular_season]
        @team_matchups.keep_if{|mu| mu.regular_season == true}
      end
    else
      @team_matchups = TeamMatchup.all.order(season_id: :asc, week_number: :asc)
    end

    render json: TeamMatchupSerializer.new(@team_matchups).serialized_json, callback: params['callback']
  end
end
