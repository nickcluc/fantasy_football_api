class Api::V1::SeasonsController < Api::V1::BaseController
  def index
    if params[:filter]
      @seasons = Season.find(params[:filter][:id].split(','))
    else
      @seasons = Season.all
    end

    render json: SeasonSerializer.new(@seasons).serialized_json, callback: params['callback']
  end
end
