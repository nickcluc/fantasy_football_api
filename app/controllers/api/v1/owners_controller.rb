class Api::V1::OwnersController < Api::V1::BaseController
  def index
    render json: Owner.includes(:teams).sorted_by_average_regular_season_score, callback: params['callback']
  end
end
