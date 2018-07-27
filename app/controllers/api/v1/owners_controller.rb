class Api::V1::OwnersController < Api::V1::BaseController
  def index
    @owners = Owner.includes(:teams)
    if params[:sort]
      if Owner.columns.include?(params[:sort])
        @owners = @owners.order(params[:sort])
      else
        if params[:dir].to_sym == :asc
          @owners = Owner.all.sort_by{|owner| owner.send(params[:sort].to_sym)}
        elsif params[:dir].to_sym == :desc
          @owners = Owner.all.sort_by{|owner| owner.send(params[:sort].to_sym)}.reverse
        end
      end
    end
    render json: OwnerSerializer.new(@owners).serialized_json, callback: params['callback']
  end
end
