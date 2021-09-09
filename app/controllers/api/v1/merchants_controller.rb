class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:page].to_i <= 1
      render json: MerchantSerializer.new(Merchant.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: MerchantSerializer.new(Merchant.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    if find_params
      render json: MerchantSerializer.new(Merchant.find_first_by_name(params[:name]))
    else
      render status: :bad_request
    end
  end

  def most_items
    quantity = params[:quantity].to_i

    if params[:quantity]
      render json: MerchantSerializer.merchants_items_sold(Merchant.merchant_items_sold(quantity))
    else
      render status: :bad_request
    end
  end

  private

  def find_params
    params.require(:name)
  end
end
