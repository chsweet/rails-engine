class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.paginate(page: params[:page], per_page: params[:per_page]))
  end
end
