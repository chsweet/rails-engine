class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    items = Item.where("merchant_id = ?", merchant.id)

    render json: ItemSerializer.new(items)
  end
end
