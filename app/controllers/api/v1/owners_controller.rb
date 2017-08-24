class Api::V1::OwnersController < Api::V1::BaseController
  def index
    @owners = Owner.includes(:teams)
    render json: @owners, callback: params['callback']
  end
end
