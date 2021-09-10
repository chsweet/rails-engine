class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    if !params[:quantity]
      render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(10))
    elsif params[:quantity] != 0 && params[:quantity].empty? == false
      render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(params[:quantity]))
    else
      render status: :bad_request
    end
  end
end
