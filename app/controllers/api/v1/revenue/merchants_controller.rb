class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if merchants_revenue_params
      quantity = params[:quantity].to_i
      render json: MerchantSerializer.merchant_name_revenue(Merchant.merchant_sorted_by_revenue(quantity))
    else
      render status: :bad_request
    end
  end

  def show
    render json: MerchantSerializer.merchant_revenue(Merchant.find(params[:id]))
  end

  private

  def merchants_revenue_params
    params.require(:quantity)
  end
end
