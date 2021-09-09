class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    # require "pry";binding.pry
    quantity = params[:quantity].to_i

    if params[:quantity] && quantity != 0
      render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(quantity))
    elsif !params[:quantity]
      render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(10))
    else
      render status: :bad_request
    end
  end

  private

  # def item_revenue_params
  #   params.require(:quantity)
  # end
end
