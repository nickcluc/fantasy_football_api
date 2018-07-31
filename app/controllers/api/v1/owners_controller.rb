class Api::V1::OwnersController < Api::V1::BaseController
  def index
    @owners = Owner.
      includes(:teams).
      includes(:team_matchups).
      includes(:championships).
      includes(:second_places).
      includes(:third_places).
      includes(:last_places)

    if params[:sort]
      if Owner.columns.include?(params[:sort])
        @owners = @owners.order(params[:sort])
      else
        if params[:dir].to_sym == :asc
          @owners.sort_by{|owner| owner.send(params[:sort].to_sym)}
        elsif params[:dir].to_sym == :desc
          @owners.sort_by{|owner| owner.send(params[:sort].to_sym)}.reverse
        end
      end
    end
    render json: OwnerSerializer.new(@owners).serialized_json, callback: params['callback']
  end
end
