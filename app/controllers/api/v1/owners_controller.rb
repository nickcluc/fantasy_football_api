class Api::V1::OwnersController < Api::V1::BaseController
  def index
    @owners = Owner.includes(:teams).sorted_by_average_regular_season_score
    render json: @owners, callback: params['callback']
  end
end
