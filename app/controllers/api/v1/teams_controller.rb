class Api::V1::TeamsController < Api::V1::BaseController
  def index
    if params[:filter]
      @teams = Team.find(params[:filter][:id].split(','))
    else
      @teams = Team.all
    end

    render json: TeamSerializer.new(@teams).serialized_json, callback: params['callback']
  end

  def show
    @team = Team.find([:id])
    render json: TeamSerializer.new(@team).serialized_json, callback: params['callback']
  end
end
