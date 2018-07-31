class Api::V1::TeamMatchupsController < Api::V1::BaseController
  def index
    if params[:filter]
      @team_matchups = TeamMatchup.find(params[:filter][:id].split(','))
    else
      @team_matchups = TeamMatchup.order(season_id: :asc, week_number: :asc).all
    end

    render json: TeamMatchupSerializer.new(@team_matchups).serialized_json, callback: params['callback']
  end
end
