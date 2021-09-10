class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity] && params[:quantity].empty? == false
      merchants = Merchant.merchant_sorted_by_revenue(params[:quantity])
      render json: MerchantSerializer.merchant_name_revenue(merchants)
    else
      render json: {error: ""}, status: :bad_request
    end
  end

  def show
    render json: MerchantSerializer.merchant_revenue(Merchant.find(params[:id]))
  end
end
