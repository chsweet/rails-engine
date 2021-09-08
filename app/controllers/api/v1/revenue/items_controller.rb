class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    require "pry";binding.pry
    quantity = params[:quantity].to_i
    render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(quantity))
  end

  private

  def item_revenue_params
  end
end
