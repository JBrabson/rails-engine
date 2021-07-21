class Api::V1::ItemsController < ApplicationController
  def index
    if (params[:per_page]).to_i >= 200
      items = Item.all
    else
      items = Item.pagination(params.fetch(:per_page, 20).to_i, params.fetch(:page, 1).to_i)
    end
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.create(item_params)
    render json: ItemSerializer.new(item)
  end


  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
