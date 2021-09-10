class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    if params[:quantity] && params[:quantity] != 0 && params[:quantity].empty? == false
      render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(params[:quantity]))
    elsif params[:quantity].empty?
      render status: :bad_request
    else
      render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(10))
    end
  end
end
