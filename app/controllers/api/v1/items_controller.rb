class Api::V1::ItemsController < ApplicationController
  def index
    if params[:page].to_i <= 1
      render json: ItemSerializer.new(Item.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: ItemSerializer.new(Item.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render status: :bad_request
    end
  end

  def update
    item = Item.find(params[:id])

    if params[:item][:merchant_id] && Merchant.exists?(:id => params[:item][:merchant_id]) == false
      render status: :not_found
    else
      item.update(item_params)

      render json: ItemSerializer.new(item)
    end
  end

  def destroy
    render json: Item.delete(params[:id]), status: :no_content
  end

  def find_all
    if params[:name] && params[:name].empty? == false
      render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
    elsif params[:min_price] && params[:min_price].empty? == false
      render json: ItemSerializer.new(Item.find_all_by_min_price(params[:min_price]))
    elsif params[:max_price] && params[:max_price].empty? == false
      render json: ItemSerializer.new(Item.find_all_by_max_price(params[:max_price]))
    else
      render status: :bad_request
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
