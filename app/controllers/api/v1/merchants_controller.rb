class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:page].to_i <= 1
      render json: MerchantSerializer.new(Merchant.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: MerchantSerializer.new(Merchant.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def find
    merchant = Merchant.find_first_by_name(params[:name])

    if params[:name] && merchant.nil?
      render json: {data: {}}, status: :ok
    elsif params[:name] && params[:name].empty? == false
      render json: MerchantSerializer.new(merchant)
    else
      render status: :bad_request
    end
  end

  def most_items
    if params[:quantity]
      render json: MerchantSerializer.merchants_items_sold(Merchant.merchant_items_sold(params[:quantity]))
    else
      render json: {error: ""}, status: :bad_request
    end
  end
end
