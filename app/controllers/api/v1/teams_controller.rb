class Api::V1::TeamsController < Api::V1::BaseController
  def show
    @team = Team.find(params[:id])

    render json: TeamSerializer.new(@team).serialized_json, callback: params['callback']
  end
end
