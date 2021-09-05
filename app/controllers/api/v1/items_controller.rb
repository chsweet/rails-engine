class Api::V1::ItemsController < ApplicationController
  def index
    if params[:page].to_i <= 1
      render json: ItemSerializer.new(Item.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: ItemSerializer.new(Item.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end
end
