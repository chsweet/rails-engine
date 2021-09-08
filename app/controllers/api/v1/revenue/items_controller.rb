class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    # require "pry";bindisng.pry
    # if item_revenue_params

    # quantity = params[:quantity].to_i
    render json: ItemSerializer.item_revenue(Item.items_sorted_by_revenue(10))
  end

  private

  def item_revenue_params
  end
end
