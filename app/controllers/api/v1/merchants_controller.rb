class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:page].to_i < 1
      render json: MerchantSerializer.new(Merchant.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: MerchantSerializer.new(Merchant.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end
